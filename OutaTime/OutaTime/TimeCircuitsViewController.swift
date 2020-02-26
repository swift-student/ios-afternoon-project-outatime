//
//  TimeCircuitsViewController.swift
//  OutaTime
//
//  Created by Shawn Gee on 2/25/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class TimeCircuitsViewController: UIViewController {
    //MARK: - IBOutlets
    
    typealias TimeLabels = (month: UILabel?, day: UILabel?, year: UILabel?, hour: UILabel?, minute: UILabel?)

    // Destination Time Outlets
    @IBOutlet weak var destinationMonthLabel: UILabel!
    @IBOutlet weak var destinationDayLabel: UILabel!
    @IBOutlet weak var destinationYearLabel: UILabel!
    @IBOutlet weak var destinationHourLabel: UILabel!
    @IBOutlet weak var destinationMinuteLabel: UILabel!
    
    lazy var destinationLabels = (
        destinationMonthLabel,
        destinationDayLabel,
        destinationYearLabel,
        destinationHourLabel,
        destinationMinuteLabel)
    
    // Present Time Outlets
    @IBOutlet weak var presentTimeMonthLabel: UILabel!
    @IBOutlet weak var presentTimeDayLabel: UILabel!
    @IBOutlet weak var presentTimeYearLabel: UILabel!
    @IBOutlet weak var presentTimeHourLabel: UILabel!
    @IBOutlet weak var presentTimeMinuteLabel: UILabel!
    
    lazy var presentLabels = (
        presentTimeMonthLabel,
        presentTimeDayLabel,
        presentTimeYearLabel,
        presentTimeHourLabel,
        presentTimeMinuteLabel)
    
    // Last Time Departed Outlets
    @IBOutlet weak var lastDepartedMonthLabel: UILabel!
    @IBOutlet weak var lastDepartedDayLabel: UILabel!
    @IBOutlet weak var lastDepartedYearLabel: UILabel!
    @IBOutlet weak var lastDepartedHourLabel: UILabel!
    @IBOutlet weak var lastDepartedMinuteLabel: UILabel!
    
    lazy var lastDepartedLabels = (
        lastDepartedMonthLabel,
        lastDepartedDayLabel,
        lastDepartedYearLabel,
        lastDepartedHourLabel,
        lastDepartedMinuteLabel)
    
    // Speed
    @IBOutlet weak var speedLabel: UILabel!
    
    
    //MARK: - IBActions
    
    @IBAction func travelBack(_ sender: UIButton) {
        startTimer()
    }
    
    
    //MARK: - Private Properties
    
    typealias MilesPerHour = Int
    
    private var currentSpeed: MilesPerHour = 0

    private var presentTime = Date() {
        didSet {
            update(presentLabels, withDate: presentTime)
        }
    }
    private var destinationTime = Date() {
        didSet {
            update(destinationLabels, withDate: destinationTime)
        }
    }
    private var lastDepartedTime = Date() {
        didSet {
            update(lastDepartedLabels, withDate: lastDepartedTime)
        }
    }
    
    private var speedIncrementor: Timer?
    
    
    //MARK: - Private Methods
    
    private func update(_ timeLabels: TimeLabels, withDate date: Date) {
        timeLabels.month?.text = date.month
        timeLabels.day?.text = date.day
        timeLabels.year?.text = date.year
        timeLabels.hour?.text = date.hour
        timeLabels.minute?.text = date.minute
    }
    
    private func setToEmpty(_ timeLabels: TimeLabels) {
        timeLabels.month?.text = "---"
        timeLabels.day?.text = "--"
        timeLabels.year?.text = "----"
        timeLabels.hour?.text = "--"
        timeLabels.minute?.text = "--"
    }
    
    private func startTimer() {
        speedIncrementor = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: updateSpeed(_:))
    }
    
    private func resetTimer() {
        speedIncrementor?.invalidate()
        speedIncrementor = nil
    }

    private func updateSpeed(_ timer: Timer) {
        if currentSpeed < 88 {
            currentSpeed += 1
            speedLabel.text = "\(currentSpeed) MPH"
        } else {
            lastDepartedTime = presentTime
            presentTime = destinationTime
            currentSpeed = 0
            resetTimer()
        }
    }
    
    private func setupViews() {
        presentTime = Date()
        setToEmpty(lastDepartedLabels)
        speedLabel.text = "\(currentSpeed) MPH"
    }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let datePickerVC = segue.destination as? DatePickerViewController {
            datePickerVC.delegate = self
        }
    }
}


//MARK: - DestinationDatePickerDelegate

extension TimeCircuitsViewController: DestinationDatePickerDelegate {
    func destinationWasChosen(_ date: Date) {
        destinationTime = date
    }
}


//MARK: - Date Extension

fileprivate extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y"
        return dateFormatter.string(from: self)
    }
    var hour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh"
        return dateFormatter.string(from: self)
    }
    var minute: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: self)
    }
}
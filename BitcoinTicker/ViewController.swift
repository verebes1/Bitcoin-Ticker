//
//  AppDelegate.swift
//  BitcoinTicker
//
//  Created by verebes on 23/01/2016.
//  Copyright © 2016 AD Progress. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        finalURL = baseURL + "AUD"
        getBitcoinPrice(url: finalURL)
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        //bitcoinPriceLabel.text = currencyArray[row]
        getBitcoinPrice(url: finalURL)
    }
    
    

    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    func getBitcoinPrice(url: String) {
        Alamofire.request(finalURL, method: .get, parameters: nil).responseJSON {
            response in
            if response.result.isSuccess {
                print("BITCOIN DATA RECEIVED!:")
                let bitcoinJSON: JSON = JSON(response.result.value!)
                print(bitcoinJSON)
                self.parseBitcoinInfoReceived(json: bitcoinJSON)
            } else {
                print("NO DATA RECEIVED")
                self.bitcoinPriceLabel.text = "Connection issues"
            }
        }
    }
    
    
        //MARK: - Parsing JSON
        /***************************************************************/
    func parseBitcoinInfoReceived(json: JSON) {
        let price = json["ask"].doubleValue
        let priceRounded = (price * 100).rounded() / 100
        bitcoinPriceLabel.text = "\(currencySymbols[currencyPicker.selectedRow(inComponent: 0)]) \(priceRounded)"
    }
    
    
    



}


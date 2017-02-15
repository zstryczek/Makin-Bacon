//
//  GameScene.swift
//  Lasso
//
//  Created by zstryczek on 9/20/16.
//  Copyright (c) 2016 zstryapps. All rights reserved.
//


/*
 1. What were your greatest strengths in creating this app?
    My greatest strength was having determination to finish the game and work through all the bugs that came up through the process.
 
 2. What are some weaknesses that you should work on for future projects similar to this?
    To try to consolidate code more and make it easier to follow and read
 
 3. What did you learn specifically about spriteKit from this project?
    That you need to create the entire scene programatically and if you try to create a node again before you remove it the app will crash.
 
 4. What were your major contributions to the app?
    Doing all of the coding and back end work
 
 5. What were your partner's major contributions to the app?
    All of the design
 
 6. How many hours did you honestly put into this project (we had roughly 12 in class hours)?
    about 30
 
 7. Where the videos helpful and what other ways would you prefer to learn about the content of spriteKit?
    I did not refrence any videos but having code to look at in stack overflow really helped
 
 8. Comment your app, explaining your steps through the process.
 
 */
import SpriteKit
import GameKit
import GoogleMobileAds
import UIKit

class GameScene: SKScene, GKGameCenterControllerDelegate, UIAlertViewDelegate {
    
    var interstitial: GADInterstitial!
    
    // Create all of the nodes and timers
    var timer = Timer()
    var timer2 = Timer()
    var cowBoy : SKSpriteNode!
    var pig : SKSpriteNode!
    var toss : SKSpriteNode!
    var poof : SKSpriteNode!
    var alien : SKSpriteNode!
    var background : SKSpriteNode!
    var newGameBackground : SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var recordLabel: SKLabelNode!
    var highScore = Int()
    var holdScreenToStart : SKLabelNode!
    var distanceFromCowBoy = CGFloat()
    var heightOfLoadBar = CGFloat()
    var loopLocation = CGFloat()
    var loopLocationDown = CGFloat()
    var loopDistanceToTravel = CGFloat()
    var startButton : SKNode! = nil
    var highScoreButton : SKNode! = nil
    var startButtonTapped = false
    var highScoreButtonTapped = false
    var bar = SKSpriteNode(texture: SKTexture(imageNamed: "loadBar"), size: CGSize(width: 600, height: 693))
    var barFill = SKSpriteNode(color: UIColor(red: 1.0, green: 0.34, blue: 0.34, alpha: 1.0), size: CGSize(width: 57.0, height: 0.0))
    var loop = SKSpriteNode(texture: SKTexture(imageNamed: "whipLoop0"), size: CGSize(width: 550, height: 200))
    var ropeHorizontal = SKSpriteNode(color: UIColor(red: 0.51, green: 0.40, blue: 0.33, alpha: 1.0), size: CGSize(width: 0.0, height: 5.0))
    var ropeVertical = SKSpriteNode(color: UIColor(red: 0.51, green: 0.40, blue: 0.33, alpha: 1.0), size: CGSize(width: 5.0, height: 0))
    
    
    // start game at score of 0
    var score = 0
        
    {
        didSet //Called immediatiley after a new value is stored it's a property observer
        {
            scoreLabel.text = "bacon: \(score)"
        }
    }

    // create new game screne
    override func didMove(to view: SKView) {
        
        createNewGameBackground()
        createBackground()
        background.run(SKAction.fadeOut(withDuration: 0.0))
        createRope()
        createScore()
        authPlayer()
        createAndLoadInterstitial()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.location(in: self)
            
            // check to see if tap was on top of "button" node
            
            if (startButtonTapped == true && self.contains(location))
            {
                timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(GameScene.animate), userInfo: nil, repeats: true)
                self.view?.isUserInteractionEnabled = false
            }
            
            // checks to see if start button was tapped and starts to play the game
            if (startButton.contains(location) && startButtonTapped == false)
            {

                startButton.removeFromParent()
                highScoreButton.removeFromParent()
                score = 0
                recordLabel.run(SKAction.fadeOut(withDuration: 1.0))
                createLoadBar()
                createCowBoy()
                getPigLocation()
                createInstructionLabel()
                background.run(SKAction.fadeIn(withDuration: 1.0))
                newGameBackground.run(SKAction.fadeOut(withDuration: 1.0))
                startButtonTapped = true
                let colorize = SKAction.colorize(with: UIColor.black, colorBlendFactor: 1.0, duration: 1.0)
                scoreLabel.run(colorize)
            }
            
            if highScoreButton.contains(location)
            {
                if(startButtonTapped == false)
                {
                    showLeaderBoard()
                    
                }
                
                if(startButtonTapped == true)
                {
                    
                }
            }
            
            
        }
        
        
    }
    
    // Runs the check score func at different heights depending how long the screen was held down
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (startButtonTapped == false)
        {
        self.view?.isUserInteractionEnabled = true
        }
        
        
        if (startButtonTapped == true)
        {
        self.view?.isUserInteractionEnabled = false
        }
        
        if(heightOfLoadBar == 0)
        {
            self.view?.isUserInteractionEnabled = true
            timer.invalidate()
        }
        if (heightOfLoadBar == 50)
        {
            animateLasso(distance: 1)
            
        }
        if (heightOfLoadBar == 100)
        {
            animateLasso(distance: 2)
        }
        if (heightOfLoadBar == 150)
        {
            animateLasso(distance: 3)
        }
        if (heightOfLoadBar == 200)
        {
            animateLasso(distance: 4)
        }
        if (heightOfLoadBar == 250)
        {
            animateLasso(distance: 5)
        }
        if (heightOfLoadBar == 300)
        {
            animateLasso(distance: 6)
        }
        if (heightOfLoadBar == 350)
        {
            animateLasso(distance: 7)
        }
        if (heightOfLoadBar == 400)
        {
            animateLasso(distance: 8)
        }
        if (heightOfLoadBar == 450)
        {
            animateLasso(distance: 9)
        }
        if (heightOfLoadBar >= 500)
        {
            animateLasso(distance: 10)
        }
        heightOfLoadBar = 0
        barFill.size.height = heightOfLoadBar
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    /// Ad Mob stuff 
    
    private func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6036964001864201/1262275170")
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        interstitial.load(request)
    }
    
    func showInterstitial()
    {
        if (self.interstitial.isReady) {
            interstitial.present(fromRootViewController: (self.view?.window?.rootViewController!)!)
        }
    }
    
    
    // Ad Mob stuff done
    
    
    /// GAME CENTER STUFF START
    
    func authPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view != nil {
                
                self.view?.window?.rootViewController!.present(view!, animated: true, completion:nil)
                
            }
            else {
                
                print(GKLocalPlayer.localPlayer().isAuthenticated)
                
            }
            
            
        }
    }
    
    func showLeaderBoard(){
        let viewController = self.view?.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        
        gcvc.gameCenterDelegate = self
        
        viewController?.present(gcvc, animated: true, completion: nil)
    }
    
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
    }

    
    ///// GAME CENTER STUFF DONE
    
    
    
    
    // creates day background
    func createBackground()
    {
        let backgroundTexture = SKTexture(imageNamed: "sprite_0-2") //Sets texture to node
        backgroundTexture.filteringMode = SKTextureFilteringMode.nearest
        background = SKSpriteNode(texture: backgroundTexture) //Sets texture to sprite node
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1 //Staking order
        background.position = CGPoint(x: frame.midX, y: frame.midY) //Location on the view
        background.size = CGSize(width: frame.width, height: frame.height * 0.8)
        
        addChild(background) //Add to scene

    }
    
    // Creates the background and the buttons for the new game
    func createNewGameBackground()
    {
        createRecord()
        
        let newGameBackgroundTexture = SKTexture(imageNamed: "sprite_1 copy") //Sets texture to node
        newGameBackgroundTexture.filteringMode = SKTextureFilteringMode.nearest
        newGameBackground = SKSpriteNode(texture: newGameBackgroundTexture) //Sets texture to sprite node
        newGameBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        newGameBackground.zPosition = -1 //Staking order
        newGameBackground.position = CGPoint(x: frame.midX, y: frame.midY) //Location on the view
        newGameBackground.size = CGSize(width: frame.width, height: frame.height * 0.8)
        
        addChild(newGameBackground) //Add to scene
        
        startButton = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 140, height: 80))
        startButton.position = CGPoint(x: frame.width * 0.43, y: frame.height * 0.27)
        startButton.zPosition = 3
        
        addChild(startButton)
        
        highScoreButton = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 140, height: 80))
        highScoreButton.position = CGPoint(x: frame.width * 0.603, y: frame.height * 0.27)
        highScoreButton.zPosition = 3
        
        addChild(highScoreButton)
        
        recordLabel.text = ("Record: \(DisplayHighScore())")
        

        
    }

    // Creates cowboy and starts his animation
    func createCowBoy()
    {
        let cowBoyTexture = SKTexture(imageNamed: "sprite_0") //Sets texture to node
        cowBoyTexture.filteringMode = SKTextureFilteringMode.nearest
        cowBoy = SKSpriteNode(texture: cowBoyTexture) //Sets texture to sprite node
        cowBoy.anchorPoint = CGPoint(x: 0, y: 0)
        cowBoy.zPosition = 2 //Staking order
        cowBoy.position = CGPoint(x: frame.width * 0.01, y: frame.height * 0.15) //Location on the view
        cowBoy.size = CGSize(width: 150, height: 200)
        
        addChild(cowBoy) //Add to scene
        

        let frame2 = SKTexture(imageNamed: "sprite_1") // Additional textures for animation
        frame2.filteringMode = SKTextureFilteringMode.nearest

        let animation = SKAction.animate(with: [cowBoyTexture, frame2, cowBoyTexture], timePerFrame: 0.08) //Set textures for animation and time frame
        let runForever = SKAction.repeatForever(animation) //Sets the animation to loop forever
        cowBoy.run(runForever) //Runs the action on the node
    }
    
    // Creates the score label
    func createScore()
    {
        scoreLabel = SKLabelNode(fontNamed: "pixel")
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: frame.width * 0.1, y: frame.maxY * 0.83)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.zPosition = 5
        scoreLabel.text = "bacon: 0"
        scoreLabel.fontColor = UIColor.white
        
        addChild(scoreLabel)
        
    }
    // Creates the score label
    func createRecord()
    {
        recordLabel = SKLabelNode(fontNamed: "pixel")
        recordLabel.fontSize = 50
        recordLabel.position = CGPoint(x: frame.width * 0.5, y: frame.maxY * 0.80)
        recordLabel.horizontalAlignmentMode = .center
        recordLabel.verticalAlignmentMode = .center
        recordLabel.zPosition = 5
        recordLabel.text = "Record: 0"
        recordLabel.fontColor = UIColor(red: 1.0, green: 106/255, blue: 7/255, alpha: 1.0)
        recordLabel.alpha = 0.0
        
        addChild(recordLabel)
        
        recordLabel.run(SKAction.fadeIn(withDuration: 1.0))
        
        
    }
    
    // Creates the instruction label
    func createInstructionLabel()
    {
        holdScreenToStart = SKLabelNode(fontNamed: "pixel")
        holdScreenToStart.fontSize = 30
        holdScreenToStart.position = CGPoint(x: frame.midX, y: frame.height * 0.8)
        holdScreenToStart.horizontalAlignmentMode = .center
        holdScreenToStart.verticalAlignmentMode = .center
        holdScreenToStart.zPosition = 5
        holdScreenToStart.text = "HOLD SCREEN TO LASSO"
        holdScreenToStart.fontColor = UIColor.black
        holdScreenToStart.alpha = 0.0
        
        addChild(holdScreenToStart)

        holdScreenToStart.run(SKAction.fadeIn(withDuration: 1.0))
    }

    
    func DisplayHighScore() -> Int {
        UserDefaults.standard.integer(forKey: "highscore")
        
        //Check if score is higher than NSUserDefaults stored value and change NSUserDefaults stored value if it's true
        if score > UserDefaults.standard.integer(forKey: "highscore") {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highscore")
            UserDefaults.standard.synchronize()
            
        }
        
        return UserDefaults.standard.integer(forKey: "highscore")
    }

    
    

    // Animates the cowboy to look like he throws the lasso
    func throwLasso()
    {
        let tossTexture = SKTexture(imageNamed: "whippedboy1") //Sets texture to node
        tossTexture.filteringMode = SKTextureFilteringMode.nearest
        toss = SKSpriteNode(texture: tossTexture) //Sets texture to sprite node
        toss.anchorPoint = CGPoint(x: 0, y: 0)
        toss.zPosition = 2 //Staking order
        toss.position = CGPoint(x: frame.width * 0.01, y: frame.height * 0.15) //Location on the view
        toss.size = CGSize(width: 150, height: 200)
        
        addChild(toss) //Add to scene
        
        let animation = SKAction.animate(with: [tossTexture], timePerFrame: 0.5) //Set textures for animation and time frame

        toss.run(animation) //Runs the action on the node
    }
    
    // Animates the lasso and brings it to the positioon of the pig
    func animateLasso(distance: Int)
    {
        holdScreenToStart.run(SKAction.fadeOut(withDuration: 1.0))
        timer.invalidate()

        loopLocation = 0
        loopLocationDown = 0
        loop.position = CGPoint(x: frame.width * 0.27, y: frame.height * 0.28)
        loop.zPosition = 3
        addChild(loop)
        
        cowBoy.removeFromParent()
        throwLasso()
        ropeVertical.size.height = 65.0

        
        timer2 = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameScene.moveLoop), userInfo: nil, repeats: true)
        
        if (distance == 1)
        {
            loopDistanceToTravel = 70
        }
        if (distance == 2)
        {
            loopDistanceToTravel = 140
        }
        if (distance == 3)
        {
            loopDistanceToTravel = 210
        }
        if (distance == 4)
        {
            loopDistanceToTravel = 280
        }
        if (distance == 5)
        {
            loopDistanceToTravel = 350
        }
        if (distance == 6)
        {
            loopDistanceToTravel = 420
        }
        if (distance == 7)
        {
            loopDistanceToTravel = 490
        }
        if (distance == 8)
        {
            loopDistanceToTravel = 560
        }
        if (distance == 9)
        {
            loopDistanceToTravel = 630
        }
        if (distance == 10)
        {
            loopDistanceToTravel = 700
        }
    }
    
    // Gets a random location for the pig and sets it to that location
    func getPigLocation()
    {
        let randomNum = Int(arc4random_uniform(10))
 
        if (randomNum == 0)
        {
            distanceFromCowBoy = 70
        }
        if (randomNum == 1)
        {
            distanceFromCowBoy = 140
        }
        if (randomNum == 2)
        {
            distanceFromCowBoy = 210
        }
        if (randomNum == 3)
        {
            distanceFromCowBoy = 280
        }
        if (randomNum == 4)
        {
            distanceFromCowBoy = 350
        }
        if (randomNum == 5)
        {
            distanceFromCowBoy = 420
        }
        if (randomNum == 6)
        {
            distanceFromCowBoy = 490
        }
        if (randomNum == 7)
        {
            distanceFromCowBoy = 560
        }
        if (randomNum == 8)
        {
            distanceFromCowBoy = 630
        }
        if (randomNum == 9)
        {
            distanceFromCowBoy = 700
        }
        createPig()
    }
    
    // Creates the pig
    func createPig()
    {
        let pigTexture = SKTexture(imageNamed: "sprite_0-1") //Sets texture to node
        pigTexture.filteringMode = SKTextureFilteringMode.nearest
        pig = SKSpriteNode(texture: pigTexture) //Sets texture to sprite node
        pig.anchorPoint = CGPoint(x: 0, y: 0)
        pig.zPosition = 2 //Staking order
        pig.position = CGPoint(x: cowBoy.frame.midX + distanceFromCowBoy, y: frame.height * 0.06) //Location on the view
        pig.size = CGSize(width: 150, height: 200)
        
        addChild(pig) //Add to scene
        
        
        let frame2 = SKTexture(imageNamed: "sprite_1-1") // Additional textures for animation
        frame2.filteringMode = SKTextureFilteringMode.nearest
        
        let animation = SKAction.animate(with: [pigTexture, frame2, pigTexture], timePerFrame: 0.5) //Set textures for animation and time frame
        let runForever = SKAction.repeatForever(animation) //Sets the animation to loop forever
        pig.run(runForever) //Runs the action on the node
    }
    
    // If caught animates the pig to bacon
    func poofToBacon()
    {
        let poofTexture = SKTexture(imageNamed: "porkcaught0") //Sets texture to node
        poofTexture.filteringMode = SKTextureFilteringMode.nearest
        poof = SKSpriteNode(texture: poofTexture) //Sets texture to sprite node
        poof.anchorPoint = CGPoint(x: 0, y: 0)
        poof.zPosition = 2 //Staking order
        poof.position = CGPoint(x: cowBoy.frame.midX + distanceFromCowBoy, y: frame.height * 0.06) //Location on the view
        poof.size = CGSize(width: 150, height: 200)
        
        addChild(poof) //Add to scene
        
        
        let frame1 = SKTexture(imageNamed: "porkcaught1") // Additional textures for animation
        frame1.filteringMode = SKTextureFilteringMode.nearest
        
        let frame2 = SKTexture(imageNamed: "porkcaught2") // Additional textures for animation
        frame2.filteringMode = SKTextureFilteringMode.nearest
        
        let frame3 = SKTexture(imageNamed: "porkcaught3") // Additional textures for animation
        frame3.filteringMode = SKTextureFilteringMode.nearest
        
        let frame4 = SKTexture(imageNamed: "porkcaught4") // Additional textures for animation
        frame4.filteringMode = SKTextureFilteringMode.nearest
        
        let frame5 = SKTexture(imageNamed: "porkcaught5") // Additional textures for animation
        frame5.filteringMode = SKTextureFilteringMode.nearest
        
        let frame6 = SKTexture(imageNamed: "porkcaught6") // Additional textures for animation
        frame6.filteringMode = SKTextureFilteringMode.nearest
        
        
        let animation = SKAction.animate(with: [poofTexture, frame1, frame2, frame3, frame4, frame5, frame6], timePerFrame: 0.125) //Set textures for animation and time frame
        poof.run(animation) //Runs the action on the node
        poof.run(animation, completion: {finished in self.poof.run(SKAction.fadeOut(withDuration: 1.0), completion: {finished in self.poof.removeFromParent()})})
        
        getPigLocation()
    }
    
    // Creates location for the laod bar and adds it to view
    func createLoadBar()
    {
        bar.alpha = 1.0
        bar.anchorPoint = CGPoint(x: 0, y: 0)
        bar.position = CGPoint(x: frame.width - 318, y: frame.height * 0.07 - 2)
        bar.zPosition = 1
        
        addChild(bar)
        
        barFill.alpha = 1.0
        barFill.anchorPoint = CGPoint(x: 0, y: 0)
        barFill.position = CGPoint(x: frame.width - 75, y: frame.height * 0.179)
        barFill.zPosition = 2
        
        addChild(barFill)
        
        
    }
    // Creates rope
    func createRope()
    {
        ropeHorizontal.alpha = 1.0
        ropeHorizontal.anchorPoint = CGPoint(x: 0, y: ropeHorizontal.frame.midY)
        ropeHorizontal.position = CGPoint(x: frame.width * 0.138, y: frame.height * 0.3)
        ropeHorizontal.zPosition = 3
        
        addChild(ropeHorizontal)
        
        ropeVertical.alpha = 1.0
        ropeVertical.anchorPoint = CGPoint(x: ropeVertical.frame.midX, y: 0)
        ropeVertical.position = CGPoint(x: frame.width * 0.138, y: frame.height * 0.306)
        ropeVertical.zPosition = 3
        
        addChild(ropeVertical)
    }

    
    // Makes load bar grow when called by timer
    func animate()
    {
        heightOfLoadBar += 50
        barFill.size.height = heightOfLoadBar
        
        if(barFill.size.height > 500)
        {
            barFill.size.height = 50
            heightOfLoadBar = 50
        }
    }
    
    // moves the loop over then down on top of pig
    func moveLoop()
    {
        loopLocation += 10
        loop.alpha = 1.0
        loop.position = CGPoint(x: frame.width * 0.27 + loopLocation, y: frame.height * 0.28)
        ropeHorizontal.size.width = loopLocation - 35
        ropeVertical.position.x = loopLocation + 105
        
        if(loopLocation >= loopDistanceToTravel)
        {
            loopLocationDown += 10
            loop.position = CGPoint(x: frame.width * 0.27 + loopDistanceToTravel, y: frame.height * 0.28 - loopLocationDown)
            ropeHorizontal.size.width = loopDistanceToTravel - 35
            ropeVertical.position.x = loopDistanceToTravel + 105
            ropeVertical.size.height -= 10
            
            if(loop.position.y <= frame.height * 0.28 - 100)
            {
                loop.position = CGPoint(x: frame.width * 0.27 + loopDistanceToTravel, y: frame.height * 0.28 - 100)
                ropeVertical.position.x = loopDistanceToTravel + 105
                ropeVertical.size.height = -40
                checkThrow(distance: loopDistanceToTravel)
                timer2.invalidate()
            }
            
        }

    }
    // makes pig fly away once ryan makes images
    func pigAbduction()
    {
        
        let alienTexture = SKTexture(imageNamed: "Aliensprite_00") //Sets texture to node
        alienTexture.filteringMode = SKTextureFilteringMode.nearest
        alien = SKSpriteNode(texture: alienTexture) //Sets texture to sprite node
        alien.anchorPoint = CGPoint(x: 0, y: 0)
        alien.zPosition = 2 //Staking order
        alien.position = CGPoint(x: cowBoy.frame.midX + distanceFromCowBoy, y: frame.height * 0.157) //Location on the view
        alien.size = CGSize(width: 150, height: self.frame.height * 0.69)
        
        addChild(alien) //Add to scene
        
        
        let frame1 = SKTexture(imageNamed: "Aliensprite_01") // Additional textures for animation
        frame1.filteringMode = SKTextureFilteringMode.nearest
        
        let frame2 = SKTexture(imageNamed: "Aliensprite_02") // Additional textures for animation
        frame2.filteringMode = SKTextureFilteringMode.nearest
        
        let frame3 = SKTexture(imageNamed: "Aliensprite_03") // Additional textures for animation
        frame3.filteringMode = SKTextureFilteringMode.nearest
        
        let frame4 = SKTexture(imageNamed: "Aliensprite_04") // Additional textures for animation
        frame4.filteringMode = SKTextureFilteringMode.nearest
        
        let frame5 = SKTexture(imageNamed: "Aliensprite_05") // Additional textures for animation
        frame5.filteringMode = SKTextureFilteringMode.nearest
        
        let frame6 = SKTexture(imageNamed: "Aliensprite_06") // Additional textures for animation
        frame6.filteringMode = SKTextureFilteringMode.nearest
        
        let frame7 = SKTexture(imageNamed: "Aliensprite_07") // Additional textures for animation
        frame6.filteringMode = SKTextureFilteringMode.nearest

        let frame8 = SKTexture(imageNamed: "Aliensprite_08") // Additional textures for animation
        frame6.filteringMode = SKTextureFilteringMode.nearest

        let frame9 = SKTexture(imageNamed: "Aliensprite_09") // Additional textures for animation
        frame6.filteringMode = SKTextureFilteringMode.nearest

        let frame10 = SKTexture(imageNamed: "Aliensprite_10") // Additional textures for animation
        frame6.filteringMode = SKTextureFilteringMode.nearest

        let frame11 = SKTexture(imageNamed: "Aliensprite_11") // Additional textures for animation
        frame6.filteringMode = SKTextureFilteringMode.nearest

        let frame12 = SKTexture(imageNamed: "Aliensprite_12") // Additional textures for animation
        frame6.filteringMode = SKTextureFilteringMode.nearest
        
        let frame13 = SKTexture(imageNamed: "Aliensprite_13") // Additional textures for animation
        frame6.filteringMode = SKTextureFilteringMode.nearest


        
        
        let animation = SKAction.animate(with: [alienTexture, frame1, frame2, frame3, frame4, frame5, frame6, frame7, frame8, frame9, frame10, frame11, frame12, frame13], timePerFrame: 0.125) //Set textures for animation and time frame
        alien.run(animation) //Runs the action on the node
        alien.run(animation, completion: {finished in
            
            self.alien.removeFromParent()
            self.startButtonTapped = false
            self.startButton.isUserInteractionEnabled = true
            self.highScoreButton.isUserInteractionEnabled = true
            self.createNewGameBackground()
            self.newGameBackground.alpha = 0.0
            self.background.run(SKAction.fadeOut(withDuration: 1.0))
            self.newGameBackground.run(SKAction.fadeIn(withDuration: 1.0), completion: {finished in self.view?.isUserInteractionEnabled = true})
            self.ropeVertical.run(SKAction.fadeOut(withDuration: 1.0), completion: {finished in
                self.ropeVertical.size.height = 0.0
                self.ropeVertical.alpha = 1.0
            })
            
            self.ropeHorizontal.run(SKAction.fadeOut(withDuration: 1.0), completion: {finished in
                self.ropeHorizontal.size.width = 0.0
                self.ropeHorizontal.alpha = 1.0
            })

            
            let duration = 1.0
            self.scoreLabel.run(SKAction.colorize(with: UIColor.white, colorBlendFactor: 1.0, duration: 1.0))
            self.bar.run(SKAction.fadeOut(withDuration: duration), completion: {finished in self.bar.removeFromParent()})
            self.barFill.run(SKAction.fadeOut(withDuration: duration), completion: {finished in self.barFill.removeFromParent()})
            self.toss.run(SKAction.fadeOut(withDuration: duration), completion: {finished in self.toss.removeFromParent()})
            self.loop.run(SKAction.fadeOut(withDuration: duration), completion: {finished in self.loop.removeFromParent()})
            self.cowBoy.run(SKAction.fadeOut(withDuration: duration), completion: {finished in self.cowBoy.removeFromParent()})
            self.loop.run(SKAction.fadeOut(withDuration: duration), completion: {finished in
                self.loop.removeFromParent()
                
                let randomAdNum = arc4random_uniform(3)
                
                if (randomAdNum == 1)
                {
                self.showInterstitial()
                self.createAndLoadInterstitial()
                }
            })
        })
    }
    
    // Check to see if the throw was correct or not and resets if incorrect
    func checkThrow(distance: CGFloat)
    {
        if(distance == loopDistanceToTravel && distanceFromCowBoy == loopDistanceToTravel)
        {
            createCowBoy()
            toss.removeFromParent()
            loop.removeFromParent()
            pig.removeFromParent()
            poofToBacon()
            ropeHorizontal.size.width = 0.0
            ropeVertical.size.height = 0.0
            score += 1
            self.view?.isUserInteractionEnabled = true
        }
            
        else
        {
            self.recordLabel.removeFromParent()
            pig.removeFromParent()
            
            pigAbduction()
            
            if GKLocalPlayer.localPlayer().isAuthenticated {
                
                let scoreReporter = GKScore(leaderboardIdentifier: "MakinB")
                
                scoreReporter.value = Int64(UserDefaults.standard.integer(forKey: "highscore")
                )
                
                let scoreArray : [GKScore] = [scoreReporter]
                
                GKScore.report(scoreArray, withCompletionHandler: nil)
            }


        }
    }
    
}

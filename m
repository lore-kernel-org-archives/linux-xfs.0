Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jul 2008 14:51:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6HLpng0029889
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 14:51:50 -0700
Received: from rsbne02.RSBNE.LOCAL (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FF49E5396A
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 14:52:56 -0700 (PDT)
Received: from rsbne02.RSBNE.LOCAL (robert87.lnk.telstra.net [203.45.17.90]) by cuda.sgi.com with ESMTP id sRsQCCJk2ypeaA8Y for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 14:52:56 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Power loss causes bad magic number??
Date: Fri, 18 Jul 2008 07:52:43 +1000
Message-ID: <F46A887185FC6044A7FAC577E31118AE02231846@rsbne01.RSBNE.LOCAL>
In-Reply-To: <487F4AC5.3000806@thebarn.com>
References: <F46A887185FC6044A7FAC577E31118AE022316C0@rsbne01.RSBNE.LOCAL> <487D5F80.1050909@sandeen.net> <F46A887185FC6044A7FAC577E31118AE021E0623@rsbne01.RSBNE.LOCAL> <20080716073503.GE29319@disturbed> <F46A887185FC6044A7FAC577E31118AE021E0625@rsbne01.RSBNE.LOCAL> <487F4AC5.3000806@thebarn.com>
From: "Stephen Porter" <stephenp@r-s.com.au>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com


-----Original Message-----
From: Russell Cattelan [mailto:cattelan@thebarn.com] 
Sent: Thursday, 17 July 2008 11:36 PM
To: Stephen Porter
Cc: xfs@oss.sgi.com
Subject: Re: Power loss causes bad magic number??
   
> Heh welcome to the world of linux's poor device name handling.

Hehe, gee thanks! :)

> Did you make some sort of change to the hardware? added drives, moved 
> cards around, etc?
> Anything that changes the order that drives are discovered will affect

> the sd[a-...] naming.

No changes were made to the hardware, though as I mentioned originally I
did loose power twice within a few hours, and it was the 2nd time the
issue appeared.

Having said that, after "fixing" the issue (updating the fstab entry) I
have since installed a few updates, and it broke again (remapped back to
sdc). :/

> Mount by label or mount by uuid may be your friend in this case.
  
I think this is going to be my only option (unless I want to keep
updating fstab entries each time _something_ updates on the box).  Time
to visit google again.  I realise this is now way off topic, but is
there a "preferred method" with regards to mounting by labels or uuid?


Thanks.

Stephen.

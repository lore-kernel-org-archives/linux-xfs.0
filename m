Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 Jul 2008 10:34:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m65HYbi2018770
	for <xfs@oss.sgi.com>; Sat, 5 Jul 2008 10:34:37 -0700
Received: from wr-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D575F12DCA02
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2008 10:35:41 -0700 (PDT)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.227]) by cuda.sgi.com with ESMTP id jUp8tCEPaaxI5R37 for <xfs@oss.sgi.com>; Sat, 05 Jul 2008 10:35:41 -0700 (PDT)
Received: by wr-out-0506.google.com with SMTP id 57so1130389wri.12
        for <xfs@oss.sgi.com>; Sat, 05 Jul 2008 10:35:41 -0700 (PDT)
Message-ID: <cccedfc60807051035n943a669q61c01f6f1c05d6fa@mail.gmail.com>
Date: Sat, 5 Jul 2008 12:35:41 -0500
From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>

Try booting with:

nolapic

That largely fixed my problems on my motherboard (2.6.18+, EPoX MF-570SLI).
I hope to try 2.6.25+ soon.
-- 
Jon

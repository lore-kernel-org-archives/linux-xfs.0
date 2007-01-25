Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 16:34:37 -0800 (PST)
Received: from amd.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0P0Y8qw031723
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 16:34:29 -0800
Date: Thu, 25 Jan 2007 01:32:42 +0100
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like 2.16.19.2
Message-ID: <20070125003242.GA23343@elf.ucw.cz>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan> <20070122133735.GB4493@ucw.cz> <Pine.LNX.4.64.0701221348020.11525@p34.internal.lan> <Pine.LNX.4.64.0701241837550.2930@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701241837550.2930@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Hi!

> > Is it highmem-related? Can you try it with mem=256M?
> 
> Bad idea, the kernel crashes & burns when I use mem=256, I had to boot 
> 2.6.20-rc5-6 single to get back into my machine, very nasty.  Remember I 
> use an onboard graphics controller that has 128MB of RAM allocated to it 
> and I believe the ICH8 chipset also uses some memory, in any event mem=256 
> causes the machine to lockup before it can even get to the boot/init 
> processes, the two leds on the keyboard were blinking, caps lock and 
> scroll lock and I saw no console at all!

Okay, so try mem=700M or disable CONFIG_HIGHMEM or something.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

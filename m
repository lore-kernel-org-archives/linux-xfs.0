Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 16:37:17 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0P0b7qw032726
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 16:37:09 -0800
Date: Wed, 24 Jan 2007 19:36:13 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
In-Reply-To: <20070125003242.GA23343@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0701241936020.4028@p34.internal.lan>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
 <20070122133735.GB4493@ucw.cz> <Pine.LNX.4.64.0701221348020.11525@p34.internal.lan>
 <Pine.LNX.4.64.0701241837550.2930@p34.internal.lan> <20070125003242.GA23343@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Thu, 25 Jan 2007, Pavel Machek wrote:

> Hi!
> 
> > > Is it highmem-related? Can you try it with mem=256M?
> > 
> > Bad idea, the kernel crashes & burns when I use mem=256, I had to boot 
> > 2.6.20-rc5-6 single to get back into my machine, very nasty.  Remember I 
> > use an onboard graphics controller that has 128MB of RAM allocated to it 
> > and I believe the ICH8 chipset also uses some memory, in any event mem=256 
> > causes the machine to lockup before it can even get to the boot/init 
> > processes, the two leds on the keyboard were blinking, caps lock and 
> > scroll lock and I saw no console at all!
> 
> Okay, so try mem=700M or disable CONFIG_HIGHMEM or something.
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Ok, this will be my last test for tonight, trying now.

Justin.

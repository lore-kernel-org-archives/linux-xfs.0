Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 15:40:08 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0ONe1qw014102
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 15:40:01 -0800
Date: Wed, 24 Jan 2007 18:39:07 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
In-Reply-To: <Pine.LNX.4.64.0701221348020.11525@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0701241837550.2930@p34.internal.lan>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
 <20070122133735.GB4493@ucw.cz> <Pine.LNX.4.64.0701221348020.11525@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

> Is it highmem-related? Can you try it with mem=256M?

Bad idea, the kernel crashes & burns when I use mem=256, I had to boot 
2.6.20-rc5-6 single to get back into my machine, very nasty.  Remember I 
use an onboard graphics controller that has 128MB of RAM allocated to it 
and I believe the ICH8 chipset also uses some memory, in any event mem=256 
causes the machine to lockup before it can even get to the boot/init 
processes, the two leds on the keyboard were blinking, caps lock and 
scroll lock and I saw no console at all!

Justin.

On Mon, 22 Jan 2007, Justin Piszcz wrote:

> 
> 
> On Mon, 22 Jan 2007, Pavel Machek wrote:
> 
> > On Sun 2007-01-21 14:27:34, Justin Piszcz wrote:
> > > Why does copying an 18GB on a 74GB raptor raid1 cause the kernel to invoke 
> > > the OOM killer and kill all of my processes?
> > > 
> > > Doing this on a single disk 2.6.19.2 is OK, no issues.  However, this 
> > > happens every time!
> > > 
> > > Anything to try?  Any other output needed?  Can someone shed some light on 
> > > this situation?
> > 
> > Is it highmem-related? Can you try it with mem=256M?
> > 
> > 							Pavel
> > -- 
> > (english) http://www.livejournal.com/~pavelmachek
> > (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> I will give this a try later or tomorrow, I cannot have my machine crash 
> at the moment.
> 
> Also, the onboard video on the Intel 965 chipset uses 128MB, not sure if 
> that has anything to do with it because after the system kill -9's all the 
> processes etc, my terminal looks like garbage.
> 
> Justin.
> 
> 

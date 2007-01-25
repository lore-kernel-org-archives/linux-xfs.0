Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Jan 2007 01:10:33 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0P99Uqw017438
	for <xfs@oss.sgi.com>; Thu, 25 Jan 2007 01:09:31 -0800
Date: Thu, 25 Jan 2007 04:08:36 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
In-Reply-To: <20070125003242.GA23343@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0701250407590.3673@p34.internal.lan>
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

I forgot to remove the mem=700M with PREEMPT off and this is what I saw 
this morning:

[18005.261875] Killed process 4768 (screen)
[18005.262343] Out of memory: kill process 4793 (screen) score 385 or a 
child
[18005.262350] Killed process 4793 (screen)
[18005.378536] Out of memory: kill process 4825 (screen) score 385 or a 
child
[18005.378542] Killed process 4825 (screen)
[18005.378547] Out of memory: kill process 4825 (screen) score 385 or a 
child
[18005.378553] Killed process 4825 (screen)
[18005.413072] Out of memory: kill process 4875 (screen) score 385 or a 
child
[18005.413079] Killed process 4875 (screen)
[18005.423735] Out of memory: kill process 4970 (screen) score 385 or a 
child
[18005.423742] Killed process 4970 (screen)
[18005.431391] Out of memory: kill process 21365 (xfs_fsr) score 286 or a 
child
[18005.431398] Killed process 21365 (xfs_fsr)
 
$ screen -ls
  There are screens on:
        2532.pts-0.p34  (Dead ???)
        3776.pts-2.p34  (Dead ???)
        4768.pts-7.p34  (Dead ???)
        4793.pts-9.p34  (Dead ???)
        4825.pts-11.p34 (Dead ???)
        4875.pts-13.p34 (Dead ???)
        4970.pts-15.p34 (Dead ???)
 

Lovely...

$ uname -r
2.6.20-rc5

Something is seriously wrong with that OOM killer.

Justin.

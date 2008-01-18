Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jan 2008 07:39:36 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0IFdUIT022363
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 07:39:33 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D21B9535365
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 07:39:49 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id Bt2Eh1jmL8g8tjeK for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 07:39:49 -0800 (PST)
Date: Fri, 18 Jan 2008 10:39:16 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux Software RAID 5 + XFS Multi-Benchmarks / 10 Raptors
 Again
In-Reply-To: <29a863790801180735n379a27f1t4987686b2ec1aa50@mail.gmail.com>
Message-ID: <alpine.DEB.0.999999.0801181036260.23565@p34.internal.lan>
References: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan> <29a863790801180735n379a27f1t4987686b2ec1aa50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Greg Cormier <gcormier@gmail.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>



On Fri, 18 Jan 2008, Greg Cormier wrote:

> Justin, thanks for the script. Here's my results. I ran it a few times
> with different tests, hence the small number of results you see here,
> I slowly trimmed out the obvious not-ideal sizes.
Nice, we all love benchmarks!! :)

>
> System
> ---
> Athlon64 3500
> 2GB RAM
> 4x500GB WD Raid editions, raid 5. SDE is the old 4-platter version
> (5000YS), the others are the 3 platter version. Faster :-)
Ok.

>
> /dev/sdb:
> Timing buffered disk reads:  240 MB in  3.00 seconds =  79.91 MB/sec
> /dev/sdc:
> Timing buffered disk reads:  248 MB in  3.01 seconds =  82.36 MB/sec
> /dev/sdd:
> Timing buffered disk reads:  248 MB in  3.02 seconds =  82.22 MB/sec
> /dev/sde:  (older model, 4 platters instead of 3)
> Timing buffered disk reads:  210 MB in  3.01 seconds =  69.87 MB/sec
> /dev/md3:
> Timing buffered disk reads:  628 MB in  3.00 seconds = 209.09 MB/sec
>
>
> Testing
> ---
> Test was : dd if=/dev/zero of=/r1/bigfile bs=1M count=10240; sync
> 64-chunka.txt:2:00.63
> 128-chunka.txt:2:00.20
> 256-chunka.txt:2:01.67
> 512-chunka.txt:2:19.90
> 1024-chunka.txt:2:59.32
For your configuration, a 64-256k chunk seems optimal for this, hypothetical
benchmark :)


>
>
> Test was : Unraring multipart RAR's, 1.2 gigabytes. Source and dest
> drive were the raid array.
> 64-chunkc.txt:1:04.20
> 128-chunkc.txt:0:49.37
> 256-chunkc.txt:0:48.88
> 512-chunkc.txt:0:41.20
> 1024-chunkc.txt:0:40.82
1 meg looks like its the best, which is what I use today, 1 MiB chunk offers
the best peformance by far, at least with all of my testing (with big files)
such as the tests you performed.

>
>
>
> So, there's a toss up between 256 and 512.
Yeah for DD performance, not real-life.

> If I'm interpreting
> correctly here, raw throughput is better with 256, but 512 seems to
> work better with real-world stuff? 
Look above, 1 MiB got you the fastest unrar time.

> I'll try to think up another test
> or two perhaps, and removing 64 as one of the possible options to save
> time (mke2fs takes a while on 1.5TB)
Also, don't use ext*, XFS can be up to 2-3x faster (in many of the 
benchmarks).

>
> Next step will be playing with read aheads and stripe cache sizes I
> guess! I'm open to any comments/suggestions you guys have!
>
> Greg
>

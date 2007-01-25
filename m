Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Jan 2007 03:14:11 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0PBE1qw010014
	for <xfs@oss.sgi.com>; Thu, 25 Jan 2007 03:14:05 -0800
Date: Thu, 25 Jan 2007 06:13:07 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
In-Reply-To: <45B80610.5010804@rcn.com>
Message-ID: <Pine.LNX.4.64.0701250612040.8945@p34.internal.lan>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
 <20070122115703.97ed54f3.akpm@osdl.org> <Pine.LNX.4.64.0701241909120.2930@p34.internal.lan>
 <45B80610.5010804@rcn.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bill Cizek <cizek@rcn.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>



On Wed, 24 Jan 2007, Bill Cizek wrote:

> Justin Piszcz wrote:
> > On Mon, 22 Jan 2007, Andrew Morton wrote:
> >   
> > > > On Sun, 21 Jan 2007 14:27:34 -0500 (EST) Justin Piszcz
> > > > <jpiszcz@lucidpixels.com> wrote:
> > > > Why does copying an 18GB on a 74GB raptor raid1 cause the kernel to
> > > > invoke the OOM killer and kill all of my processes?
> > > >       
> > Running with PREEMPT OFF lets me copy the file!!  The machine LAGS
> > occasionally every 5-30-60 seconds or so VERY BADLY, talking 5-10 seconds of
> > lag, but hey, it does not crash!! I will boot the older kernel with preempt
> > on and see if I can get you that information you requested.
> >   
> Justin,
> 
> According to your kernel_ring_buffer.txt (attached to another email), you are
> using "anticipatory" as your io scheduler:
>   289  Jan 24 18:35:25 p34 kernel: [    0.142130] io scheduler noop registered
>   290  Jan 24 18:35:25 p34 kernel: [    0.142194] io scheduler anticipatory
> registered (default)
> 
> I had a problem with this scheduler where my system would occasionally lockup
> during heavy I/O.  Sometimes it would fix itself, sometimes I had to reboot.
> I changed to the "CFQ" io scheduler and my system has worked fine since then.
> 
> CFQ has to be built into the kernel (under BlockLayer/IOSchedulers).  It can
> be selected as default or you can set it during runtime:
> 
> echo cfq > /sys/block/<disk>/queue/scheduler
> ...
> 
> Hope this helps,
> Bill
> 
>

I used to run CFQ awhile back but then I switched over to AS as it has 
better performance for my workloads, currently, I am running with PREEMPT 
off, if I see any additional issues, I will switch to the CFQ scheduler.

Right now, its the OOM killer that is going crazy.

Justin.

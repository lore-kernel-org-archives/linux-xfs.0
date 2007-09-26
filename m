Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 10:41:50 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8QHfeMH002393
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 10:41:45 -0700
Date: Wed, 26 Sep 2007 13:41:40 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <216020.40502.qm@web32910.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0709261339310.24646@p34.internal.lan>
References: <216020.40502.qm@web32910.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: b.j.smith@ieee.org
Cc: Ralf Gross <Ralf-Lists@ralfgross.de>, linux-xfs@oss.sgi.com



On Wed, 26 Sep 2007, Bryan J. Smith wrote:

> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> I wonder where the bottleneck lies.
>
> The microcontroller.
>
> Listen, for the last time, hardware RAID is _not_ for non-blocking
> I/O.  Hardware RAID is for in-line XOR streaming off-load, so it
> doesn't tie up a system interconnect (which isn't an ideal use for
> it).
I agree and this makes sense but in real-world loads it makes me wonder, 
at least with the 2.4 kernel.  I see hosts where total streaming does not 
take place, instead lots of little files are copied on and off a host and 
with the 2.4 kernel (RHEL3) the system 'feels' as if it were buried even 
though the load is not that high ~9-10-15.  Using ext3 on a 9 or 10 disk 
RAID5 with default RAID parameters on a 3ware 9550SX card.

Justin.

>
> A hardware RAID card is when you have other things going on in your
> interconnect that you don't want the parity LOAD-XOR-STOR to take
> away from what it could be using for the service.
>
> It will _never_ have the "raw performance" of OS optimized software
> RAID.  At the same time, OS optimized software RAID's impact on the
> system interconnect is one of those "unmeasurable" details _unless_
> you actually benchmark your application.
>
> I have repeatedly had issues with elementary UDP/IP NFS performance
> when the PIO of software RAID is hogging the system interconnect.
> Same deal for large numbers of large database record commits.
Understood.

>
>
> -- 
> Bryan J. Smith   Professional, Technical Annoyance
> b.j.smith@ieee.org    http://thebs413.blogspot.com
> --------------------------------------------------
>     Fission Power:  An Inconvenient Solution
>

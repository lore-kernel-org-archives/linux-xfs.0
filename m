Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 04:00:22 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NC0Dqw004266
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 04:00:14 -0800
Date: Tue, 23 Jan 2007 06:59:19 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
In-Reply-To: <45B5ECAA.6000100@tls.msk.ru>
Message-ID: <Pine.LNX.4.64.0701230657380.8978@p34.internal.lan>
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan>
 <45B5261B.1050104@redhat.com> <17845.13256.284461.992275@notabene.brown>
 <Pine.LNX.4.64.0701230556050.8978@p34.internal.lan> <45B5ECAA.6000100@tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>



On Tue, 23 Jan 2007, Michael Tokarev wrote:

> Justin Piszcz wrote:
> []
> > Is this a bug that can or will be fixed or should I disable pre-emption on 
> > critical and/or server machines?
> 
> Disabling pre-emption on critical and/or server machines seems to be a good
> idea in the first place.  IMHO anyway.. ;)
> 
> /mjt
> 

So for a server system, the following options should be as follows:

Preemption Model (No Forced Preemption (Server))  --->
[ ] Preempt The Big Kernel Lock

Also, my mobo has HPET timer support in the BIOS, is there any reason to 
use this on a server? I do run X on it via the Intel 965 chipset video.

So bottom line is make sure not to use preemption on servers or else you 
will get weird spinlock/deadlocks on RAID devices--GOOD To know!

Thanks!

Justin.

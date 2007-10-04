Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 16:10:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l94NAd8O027210
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 16:10:44 -0700
Received: from snort.melbourne.sgi.com (snort.melbourne.sgi.com [134.14.54.149]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id JAA18191 for <xfs@oss.sgi.com>; Fri, 5 Oct 2007 09:10:39 +1000
Received: from snort.melbourne.sgi.com (localhost [127.0.0.1])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id l94NAcdD51135921
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2007 09:10:39 +1000 (AEST)
Received: (from dgc@localhost)
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id l94NAbLd51176060
	for xfs@oss.sgi.com; Fri, 5 Oct 2007 09:10:37 +1000 (AEST)
Date: Fri, 5 Oct 2007 09:10:37 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Crash on 2.6.21.7 Vanilla + DRBD 0.7
Message-ID: <20071004231037.GJ23367404@sgi.com>
References: <20071004133302.GA5058@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004133302.GA5058@apartia.fr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Thu, Oct 04, 2007 at 03:33:02PM +0200, vindex+lists-xfs@apartia.org wrote:
> 
> Hi,
> 
> I did compile a fresh 2.6.21.7 kernel from kernel.org (no distro patch,
> ....), and latest svn (3062) 0.7.X drbd.
> 
> After just 2 days of uptime, I did experience another crash.
> 
> I wonder if it is an XFS related bug, a DRBD one, or related to XFS on
> top of DRBD.
> 
> This bug seems to occur with intensive IO operations.
> 
> What do you think about it ?
> 
> Thanks
> 
> 
> Oct  3 18:55:23  kernel: Oops: 0002 [#1]
> Oct  3 18:55:23  kernel: SMP 
> Oct  3 18:55:23  kernel: CPU:    7
> Oct  3 18:55:23  kernel: EIP:    0060:[<c016540c>]    Not tainted VLI
> Oct  3 18:55:23  kernel: EFLAGS: 00010046   (2.6.21-dl380-g5-20071001 #1)
> Oct  3 18:55:23  kernel: EIP is at cache_alloc_refill+0x11c/0x4f0

Use after free somewhere, i'd say. Turn on slab/slub poisoning and
other memory debugging options and see where it panics next
time.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

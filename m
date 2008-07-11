Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Jul 2008 03:20:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6BAKqcf025711
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 03:20:53 -0700
Received: from uplift.swm.pp.se (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBBFADF7BEC
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 03:21:58 -0700 (PDT)
Received: from uplift.swm.pp.se (swm.pp.se [212.247.200.143]) by cuda.sgi.com with ESMTP id IDwCQ8HZYe6M3Vah for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 03:21:58 -0700 (PDT)
Date: Fri, 11 Jul 2008 12:21:56 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: xfs bug in 2.6.26-rc9
In-Reply-To: <20080711084248.GU29319@disturbed>
Message-ID: <alpine.DEB.1.10.0807111215040.30192@uplift.swm.pp.se>
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, 11 Jul 2008, Dave Chinner wrote:

> That aside, what was the assert failure reported prior to the oops? i.e. 
> paste the lines in the log before the ---[ cut here ]--- line? One of 
> them will start with 'Assertion failed:', I think....

These ones?

Jul  8 04:44:56 via kernel: [554197.888008] Assertion failed: whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, line: 5879
Jul  9 03:25:21 via kernel: [42940.748007] Assertion failed: whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, line: 5879

I'll happily rebuild the kernel without the debug option and do xfs_check 
to weed out any possible logical problem with the volume, if you don't 
need any further information from the current state of my volume.

I should also say that this assert failue happened two nights in a row so 
I guess it's fairly reproducible (didn't happen on the 10th, and today, 
the 11th it seems to have panic:ed around 03:30 (I start the 
defragmentation via cron at 03:00) which I think is related.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

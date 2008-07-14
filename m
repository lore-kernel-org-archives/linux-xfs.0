Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jul 2008 00:29:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6E7Thwf003563
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 00:29:44 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB0F12EA5DE
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 00:30:49 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 6AnbqEZdN7mCfNGZ for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 00:30:49 -0700 (PDT)
Date: Mon, 14 Jul 2008 17:30:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs bug in 2.6.26-rc9
Message-ID: <20080714073035.GV29319@disturbed>
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed> <alpine.DEB.1.10.0807111215040.30192@uplift.swm.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807111215040.30192@uplift.swm.pp.se>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jul 11, 2008 at 12:21:56PM +0200, Mikael Abrahamsson wrote:
> On Fri, 11 Jul 2008, Dave Chinner wrote:
>
>> That aside, what was the assert failure reported prior to the oops? 
>> i.e. paste the lines in the log before the ---[ cut here ]--- line? One 
>> of them will start with 'Assertion failed:', I think....
>
> These ones?
>
> Jul  8 04:44:56 via kernel: [554197.888008] Assertion failed: whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, line: 5879
> Jul  9 03:25:21 via kernel: [42940.748007] Assertion failed: whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, line: 5879

That implies a flush to disk failed to write everything, but no error was
reported back to the flush. Not particularly conclusive what caused
your problem.

That being said, it's not a fatal error - it simply means that
the bmap will return a bogus block number reported for the delalloc
extent that still exists. 

This implies an in-memory error, not an on-disk error...

> I should also say that this assert failue happened two nights in a row so 
> I guess it's fairly reproducible (didn't happen on the 10th, and today,  
> the 11th it seems to have panic:ed around 03:30 (I start the  
> defragmentation via cron at 03:00) which I think is related.

Can you find the file it is failing on and run 'xfs_bmap -vvp
<file>' to just extract the extent map outside the context of
xfs_fsr?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

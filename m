Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 21:42:13 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1K5g3v6018959
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 21:42:08 -0800
Date: Wed, 20 Feb 2008 16:42:16 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
Message-ID: <20080220054216.GN155407@sgi.com>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk> <20080216074019.GV155407@sgi.com> <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk> <20080217230645.GY155407@sgi.com> <Pine.LNX.4.63.0802180015110.4514@alienAngel.home.sk> <Pine.LNX.4.63.0802190044350.8907@alienAngel.home.sk> <20080219002059.GX155407@sgi.com> <Pine.LNX.4.63.0802190209490.20408@alienAngel.home.sk> <20080219014619.GY155407@sgi.com> <Pine.LNX.4.63.0802191458080.4320@alienAngel.home.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0802191458080.4320@alienAngel.home.sk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Derfinak <ja@mail.upjs.sk>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Tue, Feb 19, 2008 at 03:05:32PM +0100, Jan Derfinak wrote:
> On Tue, 19 Feb 2008, David Chinner wrote:
> 
> > I did not use a patched mkfs - just my patch that does correction.
> 
> I tried with only your patch. The result is slightly different, but
> not correct.

Ok, still 1024 blocks out. Still need to reproduce it locally.

FYI - thisis not a corruption bug - just an accounting problem.
IOWs, all it will cause is slightly premature detection of ENOSPC....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

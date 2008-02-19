Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 17:46:11 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1J1k4vT019342
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 17:46:07 -0800
Date: Tue, 19 Feb 2008 12:46:19 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
Message-ID: <20080219014619.GY155407@sgi.com>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk> <20080216074019.GV155407@sgi.com> <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk> <20080217230645.GY155407@sgi.com> <Pine.LNX.4.63.0802180015110.4514@alienAngel.home.sk> <Pine.LNX.4.63.0802190044350.8907@alienAngel.home.sk> <20080219002059.GX155407@sgi.com> <Pine.LNX.4.63.0802190209490.20408@alienAngel.home.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0802190209490.20408@alienAngel.home.sk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Derfinak <ja@mail.upjs.sk>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Tue, Feb 19, 2008 at 02:20:42AM +0100, Jan Derfinak wrote:
> On Tue, 19 Feb 2008, David Chinner wrote:
> 
> > 
> > The output I showed you was from an ia64 machine, so it's not
> > purely 64bit related.
> > 
> > Can you rebuild you x86_64 kernel from the same kernel
> > tree you built the ia32 (make mrproper; make ....) and reinstall
> > it and see if the still exists?
> 
> Done, but the problem still exists.
> # xfs_check /dev/loop0
> sb_fdblocks 253756, counted 254780
> 
> Dave, when you tested on ia64, did you use mkfs.xfs which wrote feature2
> record on right place or did you use your patch to correct feature2 on
> mount? Because I use mkfs.xfs patched with Eric Sandeen patch on x86_64 to
> create FS which really has lazy-count=1.

I did not use a patched mkfs - just my patch that does correction.
I think I need to test this on an x86_64 box and see if i can
reproduce it locally because it's not obviously operator error
or clearly an 32/64bit problem...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

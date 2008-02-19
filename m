Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 16:20:50 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1J0Ki2I013389
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 16:20:46 -0800
Date: Tue, 19 Feb 2008 11:20:59 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
Message-ID: <20080219002059.GX155407@sgi.com>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk> <20080216074019.GV155407@sgi.com> <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk> <20080217230645.GY155407@sgi.com> <Pine.LNX.4.63.0802180015110.4514@alienAngel.home.sk> <Pine.LNX.4.63.0802190044350.8907@alienAngel.home.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0802190044350.8907@alienAngel.home.sk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Derfinak <ja@mail.upjs.sk>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Tue, Feb 19, 2008 at 01:04:35AM +0100, Jan Derfinak wrote:
> On Mon, 18 Feb 2008, Jan Derfinak wrote:
> 
> > > with dd and rm'ing a subset of the files before unmounting?
> > > I've run some simple tests this morning that do this, and I
> > > don't see any issues. I'd like to confirm that simple cases
> > 
> > Did you use x86_64 and latest CVS kernel?
> 
> I have run the mount,umount test on x86 architecture with the same kernel
> source version. Kernel image is of course different, it is different
> computer.
> On x86 everything is ok.
> I guess that problem is in 64-bit architecture. Is it possible?

The output I showed you was from an ia64 machine, so it's not
purely 64bit related.

Can you rebuild you x86_64 kernel from the same kernel
tree you built the ia32 (make mrproper; make ....) and reinstall
it and see if the still exists?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

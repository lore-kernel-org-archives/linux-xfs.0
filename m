Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Feb 2008 15:06:40 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1HN6XaB029845
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 15:06:37 -0800
Date: Mon, 18 Feb 2008 10:06:45 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
Message-ID: <20080217230645.GY155407@sgi.com>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk> <20080216074019.GV155407@sgi.com> <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Derfinak <ja@mail.upjs.sk>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Sat, Feb 16, 2008 at 11:41:42PM +0100, Jan Derfinak wrote:
> On Sat, 16 Feb 2008, David Chinner wrote:
> 
> > had time. The patch below should fix the problem - mkfs.xfs is writing
> > the features2 field to the wrong location in the superblock, and
> > this patch detects and corrects it. You'll probably see the output:
> 
> I would like to ask if correcting the feature2 field can lead to this
> message?:
> # xfs_check /dev/system/mnt
> sb_fdblocks 190009, counted 191033
> sb_fdblocks 190009, aggregate AGF count 191033

Lazy superblock counters mean that the superblock counters
are not kept exactly up to date at all times and hence this
can happen if the filesystem was not shut down cleanly. however,
when you remount the filesystem, it should recover all of the
correct values due to redundant information in the AGF and AGI
headers (that's the "aggregate AGF count" above). In the case
of a clean shutdown, however, they should be up to date.

Is this reproducable with simple tests? e.g. mkfs, mount, unmount
check? or doing some simple things like creating some files
with dd and rm'ing a subset of the files before unmounting?
I've run some simple tests this morning that do this, and I
don't see any issues. I'd like to confirm that simple cases
are working correctly on your test setup first...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

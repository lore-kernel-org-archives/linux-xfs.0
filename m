Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Feb 2008 00:58:04 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1C8voBr026490
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 00:57:55 -0800
Date: Tue, 12 Feb 2008 19:58:02 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs [_fsr] probs in 2.6.24.0
Message-ID: <20080212085802.GA155407@sgi.com>
References: <47B0F00D.3060802@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B0F00D.3060802@tlinx.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs@oss.sgi.com, Linux-Kernel <linux-kernel@vger.kernel.org>

On Mon, Feb 11, 2008 at 05:02:05PM -0800, Linda Walsh wrote:
> 
> I'm getting similar errors on an x86-32 & x86-64 kernel.  The x86-64 system
> (2nd log below w/date+times) was unusable this morning: one or more of the
> xfs file systems had "gone off line" due to some unknown error (upon reboot,
> no errors were indicated; all partitions on the same physical disk).
> 
> I keep ending up with random failures on two systems.  The 32-bit sys more
> often than not just "locks-up" -- no messages, no keyboard response...etc.
> Nothing to do except reset -- and of course, nothing in the logs....

Filesystem bugs rarely hang systems hard like that - more likely is
a hardware or driver problem. And neither of the lockdep reports
below are likely to be responsible for a system wide, no-response
hang.

[cut a bunch of speculation and stuff about hardware problems
causing XFS problems]

> Lemme know if I can provide any info in addressing these problems.  I don't
> know if they are related to the other system crashes, but usage patterns
> indicate it could be disk-activity related.  So eliminating known bugs &
> problems in that area might help (?)...

If your hardware or drivers are unstable, then XFS cannot be
expected to reliably work. Given that xfs_fsr apparently triggers
the hangs, I'd suggest putting lots of I/O load on your disk subsystem
by copying files around with direct I/O (just like xfs_fsr does) to
try to reproduce the problem.

Perhaps by running xfs_fsr manually you could reproduce the
problem while you are sitting in front of the machine...

Looking at the lockdep reports:

> The first set of errors the I have some diagnostics for, I could
> only find in dmesg:
> (ish-32bit machine)
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.24-ish #1
> -------------------------------------------------------
> xfs_fsr/2119 is trying to acquire lock:
> (&mm->mmap_sem){----}, at: [<b01a3432>] dio_get_page+0x62/0x160
> 
> but task is already holding lock:
> (&(&ip->i_iolock)->mr_lock){----}, at: [<b02651db>] xfs_ilock+0x5b/0xb0

dio_get_page() takes the mmap_sem of the processes
vma that has the pages we do I/O into. That's not new.
We're holding the xfs inode iolock at this point to protect
against truncate  and simultaneous buffered I/O races and
this is also unchanged.  i.e. this is normal.

> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:

munmap() dropping the last reference to it's vm_file and
calling ->release() which causes a truncate of speculatively
allocated space to take place. IOWs, ->release() is called
with the mmap_sem held. Hmmm....

Looking at it in terms of i_mutex, other filesystems hold
i_mutex over dio_get_page() (all those that use DIO_LOCKING)
so question is whether we are allowed to take the i_mutex
in ->release. I note that both reiserfs and hfsplus take 
i_mutex in ->release as well as use DIO_LOCKING, so this
problem is not isolated to XFS.

However, it would appear that mmap_sem -> i_mutex is illegal
according to the comment at the head of mm/filemap.c. While we are
not using i_mutex in this case, the inversion would seem to be
equivalent in nature.

There's not going to be a quick fix for this.

And the other one:

> Feb  7 02:01:50 kern: 
> -------------------------------------------------------
> Feb  7 02:01:50 kern: xfs_fsr/6313 is trying to acquire lock:
> Feb  7 02:01:50 kern:  (&(&ip->i_lock)->mr_lock/2){----}, at: 
> [<ffffffff803c1b22>] xfs_ilock+0x82/0xc0
> Feb  7 02:01:50 kern:
> Feb  7 02:01:50 kern: but task is already holding lock:
> Feb  7 02:01:50 kern:  (&(&ip->i_iolock)->mr_lock/3){--..}, at: 
> [<ffffffff803c1b45>] xfs_ilock+0xa5/0xc0
> Feb  7 02:01:50 kern:
> Feb  7 02:01:50 kern: which lock already depends on the new lock.

Looks like yet another false positive. Basically we do this
in xfs_swap_extents:

	inode A: i_iolock class 2
	inode A: i_ilock class 2
	inode B: i_iolock class 3
	inode B: i_ilock class 3
	.....
	inode A: unlock ilock
	inode B: unlock ilock
	.....
>>>>>	inode A: ilock class 2
	inode B: ilock class 3

And lockdep appears to be complaining about the relocking of inode A
as class 2 because we've got a class 3 iolock still held, hence
violating the order it saw initially.  There's no possible deadlock
here so we'll just have to add more hacks to the annotation code to make
lockdep happy.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

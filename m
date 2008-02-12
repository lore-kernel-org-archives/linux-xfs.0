Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Feb 2008 13:59:03 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1CLwsVr031435
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2008 13:58:59 -0800
Date: Wed, 13 Feb 2008 08:59:07 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs [_fsr] probs in 2.6.24.0
Message-ID: <20080212215907.GH155407@sgi.com>
References: <47B0F00D.3060802@tlinx.org> <20080212085802.GA155407@sgi.com> <47B2094D.50406@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B2094D.50406@tlinx.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linda Walsh <xfs@tlinx.org>
Cc: David Chinner <dgc@sgi.com>, Linux-Xfs <linux-xfs@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>

On Tue, Feb 12, 2008 at 01:02:05PM -0800, Linda Walsh wrote:
> David Chinner wrote:
> >Perhaps by running xfs_fsr manually you could reproduce the
> >problem while you are sitting in front of the machine...
> ----
> 	Um...yeah, AND with multiple "cp's of multi-gig files
> going on at same time, both local, by a sister machine via NFS,
> and and a 3rd machine tapping (not banging) away via CIFS.
> These were on top of normal server duties.  Whenever I stress
> it on *purpose* and watch it, works fine.   GRRRRRRR....I HATE
>  THAT!!!

I feel your pain.

> 	The file system(s) going "offline" due
> to xfs-detected filesystem errors has only happened *once* on
> asa, the 64-bit machine.  It's a fairly new machine w/o added
> hardware -- but this only happened in 2.24.0 when I added the
> tickless clock option, which sure seems like a remote possibility for
> causing an xfs error, but could be.

Well, tickless is new and shiny and I doubt anyone has done
much testing with XFS on tickless kernels. Still, if that's a new
config option you set, change it back to what you had for .23 on
that hardware and try again.

> >Looking at it in terms of i_mutex, other filesystems hold
> >i_mutex over dio_get_page() (all those that use DIO_LOCKING)
> >so question is whether we are allowed to take the i_mutex
> >in ->release. I note that both reiserfs and hfsplus take 
> >i_mutex in ->release as well as use DIO_LOCKING, so this
> >problem is not isolated to XFS.
> >
> >However, it would appear that mmap_sem -> i_mutex is illegal
> >according to the comment at the head of mm/filemap.c. While we are
> >not using i_mutex in this case, the inversion would seem to be
> >equivalent in nature.
> >
> >There's not going to be a quick fix for this.
> ----
> 	What could be the consequences of this locking anomaly?

If you have a multithreaded application that mixes mmap and
direct I/O, and you have a simultaneous munmap() call and
read() to the same file, you might be able to deadlock access
to that file. However, you'd have to be certifiably insane
to write an application that did this (mix mmap and direct I/O
to the same file at the same time), so I think exposure is
pretty limited.

> I.e., for example, in NFS, I have enabled "allow direct I/O on NFS
> files".

That's client side direct I/O, which is not what the server
does. Client side direct I/O results in synchronous buffered
I/O on the server, which will thrash your disks pretty hard.
The config option help does warn you about this. ;)

> >And the other one:
> >
> >>Feb  7 02:01:50 kern: 
> >>-------------------------------------------------------
> >>Feb  7 02:01:50 kern: xfs_fsr/6313 is trying to acquire lock:
> >>Feb  7 02:01:50 kern:  (&(&ip->i_lock)->mr_lock/2){----}, at: 
> >>[<ffffffff803c1b22>] xfs_ilock+0x82/0xc0
> >>Feb  7 02:01:50 kern:
> >>Feb  7 02:01:50 kern: but task is already holding lock:
> >>Feb  7 02:01:50 kern:  (&(&ip->i_iolock)->mr_lock/3){--..}, at: 
> >>[<ffffffff803c1b45>] xfs_ilock+0xa5/0xc0
> >>Feb  7 02:01:50 kern:
> >>Feb  7 02:01:50 kern: which lock already depends on the new lock.
> >
> >Looks like yet another false positive. Basically we do this
> >in xfs_swap_extents:
> >
> >	inode A: i_iolock class 2
> >	inode A: i_ilock class 2
> >	inode B: i_iolock class 3
> >	inode B: i_ilock class 3
> >	.....
> >	inode A: unlock ilock
> >	inode B: unlock ilock
> >	.....
> >>>>>>	inode A: ilock class 2
> >	inode B: ilock class 3
> >
> >And lockdep appears to be complaining about the relocking of inode A
> >as class 2 because we've got a class 3 iolock still held, hence
> >violating the order it saw initially.  There's no possible deadlock
> >here so we'll just have to add more hacks to the annotation code to make
> >lockdep happy.
> ----
> 	Is there a reason to unlock and relock the same inode while
> the level 3 lock is held -- i.e. does 'unlocking ilock' allow some
> increased 'throughput' for some other potential process to access
> the same inode? 

It prevents a single thread deadlock when doing transaction reservation.
i.e. the process of setting up a transaction can require the ilock
to be taken, and hence we have to drop it before and pick it back up
after the transaction reservation.

We hold on to the iolock to prevent the inode from having new I/O
started while we do the transaction reservation, so it's in the
same state after the reservation as it was before....

We have to hold both locks to guarantee exclusive access to the
inode, so once we have the reservation we need to pick the ilocks
back up. The way we do it here does not violate lock ordering at all
(iolock before ilock on a single inode, and ascending inode number
order for multiple inodes), but lockdep is not smart enough to know
that. Hence we need more complex annotations to shut it up.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

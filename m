Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 21:13:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P4DcGi025479
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 21:13:40 -0700
Subject: TAKE 978886 - xfs_dialloc() dirtying transactions at ENOSPC incorrectly
Message-Id: <20080325041407.F090958C4C0F@chook.melbourne.sgi.com>
Date: Tue, 25 Mar 2008 15:14:07 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Account for inode cluster alignment in all allocations

At ENOSPC, we can get a filesystem shutdown due to a cancelling a
dirty transaction in xfs_mkdir or xfs_create. This is due to the
initial allocation attempt not taking into account inode alignment and hence
we can prepare the AGF freelist for allocation when it's not actually
possible to do an allocation. This results in inode allocation returning
ENOSPC with a dirty transaction, and hence we shut down the filesystem.

Because the first allocation is an exact allocation attempt, we must tell
the allocator that the alignment does not affect the allocation attempt.
i.e. we will accept any extent alignment as long as the extent starts
at the block we want. Unfortunately, this means that if the longest
free extent is less than the length + alignment necessary for fallback
allocation attempts but is long enough to attempt a non-aligned allocation,
we will modify the free list.

If we then have the exact allocation fail, all other allocation attempts
will also fail due to the alignment constraint being taken into account.
Hence the initial attempt needs to set the "alignment slop" field so
that alignment, while not required, must be taken into account when
determining if there is enough space left in the AG to do the allocation.

That means if the exact allocation fails, we will not dirty the freelist
if there is not enough space available fo a subsequent allocation to
succeed. Hence we get an ENOSPC error back to userspace without shutting
down the filesystem.

Date:  Tue Mar 25 15:13:28 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30699a
fs/xfs/xfs_ialloc.c - 1.198 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.198&r2=text&tr2=1.197&f=h
	- Account for inode cluster allocation alignment even when trying to allocate
	  at an exact block. This prevents a failed exact allocation attempt from
	  dirtying the transaction when the conditions are such that no allocation
	  can succeed.

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Dec 2007 23:44:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBI7i3Zt024379
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 23:44:08 -0800
Date: Tue, 18 Dec 2007 18:44:05 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [review] Remove the xfs refcache
Message-ID: <20071218074405.GI4396912@sgi.com>
References: <4765EC66.5020202@sgi.com> <4765F444.8010705@sgi.com> <20071217071426.GA11462@infradead.org> <47674892.9070506@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47674892.9070506@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Donald Douwsma <donaldd@sgi.com>, xfs-oss <xfs@oss.sgi.com>, gnb@sgi.com

On Tue, Dec 18, 2007 at 03:12:02PM +1100, Lachlan McIlroy wrote:
> Since I have been able to reproduce some of our NAS/NFS performance problems
> without NFS (that is demonstrate that the problems are in XFS) it makes some
> sense to fix these in XFS.  I have observed that for some non-NFS workloads
> we see a significant reduction in log traffic with the OFC in XFS so for
> reasons beyond NFS there may be a need to reactivate the refcache code.  For
> the moment we are still analysing the pros/cons.

Reactivating the ref cache is fundamentally the wrong thing to do.
Most of these problems come from the mismatch of inode life cycles
between Linux and XFS and this is the basic problem we need to solve.

For example - do the open-write-close related performance issues go
away if you remove the xfs_free_eofblocks() call in xfs_release()?
i.e. are we just being stupid about the way we deal with closing
of file descriptors?

This should work because the linux inode will remain around with a
ref-count of 1 on the unused list due to the dentry pinning it
in place. Only when the dentry gets reclaimed (e.g. memory pressure,
unlink, unmount, etc) will the truncate occur, and hence repeated
single file open-write-close based workloads (like the nfsd) don't
issue a truncate transaction and trash the EOF preallocation on
every close....

And look at the code - the *only thing* the refcache does is avoid
the truncate in xfs_release(). So, the patch below is the equivalent
of re-introducing the refcache into XFS but uses the linux inode
life cycle to keep references around.

FWIW, this means that EOF pre-allocations will not get trimmed
immediately which may have disk usage implications for users with
small quotas, those that create lots of small files, or there are
lots of written inodes with prealocated space cached in memory
when a crash occurs.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


Don't truncate EOF blocks on ->release

Avoid truncating EOF blocks on final close of an filp and
delay it till the inode is reclaimed. While this puts more
pressure on xfs_inactive() during reclaim, it means that
we avoid lots of needless transactions on open-write-close
type workloads (eg as done by the nfsd code).

Note that this means that while inodes are cached in memory
they may be consuming more blocks than their size may indicate
and this space will not be reclaimed if the machine crashes.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_vnodeops.c |   24 ------------------------
 1 file changed, 24 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-12-10 12:04:17.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-12-18 18:17:57.188146022 +1100
@@ -1504,7 +1504,6 @@ xfs_release(
 {
 	bhv_vnode_t	*vp = XFS_ITOV(ip);
 	xfs_mount_t	*mp = ip->i_mount;
-	int		error;
 
 	if (!VN_ISREG(vp) || (ip->i_d.di_mode == 0))
 		return 0;
@@ -1540,29 +1539,6 @@ xfs_release(
 		if (truncated && VN_DIRTY(vp) && ip->i_delayed_blks > 0)
 			xfs_flush_pages(ip, 0, -1, XFS_B_ASYNC, FI_NONE);
 	}
-
-#ifdef HAVE_REFCACHE
-	/* If we are in the NFS reference cache then don't do this now */
-	if (ip->i_refcache)
-		return 0;
-#endif
-
-	if (ip->i_d.di_nlink != 0) {
-		if ((((ip->i_d.di_mode & S_IFMT) == S_IFREG) &&
-		     ((ip->i_size > 0) || (VN_CACHED(vp) > 0 ||
-		       ip->i_delayed_blks > 0)) &&
-		     (ip->i_df.if_flags & XFS_IFEXTENTS))  &&
-		    (!(ip->i_d.di_flags &
-				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
-			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
-			if (error)
-				return error;
-			/* Update linux inode block count after free above */
-			vn_to_inode(vp)->i_blocks = XFS_FSB_TO_BB(mp,
-				ip->i_d.di_nblocks + ip->i_delayed_blks);
-		}
-	}
-
 	return 0;
 }
 

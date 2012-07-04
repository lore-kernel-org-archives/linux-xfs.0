Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q64FEj35223594 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 10:14:45 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zfu3peJ41Aj7D64H (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jul 2012 08:14:44 -0700 (PDT)
Message-Id: <20120704151443.077344815@bombadil.infradead.org>
Date: Wed, 04 Jul 2012 11:13:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5] xfs: clean up xfs_inactive
References: <20120704151328.928543446@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-evict-transactions
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: sage@newdream.net

The code to reserve log space and join the inode to the transaction is
common for all cases, so don't duplicate it.  Also remove the trivial
xfs_inactive_symlink_local helper which can simply be opencode now.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_vnodeops.c |  171 ++++++++++++--------------------------------------
 1 file changed, 43 insertions(+), 128 deletions(-)

Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2012-07-04 09:01:24.733722862 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2012-07-04 09:50:20.683705323 +0200
@@ -282,23 +282,15 @@ xfs_inactive_symlink_rmt(
 	 * free them all in one bunmapi call.
 	 */
 	ASSERT(ip->i_d.di_nextents > 0 && ip->i_d.di_nextents <= 2);
-	if ((error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_ITRUNCATE_LOG_COUNT))) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
-		xfs_trans_cancel(tp, 0);
-		*tpp = NULL;
-		return error;
-	}
+
 	/*
 	 * Lock the inode, fix the size, and join it to the transaction.
 	 * Hold it so in the normal path, we still have it locked for
 	 * the second transaction.  In the error paths we need it
 	 * held so the cancel won't rele it, see below.
 	 */
-	xfs_ilock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 	size = (int)ip->i_d.di_size;
 	ip->i_d.di_size = 0;
-	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	/*
 	 * Find the block(s) so we can inval and unmap them.
@@ -385,67 +377,15 @@ xfs_inactive_symlink_rmt(
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		goto error0;
 	}
-	/*
-	 * Return with the inode locked but not joined to the transaction.
-	 */
+
+	xfs_trans_ijoin(tp, ip, 0);
 	*tpp = tp;
 	return 0;
 
  error1:
 	xfs_bmap_cancel(&free_list);
  error0:
-	/*
-	 * Have to come here with the inode locked and either
-	 * (held and in the transaction) or (not in the transaction).
-	 * If the inode isn't held then cancel would iput it, but
-	 * that's wrong since this is inactive and the vnode ref
-	 * count is 0 already.
-	 * Cancel won't do anything to the inode if held, but it still
-	 * needs to be locked until the cancel is done, if it was
-	 * joined to the transaction.
-	 */
-	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
-	*tpp = NULL;
 	return error;
-
-}
-
-STATIC int
-xfs_inactive_symlink_local(
-	xfs_inode_t	*ip,
-	xfs_trans_t	**tpp)
-{
-	int		error;
-
-	ASSERT(ip->i_d.di_size <= XFS_IFORK_DSIZE(ip));
-	/*
-	 * We're freeing a symlink which fit into
-	 * the inode.  Just free the memory used
-	 * to hold the old symlink.
-	 */
-	error = xfs_trans_reserve(*tpp, 0,
-				  XFS_ITRUNCATE_LOG_RES(ip->i_mount),
-				  0, XFS_TRANS_PERM_LOG_RES,
-				  XFS_ITRUNCATE_LOG_COUNT);
-
-	if (error) {
-		xfs_trans_cancel(*tpp, 0);
-		*tpp = NULL;
-		return error;
-	}
-	xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-
-	/*
-	 * Zero length symlinks _can_ exist.
-	 */
-	if (ip->i_df.if_bytes > 0) {
-		xfs_idata_realloc(ip,
-				  -(ip->i_df.if_bytes),
-				  XFS_DATA_FORK);
-		ASSERT(ip->i_df.if_bytes == 0);
-	}
-	return 0;
 }
 
 STATIC int
@@ -604,7 +544,7 @@ xfs_inactive(
 	xfs_trans_t	*tp;
 	xfs_mount_t	*mp;
 	int		error;
-	int		truncate;
+	int		truncate = 0;
 
 	/*
 	 * If the inode is already free, then there can be nothing
@@ -616,17 +556,6 @@ xfs_inactive(
 		return VN_INACTIVE_CACHE;
 	}
 
-	/*
-	 * Only do a truncate if it's a regular file with
-	 * some actual space in it.  It's OK to look at the
-	 * inode's fields without the lock because we're the
-	 * only one with a reference to the inode.
-	 */
-	truncate = ((ip->i_d.di_nlink == 0) &&
-	    ((ip->i_d.di_size != 0) || XFS_ISIZE(ip) != 0 ||
-	     (ip->i_d.di_nextents > 0) || (ip->i_delayed_blks > 0)) &&
-	    S_ISREG(ip->i_d.di_mode));
-
 	mp = ip->i_mount;
 
 	error = 0;
@@ -650,72 +579,54 @@ xfs_inactive(
 		goto out;
 	}
 
-	ASSERT(ip->i_d.di_nlink == 0);
+	if (S_ISREG(ip->i_d.di_mode) &&
+	    (ip->i_d.di_size != 0 || XFS_ISIZE(ip) != 0 ||
+	     ip->i_d.di_nextents > 0 || ip->i_delayed_blks > 0))
+		truncate = 1;
 
 	error = xfs_qm_dqattach(ip, 0);
 	if (error)
 		return VN_INACTIVE_CACHE;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-	if (truncate) {
-		xfs_ilock(ip, XFS_IOLOCK_EXCL);
-
-		error = xfs_trans_reserve(tp, 0,
-					  XFS_ITRUNCATE_LOG_RES(mp),
-					  0, XFS_TRANS_PERM_LOG_RES,
-					  XFS_ITRUNCATE_LOG_COUNT);
-		if (error) {
-			/* Don't call itruncate_cleanup */
-			ASSERT(XFS_FORCED_SHUTDOWN(mp));
-			xfs_trans_cancel(tp, 0);
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-			return VN_INACTIVE_CACHE;
-		}
+	error = xfs_trans_reserve(tp, 0,
+			(truncate || S_ISLNK(ip->i_d.di_mode)) ?
+				XFS_ITRUNCATE_LOG_RES(mp) :
+				XFS_IFREE_LOG_RES(mp),
+			0,
+			XFS_TRANS_PERM_LOG_RES,
+			XFS_ITRUNCATE_LOG_COUNT);
+	if (error) {
+		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		xfs_trans_cancel(tp, 0);
+		return VN_INACTIVE_CACHE;
+	}
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, 0);
+	xfs_ilock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 
+	if (S_ISLNK(ip->i_d.di_mode)) {
+		/*
+		 * Zero length symlinks _can_ exist.
+		 */
+		if (ip->i_d.di_size > XFS_IFORK_DSIZE(ip)) {
+			error = xfs_inactive_symlink_rmt(ip, &tp);
+			if (error)
+				goto out_cancel;
+		} else if (ip->i_df.if_bytes > 0) {
+			xfs_idata_realloc(ip, -(ip->i_df.if_bytes),
+					  XFS_DATA_FORK);
+			ASSERT(ip->i_df.if_bytes == 0);
+		}
+	} else if (truncate) {
 		ip->i_d.di_size = 0;
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
-		if (error) {
-			xfs_trans_cancel(tp,
-				XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
-			return VN_INACTIVE_CACHE;
-		}
+		if (error)
+			goto out_cancel;
 
 		ASSERT(ip->i_d.di_nextents == 0);
-	} else if (S_ISLNK(ip->i_d.di_mode)) {
-
-		/*
-		 * If we get an error while cleaning up a
-		 * symlink we bail out.
-		 */
-		error = (ip->i_d.di_size > XFS_IFORK_DSIZE(ip)) ?
-			xfs_inactive_symlink_rmt(ip, &tp) :
-			xfs_inactive_symlink_local(ip, &tp);
-
-		if (error) {
-			ASSERT(tp == NULL);
-			return VN_INACTIVE_CACHE;
-		}
-
-		xfs_trans_ijoin(tp, ip, 0);
-	} else {
-		error = xfs_trans_reserve(tp, 0,
-					  XFS_IFREE_LOG_RES(mp),
-					  0, XFS_TRANS_PERM_LOG_RES,
-					  XFS_INACTIVE_LOG_COUNT);
-		if (error) {
-			ASSERT(XFS_FORCED_SHUTDOWN(mp));
-			xfs_trans_cancel(tp, 0);
-			return VN_INACTIVE_CACHE;
-		}
-
-		xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, 0);
 	}
 
 	/*
@@ -781,7 +692,11 @@ xfs_inactive(
 	xfs_qm_dqdetach(ip);
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 
- out:
+out:
+	return VN_INACTIVE_CACHE;
+out_cancel:
+	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 	return VN_INACTIVE_CACHE;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

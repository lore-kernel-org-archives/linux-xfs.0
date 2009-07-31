Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6VL40Qu171479 for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 16:04:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C7F212A94F3
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 14:13:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NidCUiTWDa4vZ3AF for
	<xfs@oss.sgi.com>; Fri, 31 Jul 2009 14:13:51 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MWzHU-0003YV-JH
	for xfs@oss.sgi.com; Fri, 31 Jul 2009 21:04:48 +0000
Message-Id: <20090731210448.410776000@bombadil.infradead.org>
Date: Fri, 31 Jul 2009 17:03:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs: do not wait for the iolock in xfs_free_eofblocks
References: <20090731210340.638586000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-free_eofblocks-lock
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

For both callers of xfs_free_eofblocks taking the iolock in blocking
fashion causes problems:

 - in xfs_release is causes a lock order reversal with the mmap lock
 - due to xfs_inactive beeing called from reclaim context it would
   forbid memory allocation under the iolock.

Just making the lock acquisition non-blocking solves both issues.  In
xfs_release that will leave preallocation on the file, but we'll get
rid of them later, and in xfs_incative the iolock can never be held
by anyone (see rationale in the previous patch).

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_rw.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_rw.h	2009-07-31 18:41:28.413339736 +0200
+++ linux-2.6/fs/xfs/xfs_rw.h	2009-07-31 18:45:38.737339768 +0200
@@ -37,13 +37,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_
 }
 
 /*
- * Flags for xfs_free_eofblocks
- */
-#define XFS_FREE_EOF_LOCK	(1<<0)
-#define XFS_FREE_EOF_NOLOCK	(1<<1)
-
-
-/*
  * helper function to extract extent size hint from inode
  */
 STATIC_INLINE xfs_extlen_t
@@ -78,10 +71,4 @@ extern int xfs_read_buf(struct xfs_mount
 extern void xfs_ioerror_alert(char *func, struct xfs_mount *mp,
 				xfs_buf_t *bp, xfs_daddr_t blkno);
 
-/*
- * Prototypes for functions in xfs_vnodeops.c.
- */
-extern int xfs_free_eofblocks(struct xfs_mount *mp, struct xfs_inode *ip,
-			int flags);
-
 #endif /* __XFS_RW_H__ */
Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c	2009-07-31 18:45:37.483080484 +0200
+++ linux-2.6/fs/xfs/xfs_vnodeops.c	2009-07-31 19:21:33.305080480 +0200
@@ -718,12 +718,11 @@ xfs_fsync(
  * when the link count isn't zero and by xfs_dm_punch_hole() when
  * punching a hole to EOF.
  */
-int
+STATIC int
 xfs_free_eofblocks(
-	xfs_mount_t	*mp,
-	xfs_inode_t	*ip,
-	int		flags)
+	xfs_inode_t	*ip)
 {
+	xfs_mount_t	*mp = ip->i_mount;
 	xfs_trans_t	*tp;
 	int		error;
 	xfs_fileoff_t	end_fsb;
@@ -731,7 +730,6 @@ xfs_free_eofblocks(
 	xfs_filblks_t	map_len;
 	int		nimaps;
 	xfs_bmbt_irec_t	imap;
-	int		use_iolock = (flags & XFS_FREE_EOF_LOCK);
 
 	/*
 	 * Figure out if there are any blocks beyond the end
@@ -749,77 +747,78 @@ xfs_free_eofblocks(
 			  NULL, 0, &imap, &nimaps, NULL, NULL);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
-	if (!error && (nimaps != 0) &&
-	    (imap.br_startblock != HOLESTARTBLOCK ||
-	     ip->i_delayed_blks)) {
-		/*
-		 * Attach the dquots to the inode up front.
-		 */
-		error = xfs_qm_dqattach(ip, 0);
-		if (error)
-			return error;
+	if (error || nimaps == 0 ||
+	    (imap.br_startblock == HOLESTARTBLOCK && !ip->i_delayed_blks))
+		return error;
 
-		/*
-		 * There are blocks after the end of file.
-		 * Free them up now by truncating the file to
-		 * its current size.
-		 */
-		tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
+	/*
+	 * Attach the dquots to the inode up front.
+	 */
+	error = xfs_qm_dqattach(ip, 0);
+	if (error)
+		return error;
 
-		/*
-		 * Do the xfs_itruncate_start() call before
-		 * reserving any log space because
-		 * itruncate_start will call into the buffer
-		 * cache and we can't
-		 * do that within a transaction.
-		 */
-		if (use_iolock)
-			xfs_ilock(ip, XFS_IOLOCK_EXCL);
-		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
-				    ip->i_size);
-		if (error) {
-			xfs_trans_cancel(tp, 0);
-			if (use_iolock)
-				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-			return error;
-		}
+	/*
+	 * There are blocks after the end of file.
+	 *
+	 * Free them up now by truncating the file to its current size.
+	 */
+	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
 
-		error = xfs_trans_reserve(tp, 0,
-					  XFS_ITRUNCATE_LOG_RES(mp),
-					  0, XFS_TRANS_PERM_LOG_RES,
-					  XFS_ITRUNCATE_LOG_COUNT);
-		if (error) {
-			ASSERT(XFS_FORCED_SHUTDOWN(mp));
-			xfs_trans_cancel(tp, 0);
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-			return error;
-		}
+	/*
+	 * We can't just take the iolock here normally because that may
+	 * cause a lock order reversal or deadlocks due to memory allocations.
+	 *
+	 * But in the worse case we'll leave a superflous allocation on the
+	 * inode that will get purged the next time we drop the last reference
+	 * to a file pointing to this inode or totally evicting this inode.
+	 */
+	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
+		xfs_trans_cancel(tp, 0);
+		return EAGAIN;
+	}
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip,
-				XFS_IOLOCK_EXCL |
-				XFS_ILOCK_EXCL);
-		xfs_trans_ihold(tp, ip);
+	/*
+	 * Do the xfs_itruncate_start() call before reserving any log space
+	 * because itruncate_start will call into the buffer cache and we
+	 * can't do that within a transaction.
+	 */
+	error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, ip->i_size);
+	if (error)
+		goto out_cancel;
 
-		error = xfs_itruncate_finish(&tp, ip,
-					     ip->i_size,
-					     XFS_DATA_FORK,
-					     0);
-		/*
-		 * If we get an error at this point we
-		 * simply don't bother truncating the file.
-		 */
-		if (error) {
-			xfs_trans_cancel(tp,
-					 (XFS_TRANS_RELEASE_LOG_RES |
-					  XFS_TRANS_ABORT));
-		} else {
-			error = xfs_trans_commit(tp,
-						XFS_TRANS_RELEASE_LOG_RES);
-		}
-		xfs_iunlock(ip, (use_iolock ? (XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL)
-					    : XFS_ILOCK_EXCL));
+	error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp),
+				  0, XFS_TRANS_PERM_LOG_RES,
+				  XFS_ITRUNCATE_LOG_COUNT);
+	if (error) {
+		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		goto out_cancel;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	xfs_trans_ihold(tp, ip);
+
+	/*
+	 * If we get an error at this point we simply don't bother truncating
+	 * the file.
+	 */
+	error = xfs_itruncate_finish(&tp, ip, ip->i_size, XFS_DATA_FORK, 0);
+	if (error) {
+		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
+				     XFS_TRANS_ABORT);
+		goto out_unlock;
 	}
+
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+
+ out_unlock:
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	return error;
+
+ out_cancel:
+	xfs_trans_cancel(tp, 0);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	return error;
 }
 
@@ -1116,8 +1115,8 @@ xfs_release(
 		     (ip->i_df.if_flags & XFS_IFEXTENTS))  &&
 		    (!(ip->i_d.di_flags &
 				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
-			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
-			if (error)
+			error = xfs_free_eofblocks(ip);
+			if (error && error != EAGAIN)
 				return error;
 		}
 	}
@@ -1187,7 +1186,8 @@ xfs_inactive(
 		     (!(ip->i_d.di_flags &
 				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) ||
 		      (ip->i_delayed_blks != 0)))) {
-			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
+			error = xfs_free_eofblocks(ip);
+			ASSERT(error != EAGAIN);
 			if (error)
 				return VN_INACTIVE_CACHE;
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

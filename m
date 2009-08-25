Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7PIgDtR217747 for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 13:42:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFB481533613
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 11:43:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AkMd31wmBjSs6Ane for
	<xfs@oss.sgi.com>; Tue, 25 Aug 2009 11:43:05 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Mg0z3-0004wN-Ka
	for xfs@oss.sgi.com; Tue, 25 Aug 2009 18:43:05 +0000
Message-Id: <20090825184305.433008786@bombadil.infradead.org>
Date: Tue, 25 Aug 2009 14:41:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs: do not wait for the iolock in xfs_free_eofblocks
References: <20090825184145.704014101@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-lockdep-free_eofblocks
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

As mention in the previous platch there is no need to acquire iolock in
the inactive path as the inode is dead enough at that point.  For release
we can just acquire the lock in a non-blocking fashion.  This will leave
the pre-allocation on the file in case of lock contention, but we will
still take care of it on the final iput.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-08-24 11:23:28.798259252 -0300
+++ xfs/fs/xfs/xfs_vnodeops.c	2009-08-24 11:23:34.886280913 -0300
@@ -714,9 +714,14 @@ xfs_fsync(
 }
 
 /*
- * This is called by xfs_inactive to free any blocks beyond eof
- * when the link count isn't zero and by xfs_dm_punch_hole() when
- * punching a hole to EOF.
+ * We either call this from xfs_release when dropping the last reference to
+ * a file structure, or from xfs_inactive when dropping an inode out of the
+ * cache that has not been deleted.  In the first case we must take the
+ * iolock to protect against concurrent truncate calls, but we can't
+ * acquire it in the normal blocking way as that would created a lock order
+ * reversal against mmap_sem.  In the latter case we don't need the iolock
+ * at all because we're called on inode that is dead enough to not see any
+ * I/O at all.
  */
 STATIC int
 xfs_free_eofblocks(
@@ -766,6 +771,11 @@ xfs_free_eofblocks(
 		 */
 		tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
 
+		if (use_iolock && !xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
+			xfs_trans_cancel(tp, 0);
+			return EAGAIN;
+		}
+
 		/*
 		 * Do the xfs_itruncate_start() call before
 		 * reserving any log space because
@@ -773,16 +783,10 @@ xfs_free_eofblocks(
 		 * cache and we can't
 		 * do that within a transaction.
 		 */
-		if (use_iolock)
-			xfs_ilock(ip, XFS_IOLOCK_EXCL);
 		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
 				    ip->i_size);
-		if (error) {
-			xfs_trans_cancel(tp, 0);
-			if (use_iolock)
-				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-			return error;
-		}
+		if (error)
+			goto out_cancel;
 
 		error = xfs_trans_reserve(tp, 0,
 					  XFS_ITRUNCATE_LOG_RES(mp),
@@ -790,14 +794,12 @@ xfs_free_eofblocks(
 					  XFS_ITRUNCATE_LOG_COUNT);
 		if (error) {
 			ASSERT(XFS_FORCED_SHUTDOWN(mp));
-			xfs_trans_cancel(tp, 0);
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-			return error;
+			goto out_cancel;
 		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip,
-				XFS_IOLOCK_EXCL |
+		xfs_trans_ijoin(tp, ip, use_iolock ?
+				XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL :
 				XFS_ILOCK_EXCL);
 		xfs_trans_ihold(tp, ip);
 
@@ -821,6 +823,12 @@ xfs_free_eofblocks(
 					    : XFS_ILOCK_EXCL));
 	}
 	return error;
+
+out_cancel:
+	xfs_trans_cancel(tp, 0);
+	if (use_iolock)
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	return error;
 }
 
 /*
@@ -1117,7 +1125,7 @@ xfs_release(
 		    (!(ip->i_d.di_flags &
 				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
 			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
-			if (error)
+			if (error && error != EAGAIN)
 				return error;
 		}
 	}
@@ -1187,7 +1195,7 @@ xfs_inactive(
 		     (!(ip->i_d.di_flags &
 				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) ||
 		      (ip->i_delayed_blks != 0)))) {
-			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
+			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_NOLOCK);
 			if (error)
 				return VN_INACTIVE_CACHE;
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8GDIaf0056409 for <xfs@oss.sgi.com>; Wed, 16 Sep 2009 08:18:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CAF331A72645
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2009 06:19:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NnRCFM73I4TpYST8 for
	<xfs@oss.sgi.com>; Wed, 16 Sep 2009 06:19:43 -0700 (PDT)
Message-Id: <20090916131942.225072974@bombadil.infradead.org>
Date: Wed, 16 Sep 2009 09:18:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/4] xfs: make sure xfs_sync_fsdata covers the log 
References: <20090916131818.939008605@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-xfs_sync_fsdata
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

From: Dave Chinner <david@fromorbit.com>

We want to always cover the log after writing out the superblock, and
in case of a synchronous writeout make sure we actually wait for the
log to be covered.  That way a filesystem that has been sync()ed can
be considered clean by log recovery.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-09-16 10:04:30.869278510 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-09-16 10:04:41.193004640 -0300
@@ -309,11 +309,15 @@ xfs_sync_attr(
 STATIC int
 xfs_commit_dummy_trans(
 	struct xfs_mount	*mp,
-	uint			log_flags)
+	uint			flags)
 {
 	struct xfs_inode	*ip = mp->m_rootip;
 	struct xfs_trans	*tp;
 	int			error;
+	int			log_flags = XFS_LOG_FORCE;
+
+	if (flags & SYNC_WAIT)
+		log_flags |= XFS_LOG_SYNC;
 
 	/*
 	 * Put a dummy transaction in the log to tell recovery
@@ -331,16 +335,15 @@ xfs_commit_dummy_trans(
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_ihold(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	/* XXX(hch): ignoring the error here.. */
 	error = xfs_trans_commit(tp, 0);
-
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
+	/* the log force ensures this transaction is pushed to disk */
 	xfs_log_force(mp, 0, log_flags);
-	return 0;
+	return error;
 }
 
-int
+int
 xfs_sync_fsdata(
 	struct xfs_mount	*mp,
 	int			flags)
@@ -385,7 +388,20 @@ xfs_sync_fsdata(
 	else
 		XFS_BUF_ASYNC(bp);
 
-	return xfs_bwrite(mp, bp);
+	error = xfs_bwrite(mp, bp);
+	if (error)
+		return error;
+
+	/*
+	 * If this is a data integrity sync make sure all pending buffers
+	 * are flushed out for the log coverage check below.
+	 */
+	if (flags & SYNC_WAIT)
+		xfs_flush_buftarg(mp->m_ddev_targp, 1);
+
+	if (xfs_log_need_covered(mp))
+		error = xfs_commit_dummy_trans(mp, flags);
+	return error;
 
  out_brelse:
 	xfs_buf_relse(bp);
@@ -572,8 +588,6 @@ xfs_sync_worker(
 		/* dgc: errors ignored here */
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
 		error = xfs_sync_fsdata(mp, SYNC_TRYLOCK);
-		if (xfs_log_need_covered(mp))
-			error = xfs_commit_dummy_trans(mp, XFS_LOG_FORCE);
 	}
 	mp->m_sync_seq++;
 	wake_up(&mp->m_wait_single_sync_task);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

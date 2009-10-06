Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96KZIrx091122 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 15:35:18 -0500
Message-Id: <20091006203643.508411288@bombadil.infradead.org>
Date: Tue, 06 Oct 2009 16:29:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] xfs: make sure xfs_sync_fsdata covers the log 
References: <20091006202925.459164320@bombadil.infradead.org>
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
To: aelder@sgi.com, xfs@oss.sgi.com, akpm@linux-foundation.org, sfr@canb.auug.org.au
Cc: linux-fsdevel@vger.kernel.org

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

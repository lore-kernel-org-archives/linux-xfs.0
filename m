Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2CAvh95245510 for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 04:57:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4C7C14217D0
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 02:59:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 48hJLJn1VuNlGgJW for
	<xfs@oss.sgi.com>; Fri, 12 Mar 2010 02:59:16 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Nq2aK-0002GI-3K
	for xfs@oss.sgi.com; Fri, 12 Mar 2010 10:59:16 +0000
Date: Fri, 12 Mar 2010 05:59:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] xfs: remove periodic superblock writeback
Message-ID: <20100312105915.GA8643@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


All modifications to the superblock are done transactional through
xfs_trans_log_buf, so there is no reason to initiate periodic asynchronous
writeback.  This only removes the superblock from the delwri list and will
lead to sub-optimal I/O scheduling.

Cut down xfs_sync_fsdata now that it's only used for synchronous superblock
writes and move the log coverage checks into the two callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-03-11 11:41:36.631253262 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2010-03-11 11:42:09.587004694 +0100
@@ -348,68 +348,24 @@ xfs_commit_dummy_trans(
 
 STATIC int
 xfs_sync_fsdata(
-	struct xfs_mount	*mp,
-	int			flags)
+	struct xfs_mount	*mp)
 {
 	struct xfs_buf		*bp;
-	struct xfs_buf_log_item	*bip;
-	int			error = 0;
-
-	/*
-	 * If this is xfssyncd() then only sync the superblock if we can
-	 * lock it without sleeping and it is not pinned.
-	 */
-	if (flags & SYNC_TRYLOCK) {
-		ASSERT(!(flags & SYNC_WAIT));
-
-		bp = xfs_getsb(mp, XBF_TRYLOCK);
-		if (!bp)
-			goto out;
-
-		bip = XFS_BUF_FSPRIVATE(bp, struct xfs_buf_log_item *);
-		if (!bip || !xfs_buf_item_dirty(bip) || XFS_BUF_ISPINNED(bp))
-			goto out_brelse;
-	} else {
-		bp = xfs_getsb(mp, 0);
-
-		/*
-		 * If the buffer is pinned then push on the log so we won't
-		 * get stuck waiting in the write for someone, maybe
-		 * ourselves, to flush the log.
-		 *
-		 * Even though we just pushed the log above, we did not have
-		 * the superblock buffer locked at that point so it can
-		 * become pinned in between there and here.
-		 */
-		if (XFS_BUF_ISPINNED(bp))
-			xfs_log_force(mp, 0);
-	}
-
-
-	if (flags & SYNC_WAIT)
-		XFS_BUF_UNASYNC(bp);
-	else
-		XFS_BUF_ASYNC(bp);
-
-	error = xfs_bwrite(mp, bp);
-	if (error)
-		return error;
 
 	/*
-	 * If this is a data integrity sync make sure all pending buffers
-	 * are flushed out for the log coverage check below.
+	 * If the buffer is pinned then push on the log so we won't get stuck
+	 * waiting in the write for someone, maybe ourselves, to flush the log.
+	 *
+	 * Even though we just pushed the log above, we did not have the
+	 * superblock buffer locked at that point so it can become pinned in
+	 * between there and here.
 	 */
-	if (flags & SYNC_WAIT)
-		xfs_flush_buftarg(mp->m_ddev_targp, 1);
-
-	if (xfs_log_need_covered(mp))
-		error = xfs_commit_dummy_trans(mp, flags);
-	return error;
+	bp = xfs_getsb(mp, 0);
+	if (XFS_BUF_ISPINNED(bp))
+		xfs_log_force(mp, 0);
 
- out_brelse:
-	xfs_buf_relse(bp);
- out:
-	return error;
+	XFS_BUF_UNASYNC(bp);
+	return xfs_bwrite(mp, bp);
 }
 
 /*
@@ -433,7 +389,7 @@ int
 xfs_quiesce_data(
 	struct xfs_mount	*mp)
 {
-	int error;
+	int			error, error2 = 0;
 
 	/* push non-blocking */
 	xfs_sync_data(mp, 0);
@@ -444,13 +400,20 @@ xfs_quiesce_data(
 	xfs_qm_sync(mp, SYNC_WAIT);
 
 	/* write superblock and hoover up shutdown errors */
-	error = xfs_sync_fsdata(mp, SYNC_WAIT);
+	error = xfs_sync_fsdata(mp);
+
+	/* make sure all delwri buffers are written out */
+	xfs_flush_buftarg(mp->m_ddev_targp, 1);
+
+	/* mark the log as covered if needed */
+	if (xfs_log_need_covered(mp))
+		error2 = xfs_commit_dummy_trans(mp, SYNC_WAIT);
 
 	/* flush data-only devices */
 	if (mp->m_rtdev_targp)
 		XFS_bflush(mp->m_rtdev_targp);
 
-	return error;
+	return error ? error : error2;
 }
 
 STATIC void
@@ -573,9 +536,9 @@ xfs_flush_inodes(
 }
 
 /*
- * Every sync period we need to unpin all items, reclaim inodes, sync
- * quota and write out the superblock. We might need to cover the log
- * to indicate it is idle.
+ * Every sync period we need to unpin all items, reclaim inodes and sync
+ * disk quotas.  We might need to cover the log to indicate that the
+ * filesystem is idle.
  */
 STATIC void
 xfs_sync_worker(
@@ -589,7 +552,8 @@ xfs_sync_worker(
 		xfs_reclaim_inodes(mp, 0);
 		/* dgc: errors ignored here */
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
-		error = xfs_sync_fsdata(mp, SYNC_TRYLOCK);
+		if (xfs_log_need_covered(mp))
+			error = xfs_commit_dummy_trans(mp, 0);
 	}
 	mp->m_sync_seq++;
 	wake_up(&mp->m_wait_single_sync_task);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AGrSIr189841 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:53:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2CF21C7C9CC
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 09:53:27 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	acAalbfzQD0PMZFZ for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 09:53:27 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RDJ6V-0008En-6l
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 16:53:27 +0000
Message-Id: <20111010165327.165557754@bombadil.infradead.org>
Date: Mon, 10 Oct 2011 12:52:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/11] xfs: remove XFS_BUF_STALE and XFS_BUF_SUPER_STALE
References: <20111010165242.656850411@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_BUF_STALE
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2011-10-06 14:37:08.850919140 -0400
+++ xfs/fs/xfs/xfs_attr.c	2011-10-06 14:37:11.010920453 -0400
@@ -2168,7 +2168,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 		 */
 		bp = xfs_incore(mp->m_ddev_targp, dblkno, blkcnt, XBF_TRYLOCK);
 		if (bp) {
-			XFS_BUF_STALE(bp);
+			xfs_buf_stale(bp);
 			xfs_buf_delwri_dequeue(bp);
 			xfs_buf_relse(bp);
 			bp = NULL;
Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-10-06 14:37:08.862918712 -0400
+++ xfs/fs/xfs/xfs_buf.c	2011-10-06 14:37:11.014920137 -0400
@@ -1061,7 +1061,7 @@ xfs_bioerror(
 	XFS_BUF_UNREAD(bp);
 	xfs_buf_delwri_dequeue(bp);
 	XFS_BUF_UNDONE(bp);
-	XFS_BUF_STALE(bp);
+	xfs_buf_stale(bp);
 
 	xfs_buf_ioend(bp, 0);
 
@@ -1090,7 +1090,7 @@ xfs_bioerror_relse(
 	XFS_BUF_UNREAD(bp);
 	xfs_buf_delwri_dequeue(bp);
 	XFS_BUF_DONE(bp);
-	XFS_BUF_STALE(bp);
+	xfs_buf_stale(bp);
 	bp->b_iodone = NULL;
 	if (!(fl & XBF_ASYNC)) {
 		/*
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2011-10-06 14:37:08.870920884 -0400
+++ xfs/fs/xfs/xfs_buf.h	2011-10-06 14:37:11.014920137 -0400
@@ -242,14 +242,8 @@ xfs_buf_target_name(struct xfs_buftarg *
 			    XBF_SYNCIO|XBF_FUA|XBF_FLUSH))
 
 void xfs_buf_stale(struct xfs_buf *bp);
-#define XFS_BUF_STALE(bp)	xfs_buf_stale(bp);
 #define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XBF_STALE)
 #define XFS_BUF_ISSTALE(bp)	((bp)->b_flags & XBF_STALE)
-#define XFS_BUF_SUPER_STALE(bp)	do {				\
-					XFS_BUF_STALE(bp);	\
-					xfs_buf_delwri_dequeue(bp);	\
-					XFS_BUF_DONE(bp);	\
-				} while (0)
 
 #define XFS_BUF_ISDELAYWRITE(bp)	((bp)->b_flags & XBF_DELWRI)
 
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-10-06 14:37:08.882920547 -0400
+++ xfs/fs/xfs/xfs_buf_item.c	2011-10-06 14:37:11.014920137 -0400
@@ -967,7 +967,9 @@ xfs_buf_iodone_callbacks(
 	 * I/O errors, there's no point in giving this a retry.
 	 */
 	if (XFS_FORCED_SHUTDOWN(mp)) {
-		XFS_BUF_SUPER_STALE(bp);
+		xfs_buf_stale(bp);
+		xfs_buf_delwri_dequeue(bp);
+		XFS_BUF_DONE(bp);
 		trace_xfs_buf_item_iodone(bp, _RET_IP_);
 		goto do_callbacks;
 	}
@@ -1006,7 +1008,7 @@ xfs_buf_iodone_callbacks(
 	 * If the write of the buffer was synchronous, we want to make
 	 * sure to return the error to the caller of xfs_bwrite().
 	 */
-	XFS_BUF_STALE(bp);
+	xfs_buf_stale(bp);
 	XFS_BUF_DONE(bp);
 	xfs_buf_delwri_dequeue(bp);
 
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-10-06 14:37:08.894917822 -0400
+++ xfs/fs/xfs/xfs_inode.c	2011-10-06 14:37:11.018917565 -0400
@@ -2469,11 +2469,11 @@ cluster_corrupt_out:
 		 */
 		if (bp->b_iodone) {
 			XFS_BUF_UNDONE(bp);
-			XFS_BUF_STALE(bp);
+			xfs_buf_stale(bp);
 			xfs_buf_ioerror(bp, EIO);
 			xfs_buf_ioend(bp, 0);
 		} else {
-			XFS_BUF_STALE(bp);
+			xfs_buf_stale(bp);
 			xfs_buf_relse(bp);
 		}
 	}
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-10-06 14:37:08.902920983 -0400
+++ xfs/fs/xfs/xfs_log.c	2011-10-06 14:37:11.022918855 -0400
@@ -869,7 +869,7 @@ xlog_iodone(xfs_buf_t *bp)
 	if (XFS_TEST_ERROR((xfs_buf_geterror(bp)), l->l_mp,
 			XFS_ERRTAG_IODONE_IOERR, XFS_RANDOM_IODONE_IOERR)) {
 		xfs_ioerror_alert("xlog_iodone", l->l_mp, bp, XFS_BUF_ADDR(bp));
-		XFS_BUF_STALE(bp);
+		xfs_buf_stale(bp);
 		xfs_force_shutdown(l->l_mp, SHUTDOWN_LOG_IO_ERROR);
 		/*
 		 * This flag will be propagated to the trans-committed
@@ -1235,7 +1235,7 @@ xlog_bdstrat(
 
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		xfs_buf_ioerror(bp, EIO);
-		XFS_BUF_STALE(bp);
+		xfs_buf_stale(bp);
 		xfs_buf_ioend(bp, 0);
 		/*
 		 * It would seem logical to return EIO here, but we rely on
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2011-10-06 14:37:08.914921299 -0400
+++ xfs/fs/xfs/xfs_log_recover.c	2011-10-06 14:37:11.026919015 -0400
@@ -2174,7 +2174,7 @@ xlog_recover_buffer_pass2(
 	    be16_to_cpu(*((__be16 *)xfs_buf_offset(bp, 0))) &&
 	    (XFS_BUF_COUNT(bp) != MAX(log->l_mp->m_sb.sb_blocksize,
 			(__uint32_t)XFS_INODE_CLUSTER_SIZE(log->l_mp)))) {
-		XFS_BUF_STALE(bp);
+		xfs_buf_stale(bp);
 		error = xfs_bwrite(bp);
 	} else {
 		ASSERT(bp->b_target->bt_mount == mp);
Index: xfs/fs/xfs/xfs_rw.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.c	2011-10-06 14:37:08.926918084 -0400
+++ xfs/fs/xfs/xfs_rw.c	2011-10-06 14:37:11.030919219 -0400
@@ -150,7 +150,7 @@ xfs_read_buf(
 		if (bp) {
 			XFS_BUF_UNDONE(bp);
 			xfs_buf_delwri_dequeue(bp);
-			XFS_BUF_STALE(bp);
+			xfs_buf_stale(bp);
 			/*
 			 * brelse clears B_ERROR and b_error
 			 */
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2011-10-06 14:37:08.942920379 -0400
+++ xfs/fs/xfs/xfs_trans_buf.c	2011-10-06 14:37:11.030919219 -0400
@@ -160,8 +160,11 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 	bp = xfs_trans_buf_item_match(tp, target_dev, blkno, len);
 	if (bp != NULL) {
 		ASSERT(xfs_buf_islocked(bp));
-		if (XFS_FORCED_SHUTDOWN(tp->t_mountp))
-			XFS_BUF_SUPER_STALE(bp);
+		if (XFS_FORCED_SHUTDOWN(tp->t_mountp)) {
+			xfs_buf_stale(bp);
+			xfs_buf_delwri_dequeue(bp);
+			XFS_BUF_DONE(bp);
+		}
 
 		/*
 		 * If the buffer is stale then it was binval'ed
@@ -387,7 +390,9 @@ xfs_trans_read_buf(
 	}
 	if (bp->b_error) {
 		error = bp->b_error;
-		XFS_BUF_SUPER_STALE(bp);
+		xfs_buf_stale(bp);
+		xfs_buf_delwri_dequeue(bp);
+		XFS_BUF_DONE(bp);
 		xfs_ioerror_alert("xfs_trans_read_buf", mp,
 				  bp, blkno);
 		if (tp->t_flags & XFS_TRANS_DIRTY)
@@ -740,7 +745,7 @@ xfs_trans_binval(
 	 * rid of it.
 	 */
 	xfs_buf_delwri_dequeue(bp);
-	XFS_BUF_STALE(bp);
+	xfs_buf_stale(bp);
 	bip->bli_flags |= XFS_BLI_STALE;
 	bip->bli_flags &= ~(XFS_BLI_INODE_BUF | XFS_BLI_LOGGED | XFS_BLI_DIRTY);
 	bip->bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

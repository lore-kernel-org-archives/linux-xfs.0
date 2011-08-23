Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7N8TFA2164761 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 03:29:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F27E1DA1885
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 01:29:12 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ubqioCZg7KNdbMIS for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 01:29:12 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QvmMC-00061Y-I1
	for xfs@oss.sgi.com; Tue, 23 Aug 2011 08:29:12 +0000
Message-Id: <20110823082912.512830398@bombadil.infradead.org>
Date: Tue, 23 Aug 2011 04:28:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/11] xfs: call xfs_buf_delwri_queue directly
References: <20110823082802.335389799@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-call-xfs_buf_delwri_queue-directly
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

Unify the ways we add buffers to the delwri queue by always calling
xfs_buf_delwri_queue directly.  The xfs_bdwrite functions is removed and
opencoded in its callers, and the two places setting XBF_DELWRI while a
buffer is locked and expecting xfs_buf_unlock to pick it up are converted
to call xfs_buf_delwri_queue directly, too.  Also replace the
XFS_BUF_UNDELAYWRITE macro with direct calls to xfs_buf_delwri_dequeue
to make the explicit queuing/dequeuing more obvious.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-08-23 03:56:16.198380574 +0200
+++ xfs/fs/xfs/xfs_buf.c	2011-08-23 03:56:36.038273093 +0200
@@ -43,7 +43,6 @@
 
 static kmem_zone_t *xfs_buf_zone;
 STATIC int xfsbufd(void *);
-STATIC void xfs_buf_delwri_queue(xfs_buf_t *);
 
 static struct workqueue_struct *xfslogd_workqueue;
 struct workqueue_struct *xfsdatad_workqueue;
@@ -937,9 +936,6 @@ void
 xfs_buf_unlock(
 	struct xfs_buf		*bp)
 {
-	if ((bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)) == XBF_DELWRI)
-		xfs_buf_delwri_queue(bp);
-
 	XB_CLEAR_OWNER(bp);
 	up(&bp->b_sema);
 
@@ -1036,17 +1032,6 @@ xfs_bwrite(
 	return error;
 }
 
-void
-xfs_bdwrite(
-	void			*mp,
-	struct xfs_buf		*bp)
-{
-	trace_xfs_buf_bdwrite(bp, _RET_IP_);
-
-	xfs_buf_delwri_queue(bp);
-	xfs_buf_relse(bp);
-}
-
 /*
  * Called when we want to stop a buffer from getting written or read.
  * We attach the EIO error, muck with its flags, and call xfs_buf_ioend
@@ -1069,7 +1054,7 @@ xfs_bioerror(
 	 * We're calling xfs_buf_ioend, so delete XBF_DONE flag.
 	 */
 	XFS_BUF_UNREAD(bp);
-	XFS_BUF_UNDELAYWRITE(bp);
+	xfs_buf_delwri_dequeue(bp);
 	XFS_BUF_UNDONE(bp);
 	XFS_BUF_STALE(bp);
 
@@ -1098,7 +1083,7 @@ xfs_bioerror_relse(
 	 * change that interface.
 	 */
 	XFS_BUF_UNREAD(bp);
-	XFS_BUF_UNDELAYWRITE(bp);
+	xfs_buf_delwri_dequeue(bp);
 	XFS_BUF_DONE(bp);
 	XFS_BUF_STALE(bp);
 	bp->b_iodone = NULL;
@@ -1555,7 +1540,7 @@ error:
 /*
  *	Delayed write buffer handling
  */
-STATIC void
+void
 xfs_buf_delwri_queue(
 	xfs_buf_t		*bp)
 {
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2011-08-23 03:55:16.702036227 +0200
+++ xfs/fs/xfs/xfs_buf.h	2011-08-23 03:56:17.315041192 +0200
@@ -198,7 +198,6 @@ extern void xfs_buf_unlock(xfs_buf_t *);
 
 /* Buffer Read and Write Routines */
 extern int xfs_bwrite(struct xfs_mount *mp, struct xfs_buf *bp);
-extern void xfs_bdwrite(void *mp, xfs_buf_t *bp);
 
 extern void xfsbdstrat(struct xfs_mount *, struct xfs_buf *);
 extern int xfs_bdstrat_cb(struct xfs_buf *);
@@ -221,8 +220,9 @@ static inline int xfs_buf_geterror(xfs_b
 extern xfs_caddr_t xfs_buf_offset(xfs_buf_t *, size_t);
 
 /* Delayed Write Buffer Routines */
-extern void xfs_buf_delwri_dequeue(xfs_buf_t *);
-extern void xfs_buf_delwri_promote(xfs_buf_t *);
+extern void xfs_buf_delwri_queue(struct xfs_buf *);
+extern void xfs_buf_delwri_dequeue(struct xfs_buf *);
+extern void xfs_buf_delwri_promote(struct xfs_buf *);
 
 /* Buffer Daemon Setup Routines */
 extern int xfs_buf_init(void);
@@ -251,8 +251,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 					XFS_BUF_DONE(bp);	\
 				} while (0)
 
-#define XFS_BUF_DELAYWRITE(bp)		((bp)->b_flags |= XBF_DELWRI)
-#define XFS_BUF_UNDELAYWRITE(bp)	xfs_buf_delwri_dequeue(bp)
 #define XFS_BUF_ISDELAYWRITE(bp)	((bp)->b_flags & XBF_DELWRI)
 
 #define XFS_BUF_DONE(bp)	((bp)->b_flags |= XBF_DONE)
Index: xfs/fs/xfs/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trace.h	2011-08-23 03:55:16.705369543 +0200
+++ xfs/fs/xfs/xfs_trace.h	2011-08-23 03:56:17.318374507 +0200
@@ -320,7 +320,6 @@ DEFINE_BUF_EVENT(xfs_buf_rele);
 DEFINE_BUF_EVENT(xfs_buf_iodone);
 DEFINE_BUF_EVENT(xfs_buf_iorequest);
 DEFINE_BUF_EVENT(xfs_buf_bawrite);
-DEFINE_BUF_EVENT(xfs_buf_bdwrite);
 DEFINE_BUF_EVENT(xfs_buf_lock);
 DEFINE_BUF_EVENT(xfs_buf_lock_done);
 DEFINE_BUF_EVENT(xfs_buf_trylock);
Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-08-23 03:55:16.712036173 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-08-23 03:56:17.318374507 +0200
@@ -1243,8 +1243,10 @@ xfs_qm_dqflush(
 
 	if (flags & SYNC_WAIT)
 		error = xfs_bwrite(mp, bp);
-	else
-		xfs_bdwrite(mp, bp);
+	else {
+		xfs_buf_delwri_queue(bp);
+		xfs_buf_relse(bp);
+	}
 
 	trace_xfs_dqflush_done(dqp);
 
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-08-23 03:55:16.718702803 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-08-23 03:56:17.321707822 +0200
@@ -1296,7 +1296,8 @@ xfs_qm_dqiter_bufs(
 			break;
 
 		xfs_qm_reset_dqcounts(mp, bp, firstid, type);
-		xfs_bdwrite(mp, bp);
+		xfs_buf_delwri_queue(bp);
+		xfs_buf_relse(bp);
 		/*
 		 * goto the next block.
 		 */
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2011-08-23 03:55:16.725369434 +0200
+++ xfs/fs/xfs/xfs_attr.c	2011-08-23 03:56:17.325041137 +0200
@@ -2189,7 +2189,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 		bp = xfs_incore(mp->m_ddev_targp, dblkno, blkcnt, XBF_TRYLOCK);
 		if (bp) {
 			XFS_BUF_STALE(bp);
-			XFS_BUF_UNDELAYWRITE(bp);
+			xfs_buf_delwri_dequeue(bp);
 			xfs_buf_relse(bp);
 			bp = NULL;
 		}
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-08-23 03:55:16.732036066 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2011-08-23 03:56:17.325041137 +0200
@@ -992,7 +992,7 @@ xfs_buf_iodone_callbacks(
 		xfs_buf_ioerror(bp, 0); /* errno of 0 unsets the flag */
 
 		if (!XFS_BUF_ISSTALE(bp)) {
-			XFS_BUF_DELAYWRITE(bp);
+			xfs_buf_delwri_queue(bp);
 			XFS_BUF_DONE(bp);
 		}
 		ASSERT(bp->b_iodone != NULL);
@@ -1007,7 +1007,7 @@ xfs_buf_iodone_callbacks(
 	 */
 	XFS_BUF_STALE(bp);
 	XFS_BUF_DONE(bp);
-	XFS_BUF_UNDELAYWRITE(bp);
+	xfs_buf_delwri_dequeue(bp);
 
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
 
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-08-23 03:55:16.735369381 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-08-23 03:56:17.328374452 +0200
@@ -2598,8 +2598,10 @@ xfs_iflush(
 
 	if (flags & SYNC_WAIT)
 		error = xfs_bwrite(mp, bp);
-	else
-		xfs_bdwrite(mp, bp);
+	else {
+		xfs_buf_delwri_queue(bp);
+		xfs_buf_relse(bp);
+	}
 	return error;
 
 corrupt_out:
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2011-08-23 03:55:16.742036011 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2011-08-23 03:56:17.331707768 +0200
@@ -2176,7 +2176,8 @@ xlog_recover_buffer_pass2(
 	} else {
 		ASSERT(bp->b_target->bt_mount == mp);
 		bp->b_iodone = xlog_recover_iodone;
-		xfs_bdwrite(mp, bp);
+		xfs_buf_delwri_queue(bp);
+		xfs_buf_relse(bp);
 	}
 
 	return (error);
@@ -2439,7 +2440,8 @@ xlog_recover_inode_pass2(
 write_inode_buffer:
 	ASSERT(bp->b_target->bt_mount == mp);
 	bp->b_iodone = xlog_recover_iodone;
-	xfs_bdwrite(mp, bp);
+	xfs_buf_delwri_queue(bp);
+	xfs_buf_relse(bp);
 error:
 	if (need_free)
 		kmem_free(in_f);
@@ -2561,7 +2563,8 @@ xlog_recover_dquot_pass2(
 	ASSERT(dq_f->qlf_size == 2);
 	ASSERT(bp->b_target->bt_mount == mp);
 	bp->b_iodone = xlog_recover_iodone;
-	xfs_bdwrite(mp, bp);
+	xfs_buf_delwri_queue(bp);
+	xfs_buf_relse(bp);
 
 	return (0);
 }
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2011-08-23 03:55:16.748702641 +0200
+++ xfs/fs/xfs/xfs_mount.c	2011-08-23 03:56:17.331707768 +0200
@@ -1612,7 +1612,7 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 
 		XFS_BUF_UNDONE(sbp);
 		XFS_BUF_UNREAD(sbp);
-		XFS_BUF_UNDELAYWRITE(sbp);
+		xfs_buf_delwri_dequeue(sbp);
 		XFS_BUF_WRITE(sbp);
 		XFS_BUF_UNASYNC(sbp);
 		ASSERT(sbp->b_target == mp->m_ddev_targp);
Index: xfs/fs/xfs/xfs_rw.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.c	2011-08-23 03:55:16.755369271 +0200
+++ xfs/fs/xfs/xfs_rw.c	2011-08-23 03:56:17.335041084 +0200
@@ -149,7 +149,7 @@ xfs_read_buf(
 		}
 		if (bp) {
 			XFS_BUF_UNDONE(bp);
-			XFS_BUF_UNDELAYWRITE(bp);
+			xfs_buf_delwri_dequeue(bp);
 			XFS_BUF_STALE(bp);
 			/*
 			 * brelse clears B_ERROR and b_error
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2011-08-23 03:55:16.762035902 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2011-08-23 03:56:17.335041084 +0200
@@ -643,13 +643,14 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 	 * inside the b_bdstrat callback so that this won't get written to
 	 * disk.
 	 */
-	XFS_BUF_DELAYWRITE(bp);
 	XFS_BUF_DONE(bp);
 
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	bp->b_iodone = xfs_buf_iodone_callbacks;
 	bip->bli_item.li_cb = xfs_buf_iodone;
 
+	xfs_buf_delwri_queue(bp);
+
 	trace_xfs_trans_log_buf(bip);
 
 	/*
@@ -738,7 +739,7 @@ xfs_trans_binval(
 	 * We set the stale bit in the buffer as well since we're getting
 	 * rid of it.
 	 */
-	XFS_BUF_UNDELAYWRITE(bp);
+	xfs_buf_delwri_dequeue(bp);
 	XFS_BUF_STALE(bp);
 	bip->bli_flags |= XFS_BLI_STALE;
 	bip->bli_flags &= ~(XFS_BLI_INODE_BUF | XFS_BLI_LOGGED | XFS_BLI_DIRTY);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

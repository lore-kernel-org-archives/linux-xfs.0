Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DMHGJ2194824 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 16:17:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C16931C4D172
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 14:18:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2WofqyzN4VQMrseI for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2010 14:18:12 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NVBXY-0007Xn-BA
	for xfs@oss.sgi.com; Wed, 13 Jan 2010 22:18:12 +0000
Message-Id: <20100113221812.190183785@bombadil.infradead.org>
Date: Wed, 13 Jan 2010 17:17:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] xfs: move more buffer helpers into xfs_buf.c
References: <20100113221755.686033903@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-move-buf-funcs
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

Move xfsbdstrat and xfs_bdstrat_cb from xfs_lrw.c and xfs_bioerror and
xfs_bioerror_relse from xfs_rw.c into xfs_buf.c.  This also means
xfs_bioerror and xfs_bioerror_relse can be marked static now.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2010-01-08 14:36:12.997003975 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2010-01-08 14:49:45.449006546 +0100
@@ -1121,6 +1121,126 @@ xfs_bdwrite(
 	xfs_buf_delwri_queue(bp, 1);
 }
 
+/*
+ * Called when we want to stop a buffer from getting written or read.
+ * We attach the EIO error, muck with its flags, and call biodone
+ * so that the proper iodone callbacks get called.
+ */
+STATIC int
+xfs_bioerror(
+	xfs_buf_t *bp)
+{
+#ifdef XFSERRORDEBUG
+	ASSERT(XFS_BUF_ISREAD(bp) || bp->b_iodone);
+#endif
+
+	/*
+	 * No need to wait until the buffer is unpinned, we aren't flushing it.
+	 */
+	XFS_BUF_ERROR(bp, EIO);
+
+	/*
+	 * We're calling biodone, so delete XBF_DONE flag.
+	 */
+	XFS_BUF_UNREAD(bp);
+	XFS_BUF_UNDELAYWRITE(bp);
+	XFS_BUF_UNDONE(bp);
+	XFS_BUF_STALE(bp);
+
+	XFS_BUF_CLR_BDSTRAT_FUNC(bp);
+	xfs_biodone(bp);
+
+	return EIO;
+}
+
+/*
+ * Same as xfs_bioerror, except that we are releasing the buffer
+ * here ourselves, and avoiding the biodone call.
+ * This is meant for userdata errors; metadata bufs come with
+ * iodone functions attached, so that we can track down errors.
+ */
+STATIC int
+xfs_bioerror_relse(
+	struct xfs_buf	*bp)
+{
+	int64_t		fl = XFS_BUF_BFLAGS(bp);
+	/*
+	 * No need to wait until the buffer is unpinned.
+	 * We aren't flushing it.
+	 *
+	 * chunkhold expects B_DONE to be set, whether
+	 * we actually finish the I/O or not. We don't want to
+	 * change that interface.
+	 */
+	XFS_BUF_UNREAD(bp);
+	XFS_BUF_UNDELAYWRITE(bp);
+	XFS_BUF_DONE(bp);
+	XFS_BUF_STALE(bp);
+	XFS_BUF_CLR_IODONE_FUNC(bp);
+	XFS_BUF_CLR_BDSTRAT_FUNC(bp);
+	if (!(fl & XFS_B_ASYNC)) {
+		/*
+		 * Mark b_error and B_ERROR _both_.
+		 * Lot's of chunkcache code assumes that.
+		 * There's no reason to mark error for
+		 * ASYNC buffers.
+		 */
+		XFS_BUF_ERROR(bp, EIO);
+		XFS_BUF_FINISH_IOWAIT(bp);
+	} else {
+		xfs_buf_relse(bp);
+	}
+
+	return EIO;
+}
+
+
+/*
+ * All xfs metadata buffers except log state machine buffers
+ * get this attached as their b_bdstrat callback function.
+ * This is so that we can catch a buffer
+ * after prematurely unpinning it to forcibly shutdown the filesystem.
+ */
+int
+xfs_bdstrat_cb(
+	struct xfs_buf	*bp)
+{
+	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
+		trace_xfs_bdstrat_shut(bp, _RET_IP_);
+		/*
+		 * Metadata write that didn't get logged but
+		 * written delayed anyway. These aren't associated
+		 * with a transaction, and can be ignored.
+		 */
+		if (!bp->b_iodone && !XFS_BUF_ISREAD(bp))
+			return xfs_bioerror_relse(bp);
+		else
+			return xfs_bioerror(bp);
+	}
+
+	xfs_buf_iorequest(bp);
+	return 0;
+}
+
+/*
+ * Wrapper around bdstrat so that we can stop data from going to disk in case
+ * we are shutting down the filesystem.  Typically user data goes thru this
+ * path; one of the exceptions is the superblock.
+ */
+void
+xfsbdstrat(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp)
+{
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		trace_xfs_bdstrat_shut(bp, _RET_IP_);
+		xfs_bioerror_relse(bp);
+		return;
+	}
+
+	xfs_buf_iorequest(bp);
+}
+
 STATIC void
 _xfs_buf_ioend(
 	xfs_buf_t		*bp,
Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2010-01-08 14:37:05.433254150 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2010-01-08 14:37:27.189016082 +0100
@@ -235,6 +235,10 @@ extern void xfs_buf_unlock(xfs_buf_t *);
 extern int xfs_bwrite(struct xfs_mount *mp, struct xfs_buf *bp);
 extern int xfs_bawrite(void *mp, xfs_buf_t *bp);
 extern void xfs_bdwrite(void *mp, xfs_buf_t *bp);
+
+extern void xfsbdstrat(struct xfs_mount *, struct xfs_buf *);
+extern int xfs_bdstrat_cb(struct xfs_buf *);
+
 extern void xfs_buf_ioend(xfs_buf_t *,	int);
 extern void xfs_buf_ioerror(xfs_buf_t *, int);
 extern int xfs_buf_iorequest(xfs_buf_t *);
Index: xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2010-01-08 14:36:12.979003708 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_lrw.c	2010-01-08 14:36:31.450260193 +0100
@@ -784,53 +784,6 @@ write_retry:
 }
 
 /*
- * All xfs metadata buffers except log state machine buffers
- * get this attached as their b_bdstrat callback function.
- * This is so that we can catch a buffer
- * after prematurely unpinning it to forcibly shutdown the filesystem.
- */
-int
-xfs_bdstrat_cb(struct xfs_buf *bp)
-{
-	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
-		trace_xfs_bdstrat_shut(bp, _RET_IP_);
-		/*
-		 * Metadata write that didn't get logged but
-		 * written delayed anyway. These aren't associated
-		 * with a transaction, and can be ignored.
-		 */
-		if (XFS_BUF_IODONE_FUNC(bp) == NULL &&
-		    (XFS_BUF_ISREAD(bp)) == 0)
-			return (xfs_bioerror_relse(bp));
-		else
-			return (xfs_bioerror(bp));
-	}
-
-	xfs_buf_iorequest(bp);
-	return 0;
-}
-
-/*
- * Wrapper around bdstrat so that we can stop data from going to disk in case
- * we are shutting down the filesystem.  Typically user data goes thru this
- * path; one of the exceptions is the superblock.
- */
-void
-xfsbdstrat(
-	struct xfs_mount	*mp,
-	struct xfs_buf		*bp)
-{
-	ASSERT(mp);
-	if (!XFS_FORCED_SHUTDOWN(mp)) {
-		xfs_buf_iorequest(bp);
-		return;
-	}
-
-	trace_xfs_bdstrat_shut(bp, _RET_IP_);
-	xfs_bioerror_relse(bp);
-}
-
-/*
  * If the underlying (data/log/rt) device is readonly, there are some
  * operations that cannot proceed.
  */
Index: xfs/fs/xfs/linux-2.6/xfs_lrw.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_lrw.h	2010-01-08 14:37:05.420004139 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_lrw.h	2010-01-08 14:37:10.786008356 +0100
@@ -22,9 +22,6 @@ struct xfs_mount;
 struct xfs_inode;
 struct xfs_buf;
 
-/* errors from xfsbdstrat() must be extracted from the buffer */
-extern void xfsbdstrat(struct xfs_mount *, struct xfs_buf *);
-extern int xfs_bdstrat_cb(struct xfs_buf *);
 extern int xfs_dev_is_read_only(struct xfs_mount *, char *);
 
 extern int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
Index: xfs/fs/xfs/xfs_rw.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.c	2010-01-08 14:37:36.052026657 +0100
+++ xfs/fs/xfs/xfs_rw.c	2010-01-08 14:38:01.461318269 +0100
@@ -153,88 +153,6 @@ xfs_do_force_shutdown(
 	}
 }
 
-
-/*
- * Called when we want to stop a buffer from getting written or read.
- * We attach the EIO error, muck with its flags, and call biodone
- * so that the proper iodone callbacks get called.
- */
-int
-xfs_bioerror(
-	xfs_buf_t *bp)
-{
-
-#ifdef XFSERRORDEBUG
-	ASSERT(XFS_BUF_ISREAD(bp) || bp->b_iodone);
-#endif
-
-	/*
-	 * No need to wait until the buffer is unpinned.
-	 * We aren't flushing it.
-	 */
-	XFS_BUF_ERROR(bp, EIO);
-	/*
-	 * We're calling biodone, so delete B_DONE flag. Either way
-	 * we have to call the iodone callback, and calling biodone
-	 * probably is the best way since it takes care of
-	 * GRIO as well.
-	 */
-	XFS_BUF_UNREAD(bp);
-	XFS_BUF_UNDELAYWRITE(bp);
-	XFS_BUF_UNDONE(bp);
-	XFS_BUF_STALE(bp);
-
-	XFS_BUF_CLR_BDSTRAT_FUNC(bp);
-	xfs_biodone(bp);
-
-	return (EIO);
-}
-
-/*
- * Same as xfs_bioerror, except that we are releasing the buffer
- * here ourselves, and avoiding the biodone call.
- * This is meant for userdata errors; metadata bufs come with
- * iodone functions attached, so that we can track down errors.
- */
-int
-xfs_bioerror_relse(
-	xfs_buf_t *bp)
-{
-	int64_t fl;
-
-	ASSERT(XFS_BUF_IODONE_FUNC(bp) != xfs_buf_iodone_callbacks);
-	ASSERT(XFS_BUF_IODONE_FUNC(bp) != xlog_iodone);
-
-	fl = XFS_BUF_BFLAGS(bp);
-	/*
-	 * No need to wait until the buffer is unpinned.
-	 * We aren't flushing it.
-	 *
-	 * chunkhold expects B_DONE to be set, whether
-	 * we actually finish the I/O or not. We don't want to
-	 * change that interface.
-	 */
-	XFS_BUF_UNREAD(bp);
-	XFS_BUF_UNDELAYWRITE(bp);
-	XFS_BUF_DONE(bp);
-	XFS_BUF_STALE(bp);
-	XFS_BUF_CLR_IODONE_FUNC(bp);
-	XFS_BUF_CLR_BDSTRAT_FUNC(bp);
-	if (!(fl & XFS_B_ASYNC)) {
-		/*
-		 * Mark b_error and B_ERROR _both_.
-		 * Lot's of chunkcache code assumes that.
-		 * There's no reason to mark error for
-		 * ASYNC buffers.
-		 */
-		XFS_BUF_ERROR(bp, EIO);
-		XFS_BUF_FINISH_IOWAIT(bp);
-	} else {
-		xfs_buf_relse(bp);
-	}
-	return (EIO);
-}
-
 /*
  * Prints out an ALERT message about I/O error.
  */
Index: xfs/fs/xfs/xfs_rw.h
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.h	2010-01-08 14:38:21.464003870 +0100
+++ xfs/fs/xfs/xfs_rw.h	2010-01-08 14:38:38.516035769 +0100
@@ -40,8 +40,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_
  * Prototypes for functions in xfs_rw.c.
  */
 extern int xfs_write_clear_setuid(struct xfs_inode *ip);
-extern int xfs_bioerror(struct xfs_buf *bp);
-extern int xfs_bioerror_relse(struct xfs_buf *bp);
 extern int xfs_read_buf(struct xfs_mount *mp, xfs_buftarg_t *btp,
 			xfs_daddr_t blkno, int len, uint flags,
 			struct xfs_buf **bpp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

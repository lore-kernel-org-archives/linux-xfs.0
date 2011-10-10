Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AGrTwl189860 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:53:30 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C537B16BAE60
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 10:00:39 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	tZTekpbbo5CSjMrj for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 10:00:39 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RDJ6V-0008GL-ND
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 16:53:27 +0000
Message-Id: <20111010165327.677374730@bombadil.infradead.org>
Date: Mon, 10 Oct 2011 12:52:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/11] xfs: clean up xfs_ioerror_alert
References: <20111010165242.656850411@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_ioerror_alert
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

Instead of passing the block number and mount structure explicitly
get them off the bp and fix make the argument order more natural.

Also move it to xfs_buf.c and stop printing the device name given
that we already get the fs name as part of xfs_alert, and we know
what device is operates on because of the caller that gets printed,
finally rename it to xfs_buf_ioerror_alert and pass __func__ as
argument where it makes sense.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-10-06 16:56:56.572145911 -0400
+++ xfs/fs/xfs/xfs_buf.c	2011-10-07 10:23:33.469017596 -0400
@@ -1004,6 +1004,17 @@ xfs_buf_ioerror(
 	trace_xfs_buf_ioerror(bp, error, _RET_IP_);
 }
 
+void
+xfs_buf_ioerror_alert(
+	struct xfs_buf		*bp,
+	const char		*func)
+{
+	xfs_alert(bp->b_target->bt_mount,
+"metadata I/O error: block 0x%llx (\"%s\") error %d buf count %zd",
+		(__uint64_t)XFS_BUF_ADDR(bp), func,
+		bp->b_error, XFS_BUF_COUNT(bp));
+}
+
 int
 xfs_bwrite(
 	struct xfs_buf		*bp)
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2011-10-06 16:56:56.572145911 -0400
+++ xfs/fs/xfs/xfs_buf.h	2011-10-07 10:21:35.348517109 -0400
@@ -205,6 +205,7 @@ extern int xfs_bdstrat_cb(struct xfs_buf
 
 extern void xfs_buf_ioend(xfs_buf_t *,	int);
 extern void xfs_buf_ioerror(xfs_buf_t *, int);
+extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
 extern int xfs_buf_iorequest(xfs_buf_t *);
 extern int xfs_buf_iowait(xfs_buf_t *);
 extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-10-06 16:56:56.576173159 -0400
+++ xfs/fs/xfs/xfs_log.c	2011-10-07 10:26:21.288518175 -0400
@@ -868,7 +868,7 @@ xlog_iodone(xfs_buf_t *bp)
 	 */
 	if (XFS_TEST_ERROR((xfs_buf_geterror(bp)), l->l_mp,
 			XFS_ERRTAG_IODONE_IOERR, XFS_RANDOM_IODONE_IOERR)) {
-		xfs_ioerror_alert("xlog_iodone", l->l_mp, bp, XFS_BUF_ADDR(bp));
+		xfs_buf_ioerror_alert(bp, __func__);
 		xfs_buf_stale(bp);
 		xfs_force_shutdown(l->l_mp, SHUTDOWN_LOG_IO_ERROR);
 		/*
@@ -1375,9 +1375,9 @@ xlog_sync(xlog_t		*log,
 	 */
 	XFS_BUF_WRITE(bp);
 
-	if ((error = xlog_bdstrat(bp))) {
-		xfs_ioerror_alert("xlog_sync", log->l_mp, bp,
-				  XFS_BUF_ADDR(bp));
+	error = xlog_bdstrat(bp);
+	if (error) {
+		xfs_buf_ioerror_alert(bp, "xlog_sync");
 		return error;
 	}
 	if (split) {
@@ -1411,9 +1411,9 @@ xlog_sync(xlog_t		*log,
 		/* account for internal log which doesn't start at block #0 */
 		XFS_BUF_SET_ADDR(bp, XFS_BUF_ADDR(bp) + log->l_logBBstart);
 		XFS_BUF_WRITE(bp);
-		if ((error = xlog_bdstrat(bp))) {
-			xfs_ioerror_alert("xlog_sync (split)", log->l_mp,
-					  bp, XFS_BUF_ADDR(bp));
+		error = xlog_bdstrat(bp);
+		if (error) {
+			xfs_buf_ioerror_alert(bp, "xlog_sync (split)");
 			return error;
 		}
 	}
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2011-10-06 16:56:11.012199805 -0400
+++ xfs/fs/xfs/xfs_log_recover.c	2011-10-07 10:25:55.480875753 -0400
@@ -183,8 +183,7 @@ xlog_bread_noalign(
 	xfsbdstrat(log->l_mp, bp);
 	error = xfs_buf_iowait(bp);
 	if (error)
-		xfs_ioerror_alert("xlog_bread", log->l_mp,
-				  bp, XFS_BUF_ADDR(bp));
+		xfs_buf_ioerror_alert(bp, __func__);
 	return error;
 }
 
@@ -269,10 +268,8 @@ xlog_bwrite(
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
 
 	error = xfs_bwrite(bp);
-	if (error) {
-		xfs_ioerror_alert("xlog_bwrite", log->l_mp,
-				  bp, XFS_BUF_ADDR(bp));
-	}
+	if (error)
+		xfs_buf_ioerror_alert(bp, __func__);
 	xfs_buf_relse(bp);
 	return error;
 }
@@ -364,9 +361,7 @@ xlog_recover_iodone(
 		 * We're not going to bother about retrying
 		 * this during recovery. One strike!
 		 */
-		xfs_ioerror_alert("xlog_recover_iodone",
-					bp->b_target->bt_mount, bp,
-					XFS_BUF_ADDR(bp));
+		xfs_buf_ioerror_alert(bp, __func__);
 		xfs_force_shutdown(bp->b_target->bt_mount,
 					SHUTDOWN_META_IO_ERROR);
 	}
@@ -2138,8 +2133,7 @@ xlog_recover_buffer_pass2(
 		return XFS_ERROR(ENOMEM);
 	error = bp->b_error;
 	if (error) {
-		xfs_ioerror_alert("xlog_recover_do..(read#1)", mp,
-				  bp, buf_f->blf_blkno);
+		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#1)");
 		xfs_buf_relse(bp);
 		return error;
 	}
@@ -2234,8 +2228,7 @@ xlog_recover_inode_pass2(
 	}
 	error = bp->b_error;
 	if (error) {
-		xfs_ioerror_alert("xlog_recover_do..(read#2)", mp,
-				  bp, in_f->ilf_blkno);
+		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#2)");
 		xfs_buf_relse(bp);
 		goto error;
 	}
@@ -2542,8 +2535,7 @@ xlog_recover_dquot_pass2(
 			     XFS_FSB_TO_BB(mp, dq_f->qlf_len),
 			     0, &bp);
 	if (error) {
-		xfs_ioerror_alert("xlog_recover_do..(read#3)", mp,
-				  bp, dq_f->qlf_blkno);
+		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#3)");
 		return error;
 	}
 	ASSERT(bp);
@@ -3695,8 +3687,7 @@ xlog_do_recover(
 	xfsbdstrat(log->l_mp, bp);
 	error = xfs_buf_iowait(bp);
 	if (error) {
-		xfs_ioerror_alert("xlog_do_recover",
-				  log->l_mp, bp, XFS_BUF_ADDR(bp));
+		xfs_buf_ioerror_alert(bp, __func__);
 		ASSERT(0);
 		xfs_buf_relse(bp);
 		return error;
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2011-10-06 16:55:46.200146955 -0400
+++ xfs/fs/xfs/xfs_mount.c	2011-10-07 10:25:59.917017490 -0400
@@ -1610,8 +1610,7 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 		xfsbdstrat(mp, sbp);
 		error = xfs_buf_iowait(sbp);
 		if (error)
-			xfs_ioerror_alert("xfs_unmountfs_writesb",
-					  mp, sbp, XFS_BUF_ADDR(sbp));
+			xfs_buf_ioerror_alert(sbp, __func__);
 		xfs_buf_relse(sbp);
 	}
 	return error;
Index: xfs/fs/xfs/xfs_rw.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.c	2011-10-06 16:56:55.328221163 -0400
+++ xfs/fs/xfs/xfs_rw.c	2011-10-07 10:26:04.905017141 -0400
@@ -92,24 +92,6 @@ xfs_do_force_shutdown(
 }
 
 /*
- * Prints out an ALERT message about I/O error.
- */
-void
-xfs_ioerror_alert(
-	char			*func,
-	struct xfs_mount	*mp,
-	xfs_buf_t		*bp,
-	xfs_daddr_t		blkno)
-{
-	xfs_alert(mp,
-		 "I/O error occurred: meta-data dev %s block 0x%llx"
-		 "       (\"%s\") error %d buf count %zd",
-		xfs_buf_target_name(bp->b_target),
-		(__uint64_t)blkno, func,
-		bp->b_error, XFS_BUF_COUNT(bp));
-}
-
-/*
  * This isn't an absolute requirement, but it is
  * just a good idea to call xfs_read_buf instead of
  * directly doing a read_buf call. For one, we shouldn't
@@ -143,7 +125,7 @@ xfs_read_buf(
 	} else {
 		*bpp = NULL;
 		if (error) {
-			xfs_ioerror_alert("xfs_read_buf", mp, bp, XFS_BUF_ADDR(bp));
+			xfs_buf_ioerror_alert(bp, __func__);
 		} else {
 			error = XFS_ERROR(EIO);
 		}
Index: xfs/fs/xfs/xfs_rw.h
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.h	2011-10-06 16:55:46.220145004 -0400
+++ xfs/fs/xfs/xfs_rw.h	2011-10-06 16:56:57.588174692 -0400
@@ -42,8 +42,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_
 extern int xfs_read_buf(struct xfs_mount *mp, xfs_buftarg_t *btp,
 			xfs_daddr_t blkno, int len, uint flags,
 			struct xfs_buf **bpp);
-extern void xfs_ioerror_alert(char *func, struct xfs_mount *mp,
-				xfs_buf_t *bp, xfs_daddr_t blkno);
 extern xfs_extlen_t xfs_get_extsz_hint(struct xfs_inode *ip);
 
 #endif /* __XFS_RW_H__ */
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2011-10-06 16:56:55.332149597 -0400
+++ xfs/fs/xfs/xfs_trans_buf.c	2011-10-07 10:26:09.024516569 -0400
@@ -296,8 +296,7 @@ xfs_trans_read_buf(
 
 		if (bp->b_error) {
 			error = bp->b_error;
-			xfs_ioerror_alert("xfs_trans_read_buf", mp,
-					  bp, blkno);
+			xfs_buf_ioerror_alert(bp, __func__);
 			xfs_buf_relse(bp);
 			return error;
 		}
@@ -339,8 +338,7 @@ xfs_trans_read_buf(
 			xfsbdstrat(tp->t_mountp, bp);
 			error = xfs_buf_iowait(bp);
 			if (error) {
-				xfs_ioerror_alert("xfs_trans_read_buf", mp,
-						  bp, blkno);
+				xfs_buf_ioerror_alert(bp, __func__);
 				xfs_buf_relse(bp);
 				/*
 				 * We can gracefully recover from most read
@@ -391,8 +389,7 @@ xfs_trans_read_buf(
 		error = bp->b_error;
 		xfs_buf_stale(bp);
 		XFS_BUF_DONE(bp);
-		xfs_ioerror_alert("xfs_trans_read_buf", mp,
-				  bp, blkno);
+		xfs_buf_ioerror_alert(bp, __func__);
 		if (tp->t_flags & XFS_TRANS_DIRTY)
 			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
 		xfs_buf_relse(bp);
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2011-10-06 16:55:46.248145273 -0400
+++ xfs/fs/xfs/xfs_vnodeops.c	2011-10-07 10:28:35.269018664 -0400
@@ -87,8 +87,7 @@ xfs_readlink_bmap(
 			return XFS_ERROR(ENOMEM);
 		error = bp->b_error;
 		if (error) {
-			xfs_ioerror_alert("xfs_readlink",
-				  ip->i_mount, bp, XFS_BUF_ADDR(bp));
+			xfs_buf_ioerror_alert(bp, __func__);
 			xfs_buf_relse(bp);
 			goto out;
 		}
@@ -1993,8 +1992,8 @@ xfs_zero_remaining_bytes(
 		xfsbdstrat(mp, bp);
 		error = xfs_buf_iowait(bp);
 		if (error) {
-			xfs_ioerror_alert("xfs_zero_remaining_bytes(read)",
-					  mp, bp, XFS_BUF_ADDR(bp));
+			xfs_buf_ioerror_alert(bp,
+					"xfs_zero_remaining_bytes(read)");
 			break;
 		}
 		memset(bp->b_addr +
@@ -2006,8 +2005,8 @@ xfs_zero_remaining_bytes(
 		xfsbdstrat(mp, bp);
 		error = xfs_buf_iowait(bp);
 		if (error) {
-			xfs_ioerror_alert("xfs_zero_remaining_bytes(write)",
-					  mp, bp, XFS_BUF_ADDR(bp));
+			xfs_buf_ioerror_alert(bp,
+					"xfs_zero_remaining_bytes(write)");
 			break;
 		}
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

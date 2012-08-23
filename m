Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52mt6134686 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:48 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kxv3VmunPWGeOr1K for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:32 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZg-0003Ei-56
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:20 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZf-0003cP-Vn
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 016/102] xfs: clean up xfs_ioerror_alert
Date: Thu, 23 Aug 2012 15:01:34 +1000
Message-Id: <1345698180-13612-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 901796afca0d31d97bf6d1bf2ab251a93a4b8c83

Instead of passing the block number and mount structure explicitly
get them off the bp and fix make the argument order more natural.

Also move it to xfs_buf.c and stop printing the device name given
that we already get the fs name as part of xfs_alert, and we know
what device is operates on because of the caller that gets printed,
finally rename it to xfs_buf_ioerror_alert and pass __func__ as
argument where it makes sense.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   11 +++++++++++
 fs/xfs/linux-2.6/xfs_buf.h |    1 +
 fs/xfs/xfs_log.c           |   14 +++++++-------
 fs/xfs/xfs_log_recover.c   |   25 +++++++++----------------
 fs/xfs/xfs_mount.c         |    3 +--
 fs/xfs/xfs_rw.c            |   20 +-------------------
 fs/xfs/xfs_rw.h            |    2 --
 fs/xfs/xfs_trans_buf.c     |    9 +++------
 fs/xfs/xfs_vnodeops.c      |   11 +++++------
 9 files changed, 38 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 449ba57..82fe480 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1028,6 +1028,17 @@ xfs_buf_ioerror(
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
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index ee3714b..71d6698 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -207,6 +207,7 @@ extern int xfs_bdstrat_cb(struct xfs_buf *);
 
 extern void xfs_buf_ioend(xfs_buf_t *,	int);
 extern void xfs_buf_ioerror(xfs_buf_t *, int);
+extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
 extern int xfs_buf_iorequest(xfs_buf_t *);
 extern int xfs_buf_iowait(xfs_buf_t *);
 extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8700411..b180b55 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -886,7 +886,7 @@ xlog_iodone(xfs_buf_t *bp)
 	 */
 	if (XFS_TEST_ERROR((XFS_BUF_GETERROR(bp)), l->l_mp,
 			XFS_ERRTAG_IODONE_IOERR, XFS_RANDOM_IODONE_IOERR)) {
-		xfs_ioerror_alert("xlog_iodone", l->l_mp, bp, XFS_BUF_ADDR(bp));
+		xfs_buf_ioerror_alert(bp, __func__);
 		XFS_BUF_STALE(bp);
 		xfs_force_shutdown(l->l_mp, SHUTDOWN_LOG_IO_ERROR);
 		/*
@@ -1397,9 +1397,9 @@ xlog_sync(xlog_t		*log,
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
@@ -1437,9 +1437,9 @@ xlog_sync(xlog_t		*log,
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
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b75fd67..dfd872a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -181,8 +181,7 @@ xlog_bread_noalign(
 	xfsbdstrat(log->l_mp, bp);
 	error = xfs_buf_iowait(bp);
 	if (error)
-		xfs_ioerror_alert("xlog_bread", log->l_mp,
-				  bp, XFS_BUF_ADDR(bp));
+		xfs_buf_ioerror_alert(bp, __func__);
 	return error;
 }
 
@@ -268,9 +267,9 @@ xlog_bwrite(
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
 	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
 
-	if ((error = xfs_bwrite(log->l_mp, bp)))
-		xfs_ioerror_alert("xlog_bwrite", log->l_mp,
-				  bp, XFS_BUF_ADDR(bp));
+	error = xfs_bwrite(log->l_mp, bp);
+	if (error)
+		xfs_buf_ioerror_alert(bp, __func__);
 	return error;
 }
 
@@ -361,9 +360,7 @@ xlog_recover_iodone(
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
@@ -2132,8 +2129,7 @@ xlog_recover_buffer_pass2(
 	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
 			  buf_flags);
 	if (XFS_BUF_ISERROR(bp)) {
-		xfs_ioerror_alert("xlog_recover_do..(read#1)", mp,
-				  bp, buf_f->blf_blkno);
+		xfs_buf_ioerror_alert(bp, __func__);
 		error = XFS_BUF_GETERROR(bp);
 		xfs_buf_relse(bp);
 		return error;
@@ -2224,8 +2220,7 @@ xlog_recover_inode_pass2(
 	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
 			  XBF_LOCK);
 	if (XFS_BUF_ISERROR(bp)) {
-		xfs_ioerror_alert("xlog_recover_do..(read#2)", mp,
-				  bp, in_f->ilf_blkno);
+		xfs_buf_ioerror_alert(bp, __func__);
 		error = XFS_BUF_GETERROR(bp);
 		xfs_buf_relse(bp);
 		goto error;
@@ -2533,8 +2528,7 @@ xlog_recover_dquot_pass2(
 			     XFS_FSB_TO_BB(mp, dq_f->qlf_len),
 			     0, &bp);
 	if (error) {
-		xfs_ioerror_alert("xlog_recover_do..(read#3)", mp,
-				  bp, dq_f->qlf_blkno);
+		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#3)");
 		return error;
 	}
 	ASSERT(bp);
@@ -3674,8 +3668,7 @@ xlog_do_recover(
 	xfsbdstrat(log->l_mp, bp);
 	error = xfs_buf_iowait(bp);
 	if (error) {
-		xfs_ioerror_alert("xlog_do_recover",
-				  log->l_mp, bp, XFS_BUF_ADDR(bp));
+		xfs_buf_ioerror_alert(bp, __func__);
 		ASSERT(0);
 		xfs_buf_relse(bp);
 		return error;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 9afdd49..3effa7f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1626,8 +1626,7 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 		xfsbdstrat(mp, sbp);
 		error = xfs_buf_iowait(sbp);
 		if (error)
-			xfs_ioerror_alert("xfs_unmountfs_writesb",
-					  mp, sbp, XFS_BUF_ADDR(sbp));
+			xfs_buf_ioerror_alert(sbp, __func__);
 		xfs_buf_relse(sbp);
 	}
 	return error;
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index d6d6fdf..47188fa 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
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
-		XFS_BUFTARG_NAME(XFS_BUF_TARGET(bp)),
-		(__uint64_t)blkno, func,
-		XFS_BUF_GETERROR(bp), XFS_BUF_COUNT(bp));
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
diff --git a/fs/xfs/xfs_rw.h b/fs/xfs/xfs_rw.h
index 11c41ec..bbdb9ad 100644
--- a/fs/xfs/xfs_rw.h
+++ b/fs/xfs/xfs_rw.h
@@ -42,8 +42,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
 extern int xfs_read_buf(struct xfs_mount *mp, xfs_buftarg_t *btp,
 			xfs_daddr_t blkno, int len, uint flags,
 			struct xfs_buf **bpp);
-extern void xfs_ioerror_alert(char *func, struct xfs_mount *mp,
-				xfs_buf_t *bp, xfs_daddr_t blkno);
 extern xfs_extlen_t xfs_get_extsz_hint(struct xfs_inode *ip);
 
 #endif /* __XFS_RW_H__ */
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 03b3b7f..26abce5 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -294,8 +294,7 @@ xfs_trans_read_buf(
 					EAGAIN : XFS_ERROR(ENOMEM);
 
 		if (XFS_BUF_GETERROR(bp) != 0) {
-			xfs_ioerror_alert("xfs_trans_read_buf", mp,
-					  bp, blkno);
+			xfs_buf_ioerror_alert(bp, __func__);
 			error = XFS_BUF_GETERROR(bp);
 			xfs_buf_relse(bp);
 			return error;
@@ -338,8 +337,7 @@ xfs_trans_read_buf(
 			xfsbdstrat(tp->t_mountp, bp);
 			error = xfs_buf_iowait(bp);
 			if (error) {
-				xfs_ioerror_alert("xfs_trans_read_buf", mp,
-						  bp, blkno);
+				xfs_buf_ioerror_alert(bp, __func__);
 				xfs_buf_relse(bp);
 				/*
 				 * We can gracefully recover from most read
@@ -390,8 +388,7 @@ xfs_trans_read_buf(
 	    XFS_BUF_SUPER_STALE(bp);
 		error = XFS_BUF_GETERROR(bp);
 
-		xfs_ioerror_alert("xfs_trans_read_buf", mp,
-				  bp, blkno);
+		xfs_buf_ioerror_alert(bp, __func__);
 		if (tp->t_flags & XFS_TRANS_DIRTY)
 			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 154223c..44f780c 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -509,8 +509,7 @@ xfs_readlink_bmap(
 				  XBF_LOCK | XBF_MAPPED | XBF_DONT_BLOCK);
 		error = XFS_BUF_GETERROR(bp);
 		if (error) {
-			xfs_ioerror_alert("xfs_readlink",
-				  ip->i_mount, bp, XFS_BUF_ADDR(bp));
+			xfs_buf_ioerror_alert(bp, __func__);
 			xfs_buf_relse(bp);
 			goto out;
 		}
@@ -2468,8 +2467,8 @@ xfs_zero_remaining_bytes(
 		xfsbdstrat(mp, bp);
 		error = xfs_buf_iowait(bp);
 		if (error) {
-			xfs_ioerror_alert("xfs_zero_remaining_bytes(read)",
-					  mp, bp, XFS_BUF_ADDR(bp));
+			xfs_buf_ioerror_alert(bp,
+					"xfs_zero_remaining_bytes(read)");
 			break;
 		}
 		memset(XFS_BUF_PTR(bp) +
@@ -2481,8 +2480,8 @@ xfs_zero_remaining_bytes(
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
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

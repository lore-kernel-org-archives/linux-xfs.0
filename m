Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D367629DFE
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 16:35:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C15918F8084
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 14:35:04 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	EgUmWsoTjV3BnPrQ for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 14:35:02 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XvZYQ-0003nU-Cd
	for xfs@oss.sgi.com; Tue, 02 Dec 2014 09:34:50 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XvZYQ-0004Za-BQ
	for xfs@oss.sgi.com; Tue, 02 Dec 2014 09:34:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: lobotomise xfs_trans_read_buf_map()
Date: Tue,  2 Dec 2014 09:34:50 +1100
Message-Id: <1417473290-17544-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

There's a case in that code where it checks for a buffer match in a
transaction where the buffer is not marked done. i.e. trying to
catch a buffer we have locked in the transaction but have not
completed IO on.

The only way we can find a buffer that has not had IO completed on
it is if it had readahead issued on it, but we never do readahead on
buffers that we have already joined into a transaction. Hence this
condition cannot occur, and buffers locked and joined into a
transaction should always be marked done and not under IO.

Remove this code and re-order xfs_trans_read_buf_map() to remove
duplicated IO dispatch and error handling code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_buf.c | 113 ++++++++++++-------------------------------------
 1 file changed, 26 insertions(+), 87 deletions(-)

diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index d3d80be..0136b4f 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -255,46 +255,11 @@ xfs_trans_read_buf_map(
 	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
-	xfs_buf_t		*bp;
-	xfs_buf_log_item_t	*bip;
+	struct xfs_buf		*bp = NULL;
+	struct xfs_buf_log_item	*bip;
 	int			error;
 
 	*bpp = NULL;
-	if (!tp) {
-		bp = xfs_buf_read_map(target, map, nmaps, flags, ops);
-		if (!bp)
-			return (flags & XBF_TRYLOCK) ?
-					-EAGAIN : -ENOMEM;
-
-		if (bp->b_error) {
-			error = bp->b_error;
-			xfs_buf_ioerror_alert(bp, __func__);
-			XFS_BUF_UNDONE(bp);
-			xfs_buf_stale(bp);
-			xfs_buf_relse(bp);
-
-			/* bad CRC means corrupted metadata */
-			if (error == -EFSBADCRC)
-				error = -EFSCORRUPTED;
-			return error;
-		}
-#ifdef DEBUG
-		if (xfs_do_error) {
-			if (xfs_error_target == target) {
-				if (((xfs_req_num++) % xfs_error_mod) == 0) {
-					xfs_buf_relse(bp);
-					xfs_debug(mp, "Returning error!");
-					return -EIO;
-				}
-			}
-		}
-#endif
-		if (XFS_FORCED_SHUTDOWN(mp))
-			goto shutdown_abort;
-		*bpp = bp;
-		return 0;
-	}
-
 	/*
 	 * If we find the buffer in the cache with this transaction
 	 * pointer in its b_fsprivate2 field, then we know we already
@@ -303,49 +268,24 @@ xfs_trans_read_buf_map(
 	 * If the buffer is not yet read in, then we read it in, increment
 	 * the lock recursion count, and return it to the caller.
 	 */
-	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
-	if (bp != NULL) {
+	if (tp)
+		bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
+	if (bp) {
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_transp == tp);
 		ASSERT(bp->b_fspriv != NULL);
 		ASSERT(!bp->b_error);
-		if (!(XFS_BUF_ISDONE(bp))) {
-			trace_xfs_trans_read_buf_io(bp, _RET_IP_);
-			ASSERT(!XFS_BUF_ISASYNC(bp));
-			ASSERT(bp->b_iodone == NULL);
-			XFS_BUF_READ(bp);
-			bp->b_ops = ops;
-
-			error = xfs_buf_submit_wait(bp);
-			if (error) {
-				if (!XFS_FORCED_SHUTDOWN(mp))
-					xfs_buf_ioerror_alert(bp, __func__);
-				xfs_buf_relse(bp);
-				/*
-				 * We can gracefully recover from most read
-				 * errors. Ones we can't are those that happen
-				 * after the transaction's already dirty.
-				 */
-				if (tp->t_flags & XFS_TRANS_DIRTY)
-					xfs_force_shutdown(tp->t_mountp,
-							SHUTDOWN_META_IO_ERROR);
-				/* bad CRC means corrupted metadata */
-				if (error == -EFSBADCRC)
-					error = -EFSCORRUPTED;
-				return error;
-			}
-		}
+		ASSERT(bp->b_flags & XBF_DONE);
+
 		/*
 		 * We never locked this buf ourselves, so we shouldn't
 		 * brelse it either. Just get out.
 		 */
 		if (XFS_FORCED_SHUTDOWN(mp)) {
 			trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
-			*bpp = NULL;
 			return -EIO;
 		}
 
-
 		bip = bp->b_fspriv;
 		bip->bli_recur++;
 
@@ -356,17 +296,20 @@ xfs_trans_read_buf_map(
 	}
 
 	bp = xfs_buf_read_map(target, map, nmaps, flags, ops);
-	if (bp == NULL) {
-		*bpp = NULL;
-		return (flags & XBF_TRYLOCK) ?
-					0 : -ENOMEM;
+	if (!bp) {
+		if (!(flags & XBF_TRYLOCK))
+			return -ENOMEM;
+		return tp ? 0 : -EAGAIN;
 	}
+
 	if (bp->b_error) {
 		error = bp->b_error;
+		if (!XFS_FORCED_SHUTDOWN(mp))
+			xfs_buf_ioerror_alert(bp, __func__);
+		bp->b_flags &= ~XBF_DONE;
 		xfs_buf_stale(bp);
-		XFS_BUF_DONE(bp);
-		xfs_buf_ioerror_alert(bp, __func__);
-		if (tp->t_flags & XFS_TRANS_DIRTY)
+
+		if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
 			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
 		xfs_buf_relse(bp);
 
@@ -376,32 +319,28 @@ xfs_trans_read_buf_map(
 		return error;
 	}
 #ifdef DEBUG
-	if (xfs_do_error && !(tp->t_flags & XFS_TRANS_DIRTY)) {
+	if (xfs_do_error && (!tp || !(tp->t_flags & XFS_TRANS_DIRTY))) {
 		if (xfs_error_target == target) {
 			if (((xfs_req_num++) % xfs_error_mod) == 0) {
-				xfs_force_shutdown(tp->t_mountp,
-						   SHUTDOWN_META_IO_ERROR);
 				xfs_buf_relse(bp);
-				xfs_debug(mp, "Returning trans error!");
+				xfs_debug(mp, "Returning error!");
 				return -EIO;
 			}
 		}
 	}
 #endif
-	if (XFS_FORCED_SHUTDOWN(mp))
-		goto shutdown_abort;
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		xfs_buf_relse(bp);
+		trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
+		return -EIO;
+	}
 
-	_xfs_trans_bjoin(tp, bp, 1);
+	if (tp)
+		_xfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_read_buf(bp->b_fspriv);
-
 	*bpp = bp;
 	return 0;
 
-shutdown_abort:
-	trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
-	xfs_buf_relse(bp);
-	*bpp = NULL;
-	return -EIO;
 }
 
 /*
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

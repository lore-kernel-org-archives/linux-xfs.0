Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DF8077F54
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 17:07:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CE0FB8F8033
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 15:07:23 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	psUwXK4DAVGtGiRx for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 15:07:21 -0800 (PST)
Date: Wed, 3 Dec 2014 10:07:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] xfs: lobotomise xfs_trans_read_buf_map()
Message-ID: <20141202230706.GH18131@dastard>
References: <1417473290-17544-1-git-send-email-david@fromorbit.com>
	<20141202165930.GA28571@infradead.org>
	<20141202224518.GG18131@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141202224518.GG18131@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


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

Version 2:
- kill unused xfs_do_error debug code
- add comment explaining clearing of XBF_DONE and marking the buffer
  stale on read error.

 fs/xfs/xfs_trans_buf.c | 135 ++++++++++++-------------------------------------
 1 file changed, 33 insertions(+), 102 deletions(-)

diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index d3d80be..df14070 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -227,13 +227,6 @@ xfs_trans_getsb(xfs_trans_t	*tp,
 	return bp;
 }
 
-#ifdef DEBUG
-xfs_buftarg_t *xfs_error_target;
-int	xfs_do_error;
-int	xfs_req_num;
-int	xfs_error_mod = 33;
-#endif
-
 /*
  * Get and lock the buffer for the caller if it is not already
  * locked within the given transaction.  If it has not yet been
@@ -255,46 +248,11 @@ xfs_trans_read_buf_map(
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
@@ -303,49 +261,24 @@ xfs_trans_read_buf_map(
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
 
@@ -356,17 +289,29 @@ xfs_trans_read_buf_map(
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
+	/*
+	 * If we've had a read error, then the contents of the buffer are
+	 * invalid and shoul dnot be used. To ensure that a followup read tries
+	 * to pull the buffer from disk again, we clear the XBF_DONE flag and
+	 * mark the buffer stale. This ensures that anyone who has a current
+	 * reference to the buffer will interpret it's contents correctly and
+	 * future cache lookups will also treat it as an empty, uninitialised
+	 * buffer.
+	 */
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
 
@@ -375,33 +320,19 @@ xfs_trans_read_buf_map(
 			error = -EFSCORRUPTED;
 		return error;
 	}
-#ifdef DEBUG
-	if (xfs_do_error && !(tp->t_flags & XFS_TRANS_DIRTY)) {
-		if (xfs_error_target == target) {
-			if (((xfs_req_num++) % xfs_error_mod) == 0) {
-				xfs_force_shutdown(tp->t_mountp,
-						   SHUTDOWN_META_IO_ERROR);
-				xfs_buf_relse(bp);
-				xfs_debug(mp, "Returning trans error!");
-				return -EIO;
-			}
-		}
+
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		xfs_buf_relse(bp);
+		trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
+		return -EIO;
 	}
-#endif
-	if (XFS_FORCED_SHUTDOWN(mp))
-		goto shutdown_abort;
 
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

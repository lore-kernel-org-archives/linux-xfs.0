Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7E3FB29DFA
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 01:39:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 54E028F8089
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 23:39:19 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	2u5e5YIRHwej1GM1 for <xfs@oss.sgi.com>;
	Thu, 14 Aug 2014 23:39:17 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XIBAL-0001ZV-CZ
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XIBAL-0001Uj-Bk
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/9] xfs: clean up xfs_trans_buf_read_map
Date: Fri, 15 Aug 2014 16:39:05 +1000
Message-Id: <1408084747-4540-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1408084747-4540-1-git-send-email-david@fromorbit.com>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
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

The error handling is a mess of inconsistent spaghetti. Clean it up
like Christoph's comment from long ago said we should. While there,
get rid of the "xfs_do_error" error injection debug code. If we need
to do error injection, we can do it on demand via kprobes rather
than needing to run the kernel under a debug and poke magic
variables.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_buf.c | 187 ++++++++++++++++++-------------------------------
 1 file changed, 69 insertions(+), 118 deletions(-)

diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 758c07d..9c3e610 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -229,13 +229,6 @@ xfs_trans_getsb(xfs_trans_t	*tp,
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
@@ -257,165 +250,123 @@ xfs_trans_read_buf_map(
 	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
-	xfs_buf_t		*bp;
-	xfs_buf_log_item_t	*bip;
+	struct xfs_buf		*bp = NULL;
 	int			error;
+	bool			release = true;
 
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
 
 	/*
-	 * If we find the buffer in the cache with this transaction
-	 * pointer in its b_fsprivate2 field, then we know we already
-	 * have it locked.  If it is already read in we just increment
-	 * the lock recursion count and return the buffer to the caller.
-	 * If the buffer is not yet read in, then we read it in, increment
-	 * the lock recursion count, and return it to the caller.
+	 * If we find the buffer in this transaction's item list, then we know
+	 * we already have it locked.  If it is already read in we just
+	 * increment the lock recursion count and return the buffer to the
+	 * caller.
 	 */
-	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
-	if (bp != NULL) {
+	if (tp)
+		bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
+
+	if (bp) {
+		struct xfs_buf_log_item	*bip;
+
+		/*
+		 * We don't own this buffer ourselves, so we shouldn't release
+		 * it if we come across any errors in processing it.
+		 */
+		release = false;
+
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_transp == tp);
 		ASSERT(bp->b_fspriv != NULL);
 		ASSERT(!bp->b_error);
-		if (!(XFS_BUF_ISDONE(bp))) {
+		if (!(bp->b_flags & XBF_DONE)) {
 			trace_xfs_trans_read_buf_io(bp, _RET_IP_);
-			ASSERT(!XFS_BUF_ISASYNC(bp));
+			ASSERT(!(bp->b_flags & XBF_ASYNC));
 			ASSERT(bp->b_iodone == NULL);
-			XFS_BUF_READ(bp);
+
+			bp->b_flags |= XBF_READ;
 			bp->b_ops = ops;
 
-			/*
-			 * XXX(hch): clean up the error handling here to be less
-			 * of a mess..
-			 */
 			if (XFS_FORCED_SHUTDOWN(mp)) {
 				trace_xfs_bdstrat_shut(bp, _RET_IP_);
-				bp->b_flags &= ~(XBF_READ | XBF_DONE);
-				xfs_buf_ioerror(bp, -EIO);
-				xfs_buf_stale(bp);
-				return -EIO;
+				error = -EIO;
+				goto out_stale;
 			}
 
 			xfs_buf_iorequest(bp);
 			error = xfs_buf_iowait(bp);
 			if (error) {
 				xfs_buf_ioerror_alert(bp, __func__);
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
+				goto out_do_shutdown;
+
 			}
 		}
-		/*
-		 * We never locked this buf ourselves, so we shouldn't
-		 * brelse it either. Just get out.
-		 */
+
 		if (XFS_FORCED_SHUTDOWN(mp)) {
 			trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
-			*bpp = NULL;
 			return -EIO;
 		}
 
-
+		/* good buffer! */
 		bip = bp->b_fspriv;
 		bip->bli_recur++;
-
 		ASSERT(atomic_read(&bip->bli_refcount) > 0);
 		trace_xfs_trans_read_buf_recur(bip);
 		*bpp = bp;
 		return 0;
 	}
 
+	/*
+	 * Read the buffer from disk as there is no transaction context or we
+	 * didn't find a matching buffer in the transaction item list.
+	 */
 	bp = xfs_buf_read_map(target, map, nmaps, flags, ops);
-	if (bp == NULL) {
-		*bpp = NULL;
-		return (flags & XBF_TRYLOCK) ?
-					0 : -ENOMEM;
+	if (!bp) {
+		/* XXX(dgc): should always return -EAGAIN on trylock failure */
+		if (!(flags & XBF_TRYLOCK))
+			return -ENOMEM;
+		if (!tp)
+			return -EAGAIN;
+		return 0;
 	}
 	if (bp->b_error) {
-		error = bp->b_error;
-		xfs_buf_stale(bp);
-		XFS_BUF_DONE(bp);
 		xfs_buf_ioerror_alert(bp, __func__);
-		if (tp->t_flags & XFS_TRANS_DIRTY)
-			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
-		xfs_buf_relse(bp);
-
-		/* bad CRC means corrupted metadata */
-		if (error == -EFSBADCRC)
-			error = -EFSCORRUPTED;
-		return error;
+		error = bp->b_error;
+		goto out_do_shutdown;
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
+		trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
+		error = -EIO;
+		goto out_stale;
 	}
-#endif
-	if (XFS_FORCED_SHUTDOWN(mp))
-		goto shutdown_abort;
 
-	_xfs_trans_bjoin(tp, bp, 1);
-	trace_xfs_trans_read_buf(bp->b_fspriv);
+	if (tp) {
+		_xfs_trans_bjoin(tp, bp, 1);
+		trace_xfs_trans_read_buf(bp->b_fspriv);
+	}
 
 	*bpp = bp;
 	return 0;
 
-shutdown_abort:
-	trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
-	xfs_buf_relse(bp);
-	*bpp = NULL;
-	return -EIO;
+
+out_do_shutdown:
+	/*
+	 * We can gracefully recover from most read errors. Ones we can't are
+	 * those that happen after the transaction's already dirty.
+	 */
+	if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
+		xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
+out_stale:
+	bp->b_flags &= ~(XBF_READ | XBF_DONE);
+	xfs_buf_ioerror(bp, error);
+	xfs_buf_stale(bp);
+	if (release)
+		xfs_buf_relse(bp);
+
+	/* bad CRC means corrupted metadata */
+	if (error == -EFSBADCRC)
+		error = -EFSCORRUPTED;
+	return error;
 }
 
 /*
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

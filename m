Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB76JBlT046726 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 00:19:11 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D9881305D4C
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 22:19:08 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	NeNiOqtvhS6CzvxQ for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 22:19:08 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RYAqF-0003o6-PL
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:55 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RYAq0-0003V1-Ef
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/12] xfs: remove duplication in transaction buffer operations
Date: Wed,  7 Dec 2011 17:18:23 +1100
Message-Id: <1323238703-13198-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1323238703-13198-1-git-send-email-david@fromorbit.com>
References: <1323238703-13198-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Remove the duplicated code introduced earlier in the series and make
sure that multiple irec buffer operations work correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_buf.c |  351 ++++++++++-------------------------------------
 1 files changed, 75 insertions(+), 276 deletions(-)

diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 8463f2d..290cfba 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -44,13 +44,27 @@ STATIC struct xfs_buf *
 xfs_trans_buf_item_match(
 	struct xfs_trans	*tp,
 	struct xfs_buftarg	*target,
-	xfs_daddr_t		blkno,
-	int			len)
+	struct xfs_bmbt_irec	*map,
+	int			nmaps)
 {
 	struct xfs_log_item_desc *lidp;
 	struct xfs_buf_log_item	*blip;
+	xfs_daddr_t		blkno;
+	int			len = 0;
+	int			i;
+
+	if (map[0].br_state == XFS_EXT_DADDR)
+		blkno = map[0].br_startblock;
+	else
+		blkno = XFS_FSB_TO_DADDR(tp->t_mountp, map[0].br_startblock);
+
+	for (i = 0; i < nmaps; i++) {
+		if (map[0].br_state == XFS_EXT_DADDR)
+			len += BBTOB(map[i].br_blockcount);
+		else
+			len += XFS_FSB_TO_B(tp->t_mountp, map[0].br_blockcount);
+	}
 
-	len = BBTOB(len);
 	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
 		blip = (struct xfs_buf_log_item *)lidp->lid_item;
 		if (blip->bli_item.li_type == XFS_LI_BUF &&
@@ -122,90 +136,10 @@ xfs_trans_bjoin(
 	trace_xfs_trans_bjoin(bp->b_fspriv);
 }
 
-/*
- * Get and lock the buffer for the caller if it is not already
- * locked within the given transaction.  If it is already locked
- * within the transaction, just increment its lock recursion count
- * and return a pointer to it.
- *
- * If the transaction pointer is NULL, make this just a normal
- * get_buf() call.
- */
-xfs_buf_t *
-xfs_trans_get_buf(xfs_trans_t	*tp,
-		  xfs_buftarg_t	*target_dev,
-		  xfs_daddr_t	blkno,
-		  int		len,
-		  uint		flags)
-{
-	xfs_buf_t		*bp;
-	xfs_buf_log_item_t	*bip;
-
-	if (flags == 0)
-		flags = XBF_LOCK | XBF_MAPPED;
-
-	/*
-	 * Default to a normal get_buf() call if the tp is NULL.
-	 */
-	if (tp == NULL)
-		return xfs_buf_get(target_dev, blkno, len,
-				   flags | XBF_DONT_BLOCK);
-
-	/*
-	 * If we find the buffer in the cache with this transaction
-	 * pointer in its b_fsprivate2 field, then we know we already
-	 * have it locked.  In this case we just increment the lock
-	 * recursion count and return the buffer to the caller.
-	 */
-	bp = xfs_trans_buf_item_match(tp, target_dev, blkno, len);
-	if (bp != NULL) {
-		ASSERT(xfs_buf_islocked(bp));
-		if (XFS_FORCED_SHUTDOWN(tp->t_mountp)) {
-			xfs_buf_stale(bp);
-			XFS_BUF_DONE(bp);
-		}
-
-		/*
-		 * If the buffer is stale then it was binval'ed
-		 * since last read.  This doesn't matter since the
-		 * caller isn't allowed to use the data anyway.
-		 */
-		else if (XFS_BUF_ISSTALE(bp))
-			ASSERT(!XFS_BUF_ISDELAYWRITE(bp));
-
-		ASSERT(bp->b_transp == tp);
-		bip = bp->b_fspriv;
-		ASSERT(bip != NULL);
-		ASSERT(atomic_read(&bip->bli_refcount) > 0);
-		bip->bli_recur++;
-		trace_xfs_trans_get_buf_recur(bip);
-		return (bp);
-	}
-
-	/*
-	 * We always specify the XBF_DONT_BLOCK flag within a transaction
-	 * so that get_buf does not try to push out a delayed write buffer
-	 * which might cause another transaction to take place (if the
-	 * buffer was delayed alloc).  Such recursive transactions can
-	 * easily deadlock with our current transaction as well as cause
-	 * us to run out of stack space.
-	 */
-	bp = xfs_buf_get(target_dev, blkno, len, flags | XBF_DONT_BLOCK);
-	if (bp == NULL) {
-		return NULL;
-	}
-
-	ASSERT(!bp->b_error);
-
-	_xfs_trans_bjoin(tp, bp, 1);
-	trace_xfs_trans_get_buf(bp->b_fspriv);
-	return (bp);
-}
-
 struct xfs_buf *
 xfs_trans_get_buf_irec(
 	struct xfs_trans	*tp,
-	struct xfs_buftarg	*target_dev,
+	struct xfs_buftarg	*target,
 	struct xfs_bmbt_irec	*map,
 	int			nmaps,
 	uint			flags)
@@ -213,8 +147,6 @@ xfs_trans_get_buf_irec(
 	struct xfs_buf		*bp;
 	struct xfs_buf_log_item	*bip;
 
-	ASSERT_ALWAYS(nmaps == 1);
-
 	if (flags == 0)
 		flags = XBF_LOCK | XBF_MAPPED;
 
@@ -222,7 +154,7 @@ xfs_trans_get_buf_irec(
 	 * Default to a normal get_buf() call if the tp is NULL.
 	 */
 	if (tp == NULL)
-		return xfs_buf_get_irec(target_dev, map, nmaps,
+		return xfs_buf_get_irec(target, map, nmaps,
 				   flags | XBF_DONT_BLOCK);
 
 	/*
@@ -231,9 +163,7 @@ xfs_trans_get_buf_irec(
 	 * have it locked.  In this case we just increment the lock
 	 * recursion count and return the buffer to the caller.
 	 */
-	bp = xfs_trans_buf_item_match(tp, target_dev,
-			XFS_FSB_TO_DADDR(tp->t_mountp, map[0].br_startblock),
-			XFS_FSB_TO_BB(tp->t_mountp, map[0].br_blockcount));
+	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
 	if (bp != NULL) {
 		ASSERT(xfs_buf_islocked(bp));
 		if (XFS_FORCED_SHUTDOWN(tp->t_mountp)) {
@@ -266,7 +196,7 @@ xfs_trans_get_buf_irec(
 	 * easily deadlock with our current transaction as well as cause
 	 * us to run out of stack space.
 	 */
-	bp = xfs_buf_get_irec(target_dev, map, nmaps, flags | XBF_DONT_BLOCK);
+	bp = xfs_buf_get_irec(target, map, nmaps, flags | XBF_DONT_BLOCK);
 	if (bp == NULL) {
 		return NULL;
 	}
@@ -279,6 +209,31 @@ xfs_trans_get_buf_irec(
 }
 
 /*
+ * Get and lock the buffer for the caller if it is not already
+ * locked within the given transaction.  If it is already locked
+ * within the transaction, just increment its lock recursion count
+ * and return a pointer to it.
+ *
+ * If the transaction pointer is NULL, make this just a normal
+ * get_buf() call.
+ */
+xfs_buf_t *
+xfs_trans_get_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	int			numblks,
+	uint			flags)
+{
+	struct xfs_bmbt_irec map = {
+		.br_startblock = blkno,
+		.br_blockcount = numblks,
+		.br_state = XFS_EXT_DADDR,
+	};
+	return xfs_trans_get_buf_irec(tp, target, &map, 1, flags);
+}
+
+/*
  * Get and lock the superblock buffer of this file system for the
  * given transaction.
  *
@@ -334,186 +289,6 @@ int	xfs_req_num;
 int	xfs_error_mod = 33;
 #endif
 
-/*
- * Get and lock the buffer for the caller if it is not already
- * locked within the given transaction.  If it has not yet been
- * read in, read it from disk. If it is already locked
- * within the transaction and already read in, just increment its
- * lock recursion count and return a pointer to it.
- *
- * If the transaction pointer is NULL, make this just a normal
- * read_buf() call.
- */
-int
-xfs_trans_read_buf(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_buftarg_t	*target,
-	xfs_daddr_t	blkno,
-	int		len,
-	uint		flags,
-	xfs_buf_t	**bpp)
-{
-	xfs_buf_t		*bp;
-	xfs_buf_log_item_t	*bip;
-	int			error;
-
-	if (flags == 0)
-		flags = XBF_LOCK | XBF_MAPPED;
-
-	/*
-	 * Default to a normal get_buf() call if the tp is NULL.
-	 */
-	if (tp == NULL) {
-		bp = xfs_buf_read(target, blkno, len, flags | XBF_DONT_BLOCK);
-		if (!bp)
-			return (flags & XBF_TRYLOCK) ?
-					EAGAIN : XFS_ERROR(ENOMEM);
-
-		if (bp->b_error) {
-			error = bp->b_error;
-			xfs_buf_ioerror_alert(bp, __func__);
-			xfs_buf_relse(bp);
-			return error;
-		}
-#ifdef DEBUG
-		if (xfs_do_error) {
-			if (xfs_error_target == target) {
-				if (((xfs_req_num++) % xfs_error_mod) == 0) {
-					xfs_buf_relse(bp);
-					xfs_debug(mp, "Returning error!");
-					return XFS_ERROR(EIO);
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
-	/*
-	 * If we find the buffer in the cache with this transaction
-	 * pointer in its b_fsprivate2 field, then we know we already
-	 * have it locked.  If it is already read in we just increment
-	 * the lock recursion count and return the buffer to the caller.
-	 * If the buffer is not yet read in, then we read it in, increment
-	 * the lock recursion count, and return it to the caller.
-	 */
-	bp = xfs_trans_buf_item_match(tp, target, blkno, len);
-	if (bp != NULL) {
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_transp == tp);
-		ASSERT(bp->b_fspriv != NULL);
-		ASSERT(!bp->b_error);
-		if (!(XFS_BUF_ISDONE(bp))) {
-			trace_xfs_trans_read_buf_io(bp, _RET_IP_);
-			ASSERT(!XFS_BUF_ISASYNC(bp));
-			XFS_BUF_READ(bp);
-			xfsbdstrat(tp->t_mountp, bp);
-			error = xfs_buf_iowait(bp);
-			if (error) {
-				xfs_buf_ioerror_alert(bp, __func__);
-				xfs_buf_relse(bp);
-				/*
-				 * We can gracefully recover from most read
-				 * errors. Ones we can't are those that happen
-				 * after the transaction's already dirty.
-				 */
-				if (tp->t_flags & XFS_TRANS_DIRTY)
-					xfs_force_shutdown(tp->t_mountp,
-							SHUTDOWN_META_IO_ERROR);
-				return error;
-			}
-		}
-		/*
-		 * We never locked this buf ourselves, so we shouldn't
-		 * brelse it either. Just get out.
-		 */
-		if (XFS_FORCED_SHUTDOWN(mp)) {
-			trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
-			*bpp = NULL;
-			return XFS_ERROR(EIO);
-		}
-
-
-		bip = bp->b_fspriv;
-		bip->bli_recur++;
-
-		ASSERT(atomic_read(&bip->bli_refcount) > 0);
-		trace_xfs_trans_read_buf_recur(bip);
-		*bpp = bp;
-		return 0;
-	}
-
-	/*
-	 * We always specify the XBF_DONT_BLOCK flag within a transaction
-	 * so that get_buf does not try to push out a delayed write buffer
-	 * which might cause another transaction to take place (if the
-	 * buffer was delayed alloc).  Such recursive transactions can
-	 * easily deadlock with our current transaction as well as cause
-	 * us to run out of stack space.
-	 */
-	bp = xfs_buf_read(target, blkno, len, flags | XBF_DONT_BLOCK);
-	if (bp == NULL) {
-		*bpp = NULL;
-		return (flags & XBF_TRYLOCK) ?
-					0 : XFS_ERROR(ENOMEM);
-	}
-	if (bp->b_error) {
-		error = bp->b_error;
-		xfs_buf_stale(bp);
-		XFS_BUF_DONE(bp);
-		xfs_buf_ioerror_alert(bp, __func__);
-		if (tp->t_flags & XFS_TRANS_DIRTY)
-			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
-		xfs_buf_relse(bp);
-		return error;
-	}
-#ifdef DEBUG
-	if (xfs_do_error && !(tp->t_flags & XFS_TRANS_DIRTY)) {
-		if (xfs_error_target == target) {
-			if (((xfs_req_num++) % xfs_error_mod) == 0) {
-				xfs_force_shutdown(tp->t_mountp,
-						   SHUTDOWN_META_IO_ERROR);
-				xfs_buf_relse(bp);
-				xfs_debug(mp, "Returning trans error!");
-				return XFS_ERROR(EIO);
-			}
-		}
-	}
-#endif
-	if (XFS_FORCED_SHUTDOWN(mp))
-		goto shutdown_abort;
-
-	_xfs_trans_bjoin(tp, bp, 1);
-	trace_xfs_trans_read_buf(bp->b_fspriv);
-
-	*bpp = bp;
-	return 0;
-
-shutdown_abort:
-	/*
-	 * the theory here is that buffer is good but we're
-	 * bailing out because the filesystem is being forcibly
-	 * shut down.  So we should leave the b_flags alone since
-	 * the buffer's not staled and just get out.
-	 */
-#if defined(DEBUG)
-	if (XFS_BUF_ISSTALE(bp) && XFS_BUF_ISDELAYWRITE(bp))
-		xfs_notice(mp, "about to pop assert, bp == 0x%p", bp);
-#endif
-	ASSERT((bp->b_flags & (XBF_STALE|XBF_DELWRI)) !=
-				     (XBF_STALE|XBF_DELWRI));
-
-	trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
-	xfs_buf_relse(bp);
-	*bpp = NULL;
-	return XFS_ERROR(EIO);
-}
-
-
 int
 xfs_trans_read_buf_irec(
 	struct xfs_mount	*mp,
@@ -528,8 +303,6 @@ xfs_trans_read_buf_irec(
 	xfs_buf_log_item_t	*bip;
 	int			error;
 
-	ASSERT_ALWAYS(nmaps == 1);
-
 	if (flags == 0)
 		flags = XBF_LOCK | XBF_MAPPED;
 
@@ -574,9 +347,7 @@ xfs_trans_read_buf_irec(
 	 * If the buffer is not yet read in, then we read it in, increment
 	 * the lock recursion count, and return it to the caller.
 	 */
-	bp = xfs_trans_buf_item_match(tp, target,
-				XFS_FSB_TO_DADDR(mp, map[0].br_startblock),
-				XFS_FSB_TO_BB(mp, map[0].br_blockcount));
+	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
 	if (bp != NULL) {
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_transp == tp);
@@ -689,6 +460,34 @@ shutdown_abort:
 }
 
 /*
+ * Get and lock the buffer for the caller if it is not already
+ * locked within the given transaction.  If it has not yet been
+ * read in, read it from disk. If it is already locked
+ * within the transaction and already read in, just increment its
+ * lock recursion count and return a pointer to it.
+ *
+ * If the transaction pointer is NULL, make this just a normal
+ * read_buf() call.
+ */
+int
+xfs_trans_read_buf(
+	xfs_mount_t	*mp,
+	xfs_trans_t	*tp,
+	xfs_buftarg_t	*target,
+	xfs_daddr_t	blkno,
+	int		numblks,
+	uint		flags,
+	xfs_buf_t	**bpp)
+{
+	struct xfs_bmbt_irec map = {
+		.br_startblock = blkno,
+		.br_blockcount = numblks,
+		.br_state = XFS_EXT_DADDR,
+	};
+	return xfs_trans_read_buf_irec(mp, tp, target, &map, 1, flags, bpp);
+}
+
+/*
  * Release the buffer bp which was previously acquired with one of the
  * xfs_trans_... buffer allocation routines if the buffer has not
  * been modified within this transaction.  If the buffer is modified
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

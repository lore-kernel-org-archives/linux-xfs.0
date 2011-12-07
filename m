Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB76J5hf046688 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 00:19:06 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 976AD1305D47
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 22:19:03 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	huYAuikRBpOEoXbi for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 22:19:03 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RYAq5-0003o9-0o
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:45 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RYApz-0003Uj-Hn
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/12] xfs: add irec interfaces to xfs_trans_buf_get/read
Date: Wed,  7 Dec 2011 17:18:16 +1100
Message-Id: <1323238703-13198-6-git-send-email-david@fromorbit.com>
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

Add an irec interface to the transaction buffer API so that we can
connect up the xfs_dabuf code to the new compound buffer API. Only
support a single map at this point to simplify the implementation.

Also, just duplicate the existing code to minimise the impact of the
change.  This will be refactored later to remove all the duplicated
code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.h     |    7 ++
 fs/xfs/xfs_trans_buf.c |  250 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 257 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 3ae713c..cc0aeae1 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -458,6 +458,13 @@ struct xfs_buf	*xfs_trans_get_buf(xfs_trans_t *, struct xfs_buftarg *, xfs_daddr
 int		xfs_trans_read_buf(struct xfs_mount *, xfs_trans_t *,
 				   struct xfs_buftarg *, xfs_daddr_t, int, uint,
 				   struct xfs_buf **);
+struct xfs_buf	*xfs_trans_get_buf_irec(struct xfs_trans *, struct xfs_buftarg *,
+				        struct xfs_bmbt_irec *, int, uint);
+int		xfs_trans_read_buf_irec(struct xfs_mount *, struct xfs_trans *,
+					struct xfs_buftarg *,
+					struct xfs_bmbt_irec *, int, uint,
+					struct xfs_buf **);
+
 struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *, int);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 475a4de..8463f2d 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -202,6 +202,82 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 	return (bp);
 }
 
+struct xfs_buf *
+xfs_trans_get_buf_irec(
+	struct xfs_trans	*tp,
+	struct xfs_buftarg	*target_dev,
+	struct xfs_bmbt_irec	*map,
+	int			nmaps,
+	uint			flags)
+{
+	struct xfs_buf		*bp;
+	struct xfs_buf_log_item	*bip;
+
+	ASSERT_ALWAYS(nmaps == 1);
+
+	if (flags == 0)
+		flags = XBF_LOCK | XBF_MAPPED;
+
+	/*
+	 * Default to a normal get_buf() call if the tp is NULL.
+	 */
+	if (tp == NULL)
+		return xfs_buf_get_irec(target_dev, map, nmaps,
+				   flags | XBF_DONT_BLOCK);
+
+	/*
+	 * If we find the buffer in the cache with this transaction
+	 * pointer in its b_fsprivate2 field, then we know we already
+	 * have it locked.  In this case we just increment the lock
+	 * recursion count and return the buffer to the caller.
+	 */
+	bp = xfs_trans_buf_item_match(tp, target_dev,
+			XFS_FSB_TO_DADDR(tp->t_mountp, map[0].br_startblock),
+			XFS_FSB_TO_BB(tp->t_mountp, map[0].br_blockcount));
+	if (bp != NULL) {
+		ASSERT(xfs_buf_islocked(bp));
+		if (XFS_FORCED_SHUTDOWN(tp->t_mountp)) {
+			xfs_buf_stale(bp);
+			XFS_BUF_DONE(bp);
+		}
+
+		/*
+		 * If the buffer is stale then it was binval'ed
+		 * since last read.  This doesn't matter since the
+		 * caller isn't allowed to use the data anyway.
+		 */
+		else if (XFS_BUF_ISSTALE(bp))
+			ASSERT(!XFS_BUF_ISDELAYWRITE(bp));
+
+		ASSERT(bp->b_transp == tp);
+		bip = bp->b_fspriv;
+		ASSERT(bip != NULL);
+		ASSERT(atomic_read(&bip->bli_refcount) > 0);
+		bip->bli_recur++;
+		trace_xfs_trans_get_buf_recur(bip);
+		return (bp);
+	}
+
+	/*
+	 * We always specify the XBF_DONT_BLOCK flag within a transaction
+	 * so that get_buf does not try to push out a delayed write buffer
+	 * which might cause another transaction to take place (if the
+	 * buffer was delayed alloc).  Such recursive transactions can
+	 * easily deadlock with our current transaction as well as cause
+	 * us to run out of stack space.
+	 */
+	bp = xfs_buf_get_irec(target_dev, map, nmaps, flags | XBF_DONT_BLOCK);
+	if (bp == NULL) {
+		return NULL;
+	}
+
+	ASSERT(!bp->b_error);
+
+	_xfs_trans_bjoin(tp, bp, 1);
+	trace_xfs_trans_get_buf(bp->b_fspriv);
+	return (bp);
+}
+
 /*
  * Get and lock the superblock buffer of this file system for the
  * given transaction.
@@ -438,6 +514,180 @@ shutdown_abort:
 }
 
 
+int
+xfs_trans_read_buf_irec(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buftarg	*target,
+	struct xfs_bmbt_irec	*map,
+	int			nmaps,
+	uint			flags,
+	struct xfs_buf		**bpp)
+{
+	xfs_buf_t		*bp;
+	xfs_buf_log_item_t	*bip;
+	int			error;
+
+	ASSERT_ALWAYS(nmaps == 1);
+
+	if (flags == 0)
+		flags = XBF_LOCK | XBF_MAPPED;
+
+	/*
+	 * Default to a normal get_buf() call if the tp is NULL.
+	 */
+	if (tp == NULL) {
+		bp = xfs_buf_read_irec(target, map, nmaps,
+				       flags | XBF_DONT_BLOCK);
+		if (!bp)
+			return (flags & XBF_TRYLOCK) ?
+					EAGAIN : XFS_ERROR(ENOMEM);
+
+		if (bp->b_error) {
+			error = bp->b_error;
+			xfs_buf_ioerror_alert(bp, __func__);
+			xfs_buf_relse(bp);
+			return error;
+		}
+#ifdef DEBUG
+		if (xfs_do_error) {
+			if (xfs_error_target == target) {
+				if (((xfs_req_num++) % xfs_error_mod) == 0) {
+					xfs_buf_relse(bp);
+					xfs_debug(mp, "Returning error!");
+					return XFS_ERROR(EIO);
+				}
+			}
+		}
+#endif
+		if (XFS_FORCED_SHUTDOWN(mp))
+			goto shutdown_abort;
+		*bpp = bp;
+		return 0;
+	}
+
+	/*
+	 * If we find the buffer in the cache with this transaction
+	 * pointer in its b_fsprivate2 field, then we know we already
+	 * have it locked.  If it is already read in we just increment
+	 * the lock recursion count and return the buffer to the caller.
+	 * If the buffer is not yet read in, then we read it in, increment
+	 * the lock recursion count, and return it to the caller.
+	 */
+	bp = xfs_trans_buf_item_match(tp, target,
+				XFS_FSB_TO_DADDR(mp, map[0].br_startblock),
+				XFS_FSB_TO_BB(mp, map[0].br_blockcount));
+	if (bp != NULL) {
+		ASSERT(xfs_buf_islocked(bp));
+		ASSERT(bp->b_transp == tp);
+		ASSERT(bp->b_fspriv != NULL);
+		ASSERT(!bp->b_error);
+		if (!(XFS_BUF_ISDONE(bp))) {
+			trace_xfs_trans_read_buf_io(bp, _RET_IP_);
+			ASSERT(!XFS_BUF_ISASYNC(bp));
+			XFS_BUF_READ(bp);
+			xfsbdstrat(tp->t_mountp, bp);
+			error = xfs_buf_iowait(bp);
+			if (error) {
+				xfs_buf_ioerror_alert(bp, __func__);
+				xfs_buf_relse(bp);
+				/*
+				 * We can gracefully recover from most read
+				 * errors. Ones we can't are those that happen
+				 * after the transaction's already dirty.
+				 */
+				if (tp->t_flags & XFS_TRANS_DIRTY)
+					xfs_force_shutdown(tp->t_mountp,
+							SHUTDOWN_META_IO_ERROR);
+				return error;
+			}
+		}
+		/*
+		 * We never locked this buf ourselves, so we shouldn't
+		 * brelse it either. Just get out.
+		 */
+		if (XFS_FORCED_SHUTDOWN(mp)) {
+			trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
+			*bpp = NULL;
+			return XFS_ERROR(EIO);
+		}
+
+
+		bip = bp->b_fspriv;
+		bip->bli_recur++;
+
+		ASSERT(atomic_read(&bip->bli_refcount) > 0);
+		trace_xfs_trans_read_buf_recur(bip);
+		*bpp = bp;
+		return 0;
+	}
+
+	/*
+	 * We always specify the XBF_DONT_BLOCK flag within a transaction
+	 * so that get_buf does not try to push out a delayed write buffer
+	 * which might cause another transaction to take place (if the
+	 * buffer was delayed alloc).  Such recursive transactions can
+	 * easily deadlock with our current transaction as well as cause
+	 * us to run out of stack space.
+	 */
+	bp = xfs_buf_read_irec(target, map, nmaps, flags | XBF_DONT_BLOCK);
+	if (bp == NULL) {
+		*bpp = NULL;
+		return (flags & XBF_TRYLOCK) ?
+					0 : XFS_ERROR(ENOMEM);
+	}
+	if (bp->b_error) {
+		error = bp->b_error;
+		xfs_buf_stale(bp);
+		XFS_BUF_DONE(bp);
+		xfs_buf_ioerror_alert(bp, __func__);
+		if (tp->t_flags & XFS_TRANS_DIRTY)
+			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
+		xfs_buf_relse(bp);
+		return error;
+	}
+#ifdef DEBUG
+	if (xfs_do_error && !(tp->t_flags & XFS_TRANS_DIRTY)) {
+		if (xfs_error_target == target) {
+			if (((xfs_req_num++) % xfs_error_mod) == 0) {
+				xfs_force_shutdown(tp->t_mountp,
+						   SHUTDOWN_META_IO_ERROR);
+				xfs_buf_relse(bp);
+				xfs_debug(mp, "Returning trans error!");
+				return XFS_ERROR(EIO);
+			}
+		}
+	}
+#endif
+	if (XFS_FORCED_SHUTDOWN(mp))
+		goto shutdown_abort;
+
+	_xfs_trans_bjoin(tp, bp, 1);
+	trace_xfs_trans_read_buf(bp->b_fspriv);
+
+	*bpp = bp;
+	return 0;
+
+shutdown_abort:
+	/*
+	 * the theory here is that buffer is good but we're
+	 * bailing out because the filesystem is being forcibly
+	 * shut down.  So we should leave the b_flags alone since
+	 * the buffer's not staled and just get out.
+	 */
+#if defined(DEBUG)
+	if (XFS_BUF_ISSTALE(bp) && XFS_BUF_ISDELAYWRITE(bp))
+		xfs_notice(mp, "about to pop assert, bp == 0x%p", bp);
+#endif
+	ASSERT((bp->b_flags & (XBF_STALE|XBF_DELWRI)) !=
+				     (XBF_STALE|XBF_DELWRI));
+
+	trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
+	xfs_buf_relse(bp);
+	*bpp = NULL;
+	return XFS_ERROR(EIO);
+}
+
 /*
  * Release the buffer bp which was previously acquired with one of the
  * xfs_trans_... buffer allocation routines if the buffer has not
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

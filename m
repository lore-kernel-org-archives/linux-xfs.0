Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56362 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfEUDrM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 23:47:12 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/7] libxfs: Remove XACT_DEBUG #ifdefs
Date: Mon, 20 May 2019 22:47:01 -0500
Message-Id: <1558410427-1837-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Remove XACT_DEBUG #ifdefs to reduce more cosmetic differences
between userspace & kernelspace libxfs.  Add in some corresponding
(stubbed-out) tracepoint calls.

If these are felt to be particularly useful, the tracepoint calls
could be fleshed out to provide similar information.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 include/xfs_trace.h | 13 ++++++++
 libxfs/trans.c      | 85 ++++++++++++++---------------------------------------
 2 files changed, 35 insertions(+), 63 deletions(-)

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 793ac56..4372004 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -161,6 +161,19 @@
 #define trace_xfs_perag_get_tag(a,b,c,d) ((c) = (c))
 #define trace_xfs_perag_put(a,b,c,d)	((c) = (c))
 
+#define trace_xfs_trans_alloc(a,b)		((void) 0)
+#define trace_xfs_trans_cancel(a,b)		((void) 0)
+#define trace_xfs_trans_brelse(a)		((void) 0)
+#define trace_xfs_trans_binval(a)		((void) 0)
+#define trace_xfs_trans_bjoin(a)		((void) 0)
+#define trace_xfs_trans_bhold(a)		((void) 0)
+#define trace_xfs_trans_get_buf(a)		((void) 0)
+#define trace_xfs_trans_getsb_recur(a)		((void) 0)
+#define trace_xfs_trans_getsb(a)		((void) 0)
+#define trace_xfs_trans_read_buf_recur(a)	((void) 0)
+#define trace_xfs_trans_read_buf(a)		((void) 0)
+#define trace_xfs_trans_commit(a,b)		((void) 0)
+
 #define trace_xfs_defer_cancel(a,b)		((void) 0)
 #define trace_xfs_defer_pending_commit(a,b)	((void) 0)
 #define trace_xfs_defer_pending_abort(a,b)	((void) 0)
diff --git a/libxfs/trans.c b/libxfs/trans.c
index cb15552..f50a9b2 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_defer.h"
+#include "xfs_trace.h"
 
 static void xfs_trans_free_items(struct xfs_trans *tp);
 STATIC struct xfs_trans *xfs_trans_dup(struct xfs_trans *tp);
@@ -269,9 +270,9 @@ libxfs_trans_alloc(
 		xfs_trans_cancel(tp);
 		return error;
 	}
-#ifdef XACT_DEBUG
-	fprintf(stderr, "allocated new transaction %p\n", tp);
-#endif
+
+	trace_xfs_trans_alloc(tp, _RET_IP_);
+
 	*tpp = tp;
 	return 0;
 }
@@ -317,23 +318,16 @@ void
 libxfs_trans_cancel(
 	struct xfs_trans	*tp)
 {
-#ifdef XACT_DEBUG
-	struct xfs_trans	*otp = tp;
-#endif
+	trace_xfs_trans_cancel(tp, _RET_IP_);
+
 	if (tp == NULL)
-		goto out;
+		return;
 
 	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
 		xfs_defer_cancel(tp);
 
 	xfs_trans_free_items(tp);
 	xfs_trans_free(tp);
-
-out:
-#ifdef XACT_DEBUG
-	fprintf(stderr, "## cancelled transaction %p\n", otp);
-#endif
-	return;
 }
 
 void
@@ -353,10 +347,6 @@ libxfs_trans_ijoin(
 	iip->ili_lock_flags = lock_flags;
 
 	xfs_trans_add_item(tp, (xfs_log_item_t *)(iip));
-
-#ifdef XACT_DEBUG
-	fprintf(stderr, "ijoin'd inode %llu, transaction %p\n", ip->i_ino, tp);
-#endif
 }
 
 void
@@ -388,9 +378,6 @@ xfs_trans_log_inode(
 	uint			flags)
 {
 	ASSERT(ip->i_itemp != NULL);
-#ifdef XACT_DEBUG
-	fprintf(stderr, "dirtied inode %llu, transaction %p\n", ip->i_ino, tp);
-#endif
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags);
@@ -434,9 +421,6 @@ libxfs_trans_dirty_buf(
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 
-#ifdef XACT_DEBUG
-	fprintf(stderr, "dirtied buffer %p, transaction %p\n", bp, tp);
-#endif
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
 }
@@ -501,15 +485,14 @@ libxfs_trans_brelse(
 	xfs_buf_t		*bp)
 {
 	xfs_buf_log_item_t	*bip;
-#ifdef XACT_DEBUG
-	fprintf(stderr, "released buffer %p, transaction %p\n", bp, tp);
-#endif
 
 	if (tp == NULL) {
 		ASSERT(bp->b_transp == NULL);
 		libxfs_putbuf(bp);
 		return;
 	}
+
+	trace_xfs_trans_brelse(bip);
 	ASSERT(bp->b_transp == tp);
 	bip = bp->b_log_item;
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
@@ -536,13 +519,12 @@ libxfs_trans_binval(
 	xfs_buf_t		*bp)
 {
 	xfs_buf_log_item_t	*bip = bp->b_log_item;
-#ifdef XACT_DEBUG
-	fprintf(stderr, "binval'd buffer %p, transaction %p\n", bp, tp);
-#endif
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 
+	trace_xfs_trans_binval(bip);
+
 	if (bip->bli_flags & XFS_BLI_STALE)
 		return;
 	XFS_BUF_UNDELAYWRITE(bp);
@@ -563,14 +545,12 @@ libxfs_trans_bjoin(
 	xfs_buf_log_item_t	*bip;
 
 	ASSERT(bp->b_transp == NULL);
-#ifdef XACT_DEBUG
-	fprintf(stderr, "bjoin'd buffer %p, transaction %p\n", bp, tp);
-#endif
 
 	xfs_buf_item_init(bp, tp->t_mountp);
 	bip = bp->b_log_item;
 	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
 	bp->b_transp = tp;
+	trace_xfs_trans_bjoin(bp->b_log_item);
 }
 
 void
@@ -582,11 +562,9 @@ libxfs_trans_bhold(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-#ifdef XACT_DEBUG
-	fprintf(stderr, "bhold'd buffer %p, transaction %p\n", bp, tp);
-#endif
 
 	bip->bli_flags |= XFS_BLI_HOLD;
+	trace_xfs_trans_bhold(bip);
 }
 
 xfs_buf_t *
@@ -615,13 +593,11 @@ libxfs_trans_get_buf_map(
 	bp = libxfs_getbuf_map(btp, map, nmaps, 0);
 	if (bp == NULL)
 		return NULL;
-#ifdef XACT_DEBUG
-	fprintf(stderr, "trans_get_buf buffer %p, transaction %p\n", bp, tp);
-#endif
 
 	libxfs_trans_bjoin(tp, bp);
 	bip = bp->b_log_item;
 	bip->bli_recur = 0;
+	trace_xfs_trans_get_buf(bp->b_log_item);
 	return bp;
 }
 
@@ -645,17 +621,16 @@ libxfs_trans_getsb(
 		bip = bp->b_log_item;
 		ASSERT(bip != NULL);
 		bip->bli_recur++;
+		trace_xfs_trans_getsb_recur(bip);
 		return bp;
 	}
 
 	bp = libxfs_getsb(mp, flags);
-#ifdef XACT_DEBUG
-	fprintf(stderr, "trans_get_sb buffer %p, transaction %p\n", bp, tp);
-#endif
 
 	libxfs_trans_bjoin(tp, bp);
 	bip = bp->b_log_item;
 	bip->bli_recur = 0;
+	trace_xfs_trans_getsb(bp->b_log_item);
 	return bp;
 }
 
@@ -692,6 +667,7 @@ libxfs_trans_read_buf_map(
 		ASSERT(bp->b_log_item != NULL);
 		bip = bp->b_log_item;
 		bip->bli_recur++;
+		trace_xfs_trans_read_buf_recur(bip);
 		goto done;
 	}
 
@@ -702,14 +678,11 @@ libxfs_trans_read_buf_map(
 	if (bp->b_error)
 		goto out_relse;
 
-#ifdef XACT_DEBUG
-	fprintf(stderr, "trans_read_buf buffer %p, transaction %p\n", bp, tp);
-#endif
-
 	xfs_trans_bjoin(tp, bp);
 	bip = bp->b_log_item;
 	bip->bli_recur = 0;
 done:
+	trace_xfs_trans_read_buf(bp->b_log_item);
 	*bpp = bp;
 	return 0;
 out_relse:
@@ -825,10 +798,6 @@ inode_item_done(
 	}
 
 	libxfs_writebuf(bp, 0);
-#ifdef XACT_DEBUG
-	fprintf(stderr, "flushing dirty inode %llu, buffer %p\n",
-			ip->i_ino, bp);
-#endif
 free:
 	xfs_inode_item_put(iip);
 }
@@ -846,13 +815,8 @@ buf_item_done(
 	bp->b_transp = NULL;			/* remove xact ptr */
 
 	hold = (bip->bli_flags & XFS_BLI_HOLD);
-	if (bip->bli_flags & XFS_BLI_DIRTY) {
-#ifdef XACT_DEBUG
-		fprintf(stderr, "flushing/staling buffer %p (hold=%d)\n",
-			bp, hold);
-#endif
+	if (bip->bli_flags & XFS_BLI_DIRTY)
 		libxfs_writebuf_int(bp, 0);
-	}
 
 	bip->bli_flags &= ~XFS_BLI_HOLD;
 	xfs_buf_item_put(bip);
@@ -938,6 +902,8 @@ __xfs_trans_commit(
 	struct xfs_sb		*sbp;
 	int			error = 0;
 
+	trace_xfs_trans_commit(tp, _RET_IP_);
+
 	if (tp == NULL)
 		return 0;
 
@@ -953,12 +919,8 @@ __xfs_trans_commit(
 			goto out_unreserve;
 	}
 
-	if (!(tp->t_flags & XFS_TRANS_DIRTY)) {
-#ifdef XACT_DEBUG
-		fprintf(stderr, "committed clean transaction %p\n", tp);
-#endif
+	if (!(tp->t_flags & XFS_TRANS_DIRTY))
 		goto out_unreserve;
-	}
 
 	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
 		sbp = &(tp->t_mountp->m_sb);
@@ -973,9 +935,6 @@ __xfs_trans_commit(
 		xfs_log_sb(tp);
 	}
 
-#ifdef XACT_DEBUG
-	fprintf(stderr, "committing dirty transaction %p\n", tp);
-#endif
 	trans_committed(tp);
 
 	/* That's it for the transaction structure.  Free it. */
-- 
1.8.3.1

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36104 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727762AbfEJUSo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 16:18:44 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 11/11] libxfs: minor sync-ups to kernel-ish functions
Date: Fri, 10 May 2019 15:18:30 -0500
Message-Id: <1557519510-10602-12-git-send-email-sandeen@redhat.com>
In-Reply-To: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Change typedefs to structs, add comments, and other very
minor changes to userspace libxfs/ functions so that they
more closely match kernelspace.  Should be no functional
changes.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/buf_item.c    |  13 +---
 libxfs/inode_item.c  |   9 +--
 libxfs/libxfs_priv.h |   4 -
 libxfs/trans.c       |  80 ++++++++++++--------
 libxfs/trans_buf.c   | 205 ++++++++++++++++++++++++++++++++++++++-------------
 5 files changed, 211 insertions(+), 100 deletions(-)

diff --git a/libxfs/buf_item.c b/libxfs/buf_item.c
index 2e64c8c..30e9609 100644
--- a/libxfs/buf_item.c
+++ b/libxfs/buf_item.c
@@ -16,10 +16,6 @@
 
 kmem_zone_t	*xfs_buf_item_zone;
 
-/*
- * The following are from fs/xfs/xfs_buf_item.c
- */
-
 void
 xfs_buf_item_put(
 	struct xfs_buf_log_item	*bip)
@@ -56,8 +52,8 @@ buf_item_unlock(
  */
 void
 xfs_buf_item_init(
-	xfs_buf_t		*bp,
-	xfs_mount_t		*mp)
+	struct xfs_buf		*bp,
+	struct xfs_mount	*mp)
 {
 	xfs_log_item_t		*lip;
 	xfs_buf_log_item_t	*bip;
@@ -85,8 +81,7 @@ xfs_buf_item_init(
 		}
 	}
 
-	bip = (xfs_buf_log_item_t *)kmem_zone_zalloc(xfs_buf_item_zone,
-						    KM_SLEEP);
+	bip = kmem_zone_zalloc(xfs_buf_item_zone, KM_SLEEP);
 #ifdef LI_DEBUG
 	fprintf(stderr, "adding buf item %p for not-logged buffer %p\n",
 		bip, bp);
@@ -107,7 +102,7 @@ xfs_buf_item_init(
  */
 void
 xfs_buf_item_log(
-	xfs_buf_log_item_t	*bip,
+	struct xfs_buf_log_item	*bip,
 	uint			first,
 	uint			last)
 {
diff --git a/libxfs/inode_item.c b/libxfs/inode_item.c
index 4e9b1af..e3d4ff9 100644
--- a/libxfs/inode_item.c
+++ b/libxfs/inode_item.c
@@ -23,14 +23,13 @@ kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
  */
 void
 xfs_inode_item_init(
-	xfs_inode_t		*ip,
-	xfs_mount_t		*mp)
+	struct xfs_inode	*ip,
+	struct xfs_mount	*mp)
 {
-	xfs_inode_log_item_t	*iip;
+	struct xfs_inode_log_item *iip;
 
 	ASSERT(ip->i_itemp == NULL);
-	iip = ip->i_itemp = (xfs_inode_log_item_t *)
-			kmem_zone_zalloc(xfs_ili_zone, KM_SLEEP);
+	iip = ip->i_itemp = kmem_zone_zalloc(xfs_ili_zone, KM_SLEEP);
 #ifdef LI_DEBUG
 	fprintf(stderr, "inode_item_init for inode %llu, iip=%p\n",
 		ip->i_ino, iip);
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index cf808d3..2b7d8c5 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -526,10 +526,6 @@ void xfs_buf_item_put(struct xfs_buf_log_item *bip);
 void buf_item_unlock(struct xfs_buf_log_item *bip);
 void buf_item_done(struct xfs_buf_log_item *bip);
 
-/* xfs_trans_buf.c */
-struct xfs_buf *xfs_trans_buf_item_match(struct xfs_trans *,
-			struct xfs_buftarg *, struct xfs_buf_map *, int);
-
 /* local source files */
 #define xfs_mod_fdblocks(mp, delta, rsvd) \
 	libxfs_mod_incore_sb(mp, XFS_TRANS_SB_FDBLOCKS, delta, rsvd)
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 4d83ec5..831cfa1 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -16,10 +16,6 @@
 #include "xfs_sb.h"
 #include "xfs_defer.h"
 
-/*
- * Simple transaction interface
- */
-
 kmem_zone_t	*xfs_trans_zone;
 
 /*
@@ -30,14 +26,14 @@ void
 xfs_trans_init(
 	struct xfs_mount	*mp)
 {
-	xfs_trans_resv_calc(mp, &mp->m_resv);
+	xfs_trans_resv_calc(mp, M_RES(mp));
 }
 
 /*
  * Free the transaction structure.  If there is more clean up
  * to do when the structure is freed, add it here.
  */
-static void
+STATIC void
 xfs_trans_free(
 	struct xfs_trans	*tp)
 {
@@ -106,7 +102,7 @@ xfs_trans_reserve(
 	uint			blocks,
 	uint			rtextents)
 {
-	int			error = 0;
+	int		error = 0;
 
 	/*
 	 * Attempt to reserve the needed disk blocks by decrementing
@@ -114,8 +110,9 @@ xfs_trans_reserve(
 	 * fail if the count would go below zero.
 	 */
 	if (blocks > 0) {
-		if (tp->t_mountp->m_sb.sb_fdblocks < blocks)
+		if (tp->t_mountp->m_sb.sb_fdblocks < blocks) {
 			return -ENOSPC;
+		}
 		tp->t_blk_res += blocks;
 	}
 
@@ -128,10 +125,11 @@ xfs_trans_reserve(
 		ASSERT(tp->t_log_count == 0 ||
 		       tp->t_log_count == resp->tr_logcount);
 
-		if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES)
+		if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES) {
 			tp->t_flags |= XFS_TRANS_PERM_LOG_RES;
-		else
+		} else {
 			ASSERT(!(tp->t_flags & XFS_TRANS_PERM_LOG_RES));
+		}
 
 		tp->t_log_res = resp->tr_logres;
 		tp->t_log_count = resp->tr_logcount;
@@ -156,8 +154,9 @@ xfs_trans_reserve(
 	 * reservations which have already been performed.
 	 */
 undo_blocks:
-	if (blocks > 0)
+	if (blocks > 0) {
 		tp->t_blk_res = 0;
+	}
 
 	return error;
 }
@@ -166,11 +165,10 @@ int
 xfs_trans_alloc(
 	struct xfs_mount	*mp,
 	struct xfs_trans_res	*resp,
-	unsigned int		blocks,
-	unsigned int		rtextents,
-	unsigned int		flags,
+	uint			blocks,
+	uint			rtextents,
+	uint			flags,
 	struct xfs_trans	**tpp)
-
 {
 	struct xfs_trans	*tp;
 	int			error;
@@ -235,18 +233,24 @@ xfs_trans_alloc_empty(
  * Record the indicated change to the given field for application
  * to the file system's superblock when the transaction commits.
  * For now, just store the change in the transaction structure.
+ *
  * Mark the transaction structure to indicate that the superblock
  * needs to be updated before committing.
- *
- * Originally derived from xfs_trans_mod_sb().
  */
 void
 xfs_trans_mod_sb(
-	xfs_trans_t		*tp,
-	uint			field,
-	long			delta)
+	xfs_trans_t	*tp,
+	uint		field,
+	int64_t		delta)
 {
 	switch (field) {
+	case XFS_TRANS_SB_ICOUNT:
+		ASSERT(delta > 0);
+		tp->t_icount_delta += delta;
+		break;
+	case XFS_TRANS_SB_IFREE:
+		tp->t_ifree_delta += delta;
+		break;
 	case XFS_TRANS_SB_RES_FDBLOCKS:
 		return;
 	case XFS_TRANS_SB_FDBLOCKS:
@@ -261,13 +265,6 @@ _("Transaction block reservation exceeded! %u > %u\n"),
 		}
 		tp->t_fdblocks_delta += delta;
 		break;
-	case XFS_TRANS_SB_ICOUNT:
-		ASSERT(delta > 0);
-		tp->t_icount_delta += delta;
-		break;
-	case XFS_TRANS_SB_IFREE:
-		tp->t_ifree_delta += delta;
-		break;
 	case XFS_TRANS_SB_FREXTENTS:
 		tp->t_frextents_delta += delta;
 		break;
@@ -295,7 +292,9 @@ xfs_trans_add_item(
 }
 
 /*
- * Unlink and free the given descriptor.
+ * Unlink the log item from the transaction. the log item is no longer
+ * considered dirty in this transaction, as the linked transaction has
+ * finished, either by abort or commit completion.
  */
 void
 xfs_trans_del_item(
@@ -306,7 +305,7 @@ xfs_trans_del_item(
 }
 
 /* Detach and unlock all of the items in a transaction */
-static void
+void
 xfs_trans_free_items(
 	struct xfs_trans	*tp)
 {
@@ -373,6 +372,13 @@ __xfs_trans_commit(
 			goto out_unreserve;
 	}
 
+	/*
+	 * If there is nothing to be logged by the transaction,
+	 * then unlock all of the items associated with the
+	 * transaction and free the transaction structure.
+	 * Also make sure to return any reserved blocks to
+	 * the free pool.
+	 */
 	if (!(tp->t_flags & XFS_TRANS_DIRTY)) {
 #ifdef XACT_DEBUG
 		fprintf(stderr, "committed clean transaction %p\n", tp);
@@ -380,6 +386,9 @@ __xfs_trans_commit(
 		goto out_unreserve;
 	}
 
+	/*
+	 * If we need to update the superblock, then do it now.
+	 */
 	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
 		sbp = &(tp->t_mountp->m_sb);
 		if (tp->t_icount_delta)
@@ -405,6 +414,7 @@ __xfs_trans_commit(
 out_unreserve:
 	xfs_trans_free_items(tp);
 	xfs_trans_free(tp);
+
 	return error;
 }
 
@@ -415,6 +425,14 @@ xfs_trans_commit(
 	return __xfs_trans_commit(tp, false);
 }
 
+/*
+ * Unlock all of the transaction's items and free the transaction.
+ * The transaction must not have modified any of its items, because
+ * there is no way to restore them to their previous state.
+ *
+ * If the transaction has made a log reservation, make sure to release
+ * it as well.
+ */
 void
 xfs_trans_cancel(
 	struct xfs_trans	*tp)
@@ -441,7 +459,7 @@ out:
 /*
  * Roll from one trans in the sequence of PERMANENT transactions to
  * the next: permanent transactions are only flushed out when
- * committed with XFS_TRANS_RELEASE_LOG_RES, but we still want as soon
+ * committed with xfs_trans_commit(), but we still want as soon
  * as possible to let chunks of it go to the log. So we commit the
  * chunk we've been working on and get a new transaction to continue.
  */
@@ -464,7 +482,7 @@ xfs_trans_roll(
 	/*
 	 * Commit the current transaction.
 	 * If this commit failed, then it'd just unlock those items that
-	 * are marked to be released. That also means that a filesystem shutdown
+	 * are not marked ihold. That also means that a filesystem shutdown
 	 * is in progress. The caller takes the responsibility to cancel
 	 * the duplicate transaction that gets returned.
 	 */
diff --git a/libxfs/trans_buf.c b/libxfs/trans_buf.c
index 9c2c36e..6ce3b1d 100644
--- a/libxfs/trans_buf.c
+++ b/libxfs/trans_buf.c
@@ -4,7 +4,6 @@
  * Copyright (C) 2010 Red Hat, Inc.
  * All Rights Reserved.
  */
-
 #include "libxfs_priv.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
@@ -17,22 +16,18 @@
 #include "xfs_sb.h"
 
 /*
- * Following functions from fs/xfs/xfs_trans_buf.c
- */
-
-/*
  * Check to see if a buffer matching the given parameters is already
  * a part of the given transaction.
  */
-xfs_buf_t *
+STATIC struct xfs_buf *
 xfs_trans_buf_item_match(
-	xfs_trans_t		*tp,
-	struct xfs_buftarg	*btp,
+	struct xfs_trans	*tp,
+	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps)
 {
 	struct xfs_log_item	*lip;
-	struct xfs_buf_log_item *blip;
+	struct xfs_buf_log_item	*blip;
 	int			len = 0;
 	int			i;
 
@@ -42,7 +37,7 @@ xfs_trans_buf_item_match(
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		blip = (struct xfs_buf_log_item *)lip;
 		if (blip->bli_item.li_type == XFS_LI_BUF &&
-		    blip->bli_buf->b_target->dev == btp->dev &&
+		    blip->bli_buf->b_target->dev == target->dev &&
 		    XFS_BUF_ADDR(blip->bli_buf) == map[0].bm_bn &&
 		    blip->bli_buf->b_bcount == BBTOB(len)) {
 			ASSERT(blip->bli_buf->b_map_count == nmaps);
@@ -55,10 +50,10 @@ xfs_trans_buf_item_match(
 
 void
 xfs_trans_bjoin(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
 {
-	xfs_buf_log_item_t	*bip;
+	struct xfs_buf_log_item	*bip;
 
 	ASSERT(bp->b_transp == NULL);
 #ifdef XACT_DEBUG
@@ -71,21 +66,36 @@ xfs_trans_bjoin(
 	bp->b_transp = tp;
 }
 
-xfs_buf_t *
+/*
+ * Get and lock the buffer for the caller if it is not already
+ * locked within the given transaction.  If it is already locked
+ * within the transaction, just increment its lock recursion count
+ * and return a pointer to it.
+ *
+ * If the transaction pointer is NULL, make this just a normal
+ * get_buf() call.
+ */
+struct xfs_buf *
 xfs_trans_get_buf_map(
-	xfs_trans_t		*tp,
-	struct xfs_buftarg	*btp,
+	struct xfs_trans	*tp,
+	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
-	uint			f)
+	uint			flags)
 {
 	xfs_buf_t		*bp;
-	xfs_buf_log_item_t	*bip;
-
-	if (tp == NULL)
-		return libxfs_getbuf_map(btp, map, nmaps, 0);
-
-	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
+	struct xfs_buf_log_item	*bip;
+
+	if (!tp)
+		return libxfs_getbuf_map(target, map, nmaps, 0);
+
+	/*
+	 * If we find the buffer in the cache with this transaction
+	 * pointer in its b_fsprivate2 field, then we know we already
+	 * have it locked.  In this case we just increment the lock
+	 * recursion count and return the buffer to the caller.
+	 */
+	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
 	if (bp != NULL) {
 		ASSERT(bp->b_transp == tp);
 		bip = bp->b_log_item;
@@ -94,9 +104,10 @@ xfs_trans_get_buf_map(
 		return bp;
 	}
 
-	bp = libxfs_getbuf_map(btp, map, nmaps, 0);
-	if (bp == NULL)
+	bp = libxfs_getbuf_map(target, map, nmaps, 0);
+	if (bp == NULL) {
 		return NULL;
+	}
 #ifdef XACT_DEBUG
 	fprintf(stderr, "trans_get_buf buffer %p, transaction %p\n", bp, tp);
 #endif
@@ -107,14 +118,22 @@ xfs_trans_get_buf_map(
 	return bp;
 }
 
+/*
+ * Get and lock the superblock buffer of this file system for the
+ * given transaction.
+ *
+ * We don't need to use incore_match() here, because the superblock
+ * buffer is a private buffer which we keep a pointer to in the
+ * mount structure.
+ */
 xfs_buf_t *
 xfs_trans_getsb(
 	xfs_trans_t		*tp,
-	xfs_mount_t		*mp,
+	struct xfs_mount	*mp,
 	int			flags)
 {
 	xfs_buf_t		*bp;
-	xfs_buf_log_item_t	*bip;
+	struct xfs_buf_log_item	*bip;
 	int			len = XFS_FSS_TO_BB(mp, 1);
 	DEFINE_SINGLE_BUF_MAP(map, XFS_SB_DADDR, len);
 
@@ -141,25 +160,35 @@ xfs_trans_getsb(
 	return bp;
 }
 
+/*
+ * Get and lock the buffer for the caller if it is not already
+ * locked within the given transaction.  If it has not yet been
+ * read in, read it from disk. If it is already locked
+ * within the transaction and already read in, just increment its
+ * lock recursion count and return a pointer to it.
+ *
+ * If the transaction pointer is NULL, make this just a normal
+ * read_buf() call.
+ */
 int
 xfs_trans_read_buf_map(
-	xfs_mount_t		*mp,
-	xfs_trans_t		*tp,
-	struct xfs_buftarg	*btp,
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
 	uint			flags,
-	xfs_buf_t		**bpp,
+	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
-	xfs_buf_t		*bp;
-	xfs_buf_log_item_t	*bip;
+	struct xfs_buf		*bp;
+	struct xfs_buf_log_item	*bip;
 	int			error;
 
 	*bpp = NULL;
 
 	if (tp == NULL) {
-		bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
+		bp = libxfs_readbuf_map(target, map, nmaps, flags, ops);
 		if (!bp) {
 			return (flags & XBF_TRYLOCK) ?  -EAGAIN : -ENOMEM;
 		}
@@ -168,7 +197,7 @@ xfs_trans_read_buf_map(
 		goto done;
 	}
 
-	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
+	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
 	if (bp != NULL) {
 		ASSERT(bp->b_transp == tp);
 		ASSERT(bp->b_log_item != NULL);
@@ -177,7 +206,7 @@ xfs_trans_read_buf_map(
 		goto done;
 	}
 
-	bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
+	bp = libxfs_readbuf_map(target, map, nmaps, flags, ops);
 	if (!bp) {
 		return (flags & XBF_TRYLOCK) ?  -EAGAIN : -ENOMEM;
 	}
@@ -200,47 +229,80 @@ out_relse:
 	return error;
 }
 
+/*
+ * Release a buffer previously joined to the transaction. If the buffer is
+ * modified within this transaction, decrement the recursion count but do not
+ * release the buffer even if the count goes to 0. If the buffer is not modified
+ * within the transaction, decrement the recursion count and release the buffer
+ * if the recursion count goes to 0.
+ *
+ * If the buffer is to be released and it was not already dirty before this
+ * transaction began, then also free the buf_log_item associated with it.
+ *
+ * If the transaction pointer is NULL, this is a normal xfs_buf_relse() call.
+ */
 void
 xfs_trans_brelse(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
 {
-	xfs_buf_log_item_t	*bip;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 #ifdef XACT_DEBUG
 	fprintf(stderr, "released buffer %p, transaction %p\n", bp, tp);
 #endif
 
-	if (tp == NULL) {
+	if (!tp) {
 		ASSERT(bp->b_transp == NULL);
 		libxfs_putbuf(bp);
 		return;
 	}
 	ASSERT(bp->b_transp == tp);
-	bip = bp->b_log_item;
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
+
+	/*
+	 * If the release is for a recursive lookup, then decrement the count
+	 * and return.
+	 */
 	if (bip->bli_recur > 0) {
 		bip->bli_recur--;
 		return;
 	}
-	/* If dirty/stale, can't release till transaction committed */
-	if (bip->bli_flags & XFS_BLI_STALE)
-		return;
+
+	/*
+	 * If the buffer is invalidated or dirty in this transaction, we can't
+	 * release it until we commit.
+	 */
 	if (test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags))
 		return;
+	if (bip->bli_flags & XFS_BLI_STALE)
+		return;
+
+	/*
+	 * Unlink the log item from the transaction and clear the hold flag, if
+	 * set. We wouldn't want the next user of the buffer to get confused.
+	 */
 	xfs_trans_del_item(&bip->bli_item);
-	if (bip->bli_flags & XFS_BLI_HOLD)
-		bip->bli_flags &= ~XFS_BLI_HOLD;
+	bip->bli_flags &= ~XFS_BLI_HOLD;
+
+	/* drop the reference to the bli */
 	xfs_buf_item_put(bip);
+
 	bp->b_transp = NULL;
 	libxfs_putbuf(bp);
 }
 
+/*
+ * Mark the buffer as not needing to be unlocked when the buf item's
+ * iop_unlock() routine is called.  The buffer msut already be locked
+ * and associated with the given transaction.
+ */
+/* ARGSUSED */
 void
 xfs_trans_bhold(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
 {
-	xfs_buf_log_item_t	*bip = bp->b_log_item;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
@@ -289,18 +351,48 @@ xfs_trans_log_buf(
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	ASSERT((first <= last) && (last < bp->b_bcount));
+	ASSERT(first <= last && last < bp->b_bcount);
 
 	xfs_trans_dirty_buf(tp, bp);
 	xfs_buf_item_log(bip, first, last);
 }
 
+
+/*
+ * Invalidate a buffer that is being used within a transaction.
+ *
+ * Typically this is because the blocks in the buffer are being freed, so we
+ * need to prevent it from being written out when we're done.  Allowing it
+ * to be written again might overwrite data in the free blocks if they are
+ * reallocated to a file.
+ *
+ * We prevent the buffer from being written out by marking it stale.  We can't
+ * get rid of the buf log item at this point because the buffer may still be
+ * pinned by another transaction.  If that is the case, then we'll wait until
+ * the buffer is committed to disk for the last time (we can tell by the ref
+ * count) and free it in xfs_buf_item_unpin().  Until that happens we will
+ * keep the buffer locked so that the buffer and buf log item are not reused.
+ *
+ * We also set the XFS_BLF_CANCEL flag in the buf log format structure and log
+ * the buf item.  This will be used at recovery time to determine that copies
+ * of the buffer in the log before this should not be replayed.
+ *
+ * We mark the item descriptor and the transaction dirty so that we'll hold
+ * the buffer until after the commit.
+ *
+ * Since we're invalidating the buffer, we also clear the state about which
+ * parts of the buffer have been logged.  We also clear the flag indicating
+ * that this is an inode buffer since the data in the buffer will no longer
+ * be valid.
+ *
+ * We set the stale bit in the buffer as well since we're getting rid of it.
+ */
 void
 xfs_trans_binval(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
 {
-	xfs_buf_log_item_t	*bip = bp->b_log_item;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 #ifdef XACT_DEBUG
 	fprintf(stderr, "binval'd buffer %p, transaction %p\n", bp, tp);
 #endif
@@ -308,10 +400,12 @@ xfs_trans_binval(
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 
-	if (bip->bli_flags & XFS_BLI_STALE)
+	if (bip->bli_flags & XFS_BLI_STALE) {
 		return;
+	}
 	XFS_BUF_UNDELAYWRITE(bp);
 	xfs_buf_stale(bp);
+
 	bip->bli_flags |= XFS_BLI_STALE;
 	bip->bli_flags &= ~XFS_BLI_DIRTY;
 	bip->bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
@@ -320,12 +414,21 @@ xfs_trans_binval(
 	tp->t_flags |= XFS_TRANS_DIRTY;
 }
 
+/*
+ * Mark the buffer as being one which contains newly allocated
+ * inodes.  We need to make sure that even if this buffer is
+ * relogged as an 'inode buf' we still recover all of the inode
+ * images in the face of a crash.  This works in coordination with
+ * xfs_buf_item_committed() to ensure that the buffer remains in the
+ * AIL at its original location even after it has been relogged.
+ */
+/* ARGSUSED */
 void
 xfs_trans_inode_alloc_buf(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
 {
-	xfs_buf_log_item_t	*bip = bp->b_log_item;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-- 
1.8.3.1

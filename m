Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D46C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiJBS3b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJBS3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:29:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434D13C152
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:29:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E7BCB80D86
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B2AC433C1;
        Sun,  2 Oct 2022 18:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735362;
        bh=uQL84dVZLPomVvK7qCc0z2vC2LAcS3gZusUszYUuvM8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qEAteuyq7mTQbkDH+Ukh8/bV30htiArLjPxw+0mxw2YzA28JNTWlxuY5A4sHGnJx/
         T0cXFQ2gW6LxnVD6vgEXMk91+FHo7X1312ExXiz4zke1pA6rAdfL6m2V8+VtiRi1NC
         2DXPFy7Gy++15tfv/TQ98Fqi+pUJ2s/TtFGY9mEEP3LYGa2iabjn2cmvl2gnbnH5R2
         DtIu58+tKkmPauRB3PiwZd1qSrYo15a3EegOI+7pyELo2Z75uWH9ZKO7oceVIgaJlc
         sdFxHPR7ey1HRlpIVg0Hz4IbEAfJg/rZ19M3y0pxwkfxIrUSj2oIdHX6/6tdN/Ayhc
         vfyHQ9Cl+1RBA==
Subject: [PATCH 1/5] xfs: allow queued AG intents to drain before scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:58 -0700
Message-ID: <166473479890.1083534.11387309675967725858.stgit@magnolia>
In-Reply-To: <166473479864.1083534.16821762305468128245.stgit@magnolia>
References: <166473479864.1083534.16821762305468128245.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When a writer thread executes a chain of log intent items, the AG header
buffer locks will cycle during a transaction roll to get from one intent
item to the next in a chain.  Although scrub takes all AG header buffer
locks, this isn't sufficient to guard against scrub checking an AG while
that writer thread is in the middle of finishing a chain because there's
no higher level locking primitive guarding allocation groups.

When there's a collision, cross-referencing between data structures
(e.g. rmapbt and refcountbt) yields false corruption events; if repair
is running, this results in incorrect repairs, which is catastrophic.

Fix this by adding to the perag structure the count of active intents
and make scrub wait until it has both AG header buffer locks and the
intent counter reaches zero.  This is a little stupid since transactions
can queue intents without taking buffer locks, but it's not the end of
the world for scrub to wait (in KILLABLE state) for those transactions.

In the next patch we'll improve on this facility, but this patch
provides the basic functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig             |    4 ++
 fs/xfs/libxfs/xfs_ag.c     |    4 ++
 fs/xfs/libxfs/xfs_ag.h     |    8 +++
 fs/xfs/libxfs/xfs_defer.c  |   10 +++-
 fs/xfs/libxfs/xfs_defer.h  |    3 +
 fs/xfs/scrub/common.c      |  103 +++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/scrub/health.c      |    2 +
 fs/xfs/scrub/refcount.c    |    2 +
 fs/xfs/xfs_attr_item.c     |    1 
 fs/xfs/xfs_bmap_item.c     |   48 ++++++++++++++++++++-
 fs/xfs/xfs_extfree_item.c  |   30 +++++++++++++
 fs/xfs/xfs_mount.c         |   76 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h         |   52 ++++++++++++++++++++++
 fs/xfs/xfs_refcount_item.c |   25 +++++++++++
 fs/xfs/xfs_rmap_item.c     |   18 ++++++++
 fs/xfs/xfs_trace.h         |   71 ++++++++++++++++++++++++++++++
 16 files changed, 441 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 8618ad0f84cd..a4eff514b647 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -93,10 +93,14 @@ config XFS_RT
 
 	  If unsure, say N.
 
+config XFS_DRAIN_INTENTS
+	bool
+
 config XFS_ONLINE_SCRUB
 	bool "XFS online metadata check support"
 	default n
 	depends on XFS_FS
+	select XFS_DRAIN_INTENTS
 	help
 	  If you say Y here you will be able to check metadata on a
 	  mounted XFS filesystem.  This feature is intended to reduce
diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index bb0c700afe3c..27ba30f8f64b 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -192,6 +192,7 @@ xfs_free_perag(
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
 		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
+		xfs_drain_free(&pag->pag_intents);
 
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 		xfs_buf_hash_destroy(pag);
@@ -313,6 +314,7 @@ xfs_initialize_perag(
 		spin_lock_init(&pag->pag_state_lock);
 		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+		xfs_drain_init(&pag->pag_intents);
 		init_waitqueue_head(&pag->pagb_wait);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
@@ -345,6 +347,7 @@ xfs_initialize_perag(
 	return 0;
 
 out_remove_pag:
+	xfs_drain_free(&pag->pag_intents);
 	radix_tree_delete(&mp->m_perag_tree, index);
 out_free_pag:
 	kmem_free(pag);
@@ -355,6 +358,7 @@ xfs_initialize_perag(
 		if (!pag)
 			break;
 		xfs_buf_hash_destroy(pag);
+		xfs_drain_free(&pag->pag_intents);
 		kmem_free(pag);
 	}
 	return error;
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 517a138faa66..73dfdf2119ee 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -103,6 +103,14 @@ struct xfs_perag {
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
 
+	/*
+	 * We use xfs_drain to track the number of deferred log intent items
+	 * that have been queued (but not yet processed) so that waiters (e.g.
+	 * scrub) will not lock resources when other threads are in the middle
+	 * of processing a chain of intent items only to find momentary
+	 * inconsistencies.
+	 */
+	struct xfs_drain	pag_intents;
 #endif /* __KERNEL__ */
 };
 
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5a321b783398..7e977b1ef505 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -397,7 +397,8 @@ xfs_defer_cancel_list(
 		list_for_each_safe(pwi, n, &dfp->dfp_work) {
 			list_del(pwi);
 			dfp->dfp_count--;
-			ops->cancel_item(pwi);
+			trace_xfs_defer_cancel_item(mp, dfp, pwi);
+			ops->cancel_item(mp, pwi);
 		}
 		ASSERT(dfp->dfp_count == 0);
 		kmem_cache_free(xfs_defer_pending_cache, dfp);
@@ -476,6 +477,7 @@ xfs_defer_finish_one(
 	list_for_each_safe(li, n, &dfp->dfp_work) {
 		list_del(li);
 		dfp->dfp_count--;
+		trace_xfs_defer_finish_item(tp->t_mountp, dfp, li);
 		error = ops->finish_item(tp, dfp->dfp_done, li, &state);
 		if (error == -EAGAIN) {
 			int		ret;
@@ -623,7 +625,7 @@ xfs_defer_add(
 	struct list_head		*li)
 {
 	struct xfs_defer_pending	*dfp = NULL;
-	const struct xfs_defer_op_type	*ops;
+	const struct xfs_defer_op_type	*ops = defer_op_types[type];
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
@@ -636,7 +638,6 @@ xfs_defer_add(
 	if (!list_empty(&tp->t_dfops)) {
 		dfp = list_last_entry(&tp->t_dfops,
 				struct xfs_defer_pending, dfp_list);
-		ops = defer_op_types[dfp->dfp_type];
 		if (dfp->dfp_type != type ||
 		    (ops->max_items && dfp->dfp_count >= ops->max_items))
 			dfp = NULL;
@@ -653,6 +654,9 @@ xfs_defer_add(
 	}
 
 	list_add_tail(li, &dfp->dfp_work);
+	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
+	if (ops->add_item)
+		ops->add_item(tp->t_mountp, li);
 	dfp->dfp_count++;
 }
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..6cce34fcefe2 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -55,7 +55,8 @@ struct xfs_defer_op_type {
 			struct list_head *item, struct xfs_btree_cur **state);
 	void (*finish_cleanup)(struct xfs_trans *tp,
 			struct xfs_btree_cur *state, int error);
-	void (*cancel_item)(struct list_head *item);
+	void (*cancel_item)(struct xfs_mount *mp, struct list_head *item);
+	void (*add_item)(struct xfs_mount *mp, const struct list_head *item);
 	unsigned int		max_items;
 };
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index ad70f29233c3..cc4882c0cfc2 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -396,26 +396,19 @@ want_ag_read_header_failure(
 }
 
 /*
- * Grab the perag structure and all the headers for an AG.
+ * Grab the AG header buffers for the attached perag structure.
  *
  * The headers should be released by xchk_ag_free, but as a fail safe we attach
  * all the buffers we grab to the scrub transaction so they'll all be freed
- * when we cancel it.  Returns ENOENT if we can't grab the perag structure.
+ * when we cancel it.
  */
-int
-xchk_ag_read_headers(
+static inline int
+xchk_perag_read_headers(
 	struct xfs_scrub	*sc,
-	xfs_agnumber_t		agno,
 	struct xchk_ag		*sa)
 {
-	struct xfs_mount	*mp = sc->mp;
 	int			error;
 
-	ASSERT(!sa->pag);
-	sa->pag = xfs_perag_get(mp, agno);
-	if (!sa->pag)
-		return -ENOENT;
-
 	error = xfs_ialloc_read_agi(sa->pag, sc->tp, &sa->agi_bp);
 	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGI))
 		return error;
@@ -427,6 +420,94 @@ xchk_ag_read_headers(
 	return 0;
 }
 
+/*
+ * Grab the AG headers for the attached perag structure and wait for pending
+ * intents to drain.
+ */
+static int
+xchk_perag_lock(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_ag		*sa = &sc->sa;
+	int			error = 0;
+
+	ASSERT(sa->pag != NULL);
+	ASSERT(sa->agi_bp == NULL);
+	ASSERT(sa->agf_bp == NULL);
+
+	do {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		error = xchk_perag_read_headers(sc, sa);
+		if (error)
+			return error;
+
+		/*
+		 * Decide if this AG is quiet enough for all metadata to be
+		 * consistent with each other.  XFS allows the AG header buffer
+		 * locks to cycle across transaction rolls while processing
+		 * chains of deferred ops, which means that there could be
+		 * other threads in the middle of processing a chain of
+		 * deferred ops.  For regular operations we are careful about
+		 * ordering operations to prevent collisions between threads
+		 * (which is why we don't need a per-AG lock), but scrub and
+		 * repair have to serialize against chained operations.
+		 *
+		 * We just locked all the AG headers buffers; now take a look
+		 * to see if there are any intents in progress.  If there are,
+		 * drop the AG headers and wait for the intents to drain.
+		 * Since we hold all the AG header locks for the duration of
+		 * the scrub, this is the only time we have to sample the
+		 * intents counter; any threads increasing it after this point
+		 * can't possibly be in the middle of a chain of AG metadata
+		 * updates.
+		 *
+		 * Obviously, this should be slanted against scrub and in favor
+		 * of runtime threads.
+		 */
+		if (!xfs_ag_intents_busy(sa->pag))
+			return 0;
+
+		if (sa->agf_bp) {
+			xfs_trans_brelse(sc->tp, sa->agf_bp);
+			sa->agf_bp = NULL;
+		}
+
+		if (sa->agi_bp) {
+			xfs_trans_brelse(sc->tp, sa->agi_bp);
+			sa->agi_bp = NULL;
+		}
+
+		error = xfs_ag_drain_intents(sa->pag);
+		if (error == -ERESTARTSYS)
+			error = -EINTR;
+	} while (!error);
+
+	return error;
+}
+
+/*
+ * Grab the per-AG structure, grab all AG header buffers, and wait until there
+ * aren't any pending intents.  Returns -ENOENT if we can't grab the perag
+ * structure.
+ */
+int
+xchk_ag_read_headers(
+	struct xfs_scrub	*sc,
+	xfs_agnumber_t		agno,
+	struct xchk_ag		*sa)
+{
+	struct xfs_mount	*mp = sc->mp;
+
+	ASSERT(!sa->pag);
+	sa->pag = xfs_perag_get(mp, agno);
+	if (!sa->pag)
+		return -ENOENT;
+
+	return xchk_perag_lock(sc);
+}
+
 /* Release all the AG btree cursors. */
 void
 xchk_ag_btcur_free(
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index aa65ec88a0c0..f7c5a109615f 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -7,6 +7,8 @@
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
 #include "xfs_btree.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index f037e73922c1..e4a550f8d1b7 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -7,6 +7,8 @@
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
 #include "xfs_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 5077a7ad5646..4d3722281845 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -504,6 +504,7 @@ xfs_attr_abort_intent(
 /* Cancel an attr */
 STATIC void
 xfs_attr_cancel_item(
+	struct xfs_mount		*mp,
 	struct list_head		*item)
 {
 	struct xfs_attr_intent		*attr;
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 51f66e982484..996e9fd146f8 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -370,6 +370,18 @@ xfs_bmap_update_create_done(
 	return &xfs_trans_get_bud(tp, BUI_ITEM(intent))->bud_item;
 }
 
+static inline void
+xfs_bmap_drop_intents(
+	struct xfs_mount		*mp,
+	const struct xfs_bmap_intent	*bi,
+	xfs_fsblock_t			orig_startblock)
+{
+	if (!xfs_has_rmapbt(mp))
+		return;
+
+	xfs_fs_drop_intents(mp, orig_startblock);
+}
+
 /* Process a deferred rmap update. */
 STATIC int
 xfs_bmap_update_finish_item(
@@ -379,10 +391,13 @@ xfs_bmap_update_finish_item(
 	struct xfs_btree_cur		**state)
 {
 	struct xfs_bmap_intent		*bmap;
+	struct xfs_mount		*mp = tp->t_mountp;
+	xfs_fsblock_t			orig_startblock;
 	xfs_filblks_t			count;
 	int				error;
 
 	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
+	orig_startblock = bmap->bi_bmap.br_startblock;
 	count = bmap->bi_bmap.br_blockcount;
 	error = xfs_trans_log_finish_bmap_update(tp, BUD_ITEM(done),
 			bmap->bi_type,
@@ -396,6 +411,14 @@ xfs_bmap_update_finish_item(
 		bmap->bi_bmap.br_blockcount = count;
 		return -EAGAIN;
 	}
+
+	/*
+	 * Drop our intent counter reference now that we've either queued a
+	 * deferred rmap intent or failed.  Be careful to use the original
+	 * startblock since the finishing functions can update the intent
+	 * state.
+	 */
+	xfs_bmap_drop_intents(mp, bmap, orig_startblock);
 	kmem_cache_free(xfs_bmap_intent_cache, bmap);
 	return error;
 }
@@ -408,17 +431,39 @@ xfs_bmap_update_abort_intent(
 	xfs_bui_release(BUI_ITEM(intent));
 }
 
-/* Cancel a deferred rmap update. */
+/* Cancel a deferred bmap update. */
 STATIC void
 xfs_bmap_update_cancel_item(
+	struct xfs_mount		*mp,
 	struct list_head		*item)
 {
 	struct xfs_bmap_intent		*bmap;
 
 	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
+	xfs_bmap_drop_intents(mp, bmap, bmap->bi_bmap.br_startblock);
 	kmem_cache_free(xfs_bmap_intent_cache, bmap);
 }
 
+/* Add a deferred bmap update. */
+STATIC void
+xfs_bmap_update_add_item(
+	struct xfs_mount		*mp,
+	const struct list_head		*item)
+{
+	const struct xfs_bmap_intent	*bi;
+
+	bi = container_of(item, struct xfs_bmap_intent, bi_list);
+
+	/*
+	 * Grab an intent counter reference on behalf of the deferred rmap
+	 * intent item that we will queue when we finish this bmap work.
+	 */
+	if (!xfs_has_rmapbt(mp))
+		return;
+
+	xfs_fs_bump_intents(mp, bi->bi_bmap.br_startblock);
+}
+
 const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
 	.create_intent	= xfs_bmap_update_create_intent,
@@ -426,6 +471,7 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.create_done	= xfs_bmap_update_create_done,
 	.finish_item	= xfs_bmap_update_finish_item,
 	.cancel_item	= xfs_bmap_update_cancel_item,
+	.add_item	= xfs_bmap_update_add_item,
 };
 
 /* Is this recovered BUI ok? */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 27ccfcd82f04..92032f2b7be0 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -477,6 +477,14 @@ xfs_extent_free_create_done(
 	return &xfs_trans_get_efd(tp, EFI_ITEM(intent), count)->efd_item;
 }
 
+static inline void
+xfs_extent_free_drop_intents(
+	struct xfs_mount			*mp,
+	const struct xfs_extent_free_item	*xefi)
+{
+	xfs_fs_drop_intents(mp, xefi->xefi_startblock);
+}
+
 /* Process a free extent. */
 STATIC int
 xfs_extent_free_finish_item(
@@ -486,6 +494,7 @@ xfs_extent_free_finish_item(
 	struct xfs_btree_cur		**state)
 {
 	struct xfs_owner_info		oinfo = { };
+	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent_free_item	*free;
 	int				error;
 
@@ -499,6 +508,8 @@ xfs_extent_free_finish_item(
 			free->xefi_startblock,
 			free->xefi_blockcount,
 			&oinfo, free->xefi_flags & XFS_EFI_SKIP_DISCARD);
+
+	xfs_extent_free_drop_intents(mp, free);
 	kmem_cache_free(xfs_extfree_item_cache, free);
 	return error;
 }
@@ -514,14 +525,30 @@ xfs_extent_free_abort_intent(
 /* Cancel a free extent. */
 STATIC void
 xfs_extent_free_cancel_item(
+	struct xfs_mount		*mp,
 	struct list_head		*item)
 {
 	struct xfs_extent_free_item	*free;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
+	xfs_extent_free_drop_intents(mp, free);
 	kmem_cache_free(xfs_extfree_item_cache, free);
 }
 
+/* Add a deferred free extent. */
+STATIC void
+xfs_extent_free_add_item(
+	struct xfs_mount		*mp,
+	const struct list_head		*item)
+{
+	const struct xfs_extent_free_item *xefi;
+
+	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
+
+	/* Grab an intent counter reference for this intent item. */
+	xfs_fs_bump_intents(mp, xefi->xefi_startblock);
+}
+
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
 	.create_intent	= xfs_extent_free_create_intent,
@@ -529,6 +556,7 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.create_done	= xfs_extent_free_create_done,
 	.finish_item	= xfs_extent_free_finish_item,
 	.cancel_item	= xfs_extent_free_cancel_item,
+	.add_item	= xfs_extent_free_add_item,
 };
 
 /*
@@ -585,6 +613,7 @@ xfs_agfl_free_finish_item(
 	extp->ext_len = free->xefi_blockcount;
 	efdp->efd_next_extent++;
 
+	xfs_extent_free_drop_intents(mp, free);
 	kmem_cache_free(xfs_extfree_item_cache, free);
 	return error;
 }
@@ -597,6 +626,7 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 	.create_done	= xfs_extent_free_create_done,
 	.finish_item	= xfs_agfl_free_finish_item,
 	.cancel_item	= xfs_extent_free_cancel_item,
+	.add_item	= xfs_extent_free_add_item,
 };
 
 /* Is this recovered EFI ok? */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f10c88cee116..6c84c6547a0b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1385,3 +1385,79 @@ xfs_mod_delalloc(
 	percpu_counter_add_batch(&mp->m_delalloc_blks, delta,
 			XFS_DELALLOC_BATCH);
 }
+
+#ifdef CONFIG_XFS_DRAIN_INTENTS
+/* Increase the pending intent count. */
+static inline void xfs_drain_bump(struct xfs_drain *dr)
+{
+	atomic_inc(&dr->dr_count);
+}
+
+/* Decrease the pending intent count, and wake any waiters, if appropriate. */
+static inline void xfs_drain_drop(struct xfs_drain *dr)
+{
+	if (atomic_dec_and_test(&dr->dr_count) &&
+	    wq_has_sleeper(&dr->dr_waiters))
+		wake_up(&dr->dr_waiters);
+}
+
+/*
+ * Wait for the pending intent count for a drain to hit zero.
+ *
+ * Callers must not hold any locks that would prevent intents from being
+ * finished.
+ */
+static inline int xfs_drain_wait(struct xfs_drain *dr)
+{
+	return wait_event_killable(dr->dr_waiters, !xfs_drain_busy(dr));
+}
+
+/* Add an item to the pending count. */
+void
+xfs_fs_bump_intents(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsb)
+{
+	struct xfs_perag	*pag;
+
+	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, fsb));
+	trace_xfs_perag_bump_intents(pag, __return_address);
+	xfs_drain_bump(&pag->pag_intents);
+	xfs_perag_put(pag);
+}
+
+/* Remove an item from the pending count. */
+void
+xfs_fs_drop_intents(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsb)
+{
+	struct xfs_perag	*pag;
+
+	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, fsb));
+	trace_xfs_perag_drop_intents(pag, __return_address);
+	xfs_drain_drop(&pag->pag_intents);
+	xfs_perag_put(pag);
+}
+
+/*
+ * Wait for the pending intent count for AG metadata to hit zero.
+ * Callers must not hold any AG header buffers.
+ */
+int
+xfs_ag_drain_intents(
+	struct xfs_perag	*pag)
+{
+	trace_xfs_perag_wait_intents(pag, __return_address);
+	return xfs_drain_wait(&pag->pag_intents);
+}
+
+/* Might someone else be processing intents for this AG? */
+bool
+xfs_ag_intents_busy(
+	struct xfs_perag	*pag)
+{
+	return xfs_drain_busy(&pag->pag_intents);
+}
+
+#endif /* CONFIG_XFS_DRAIN_INTENTS */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 8aca2cc173ac..ddf438701022 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -56,6 +56,58 @@ struct xfs_error_cfg {
 	long		retry_timeout;	/* in jiffies, -1 = infinite */
 };
 
+#ifdef CONFIG_XFS_DRAIN_INTENTS
+/*
+ * Passive drain mechanism.  This data structure tracks a count of some items
+ * and contains a waitqueue for callers who would like to wake up when the
+ * count hits zero.
+ */
+struct xfs_drain {
+	/* Number of items pending in some part of the filesystem. */
+	atomic_t		dr_count;
+
+	/* Queue to wait for dri_count to go to zero */
+	struct wait_queue_head	dr_waiters;
+};
+
+int xfs_ag_drain_intents(struct xfs_perag *pag);
+bool xfs_ag_intents_busy(struct xfs_perag *pag);
+
+void xfs_fs_bump_intents(struct xfs_mount *mp, xfs_fsblock_t fsb);
+void xfs_fs_drop_intents(struct xfs_mount *mp, xfs_fsblock_t fsb);
+
+/* Are there work items pending? */
+static inline bool xfs_drain_busy(struct xfs_drain *dr)
+{
+	return atomic_read(&dr->dr_count) > 0;
+}
+
+static inline void xfs_drain_init(struct xfs_drain *dr)
+{
+	atomic_set(&dr->dr_count, 0);
+	init_waitqueue_head(&dr->dr_waiters);
+}
+
+static inline void xfs_drain_free(struct xfs_drain *dr)
+{
+	ASSERT(!xfs_drain_busy(dr));
+}
+#else
+struct xfs_drain { /* empty */ };
+
+static inline void
+xfs_fs_bump_intents(struct xfs_mount *mp, xfs_fsblock_t fsb)
+{
+}
+
+static inline void
+xfs_fs_drop_intents(struct xfs_mount *mp, xfs_fsblock_t fsb)
+{
+}
+# define xfs_drain_init(dr)	((void)0)
+# define xfs_drain_free(dr)	((void)0)
+#endif /* CONFIG_XFS_DRAIN_INTENTS */
+
 /*
  * Per-cpu deferred inode inactivation GC lists.
  */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 7e97bf19793d..f16208b0929d 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -379,11 +379,14 @@ xfs_refcount_update_finish_item(
 	struct xfs_btree_cur		**state)
 {
 	struct xfs_refcount_intent	*refc;
+	struct xfs_mount		*mp = tp->t_mountp;
+	xfs_fsblock_t			orig_startblock;
 	xfs_fsblock_t			new_fsb;
 	xfs_extlen_t			new_aglen;
 	int				error;
 
 	refc = container_of(item, struct xfs_refcount_intent, ri_list);
+	orig_startblock = refc->ri_startblock;
 	error = xfs_trans_log_finish_refcount_update(tp, CUD_ITEM(done),
 			refc->ri_type, refc->ri_startblock, refc->ri_blockcount,
 			&new_fsb, &new_aglen, state);
@@ -396,6 +399,13 @@ xfs_refcount_update_finish_item(
 		refc->ri_blockcount = new_aglen;
 		return -EAGAIN;
 	}
+
+	/*
+	 * Drop our intent counter reference now that we've finished all the
+	 * work or failed.  Be careful to use the original startblock because
+	 * the finishing functions can update the intent state.
+	 */
+	xfs_fs_drop_intents(mp, orig_startblock);
 	kmem_cache_free(xfs_refcount_intent_cache, refc);
 	return error;
 }
@@ -411,14 +421,28 @@ xfs_refcount_update_abort_intent(
 /* Cancel a deferred refcount update. */
 STATIC void
 xfs_refcount_update_cancel_item(
+	struct xfs_mount		*mp,
 	struct list_head		*item)
 {
 	struct xfs_refcount_intent	*refc;
 
 	refc = container_of(item, struct xfs_refcount_intent, ri_list);
+	xfs_fs_drop_intents(mp, refc->ri_startblock);
 	kmem_cache_free(xfs_refcount_intent_cache, refc);
 }
 
+/* Add a deferred refcount update. */
+STATIC void
+xfs_refcount_update_add_item(
+	struct xfs_mount		*mp,
+	const struct list_head		*item)
+{
+	const struct xfs_refcount_intent *ri;
+
+	ri = container_of(item, struct xfs_refcount_intent, ri_list);
+	xfs_fs_bump_intents(mp, ri->ri_startblock);
+}
+
 const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
 	.create_intent	= xfs_refcount_update_create_intent,
@@ -427,6 +451,7 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.finish_item	= xfs_refcount_update_finish_item,
 	.finish_cleanup = xfs_refcount_finish_one_cleanup,
 	.cancel_item	= xfs_refcount_update_cancel_item,
+	.add_item	= xfs_refcount_update_add_item,
 };
 
 /* Is this recovered CUI ok? */
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index fef92e02f3bb..b107eb4759b1 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -431,6 +431,7 @@ xfs_rmap_update_finish_item(
 	struct xfs_btree_cur		**state)
 {
 	struct xfs_rmap_intent		*rmap;
+	struct xfs_mount		*mp = tp->t_mountp;
 	int				error;
 
 	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
@@ -439,6 +440,8 @@ xfs_rmap_update_finish_item(
 			rmap->ri_bmap.br_startoff, rmap->ri_bmap.br_startblock,
 			rmap->ri_bmap.br_blockcount, rmap->ri_bmap.br_state,
 			state);
+
+	xfs_fs_drop_intents(mp, rmap->ri_bmap.br_startblock);
 	kmem_cache_free(xfs_rmap_intent_cache, rmap);
 	return error;
 }
@@ -454,14 +457,28 @@ xfs_rmap_update_abort_intent(
 /* Cancel a deferred rmap update. */
 STATIC void
 xfs_rmap_update_cancel_item(
+	struct xfs_mount		*mp,
 	struct list_head		*item)
 {
 	struct xfs_rmap_intent		*rmap;
 
 	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
+	xfs_fs_drop_intents(mp, rmap->ri_bmap.br_startblock);
 	kmem_cache_free(xfs_rmap_intent_cache, rmap);
 }
 
+/* Add a deferred rmap update. */
+STATIC void
+xfs_rmap_update_add_item(
+	struct xfs_mount		*mp,
+	const struct list_head		*item)
+{
+	const struct xfs_rmap_intent	*ri;
+
+	ri = container_of(item, struct xfs_rmap_intent, ri_list);
+	xfs_fs_bump_intents(mp, ri->ri_bmap.br_startblock);
+}
+
 const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
 	.create_intent	= xfs_rmap_update_create_intent,
@@ -470,6 +487,7 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.finish_item	= xfs_rmap_update_finish_item,
 	.finish_cleanup = xfs_rmap_finish_one_cleanup,
 	.cancel_item	= xfs_rmap_update_cancel_item,
+	.add_item	= xfs_rmap_update_add_item,
 };
 
 /* Is this recovered RUI ok? */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f9057af6e0c8..fae3b0fe0971 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2675,6 +2675,44 @@ DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_deferred);
 DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_agfl_free_defer);
 DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_agfl_free_deferred);
 
+DECLARE_EVENT_CLASS(xfs_defer_pending_item_class,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_pending *dfp,
+		 void *item),
+	TP_ARGS(mp, dfp, item),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, type)
+		__field(void *, intent)
+		__field(void *, item)
+		__field(char, committed)
+		__field(int, nr)
+	),
+	TP_fast_assign(
+		__entry->dev = mp ? mp->m_super->s_dev : 0;
+		__entry->type = dfp->dfp_type;
+		__entry->intent = dfp->dfp_intent;
+		__entry->item = item;
+		__entry->committed = dfp->dfp_done != NULL;
+		__entry->nr = dfp->dfp_count;
+	),
+	TP_printk("dev %d:%d optype %d intent %p item %p committed %d nr %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->type,
+		  __entry->intent,
+		  __entry->item,
+		  __entry->committed,
+		  __entry->nr)
+)
+#define DEFINE_DEFER_PENDING_ITEM_EVENT(name) \
+DEFINE_EVENT(xfs_defer_pending_item_class, name, \
+	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_pending *dfp, \
+		 void *item), \
+	TP_ARGS(mp, dfp, item))
+
+DEFINE_DEFER_PENDING_ITEM_EVENT(xfs_defer_add_item);
+DEFINE_DEFER_PENDING_ITEM_EVENT(xfs_defer_cancel_item);
+DEFINE_DEFER_PENDING_ITEM_EVENT(xfs_defer_finish_item);
+
 /* rmap tracepoints */
 DECLARE_EVENT_CLASS(xfs_rmap_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -4208,6 +4246,39 @@ TRACE_EVENT(xfs_force_shutdown,
 		__entry->line_num)
 );
 
+#ifdef CONFIG_XFS_DRAIN_INTENTS
+DECLARE_EVENT_CLASS(xfs_perag_intents_class,
+	TP_PROTO(struct xfs_perag *pag, void *caller_ip),
+	TP_ARGS(pag, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(long, nr_intents)
+		__field(void *, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->nr_intents = atomic_read(&pag->pag_intents.dr_count);
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d agno 0x%x intents %ld caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->nr_intents,
+		  __entry->caller_ip)
+);
+
+#define DEFINE_PERAG_INTENTS_EVENT(name)	\
+DEFINE_EVENT(xfs_perag_intents_class, name,					\
+	TP_PROTO(struct xfs_perag *pag, void *caller_ip), \
+	TP_ARGS(pag, caller_ip))
+DEFINE_PERAG_INTENTS_EVENT(xfs_perag_bump_intents);
+DEFINE_PERAG_INTENTS_EVENT(xfs_perag_drop_intents);
+DEFINE_PERAG_INTENTS_EVENT(xfs_perag_wait_intents);
+
+#endif /* CONFIG_XFS_DRAIN_INTENTS */
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH


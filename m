Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBC2C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiL3WhJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3WhH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:37:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D5617E33
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:37:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6550F61C18
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AF3C433EF;
        Fri, 30 Dec 2022 22:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439824;
        bh=CbSYDT2FJtKUTDSmFWbYta8NTCov5Kp5jy4oazSWbVo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Gc7ufnSHetJwpNuLux/RP5g2DD88F5qI/XU3y5R3rMSEmbRCCvoHD3xLGqnotBDV1
         pcXMJMKCXfaDUeO+JWjAhNq12gmEU6UoF1DVfLFgRvhJSh6ZsLsfI+HhiE/MABDyZ2
         nvYy1cbdHOMlmTRJV44ftBB2fGrytqd7eoaa23FOg1038iKbOM/l8BDSiuWtaYhLnW
         R7Eib3J6DwcZBOW/keDTOGl462P994+P7QPOLNxP+7gOGaRcXGVo+XqEixf+P8uS2s
         l4kGjvEtV+77+GnjbwEHTqwU49eKRl/0V3lCz/q2JqKgwsD/ipZgnbXZSM9tEfhRDI
         J+2mdarApA6kw==
Subject: [PATCH 2/5] xfs: allow queued AG intents to drain before scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:07 -0800
Message-ID: <167243826779.683691.9626839033927154131.stgit@magnolia>
In-Reply-To: <167243826744.683691.2061427880010614570.stgit@magnolia>
References: <167243826744.683691.2061427880010614570.stgit@magnolia>
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
intent counter reaches zero.

One quirk of the drain code is that deferred bmap updates also bump and
drop the intent counter.  A fundamental decision made during the design
phase of the reverse mapping feature is that updates to the rmapbt
records are always made by the same code that updates the primary
metadata.  In other words, callers of bmapi functions expect that the
bmapi functions will queue deferred rmap updates.

Some parts of the reflink code queue deferred refcount (CUI) and bmap
(BUI) updates in the same head transaction, but the deferred work
manager completely finishes the CUI before the BUI work is started.  As
a result, the CUI drops the intent count long before the deferred rmap
(RUI) update even has a chance to bump the intent count.  The only way
to keep the intent count elevated between the CUI and RUI is for the BUI
to bump the counter until the RUI has been created.

A second quirk of the intent drain code is that deferred work items must
increment the intent counter as soon as the work item is added to the
transaction.  When a BUI completes and queues an RUI, the RUI must
increment the counter before the BUI decrements it.  The only way to
accomplish this is to require that the counter be bumped as soon as the
deferred work item is created in memory.

In the next patches we'll improve on this facility, but this patch
provides the basic functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig             |    4 ++
 fs/xfs/Makefile            |    2 +
 fs/xfs/libxfs/xfs_ag.c     |    4 ++
 fs/xfs/libxfs/xfs_ag.h     |    8 +++
 fs/xfs/libxfs/xfs_defer.c  |    6 ++-
 fs/xfs/scrub/common.c      |  103 +++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/scrub/health.c      |    2 +
 fs/xfs/scrub/refcount.c    |    2 +
 fs/xfs/xfs_bmap_item.c     |   10 ++++
 fs/xfs/xfs_drain.c         |   96 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_drain.h         |   77 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_extfree_item.c  |    2 +
 fs/xfs/xfs_linux.h         |    1 
 fs/xfs/xfs_refcount_item.c |    2 +
 fs/xfs/xfs_rmap_item.c     |    2 +
 fs/xfs/xfs_trace.h         |   71 ++++++++++++++++++++++++++++++
 16 files changed, 379 insertions(+), 13 deletions(-)
 create mode 100644 fs/xfs/xfs_drain.c
 create mode 100644 fs/xfs/xfs_drain.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 9fac5ea8d0e4..ab24e683b440 100644
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
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 03135a1c31b6..ea0725cfb6fb 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -135,6 +135,8 @@ ifeq ($(CONFIG_MEMORY_FAILURE),y)
 xfs-$(CONFIG_FS_DAX)		+= xfs_notify_failure.o
 endif
 
+xfs-$(CONFIG_XFS_DRAIN_INTENTS)	+= xfs_drain.o
+
 # online scrub/repair
 ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
 
diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index fed965831f2d..8b1bb228cba6 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -207,6 +207,7 @@ xfs_free_perag(
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
 		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
+		xfs_drain_free(&pag->pag_intents);
 
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 		xfs_buf_hash_destroy(pag);
@@ -328,6 +329,7 @@ xfs_initialize_perag(
 		spin_lock_init(&pag->pag_state_lock);
 		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+		xfs_drain_init(&pag->pag_intents);
 		init_waitqueue_head(&pag->pagb_wait);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
@@ -360,6 +362,7 @@ xfs_initialize_perag(
 	return 0;
 
 out_remove_pag:
+	xfs_drain_free(&pag->pag_intents);
 	radix_tree_delete(&mp->m_perag_tree, index);
 out_free_pag:
 	kmem_free(pag);
@@ -370,6 +373,7 @@ xfs_initialize_perag(
 		if (!pag)
 			break;
 		xfs_buf_hash_destroy(pag);
+		xfs_drain_free(&pag->pag_intents);
 		kmem_free(pag);
 	}
 	return error;
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index d61b07e60802..5b4b8658685f 100644
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
index 5a321b783398..bcfb6a4203cd 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -397,6 +397,7 @@ xfs_defer_cancel_list(
 		list_for_each_safe(pwi, n, &dfp->dfp_work) {
 			list_del(pwi);
 			dfp->dfp_count--;
+			trace_xfs_defer_cancel_item(mp, dfp, pwi);
 			ops->cancel_item(pwi);
 		}
 		ASSERT(dfp->dfp_count == 0);
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
@@ -653,6 +654,7 @@ xfs_defer_add(
 	}
 
 	list_add_tail(li, &dfp->dfp_work);
+	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
 	dfp->dfp_count++;
 }
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 613260b04a3d..453d8c3f2370 100644
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
+		if (!xfs_perag_intents_busy(sa->pag))
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
+		error = xfs_perag_drain_intents(sa->pag);
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
index ffa6eda8b7d4..080487f99e5f 100644
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
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 32ccd4bb9f46..e13184afebaf 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -374,6 +374,15 @@ xfs_bmap_update_get_group(
 
 	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
 	bi->bi_pag = xfs_perag_get(mp, agno);
+
+	/*
+	 * Bump the intent count on behalf of the deferred rmap intent item
+	 * that we will queue when we finish this bmap work.  This rmap item
+	 * will bump the intent count before the bmap intent drops the intent
+	 * count, ensuring that the intent count remains nonzero across the
+	 * transaction roll.
+	 */
+	xfs_perag_bump_intents(bi->bi_pag);
 }
 
 /* Release an active AG ref after finishing mapping work. */
@@ -381,6 +390,7 @@ static inline void
 xfs_bmap_update_put_group(
 	struct xfs_bmap_intent	*bi)
 {
+	xfs_perag_drop_intents(bi->bi_pag);
 	xfs_perag_put(bi->bi_pag);
 }
 
diff --git a/fs/xfs/xfs_drain.c b/fs/xfs/xfs_drain.c
new file mode 100644
index 000000000000..e8fced914f88
--- /dev/null
+++ b/fs/xfs/xfs_drain.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_ag.h"
+#include "xfs_trace.h"
+
+void
+xfs_drain_init(
+	struct xfs_drain	*dr)
+{
+	atomic_set(&dr->dr_count, 0);
+	init_waitqueue_head(&dr->dr_waiters);
+}
+
+void
+xfs_drain_free(struct xfs_drain	*dr)
+{
+	ASSERT(atomic_read(&dr->dr_count) == 0);
+}
+
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
+/* Are there work items pending? */
+static inline bool xfs_drain_busy(struct xfs_drain *dr)
+{
+	return atomic_read(&dr->dr_count) > 0;
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
+xfs_perag_bump_intents(
+	struct xfs_perag	*pag)
+{
+	trace_xfs_perag_bump_intents(pag, __return_address);
+	xfs_drain_bump(&pag->pag_intents);
+}
+
+/* Remove an item from the pending count. */
+void
+xfs_perag_drop_intents(
+	struct xfs_perag	*pag)
+{
+	trace_xfs_perag_drop_intents(pag, __return_address);
+	xfs_drain_drop(&pag->pag_intents);
+}
+
+/*
+ * Wait for the pending intent count for AG metadata to hit zero.
+ * Callers must not hold any AG header buffers.
+ */
+int
+xfs_perag_drain_intents(
+	struct xfs_perag	*pag)
+{
+	trace_xfs_perag_wait_intents(pag, __return_address);
+	return xfs_drain_wait(&pag->pag_intents);
+}
+
+/* Might someone else be processing intents for this AG? */
+bool
+xfs_perag_intents_busy(
+	struct xfs_perag	*pag)
+{
+	return xfs_drain_busy(&pag->pag_intents);
+}
diff --git a/fs/xfs/xfs_drain.h b/fs/xfs/xfs_drain.h
new file mode 100644
index 000000000000..f01a2b5c7337
--- /dev/null
+++ b/fs/xfs/xfs_drain.h
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef XFS_DRAIN_H_
+#define XFS_DRAIN_H_
+
+struct xfs_perag;
+
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
+void xfs_drain_init(struct xfs_drain *dr);
+void xfs_drain_free(struct xfs_drain *dr);
+
+/*
+ * Deferred Work Intent Drains
+ * ===========================
+ *
+ * When a writer thread executes a chain of log intent items, the AG header
+ * buffer locks will cycle during a transaction roll to get from one intent
+ * item to the next in a chain.  Although scrub takes all AG header buffer
+ * locks, this isn't sufficient to guard against scrub checking an AG while
+ * that writer thread is in the middle of finishing a chain because there's no
+ * higher level locking primitive guarding allocation groups.
+ *
+ * When there's a collision, cross-referencing between data structures (e.g.
+ * rmapbt and refcountbt) yields false corruption events; if repair is running,
+ * this results in incorrect repairs, which is catastrophic.
+ *
+ * The solution is to the perag structure the count of active intents and make
+ * scrub wait until it has both AG header buffer locks and the intent counter
+ * reaches zero.  It is therefore critical that deferred work threads hold the
+ * AGI or AGF buffers when decrementing the intent counter.
+ *
+ * Given a list of deferred work items, the deferred work manager will complete
+ * a work item and all the sub-items that the parent item creates before moving
+ * on to the next work item in the list.  This is also true for all levels of
+ * sub-items.  Writer threads are permitted to queue multiple work items
+ * targetting the same AG, so a deferred work item (such as a BUI) that creates
+ * sub-items (such as RUIs) must bump the intent counter and maintain it until
+ * the sub-items can themselves bump the intent counter.
+ *
+ * Therefore, the intent count tracks entire lifetimes of deferred work items.
+ * All functions that create work items must increment the intent counter as
+ * soon as the item is added to the transaction and cannot drop the counter
+ * until the item is finished or cancelled.
+ */
+void xfs_perag_bump_intents(struct xfs_perag *pag);
+void xfs_perag_drop_intents(struct xfs_perag *pag);
+
+int xfs_perag_drain_intents(struct xfs_perag *pag);
+bool xfs_perag_intents_busy(struct xfs_perag *pag);
+#else
+struct xfs_drain { /* empty */ };
+
+#define xfs_drain_free(dr)		((void)0)
+#define xfs_drain_init(dr)		((void)0)
+
+static inline void xfs_perag_bump_intents(struct xfs_perag *pag) { }
+static inline void xfs_perag_drop_intents(struct xfs_perag *pag) { }
+
+#endif /* CONFIG_XFS_DRAIN_INTENTS */
+
+#endif /* XFS_DRAIN_H_ */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 8db9d9abb54a..cec637de322e 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -470,6 +470,7 @@ xfs_extent_free_get_group(
 
 	agno = XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
 	xefi->xefi_pag = xfs_perag_get(mp, agno);
+	xfs_perag_bump_intents(xefi->xefi_pag);
 }
 
 /* Release an active AG ref after some freeing work. */
@@ -477,6 +478,7 @@ static inline void
 xfs_extent_free_put_group(
 	struct xfs_extent_free_item	*xefi)
 {
+	xfs_perag_drop_intents(xefi->xefi_pag);
 	xfs_perag_put(xefi->xefi_pag);
 }
 
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index f9878021e7d0..51e84f824a7c 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -79,6 +79,7 @@ typedef __u32			xfs_nlink_t;
 #include "xfs_cksum.h"
 #include "xfs_buf.h"
 #include "xfs_message.h"
+#include "xfs_drain.h"
 
 #ifdef __BIG_ENDIAN
 #define XFS_NATIVE_HOST 1
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 4c4706a15056..5c6eecc5318a 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -375,6 +375,7 @@ xfs_refcount_update_get_group(
 
 	agno = XFS_FSB_TO_AGNO(mp, ri->ri_startblock);
 	ri->ri_pag = xfs_perag_get(mp, agno);
+	xfs_perag_bump_intents(ri->ri_pag);
 }
 
 /* Release an active AG ref after finishing refcounting work. */
@@ -382,6 +383,7 @@ static inline void
 xfs_refcount_update_put_group(
 	struct xfs_refcount_intent	*ri)
 {
+	xfs_perag_drop_intents(ri->ri_pag);
 	xfs_perag_put(ri->ri_pag);
 }
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 10b971d24b5f..38915e92bf2b 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -400,6 +400,7 @@ xfs_rmap_update_get_group(
 
 	agno = XFS_FSB_TO_AGNO(mp, ri->ri_bmap.br_startblock);
 	ri->ri_pag = xfs_perag_get(mp, agno);
+	xfs_perag_bump_intents(ri->ri_pag);
 }
 
 /* Release an active AG ref after finishing rmapping work. */
@@ -407,6 +408,7 @@ static inline void
 xfs_rmap_update_put_group(
 	struct xfs_rmap_intent	*ri)
 {
+	xfs_perag_drop_intents(ri->ri_pag);
 	xfs_perag_put(ri->ri_pag);
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0448b992a561..6941deb80244 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2679,6 +2679,44 @@ DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_deferred);
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
@@ -4318,6 +4356,39 @@ TRACE_EVENT(xfs_force_shutdown,
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


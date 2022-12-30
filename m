Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5B6C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236040AbiLaBnm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiLaBnj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:43:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6AD13DEA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:43:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FC8B61CBE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E527C433D2;
        Sat, 31 Dec 2022 01:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451017;
        bh=vg+H1cB3jEm+cDRDsCE7xkHQQrfyawhMFAcKRjb4Rc0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GJ59vbvoTgxhR/M4ZuA6fUxaw7j+ZBXI+AnLW6tqv7eHLN2sqeJqMGg2D/4tW1XLI
         4ed3DaMqUcFmKyntOjNRdRv4BKUAMVTzNC5WzIkdkD3PjLlDpvDKcADb5/ydAwF0ws
         N2eVHFIucy8rvOY1unsvF/KwskV3yyy3VazrauiRqqjfHTIyXPPuY3ZziiLFAmbNV+
         aJe45j/kNUmjbPUrwsEu3anQcvfsZ0RbqzdX5qGx7fRIdC1MX2GAcs42dtdV7ZRMsa
         YR59mpZrapdfKUSXMe0FQFSURTIpkDbkXoPxLYwOTqkhIsBfZ+JuFNHaguYD+g4wmw
         eFEy+yUWb8X1g==
Subject: [PATCH 26/38] xfs: allow queued realtime intents to drain before
 scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:19 -0800
Message-ID: <167243869971.715303.13003561824394979973.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When a writer thread executes a chain of log intent items for the
realtime volume, the ILOCKs taken during each step are for each rt
metadata file, not the entire rt volume itself.  Although scrub takes
all rt metadata ILOCKs, this isn't sufficient to guard against scrub
checking the rt volume while that writer thread is in the middle of
finishing a chain because there's no higher level locking primitive
guarding the realtime volume.

When there's a collision, cross-referencing between data structures
(e.g. rtrmapbt and rtrefcountbt) yields false corruption events; if
repair is running, this results in incorrect repairs, which is
catastrophic.

Fix this by adding to the mount structure the same drain that we use to
protect scrub against concurrent AG updates, but this time for the
realtime volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtgroup.c |    3 ++
 fs/xfs/libxfs/xfs_rtgroup.h |    9 +++++
 fs/xfs/scrub/common.c       |   76 ++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/rtbitmap.c     |    3 ++
 fs/xfs/xfs_bmap_item.c      |    5 ++-
 fs/xfs/xfs_drain.c          |   41 +++++++++++++++++++++++
 fs/xfs/xfs_drain.h          |   19 +++++++++++
 fs/xfs/xfs_extfree_item.c   |    2 +
 fs/xfs/xfs_mount.h          |    1 +
 fs/xfs/xfs_rmap_item.c      |    2 +
 fs/xfs/xfs_trace.h          |   32 ++++++++++++++++++
 11 files changed, 186 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index d6b790741265..e40806c84256 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -132,6 +132,8 @@ xfs_initialize_rtgroups(
 #ifdef __KERNEL__
 		/* Place kernel structure only init below this point. */
 		spin_lock_init(&rtg->rtg_state_lock);
+		xfs_drain_init(&rtg->rtg_intents);
+
 #endif /* __KERNEL__ */
 
 		/* first new rtg is fully initialized */
@@ -183,6 +185,7 @@ xfs_free_rtgroups(
 		spin_unlock(&mp->m_rtgroup_lock);
 		ASSERT(rtg);
 		XFS_IS_CORRUPT(rtg->rtg_mount, atomic_read(&rtg->rtg_ref) != 0);
+		xfs_drain_free(&rtg->rtg_intents);
 
 		call_rcu(&rtg->rcu_head, __xfs_free_rtgroups);
 	}
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 3230dd03d8f8..1d41a2cac34f 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -37,6 +37,15 @@ struct xfs_rtgroup {
 #ifdef __KERNEL__
 	/* -- kernel only structures below this line -- */
 	spinlock_t		rtg_state_lock;
+
+	/*
+	 * We use xfs_drain to track the number of deferred log intent items
+	 * that have been queued (but not yet processed) so that waiters (e.g.
+	 * scrub) will not lock resources when other threads are in the middle
+	 * of processing a chain of intent items only to find momentary
+	 * inconsistencies.
+	 */
+	struct xfs_drain	rtg_intents;
 #endif /* __KERNEL__ */
 };
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index b63b5c016841..bb1d9ca20374 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -757,12 +757,78 @@ xchk_rt_unlock(
 }
 
 #ifdef CONFIG_XFS_RT
+/* Lock all the rt group metadata inode ILOCKs and wait for intents. */
+static int
+xchk_rtgroup_lock(
+	struct xfs_scrub	*sc,
+	struct xchk_rt		*sr,
+	unsigned int		rtglock_flags)
+{
+	int			error = 0;
+
+	ASSERT(sr->rtg != NULL);
+
+	/*
+	 * If we're /only/ locking the rtbitmap in shared mode, then we're
+	 * obviously not trying to compare records in two metadata inodes.
+	 * There's no need to drain intents here because the caller (most
+	 * likely the rgsuper scanner) doesn't need that level of consistency.
+	 */
+	if (rtglock_flags == XFS_RTGLOCK_BITMAP_SHARED) {
+		xfs_rtgroup_lock(NULL, sr->rtg, rtglock_flags);
+		sr->rtlock_flags = rtglock_flags;
+		return 0;
+	}
+
+	do {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		xfs_rtgroup_lock(NULL, sr->rtg, rtglock_flags);
+
+		/*
+		 * Decide if the rt group is quiet enough for all metadata to
+		 * be consistent with each other.  Regular file IO doesn't get
+		 * to lock all the rt inodes at the same time, which means that
+		 * there could be other threads in the middle of processing a
+		 * chain of deferred ops.
+		 *
+		 * We just locked all the metadata inodes for this rt group;
+		 * now take a look to see if there are any intents in progress.
+		 * If there are, drop the rt group inode locks and wait for the
+		 * intents to drain.  Since we hold the rt group inode locks
+		 * for the duration of the scrub, this is the only time we have
+		 * to sample the intents counter; any threads increasing it
+		 * after this point can't possibly be in the middle of a chain
+		 * of rt metadata updates.
+		 *
+		 * Obviously, this should be slanted against scrub and in favor
+		 * of runtime threads.
+		 */
+		if (!xfs_rtgroup_intents_busy(sr->rtg)) {
+			sr->rtlock_flags = rtglock_flags;
+			return 0;
+		}
+
+		xfs_rtgroup_unlock(sr->rtg, rtglock_flags);
+
+		if (!(sc->flags & XCHK_FSHOOKS_DRAIN))
+			return -ECHRNG;
+		error = xfs_rtgroup_drain_intents(sr->rtg);
+		if (error == -ERESTARTSYS)
+			error = -EINTR;
+	} while (!error);
+
+	return error;
+}
+
 /*
  * For scrubbing a realtime group, grab all the in-core resources we'll need to
  * check the metadata, which means taking the ILOCK of the realtime group's
- * metadata inodes.  Callers must not join these inodes to the transaction with
- * non-zero lockflags or concurrency problems will result.  The @rtglock_flags
- * argument takes XFS_RTGLOCK_* flags.
+ * metadata inodes and draining any running intent chains.  Callers must not
+ * join these inodes to the transaction with non-zero lockflags or concurrency
+ * problems will result.  The @rtglock_flags argument takes XFS_RTGLOCK_*
+ * flags.
  */
 int
 xchk_rtgroup_init(
@@ -778,9 +844,7 @@ xchk_rtgroup_init(
 	if (!sr->rtg)
 		return -ENOENT;
 
-	xfs_rtgroup_lock(NULL, sr->rtg, rtglock_flags);
-	sr->rtlock_flags = rtglock_flags;
-	return 0;
+	return xchk_rtgroup_lock(sc, sr, rtglock_flags);
 }
 
 /*
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index d847773e5f66..a034f2d392f5 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -26,6 +26,9 @@ xchk_setup_rgbitmap(
 {
 	int			error;
 
+	if (xchk_need_fshook_drain(sc))
+		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
+
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 04eeae9aef79..e2e7e5f678e9 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -369,6 +369,7 @@ xfs_bmap_update_get_group(
 
 			rgno = xfs_rtb_to_rgno(mp, bi->bi_bmap.br_startblock);
 			bi->bi_rtg = xfs_rtgroup_get(mp, rgno);
+			xfs_rtgroup_bump_intents(bi->bi_rtg);
 		} else {
 			bi->bi_rtg = NULL;
 		}
@@ -395,8 +396,10 @@ xfs_bmap_update_put_group(
 	struct xfs_bmap_intent	*bi)
 {
 	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork)) {
-		if (xfs_has_rtgroups(bi->bi_owner->i_mount))
+		if (xfs_has_rtgroups(bi->bi_owner->i_mount)) {
+			xfs_rtgroup_drop_intents(bi->bi_rtg);
 			xfs_rtgroup_put(bi->bi_rtg);
+		}
 		return;
 	}
 
diff --git a/fs/xfs/xfs_drain.c b/fs/xfs/xfs_drain.c
index 9b463e1183f6..4fda4cd096fa 100644
--- a/fs/xfs/xfs_drain.c
+++ b/fs/xfs/xfs_drain.c
@@ -11,6 +11,7 @@
 #include "xfs_mount.h"
 #include "xfs_ag.h"
 #include "xfs_trace.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Use a static key here to reduce the overhead of xfs_drain_drop.  If the
@@ -119,3 +120,43 @@ xfs_perag_intents_busy(
 {
 	return xfs_drain_busy(&pag->pag_intents);
 }
+
+#ifdef CONFIG_XFS_RT
+/* Add an item to the pending count. */
+void
+xfs_rtgroup_bump_intents(
+	struct xfs_rtgroup	*rtg)
+{
+	trace_xfs_rtgroup_bump_intents(rtg, __return_address);
+	xfs_drain_bump(&rtg->rtg_intents);
+}
+
+/* Remove an item from the pending count. */
+void
+xfs_rtgroup_drop_intents(
+	struct xfs_rtgroup	*rtg)
+{
+	trace_xfs_rtgroup_drop_intents(rtg, __return_address);
+	xfs_drain_drop(&rtg->rtg_intents);
+}
+
+/*
+ * Wait for the pending intent count for realtime metadata to hit zero.
+ * Callers must not hold any rt metadata inode locks.
+ */
+int
+xfs_rtgroup_drain_intents(
+	struct xfs_rtgroup	*rtg)
+{
+	trace_xfs_rtgroup_wait_intents(rtg, __return_address);
+	return xfs_drain_wait(&rtg->rtg_intents);
+}
+
+/* Might someone else be processing intents for this rt group? */
+bool
+xfs_rtgroup_intents_busy(
+	struct xfs_rtgroup	*rtg)
+{
+	return xfs_drain_busy(&rtg->rtg_intents);
+}
+#endif /* CONFIG_XFS_RT */
diff --git a/fs/xfs/xfs_drain.h b/fs/xfs/xfs_drain.h
index a980df6d3508..478ffab95b0f 100644
--- a/fs/xfs/xfs_drain.h
+++ b/fs/xfs/xfs_drain.h
@@ -7,6 +7,7 @@
 #define XFS_DRAIN_H_
 
 struct xfs_perag;
+struct xfs_rtgroup;
 
 #ifdef CONFIG_XFS_DRAIN_INTENTS
 /*
@@ -60,12 +61,27 @@ void xfs_drain_wait_enable(void);
  * All functions that create work items must increment the intent counter as
  * soon as the item is added to the transaction and cannot drop the counter
  * until the item is finished or cancelled.
+ *
+ * The same principles apply to realtime groups because the rt metadata inode
+ * ILOCKs are not held across transaction rolls.
  */
 void xfs_perag_bump_intents(struct xfs_perag *pag);
 void xfs_perag_drop_intents(struct xfs_perag *pag);
 
 int xfs_perag_drain_intents(struct xfs_perag *pag);
 bool xfs_perag_intents_busy(struct xfs_perag *pag);
+
+#ifdef CONFIG_XFS_RT
+void xfs_rtgroup_bump_intents(struct xfs_rtgroup *rtg);
+void xfs_rtgroup_drop_intents(struct xfs_rtgroup *rtg);
+
+int xfs_rtgroup_drain_intents(struct xfs_rtgroup *rtg);
+bool xfs_rtgroup_intents_busy(struct xfs_rtgroup *rtg);
+#else
+static inline void xfs_rtgroup_bump_intents(struct xfs_rtgroup *rtg) { }
+static inline void xfs_rtgroup_drop_intents(struct xfs_rtgroup *rtg) { }
+#endif /* CONFIG_XFS_RT */
+
 #else
 struct xfs_drain { /* empty */ };
 
@@ -75,6 +91,9 @@ struct xfs_drain { /* empty */ };
 static inline void xfs_perag_bump_intents(struct xfs_perag *pag) { }
 static inline void xfs_perag_drop_intents(struct xfs_perag *pag) { }
 
+static inline void xfs_rtgroup_bump_intents(struct xfs_rtgroup *rtg) { }
+static inline void xfs_rtgroup_drop_intents(struct xfs_rtgroup *rtg) { }
+
 #endif /* CONFIG_XFS_DRAIN_INTENTS */
 
 #endif /* XFS_DRAIN_H_ */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 42b89c9e996b..e2e888bc1b1c 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -491,6 +491,7 @@ xfs_extent_free_get_group(
 
 		rgno = xfs_rtb_to_rgno(mp, xefi->xefi_startblock);
 		xefi->xefi_rtg = xfs_rtgroup_get(mp, rgno);
+		xfs_rtgroup_bump_intents(xefi->xefi_rtg);
 		return;
 	}
 
@@ -505,6 +506,7 @@ xfs_extent_free_put_group(
 	struct xfs_extent_free_item	*xefi)
 {
 	if (xfs_efi_is_realtime(xefi)) {
+		xfs_rtgroup_drop_intents(xefi->xefi_rtg);
 		xfs_rtgroup_put(xefi->xefi_rtg);
 		return;
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a565b1b1372a..b1ffab4cb9cd 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -13,6 +13,7 @@ struct xfs_ail;
 struct xfs_quotainfo;
 struct xfs_da_geometry;
 struct xfs_perag;
+struct xfs_rtgroup;
 
 /* dynamic preallocation free space thresholds, 5% down to 1% */
 enum {
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index a2949f818e0c..a95783622adb 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -400,6 +400,7 @@ xfs_rmap_update_get_group(
 
 		rgno = xfs_rtb_to_rgno(mp, ri->ri_bmap.br_startblock);
 		ri->ri_rtg = xfs_rtgroup_get(mp, rgno);
+		xfs_rtgroup_bump_intents(ri->ri_rtg);
 		return;
 	}
 
@@ -414,6 +415,7 @@ xfs_rmap_update_put_group(
 	struct xfs_rmap_intent	*ri)
 {
 	if (ri->ri_realtime) {
+		xfs_rtgroup_drop_intents(ri->ri_rtg);
 		xfs_rtgroup_put(ri->ri_rtg);
 		return;
 	}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d90e9183dfc7..a6de7b6e4afd 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4872,6 +4872,38 @@ DEFINE_PERAG_INTENTS_EVENT(xfs_perag_bump_intents);
 DEFINE_PERAG_INTENTS_EVENT(xfs_perag_drop_intents);
 DEFINE_PERAG_INTENTS_EVENT(xfs_perag_wait_intents);
 
+#ifdef CONFIG_XFS_RT
+DECLARE_EVENT_CLASS(xfs_rtgroup_intents_class,
+	TP_PROTO(struct xfs_rtgroup *rtg, void *caller_ip),
+	TP_ARGS(rtg, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, rtdev)
+		__field(long, nr_intents)
+		__field(void *, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg->rtg_mount->m_super->s_dev;
+		__entry->rtdev = rtg->rtg_mount->m_rtdev_targp->bt_dev;
+		__entry->nr_intents = atomic_read(&rtg->rtg_intents.dr_count);
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d rtdev %d:%d intents %ld caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->rtdev), MINOR(__entry->rtdev),
+		  __entry->nr_intents,
+		  __entry->caller_ip)
+);
+
+#define DEFINE_RTGROUP_INTENTS_EVENT(name)	\
+DEFINE_EVENT(xfs_rtgroup_intents_class, name,					\
+	TP_PROTO(struct xfs_rtgroup *rtg, void *caller_ip), \
+	TP_ARGS(rtg, caller_ip))
+DEFINE_RTGROUP_INTENTS_EVENT(xfs_rtgroup_bump_intents);
+DEFINE_RTGROUP_INTENTS_EVENT(xfs_rtgroup_drop_intents);
+DEFINE_RTGROUP_INTENTS_EVENT(xfs_rtgroup_wait_intents);
+#endif /* CONFIG_XFS_RT */
+
 #endif /* CONFIG_XFS_DRAIN_INTENTS */
 
 TRACE_EVENT(xfs_swapext_overhead,


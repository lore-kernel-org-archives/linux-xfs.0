Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4FDBA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZWJvPxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B82BC433C8;
	Sun, 31 Dec 2023 21:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058683;
	bh=N5qLY73T6eOO9JSWXK+3nZ6WgNIEXfmb7ftdZazJofc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RZWJvPxz4v+fNXM5Sg6ShVXtLkv4loBECcCwHqOFG40T360yWAwhSCZMDWdWSDjCx
	 sUuC2x3kuD5FbHnS1ZFe6f4bLLH1cWkwKmuJ6O5MXZiUaYGs8MZOWbDVMAoC/SIO2U
	 qVoWZhhz+OW5eoK8eH0OEtA2UyBhjazSpt2fd0E2GiX/tdNDYBsrV7hVNN1eYbheSi
	 5chEqt45iEA5zgONgFWIqE/7yAxSv11Jbx4/U51roW08tuc2IOUSOxcrl//8IWd4ne
	 GqqRYCSw069DIMkYgxQoAEt+iVR8vrrgbUAcnHEs1ERT7L9i8MDRqpBhEJzzUpKod3
	 fGqMGqQbhFAyQ==
Date: Sun, 31 Dec 2023 13:38:02 -0800
Subject: [PATCH 24/39] xfs: allow queued realtime intents to drain before
 scrubbing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404850285.1764998.16445367274469895177.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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

[Contains a few cleanups from hch]

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtgroup.c |    2 +
 fs/xfs/libxfs/xfs_rtgroup.h |    9 ++++
 fs/xfs/scrub/common.c       |   88 +++++++++++++++++++++++++++++++++++++----
 fs/xfs/scrub/rtbitmap.c     |    3 +
 fs/xfs/scrub/scrub.c        |    2 -
 fs/xfs/xfs_bmap_item.c      |   11 ++---
 fs/xfs/xfs_drain.c          |   93 +++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_drain.h          |   28 ++++++++++++-
 fs/xfs/xfs_extfree_item.c   |   14 ++----
 fs/xfs/xfs_mount.h          |    1 
 fs/xfs/xfs_rmap_item.c      |   16 +++----
 fs/xfs/xfs_trace.h          |   32 +++++++++++++++
 12 files changed, 255 insertions(+), 44 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 6ffe1c21a1ea4..7b031f4917349 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -162,6 +162,7 @@ xfs_initialize_rtgroups(
 		/* Place kernel structure only init below this point. */
 		spin_lock_init(&rtg->rtg_state_lock);
 		init_waitqueue_head(&rtg->rtg_active_wq);
+		xfs_defer_drain_init(&rtg->rtg_intents_drain);
 #endif /* __KERNEL__ */
 
 		/* Active ref owned by mount indicates rtgroup is online. */
@@ -216,6 +217,7 @@ xfs_free_rtgroups(
 		spin_unlock(&mp->m_rtgroup_lock);
 		ASSERT(rtg);
 		XFS_IS_CORRUPT(mp, atomic_read(&rtg->rtg_ref) != 0);
+		xfs_defer_drain_free(&rtg->rtg_intents_drain);
 
 		/* drop the mount's active reference */
 		xfs_rtgroup_rele(rtg);
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 559a5135820d3..9487c2e00478b 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -39,6 +39,15 @@ struct xfs_rtgroup {
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
+	struct xfs_defer_drain	rtg_intents_drain;
 #endif /* __KERNEL__ */
 };
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 3dee7d717073e..efce0dff2e937 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -776,12 +776,88 @@ xchk_rt_unlock_rtbitmap(
 }
 
 #ifdef CONFIG_XFS_RT
+/* Lock all the rt group metadata inode ILOCKs and wait for intents. */
+static int
+xchk_rtgroup_drain_and_lock(
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
+		 * If we've grabbed a non-metadata file for scrubbing, we
+		 * assume that holding its ILOCK will suffice to coordinate
+		 * with any rt intent chains involving this inode.
+		 */
+		if (sc->ip && !xfs_is_metadata_inode(sc->ip)) {
+			sr->rtlock_flags = rtglock_flags;
+			return 0;
+		}
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
+		if (!xfs_rtgroup_intent_busy(sr->rtg)) {
+			sr->rtlock_flags = rtglock_flags;
+			return 0;
+		}
+
+		xfs_rtgroup_unlock(sr->rtg, rtglock_flags);
+
+		if (!(sc->flags & XCHK_FSGATES_DRAIN))
+			return -ECHRNG;
+		error = xfs_rtgroup_intent_drain(sr->rtg);
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
@@ -797,9 +873,7 @@ xchk_rtgroup_init(
 	if (!sr->rtg)
 		return -ENOENT;
 
-	xfs_rtgroup_lock(NULL, sr->rtg, rtglock_flags);
-	sr->rtlock_flags = rtglock_flags;
-	return 0;
+	return xchk_rtgroup_drain_and_lock(sc, sr, rtglock_flags);
 }
 
 /*
@@ -1457,7 +1531,7 @@ xchk_fsgates_enable(
 	trace_xchk_fsgates_enable(sc, scrub_fsgates);
 
 	if (scrub_fsgates & XCHK_FSGATES_DRAIN)
-		xfs_drain_wait_enable();
+		xfs_defer_drain_wait_enable();
 
 	if (scrub_fsgates & XCHK_FSGATES_QUOTA)
 		xfs_dqtrx_hook_enable();
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index aae8b0e6ff281..5bedb09387495 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -84,6 +84,9 @@ xchk_setup_rtbitmap(
 	struct xchk_rtbitmap	*rtb;
 	int			error;
 
+	if (xchk_need_intent_drain(sc))
+		xchk_fsgates_enable(sc, XCHK_FSGATES_DRAIN);
+
 	rtb = kzalloc(sizeof(struct xchk_rtbitmap), XCHK_GFP_FLAGS);
 	if (!rtb)
 		return -ENOMEM;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index a6b7b57fc1df7..58bb52a63782e 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -165,7 +165,7 @@ xchk_fsgates_disable(
 	trace_xchk_fsgates_disable(sc, sc->flags & FSGATES_MASK);
 
 	if (sc->flags & XCHK_FSGATES_DRAIN)
-		xfs_drain_wait_disable();
+		xfs_defer_drain_wait_disable();
 
 	if (sc->flags & XCHK_FSGATES_QUOTA)
 		xfs_dqtrx_hook_disable();
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e50276ceceae9..4522de5f13a8d 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -327,10 +327,8 @@ xfs_bmap_update_get_group(
 {
 	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork)) {
 		if (xfs_has_rtgroups(mp)) {
-			xfs_rgnumber_t	rgno;
-
-			rgno = xfs_rtb_to_rgno(mp, bi->bi_bmap.br_startblock);
-			bi->bi_rtg = xfs_rtgroup_get(mp, rgno);
+			bi->bi_rtg = xfs_rtgroup_intent_get(mp,
+						bi->bi_bmap.br_startblock);
 		} else {
 			bi->bi_rtg = NULL;
 		}
@@ -366,8 +364,9 @@ xfs_bmap_update_put_group(
 	struct xfs_bmap_intent	*bi)
 {
 	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork)) {
-		if (xfs_has_rtgroups(bi->bi_owner->i_mount))
-			xfs_rtgroup_put(bi->bi_rtg);
+		if (xfs_has_rtgroups(bi->bi_owner->i_mount)) {
+			xfs_rtgroup_intent_put(bi->bi_rtg);
+		}
 		return;
 	}
 
diff --git a/fs/xfs/xfs_drain.c b/fs/xfs/xfs_drain.c
index 7bdb9688c0f5e..306cd133b9a27 100644
--- a/fs/xfs/xfs_drain.c
+++ b/fs/xfs/xfs_drain.c
@@ -11,11 +11,12 @@
 #include "xfs_mount.h"
 #include "xfs_ag.h"
 #include "xfs_trace.h"
+#include "xfs_rtgroup.h"
 
 /*
- * Use a static key here to reduce the overhead of xfs_drain_rele.  If the
+ * Use a static key here to reduce the overhead of xfs_defer_drain_rele.  If the
  * compiler supports jump labels, the static branch will be replaced by a nop
- * sled when there are no xfs_drain_wait callers.  Online fsck is currently
+ * sled when there are no xfs_defer_drain_wait callers.  Online fsck is currently
  * the only caller, so this is a reasonable tradeoff.
  *
  * Note: Patching the kernel code requires taking the cpu hotplug lock.  Other
@@ -23,18 +24,18 @@
  * XFS callers cannot hold any locks that might be used by memory reclaim or
  * writeback when calling the static_branch_{inc,dec} functions.
  */
-static DEFINE_STATIC_KEY_FALSE(xfs_drain_waiter_gate);
+static DEFINE_STATIC_KEY_FALSE(xfs_defer_drain_waiter_gate);
 
 void
-xfs_drain_wait_disable(void)
+xfs_defer_drain_wait_disable(void)
 {
-	static_branch_dec(&xfs_drain_waiter_gate);
+	static_branch_dec(&xfs_defer_drain_waiter_gate);
 }
 
 void
-xfs_drain_wait_enable(void)
+xfs_defer_drain_wait_enable(void)
 {
-	static_branch_inc(&xfs_drain_waiter_gate);
+	static_branch_inc(&xfs_defer_drain_waiter_gate);
 }
 
 void
@@ -71,7 +72,7 @@ static inline bool has_waiters(struct wait_queue_head *wq_head)
 static inline void xfs_defer_drain_rele(struct xfs_defer_drain *dr)
 {
 	if (atomic_dec_and_test(&dr->dr_count) &&
-	    static_branch_unlikely(&xfs_drain_waiter_gate) &&
+	    static_branch_unlikely(&xfs_defer_drain_waiter_gate) &&
 	    has_waiters(&dr->dr_waiters))
 		wake_up(&dr->dr_waiters);
 }
@@ -164,3 +165,79 @@ xfs_perag_intent_busy(
 {
 	return xfs_defer_drain_busy(&pag->pag_intents_drain);
 }
+
+#ifdef CONFIG_XFS_RT
+
+/*
+ * Get a passive reference to an rtgroup and declare an intent to update its
+ * metadata.
+ */
+struct xfs_rtgroup *
+xfs_rtgroup_intent_get(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+
+	rgno = xfs_rtb_to_rgno(mp, rtbno);
+	rtg = xfs_rtgroup_get(mp, rgno);
+	if (!rtg)
+		return NULL;
+
+	xfs_rtgroup_intent_hold(rtg);
+	return rtg;
+}
+
+/*
+ * Release our intent to update this rtgroup's metadata, and then release our
+ * passive ref to the rtgroup.
+ */
+void
+xfs_rtgroup_intent_put(
+	struct xfs_rtgroup	*rtg)
+{
+	xfs_rtgroup_intent_rele(rtg);
+	xfs_rtgroup_put(rtg);
+}
+/*
+ * Declare an intent to update rtgroup metadata.  Other threads that need
+ * exclusive access can decide to back off if they see declared intentions.
+ */
+void
+xfs_rtgroup_intent_hold(
+	struct xfs_rtgroup	*rtg)
+{
+	trace_xfs_rtgroup_intent_hold(rtg, __return_address);
+	xfs_defer_drain_grab(&rtg->rtg_intents_drain);
+}
+
+/* Release our intent to update this rtgroup's metadata. */
+void
+xfs_rtgroup_intent_rele(
+	struct xfs_rtgroup	*rtg)
+{
+	trace_xfs_rtgroup_intent_rele(rtg, __return_address);
+	xfs_defer_drain_rele(&rtg->rtg_intents_drain);
+}
+
+/*
+ * Wait for the intent update count for this rtgroup to hit zero.
+ * Callers must not hold any rt metadata inode locks.
+ */
+int
+xfs_rtgroup_intent_drain(
+	struct xfs_rtgroup	*rtg)
+{
+	trace_xfs_rtgroup_wait_intents(rtg, __return_address);
+	return xfs_defer_drain_wait(&rtg->rtg_intents_drain);
+}
+
+/* Has anyone declared an intent to update this rtgroup? */
+bool
+xfs_rtgroup_intent_busy(
+	struct xfs_rtgroup	*rtg)
+{
+	return xfs_defer_drain_busy(&rtg->rtg_intents_drain);
+}
+#endif /* CONFIG_XFS_RT */
diff --git a/fs/xfs/xfs_drain.h b/fs/xfs/xfs_drain.h
index 775164f54ea6d..b02ff87a873a1 100644
--- a/fs/xfs/xfs_drain.h
+++ b/fs/xfs/xfs_drain.h
@@ -7,6 +7,7 @@
 #define XFS_DRAIN_H_
 
 struct xfs_perag;
+struct xfs_rtgroup;
 
 #ifdef CONFIG_XFS_DRAIN_INTENTS
 /*
@@ -25,8 +26,8 @@ struct xfs_defer_drain {
 void xfs_defer_drain_init(struct xfs_defer_drain *dr);
 void xfs_defer_drain_free(struct xfs_defer_drain *dr);
 
-void xfs_drain_wait_disable(void);
-void xfs_drain_wait_enable(void);
+void xfs_defer_drain_wait_disable(void);
+void xfs_defer_drain_wait_enable(void);
 
 /*
  * Deferred Work Intent Drains
@@ -60,6 +61,9 @@ void xfs_drain_wait_enable(void);
  * All functions that create work items must increment the intent counter as
  * soon as the item is added to the transaction and cannot drop the counter
  * until the item is finished or cancelled.
+ *
+ * The same principles apply to realtime groups because the rt metadata inode
+ * ILOCKs are not held across transaction rolls.
  */
 struct xfs_perag *xfs_perag_intent_get(struct xfs_mount *mp,
 		xfs_fsblock_t fsbno);
@@ -70,6 +74,7 @@ void xfs_perag_intent_rele(struct xfs_perag *pag);
 
 int xfs_perag_intent_drain(struct xfs_perag *pag);
 bool xfs_perag_intent_busy(struct xfs_perag *pag);
+
 #else
 struct xfs_defer_drain { /* empty */ };
 
@@ -85,4 +90,23 @@ static inline void xfs_perag_intent_rele(struct xfs_perag *pag) { }
 
 #endif /* CONFIG_XFS_DRAIN_INTENTS */
 
+#if defined(CONFIG_XFS_DRAIN_INTENTS) && defined(CONFIG_XFS_RT)
+struct xfs_rtgroup *xfs_rtgroup_intent_get(struct xfs_mount *mp,
+		xfs_rtblock_t rtbno);
+void xfs_rtgroup_intent_put(struct xfs_rtgroup *rtg);
+
+void xfs_rtgroup_intent_hold(struct xfs_rtgroup *rtg);
+void xfs_rtgroup_intent_rele(struct xfs_rtgroup *rtg);
+
+int xfs_rtgroup_intent_drain(struct xfs_rtgroup *rtg);
+bool xfs_rtgroup_intent_busy(struct xfs_rtgroup *rtg);
+#else
+#define xfs_rtgroup_intent_get(mp, rtbno) \
+	xfs_rtgroup_get(mp, xfs_rtb_to_rgno((mp), (rtbno)))
+#define xfs_rtgroup_intent_put(rtg)		xfs_rtgroup_put(rtg)
+static inline void xfs_rtgroup_intent_hold(struct xfs_rtgroup *rtg) { }
+static inline void xfs_rtgroup_intent_rele(struct xfs_rtgroup *rtg) { }
+#endif /* CONFIG_XFS_DRAIN_INTENTS && CONFIG_XFS_RT */
+
+
 #endif /* XFS_DRAIN_H_ */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 51a363d85978f..a17d2bf05b414 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -468,11 +468,8 @@ xfs_extent_free_defer_add(
 	trace_xfs_extent_free_defer(mp, xefi);
 
 	if (xfs_efi_is_realtime(xefi)) {
-		xfs_rgnumber_t		rgno;
-
-		rgno = xfs_rtb_to_rgno(mp, xefi->xefi_startblock);
-		xefi->xefi_rtg = xfs_rtgroup_get(mp, rgno);
-
+		xefi->xefi_rtg = xfs_rtgroup_intent_get(mp,
+						xefi->xefi_startblock);
 		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
 				&xfs_rtextent_free_defer_type);
 		return;
@@ -615,11 +612,8 @@ xfs_efi_recover_work(
 	xefi->xefi_agresv = XFS_AG_RESV_NONE;
 	xefi->xefi_owner = XFS_RMAP_OWN_UNKNOWN;
 	if (isrt) {
-		xfs_rgnumber_t		rgno;
-
 		xefi->xefi_flags |= XFS_EFI_REALTIME;
-		rgno = xfs_rtb_to_rgno(mp, extp->ext_start);
-		xefi->xefi_rtg = xfs_rtgroup_get(mp, rgno);
+		xefi->xefi_rtg = xfs_rtgroup_intent_get(mp, extp->ext_start);
 	} else {
 		xefi->xefi_pag = xfs_perag_intent_get(mp, extp->ext_start);
 	}
@@ -778,7 +772,7 @@ xfs_rtextent_free_cancel_item(
 {
 	struct xfs_extent_free_item	*xefi = xefi_entry(item);
 
-	xfs_rtgroup_put(xefi->xefi_rtg);
+	xfs_rtgroup_intent_put(xefi->xefi_rtg);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index ada8b281d74e2..21c889a723820 100644
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
index 580baf3b1b1d3..f4270efc9dc5e 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -383,13 +383,12 @@ xfs_rmap_defer_add(
 	 * section updates.
 	 */
 	if (ri->ri_realtime) {
-		xfs_rgnumber_t	rgno;
-
-		rgno = xfs_rtb_to_rgno(mp, ri->ri_bmap.br_startblock);
-		ri->ri_rtg = xfs_rtgroup_get(mp, rgno);
+		ri->ri_rtg = xfs_rtgroup_intent_get(mp,
+						ri->ri_bmap.br_startblock);
 		xfs_defer_add(tp, &ri->ri_list, &xfs_rtrmap_update_defer_type);
 	} else {
-		ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_bmap.br_startblock);
+		ri->ri_pag = xfs_perag_intent_get(mp,
+						ri->ri_bmap.br_startblock);
 		xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
 	}
 }
@@ -538,10 +537,7 @@ xfs_rui_recover_work(
 			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
 	ri->ri_realtime = isrt;
 	if (isrt) {
-		xfs_rgnumber_t	rgno;
-
-		rgno = xfs_rtb_to_rgno(mp, map->me_startblock);
-		ri->ri_rtg = xfs_rtgroup_get(mp, rgno);
+		ri->ri_rtg = xfs_rtgroup_intent_get(mp, map->me_startblock);
 	} else {
 		ri->ri_pag = xfs_perag_intent_get(mp, map->me_startblock);
 	}
@@ -684,7 +680,7 @@ xfs_rtrmap_update_cancel_item(
 {
 	struct xfs_rmap_intent		*ri = ri_entry(item);
 
-	xfs_rtgroup_put(ri->ri_rtg);
+	xfs_rtgroup_intent_put(ri->ri_rtg);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2dc991730c303..05d8ff68b09e2 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4952,6 +4952,38 @@ DEFINE_PERAG_INTENTS_EVENT(xfs_perag_intent_hold);
 DEFINE_PERAG_INTENTS_EVENT(xfs_perag_intent_rele);
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
+		__entry->nr_intents = atomic_read(&rtg->rtg_intents_drain.dr_count);
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
+DEFINE_RTGROUP_INTENTS_EVENT(xfs_rtgroup_intent_hold);
+DEFINE_RTGROUP_INTENTS_EVENT(xfs_rtgroup_intent_rele);
+DEFINE_RTGROUP_INTENTS_EVENT(xfs_rtgroup_wait_intents);
+#endif /* CONFIG_XFS_RT */
+
 #endif /* CONFIG_XFS_DRAIN_INTENTS */
 
 TRACE_EVENT(xfs_swapext_overhead,


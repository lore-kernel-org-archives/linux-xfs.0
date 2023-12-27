Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AAA389
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UoRLaENK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F9DC433C7;
	Mon,  1 Jan 2024 00:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068081;
	bh=sjktispdo33sVHopap9yaG8KN8VL46erdgSyAGYyABM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UoRLaENKI5byn6gd/dptCk8yYX/QTlgKqhTQbvddq5qitQZB1WVpdC+waZiboU9DI
	 p4Wwwj6EZwcrROWv7ToOjHu2MzUZ5ItNoU8nyEVMvFr5MRD7VDZ4Ms5Em4kGg0RXkg
	 CCL1QiL8Zw9OTI41OFWPY8Tk9rrRu2ym5JuhhrMUAnd2sMiSz4wrClZA//VYaODY9Z
	 i+zdMD6Yo5QomkvJx8Y7aOl6stGyMujnp+Q931ukkftDVxkpm5Zhjdrwz1WML4kUlf
	 GSzLZJp/WIc1VatJKcUY7v6MeKZKQL5qB7oVMXJogOQPGipQBuiZrxI6mVbKpqh7XM
	 9J84Zf3MOgNUg==
Date: Sun, 31 Dec 2023 16:14:41 +9900
Subject: [PATCH 16/47] xfs: allow queued realtime intents to drain before
 scrubbing
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405015526.1815505.9934847494535195493.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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
 include/xfs_mount.h  |   12 ++++++++++++
 libxfs/defer_item.c  |   31 +++++++++++++------------------
 libxfs/xfs_rtgroup.c |    2 ++
 libxfs/xfs_rtgroup.h |    9 +++++++++
 4 files changed, 36 insertions(+), 18 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 4e4da5bc4fa..07f9e33b8b2 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -333,6 +333,18 @@ struct xfs_defer_drain { /* empty */ };
 static inline void xfs_perag_intent_hold(struct xfs_perag *pag) {}
 static inline void xfs_perag_intent_rele(struct xfs_perag *pag) {}
 
+struct xfs_rtgroup;
+
+#define xfs_rtgroup_intent_get(mp, rgno) \
+	xfs_rtgroup_get((mp), xfs_rtb_to_rgno((mp), (rgno)))
+#define xfs_rtgroup_intent_put(rtg)		xfs_rtgroup_put(rtg)
+
+static inline void xfs_rtgroup_intent_hold(struct xfs_rtgroup *rtg) { }
+static inline void xfs_rtgroup_intent_rele(struct xfs_rtgroup *rtg) { }
+
+#define xfs_drain_free(dr)		((void)0)
+#define xfs_drain_init(dr)		((void)0)
+
 static inline void libxfs_buftarg_drain(struct xfs_buftarg *btp)
 {
 	cache_purge(btp->bcache);
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index a82d23c17cf..e7270d02c4b 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -88,11 +88,8 @@ xfs_extent_free_defer_add(
 	struct xfs_mount		*mp = tp->t_mountp;
 
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
@@ -204,7 +201,7 @@ xfs_rtextent_free_cancel_item(
 {
 	struct xfs_extent_free_item	*xefi = xefi_entry(item);
 
-	xfs_rtgroup_put(xefi->xefi_rtg);
+	xfs_rtgroup_intent_put(xefi->xefi_rtg);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
 }
 
@@ -338,13 +335,12 @@ xfs_rmap_defer_add(
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
@@ -445,7 +441,7 @@ xfs_rtrmap_update_cancel_item(
 {
 	struct xfs_rmap_intent		*ri = ri_entry(item);
 
-	xfs_rtgroup_put(ri->ri_rtg);
+	xfs_rtgroup_intent_put(ri->ri_rtg);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);
 }
 
@@ -656,10 +652,8 @@ xfs_bmap_update_get_group(
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
@@ -695,8 +689,9 @@ xfs_bmap_update_put_group(
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
 
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 449cd57cf9e..1acf98f8c7e 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -159,6 +159,7 @@ xfs_initialize_rtgroups(
 		/* Place kernel structure only init below this point. */
 		spin_lock_init(&rtg->rtg_state_lock);
 		init_waitqueue_head(&rtg->rtg_active_wq);
+		xfs_defer_drain_init(&rtg->rtg_intents_drain);
 #endif /* __KERNEL__ */
 
 		/* Active ref owned by mount indicates rtgroup is online. */
@@ -213,6 +214,7 @@ xfs_free_rtgroups(
 		spin_unlock(&mp->m_rtgroup_lock);
 		ASSERT(rtg);
 		XFS_IS_CORRUPT(mp, atomic_read(&rtg->rtg_ref) != 0);
+		xfs_defer_drain_free(&rtg->rtg_intents_drain);
 
 		/* drop the mount's active reference */
 		xfs_rtgroup_rele(rtg);
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 559a5135820..9487c2e0047 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
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
 


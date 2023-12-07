Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB00415C8
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8QVpZTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD33C433C7;
	Thu,  7 Dec 2023 02:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916051;
	bh=3OK8j0RudwGaq11Ijt5sK9PLnviYZL6uROP/H9YIeKk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g8QVpZTbGd9ENaM6gpGgEuaGtWhHQ/ptJ3aJjmwTKINUjSZvgOLVKziX7XlQc8jQ9
	 q1mfTuVWyEs1rKUbShvHWxn0PTHD3fvS3X6EQfbhqnIN2tR8rK5p+e/5kJyF+0pcKb
	 jSzU5QMTytpDcizjRalPFlmdjxJ0houHG2F4QhfeQJkZaupnsZCgXEtkjrAye5eXGY
	 JLIrJKZbBrPbCbFPVwZ2SkneSQ+T2dSpesX7aOiaRCOKKF2DJs8YlJ0haRotxhbT2O
	 87s63RCdl5QHuCIIhMzoeYBUsDLQ7P5cEe0jXqc+7JGqOytuQmjGlmrlQVlMKFy+Yc
	 ue/Hc9UHwTB0w==
Date: Wed, 06 Dec 2023 18:27:30 -0800
Subject: [PATCH 9/9] xfs: move ->iop_relog to struct xfs_defer_op_type
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191562529.1133395.5713030567745824579.stgit@frogsfrogsfrogs>
In-Reply-To: <170191562370.1133395.5436656395520338293.stgit@frogsfrogsfrogs>
References: <170191562370.1133395.5436656395520338293.stgit@frogsfrogsfrogs>
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

The only log items that need relogging are the ones created for deferred
work operations, and the only part of the code base that relogs log
items is the deferred work machinery.  Move the function pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c  |   31 +++++++++++++-------
 fs/xfs/libxfs/xfs_defer.h  |    3 ++
 fs/xfs/xfs_attr_item.c     |    8 +++--
 fs/xfs/xfs_bmap_item.c     |   44 ++++++++++++++---------------
 fs/xfs/xfs_extfree_item.c  |   67 ++++++++++++++++++++++----------------------
 fs/xfs/xfs_refcount_item.c |   44 ++++++++++++++---------------
 fs/xfs/xfs_rmap_item.c     |   44 ++++++++++++++---------------
 fs/xfs/xfs_trans.h         |   12 --------
 8 files changed, 127 insertions(+), 126 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 95f15a4b2126..54a6be06e6cd 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -459,6 +459,25 @@ xfs_defer_cancel_list(
 		xfs_defer_pending_cancel_work(mp, dfp);
 }
 
+static inline void
+xfs_defer_relog_intent(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	struct xfs_log_item		*lip;
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+
+	xfs_defer_create_done(tp, dfp);
+
+	lip = ops->relog_intent(tp, dfp->dfp_intent, dfp->dfp_done);
+	if (lip) {
+		xfs_trans_add_item(tp, lip);
+		set_bit(XFS_LI_DIRTY, &lip->li_flags);
+	}
+	dfp->dfp_done = NULL;
+	dfp->dfp_intent = lip;
+}
+
 /*
  * Prevent a log intent item from pinning the tail of the log by logging a
  * done item to release the intent item; and then log a new intent item.
@@ -477,8 +496,6 @@ xfs_defer_relog(
 	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	list_for_each_entry(dfp, dfops, dfp_list) {
-		struct xfs_log_item	*lip;
-
 		/*
 		 * If the log intent item for this deferred op is not a part of
 		 * the current log checkpoint, relog the intent item to keep
@@ -506,15 +523,7 @@ xfs_defer_relog(
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
 		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
 
-		xfs_defer_create_done(*tpp, dfp);
-		lip = xfs_trans_item_relog(dfp->dfp_intent, dfp->dfp_done,
-				*tpp);
-		if (lip) {
-			xfs_trans_add_item(*tpp, lip);
-			set_bit(XFS_LI_DIRTY, &lip->li_flags);
-		}
-		dfp->dfp_done = NULL;
-		dfp->dfp_intent = lip;
+		xfs_defer_relog_intent(*tpp, dfp);
 	}
 
 	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index ef86a7f9b059..78d6dcd1af2c 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -59,6 +59,9 @@ struct xfs_defer_op_type {
 	void (*cancel_item)(struct list_head *item);
 	int (*recover_work)(struct xfs_defer_pending *dfp,
 			    struct list_head *capture_list);
+	struct xfs_log_item *(*relog_intent)(struct xfs_trans *tp,
+			struct xfs_log_item *intent,
+			struct xfs_log_item *done_item);
 	unsigned int		max_items;
 };
 
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 27553388da99..988d395a48ad 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -625,10 +625,10 @@ xfs_attr_recover_work(
 
 /* Re-log an intent item to push the log tail forward. */
 static struct xfs_log_item *
-xfs_attri_item_relog(
+xfs_attr_relog_intent(
+	struct xfs_trans		*tp,
 	struct xfs_log_item		*intent,
-	struct xfs_log_item		*done_item,
-	struct xfs_trans		*tp)
+	struct xfs_log_item		*done_item)
 {
 	struct xfs_attri_log_item	*old_attrip;
 	struct xfs_attri_log_item	*new_attrip;
@@ -763,6 +763,7 @@ const struct xfs_defer_op_type xfs_attr_defer_type = {
 	.finish_item	= xfs_attr_finish_item,
 	.cancel_item	= xfs_attr_cancel_item,
 	.recover_work	= xfs_attr_recover_work,
+	.relog_intent	= xfs_attr_relog_intent,
 };
 
 /*
@@ -800,7 +801,6 @@ static const struct xfs_item_ops xfs_attri_item_ops = {
 	.iop_unpin	= xfs_attri_item_unpin,
 	.iop_release    = xfs_attri_item_release,
 	.iop_match	= xfs_attri_item_match,
-	.iop_relog	= xfs_attri_item_relog,
 };
 
 const struct xlog_recover_item_ops xlog_attri_item_ops = {
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index f3421e615e1c..bc48d733634a 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -541,6 +541,27 @@ xfs_bmap_recover_work(
 	return error;
 }
 
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_bmap_relog_intent(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	struct xfs_log_item		*done_item)
+{
+	struct xfs_bui_log_item		*buip;
+	struct xfs_map_extent		*map;
+	unsigned int			count;
+
+	count = BUI_ITEM(intent)->bui_format.bui_nextents;
+	map = BUI_ITEM(intent)->bui_format.bui_extents;
+
+	buip = xfs_bui_init(tp->t_mountp);
+	memcpy(buip->bui_format.bui_extents, map, count * sizeof(*map));
+	atomic_set(&buip->bui_next_extent, count);
+
+	return &buip->bui_item;
+}
+
 const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
 	.create_intent	= xfs_bmap_update_create_intent,
@@ -549,6 +570,7 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.finish_item	= xfs_bmap_update_finish_item,
 	.cancel_item	= xfs_bmap_update_cancel_item,
 	.recover_work	= xfs_bmap_recover_work,
+	.relog_intent	= xfs_bmap_relog_intent,
 };
 
 STATIC bool
@@ -559,27 +581,6 @@ xfs_bui_item_match(
 	return BUI_ITEM(lip)->bui_format.bui_id == intent_id;
 }
 
-/* Relog an intent item to push the log tail forward. */
-static struct xfs_log_item *
-xfs_bui_item_relog(
-	struct xfs_log_item		*intent,
-	struct xfs_log_item		*done_item,
-	struct xfs_trans		*tp)
-{
-	struct xfs_bui_log_item		*buip;
-	struct xfs_map_extent		*map;
-	unsigned int			count;
-
-	count = BUI_ITEM(intent)->bui_format.bui_nextents;
-	map = BUI_ITEM(intent)->bui_format.bui_extents;
-
-	buip = xfs_bui_init(tp->t_mountp);
-	memcpy(buip->bui_format.bui_extents, map, count * sizeof(*map));
-	atomic_set(&buip->bui_next_extent, count);
-
-	return &buip->bui_item;
-}
-
 static const struct xfs_item_ops xfs_bui_item_ops = {
 	.flags		= XFS_ITEM_INTENT,
 	.iop_size	= xfs_bui_item_size,
@@ -587,7 +588,6 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
 	.iop_unpin	= xfs_bui_item_unpin,
 	.iop_release	= xfs_bui_item_release,
 	.iop_match	= xfs_bui_item_match,
-	.iop_relog	= xfs_bui_item_relog,
 };
 
 static inline void
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 518569c64e9c..3ca23ab8d92a 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -643,41 +643,12 @@ xfs_extent_free_recover_work(
 	return error;
 }
 
-const struct xfs_defer_op_type xfs_extent_free_defer_type = {
-	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
-	.create_intent	= xfs_extent_free_create_intent,
-	.abort_intent	= xfs_extent_free_abort_intent,
-	.create_done	= xfs_extent_free_create_done,
-	.finish_item	= xfs_extent_free_finish_item,
-	.cancel_item	= xfs_extent_free_cancel_item,
-	.recover_work	= xfs_extent_free_recover_work,
-};
-
-/* sub-type with special handling for AGFL deferred frees */
-const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
-	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
-	.create_intent	= xfs_extent_free_create_intent,
-	.abort_intent	= xfs_extent_free_abort_intent,
-	.create_done	= xfs_extent_free_create_done,
-	.finish_item	= xfs_agfl_free_finish_item,
-	.cancel_item	= xfs_extent_free_cancel_item,
-	.recover_work	= xfs_extent_free_recover_work,
-};
-
-STATIC bool
-xfs_efi_item_match(
-	struct xfs_log_item	*lip,
-	uint64_t		intent_id)
-{
-	return EFI_ITEM(lip)->efi_format.efi_id == intent_id;
-}
-
 /* Relog an intent item to push the log tail forward. */
 static struct xfs_log_item *
-xfs_efi_item_relog(
+xfs_extent_free_relog_intent(
+	struct xfs_trans		*tp,
 	struct xfs_log_item		*intent,
-	struct xfs_log_item		*done_item,
-	struct xfs_trans		*tp)
+	struct xfs_log_item		*done_item)
 {
 	struct xfs_efd_log_item		*efdp = EFD_ITEM(done_item);
 	struct xfs_efi_log_item		*efip;
@@ -697,6 +668,37 @@ xfs_efi_item_relog(
 	return &efip->efi_item;
 }
 
+const struct xfs_defer_op_type xfs_extent_free_defer_type = {
+	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_extent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_extent_free_finish_item,
+	.cancel_item	= xfs_extent_free_cancel_item,
+	.recover_work	= xfs_extent_free_recover_work,
+	.relog_intent	= xfs_extent_free_relog_intent,
+};
+
+/* sub-type with special handling for AGFL deferred frees */
+const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
+	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_extent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_agfl_free_finish_item,
+	.cancel_item	= xfs_extent_free_cancel_item,
+	.recover_work	= xfs_extent_free_recover_work,
+	.relog_intent	= xfs_extent_free_relog_intent,
+};
+
+STATIC bool
+xfs_efi_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return EFI_ITEM(lip)->efi_format.efi_id == intent_id;
+}
+
 static const struct xfs_item_ops xfs_efi_item_ops = {
 	.flags		= XFS_ITEM_INTENT,
 	.iop_size	= xfs_efi_item_size,
@@ -704,7 +706,6 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_unpin	= xfs_efi_item_unpin,
 	.iop_release	= xfs_efi_item_release,
 	.iop_match	= xfs_efi_item_match,
-	.iop_relog	= xfs_efi_item_relog,
 };
 
 /*
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index d218a9ed4d82..9974be81cb2b 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -501,6 +501,27 @@ xfs_refcount_recover_work(
 	return error;
 }
 
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_refcount_relog_intent(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	struct xfs_log_item		*done_item)
+{
+	struct xfs_cui_log_item		*cuip;
+	struct xfs_phys_extent		*pmap;
+	unsigned int			count;
+
+	count = CUI_ITEM(intent)->cui_format.cui_nextents;
+	pmap = CUI_ITEM(intent)->cui_format.cui_extents;
+
+	cuip = xfs_cui_init(tp->t_mountp, count);
+	memcpy(cuip->cui_format.cui_extents, pmap, count * sizeof(*pmap));
+	atomic_set(&cuip->cui_next_extent, count);
+
+	return &cuip->cui_item;
+}
+
 const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
 	.create_intent	= xfs_refcount_update_create_intent,
@@ -510,6 +531,7 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.finish_cleanup = xfs_refcount_finish_one_cleanup,
 	.cancel_item	= xfs_refcount_update_cancel_item,
 	.recover_work	= xfs_refcount_recover_work,
+	.relog_intent	= xfs_refcount_relog_intent,
 };
 
 STATIC bool
@@ -520,27 +542,6 @@ xfs_cui_item_match(
 	return CUI_ITEM(lip)->cui_format.cui_id == intent_id;
 }
 
-/* Relog an intent item to push the log tail forward. */
-static struct xfs_log_item *
-xfs_cui_item_relog(
-	struct xfs_log_item		*intent,
-	struct xfs_log_item		*done_item,
-	struct xfs_trans		*tp)
-{
-	struct xfs_cui_log_item		*cuip;
-	struct xfs_phys_extent		*pmap;
-	unsigned int			count;
-
-	count = CUI_ITEM(intent)->cui_format.cui_nextents;
-	pmap = CUI_ITEM(intent)->cui_format.cui_extents;
-
-	cuip = xfs_cui_init(tp->t_mountp, count);
-	memcpy(cuip->cui_format.cui_extents, pmap, count * sizeof(*pmap));
-	atomic_set(&cuip->cui_next_extent, count);
-
-	return &cuip->cui_item;
-}
-
 static const struct xfs_item_ops xfs_cui_item_ops = {
 	.flags		= XFS_ITEM_INTENT,
 	.iop_size	= xfs_cui_item_size,
@@ -548,7 +549,6 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
 	.iop_unpin	= xfs_cui_item_unpin,
 	.iop_release	= xfs_cui_item_release,
 	.iop_match	= xfs_cui_item_match,
-	.iop_relog	= xfs_cui_item_relog,
 };
 
 static inline void
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 96e0c2b0d059..488c4a2a80a3 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -554,6 +554,27 @@ xfs_rmap_recover_work(
 	return error;
 }
 
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_rmap_relog_intent(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	struct xfs_log_item		*done_item)
+{
+	struct xfs_rui_log_item		*ruip;
+	struct xfs_map_extent		*map;
+	unsigned int			count;
+
+	count = RUI_ITEM(intent)->rui_format.rui_nextents;
+	map = RUI_ITEM(intent)->rui_format.rui_extents;
+
+	ruip = xfs_rui_init(tp->t_mountp, count);
+	memcpy(ruip->rui_format.rui_extents, map, count * sizeof(*map));
+	atomic_set(&ruip->rui_next_extent, count);
+
+	return &ruip->rui_item;
+}
+
 const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
 	.create_intent	= xfs_rmap_update_create_intent,
@@ -563,6 +584,7 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.finish_cleanup = xfs_rmap_finish_one_cleanup,
 	.cancel_item	= xfs_rmap_update_cancel_item,
 	.recover_work	= xfs_rmap_recover_work,
+	.relog_intent	= xfs_rmap_relog_intent,
 };
 
 STATIC bool
@@ -573,27 +595,6 @@ xfs_rui_item_match(
 	return RUI_ITEM(lip)->rui_format.rui_id == intent_id;
 }
 
-/* Relog an intent item to push the log tail forward. */
-static struct xfs_log_item *
-xfs_rui_item_relog(
-	struct xfs_log_item		*intent,
-	struct xfs_log_item		*done_item,
-	struct xfs_trans		*tp)
-{
-	struct xfs_rui_log_item		*ruip;
-	struct xfs_map_extent		*map;
-	unsigned int			count;
-
-	count = RUI_ITEM(intent)->rui_format.rui_nextents;
-	map = RUI_ITEM(intent)->rui_format.rui_extents;
-
-	ruip = xfs_rui_init(tp->t_mountp, count);
-	memcpy(ruip->rui_format.rui_extents, map, count * sizeof(*map));
-	atomic_set(&ruip->rui_next_extent, count);
-
-	return &ruip->rui_item;
-}
-
 static const struct xfs_item_ops xfs_rui_item_ops = {
 	.flags		= XFS_ITEM_INTENT,
 	.iop_size	= xfs_rui_item_size,
@@ -601,7 +602,6 @@ static const struct xfs_item_ops xfs_rui_item_ops = {
 	.iop_unpin	= xfs_rui_item_unpin,
 	.iop_release	= xfs_rui_item_release,
 	.iop_match	= xfs_rui_item_match,
-	.iop_relog	= xfs_rui_item_relog,
 };
 
 static inline void
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 25646e2b12f4..2cb1e143fc49 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -79,9 +79,6 @@ struct xfs_item_ops {
 	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
 	void (*iop_release)(struct xfs_log_item *);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
-	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
-			struct xfs_log_item *done_item,
-			struct xfs_trans *tp);
 	struct xfs_log_item *(*iop_intent)(struct xfs_log_item *intent_done);
 };
 
@@ -246,15 +243,6 @@ void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
 
 extern struct kmem_cache	*xfs_trans_cache;
 
-static inline struct xfs_log_item *
-xfs_trans_item_relog(
-	struct xfs_log_item	*lip,
-	struct xfs_log_item	*done_lip,
-	struct xfs_trans	*tp)
-{
-	return lip->li_ops->iop_relog(lip, done_lip, tp);
-}
-
 struct xfs_dquot;
 
 int xfs_trans_alloc_inode(struct xfs_inode *ip, struct xfs_trans_res *resv,


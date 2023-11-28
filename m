Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F4E3D0DC
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 20:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5mM9LVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDC8C433C8;
	Tue, 28 Nov 2023 20:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701203230;
	bh=3S/7G6+ShScD+LzmHp0IB3MZz4JiMbOwq9xuQfc1Cho=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=f5mM9LVq8kpIsn0US5kuVxRanrOqX1SrIDFbRcNC+WgKrDE7P5NI7PiuMLVm0hO9W
	 p6TIIupCwTg5MvnOvPQWvysonQFolji1qwo3OWzgGVttKIsH05DApieKAOWTWvqjQD
	 hpQYwhR4wzBb4PrOQocAv+dnegV0dz9KY7/0O//1iMmQsSVeVbavM9gqxv5YhpNotE
	 gY/oVSmHM/mdeo3q/cXqDPLtSxOBVlwufPfrqQ7P1lSOlxdR1fCJpDl7uHpZLliC9x
	 cmA3yIvSwcCubLZHn45CrS4GrokhhpGs0gNnAYufnEe3PfmKoy1HsObTe5LyCepDAu
	 mdeedFTn6BwVw==
Subject: [PATCH 7/7] xfs: move ->iop_recover to xfs_defer_op_type
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, leo.lilong@huawei.com, chandanbabu@kernel.org,
 hch@lst.de
Cc: linux-xfs@vger.kernel.org
Date: Tue, 28 Nov 2023 12:27:08 -0800
Message-ID: <170120322874.13206.13311055647910298715.stgit@frogsfrogsfrogs>
In-Reply-To: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
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

Finish off the series by moving the intent item recovery function
pointer to the xfs_defer_op_type struct, since this is really a deferred
work function now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c       |   17 +++++++++++++++
 fs/xfs/libxfs/xfs_defer.h       |    4 ++++
 fs/xfs/libxfs/xfs_log_recover.h |    2 ++
 fs/xfs/xfs_attr_item.c          |    4 ++--
 fs/xfs/xfs_bmap_item.c          |   22 ++++++++++----------
 fs/xfs/xfs_extfree_item.c       |   43 ++++++++++++++++++++-------------------
 fs/xfs/xfs_log_recover.c        |    9 +++-----
 fs/xfs/xfs_refcount_item.c      |   24 +++++++++++-----------
 fs/xfs/xfs_rmap_item.c          |   24 +++++++++++-----------
 fs/xfs/xfs_trans.h              |    4 ----
 10 files changed, 85 insertions(+), 68 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 7ad554dda0aa..2b805e6fd320 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -711,6 +711,23 @@ xfs_defer_cancel_recovery(
 	xfs_defer_pending_cancel_work(mp, dfp);
 }
 
+/* Replay the deferred work item created from a recovered log intent item. */
+int
+xfs_defer_finish_recovery(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp,
+	struct list_head		*capture_list)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	int				error;
+
+	error = ops->recover_work(dfp, capture_list);
+	if (error)
+		trace_xlog_intent_recovery_failed(mp, error,
+				ops->recover_work);
+	return error;
+}
+
 /*
  * Move deferred ops from one transaction to another and reset the source to
  * initial state. This is primarily used to carry state forward across
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 49aaba364abc..d4800491f749 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -57,6 +57,8 @@ struct xfs_defer_op_type {
 	void (*finish_cleanup)(struct xfs_trans *tp,
 			struct xfs_btree_cur *state, int error);
 	void (*cancel_item)(struct list_head *item);
+	int (*recover_work)(struct xfs_defer_pending *dfp,
+			    struct list_head *capture_list);
 	unsigned int		max_items;
 };
 
@@ -130,6 +132,8 @@ struct xfs_defer_pending *xfs_defer_start_recovery(struct xfs_log_item *lip,
 		enum xfs_defer_ops_type dfp_type);
 void xfs_defer_cancel_recovery(struct xfs_mount *mp,
 		struct xfs_defer_pending *dfp);
+int xfs_defer_finish_recovery(struct xfs_mount *mp,
+		struct xfs_defer_pending *dfp, struct list_head *capture_list);
 
 static inline void
 xfs_defer_recover_work_item(
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 52162a17fc5e..c8e5d912895b 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -153,6 +153,8 @@ xlog_recover_resv(const struct xfs_trans_res *r)
 	return ret;
 }
 
+struct xfs_defer_pending;
+
 void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
 		xfs_lsn_t lsn, unsigned int dfp_type);
 int xlog_recover_finish_intent(struct xfs_trans *tp,
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 20a14ac13a51..b4b45d7333e3 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -606,7 +606,7 @@ xfs_attri_recover_work(
  * delete the attr that it describes.
  */
 STATIC int
-xfs_attri_item_recover(
+xfs_attr_recover_work(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
@@ -822,6 +822,7 @@ const struct xfs_defer_op_type xfs_attr_defer_type = {
 	.create_done	= xfs_attr_create_done,
 	.finish_item	= xfs_attr_finish_item,
 	.cancel_item	= xfs_attr_cancel_item,
+	.recover_work	= xfs_attr_recover_work,
 };
 
 /*
@@ -858,7 +859,6 @@ static const struct xfs_item_ops xfs_attri_item_ops = {
 	.iop_format	= xfs_attri_item_format,
 	.iop_unpin	= xfs_attri_item_unpin,
 	.iop_release    = xfs_attri_item_release,
-	.iop_recover	= xfs_attri_item_recover,
 	.iop_match	= xfs_attri_item_match,
 	.iop_relog	= xfs_attri_item_relog,
 };
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 84381611be73..193166a81aa7 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -437,15 +437,6 @@ xfs_bmap_update_cancel_item(
 	kmem_cache_free(xfs_bmap_intent_cache, bi);
 }
 
-const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
-	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
-	.create_intent	= xfs_bmap_update_create_intent,
-	.abort_intent	= xfs_bmap_update_abort_intent,
-	.create_done	= xfs_bmap_update_create_done,
-	.finish_item	= xfs_bmap_update_finish_item,
-	.cancel_item	= xfs_bmap_update_cancel_item,
-};
-
 /* Is this recovered BUI ok? */
 static inline bool
 xfs_bui_validate(
@@ -509,7 +500,7 @@ xfs_bui_recover_work(
  * We need to update some inode's bmbt.
  */
 STATIC int
-xfs_bui_item_recover(
+xfs_bmap_recover_work(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
@@ -588,6 +579,16 @@ xfs_bui_item_recover(
 	return error;
 }
 
+const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
+	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_bmap_update_create_intent,
+	.abort_intent	= xfs_bmap_update_abort_intent,
+	.create_done	= xfs_bmap_update_create_done,
+	.finish_item	= xfs_bmap_update_finish_item,
+	.cancel_item	= xfs_bmap_update_cancel_item,
+	.recover_work	= xfs_bmap_recover_work,
+};
+
 STATIC bool
 xfs_bui_item_match(
 	struct xfs_log_item	*lip,
@@ -628,7 +629,6 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
 	.iop_format	= xfs_bui_item_format,
 	.iop_unpin	= xfs_bui_item_unpin,
 	.iop_release	= xfs_bui_item_release,
-	.iop_recover	= xfs_bui_item_recover,
 	.iop_match	= xfs_bui_item_match,
 	.iop_relog	= xfs_bui_item_relog,
 };
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 1ee24506415e..94eb2f726829 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -567,15 +567,6 @@ xfs_extent_free_cancel_item(
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
 }
 
-const struct xfs_defer_op_type xfs_extent_free_defer_type = {
-	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
-	.create_intent	= xfs_extent_free_create_intent,
-	.abort_intent	= xfs_extent_free_abort_intent,
-	.create_done	= xfs_extent_free_create_done,
-	.finish_item	= xfs_extent_free_finish_item,
-	.cancel_item	= xfs_extent_free_cancel_item,
-};
-
 /*
  * AGFL blocks are accounted differently in the reserve pools and are not
  * inserted into the busy extent list.
@@ -632,16 +623,6 @@ xfs_agfl_free_finish_item(
 	return error;
 }
 
-/* sub-type with special handling for AGFL deferred frees */
-const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
-	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
-	.create_intent	= xfs_extent_free_create_intent,
-	.abort_intent	= xfs_extent_free_abort_intent,
-	.create_done	= xfs_extent_free_create_done,
-	.finish_item	= xfs_agfl_free_finish_item,
-	.cancel_item	= xfs_extent_free_cancel_item,
-};
-
 /* Is this recovered EFI ok? */
 static inline bool
 xfs_efi_validate_ext(
@@ -676,7 +657,7 @@ xfs_efi_recover_work(
  * the log.  We need to free the extents that it describes.
  */
 STATIC int
-xfs_efi_item_recover(
+xfs_extent_free_recover_work(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
@@ -725,6 +706,27 @@ xfs_efi_item_recover(
 	return error;
 }
 
+const struct xfs_defer_op_type xfs_extent_free_defer_type = {
+	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_extent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_extent_free_finish_item,
+	.cancel_item	= xfs_extent_free_cancel_item,
+	.recover_work	= xfs_extent_free_recover_work,
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
+};
+
 STATIC bool
 xfs_efi_item_match(
 	struct xfs_log_item	*lip,
@@ -767,7 +769,6 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_format	= xfs_efi_item_format,
 	.iop_unpin	= xfs_efi_item_unpin,
 	.iop_release	= xfs_efi_item_release,
-	.iop_recover	= xfs_efi_item_recover,
 	.iop_match	= xfs_efi_item_match,
 	.iop_relog	= xfs_efi_item_relog,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9bd2bdf42a84..7bd67e0400ee 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2568,7 +2568,6 @@ xlog_recover_process_intents(
 
 	list_for_each_entry_safe(dfp, n, &log->l_dfops, dfp_list) {
 		struct xfs_log_item	*lip = dfp->dfp_intent;
-		const struct xfs_item_ops *ops = lip->li_ops;
 
 		ASSERT(xlog_item_is_intent(lip));
 
@@ -2587,12 +2586,10 @@ xlog_recover_process_intents(
 		 *
 		 * The recovery function can free @dfp.
 		 */
-		error = ops->iop_recover(dfp, &capture_list);
-		if (error) {
-			trace_xlog_intent_recovery_failed(log->l_mp, error,
-					ops->iop_recover);
+		error = xfs_defer_finish_recovery(log->l_mp, dfp,
+				&capture_list);
+		if (error)
 			break;
-		}
 	}
 	if (error)
 		goto err;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index a0e3a42555ec..494e2561420f 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -433,16 +433,6 @@ xfs_refcount_update_cancel_item(
 	kmem_cache_free(xfs_refcount_intent_cache, ri);
 }
 
-const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
-	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
-	.create_intent	= xfs_refcount_update_create_intent,
-	.abort_intent	= xfs_refcount_update_abort_intent,
-	.create_done	= xfs_refcount_update_create_done,
-	.finish_item	= xfs_refcount_update_finish_item,
-	.finish_cleanup = xfs_refcount_finish_one_cleanup,
-	.cancel_item	= xfs_refcount_update_cancel_item,
-};
-
 /* Is this recovered CUI ok? */
 static inline bool
 xfs_cui_validate_phys(
@@ -492,7 +482,7 @@ xfs_cui_recover_work(
  * We need to update the refcountbt.
  */
 STATIC int
-xfs_cui_item_recover(
+xfs_refcount_recover_work(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
@@ -554,6 +544,17 @@ xfs_cui_item_recover(
 	return error;
 }
 
+const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
+	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_refcount_update_create_intent,
+	.abort_intent	= xfs_refcount_update_abort_intent,
+	.create_done	= xfs_refcount_update_create_done,
+	.finish_item	= xfs_refcount_update_finish_item,
+	.finish_cleanup = xfs_refcount_finish_one_cleanup,
+	.cancel_item	= xfs_refcount_update_cancel_item,
+	.recover_work	= xfs_refcount_recover_work,
+};
+
 STATIC bool
 xfs_cui_item_match(
 	struct xfs_log_item	*lip,
@@ -594,7 +595,6 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
 	.iop_format	= xfs_cui_item_format,
 	.iop_unpin	= xfs_cui_item_unpin,
 	.iop_release	= xfs_cui_item_release,
-	.iop_recover	= xfs_cui_item_recover,
 	.iop_match	= xfs_cui_item_match,
 	.iop_relog	= xfs_cui_item_relog,
 };
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 2c883ca8a545..75b71be845b7 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -452,16 +452,6 @@ xfs_rmap_update_cancel_item(
 	kmem_cache_free(xfs_rmap_intent_cache, ri);
 }
 
-const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
-	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
-	.create_intent	= xfs_rmap_update_create_intent,
-	.abort_intent	= xfs_rmap_update_abort_intent,
-	.create_done	= xfs_rmap_update_create_done,
-	.finish_item	= xfs_rmap_update_finish_item,
-	.finish_cleanup = xfs_rmap_finish_one_cleanup,
-	.cancel_item	= xfs_rmap_update_cancel_item,
-};
-
 /* Is this recovered RUI ok? */
 static inline bool
 xfs_rui_validate_map(
@@ -557,7 +547,7 @@ xfs_rui_recover_work(
  * We need to update the rmapbt.
  */
 STATIC int
-xfs_rui_item_recover(
+xfs_rmap_recover_work(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
@@ -607,6 +597,17 @@ xfs_rui_item_recover(
 	return error;
 }
 
+const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
+	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_rmap_update_create_intent,
+	.abort_intent	= xfs_rmap_update_abort_intent,
+	.create_done	= xfs_rmap_update_create_done,
+	.finish_item	= xfs_rmap_update_finish_item,
+	.finish_cleanup = xfs_rmap_finish_one_cleanup,
+	.cancel_item	= xfs_rmap_update_cancel_item,
+	.recover_work	= xfs_rmap_recover_work,
+};
+
 STATIC bool
 xfs_rui_item_match(
 	struct xfs_log_item	*lip,
@@ -647,7 +648,6 @@ static const struct xfs_item_ops xfs_rui_item_ops = {
 	.iop_format	= xfs_rui_item_format,
 	.iop_unpin	= xfs_rui_item_unpin,
 	.iop_release	= xfs_rui_item_release,
-	.iop_recover	= xfs_rui_item_recover,
 	.iop_match	= xfs_rui_item_match,
 	.iop_relog	= xfs_rui_item_relog,
 };
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 4e38357237c3..5fb018ad9fc0 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -66,8 +66,6 @@ struct xfs_log_item {
 	{ (1u << XFS_LI_DIRTY),		"DIRTY" }, \
 	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }
 
-struct xfs_defer_pending;
-
 struct xfs_item_ops {
 	unsigned flags;
 	void (*iop_size)(struct xfs_log_item *, int *, int *);
@@ -80,8 +78,6 @@ struct xfs_item_ops {
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
 	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
 	void (*iop_release)(struct xfs_log_item *);
-	int (*iop_recover)(struct xfs_defer_pending *dfp,
-			   struct list_head *capture_list);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
 			struct xfs_trans *tp);


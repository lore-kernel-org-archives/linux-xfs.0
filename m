Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C5D4417
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i054y0NC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2D5C433C8;
	Thu,  7 Dec 2023 02:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916035;
	bh=Dji4v6AkSFRXP+WBSztxbg1JW75cmhCoNwRSL2TS5rM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i054y0NCX2osDUli4j7NQP8KI4YaNA1yUHWF6PQcbWqAzIlMWqsPh043h7Yk/anj2
	 EWbI4qrNnkN/NNT0pLix1TGOtM8TxvJcn+OuLw5dulC3kit3Cm5RCAIqTHDY437UAc
	 n3aTERUZpuQZXbCJiKQoKpmCfJ8rkZ2bReTD3H1gFFBHTNE81waRGMvWO2WKTQllqG
	 ZGmnTX1DhECaEYl7/m2RvhepjcyPOF8XOH0qjnm1ntxfZt7VsOvhoH6Fh37ggwACST
	 x8GNCacM079PqiUXz269eGAyu4Goe4k1rTacnvLkwSN4SyFP9DW9r5yECaWwelCGsP
	 zilYOkQ2QCWrQ==
Date: Wed, 06 Dec 2023 18:27:15 -0800
Subject: [PATCH 8/9] xfs: collapse the ->create_done functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191562513.1133395.6193847492225162385.stgit@frogsfrogsfrogs>
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

Move the meat of the ->create_done function helpers into ->create_done
to reduce the amount of boilerplate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c     |   37 +++++++++++--------------------
 fs/xfs/xfs_bmap_item.c     |   29 +++++++++---------------
 fs/xfs/xfs_extfree_item.c  |   53 +++++++++++++++++---------------------------
 fs/xfs/xfs_refcount_item.c |   27 ++++++++--------------
 fs/xfs/xfs_rmap_item.c     |   27 ++++++++--------------
 5 files changed, 64 insertions(+), 109 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c815811d937a..27553388da99 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -33,8 +33,6 @@ struct kmem_cache		*xfs_attrd_cache;
 
 static const struct xfs_item_ops xfs_attri_item_ops;
 static const struct xfs_item_ops xfs_attrd_item_ops;
-static struct xfs_attrd_log_item *xfs_trans_get_attrd(struct xfs_trans *tp,
-					struct xfs_attri_log_item *attrip);
 
 static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
 {
@@ -732,16 +730,20 @@ xlog_recover_attri_commit_pass2(
 	return 0;
 }
 
-/*
- * This routine is called to allocate an "attr free done" log item.
- */
-static struct xfs_attrd_log_item *
-xfs_trans_get_attrd(struct xfs_trans		*tp,
-		  struct xfs_attri_log_item	*attrip)
+/* Get an ATTRD so we can process all the attrs. */
+static struct xfs_log_item *
+xfs_attr_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
 {
-	struct xfs_attrd_log_item		*attrdp;
+	struct xfs_attri_log_item	*attrip;
+	struct xfs_attrd_log_item	*attrdp;
 
-	ASSERT(tp != NULL);
+	if (!intent)
+		return NULL;
+
+	attrip = ATTRI_ITEM(intent);
 
 	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
 
@@ -750,20 +752,7 @@ xfs_trans_get_attrd(struct xfs_trans		*tp,
 	attrdp->attrd_attrip = attrip;
 	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
 
-	return attrdp;
-}
-
-/* Get an ATTRD so we can process all the attrs. */
-static struct xfs_log_item *
-xfs_attr_create_done(
-	struct xfs_trans		*tp,
-	struct xfs_log_item		*intent,
-	unsigned int			count)
-{
-	if (!intent)
-		return NULL;
-
-	return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
+	return &attrdp->attrd_item;
 }
 
 const struct xfs_defer_op_type xfs_attr_defer_type = {
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 0be7a1224a81..f3421e615e1c 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -221,22 +221,6 @@ static const struct xfs_item_ops xfs_bud_item_ops = {
 	.iop_intent	= xfs_bud_item_intent,
 };
 
-static struct xfs_bud_log_item *
-xfs_trans_get_bud(
-	struct xfs_trans		*tp,
-	struct xfs_bui_log_item		*buip)
-{
-	struct xfs_bud_log_item		*budp;
-
-	budp = kmem_cache_zalloc(xfs_bud_cache, GFP_KERNEL | __GFP_NOFAIL);
-	xfs_log_item_init(tp->t_mountp, &budp->bud_item, XFS_LI_BUD,
-			  &xfs_bud_item_ops);
-	budp->bud_buip = buip;
-	budp->bud_format.bud_bui_id = buip->bui_format.bui_id;
-
-	return budp;
-}
-
 /* Sort bmap intents by inode. */
 static int
 xfs_bmap_update_diff_items(
@@ -321,14 +305,23 @@ xfs_bmap_update_create_intent(
 	return &buip->bui_item;
 }
 
-/* Get an BUD so we can process all the deferred rmap updates. */
+/* Get an BUD so we can process all the deferred bmap updates. */
 static struct xfs_log_item *
 xfs_bmap_update_create_done(
 	struct xfs_trans		*tp,
 	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return &xfs_trans_get_bud(tp, BUI_ITEM(intent))->bud_item;
+	struct xfs_bui_log_item		*buip = BUI_ITEM(intent);
+	struct xfs_bud_log_item		*budp;
+
+	budp = kmem_cache_zalloc(xfs_bud_cache, GFP_KERNEL | __GFP_NOFAIL);
+	xfs_log_item_init(tp->t_mountp, &budp->bud_item, XFS_LI_BUD,
+			  &xfs_bud_item_ops);
+	budp->bud_buip = buip;
+	budp->bud_format.bud_bui_id = buip->bui_format.bui_id;
+
+	return &budp->bud_item;
 }
 
 /* Take a passive ref to the AG containing the space we're mapping. */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 44bbf620e0cf..518569c64e9c 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -303,38 +303,6 @@ static const struct xfs_item_ops xfs_efd_item_ops = {
 	.iop_intent	= xfs_efd_item_intent,
 };
 
-/*
- * Allocate an "extent free done" log item that will hold nextents worth of
- * extents.  The caller must use all nextents extents, because we are not
- * flexible about this at all.
- */
-static struct xfs_efd_log_item *
-xfs_trans_get_efd(
-	struct xfs_trans		*tp,
-	struct xfs_efi_log_item		*efip,
-	unsigned int			nextents)
-{
-	struct xfs_efd_log_item		*efdp;
-
-	ASSERT(nextents > 0);
-
-	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
-		efdp = kzalloc(xfs_efd_log_item_sizeof(nextents),
-				GFP_KERNEL | __GFP_NOFAIL);
-	} else {
-		efdp = kmem_cache_zalloc(xfs_efd_cache,
-					GFP_KERNEL | __GFP_NOFAIL);
-	}
-
-	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
-			  &xfs_efd_item_ops);
-	efdp->efd_efip = efip;
-	efdp->efd_format.efd_nextents = nextents;
-	efdp->efd_format.efd_efi_id = efip->efi_format.efi_id;
-
-	return efdp;
-}
-
 /*
  * Fill the EFD with all extents from the EFI when we need to roll the
  * transaction and continue with a new EFI.
@@ -428,7 +396,26 @@ xfs_extent_free_create_done(
 	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return &xfs_trans_get_efd(tp, EFI_ITEM(intent), count)->efd_item;
+	struct xfs_efi_log_item		*efip = EFI_ITEM(intent);
+	struct xfs_efd_log_item		*efdp;
+
+	ASSERT(count > 0);
+
+	if (count > XFS_EFD_MAX_FAST_EXTENTS) {
+		efdp = kzalloc(xfs_efd_log_item_sizeof(count),
+				GFP_KERNEL | __GFP_NOFAIL);
+	} else {
+		efdp = kmem_cache_zalloc(xfs_efd_cache,
+					GFP_KERNEL | __GFP_NOFAIL);
+	}
+
+	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
+			  &xfs_efd_item_ops);
+	efdp->efd_efip = efip;
+	efdp->efd_format.efd_nextents = count;
+	efdp->efd_format.efd_efi_id = efip->efi_format.efi_id;
+
+	return &efdp->efd_item;
 }
 
 /* Take a passive ref to the AG containing the space we're freeing. */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index a66bb6aa2e5d..d218a9ed4d82 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -227,22 +227,6 @@ static const struct xfs_item_ops xfs_cud_item_ops = {
 	.iop_intent	= xfs_cud_item_intent,
 };
 
-static struct xfs_cud_log_item *
-xfs_trans_get_cud(
-	struct xfs_trans		*tp,
-	struct xfs_cui_log_item		*cuip)
-{
-	struct xfs_cud_log_item		*cudp;
-
-	cudp = kmem_cache_zalloc(xfs_cud_cache, GFP_KERNEL | __GFP_NOFAIL);
-	xfs_log_item_init(tp->t_mountp, &cudp->cud_item, XFS_LI_CUD,
-			  &xfs_cud_item_ops);
-	cudp->cud_cuip = cuip;
-	cudp->cud_format.cud_cui_id = cuip->cui_format.cui_id;
-
-	return cudp;
-}
-
 /* Sort refcount intents by AG. */
 static int
 xfs_refcount_update_diff_items(
@@ -328,7 +312,16 @@ xfs_refcount_update_create_done(
 	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return &xfs_trans_get_cud(tp, CUI_ITEM(intent))->cud_item;
+	struct xfs_cui_log_item		*cuip = CUI_ITEM(intent);
+	struct xfs_cud_log_item		*cudp;
+
+	cudp = kmem_cache_zalloc(xfs_cud_cache, GFP_KERNEL | __GFP_NOFAIL);
+	xfs_log_item_init(tp->t_mountp, &cudp->cud_item, XFS_LI_CUD,
+			  &xfs_cud_item_ops);
+	cudp->cud_cuip = cuip;
+	cudp->cud_format.cud_cui_id = cuip->cui_format.cui_id;
+
+	return &cudp->cud_item;
 }
 
 /* Take a passive ref to the AG containing the space we're refcounting. */
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index d668eb4d099e..96e0c2b0d059 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -225,22 +225,6 @@ static const struct xfs_item_ops xfs_rud_item_ops = {
 	.iop_intent	= xfs_rud_item_intent,
 };
 
-static struct xfs_rud_log_item *
-xfs_trans_get_rud(
-	struct xfs_trans		*tp,
-	struct xfs_rui_log_item		*ruip)
-{
-	struct xfs_rud_log_item		*rudp;
-
-	rudp = kmem_cache_zalloc(xfs_rud_cache, GFP_KERNEL | __GFP_NOFAIL);
-	xfs_log_item_init(tp->t_mountp, &rudp->rud_item, XFS_LI_RUD,
-			  &xfs_rud_item_ops);
-	rudp->rud_ruip = ruip;
-	rudp->rud_format.rud_rui_id = ruip->rui_format.rui_id;
-
-	return rudp;
-}
-
 /* Set the map extent flags for this reverse mapping. */
 static void
 xfs_trans_set_rmap_flags(
@@ -353,7 +337,16 @@ xfs_rmap_update_create_done(
 	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return &xfs_trans_get_rud(tp, RUI_ITEM(intent))->rud_item;
+	struct xfs_rui_log_item		*ruip = RUI_ITEM(intent);
+	struct xfs_rud_log_item		*rudp;
+
+	rudp = kmem_cache_zalloc(xfs_rud_cache, GFP_KERNEL | __GFP_NOFAIL);
+	xfs_log_item_init(tp->t_mountp, &rudp->rud_item, XFS_LI_RUD,
+			  &xfs_rud_item_ops);
+	rudp->rud_ruip = ruip;
+	rudp->rud_format.rud_rui_id = ruip->rui_format.rui_id;
+
+	return &rudp->rud_item;
 }
 
 /* Take a passive ref to the AG containing the space we're rmapping. */


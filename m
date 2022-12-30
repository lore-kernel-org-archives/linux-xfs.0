Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B2CC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbiL3WfD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbiL3WfC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:35:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799E51D0DF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:35:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1875661C18
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7533FC433EF;
        Fri, 30 Dec 2022 22:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439700;
        bh=/iEfogCwiod49VtSGNEwalMhLXlVv4tECKIs6jfWhCM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BniShdAvNMM42piBhmmZansyeQLDEeIU6Ts3vrMh1jaIhP80VyoftUIhr+isBxkXh
         /OZIgU3xvmk/klVFaYgMMIhv9NHZppWFN3hTaG9ekxWESKkOkKR9nWFxfmCx0P3doJ
         sNx1tWpoHslPJzjBHCKxLuOVZMZmv+LQdMKUV8eJYyuT/xliDRdgiEOOL1qwVuE4X7
         +Ks8nmH5W7r3WP/2mP2zoSrOiHwWUEd1oVCn/EBs8QjAxlXZ1QPGS7Y7t8wc8z0/ML
         jSEb/eN5qLkkPLWVRRChGFk8ntvQmMUm1YcVFAZaJHX3S7j/9H8tuGvGERUhOEcspZ
         dEsJKPYpAx+2Q==
Subject: [PATCH 8/8] xfs: fix confusing variable names in xfs_refcount_item.c
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:10:57 -0800
Message-ID: <167243825776.683219.6337997352543008973.stgit@magnolia>
In-Reply-To: <167243825653.683219.11053689306747459204.stgit@magnolia>
References: <167243825653.683219.11053689306747459204.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Variable names in this code module are inconsistent and confusing.
xfs_phys_extent describe physical mappings, so rename them "pmap".
xfs_refcount_intents describe refcount intents, so rename them "ri".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_refcount_item.c |   54 ++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index ff4d5087ba00..48d771a76add 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -292,16 +292,16 @@ xfs_refcount_update_diff_items(
 /* Set the phys extent flags for this reverse mapping. */
 static void
 xfs_trans_set_refcount_flags(
-	struct xfs_phys_extent		*refc,
+	struct xfs_phys_extent		*pmap,
 	enum xfs_refcount_intent_type	type)
 {
-	refc->pe_flags = 0;
+	pmap->pe_flags = 0;
 	switch (type) {
 	case XFS_REFCOUNT_INCREASE:
 	case XFS_REFCOUNT_DECREASE:
 	case XFS_REFCOUNT_ALLOC_COW:
 	case XFS_REFCOUNT_FREE_COW:
-		refc->pe_flags |= type;
+		pmap->pe_flags |= type;
 		break;
 	default:
 		ASSERT(0);
@@ -313,10 +313,10 @@ STATIC void
 xfs_refcount_update_log_item(
 	struct xfs_trans		*tp,
 	struct xfs_cui_log_item		*cuip,
-	struct xfs_refcount_intent	*refc)
+	struct xfs_refcount_intent	*ri)
 {
 	uint				next_extent;
-	struct xfs_phys_extent		*ext;
+	struct xfs_phys_extent		*pmap;
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
@@ -328,10 +328,10 @@ xfs_refcount_update_log_item(
 	 */
 	next_extent = atomic_inc_return(&cuip->cui_next_extent) - 1;
 	ASSERT(next_extent < cuip->cui_format.cui_nextents);
-	ext = &cuip->cui_format.cui_extents[next_extent];
-	ext->pe_startblock = refc->ri_startblock;
-	ext->pe_len = refc->ri_blockcount;
-	xfs_trans_set_refcount_flags(ext, refc->ri_type);
+	pmap = &cuip->cui_format.cui_extents[next_extent];
+	pmap->pe_startblock = ri->ri_startblock;
+	pmap->pe_len = ri->ri_blockcount;
+	xfs_trans_set_refcount_flags(pmap, ri->ri_type);
 }
 
 static struct xfs_log_item *
@@ -343,15 +343,15 @@ xfs_refcount_update_create_intent(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_cui_log_item		*cuip = xfs_cui_init(mp, count);
-	struct xfs_refcount_intent	*refc;
+	struct xfs_refcount_intent	*ri;
 
 	ASSERT(count > 0);
 
 	xfs_trans_add_item(tp, &cuip->cui_item);
 	if (sort)
 		list_sort(mp, items, xfs_refcount_update_diff_items);
-	list_for_each_entry(refc, items, ri_list)
-		xfs_refcount_update_log_item(tp, cuip, refc);
+	list_for_each_entry(ri, items, ri_list)
+		xfs_refcount_update_log_item(tp, cuip, ri);
 	return &cuip->cui_item;
 }
 
@@ -403,10 +403,10 @@ STATIC void
 xfs_refcount_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_refcount_intent	*refc;
+	struct xfs_refcount_intent	*ri;
 
-	refc = container_of(item, struct xfs_refcount_intent, ri_list);
-	kmem_cache_free(xfs_refcount_intent_cache, refc);
+	ri = container_of(item, struct xfs_refcount_intent, ri_list);
+	kmem_cache_free(xfs_refcount_intent_cache, ri);
 }
 
 const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
@@ -423,15 +423,15 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 static inline bool
 xfs_cui_validate_phys(
 	struct xfs_mount		*mp,
-	struct xfs_phys_extent		*refc)
+	struct xfs_phys_extent		*pmap)
 {
 	if (!xfs_has_reflink(mp))
 		return false;
 
-	if (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
+	if (pmap->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
 		return false;
 
-	switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
+	switch (pmap->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
 	case XFS_REFCOUNT_INCREASE:
 	case XFS_REFCOUNT_DECREASE:
 	case XFS_REFCOUNT_ALLOC_COW:
@@ -441,7 +441,7 @@ xfs_cui_validate_phys(
 		return false;
 	}
 
-	return xfs_verify_fsbext(mp, refc->pe_startblock, refc->pe_len);
+	return xfs_verify_fsbext(mp, pmap->pe_startblock, pmap->pe_len);
 }
 
 /*
@@ -499,10 +499,10 @@ xfs_cui_item_recover(
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
 		struct xfs_refcount_intent	fake = { };
-		struct xfs_phys_extent		*refc;
+		struct xfs_phys_extent		*pmap;
 
-		refc = &cuip->cui_format.cui_extents[i];
-		refc_type = refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK;
+		pmap = &cuip->cui_format.cui_extents[i];
+		refc_type = pmap->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK;
 		switch (refc_type) {
 		case XFS_REFCOUNT_INCREASE:
 		case XFS_REFCOUNT_DECREASE:
@@ -518,8 +518,8 @@ xfs_cui_item_recover(
 			goto abort_error;
 		}
 
-		fake.ri_startblock = refc->pe_startblock;
-		fake.ri_blockcount = refc->pe_len;
+		fake.ri_startblock = pmap->pe_startblock;
+		fake.ri_blockcount = pmap->pe_len;
 		if (!requeue_only)
 			error = xfs_trans_log_finish_refcount_update(tp, cudp,
 					&fake, &rcur);
@@ -586,18 +586,18 @@ xfs_cui_item_relog(
 {
 	struct xfs_cud_log_item		*cudp;
 	struct xfs_cui_log_item		*cuip;
-	struct xfs_phys_extent		*extp;
+	struct xfs_phys_extent		*pmap;
 	unsigned int			count;
 
 	count = CUI_ITEM(intent)->cui_format.cui_nextents;
-	extp = CUI_ITEM(intent)->cui_format.cui_extents;
+	pmap = CUI_ITEM(intent)->cui_format.cui_extents;
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	cudp = xfs_trans_get_cud(tp, CUI_ITEM(intent));
 	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
 
 	cuip = xfs_cui_init(tp->t_mountp, count);
-	memcpy(cuip->cui_format.cui_extents, extp, count * sizeof(*extp));
+	memcpy(cuip->cui_format.cui_extents, pmap, count * sizeof(*pmap));
 	atomic_set(&cuip->cui_next_extent, count);
 	xfs_trans_add_item(tp, &cuip->cui_item);
 	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);


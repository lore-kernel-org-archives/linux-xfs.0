Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB5FC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbiL3Wda (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235513AbiL3Wd2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:33:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A9D1C90C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:33:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5DA161C15
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F616C433D2;
        Fri, 30 Dec 2022 22:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439607;
        bh=chtIAUN7nFkkuiAIBWOJzrY6rQR2L8nav50gPiRyNPk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YpcWnsVkD29sfXAIdkbxfCOUPzdf5vBIq0ZjUhr1oRHR9saNPk9aNrvwgpVcXjkg5
         /JLcgYyguZsxjyYT1O1ZkNSL5Pwzduf4SqQXTJQxxFMRfhg6qDj1n6gamY0Mbt/V0H
         yD6lwa935jFM3xqAnOlJaYzyghQEBZIqoynngfvtklareTeQwgzvFQ8t/YCJNZO13b
         QxSCAGAxkl4h5u5go4EfnwhaXSgOD80FIkr6IwCuOTTNsfnl3AsU9rln66jqc5a54W
         XdhwAjEw8oEFDbpKGV6/lCV0zadyCsjEOgb3Stjf3Yp/yq5AXFdMpZOGqlygZpw6mX
         OIyw6lPTx7f5Q==
Subject: [PATCH 2/8] xfs: fix confusing variable names in xfs_bmap_item.c
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:10:56 -0800
Message-ID: <167243825691.683219.13117581459184772051.stgit@magnolia>
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
xfs_map_extent describe file mappings, so rename them "map".
xfs_bmap_intents describe block mapping intents, so rename them "bi".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_item.c |   56 ++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 13aa5359c02f..6e2f0013380a 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -283,24 +283,24 @@ xfs_bmap_update_diff_items(
 /* Set the map extent flags for this mapping. */
 static void
 xfs_trans_set_bmap_flags(
-	struct xfs_map_extent		*bmap,
+	struct xfs_map_extent		*map,
 	enum xfs_bmap_intent_type	type,
 	int				whichfork,
 	xfs_exntst_t			state)
 {
-	bmap->me_flags = 0;
+	map->me_flags = 0;
 	switch (type) {
 	case XFS_BMAP_MAP:
 	case XFS_BMAP_UNMAP:
-		bmap->me_flags = type;
+		map->me_flags = type;
 		break;
 	default:
 		ASSERT(0);
 	}
 	if (state == XFS_EXT_UNWRITTEN)
-		bmap->me_flags |= XFS_BMAP_EXTENT_UNWRITTEN;
+		map->me_flags |= XFS_BMAP_EXTENT_UNWRITTEN;
 	if (whichfork == XFS_ATTR_FORK)
-		bmap->me_flags |= XFS_BMAP_EXTENT_ATTR_FORK;
+		map->me_flags |= XFS_BMAP_EXTENT_ATTR_FORK;
 }
 
 /* Log bmap updates in the intent item. */
@@ -308,7 +308,7 @@ STATIC void
 xfs_bmap_update_log_item(
 	struct xfs_trans		*tp,
 	struct xfs_bui_log_item		*buip,
-	struct xfs_bmap_intent		*bmap)
+	struct xfs_bmap_intent		*bi)
 {
 	uint				next_extent;
 	struct xfs_map_extent		*map;
@@ -324,12 +324,12 @@ xfs_bmap_update_log_item(
 	next_extent = atomic_inc_return(&buip->bui_next_extent) - 1;
 	ASSERT(next_extent < buip->bui_format.bui_nextents);
 	map = &buip->bui_format.bui_extents[next_extent];
-	map->me_owner = bmap->bi_owner->i_ino;
-	map->me_startblock = bmap->bi_bmap.br_startblock;
-	map->me_startoff = bmap->bi_bmap.br_startoff;
-	map->me_len = bmap->bi_bmap.br_blockcount;
-	xfs_trans_set_bmap_flags(map, bmap->bi_type, bmap->bi_whichfork,
-			bmap->bi_bmap.br_state);
+	map->me_owner = bi->bi_owner->i_ino;
+	map->me_startblock = bi->bi_bmap.br_startblock;
+	map->me_startoff = bi->bi_bmap.br_startoff;
+	map->me_len = bi->bi_bmap.br_blockcount;
+	xfs_trans_set_bmap_flags(map, bi->bi_type, bi->bi_whichfork,
+			bi->bi_bmap.br_state);
 }
 
 static struct xfs_log_item *
@@ -341,15 +341,15 @@ xfs_bmap_update_create_intent(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_bui_log_item		*buip = xfs_bui_init(mp);
-	struct xfs_bmap_intent		*bmap;
+	struct xfs_bmap_intent		*bi;
 
 	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
 
 	xfs_trans_add_item(tp, &buip->bui_item);
 	if (sort)
 		list_sort(mp, items, xfs_bmap_update_diff_items);
-	list_for_each_entry(bmap, items, bi_list)
-		xfs_bmap_update_log_item(tp, buip, bmap);
+	list_for_each_entry(bi, items, bi_list)
+		xfs_bmap_update_log_item(tp, buip, bi);
 	return &buip->bui_item;
 }
 
@@ -398,10 +398,10 @@ STATIC void
 xfs_bmap_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_bmap_intent		*bmap;
+	struct xfs_bmap_intent		*bi;
 
-	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
-	kmem_cache_free(xfs_bmap_intent_cache, bmap);
+	bi = container_of(item, struct xfs_bmap_intent, bi_list);
+	kmem_cache_free(xfs_bmap_intent_cache, bi);
 }
 
 const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
@@ -419,18 +419,18 @@ xfs_bui_validate(
 	struct xfs_mount		*mp,
 	struct xfs_bui_log_item		*buip)
 {
-	struct xfs_map_extent		*bmap;
+	struct xfs_map_extent		*map;
 
 	/* Only one mapping operation per BUI... */
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
 		return false;
 
-	bmap = &buip->bui_format.bui_extents[0];
+	map = &buip->bui_format.bui_extents[0];
 
-	if (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)
+	if (map->me_flags & ~XFS_BMAP_EXTENT_FLAGS)
 		return false;
 
-	switch (bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
+	switch (map->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
 	case XFS_BMAP_MAP:
 	case XFS_BMAP_UNMAP:
 		break;
@@ -438,13 +438,13 @@ xfs_bui_validate(
 		return false;
 	}
 
-	if (!xfs_verify_ino(mp, bmap->me_owner))
+	if (!xfs_verify_ino(mp, map->me_owner))
 		return false;
 
-	if (!xfs_verify_fileext(mp, bmap->me_startoff, bmap->me_len))
+	if (!xfs_verify_fileext(mp, map->me_startoff, map->me_len))
 		return false;
 
-	return xfs_verify_fsbext(mp, bmap->me_startblock, bmap->me_len);
+	return xfs_verify_fsbext(mp, map->me_startblock, map->me_len);
 }
 
 /*
@@ -558,18 +558,18 @@ xfs_bui_item_relog(
 {
 	struct xfs_bud_log_item		*budp;
 	struct xfs_bui_log_item		*buip;
-	struct xfs_map_extent		*extp;
+	struct xfs_map_extent		*map;
 	unsigned int			count;
 
 	count = BUI_ITEM(intent)->bui_format.bui_nextents;
-	extp = BUI_ITEM(intent)->bui_format.bui_extents;
+	map = BUI_ITEM(intent)->bui_format.bui_extents;
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	budp = xfs_trans_get_bud(tp, BUI_ITEM(intent));
 	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
 
 	buip = xfs_bui_init(tp->t_mountp);
-	memcpy(buip->bui_format.bui_extents, extp, count * sizeof(*extp));
+	memcpy(buip->bui_format.bui_extents, map, count * sizeof(*map));
 	atomic_set(&buip->bui_next_extent, count);
 	xfs_trans_add_item(tp, &buip->bui_item);
 	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);


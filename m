Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 211C6C10F1B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbiL3Web (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiL3WeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:34:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD2F1D0DF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:34:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40CDCB81B91
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0A1C433D2;
        Fri, 30 Dec 2022 22:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439653;
        bh=ElX1dXKjXZl/I/k5YiqpNEmPgD7J0tZalrC2tFxWhvA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FkeF1G2cz6uE2g3qEkzKZOaKBnSv0hiocck9pjreipdyHNGm/PxCH/BjqZ7yTUYVv
         1Ej39EUkagHYOaFXawG1UHDp4MJqDV98At43y2FaTsR6dTLQGIdcreYlmgVL/zECcy
         GKgsykGTbRbYfCzrWPZO/j5VggXFBzVSr6fQ5I6CAHFg5puD/96VVSjD5/gKF262qo
         oNcIyjKpmz9TfIXrd6sitNZHOTugEBggvn4YIhVNHZoH9Lx8QNhX231Noq/QnD401m
         sUL6PX1mHuSibyGmaXMRDij66PjiweFDPXqaYrAHawCO23orVqrGvbBJEH2J+SduH9
         BA93ChDJ+0+6w==
Subject: [PATCH 5/8] xfs: pass rmap space mapping directly through the log
 intent code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:10:57 -0800
Message-ID: <167243825733.683219.16257622914330370193.stgit@magnolia>
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

Pass the incore rmap space mapping through the RUI logging code instead
of repeatedly boxing and unboxing parameters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |   52 ++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_rmap.h |    6 +---
 fs/xfs/xfs_rmap_item.c   |   65 +++++++++++++++++++++-------------------------
 3 files changed, 56 insertions(+), 67 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index b56aca1e7c66..df720041cd3d 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2390,13 +2390,7 @@ xfs_rmap_finish_one_cleanup(
 int
 xfs_rmap_finish_one(
 	struct xfs_trans		*tp,
-	enum xfs_rmap_intent_type	type,
-	uint64_t			owner,
-	int				whichfork,
-	xfs_fileoff_t			startoff,
-	xfs_fsblock_t			startblock,
-	xfs_filblks_t			blockcount,
-	xfs_exntst_t			state,
+	struct xfs_rmap_intent		*ri,
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
@@ -2408,11 +2402,13 @@ xfs_rmap_finish_one(
 	xfs_agblock_t			bno;
 	bool				unwritten;
 
-	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, startblock));
-	bno = XFS_FSB_TO_AGBNO(mp, startblock);
+	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ri->ri_bmap.br_startblock));
+	bno = XFS_FSB_TO_AGBNO(mp, ri->ri_bmap.br_startblock);
 
-	trace_xfs_rmap_deferred(mp, pag->pag_agno, type, bno, owner, whichfork,
-			startoff, blockcount, state);
+	trace_xfs_rmap_deferred(mp, pag->pag_agno, ri->ri_type, bno,
+			ri->ri_owner, ri->ri_whichfork,
+			ri->ri_bmap.br_startoff, ri->ri_bmap.br_blockcount,
+			ri->ri_bmap.br_state);
 
 	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RMAP_FINISH_ONE)) {
 		error = -EIO;
@@ -2448,36 +2444,38 @@ xfs_rmap_finish_one(
 	}
 	*pcur = rcur;
 
-	xfs_rmap_ino_owner(&oinfo, owner, whichfork, startoff);
-	unwritten = state == XFS_EXT_UNWRITTEN;
-	bno = XFS_FSB_TO_AGBNO(rcur->bc_mp, startblock);
+	xfs_rmap_ino_owner(&oinfo, ri->ri_owner, ri->ri_whichfork,
+			ri->ri_bmap.br_startoff);
+	unwritten = ri->ri_bmap.br_state == XFS_EXT_UNWRITTEN;
+	bno = XFS_FSB_TO_AGBNO(rcur->bc_mp, ri->ri_bmap.br_startblock);
 
-	switch (type) {
+	switch (ri->ri_type) {
 	case XFS_RMAP_ALLOC:
 	case XFS_RMAP_MAP:
-		error = xfs_rmap_map(rcur, bno, blockcount, unwritten, &oinfo);
+		error = xfs_rmap_map(rcur, bno, ri->ri_bmap.br_blockcount,
+				unwritten, &oinfo);
 		break;
 	case XFS_RMAP_MAP_SHARED:
-		error = xfs_rmap_map_shared(rcur, bno, blockcount, unwritten,
-				&oinfo);
+		error = xfs_rmap_map_shared(rcur, bno,
+				ri->ri_bmap.br_blockcount, unwritten, &oinfo);
 		break;
 	case XFS_RMAP_FREE:
 	case XFS_RMAP_UNMAP:
-		error = xfs_rmap_unmap(rcur, bno, blockcount, unwritten,
-				&oinfo);
+		error = xfs_rmap_unmap(rcur, bno, ri->ri_bmap.br_blockcount,
+				unwritten, &oinfo);
 		break;
 	case XFS_RMAP_UNMAP_SHARED:
-		error = xfs_rmap_unmap_shared(rcur, bno, blockcount, unwritten,
-				&oinfo);
+		error = xfs_rmap_unmap_shared(rcur, bno,
+				ri->ri_bmap.br_blockcount, unwritten, &oinfo);
 		break;
 	case XFS_RMAP_CONVERT:
-		error = xfs_rmap_convert(rcur, bno, blockcount, !unwritten,
-				&oinfo);
-		break;
-	case XFS_RMAP_CONVERT_SHARED:
-		error = xfs_rmap_convert_shared(rcur, bno, blockcount,
+		error = xfs_rmap_convert(rcur, bno, ri->ri_bmap.br_blockcount,
 				!unwritten, &oinfo);
 		break;
+	case XFS_RMAP_CONVERT_SHARED:
+		error = xfs_rmap_convert_shared(rcur, bno,
+				ri->ri_bmap.br_blockcount, !unwritten, &oinfo);
+		break;
 	default:
 		ASSERT(0);
 		error = -EFSCORRUPTED;
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 54741a591a17..2dac88cea28d 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -179,10 +179,8 @@ void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
 
 void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 		struct xfs_btree_cur *rcur, int error);
-int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
-		uint64_t owner, int whichfork, xfs_fileoff_t startoff,
-		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
-		xfs_exntst_t state, struct xfs_btree_cur **pcur);
+int xfs_rmap_finish_one(struct xfs_trans *tp, struct xfs_rmap_intent *ri,
+		struct xfs_btree_cur **pcur);
 
 int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 534504ede1a3..e46d040a9fc5 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -293,19 +293,12 @@ static int
 xfs_trans_log_finish_rmap_update(
 	struct xfs_trans		*tp,
 	struct xfs_rud_log_item		*rudp,
-	enum xfs_rmap_intent_type	type,
-	uint64_t			owner,
-	int				whichfork,
-	xfs_fileoff_t			startoff,
-	xfs_fsblock_t			startblock,
-	xfs_filblks_t			blockcount,
-	xfs_exntst_t			state,
+	struct xfs_rmap_intent		*ri,
 	struct xfs_btree_cur		**pcur)
 {
 	int				error;
 
-	error = xfs_rmap_finish_one(tp, type, owner, whichfork, startoff,
-			startblock, blockcount, state, pcur);
+	error = xfs_rmap_finish_one(tp, ri, pcur);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
@@ -409,10 +402,7 @@ xfs_rmap_update_finish_item(
 	int				error;
 
 	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
-	error = xfs_trans_log_finish_rmap_update(tp, RUD_ITEM(done),
-			rmap->ri_type, rmap->ri_owner, rmap->ri_whichfork,
-			rmap->ri_bmap.br_startoff, rmap->ri_bmap.br_startblock,
-			rmap->ri_bmap.br_blockcount, rmap->ri_bmap.br_state,
+	error = xfs_trans_log_finish_rmap_update(tp, RUD_ITEM(done), rmap,
 			state);
 	kmem_cache_free(xfs_rmap_intent_cache, rmap);
 	return error;
@@ -493,15 +483,11 @@ xfs_rui_item_recover(
 	struct list_head		*capture_list)
 {
 	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
-	struct xfs_map_extent		*rmap;
 	struct xfs_rud_log_item		*rudp;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
-	enum xfs_rmap_intent_type	type;
-	xfs_exntst_t			state;
 	int				i;
-	int				whichfork;
 	int				error = 0;
 
 	/*
@@ -526,35 +512,34 @@ xfs_rui_item_recover(
 	rudp = xfs_trans_get_rud(tp, ruip);
 
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
-		rmap = &ruip->rui_format.rui_extents[i];
-		state = (rmap->me_flags & XFS_RMAP_EXTENT_UNWRITTEN) ?
-				XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
-		whichfork = (rmap->me_flags & XFS_RMAP_EXTENT_ATTR_FORK) ?
-				XFS_ATTR_FORK : XFS_DATA_FORK;
-		switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
+		struct xfs_rmap_intent	fake = { };
+		struct xfs_map_extent	*map;
+
+		map = &ruip->rui_format.rui_extents[i];
+		switch (map->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
 		case XFS_RMAP_EXTENT_MAP:
-			type = XFS_RMAP_MAP;
+			fake.ri_type = XFS_RMAP_MAP;
 			break;
 		case XFS_RMAP_EXTENT_MAP_SHARED:
-			type = XFS_RMAP_MAP_SHARED;
+			fake.ri_type = XFS_RMAP_MAP_SHARED;
 			break;
 		case XFS_RMAP_EXTENT_UNMAP:
-			type = XFS_RMAP_UNMAP;
+			fake.ri_type = XFS_RMAP_UNMAP;
 			break;
 		case XFS_RMAP_EXTENT_UNMAP_SHARED:
-			type = XFS_RMAP_UNMAP_SHARED;
+			fake.ri_type = XFS_RMAP_UNMAP_SHARED;
 			break;
 		case XFS_RMAP_EXTENT_CONVERT:
-			type = XFS_RMAP_CONVERT;
+			fake.ri_type = XFS_RMAP_CONVERT;
 			break;
 		case XFS_RMAP_EXTENT_CONVERT_SHARED:
-			type = XFS_RMAP_CONVERT_SHARED;
+			fake.ri_type = XFS_RMAP_CONVERT_SHARED;
 			break;
 		case XFS_RMAP_EXTENT_ALLOC:
-			type = XFS_RMAP_ALLOC;
+			fake.ri_type = XFS_RMAP_ALLOC;
 			break;
 		case XFS_RMAP_EXTENT_FREE:
-			type = XFS_RMAP_FREE;
+			fake.ri_type = XFS_RMAP_FREE;
 			break;
 		default:
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
@@ -563,13 +548,21 @@ xfs_rui_item_recover(
 			error = -EFSCORRUPTED;
 			goto abort_error;
 		}
-		error = xfs_trans_log_finish_rmap_update(tp, rudp, type,
-				rmap->me_owner, whichfork,
-				rmap->me_startoff, rmap->me_startblock,
-				rmap->me_len, state, &rcur);
+
+		fake.ri_owner = map->me_owner;
+		fake.ri_whichfork = (map->me_flags & XFS_RMAP_EXTENT_ATTR_FORK) ?
+				XFS_ATTR_FORK : XFS_DATA_FORK;
+		fake.ri_bmap.br_startblock = map->me_startblock;
+		fake.ri_bmap.br_startoff = map->me_startoff;
+		fake.ri_bmap.br_blockcount = map->me_len;
+		fake.ri_bmap.br_state = (map->me_flags & XFS_RMAP_EXTENT_UNWRITTEN) ?
+				XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
+
+		error = xfs_trans_log_finish_rmap_update(tp, rudp, &fake,
+				&rcur);
 		if (error == -EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					rmap, sizeof(*rmap));
+					map, sizeof(*map));
 		if (error)
 			goto abort_error;
 


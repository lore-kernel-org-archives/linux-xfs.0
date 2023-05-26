Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436A6C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbjEZBNa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbjEZBN3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:13:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733F4198
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE3C264C28
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517F2C433EF;
        Fri, 26 May 2023 01:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063606;
        bh=bBbWbZYVikqz6ZzwB12zCBkkg5g2PuJSJoPD9dhKFbk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=tK2Ha7AWiWRSF6Z3ZiwOnO6VLy62ojfFGUeagTZfxLvpdgWtUEpqLnLdqmeby0uxM
         MIyaYZ9iEadBs4wwtYFC4QstOYgU67OijmLi2TuToJMvbrsJI14S7EjJNZRcDPX03H
         OCriio4Nq0JCPrG5saPZO7lEVSpd+V29U0lpb0MFvG3mivBkT7tT3J7sH96EpyeINM
         ieNqpuYURlp/eVNpDK4VZ3Nb6ZFHu//bll75GiqK7qosHXrO3ldm2ky9gvuz+2sPTr
         oF91bmDnzcQr3oSJyQmjPPxSifBf0j6lc634o35/aD64xI7/Awdfi1q+6N5nabX+UT
         2bg8Hl26eryuA==
Date:   Thu, 25 May 2023 18:13:25 -0700
Subject: [PATCH 1/2] xfs: support deferred bmap updates on the attr fork
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506064237.3734210.2972446071513029409.stgit@frogsfrogsfrogs>
In-Reply-To: <168506064221.3734210.16655685789262733930.stgit@frogsfrogsfrogs>
References: <168506064221.3734210.16655685789262733930.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The deferred bmap update log item has always supported the attr fork, so
plumb this in so that higher layers can access this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   47 +++++++++++++++++++---------------------------
 fs/xfs/libxfs/xfs_bmap.h |    4 ++--
 fs/xfs/xfs_bmap_item.c   |    3 ++-
 fs/xfs/xfs_bmap_util.c   |    8 ++++----
 fs/xfs/xfs_reflink.c     |    8 ++++----
 5 files changed, 31 insertions(+), 39 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8f07d6cd969f..f1715be091b3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6151,17 +6151,8 @@ xfs_bmap_split_extent(
 	return error;
 }
 
-/* Deferred mapping is only for real extents in the data fork. */
-static bool
-xfs_bmap_is_update_needed(
-	struct xfs_bmbt_irec	*bmap)
-{
-	return  bmap->br_startblock != HOLESTARTBLOCK &&
-		bmap->br_startblock != DELAYSTARTBLOCK;
-}
-
 /* Record a bmap intent. */
-static int
+static void
 __xfs_bmap_add(
 	struct xfs_trans		*tp,
 	enum xfs_bmap_intent_type	type,
@@ -6171,6 +6162,11 @@ __xfs_bmap_add(
 {
 	struct xfs_bmap_intent		*bi;
 
+	if ((whichfork != XFS_DATA_FORK && whichfork != XFS_ATTR_FORK) ||
+	    bmap->br_startblock == HOLESTARTBLOCK ||
+	    bmap->br_startblock == DELAYSTARTBLOCK)
+		return;
+
 	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&bi->bi_list);
 	bi->bi_type = type;
@@ -6182,7 +6178,6 @@ __xfs_bmap_add(
 
 	xfs_bmap_update_get_group(tp->t_mountp, bi);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_BMAP, &bi->bi_list);
-	return 0;
 }
 
 /* Map an extent into a file. */
@@ -6190,12 +6185,10 @@ void
 xfs_bmap_map_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
+	int			whichfork,
 	struct xfs_bmbt_irec	*PREV)
 {
-	if (!xfs_bmap_is_update_needed(PREV))
-		return;
-
-	__xfs_bmap_add(tp, XFS_BMAP_MAP, ip, XFS_DATA_FORK, PREV);
+	__xfs_bmap_add(tp, XFS_BMAP_MAP, ip, whichfork, PREV);
 }
 
 /* Unmap an extent out of a file. */
@@ -6203,12 +6196,10 @@ void
 xfs_bmap_unmap_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
+	int			whichfork,
 	struct xfs_bmbt_irec	*PREV)
 {
-	if (!xfs_bmap_is_update_needed(PREV))
-		return;
-
-	__xfs_bmap_add(tp, XFS_BMAP_UNMAP, ip, XFS_DATA_FORK, PREV);
+	__xfs_bmap_add(tp, XFS_BMAP_UNMAP, ip, whichfork, PREV);
 }
 
 /*
@@ -6222,29 +6213,29 @@ xfs_bmap_finish_one(
 {
 	struct xfs_bmbt_irec		*bmap = &bi->bi_bmap;
 	int				error = 0;
+	int				flags = 0;
+
+	if (bi->bi_whichfork == XFS_ATTR_FORK)
+		flags |= XFS_BMAPI_ATTRFORK;
 
 	ASSERT(tp->t_highest_agno == NULLAGNUMBER);
 
 	trace_xfs_bmap_deferred(bi);
 
-	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK)) {
-		xfs_bmap_mark_sick(bi->bi_owner, bi->bi_whichfork);
-		return -EFSCORRUPTED;
-	}
-
-	if (XFS_TEST_ERROR(false, tp->t_mountp,
-			XFS_ERRTAG_BMAP_FINISH_ONE))
+	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_BMAP_FINISH_ONE))
 		return -EIO;
 
 	switch (bi->bi_type) {
 	case XFS_BMAP_MAP:
 		error = xfs_bmapi_remap(tp, bi->bi_owner, bmap->br_startoff,
-				bmap->br_blockcount, bmap->br_startblock, 0);
+				bmap->br_blockcount, bmap->br_startblock,
+				flags);
 		bmap->br_blockcount = 0;
 		break;
 	case XFS_BMAP_UNMAP:
 		error = __xfs_bunmapi(tp, bi->bi_owner, bmap->br_startoff,
-				&bmap->br_blockcount, XFS_BMAPI_REMAP, 1);
+				&bmap->br_blockcount, flags | XFS_BMAPI_REMAP,
+				1);
 		break;
 	default:
 		ASSERT(0);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 9477f4eeb87d..e35ddc9c0412 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -251,9 +251,9 @@ void xfs_bmap_update_get_group(struct xfs_mount *mp,
 
 int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
 void	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
-		struct xfs_bmbt_irec *imap);
+		int whichfork, struct xfs_bmbt_irec *imap);
 void	xfs_bmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
-		struct xfs_bmbt_irec *imap);
+		int whichfork, struct xfs_bmbt_irec *imap);
 
 static inline uint32_t xfs_bmap_fork_to_state(int whichfork)
 {
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e32abaa03635..9f88473e082e 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -558,7 +558,8 @@ xfs_bui_item_recover(
 
 	if (fake.bi_bmap.br_blockcount > 0) {
 		ASSERT(fake.bi_type == XFS_BMAP_UNMAP);
-		xfs_bmap_unmap_extent(tp, ip, &fake.bi_bmap);
+		xfs_bmap_unmap_extent(tp, fake.bi_owner, fake.bi_whichfork,
+				&fake.bi_bmap);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index a847dbd76537..4790f35341e0 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1454,16 +1454,16 @@ xfs_swap_extent_rmap(
 			}
 
 			/* Remove the mapping from the donor file. */
-			xfs_bmap_unmap_extent(tp, tip, &uirec);
+			xfs_bmap_unmap_extent(tp, tip, XFS_DATA_FORK, &uirec);
 
 			/* Remove the mapping from the source file. */
-			xfs_bmap_unmap_extent(tp, ip, &irec);
+			xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &irec);
 
 			/* Map the donor file's blocks into the source file. */
-			xfs_bmap_map_extent(tp, ip, &uirec);
+			xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &uirec);
 
 			/* Map the source file's blocks into the donor file. */
-			xfs_bmap_map_extent(tp, tip, &irec);
+			xfs_bmap_map_extent(tp, tip, XFS_DATA_FORK, &irec);
 
 			error = xfs_defer_finish(tpp);
 			tp = *tpp;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 381847db46f4..2653c964bd13 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -802,7 +802,7 @@ xfs_reflink_end_cow_extent(
 		 * If the extent we're remapping is backed by storage (written
 		 * or not), unmap the extent and drop its refcount.
 		 */
-		xfs_bmap_unmap_extent(tp, ip, &data);
+		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &data);
 		xfs_refcount_decrease_extent(tp, &data);
 		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
 				-data.br_blockcount);
@@ -826,7 +826,7 @@ xfs_reflink_end_cow_extent(
 	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
 
 	/* Map the new blocks into the data fork. */
-	xfs_bmap_map_extent(tp, ip, &del);
+	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &del);
 
 	/* Charge this new data fork mapping to the on-disk quota. */
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
@@ -1290,7 +1290,7 @@ xfs_reflink_remap_extent(
 		 * If the extent we're unmapping is backed by storage (written
 		 * or not), unmap the extent and drop its refcount.
 		 */
-		xfs_bmap_unmap_extent(tp, ip, &smap);
+		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &smap);
 		xfs_refcount_decrease_extent(tp, &smap);
 		qdelta -= smap.br_blockcount;
 	} else if (smap.br_startblock == DELAYSTARTBLOCK) {
@@ -1315,7 +1315,7 @@ xfs_reflink_remap_extent(
 	 */
 	if (dmap_written) {
 		xfs_refcount_increase_extent(tp, dmap);
-		xfs_bmap_map_extent(tp, ip, dmap);
+		xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, dmap);
 		qdelta += dmap->br_blockcount;
 	}
 


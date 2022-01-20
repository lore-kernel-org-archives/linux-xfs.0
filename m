Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A16FC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345277AbiATAY7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:24:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48090 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240515AbiATAY7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:24:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84141B81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B46C004E1;
        Thu, 20 Jan 2022 00:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638297;
        bh=EMj89fi/HYAbB1a1XycIhdoMTlxAOozypzEsdxNhYqY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qEgn+7DH+PqfcD360/h8fHitcg6ZgaB7CqVGBK3E2yT85VMqmDQlf4AIJJUcQ3Hgw
         Uls0KwENPco7LsNehZnq4SoLseAzxzOcY/+6TawtFEo9JjnN3MmoTBOIRCz8V5chbp
         0Z0KF8y/roklfW+H4lfSdm1u2WWk+gRpvt9TsY5uD20JbUiHhOGEoqadOZaSCvBw3a
         zmZ6kBVnjZUUC2KthmQmVRZAKPwz3EU7o7x9vvh8EdlPtv/mAGlHRY73FMcWa7TzIV
         U1+BqvWzO7ptGV7LhG0XWw2QD2vF9aBy5UYGS2goD/9IXUOWTHLrZlGdtQcSawvDIu
         GVpEpuGgdq3CA==
Subject: [PATCH 19/48] xfs: dynamically allocate cursors based on maxlevels
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:24:56 -0800
Message-ID: <164263829684.865554.3242016081675260913.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: c940a0c54a2e9333478f1d87ed40006a04fcec7e

To support future btree code, we need to be able to size btree cursors
dynamically for very large btrees.  Switch the maxlevels computation to
use the precomputed values in the superblock, and create cursors that
can handle a certain height.  For now, we retain the btree cursor cache
that can handle up to 9-level btrees, though a subsequent patch
introduces separate caches for each btree type, where each cache's
objects will be exactly tall enough to handle the specific btree type.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |    2 +-
 libxfs/xfs_bmap_btree.c     |    3 ++-
 libxfs/xfs_btree.h          |   13 +++++++++++--
 libxfs/xfs_ialloc_btree.c   |    3 ++-
 libxfs/xfs_refcount_btree.c |    3 ++-
 libxfs/xfs_rmap_btree.c     |    3 ++-
 6 files changed, 20 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 7d7618c5..c1030ad1 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -475,7 +475,7 @@ xfs_allocbt_init_common(
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum);
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_ag_maxlevels);
 	cur->bc_ag.abt.active = false;
 
 	if (btnum == XFS_BTNUM_CNT) {
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index c4b34cdd..9e2263ed 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -550,7 +550,8 @@ xfs_bmbt_init_cursor(
 	struct xfs_btree_cur	*cur;
 	ASSERT(whichfork != XFS_COW_FORK);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP);
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP,
+			mp->m_bm_maxlevels[whichfork]);
 	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index ed0b7d5a..b46cd983 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -94,6 +94,12 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
 
 #define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
 
+/*
+ * The btree cursor zone hands out cursors that can handle up to this many
+ * levels.  This is the known maximum for all btree types.
+ */
+#define XFS_BTREE_CUR_CACHE_MAXLEVELS	(9)
+
 struct xfs_btree_ops {
 	/* size of the key and record structures */
 	size_t	key_len;
@@ -583,15 +589,18 @@ static inline struct xfs_btree_cur *
 xfs_btree_alloc_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_btnum_t		btnum)
+	xfs_btnum_t		btnum,
+	uint8_t			maxlevels)
 {
 	struct xfs_btree_cur	*cur;
 
+	ASSERT(maxlevels <= XFS_BTREE_CUR_CACHE_MAXLEVELS);
+
 	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
-	cur->bc_maxlevels = XFS_BTREE_MAXLEVELS;
+	cur->bc_maxlevels = maxlevels;
 
 	return cur;
 }
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 87a54c07..be0918b7 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -431,7 +431,8 @@ xfs_inobt_init_common(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum);
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum,
+			M_IGEO(mp)->inobt_maxlevels);
 	if (btnum == XFS_BTNUM_INO) {
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
 		cur->bc_ops = &xfs_inobt_ops;
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 55e68613..6a716924 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -321,7 +321,8 @@ xfs_refcountbt_init_common(
 
 	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC);
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC,
+			mp->m_refc_maxlevels);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index f6339a31..4c281b71 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -450,7 +450,8 @@ xfs_rmapbt_init_common(
 	struct xfs_btree_cur	*cur;
 
 	/* Overlapping btree; 2 keys per pointer. */
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP);
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP,
+			mp->m_rmap_maxlevels);
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_ops = &xfs_rmapbt_ops;


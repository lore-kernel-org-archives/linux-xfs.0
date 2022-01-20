Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25ABDC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345275AbiATAYr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:24:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60824 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344572AbiATAYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:24:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C832B61506
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6E3C004E1;
        Thu, 20 Jan 2022 00:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638286;
        bh=6QfY6klBepPl3Qx04+4w0wAf6pAR+f02LardHwhiQNU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Is166EEBrqnh1DvyMHQXXX3cSqg7tR9m2xNQQutG9eGW1auzQp6pThRZDTbqa48vw
         KRJfvoIJZvWEeWAFxIs+xDslIMP6VZiQejXDrdZe1o+S7DOI2hhai29WG+xd2HxwwT
         Ewg34mpSwJMhfUJOTi0efXM5J3ETArIZdb6pS5ADTY3pNm5LxdDpefpzHuPCq9oo0U
         s589C9n/iePZTQZtHFKWJXLla59iOo43mjoSgm/0bTHuwmqzJxLAiXFM7n6syKHyUA
         Tr3Y8tqW3+QB12lJXAyXz/O4uoO+cncG5yxk0PH90QnLhemJJUurX027nF+KQ/NmgJ
         gQbHTG6ujcbxw==
Subject: [PATCH 17/48] xfs: refactor btree cursor allocation function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:24:45 -0800
Message-ID: <164263828587.865554.1463161547751567961.stgit@magnolia>
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

Source kernel commit: 56370ea6e5fe3e3d6e1ca2da58f95fb0d5e1779f

Refactor btree allocation to a common helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |    6 +-----
 libxfs/xfs_bmap_btree.c     |    6 +-----
 libxfs/xfs_btree.h          |   16 ++++++++++++++++
 libxfs/xfs_ialloc_btree.c   |    5 +----
 libxfs/xfs_refcount_btree.c |    5 +----
 libxfs/xfs_rmap_btree.c     |    5 +----
 6 files changed, 21 insertions(+), 22 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 46d0f229..7d7618c5 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -475,11 +475,7 @@ xfs_allocbt_init_common(
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
-	cur->bc_btnum = btnum;
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum);
 	cur->bc_ag.abt.active = false;
 
 	if (btnum == XFS_BTNUM_CNT) {
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 565e8af7..c4b34cdd 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -550,12 +550,8 @@ xfs_bmbt_init_cursor(
 	struct xfs_btree_cur	*cur;
 	ASSERT(whichfork != XFS_COW_FORK);
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP);
 	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
-	cur->bc_btnum = XFS_BTNUM_BMAP;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
 	cur->bc_ops = &xfs_bmbt_ops;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index eaffd822..8e78ede8 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -578,4 +578,20 @@ void xfs_btree_copy_keys(struct xfs_btree_cur *cur,
 		union xfs_btree_key *dst_key,
 		const union xfs_btree_key *src_key, int numkeys);
 
+static inline struct xfs_btree_cur *
+xfs_btree_alloc_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_btnum = btnum;
+
+	return cur;
+}
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index f1e03cfd..87a54c07 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -431,10 +431,7 @@ xfs_inobt_init_common(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
-	cur->bc_btnum = btnum;
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum);
 	if (btnum == XFS_BTNUM_INO) {
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
 		cur->bc_ops = &xfs_inobt_ops;
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index f7f99cbd..55e68613 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -321,10 +321,7 @@ xfs_refcountbt_init_common(
 
 	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
-	cur->bc_btnum = XFS_BTNUM_REFC;
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index bba29eea..f6339a31 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -449,11 +449,8 @@ xfs_rmapbt_init_common(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
 	/* Overlapping btree; 2 keys per pointer. */
-	cur->bc_btnum = XFS_BTNUM_RMAP;
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP);
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_ops = &xfs_rmapbt_ops;


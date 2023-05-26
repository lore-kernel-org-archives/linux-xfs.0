Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 715A3C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbjEZBIR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbjEZBIQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:08:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614EC9B
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:08:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA83F64B7B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A4BC433D2;
        Fri, 26 May 2023 01:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063294;
        bh=Fst228ClBbmCAdzyiG8iNa8WrXa8P+Xe8iMCYCI1rsg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=epAAIoZ0Zgn3OYm04SvhuUaUh7N+b6Ub5ouyeNGKHZVL+spKtGc72scxk3KEUBx+r
         nL1ko3uJXx438Rem+1vZTp86+zWr21cwswVtaBoLhWm5GBTQBCCrgpQLuySTG7XmdG
         3LdDkBrgej+n/YVrR0B62EcH5BcfNcVCdYfqjBddeLpV4vzcEkjOY7QXhtfnzYPwki
         ZwEZ4O8zk9FoQVzmDAA6Ze8OUyDGyqHHS0YYGaB1zcBd1+HPAHo0AyY0liG8i0w4IF
         R2o9njoM9vhvhakA70YsDta8Ruk2qAIuf/hRhYJZoMyBQiKTtHKbS5Gcaf7q3UVQZQ
         Ic7BZbVzBIV9A==
Date:   Thu, 25 May 2023 18:08:13 -0700
Subject: [PATCH 1/9] xfs: set the btree cursor bc_ops in
 xfs_btree_alloc_cursor
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506062693.3733506.7369181618399889020.stgit@frogsfrogsfrogs>
In-Reply-To: <168506062668.3733506.5702088548886151666.stgit@frogsfrogsfrogs>
References: <168506062668.3733506.5702088548886151666.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a precursor to putting more static data in the btree ops structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |   11 +++++------
 fs/xfs/libxfs/xfs_bmap_btree.c     |    3 +--
 fs/xfs/libxfs/xfs_btree.h          |    2 ++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   10 ++++++----
 fs/xfs/libxfs/xfs_refcount_btree.c |    4 ++--
 fs/xfs/libxfs/xfs_rmap_btree.c     |    7 +++----
 fs/xfs/scrub/xfbtree.c             |    4 ++--
 7 files changed, 21 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 90c7cb8c54ab..ec832e8291de 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -512,18 +512,17 @@ xfs_allocbt_init_common(
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_alloc_maxlevels,
-			xfs_allocbt_cur_cache);
-	cur->bc_ag.abt.active = false;
-
 	if (btnum == XFS_BTNUM_CNT) {
-		cur->bc_ops = &xfs_cntbt_ops;
+		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_cntbt_ops,
+				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
 		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
 	} else {
-		cur->bc_ops = &xfs_bnobt_ops;
+		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_bnobt_ops,
+				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
 	}
+	cur->bc_ag.abt.active = false;
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 36a024102d06..f5e9b56870b4 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -548,11 +548,10 @@ xfs_bmbt_init_common(
 
 	ASSERT(whichfork != XFS_COW_FORK);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP,
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP, &xfs_bmbt_ops,
 			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
-	cur->bc_ops = &xfs_bmbt_ops;
 	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
 	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index a1e7fb0e5806..92a938a7a30e 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -737,12 +737,14 @@ xfs_btree_alloc_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_btnum_t		btnum,
+	const struct xfs_btree_ops *ops,
 	uint8_t			maxlevels,
 	struct kmem_cache	*cache)
 {
 	struct xfs_btree_cur	*cur;
 
 	cur = kmem_cache_zalloc(cache, GFP_NOFS | __GFP_NOFAIL);
+	cur->bc_ops = ops;
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 5a945ae21b5d..3b37e231425b 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -455,14 +455,16 @@ xfs_inobt_init_common(
 	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum,
-			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
 	if (btnum == XFS_BTNUM_INO) {
+		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_inobt_ops,
+				M_IGEO(mp)->inobt_maxlevels,
+				xfs_inobt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
-		cur->bc_ops = &xfs_inobt_ops;
 	} else {
+		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_finobt_ops,
+				M_IGEO(mp)->inobt_maxlevels,
+				xfs_inobt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
-		cur->bc_ops = &xfs_finobt_ops;
 	}
 
 	if (xfs_has_crc(mp))
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index c5b99f1322ba..dfda80bdcfcb 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -359,7 +359,8 @@ xfs_refcountbt_init_common(
 	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
 
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC,
-			mp->m_refc_maxlevels, xfs_refcountbt_cur_cache);
+			&xfs_refcountbt_ops, mp->m_refc_maxlevels,
+			xfs_refcountbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
@@ -367,7 +368,6 @@ xfs_refcountbt_init_common(
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
-	cur->bc_ops = &xfs_refcountbt_ops;
 	return cur;
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index d8b21b01f4b2..0bef2883e55b 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -517,11 +517,10 @@ xfs_rmapbt_init_common(
 	struct xfs_btree_cur	*cur;
 
 	/* Overlapping btree; 2 keys per pointer. */
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP,
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
-	cur->bc_ops = &xfs_rmapbt_ops;
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	return cur;
@@ -646,11 +645,11 @@ xfs_rmapbt_mem_cursor(
 
 	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP,
-			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
+			&xfs_rmapbt_mem_ops, mp->m_rmap_maxlevels,
+			xfs_rmapbt_cur_cache);
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
 			XFS_BTREE_IN_XFILE;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
-	cur->bc_ops = &xfs_rmapbt_mem_ops;
 	cur->bc_mem.xfbtree = xfbtree;
 	cur->bc_mem.head_bp = head_bp;
 	cur->bc_nlevels = xfs_btree_mem_head_nlevels(head_bp);
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index 5cd03457091c..bfd8ff8872a5 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -258,11 +258,11 @@ xfbtree_dup_cursor(
 	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
 
 	ncur = xfs_btree_alloc_cursor(cur->bc_mp, cur->bc_tp, cur->bc_btnum,
-			cur->bc_maxlevels, cur->bc_cache);
+			cur->bc_ops, cur->bc_maxlevels, cur->bc_cache);
 	ncur->bc_flags = cur->bc_flags;
 	ncur->bc_nlevels = cur->bc_nlevels;
 	ncur->bc_statoff = cur->bc_statoff;
-	ncur->bc_ops = cur->bc_ops;
+
 	memcpy(&ncur->bc_mem, &cur->bc_mem, sizeof(cur->bc_mem));
 
 	if (cur->bc_mem.pag)


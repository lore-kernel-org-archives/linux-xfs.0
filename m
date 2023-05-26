Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A94C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjEZBId (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjEZBIc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:08:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6D1194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CDAD611A7
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065CEC433EF;
        Fri, 26 May 2023 01:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063310;
        bh=+MlyNvV7fJjN64g0Q08ySzNXrEwJcAKJUqdoJ1Q1L/E=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=g/y31axFLVLQI9LZukTVmlUXQ15wdnATeMlKwhkd+3g+7HdAThh9NKHLDSUvZs87q
         PUvSFeSs1fVkgw+kw+GM/u2TJf8Nx5V3Zn7aKHPpHt+hLH+f8nvoLNsXkZxZmLoVQ3
         //93H71cELt2T8C9TjjjomcfCIVFJEoJ42jM3Q8fyJ2OdAwV5n3kbGw0QwMeLNhJmb
         aYj9WJf3dRm5EBGJJpEvoJoOKGu171hQkql8DxfdLg9xBc57ONRrug7GkDVhyYMEJs
         b4UDzArGETcA2yJzoVA4yEWvzHVJ/JusMt7fAzYV1UihnXlDn/Ma7F45ZKd7I0Wssy
         lfm0oVqLYbiRA==
Date:   Thu, 25 May 2023 18:08:29 -0700
Subject: [PATCH 2/9] xfs: encode the default bc_flags in the btree ops
 structure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506062708.3733506.6407671689012516128.stgit@frogsfrogsfrogs>
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

Certain btree flags never change for the life of a btree cursor because
they describe the geometry of the btree itself.  Encode these in the
btree ops structure and reduce the amount of code required in each btree
type's init_cursor functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    8 ++------
 fs/xfs/libxfs/xfs_bmap_btree.c     |    5 +----
 fs/xfs/libxfs/xfs_btree.h          |    6 ++++++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    3 ---
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 --
 fs/xfs/libxfs/xfs_rmap_btree.c     |    6 +++---
 6 files changed, 12 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index ec832e8291de..f65736a237b0 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -480,6 +480,7 @@ static const struct xfs_btree_ops xfs_bnobt_ops = {
 static const struct xfs_btree_ops xfs_cntbt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
+	.geom_flags		= XFS_BTREE_LASTREC_UPDATE,
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
@@ -516,19 +517,14 @@ xfs_allocbt_init_common(
 		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_cntbt_ops,
 				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
-		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
 	} else {
 		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_bnobt_ops,
 				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
 	}
-	cur->bc_ag.abt.active = false;
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
-
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
+	cur->bc_ag.abt.active = false;
 	return cur;
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index f5e9b56870b4..22b1a6d32a7e 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -514,6 +514,7 @@ xfs_bmbt_keys_contiguous(
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
+	.geom_flags		= XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE,
 
 	.dup_cursor		= xfs_bmbt_dup_cursor,
 	.update_cursor		= xfs_bmbt_update_cursor,
@@ -552,10 +553,6 @@ xfs_bmbt_init_common(
 			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
-	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.allocated = 0;
 	cur->bc_ino.flags = 0;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 92a938a7a30e..8bda5c76f013 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -116,6 +116,9 @@ struct xfs_btree_ops {
 	size_t	key_len;
 	size_t	rec_len;
 
+	/* XFS_BTREE_* flags that determine the geometry of the btree */
+	unsigned int	geom_flags;
+
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
 	void	(*update_cursor)(struct xfs_btree_cur *src,
@@ -750,6 +753,9 @@ xfs_btree_alloc_cursor(
 	cur->bc_btnum = btnum;
 	cur->bc_maxlevels = maxlevels;
 	cur->bc_cache = cache;
+	cur->bc_flags = ops->geom_flags;
+	if (xfs_has_crc(mp))
+		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	return cur;
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 3b37e231425b..6e20f0aa4936 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -467,9 +467,6 @@ xfs_inobt_init_common(
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
 	}
 
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	return cur;
 }
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index dfda80bdcfcb..565583cd4927 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -363,8 +363,6 @@ xfs_refcountbt_init_common(
 			xfs_refcountbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
-	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 0bef2883e55b..a158a1f6985b 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -489,6 +489,7 @@ xfs_rmapbt_keys_contiguous(
 static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING,
 
 	.dup_cursor		= xfs_rmapbt_dup_cursor,
 	.set_root		= xfs_rmapbt_set_root,
@@ -519,7 +520,6 @@ xfs_rmapbt_init_common(
 	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
-	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
@@ -613,6 +613,8 @@ static const struct xfs_buf_ops xfs_rmapbt_mem_buf_ops = {
 static const struct xfs_btree_ops xfs_rmapbt_mem_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
+				  XFS_BTREE_IN_XFILE,
 
 	.dup_cursor		= xfbtree_dup_cursor,
 	.set_root		= xfbtree_set_root,
@@ -647,8 +649,6 @@ xfs_rmapbt_mem_cursor(
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP,
 			&xfs_rmapbt_mem_ops, mp->m_rmap_maxlevels,
 			xfs_rmapbt_cur_cache);
-	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
-			XFS_BTREE_IN_XFILE;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_mem.xfbtree = xfbtree;
 	cur->bc_mem.head_bp = head_bp;


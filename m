Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98623C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbiLaAOX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235713AbiLaAOU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:14:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38D1B4A8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:14:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 472F861B98
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F426C433D2;
        Sat, 31 Dec 2022 00:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445657;
        bh=CTGq0NSIVKZ5T6UvryZ+AiLTN3Mg2F7aLDRCwF70NzQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c0YewBlwmZoswosf5n6GYgjF0SWm8c/c3/j6WiNzVHd+KKKn0TNAbQVhXWLK1xXCu
         ljJYVjda2ezXj+asbOZlSBUJ5/dd3MSQckNcm+0k38tedm74xkVj6ZVyTLdfyLNw2U
         CxT3ZzImNTHeu3IXn0H5l5MQ6ibIsUlWpVptlVFN7Xu7Wl9nqBJwLR81ugzenYKXvn
         duSG+NpuG/JAZwAdyL9+Hv0fsTAS+QD9ITzqlsJCYF962VWwRnLT275P2EtaSwEQRm
         qs8Zs+gX+WD1AIx3Te3c03SomoLcdq9oDiEm0AVMtP2EVGZyqrsXy2qRZ4nbn2+/gY
         p4Mx2O2sDLCpQ==
Subject: [PATCH 3/5] xfs: create a shadow rmap btree during rmap repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:46 -0800
Message-ID: <167243866603.712315.13137022395278148512.stgit@magnolia>
In-Reply-To: <167243866562.712315.18184440339100962213.stgit@magnolia>
References: <167243866562.712315.18184440339100962213.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create an in-memory btree of rmap records instead of an array.  This
enables us to do live record collection instead of freezing the fs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap.c       |   25 +++++-----
 libxfs/xfs_rmap_btree.c |  123 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap_btree.h |    9 +++
 3 files changed, 146 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 18d9dd480b0..bbc3546eead 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -273,6 +273,8 @@ xfs_rmap_check_irec(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*irec)
 {
+	if (cur->bc_flags & XFS_BTREE_IN_MEMORY)
+		return xfs_rmap_check_perag_irec(cur->bc_mem.pag, irec);
 	return xfs_rmap_check_perag_irec(cur->bc_ag.pag, irec);
 }
 
@@ -284,9 +286,13 @@ xfs_rmap_complain_bad_rec(
 {
 	struct xfs_mount		*mp = cur->bc_mp;
 
-	xfs_warn(mp,
-		"Reverse Mapping BTree record corruption in AG %d detected at %pS!",
-		cur->bc_ag.pag->pag_agno, fa);
+	if (cur->bc_flags & XFS_BTREE_IN_MEMORY)
+		xfs_warn(mp,
+ "In-Memory Reverse Mapping BTree record corruption detected at %pS!", fa);
+	else
+		xfs_warn(mp,
+ "Reverse Mapping BTree record corruption in AG %d detected at %pS!",
+			cur->bc_ag.pag->pag_agno, fa);
 	xfs_warn(mp,
 		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
@@ -2411,15 +2417,12 @@ xfs_rmap_map_raw(
 {
 	struct xfs_owner_info	oinfo;
 
-	oinfo.oi_owner = rmap->rm_owner;
-	oinfo.oi_offset = rmap->rm_offset;
-	oinfo.oi_flags = 0;
-	if (rmap->rm_flags & XFS_RMAP_ATTR_FORK)
-		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
-	if (rmap->rm_flags & XFS_RMAP_BMBT_BLOCK)
-		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
+	xfs_owner_info_pack(&oinfo, rmap->rm_owner, rmap->rm_offset,
+			rmap->rm_flags);
 
-	if (rmap->rm_flags || XFS_RMAP_NON_INODE_OWNER(rmap->rm_owner))
+	if ((rmap->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			       XFS_RMAP_UNWRITTEN)) ||
+	    XFS_RMAP_NON_INODE_OWNER(rmap->rm_owner))
 		return xfs_rmap_map(cur, rmap->rm_startblock,
 				rmap->rm_blockcount,
 				rmap->rm_flags & XFS_RMAP_UNWRITTEN,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 574f2dda5c0..0b10f81d30e 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -19,6 +19,9 @@
 #include "xfs_trace.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
+#include "xfile.h"
+#include "xfbtree.h"
+#include "xfs_btree_mem.h"
 
 static struct kmem_cache	*xfs_rmapbt_cur_cache;
 
@@ -553,6 +556,126 @@ xfs_rmapbt_stage_cursor(
 	return cur;
 }
 
+#ifdef CONFIG_XFS_IN_MEMORY_BTREE
+/*
+ * Validate an in-memory rmap btree block.  Callers are allowed to generate an
+ * in-memory btree even if the ondisk feature is not enabled.
+ */
+static xfs_failaddr_t
+xfs_rmapbt_mem_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_failaddr_t		fa;
+	unsigned int		level;
+
+	if (!xfs_verify_magic(bp, block->bb_magic))
+		return __this_address;
+
+	fa = xfs_btree_sblock_v5hdr_verify(bp);
+	if (fa)
+		return fa;
+
+	level = be16_to_cpu(block->bb_level);
+	if (xfs_has_rmapbt(mp)) {
+		if (level >= mp->m_rmap_maxlevels)
+			return __this_address;
+	} else {
+		if (level >= xfs_rmapbt_maxlevels_ondisk())
+			return __this_address;
+	}
+
+	return xfbtree_sblock_verify(bp,
+			xfs_rmapbt_maxrecs(xfo_to_b(1), level == 0));
+}
+
+static void
+xfs_rmapbt_mem_rw_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa = xfs_rmapbt_mem_verify(bp);
+
+	if (fa)
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+}
+
+/* skip crc checks on in-memory btrees to save time */
+static const struct xfs_buf_ops xfs_rmapbt_mem_buf_ops = {
+	.name			= "xfs_rmapbt_mem",
+	.magic			= { 0, cpu_to_be32(XFS_RMAP_CRC_MAGIC) },
+	.verify_read		= xfs_rmapbt_mem_rw_verify,
+	.verify_write		= xfs_rmapbt_mem_rw_verify,
+	.verify_struct		= xfs_rmapbt_mem_verify,
+};
+
+static const struct xfs_btree_ops xfs_rmapbt_mem_ops = {
+	.rec_len		= sizeof(struct xfs_rmap_rec),
+	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+
+	.dup_cursor		= xfbtree_dup_cursor,
+	.set_root		= xfbtree_set_root,
+	.alloc_block		= xfbtree_alloc_block,
+	.free_block		= xfbtree_free_block,
+	.get_minrecs		= xfbtree_get_minrecs,
+	.get_maxrecs		= xfbtree_get_maxrecs,
+	.init_key_from_rec	= xfs_rmapbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_rmapbt_init_high_key_from_rec,
+	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
+	.key_diff		= xfs_rmapbt_key_diff,
+	.buf_ops		= &xfs_rmapbt_mem_buf_ops,
+	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
+	.keys_inorder		= xfs_rmapbt_keys_inorder,
+	.recs_inorder		= xfs_rmapbt_recs_inorder,
+	.keys_contiguous	= xfs_rmapbt_keys_contiguous,
+};
+
+/* Create a cursor for an in-memory btree. */
+struct xfs_btree_cur *
+xfs_rmapbt_mem_cursor(
+	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*head_bp,
+	struct xfbtree		*xfbtree)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	/* Overlapping btree; 2 keys per pointer. */
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP,
+			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
+	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
+			XFS_BTREE_IN_MEMORY;
+	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
+	cur->bc_ops = &xfs_rmapbt_mem_ops;
+	cur->bc_mem.xfbtree = xfbtree;
+	cur->bc_mem.head_bp = head_bp;
+	cur->bc_nlevels = xfs_btree_mem_head_nlevels(head_bp);
+
+	cur->bc_mem.pag = xfs_perag_bump(pag);
+	return cur;
+}
+
+/* Create an in-memory rmap btree. */
+int
+xfs_rmapbt_mem_create(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_buftarg	*target,
+	struct xfbtree		**xfbtreep)
+{
+	struct xfbtree_config	cfg = {
+		.btree_ops	= &xfs_rmapbt_mem_ops,
+		.target		= target,
+		.btnum		= XFS_BTNUM_RMAP,
+		.owner		= agno,
+	};
+
+	return xfbtree_create(mp, &cfg, xfbtreep);
+}
+#endif /* CONFIG_XFS_IN_MEMORY_BTREE */
+
 /*
  * Install a new reverse mapping btree root.  Caller is responsible for
  * invalidating and freeing the old btree blocks.
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index 3244715dd11..a27a236111d 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -64,4 +64,13 @@ unsigned int xfs_rmapbt_maxlevels_ondisk(void);
 int __init xfs_rmapbt_init_cur_cache(void);
 void xfs_rmapbt_destroy_cur_cache(void);
 
+#ifdef CONFIG_XFS_IN_MEMORY_BTREE
+struct xfbtree;
+struct xfs_btree_cur *xfs_rmapbt_mem_cursor(struct xfs_perag *pag,
+		struct xfs_trans *tp, struct xfs_buf *head_bp,
+		struct xfbtree *xfbtree);
+int xfs_rmapbt_mem_create(struct xfs_mount *mp, xfs_agnumber_t agno,
+		struct xfs_buftarg *target, struct xfbtree **xfbtreep);
+#endif /* CONFIG_XFS_IN_MEMORY_BTREE */
+
 #endif /* __XFS_RMAP_BTREE_H__ */


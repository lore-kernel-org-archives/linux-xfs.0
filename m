Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BA8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiLaCrO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiLaCrL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:47:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34DA19039
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:47:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8007261D17
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D4BC433D2;
        Sat, 31 Dec 2022 02:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454829;
        bh=Fd9xRN+9R18zN47BGEUhUtWxqQsIY4ePk4XxJIqQ9U4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Kn2cQFV1klhPvJ5EpuWa8LN35Roityr88zzbRTQvxkiesXncdZXM5wCC7Bc1OKC6b
         42NlIxko3BMsHAGD/g0wMQoAAX6Wr0/guaY4RR4ipegD0cPn55ajfiJti1YVqZVUvf
         khEH0BhvWPVv3Mvtn+ZmL9X6B+W3ggazsCT09USYM/ThQZZayDckwOZD/YkyrhQXct
         LVmUTjZssdmjSOYZMs/3r6PqbSNoZNieLFx26D9Pe/DHShJ9UXF2K5TchxQe1apQX0
         tHYA9Ic7dNDKbIJmPMcS5UYWO98ZnMhrdgkeqA5oIAK/XaLnz0Yxc2q6zumocTzFVr
         q/6mnuFl0gIJg==
Subject: [PATCH 18/41] xfs: create a shadow rmap btree during realtime rmap
 repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:58 -0800
Message-ID: <167243879832.732820.13580514002754799355.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
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
 libxfs/xfbtree.c          |    2 +
 libxfs/xfs_btree.c        |    2 +
 libxfs/xfs_btree.h        |    1 
 libxfs/xfs_rmap.c         |    6 ++
 libxfs/xfs_rtrmap_btree.c |  122 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |    9 +++
 6 files changed, 141 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfbtree.c b/libxfs/xfbtree.c
index 6a2ef7cbe64..21a8ab46683 100644
--- a/libxfs/xfbtree.c
+++ b/libxfs/xfbtree.c
@@ -253,6 +253,8 @@ xfbtree_dup_cursor(
 
 	if (cur->bc_mem.pag)
 		ncur->bc_mem.pag = xfs_perag_bump(cur->bc_mem.pag);
+	if (cur->bc_mem.rtg)
+		ncur->bc_mem.rtg = xfs_rtgroup_bump(cur->bc_mem.rtg);
 
 	return ncur;
 }
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index a89a05555b8..49f6ce3661e 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -487,6 +487,8 @@ xfs_btree_del_cursor(
 	if (cur->bc_flags & XFS_BTREE_IN_MEMORY) {
 		if (cur->bc_mem.pag)
 			xfs_perag_put(cur->bc_mem.pag);
+		if (cur->bc_mem.rtg)
+			xfs_rtgroup_put(cur->bc_mem.rtg);
 	}
 	kmem_cache_free(cur->bc_cache, cur);
 }
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 9f7b6fc5439..1d8656ca112 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -266,6 +266,7 @@ struct xfs_btree_cur_mem {
 	struct xfbtree			*xfbtree;
 	struct xfs_buf			*head_bp;
 	struct xfs_perag		*pag;
+	struct xfs_rtgroup		*rtg;
 };
 
 struct xfs_btree_level {
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 967a095c45d..5c118eb98b4 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -327,8 +327,12 @@ xfs_rmap_check_irec(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*irec)
 {
-	if (cur->bc_btnum == XFS_BTNUM_RTRMAP)
+	if (cur->bc_btnum == XFS_BTNUM_RTRMAP) {
+		if (cur->bc_flags & XFS_BTREE_IN_MEMORY)
+			return xfs_rmap_check_rtgroup_irec(cur->bc_mem.rtg,
+					irec);
 		return xfs_rmap_check_rtgroup_irec(cur->bc_ino.rtg, irec);
+	}
 
 	if (cur->bc_flags & XFS_BTREE_IN_MEMORY)
 		return xfs_rmap_check_perag_irec(cur->bc_mem.pag, irec);
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 05258472592..ea5b3db3b32 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -26,6 +26,9 @@
 #include "xfs_bmap.h"
 #include "xfs_imeta.h"
 #include "xfs_health.h"
+#include "xfile.h"
+#include "xfbtree.h"
+#include "xfs_btree_mem.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -554,6 +557,125 @@ xfs_rtrmapbt_stage_cursor(
 	return cur;
 }
 
+#ifdef CONFIG_XFS_IN_MEMORY_BTREE
+/*
+ * Validate an in-memory realtime rmap btree block.  Callers are allowed to
+ * generate an in-memory btree even if the ondisk feature is not enabled.
+ */
+static xfs_failaddr_t
+xfs_rtrmapbt_mem_verify(
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
+	fa = xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+	if (fa)
+		return fa;
+
+	level = be16_to_cpu(block->bb_level);
+	if (xfs_has_rmapbt(mp)) {
+		if (level >= mp->m_rtrmap_maxlevels)
+			return __this_address;
+	} else {
+		if (level >= xfs_rtrmapbt_maxlevels_ondisk())
+			return __this_address;
+	}
+
+	return xfbtree_lblock_verify(bp,
+			xfs_rtrmapbt_maxrecs(mp, xfo_to_b(1), level == 0));
+}
+
+static void
+xfs_rtrmapbt_mem_rw_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa = xfs_rtrmapbt_mem_verify(bp);
+
+	if (fa)
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+}
+
+/* skip crc checks on in-memory btrees to save time */
+static const struct xfs_buf_ops xfs_rtrmapbt_mem_buf_ops = {
+	.name			= "xfs_rtrmapbt_mem",
+	.magic			= { 0, cpu_to_be32(XFS_RTRMAP_CRC_MAGIC) },
+	.verify_read		= xfs_rtrmapbt_mem_rw_verify,
+	.verify_write		= xfs_rtrmapbt_mem_rw_verify,
+	.verify_struct		= xfs_rtrmapbt_mem_verify,
+};
+
+static const struct xfs_btree_ops xfs_rtrmapbt_mem_ops = {
+	.rec_len		= sizeof(struct xfs_rmap_rec),
+	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
+				  XFS_BTREE_LONG_PTRS | XFS_BTREE_IN_MEMORY,
+
+	.dup_cursor		= xfbtree_dup_cursor,
+	.set_root		= xfbtree_set_root,
+	.alloc_block		= xfbtree_alloc_block,
+	.free_block		= xfbtree_free_block,
+	.get_minrecs		= xfbtree_get_minrecs,
+	.get_maxrecs		= xfbtree_get_maxrecs,
+	.init_key_from_rec	= xfs_rtrmapbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
+	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
+	.key_diff		= xfs_rtrmapbt_key_diff,
+	.buf_ops		= &xfs_rtrmapbt_mem_buf_ops,
+	.diff_two_keys		= xfs_rtrmapbt_diff_two_keys,
+	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
+	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
+	.keys_contiguous	= xfs_rtrmapbt_keys_contiguous,
+};
+
+/* Create a cursor for an in-memory btree. */
+struct xfs_btree_cur *
+xfs_rtrmapbt_mem_cursor(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*head_bp,
+	struct xfbtree		*xfbtree)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_mount	*mp = rtg->rtg_mount;
+
+	/* Overlapping btree; 2 keys per pointer. */
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RTRMAP,
+			&xfs_rtrmapbt_mem_ops, mp->m_rtrmap_maxlevels,
+			xfs_rtrmapbt_cur_cache);
+	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
+	cur->bc_mem.xfbtree = xfbtree;
+	cur->bc_mem.head_bp = head_bp;
+	cur->bc_nlevels = xfs_btree_mem_head_nlevels(head_bp);
+
+	cur->bc_mem.rtg = xfs_rtgroup_bump(rtg);
+	return cur;
+}
+
+int
+xfs_rtrmapbt_mem_create(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	struct xfs_buftarg	*target,
+	struct xfbtree		**xfbtreep)
+{
+	struct xfbtree_config	cfg = {
+		.btree_ops	= &xfs_rtrmapbt_mem_ops,
+		.target		= target,
+		.flags		= XFBTREE_DIRECT_MAP,
+		.owner		= rgno,
+	};
+
+	return xfbtree_create(mp, &cfg, xfbtreep);
+}
+#endif /* CONFIG_XFS_IN_MEMORY_BTREE */
+
 /*
  * Install a new rt reverse mapping btree root.  Caller is responsible for
  * invalidating and freeing the old btree blocks.
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index 1f0a6f9620e..ff60a2ca945 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -206,4 +206,13 @@ int xfs_rtrmapbt_create(struct xfs_trans **tpp, struct xfs_imeta_path *path,
 unsigned long long xfs_rtrmapbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
+#ifdef CONFIG_XFS_IN_MEMORY_BTREE
+struct xfbtree;
+struct xfs_btree_cur *xfs_rtrmapbt_mem_cursor(struct xfs_rtgroup *rtg,
+		struct xfs_trans *tp, struct xfs_buf *mhead_bp,
+		struct xfbtree *xfbtree);
+int xfs_rtrmapbt_mem_create(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		struct xfs_buftarg *target, struct xfbtree **xfbtreep);
+#endif /* CONFIG_XFS_IN_MEMORY_BTREE */
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EC2391
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CPv8fDyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6440DC433C8;
	Mon,  1 Jan 2024 00:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068144;
	bh=6HOyrIiqJVi1YN2u54I/xTg+MRxGHhy8nOHyelfD5xs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CPv8fDyrBA8QO1QETFMcczAdoT1Gub20c1NAqcbJ7ALun+6ksLcnkmci0cThq8tIi
	 ESoFLij0RmW36r+7t9mCOQW39GD3FK2Pj6jUdgX2rbsCQaasByjAKT8JS8dYcIQ07v
	 meqaqzh1a1SejPrf8vVqLAFkXs1Ct6GxQkdmhndAK5vgIJZcP34K3pJEiWexEbasxv
	 mKR2oIZMZVCNTvD4CZ2rSlD2fXqROG24LwdwLco9GYowe/275n57gtg3zomDV92whJ
	 N9uZttfqFczg0gU8C2K1SlG6UfZvmCBGrti+UOt7FzMtTWVh6jg1di0YhJwxe0lF/s
	 gZzOxxrkdqfGw==
Date: Sun, 31 Dec 2023 16:15:43 +9900
Subject: [PATCH 20/47] xfs: create a shadow rmap btree during realtime rmap
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015579.1815505.16054821915026842707.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create an in-memory btree of rmap records instead of an array.  This
enables us to do live record collection instead of freezing the fs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfbtree.c          |    2 +
 libxfs/xfs_btree.c        |    2 +
 libxfs/xfs_btree.h        |    1 
 libxfs/xfs_rmap.c         |    5 +-
 libxfs/xfs_rtrmap_btree.c |  123 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |    9 +++
 6 files changed, 141 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfbtree.c b/libxfs/xfbtree.c
index b4762393b3a..cdc37561a62 100644
--- a/libxfs/xfbtree.c
+++ b/libxfs/xfbtree.c
@@ -253,6 +253,8 @@ xfbtree_dup_cursor(
 
 	if (cur->bc_mem.pag)
 		ncur->bc_mem.pag = xfs_perag_hold(cur->bc_mem.pag);
+	if (cur->bc_mem.rtg)
+		ncur->bc_mem.rtg = xfs_rtgroup_hold(cur->bc_mem.rtg);
 
 	return ncur;
 }
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index f599dd17d30..450c48ceaf1 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -487,6 +487,8 @@ xfs_btree_del_cursor(
 	if (cur->bc_flags & XFS_BTREE_IN_XFILE) {
 		if (cur->bc_mem.pag)
 			xfs_perag_put(cur->bc_mem.pag);
+		if (cur->bc_mem.rtg)
+			xfs_rtgroup_put(cur->bc_mem.rtg);
 	}
 	kmem_cache_free(cur->bc_cache, cur);
 }
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 3559cf5d3a6..4753a5c8476 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -269,6 +269,7 @@ struct xfs_btree_cur_mem {
 	struct xfbtree			*xfbtree;
 	struct xfs_buf			*head_bp;
 	struct xfs_perag		*pag;
+	struct xfs_rtgroup		*rtg;
 };
 
 struct xfs_btree_level {
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index cf2968cbd7f..42713dd17f4 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -328,8 +328,11 @@ xfs_rmap_check_btrec(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*irec)
 {
-	if (cur->bc_btnum == XFS_BTNUM_RTRMAP)
+	if (cur->bc_btnum == XFS_BTNUM_RTRMAP) {
+		if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+			return xfs_rtrmap_check_irec(cur->bc_mem.rtg, irec);
 		return xfs_rtrmap_check_irec(cur->bc_ino.rtg, irec);
+	}
 
 	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
 		return xfs_rmap_check_irec(cur->bc_mem.pag, irec);
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 0393da8837a..b5adfe362a7 100644
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
 
@@ -555,6 +558,126 @@ xfs_rtrmapbt_stage_cursor(
 	return cur;
 }
 
+#ifdef CONFIG_XFS_BTREE_IN_XFILE
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
+	.lru_refs		= XFS_RMAP_BTREE_REF,
+	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
+				  XFS_BTREE_LONG_PTRS | XFS_BTREE_IN_XFILE,
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
+	cur->bc_mem.rtg = xfs_rtgroup_hold(rtg);
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
+#endif /* CONFIG_XFS_BTREE_IN_XFILE */
+
 /*
  * Install a new rt reverse mapping btree root.  Caller is responsible for
  * invalidating and freeing the old btree blocks.
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index 5aec719be05..b0a8e8d89f9 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -205,4 +205,13 @@ int xfs_rtrmapbt_create(struct xfs_imeta_update *upd, struct xfs_inode **ipp);
 unsigned long long xfs_rtrmapbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
+#ifdef CONFIG_XFS_BTREE_IN_XFILE
+struct xfbtree;
+struct xfs_btree_cur *xfs_rtrmapbt_mem_cursor(struct xfs_rtgroup *rtg,
+		struct xfs_trans *tp, struct xfs_buf *mhead_bp,
+		struct xfbtree *xfbtree);
+int xfs_rtrmapbt_mem_create(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		struct xfs_buftarg *target, struct xfbtree **xfbtreep);
+#endif /* CONFIG_XFS_BTREE_IN_XFILE */
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */


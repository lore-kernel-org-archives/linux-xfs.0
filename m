Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D9621353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425240; cv=none; b=XuA5zhvbp7UXwJhgJCEE7DBTD+KuAd36506bhY9cMJ4rMCcJuLIPhE+6Nm0E6HZJOnkdOzsUbGXK6HbZ9zo4/gr5CDR7iwk70TjBpSTWy5F+KaBbwyNhZv1eBa0bJ1ZrR7jquhKC5nTD02MTkqSzO2GexsnxW9EDxe9gmPCsF8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425240; c=relaxed/simple;
	bh=ZF6OIO4ccxqyE78ooFWSr+MpSNi1N5y0TsoGE1lK0x0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tLSAP+8rH9dLxwPy8IdGne1fuv2MwFJFFQNe8ZFZ/a+imdty4vxxLcLxbZN1l6DId8Zt1LGPP7hR2zZ4COdjvLOU0rY741BD1PpHP6Lty1pmuRH9xW0gfGrmY9gz6I0Fq9pCW8zkBohpMQwrMVM/QRRnFL3KjV1roRdRy0nMmD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ss9kz4CC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ss9kz4CC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39155C433F1;
	Tue, 26 Mar 2024 03:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425240;
	bh=ZF6OIO4ccxqyE78ooFWSr+MpSNi1N5y0TsoGE1lK0x0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ss9kz4CCkcnaOC1+Lajwi/B36vvbqNkudpEN9o764sywrE5dErh4bkMkl7hQQtOUg
	 93Iteg7ysSfkWO+gvKgNeGzvNtocwWoWyuOxlu6ynFdwTz00lvX2K04NZqVWp+iXEw
	 i8jTfmL+94yc+8Evx8DQIlRpyVmz9zbzJ+qPpeq/3j9Zz2bKaPtRy8xw33C3sjr7N/
	 8Mi2iJWRZjnlaFJ47917uz8onJ3B32y2cnK3AD+e4foRTDuqmScRi4pBCtq67pVAmQ
	 XSauX97RQRVC8VhhGmC8+B7ICZJ99VayVWKw0V889djItNd7igikxTEFee21Tmg7hu
	 QjVdDWZ4ZyBCg==
Date: Mon, 25 Mar 2024 20:53:59 -0700
Subject: [PATCH 098/110] xfs: create a shadow rmap btree during rmap repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132791.2215168.16141839696808530556.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4787fc802752c9b73b28ff18860c0560bf4337f2

Create an in-memory btree of rmap records instead of an array.  This
enables us to do live record collection instead of freezing the fs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rmap.c       |   37 +++++++-----
 libxfs/xfs_rmap_btree.c |  151 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap_btree.h |    6 ++
 libxfs/xfs_shared.h     |   10 +++
 4 files changed, 190 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index a0b4280fe584..a7be2aa92c0a 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -268,6 +268,16 @@ xfs_rmap_check_irec(
 	return NULL;
 }
 
+static inline xfs_failaddr_t
+xfs_rmap_check_btrec(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*irec)
+{
+	if (xfs_btree_is_mem_rmap(cur->bc_ops))
+		return xfs_rmap_check_irec(cur->bc_mem.pag, irec);
+	return xfs_rmap_check_irec(cur->bc_ag.pag, irec);
+}
+
 static inline int
 xfs_rmap_complain_bad_rec(
 	struct xfs_btree_cur		*cur,
@@ -276,9 +286,13 @@ xfs_rmap_complain_bad_rec(
 {
 	struct xfs_mount		*mp = cur->bc_mp;
 
-	xfs_warn(mp,
-		"Reverse Mapping BTree record corruption in AG %d detected at %pS!",
-		cur->bc_ag.pag->pag_agno, fa);
+	if (xfs_btree_is_mem_rmap(cur->bc_ops))
+		xfs_warn(mp,
+ "In-Memory Reverse Mapping BTree record corruption detected at %pS!", fa);
+	else
+		xfs_warn(mp,
+ "Reverse Mapping BTree record corruption in AG %d detected at %pS!",
+			cur->bc_ag.pag->pag_agno, fa);
 	xfs_warn(mp,
 		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
@@ -306,7 +320,7 @@ xfs_rmap_get_rec(
 
 	fa = xfs_rmap_btrec_to_irec(rec, irec);
 	if (!fa)
-		fa = xfs_rmap_check_irec(cur->bc_ag.pag, irec);
+		fa = xfs_rmap_check_btrec(cur, irec);
 	if (fa)
 		return xfs_rmap_complain_bad_rec(cur, fa, irec);
 
@@ -2403,15 +2417,12 @@ xfs_rmap_map_raw(
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
@@ -2441,7 +2452,7 @@ xfs_rmap_query_range_helper(
 
 	fa = xfs_rmap_btrec_to_irec(rec, &irec);
 	if (!fa)
-		fa = xfs_rmap_check_irec(cur->bc_ag.pag, &irec);
+		fa = xfs_rmap_check_btrec(cur, &irec);
 	if (fa)
 		return xfs_rmap_complain_bad_rec(cur, fa, &irec);
 
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 956cdc2fd596..a2730e29c8a1 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -20,6 +20,9 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_health.h"
+#include "xfile.h"
+#include "buf_mem.h"
+#include "xfs_btree_mem.h"
 
 static struct kmem_cache	*xfs_rmapbt_cur_cache;
 
@@ -539,6 +542,151 @@ xfs_rmapbt_init_cursor(
 	return cur;
 }
 
+#ifdef CONFIG_XFS_BTREE_IN_MEM
+static inline unsigned int
+xfs_rmapbt_mem_block_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	if (leaf)
+		return blocklen / sizeof(struct xfs_rmap_rec);
+	return blocklen /
+		(2 * sizeof(struct xfs_rmap_key) + sizeof(__be64));
+}
+
+/*
+ * Validate an in-memory rmap btree block.  Callers are allowed to generate an
+ * in-memory btree even if the ondisk feature is not enabled.
+ */
+static xfs_failaddr_t
+xfs_rmapbt_mem_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_failaddr_t		fa;
+	unsigned int		level;
+	unsigned int		maxrecs;
+
+	if (!xfs_verify_magic(bp, block->bb_magic))
+		return __this_address;
+
+	fa = xfs_btree_fsblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+	if (fa)
+		return fa;
+
+	level = be16_to_cpu(block->bb_level);
+	if (level >= xfs_rmapbt_maxlevels_ondisk())
+		return __this_address;
+
+	maxrecs = xfs_rmapbt_mem_block_maxrecs(
+			XFBNO_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN, level == 0);
+	return xfs_btree_memblock_verify(bp, maxrecs);
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
+const struct xfs_btree_ops xfs_rmapbt_mem_ops = {
+	.name			= "mem_rmap",
+	.type			= XFS_BTREE_TYPE_MEM,
+	.geom_flags		= XFS_BTGEO_OVERLAPPING,
+
+	.rec_len		= sizeof(struct xfs_rmap_rec),
+	/* Overlapping btree; 2 keys per pointer. */
+	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.ptr_len		= XFS_BTREE_LONG_PTR_LEN,
+
+	.lru_refs		= XFS_RMAP_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_rmap_mem_2),
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
+	struct xfbtree		*xfbt)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rmapbt_mem_ops,
+			xfs_rmapbt_maxlevels_ondisk(), xfs_rmapbt_cur_cache);
+	cur->bc_mem.xfbtree = xfbt;
+	cur->bc_nlevels = xfbt->nlevels;
+
+	cur->bc_mem.pag = xfs_perag_hold(pag);
+	return cur;
+}
+
+/* Create an in-memory rmap btree. */
+int
+xfs_rmapbt_mem_init(
+	struct xfs_mount	*mp,
+	struct xfbtree		*xfbt,
+	struct xfs_buftarg	*btp,
+	xfs_agnumber_t		agno)
+{
+	xfbt->owner = agno;
+	return xfbtree_init(mp, xfbt, btp, &xfs_rmapbt_mem_ops);
+}
+
+/* Compute the max possible height for reverse mapping btrees in memory. */
+static unsigned int
+xfs_rmapbt_mem_maxlevels(void)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = XFBNO_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
+
+	minrecs[0] = xfs_rmapbt_mem_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = xfs_rmapbt_mem_block_maxrecs(blocklen, false) / 2;
+
+	/*
+	 * How tall can an in-memory rmap btree become if we filled the entire
+	 * AG with rmap records?
+	 */
+	return xfs_btree_compute_maxlevels(minrecs,
+			XFS_MAX_AG_BYTES / sizeof(struct xfs_rmap_rec));
+}
+#else
+# define xfs_rmapbt_mem_maxlevels()	(0)
+#endif /* CONFIG_XFS_BTREE_IN_MEM */
+
 /*
  * Install a new reverse mapping btree root.  Caller is responsible for
  * invalidating and freeing the old btree blocks.
@@ -609,7 +757,8 @@ xfs_rmapbt_maxlevels_ondisk(void)
 	 * like if it consumes almost all the blocks in the AG due to maximal
 	 * sharing factor.
 	 */
-	return xfs_btree_space_to_height(minrecs, XFS_MAX_CRC_AG_BLOCKS);
+	return max(xfs_btree_space_to_height(minrecs, XFS_MAX_CRC_AG_BLOCKS),
+		   xfs_rmapbt_mem_maxlevels());
 }
 
 /* Compute the maximum height of an rmap btree. */
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index 27536d7e14aa..eb90d89e8086 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -10,6 +10,7 @@ struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
 struct xbtree_afakeroot;
+struct xfbtree;
 
 /* rmaps only exist on crc enabled filesystems */
 #define XFS_RMAP_BLOCK_LEN	XFS_BTREE_SBLOCK_CRC_LEN
@@ -62,4 +63,9 @@ unsigned int xfs_rmapbt_maxlevels_ondisk(void);
 int __init xfs_rmapbt_init_cur_cache(void);
 void xfs_rmapbt_destroy_cur_cache(void);
 
+struct xfs_btree_cur *xfs_rmapbt_mem_cursor(struct xfs_perag *pag,
+		struct xfs_trans *tp, struct xfbtree *xfbtree);
+int xfs_rmapbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
+		struct xfs_buftarg *btp, xfs_agnumber_t agno);
+
 #endif /* __XFS_RMAP_BTREE_H__ */
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 6b8bc276d461..cab49e7116ec 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -51,6 +51,7 @@ extern const struct xfs_btree_ops xfs_finobt_ops;
 extern const struct xfs_btree_ops xfs_bmbt_ops;
 extern const struct xfs_btree_ops xfs_refcountbt_ops;
 extern const struct xfs_btree_ops xfs_rmapbt_ops;
+extern const struct xfs_btree_ops xfs_rmapbt_mem_ops;
 
 static inline bool xfs_btree_is_bno(const struct xfs_btree_ops *ops)
 {
@@ -87,6 +88,15 @@ static inline bool xfs_btree_is_rmap(const struct xfs_btree_ops *ops)
 	return ops == &xfs_rmapbt_ops;
 }
 
+#ifdef CONFIG_XFS_BTREE_IN_MEM
+static inline bool xfs_btree_is_mem_rmap(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_rmapbt_mem_ops;
+}
+#else
+# define xfs_btree_is_mem_rmap(...)	(false)
+#endif
+
 /* log size calculation functions */
 int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
 int	xfs_log_calc_minimum_size(struct xfs_mount *);


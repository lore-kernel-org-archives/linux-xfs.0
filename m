Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0112F757E5
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346847; cv=none; b=cRtz5fHvtTK17ah6Z7lIZuzKZ1I+OVOyCFtKZXuO5nHLzKlr5TIejvJsRaPwNjcTx1YqQRytfuBTc4NKf6ZP3AD3ipSgF9QFu6yWzUvn3qvThu6dBvKILKiOTSaxhlbfUl8mZrsIX/w1RXkZja6vU3LWzKMSaig34TytO+t64N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346847; c=relaxed/simple;
	bh=8fG5CcV+QLFU+QwYedg1rtq5A6yoK783QyO60Z3rj4g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EzlkdS5i2U9Vm3Kx+pIrnJssQXaX+utV91yzhvFgPBHpvBl0ZVGWEruOnbZnz6Vk7c+r363V2q54yQkscAZ+m3FXIz9ikp4edgL2wubXprYQ48v9Z0Lx/y9ehI0Fm/L+V53FP6q+U5XOx67uvndYOwbWvyJumLxreSTM+lVxlPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QpP8xpQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QpP8xpQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E9DC2BD11;
	Wed, 22 May 2024 03:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346846;
	bh=8fG5CcV+QLFU+QwYedg1rtq5A6yoK783QyO60Z3rj4g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QpP8xpQixxsHRsV6e8Bi/6JpsVpBzOGFNd8nN3ybumIxCY7KnrE1Ik385OTpccx+r
	 HwpjX6aNXe/DzcnVsa3PNwPtlHOfl6LPK5T4vqc45c+0ionUpxFwSRdyA2wuNo4OOQ
	 2UNmWF9EJc7uuLRumDCfz6D/qu3BVTwA8XbrfIUvDYiGe9sh+Pye93+Dqc/FrpJjnT
	 xg/IYusZP7HywwIOCrszQ0VVdTd3eQWw1sZs1Za8WvzCWA+FbuzB6hGc73K+tDnhzI
	 XTDB3JG5LJ5Hdhiizi0HLXoEzyHLPnEjk0wpGIHL/MGwOyGtrUb/QOXviYhrxtM/5t
	 Z5EJ9zM2tiraA==
Date: Tue, 21 May 2024 20:00:46 -0700
Subject: [PATCH 046/111] xfs: store the btree pointer length in struct
 xfs_btree_ops
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532395.2478931.4460091875109713825.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 1a9d26291c68fbb8f8d24f9f694b32223a072745

Make the pointer length an explicit field in the btree operations
structure so that the next patch (which introduces an explicit btree
type enum) doesn't have to play a bunch of awkward games with inferring
the pointer length from the enumeration.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_alloc_btree.c    |    2 ++
 libxfs/xfs_bmap_btree.c     |    3 ++
 libxfs/xfs_btree.c          |   57 ++++++++++++++++++-------------------------
 libxfs/xfs_btree.h          |   26 ++++++++++++--------
 libxfs/xfs_ialloc_btree.c   |    2 ++
 libxfs/xfs_refcount_btree.c |    1 +
 libxfs/xfs_rmap_btree.c     |    1 +
 repair/bulkload.c           |    2 +-
 8 files changed, 49 insertions(+), 45 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index fab420a6c..e1637580c 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -455,6 +455,7 @@ xfs_allocbt_keys_contiguous(
 const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
+	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
 	.lru_refs		= XFS_ALLOC_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_abtb_2),
@@ -483,6 +484,7 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
+	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
 	.lru_refs		= XFS_ALLOC_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_abtc_2),
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index f149dddd9..d2399ea42 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -524,10 +524,11 @@ xfs_bmbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_bmbt_ops = {
-	.geom_flags		= XFS_BTGEO_LONG_PTRS | XFS_BTGEO_ROOT_IN_INODE,
+	.geom_flags		= XFS_BTGEO_ROOT_IN_INODE,
 
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
+	.ptr_len		= XFS_BTREE_LONG_PTR_LEN,
 
 	.lru_refs		= XFS_BMAP_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_bmbt_2),
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 5f132e336..2bce8ebbd 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -249,7 +249,7 @@ xfs_btree_check_block(
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp)	/* buffer containing block, if any */
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		return xfs_btree_check_lblock(cur, block, level, bp);
 	else
 		return xfs_btree_check_sblock(cur, block, level, bp);
@@ -290,7 +290,7 @@ xfs_btree_check_ptr(
 	int				index,
 	int				level)
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (xfs_btree_check_lptr(cur, be64_to_cpu((&ptr->l)[index]),
 				level))
 			return 0;
@@ -446,7 +446,7 @@ xfs_btree_del_cursor(
 	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
 		kfree(cur->bc_ops);
-	if (!(cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) && cur->bc_ag.pag)
+	if (!(cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) && cur->bc_ag.pag)
 		xfs_perag_put(cur->bc_ag.pag);
 	kmem_cache_free(cur->bc_cache, cur);
 }
@@ -585,7 +585,7 @@ xfs_btree_dup_cursor(
  */
 static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (xfs_has_crc(cur->bc_mp))
 			return XFS_BTREE_LBLOCK_CRC_LEN;
 		return XFS_BTREE_LBLOCK_LEN;
@@ -595,15 +595,6 @@ static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
 	return XFS_BTREE_SBLOCK_LEN;
 }
 
-/*
- * Return size of btree block pointers for this btree instance.
- */
-static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
-{
-	return (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) ?
-		sizeof(__be64) : sizeof(__be32);
-}
-
 /*
  * Calculate offset of the n-th record in a btree block.
  */
@@ -651,7 +642,7 @@ xfs_btree_ptr_offset(
 {
 	return xfs_btree_block_len(cur) +
 		cur->bc_ops->get_maxrecs(cur, level) * cur->bc_ops->key_len +
-		(n - 1) * xfs_btree_ptr_len(cur);
+		(n - 1) * cur->bc_ops->ptr_len;
 }
 
 /*
@@ -999,7 +990,7 @@ xfs_btree_readahead(
 	cur->bc_levels[lev].ra |= lr;
 	block = XFS_BUF_TO_BLOCK(cur->bc_levels[lev].bp);
 
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		return xfs_btree_readahead_lblock(cur, lr, block);
 	return xfs_btree_readahead_sblock(cur, lr, block);
 }
@@ -1018,7 +1009,7 @@ xfs_btree_ptr_to_daddr(
 	if (error)
 		return error;
 
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		fsbno = be64_to_cpu(ptr->l);
 		*daddr = XFS_FSB_TO_DADDR(cur->bc_mp, fsbno);
 	} else {
@@ -1068,7 +1059,7 @@ xfs_btree_setbuf(
 	cur->bc_levels[lev].ra = 0;
 
 	b = XFS_BUF_TO_BLOCK(bp);
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (b->bb_u.l.bb_leftsib == cpu_to_be64(NULLFSBLOCK))
 			cur->bc_levels[lev].ra |= XFS_BTCUR_LEFTRA;
 		if (b->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK))
@@ -1086,7 +1077,7 @@ xfs_btree_ptr_is_null(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_ptr	*ptr)
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		return ptr->l == cpu_to_be64(NULLFSBLOCK);
 	else
 		return ptr->s == cpu_to_be32(NULLAGBLOCK);
@@ -1097,7 +1088,7 @@ xfs_btree_set_ptr_null(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		ptr->l = cpu_to_be64(NULLFSBLOCK);
 	else
 		ptr->s = cpu_to_be32(NULLAGBLOCK);
@@ -1115,7 +1106,7 @@ xfs_btree_get_sibling(
 {
 	ASSERT(lr == XFS_BB_LEFTSIB || lr == XFS_BB_RIGHTSIB);
 
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (lr == XFS_BB_RIGHTSIB)
 			ptr->l = block->bb_u.l.bb_rightsib;
 		else
@@ -1137,7 +1128,7 @@ xfs_btree_set_sibling(
 {
 	ASSERT(lr == XFS_BB_LEFTSIB || lr == XFS_BB_RIGHTSIB);
 
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (lr == XFS_BB_RIGHTSIB)
 			block->bb_u.l.bb_rightsib = ptr->l;
 		else
@@ -1167,7 +1158,7 @@ __xfs_btree_init_block(
 	buf->bb_level = cpu_to_be16(level);
 	buf->bb_numrecs = cpu_to_be16(numrecs);
 
-	if (ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		buf->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
 		buf->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
 		if (crc) {
@@ -1269,7 +1260,7 @@ xfs_btree_buf_to_ptr(
 	struct xfs_buf		*bp,
 	union xfs_btree_ptr	*ptr)
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		ptr->l = cpu_to_be64(XFS_DADDR_TO_FSB(cur->bc_mp,
 					xfs_buf_daddr(bp)));
 	else {
@@ -1384,7 +1375,7 @@ xfs_btree_copy_ptrs(
 	int			numptrs)
 {
 	ASSERT(numptrs >= 0);
-	memcpy(dst_ptr, src_ptr, numptrs * xfs_btree_ptr_len(cur));
+	memcpy(dst_ptr, src_ptr, numptrs * cur->bc_ops->ptr_len);
 }
 
 /*
@@ -1440,8 +1431,8 @@ xfs_btree_shift_ptrs(
 	ASSERT(numptrs >= 0);
 	ASSERT(dir == 1 || dir == -1);
 
-	dst_ptr = (char *)ptr + (dir * xfs_btree_ptr_len(cur));
-	memmove(dst_ptr, ptr, numptrs * xfs_btree_ptr_len(cur));
+	dst_ptr = (char *)ptr + (dir * cur->bc_ops->ptr_len);
+	memmove(dst_ptr, ptr, numptrs * cur->bc_ops->ptr_len);
 }
 
 /*
@@ -1567,7 +1558,7 @@ xfs_btree_log_block(
 			nbits = XFS_BB_NUM_BITS;
 		}
 		xfs_btree_offsets(fields,
-				  (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) ?
+				  (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) ?
 					loffsets : soffsets,
 				  nbits, &first, &last);
 		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
@@ -1790,7 +1781,7 @@ xfs_btree_check_block_owner(
 		return NULL;
 
 	owner = xfs_btree_owner(cur);
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (be64_to_cpu(block->bb_u.l.bb_owner) != owner)
 			return __this_address;
 	} else {
@@ -3049,7 +3040,7 @@ xfs_btree_new_iroot(
 	memcpy(cblock, block, xfs_btree_block_len(cur));
 	if (xfs_has_crc(cur->bc_mp)) {
 		__be64 bno = cpu_to_be64(xfs_buf_daddr(cbp));
-		if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+		if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 			cblock->bb_u.l.bb_blkno = bno;
 		else
 			cblock->bb_u.s.bb_blkno = bno;
@@ -4408,7 +4399,7 @@ xfs_btree_visit_block(
 	 * return the same block without checking if the right sibling points
 	 * back to us and creates a cyclic reference in the btree.
 	 */
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (be64_to_cpu(rptr.l) == XFS_DADDR_TO_FSB(cur->bc_mp,
 							xfs_buf_daddr(bp))) {
 			xfs_btree_mark_sick(cur);
@@ -4516,7 +4507,7 @@ xfs_btree_block_change_owner(
 
 	/* modify the owner */
 	block = xfs_btree_get_block(cur, level, &bp);
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (block->bb_u.l.bb_owner == cpu_to_be64(bbcoi->new_owner))
 			return 0;
 		block->bb_u.l.bb_owner = cpu_to_be64(bbcoi->new_owner);
@@ -5065,7 +5056,7 @@ xfs_btree_diff_two_ptrs(
 	const union xfs_btree_ptr	*a,
 	const union xfs_btree_ptr	*b)
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		return (int64_t)be64_to_cpu(a->l) - be64_to_cpu(b->l);
 	return (int64_t)be32_to_cpu(a->s) - be32_to_cpu(b->s);
 }
@@ -5213,7 +5204,7 @@ xfs_btree_has_more_records(
 		return true;
 
 	/* There are more record blocks. */
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		return block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK);
 	else
 		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 2a1f30a84..559066e3a 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -114,13 +114,17 @@ static inline enum xbtree_key_contig xbtree_key_contig(uint64_t x, uint64_t y)
 	return XBTREE_KEY_OVERLAP;
 }
 
+#define XFS_BTREE_LONG_PTR_LEN		(sizeof(__be64))
+#define XFS_BTREE_SHORT_PTR_LEN		(sizeof(__be32))
+
 struct xfs_btree_ops {
 	/* XFS_BTGEO_* flags that determine the geometry of the btree */
 	unsigned int		geom_flags;
 
-	/* size of the key and record structures */
-	size_t	key_len;
-	size_t	rec_len;
+	/* size of the key, pointer, and record structures */
+	size_t			key_len;
+	size_t			ptr_len;
+	size_t			rec_len;
 
 	/* LRU refcount to set on each btree buffer created */
 	unsigned int		lru_refs;
@@ -212,10 +216,9 @@ struct xfs_btree_ops {
 };
 
 /* btree geometry flags */
-#define XFS_BTGEO_LONG_PTRS		(1U << 0) /* pointers are 64bits long */
-#define XFS_BTGEO_ROOT_IN_INODE		(1U << 1) /* root may be variable size */
-#define XFS_BTGEO_LASTREC_UPDATE	(1U << 2) /* track last rec externally */
-#define XFS_BTGEO_OVERLAPPING		(1U << 3) /* overlapping intervals */
+#define XFS_BTGEO_ROOT_IN_INODE		(1U << 0) /* root may be variable size */
+#define XFS_BTGEO_LASTREC_UPDATE	(1U << 1) /* track last rec externally */
+#define XFS_BTGEO_OVERLAPPING		(1U << 2) /* overlapping intervals */
 
 /*
  * Reasons for the update_lastrec method to be called.
@@ -289,8 +292,8 @@ struct xfs_btree_cur
 	/*
 	 * Short btree pointers need an agno to be able to turn the pointers
 	 * into physical addresses for IO, so the btree cursor switches between
-	 * bc_ino and bc_ag based on whether XFS_BTGEO_LONG_PTRS is set for the
-	 * cursor.
+	 * bc_ino and bc_ag based on whether XFS_BTGEO_ROOT_IN_INODE is set for
+	 * the cursor.
 	 */
 	union {
 		struct xfs_btree_cur_ag	bc_ag;
@@ -689,7 +692,7 @@ xfs_btree_islastblock(
 
 	block = xfs_btree_get_block(cur, level, &bp);
 
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		return block->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK);
 	return block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK);
 }
@@ -725,6 +728,9 @@ xfs_btree_alloc_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
+	ASSERT(ops->ptr_len == XFS_BTREE_LONG_PTR_LEN ||
+	       ops->ptr_len == XFS_BTREE_SHORT_PTR_LEN);
+
 	/* BMBT allocations can come through from non-transactional context. */
 	cur = kmem_cache_zalloc(cache,
 			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index e23c5413f..a9b2a48a3 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -400,6 +400,7 @@ xfs_inobt_keys_contiguous(
 const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
+	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
 	.lru_refs		= XFS_INO_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_ibt_2),
@@ -425,6 +426,7 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 const struct xfs_btree_ops xfs_finobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
+	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
 	.lru_refs		= XFS_INO_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_fibt_2),
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 4ee259278..4918c8bae 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -319,6 +319,7 @@ xfs_refcountbt_keys_contiguous(
 const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
+	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
 	.lru_refs		= XFS_REFC_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_refcbt_2),
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 6f9bc43c2..b1d25d99d 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -475,6 +475,7 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
 	.lru_refs		= XFS_RMAP_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_rmap_2),
diff --git a/repair/bulkload.c b/repair/bulkload.c
index 31d136bb8..d36e32d99 100644
--- a/repair/bulkload.c
+++ b/repair/bulkload.c
@@ -314,7 +314,7 @@ bulkload_claim_block(
 	if (resv->used == resv->len)
 		list_move_tail(&resv->list, &bkl->resv_list);
 
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		ptr->l = cpu_to_be64(XFS_AGB_TO_FSB(mp, resv->pag->pag_agno,
 								agbno));
 	else


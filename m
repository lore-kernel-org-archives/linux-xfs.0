Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E740E8527B
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816694; cv=none; b=BHrRj40CDVSJWSqGTkHUYEWiRxy5s6XI91J1oAecuGxv4JMC5g2euAoNbaUEr6id/phennlD/nG18OaldyNziUnGnSixA2TrRCv/C38cc0vpAHy74lkHV7uGynEof+hY0jiDsxdEby4z7TMucflbdw9e9rVG3GP4p7iZmdpDkQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816694; c=relaxed/simple;
	bh=oAh64Uuxw8rGbe/DTjyAwHdQQv5Si8z0zQdEjjBmiNI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HJiZrKms8wohyXh3i4qw3hVDdd6dqWzRRRBLQaI2KfAuzoAFoNEGNo5dRv8T8Mc8LFenv+3jmkmWyUM2Zodjfa9wcPyAeKfOLCNU68Guk/QWIQy6TIMwMJcNReglbxaLNXgG5uZE7FjKJysMwiC70exCqmPVmfFdS5NuSTG+Ut4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iiwliZDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iiwliZDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66445C433C7;
	Thu,  1 Feb 2024 19:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816693;
	bh=oAh64Uuxw8rGbe/DTjyAwHdQQv5Si8z0zQdEjjBmiNI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iiwliZDx2EJ0LUA7Pk9Dw4WstY53+pqwDSQu9znZDfMzT5oD6CxAokUZ+fpFMGAXo
	 RXIyClLVGVfFO6EvanyMiMyU227j3RqqMAORBmGJkLzmmutElr5OfNItYiNuklzYr+
	 MZJMCPwtwLGJ8mn4hbIp2MfMHzjGEgggpM65+sAAtA4+xtKhIUCBZFf19+g+SMUofw
	 cmkf5N17weTESbOD69pkbpJl771DLmZJfUH3dKkTuk8w24H7YSCu0MWtukzF/fOh+7
	 AuZxALd9tq15Iad/nB2WHN8ZmB1QhRnDPQCg+/2ZWa6jqCsYCYKoblJtcFDAUMK/Id
	 OheiyYU00ys+w==
Date: Thu, 01 Feb 2024 11:44:52 -0800
Subject: [PATCH 20/23] xfs: store the btree pointer length in struct
 xfs_btree_ops
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334265.1604831.15668208190067622847.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
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

Make the pointer length an explicit field in the btree operations
structure so that the next patch (which introduces an explicit btree
type enum) doesn't have to play a bunch of awkward games with inferring
the pointer length from the enumeration.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    2 +
 fs/xfs/libxfs/xfs_bmap_btree.c     |    3 +-
 fs/xfs/libxfs/xfs_btree.c          |   57 +++++++++++++++---------------------
 fs/xfs/libxfs/xfs_btree.h          |   26 ++++++++++------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 +
 fs/xfs/libxfs/xfs_refcount_btree.c |    1 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |    1 +
 fs/xfs/scrub/btree.c               |    4 +--
 fs/xfs/scrub/newbt.c               |    2 +
 fs/xfs/xfs_trace.h                 |    4 +--
 10 files changed, 53 insertions(+), 49 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 85ac0ba3c1f1b..9b81b4407444f 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -457,6 +457,7 @@ xfs_allocbt_keys_contiguous(
 const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
+	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
 	.lru_refs		= XFS_ALLOC_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_abtb_2),
@@ -485,6 +486,7 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
+	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
 	.lru_refs		= XFS_ALLOC_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_abtc_2),
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 2d7a8a852596a..59a5f75a45e14 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -525,10 +525,11 @@ xfs_bmbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_bmbt_ops = {
-	.geom_flags		= XFS_BTGEO_LONG_PTRS | XFS_BTGEO_ROOT_IN_INODE,
+	.geom_flags		= XFS_BTGEO_ROOT_IN_INODE,
 
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
+	.ptr_len		= XFS_BTREE_LONG_PTR_LEN,
 
 	.lru_refs		= XFS_BMAP_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_bmbt_2),
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 447573e4215ec..1c15f20cb8ac5 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -252,7 +252,7 @@ xfs_btree_check_block(
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp)	/* buffer containing block, if any */
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		return xfs_btree_check_lblock(cur, block, level, bp);
 	else
 		return xfs_btree_check_sblock(cur, block, level, bp);
@@ -293,7 +293,7 @@ xfs_btree_check_ptr(
 	int				index,
 	int				level)
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (xfs_btree_check_lptr(cur, be64_to_cpu((&ptr->l)[index]),
 				level))
 			return 0;
@@ -449,7 +449,7 @@ xfs_btree_del_cursor(
 	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
 		kmem_free(cur->bc_ops);
-	if (!(cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) && cur->bc_ag.pag)
+	if (!(cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) && cur->bc_ag.pag)
 		xfs_perag_put(cur->bc_ag.pag);
 	kmem_cache_free(cur->bc_cache, cur);
 }
@@ -588,7 +588,7 @@ xfs_btree_dup_cursor(
  */
 static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (xfs_has_crc(cur->bc_mp))
 			return XFS_BTREE_LBLOCK_CRC_LEN;
 		return XFS_BTREE_LBLOCK_LEN;
@@ -598,15 +598,6 @@ static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
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
@@ -654,7 +645,7 @@ xfs_btree_ptr_offset(
 {
 	return xfs_btree_block_len(cur) +
 		cur->bc_ops->get_maxrecs(cur, level) * cur->bc_ops->key_len +
-		(n - 1) * xfs_btree_ptr_len(cur);
+		(n - 1) * cur->bc_ops->ptr_len;
 }
 
 /*
@@ -1002,7 +993,7 @@ xfs_btree_readahead(
 	cur->bc_levels[lev].ra |= lr;
 	block = XFS_BUF_TO_BLOCK(cur->bc_levels[lev].bp);
 
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		return xfs_btree_readahead_lblock(cur, lr, block);
 	return xfs_btree_readahead_sblock(cur, lr, block);
 }
@@ -1021,7 +1012,7 @@ xfs_btree_ptr_to_daddr(
 	if (error)
 		return error;
 
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		fsbno = be64_to_cpu(ptr->l);
 		*daddr = XFS_FSB_TO_DADDR(cur->bc_mp, fsbno);
 	} else {
@@ -1071,7 +1062,7 @@ xfs_btree_setbuf(
 	cur->bc_levels[lev].ra = 0;
 
 	b = XFS_BUF_TO_BLOCK(bp);
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (b->bb_u.l.bb_leftsib == cpu_to_be64(NULLFSBLOCK))
 			cur->bc_levels[lev].ra |= XFS_BTCUR_LEFTRA;
 		if (b->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK))
@@ -1089,7 +1080,7 @@ xfs_btree_ptr_is_null(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_ptr	*ptr)
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		return ptr->l == cpu_to_be64(NULLFSBLOCK);
 	else
 		return ptr->s == cpu_to_be32(NULLAGBLOCK);
@@ -1100,7 +1091,7 @@ xfs_btree_set_ptr_null(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		ptr->l = cpu_to_be64(NULLFSBLOCK);
 	else
 		ptr->s = cpu_to_be32(NULLAGBLOCK);
@@ -1118,7 +1109,7 @@ xfs_btree_get_sibling(
 {
 	ASSERT(lr == XFS_BB_LEFTSIB || lr == XFS_BB_RIGHTSIB);
 
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (lr == XFS_BB_RIGHTSIB)
 			ptr->l = block->bb_u.l.bb_rightsib;
 		else
@@ -1140,7 +1131,7 @@ xfs_btree_set_sibling(
 {
 	ASSERT(lr == XFS_BB_LEFTSIB || lr == XFS_BB_RIGHTSIB);
 
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (lr == XFS_BB_RIGHTSIB)
 			block->bb_u.l.bb_rightsib = ptr->l;
 		else
@@ -1170,7 +1161,7 @@ __xfs_btree_init_block(
 	buf->bb_level = cpu_to_be16(level);
 	buf->bb_numrecs = cpu_to_be16(numrecs);
 
-	if (ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		buf->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
 		buf->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
 		if (crc) {
@@ -1272,7 +1263,7 @@ xfs_btree_buf_to_ptr(
 	struct xfs_buf		*bp,
 	union xfs_btree_ptr	*ptr)
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		ptr->l = cpu_to_be64(XFS_DADDR_TO_FSB(cur->bc_mp,
 					xfs_buf_daddr(bp)));
 	else {
@@ -1387,7 +1378,7 @@ xfs_btree_copy_ptrs(
 	int			numptrs)
 {
 	ASSERT(numptrs >= 0);
-	memcpy(dst_ptr, src_ptr, numptrs * xfs_btree_ptr_len(cur));
+	memcpy(dst_ptr, src_ptr, numptrs * cur->bc_ops->ptr_len);
 }
 
 /*
@@ -1443,8 +1434,8 @@ xfs_btree_shift_ptrs(
 	ASSERT(numptrs >= 0);
 	ASSERT(dir == 1 || dir == -1);
 
-	dst_ptr = (char *)ptr + (dir * xfs_btree_ptr_len(cur));
-	memmove(dst_ptr, ptr, numptrs * xfs_btree_ptr_len(cur));
+	dst_ptr = (char *)ptr + (dir * cur->bc_ops->ptr_len);
+	memmove(dst_ptr, ptr, numptrs * cur->bc_ops->ptr_len);
 }
 
 /*
@@ -1570,7 +1561,7 @@ xfs_btree_log_block(
 			nbits = XFS_BB_NUM_BITS;
 		}
 		xfs_btree_offsets(fields,
-				  (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) ?
+				  (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) ?
 					loffsets : soffsets,
 				  nbits, &first, &last);
 		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
@@ -1793,7 +1784,7 @@ xfs_btree_check_block_owner(
 		return NULL;
 
 	owner = xfs_btree_owner(cur);
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (be64_to_cpu(block->bb_u.l.bb_owner) != owner)
 			return __this_address;
 	} else {
@@ -3052,7 +3043,7 @@ xfs_btree_new_iroot(
 	memcpy(cblock, block, xfs_btree_block_len(cur));
 	if (xfs_has_crc(cur->bc_mp)) {
 		__be64 bno = cpu_to_be64(xfs_buf_daddr(cbp));
-		if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+		if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 			cblock->bb_u.l.bb_blkno = bno;
 		else
 			cblock->bb_u.s.bb_blkno = bno;
@@ -4411,7 +4402,7 @@ xfs_btree_visit_block(
 	 * return the same block without checking if the right sibling points
 	 * back to us and creates a cyclic reference in the btree.
 	 */
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (be64_to_cpu(rptr.l) == XFS_DADDR_TO_FSB(cur->bc_mp,
 							xfs_buf_daddr(bp))) {
 			xfs_btree_mark_sick(cur);
@@ -4519,7 +4510,7 @@ xfs_btree_block_change_owner(
 
 	/* modify the owner */
 	block = xfs_btree_get_block(cur, level, &bp);
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 		if (block->bb_u.l.bb_owner == cpu_to_be64(bbcoi->new_owner))
 			return 0;
 		block->bb_u.l.bb_owner = cpu_to_be64(bbcoi->new_owner);
@@ -5068,7 +5059,7 @@ xfs_btree_diff_two_ptrs(
 	const union xfs_btree_ptr	*a,
 	const union xfs_btree_ptr	*b)
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		return (int64_t)be64_to_cpu(a->l) - be64_to_cpu(b->l);
 	return (int64_t)be32_to_cpu(a->s) - be32_to_cpu(b->s);
 }
@@ -5216,7 +5207,7 @@ xfs_btree_has_more_records(
 		return true;
 
 	/* There are more record blocks. */
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		return block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK);
 	else
 		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index c26321b460d39..09182981756fe 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
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
 	cur = kmem_cache_zalloc(cache, GFP_NOFS | __GFP_NOFAIL);
 	cur->bc_ops = ops;
 	cur->bc_tp = tp;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 8ac7896501067..964d05f9c5cfd 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -401,6 +401,7 @@ xfs_inobt_keys_contiguous(
 const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
+	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
 	.lru_refs		= XFS_INO_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_ibt_2),
@@ -426,6 +427,7 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 const struct xfs_btree_ops xfs_finobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
+	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
 	.lru_refs		= XFS_INO_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_fibt_2),
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index b12b1ccd1f27c..fb05bc2adc251 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -320,6 +320,7 @@ xfs_refcountbt_keys_contiguous(
 const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
+	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
 	.lru_refs		= XFS_REFC_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_refcbt_2),
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index e0ae6da94fc3e..71df1d7d0e016 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -477,6 +477,7 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
 	.lru_refs		= XFS_RMAP_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_rmap_2),
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index e882919996c49..3d3f82007ac61 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -244,7 +244,7 @@ xchk_btree_ptr_ok(
 		return true;
 
 	/* Otherwise, check the pointers. */
-	if (bs->cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (bs->cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		res = xfs_btree_check_lptr(bs->cur, be64_to_cpu(ptr->l), level);
 	else
 		res = xfs_btree_check_sptr(bs->cur, be32_to_cpu(ptr->s), level);
@@ -602,7 +602,7 @@ xchk_btree_get_block(
 		return error;
 
 	xfs_btree_get_block(bs->cur, level, pbp);
-	if (bs->cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (bs->cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		failed_at = __xfs_btree_check_lblock(bs->cur, *pblock,
 				level, *pbp);
 	else
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 84267be79dc1b..608d7ab01d89b 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -535,7 +535,7 @@ xrep_newbt_claim_block(
 	trace_xrep_newbt_claim_block(mp, resv->pag->pag_agno, agbno, 1,
 			xnr->oinfo.oi_owner);
 
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		ptr->l = cpu_to_be64(XFS_AGB_TO_FSB(mp, resv->pag->pag_agno,
 								agbno));
 	else
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b0bb0ceca0425..c92eba282863a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2520,7 +2520,7 @@ TRACE_EVENT(xfs_btree_alloc_block,
 		__entry->btnum = cur->bc_btnum;
 		__entry->error = error;
 		if (!error && stat) {
-			if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+			if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 				xfs_fsblock_t	fsb = be64_to_cpu(ptr->l);
 
 				__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp,
@@ -4283,7 +4283,7 @@ TRACE_EVENT(xfs_btree_bload_block,
 		__entry->level = level;
 		__entry->block_idx = block_idx;
 		__entry->nr_blocks = nr_blocks;
-		if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+		if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
 			xfs_fsblock_t	fsb = be64_to_cpu(ptr->l);
 
 			__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsb);


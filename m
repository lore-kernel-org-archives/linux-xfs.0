Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2EC1D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424206; cv=none; b=tZRvfslvEq8Xw02VIXDjhyRl6KBYYBFh1RIu+IgxWd0t3upR5nlc0aF3QqO9kc+V9L55sPhS/EMjk5Z/gkHdQvQwOdknDnztVkWABnyHqRtto5h6FsBCL8MdwUvG1VbZJRVJgYrRkYHikBnPOwOL6uhc61Oa5xhqrIe9OusgQ5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424206; c=relaxed/simple;
	bh=/9hbpw5tOavjVAMIefXn/GdtokTMX46lvWjcoGG4/pE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qK4r/Izzb3uRAX0WSDqaV0S1udP3e3wvbsvaMOWOnAUjU5IDSGI69Z6CBiJ1CXefRgxMjf72ULjw1cuiIBl3DW2flHH6UJ+XpU4lDBgpthoYHtFtCu0HjaRgtnDHj6pGB3PB2u+B1RoZWAKfRlSSJbQv2N2BQaU+3277FWPy91g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGl7j+C3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGl7j+C3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09205C433C7;
	Tue, 26 Mar 2024 03:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424206;
	bh=/9hbpw5tOavjVAMIefXn/GdtokTMX46lvWjcoGG4/pE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OGl7j+C3S4dlV6uIszMv6g6NM0UTlX/990dXEhtNXW4MVGSZJFgIqHvtgcROF0Sl7
	 wOMdtSwXPIDrvbIBnkziZybL6Lvrz7qB4wjh+D+fhNcKWmtwmsuQQ4mJ9GDvVOjWGD
	 vdEUe8/+aSyxAmcjsg3wjY+Pl4PRjOAzudMuGJBgu9nTxZANc9f0fqFSjcdKZLGpM0
	 1/w0LYAIoDGVgSIrRYtKh21TxoXNOixaukphb2XI0RckhFgGILc0f75B8ZaxJhN6rA
	 3qmT7V8hEIi3MclB9XF2ZXtr2Grs11RCRC4nWrh6gz1HsaO/tpvTDl3mp0i2mE0FIL
	 jctVt2jX0PRMg==
Date: Mon, 25 Mar 2024 20:36:45 -0700
Subject: [PATCH 032/110] xfs: encode the btree geometry flags in the btree ops
 structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131845.2215168.6420801315650943604.stgit@frogsfrogsfrogs>
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

Source kernel commit: fd9c7f7722d815527269b80d9990aecffa06957c

Certain btree flags never change for the life of a btree cursor because
they describe the geometry of the btree itself.  Encode these in the
btree ops structure and reduce the amount of code required in each btree
type's init_cursor functions.  This also frees up most of the bits in
bc_flags.

A previous version of this patch also converted the open-coded flags
logic to helpers.  This was removed due to the pending refactoring (that
follows this patch) to eliminate most of the state flags.

Conversion script:

sed \
-e 's/XFS_BTREE_LONG_PTRS/XFS_BTGEO_LONG_PTRS/g' \
-e 's/XFS_BTREE_ROOT_IN_INODE/XFS_BTGEO_ROOT_IN_INODE/g' \
-e 's/XFS_BTREE_LASTREC_UPDATE/XFS_BTGEO_LASTREC_UPDATE/g' \
-e 's/XFS_BTREE_OVERLAPPING/XFS_BTGEO_OVERLAPPING/g' \
-e 's/cur->bc_flags & XFS_BTGEO_/cur->bc_ops->geom_flags \& XFS_BTGEO_/g' \
-i $(git ls-files fs/xfs/*.[ch] fs/xfs/libxfs/*.[ch] fs/xfs/scrub/*.[ch])

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_alloc_btree.c   |    4 +-
 libxfs/xfs_bmap.c          |    4 +-
 libxfs/xfs_bmap_btree.c    |    6 +-
 libxfs/xfs_btree.c         |  110 ++++++++++++++++++++++----------------------
 libxfs/xfs_btree.h         |   23 ++++++---
 libxfs/xfs_btree_staging.c |   14 +++---
 libxfs/xfs_btree_staging.h |    2 -
 libxfs/xfs_rmap_btree.c    |    3 +
 repair/bulkload.c          |    2 -
 9 files changed, 87 insertions(+), 81 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 626d8e4b87a8..d3ecd513d276 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -476,6 +476,8 @@ static const struct xfs_btree_ops xfs_bnobt_ops = {
 };
 
 static const struct xfs_btree_ops xfs_cntbt_ops = {
+	.geom_flags		= XFS_BTGEO_LASTREC_UPDATE,
+
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 
@@ -514,7 +516,6 @@ xfs_allocbt_init_common(
 		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_cntbt_ops,
 				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
-		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
 	} else {
 		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_bnobt_ops,
 				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
@@ -589,7 +590,6 @@ xfs_allocbt_commit_staged_btree(
 	if (cur->bc_btnum == XFS_BTNUM_BNO) {
 		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_bnobt_ops);
 	} else {
-		cur->bc_flags |= XFS_BTREE_LASTREC_UPDATE;
 		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_cntbt_ops);
 	}
 }
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 7d7486ca6fec..72d35f664110 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -640,7 +640,7 @@ xfs_bmap_extents_to_btree(
 	block = ifp->if_broot;
 	xfs_btree_init_block_int(mp, block, XFS_BUF_DADDR_NULL,
 				 XFS_BTNUM_BMAP, 1, 1, ip->i_ino,
-				 XFS_BTREE_LONG_PTRS);
+				 XFS_BTGEO_LONG_PTRS);
 	/*
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
@@ -687,7 +687,7 @@ xfs_bmap_extents_to_btree(
 	ablock = XFS_BUF_TO_BLOCK(abp);
 	xfs_btree_init_block_int(mp, ablock, xfs_buf_daddr(abp),
 				XFS_BTNUM_BMAP, 0, 0, ip->i_ino,
-				XFS_BTREE_LONG_PTRS);
+				XFS_BTGEO_LONG_PTRS);
 
 	for_each_xfs_iext(ifp, &icur, &rec) {
 		if (isnullstartblock(rec.br_startblock))
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 8ffef40bab29..acb83443fc03 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -45,7 +45,7 @@ xfs_bmdr_to_bmbt(
 
 	xfs_btree_init_block_int(mp, rblock, XFS_BUF_DADDR_NULL,
 				 XFS_BTNUM_BMAP, 0, 0, ip->i_ino,
-				 XFS_BTREE_LONG_PTRS);
+				 XFS_BTGEO_LONG_PTRS);
 	rblock->bb_level = dblock->bb_level;
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
 	rblock->bb_numrecs = dblock->bb_numrecs;
@@ -515,6 +515,8 @@ xfs_bmbt_keys_contiguous(
 }
 
 static const struct xfs_btree_ops xfs_bmbt_ops = {
+	.geom_flags		= XFS_BTGEO_LONG_PTRS | XFS_BTGEO_ROOT_IN_INODE,
+
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
 
@@ -552,8 +554,6 @@ xfs_bmbt_init_common(
 			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
-	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
-
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.allocated = 0;
 	cur->bc_ino.flags = 0;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 38d82c03ab52..cd8cb2def194 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -258,7 +258,7 @@ xfs_btree_check_block(
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp)	/* buffer containing block, if any */
 {
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
 		return xfs_btree_check_lblock(cur, block, level, bp);
 	else
 		return xfs_btree_check_sblock(cur, block, level, bp);
@@ -299,7 +299,7 @@ xfs_btree_check_ptr(
 	int				index,
 	int				level)
 {
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
 		if (xfs_btree_check_lptr(cur, be64_to_cpu((&ptr->l)[index]),
 				level))
 			return 0;
@@ -455,7 +455,7 @@ xfs_btree_del_cursor(
 	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
 		kfree(cur->bc_ops);
-	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
+	if (!(cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) && cur->bc_ag.pag)
 		xfs_perag_put(cur->bc_ag.pag);
 	kmem_cache_free(cur->bc_cache, cur);
 }
@@ -544,7 +544,7 @@ xfs_btree_dup_cursor(
  * record, key or pointer (xfs_btree_*_addr).  Note that all addressing
  * inside the btree block is done using indices starting at one, not zero!
  *
- * If XFS_BTREE_OVERLAPPING is set, then this btree supports keys containing
+ * If XFS_BTGEO_OVERLAPPING is set, then this btree supports keys containing
  * overlapping intervals.  In such a tree, records are still sorted lowest to
  * highest and indexed by the smallest key value that refers to the record.
  * However, nodes are different: each pointer has two associated keys -- one
@@ -594,7 +594,7 @@ xfs_btree_dup_cursor(
  */
 static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
 {
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
 		if (xfs_has_crc(cur->bc_mp))
 			return XFS_BTREE_LBLOCK_CRC_LEN;
 		return XFS_BTREE_LBLOCK_LEN;
@@ -609,7 +609,7 @@ static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
  */
 static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
 {
-	return (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
+	return (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) ?
 		sizeof(__be64) : sizeof(__be32);
 }
 
@@ -723,7 +723,7 @@ struct xfs_ifork *
 xfs_btree_ifork_ptr(
 	struct xfs_btree_cur	*cur)
 {
-	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+	ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
 
 	if (cur->bc_flags & XFS_BTREE_STAGING)
 		return cur->bc_ino.ifake->if_fork;
@@ -755,7 +755,7 @@ xfs_btree_get_block(
 	int			level,	/* level in btree */
 	struct xfs_buf		**bpp)	/* buffer containing the block */
 {
-	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
 	    (level == cur->bc_nlevels - 1)) {
 		*bpp = NULL;
 		return xfs_btree_get_iroot(cur);
@@ -998,7 +998,7 @@ xfs_btree_readahead(
 	 * No readahead needed if we are at the root level and the
 	 * btree root is stored in the inode.
 	 */
-	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
 	    (lev == cur->bc_nlevels - 1))
 		return 0;
 
@@ -1008,7 +1008,7 @@ xfs_btree_readahead(
 	cur->bc_levels[lev].ra |= lr;
 	block = XFS_BUF_TO_BLOCK(cur->bc_levels[lev].bp);
 
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
 		return xfs_btree_readahead_lblock(cur, lr, block);
 	return xfs_btree_readahead_sblock(cur, lr, block);
 }
@@ -1027,7 +1027,7 @@ xfs_btree_ptr_to_daddr(
 	if (error)
 		return error;
 
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
 		fsbno = be64_to_cpu(ptr->l);
 		*daddr = XFS_FSB_TO_DADDR(cur->bc_mp, fsbno);
 	} else {
@@ -1077,7 +1077,7 @@ xfs_btree_setbuf(
 	cur->bc_levels[lev].ra = 0;
 
 	b = XFS_BUF_TO_BLOCK(bp);
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
 		if (b->bb_u.l.bb_leftsib == cpu_to_be64(NULLFSBLOCK))
 			cur->bc_levels[lev].ra |= XFS_BTCUR_LEFTRA;
 		if (b->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK))
@@ -1095,7 +1095,7 @@ xfs_btree_ptr_is_null(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_ptr	*ptr)
 {
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
 		return ptr->l == cpu_to_be64(NULLFSBLOCK);
 	else
 		return ptr->s == cpu_to_be32(NULLAGBLOCK);
@@ -1106,7 +1106,7 @@ xfs_btree_set_ptr_null(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
 		ptr->l = cpu_to_be64(NULLFSBLOCK);
 	else
 		ptr->s = cpu_to_be32(NULLAGBLOCK);
@@ -1124,7 +1124,7 @@ xfs_btree_get_sibling(
 {
 	ASSERT(lr == XFS_BB_LEFTSIB || lr == XFS_BB_RIGHTSIB);
 
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
 		if (lr == XFS_BB_RIGHTSIB)
 			ptr->l = block->bb_u.l.bb_rightsib;
 		else
@@ -1146,7 +1146,7 @@ xfs_btree_set_sibling(
 {
 	ASSERT(lr == XFS_BB_LEFTSIB || lr == XFS_BB_RIGHTSIB);
 
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
 		if (lr == XFS_BB_RIGHTSIB)
 			block->bb_u.l.bb_rightsib = ptr->l;
 		else
@@ -1168,16 +1168,16 @@ xfs_btree_init_block_int(
 	__u16			level,
 	__u16			numrecs,
 	__u64			owner,
-	unsigned int		flags)
+	unsigned int		geom_flags)
 {
-	int			crc = xfs_has_crc(mp);
+	bool			crc = xfs_has_crc(mp);
 	__u32			magic = xfs_btree_magic(crc, btnum);
 
 	buf->bb_magic = cpu_to_be32(magic);
 	buf->bb_level = cpu_to_be16(level);
 	buf->bb_numrecs = cpu_to_be16(numrecs);
 
-	if (flags & XFS_BTREE_LONG_PTRS) {
+	if (geom_flags & XFS_BTGEO_LONG_PTRS) {
 		buf->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
 		buf->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
 		if (crc) {
@@ -1230,14 +1230,14 @@ xfs_btree_init_block_cur(
 	 * change in future, but is safe for current users of the generic btree
 	 * code.
 	 */
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
 		owner = cur->bc_ino.ip->i_ino;
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
 	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp),
 				xfs_buf_daddr(bp), cur->bc_btnum, level,
-				numrecs, owner, cur->bc_flags);
+				numrecs, owner, cur->bc_ops->geom_flags);
 }
 
 /*
@@ -1255,7 +1255,7 @@ xfs_btree_is_lastrec(
 
 	if (level > 0)
 		return 0;
-	if (!(cur->bc_flags & XFS_BTREE_LASTREC_UPDATE))
+	if (!(cur->bc_ops->geom_flags & XFS_BTGEO_LASTREC_UPDATE))
 		return 0;
 
 	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
@@ -1270,7 +1270,7 @@ xfs_btree_buf_to_ptr(
 	struct xfs_buf		*bp,
 	union xfs_btree_ptr	*ptr)
 {
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
 		ptr->l = cpu_to_be64(XFS_DADDR_TO_FSB(cur->bc_mp,
 					xfs_buf_daddr(bp)));
 	else {
@@ -1588,7 +1588,7 @@ xfs_btree_log_block(
 			nbits = XFS_BB_NUM_BITS;
 		}
 		xfs_btree_offsets(fields,
-				  (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
+				  (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) ?
 					loffsets : soffsets,
 				  nbits, &first, &last);
 		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
@@ -1665,7 +1665,7 @@ xfs_btree_increment(
 	 * confused or have the tree root in an inode.
 	 */
 	if (lev == cur->bc_nlevels) {
-		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+		if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
 			goto out0;
 		ASSERT(0);
 		xfs_btree_mark_sick(cur);
@@ -1759,7 +1759,7 @@ xfs_btree_decrement(
 	 * or the root of the tree is in an inode.
 	 */
 	if (lev == cur->bc_nlevels) {
-		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+		if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
 			goto out0;
 		ASSERT(0);
 		xfs_btree_mark_sick(cur);
@@ -1807,7 +1807,7 @@ xfs_btree_lookup_get_block(
 	int			error = 0;
 
 	/* special case the root block if in an inode */
-	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
 	    (level == cur->bc_nlevels - 1)) {
 		*blkp = xfs_btree_get_iroot(cur);
 		return 0;
@@ -1835,7 +1835,7 @@ xfs_btree_lookup_get_block(
 	/* Check the inode owner since the verifiers don't. */
 	if (xfs_has_crc(cur->bc_mp) &&
 	    !(cur->bc_ino.flags & XFS_BTCUR_BMBT_INVALID_OWNER) &&
-	    (cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
+	    (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) &&
 	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
 			cur->bc_ino.ip->i_ino)
 		goto out_bad;
@@ -2055,7 +2055,7 @@ xfs_btree_high_key_from_key(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_key	*key)
 {
-	ASSERT(cur->bc_flags & XFS_BTREE_OVERLAPPING);
+	ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_OVERLAPPING);
 	return (union xfs_btree_key *)((char *)key +
 			(cur->bc_ops->key_len / 2));
 }
@@ -2076,7 +2076,7 @@ xfs_btree_get_leaf_keys(
 	rec = xfs_btree_rec_addr(cur, 1, block);
 	cur->bc_ops->init_key_from_rec(key, rec);
 
-	if (cur->bc_flags & XFS_BTREE_OVERLAPPING) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_OVERLAPPING) {
 
 		cur->bc_ops->init_high_key_from_rec(&max_hkey, rec);
 		for (n = 2; n <= xfs_btree_get_numrecs(block); n++) {
@@ -2103,7 +2103,7 @@ xfs_btree_get_node_keys(
 	union xfs_btree_key	*high;
 	int			n;
 
-	if (cur->bc_flags & XFS_BTREE_OVERLAPPING) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_OVERLAPPING) {
 		memcpy(key, xfs_btree_key_addr(cur, 1, block),
 				cur->bc_ops->key_len / 2);
 
@@ -2147,7 +2147,7 @@ xfs_btree_needs_key_update(
 	struct xfs_btree_cur	*cur,
 	int			ptr)
 {
-	return (cur->bc_flags & XFS_BTREE_OVERLAPPING) || ptr == 1;
+	return (cur->bc_ops->geom_flags & XFS_BTGEO_OVERLAPPING) || ptr == 1;
 }
 
 /*
@@ -2171,7 +2171,7 @@ __xfs_btree_updkeys(
 	struct xfs_buf		*bp;
 	int			ptr;
 
-	ASSERT(cur->bc_flags & XFS_BTREE_OVERLAPPING);
+	ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_OVERLAPPING);
 
 	/* Exit if there aren't any parent levels to update. */
 	if (level + 1 >= cur->bc_nlevels)
@@ -2240,7 +2240,7 @@ xfs_btree_update_keys(
 	ASSERT(level >= 0);
 
 	block = xfs_btree_get_block(cur, level, &bp);
-	if (cur->bc_flags & XFS_BTREE_OVERLAPPING)
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_OVERLAPPING)
 		return __xfs_btree_updkeys(cur, level, block, bp, false);
 
 	/*
@@ -2347,7 +2347,7 @@ xfs_btree_lshift(
 	int			error;		/* error return value */
 	int			i;
 
-	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
 	    level == cur->bc_nlevels - 1)
 		goto out0;
 
@@ -2475,7 +2475,7 @@ xfs_btree_lshift(
 	 * Using a temporary cursor, update the parent key values of the
 	 * block on the left.
 	 */
-	if (cur->bc_flags & XFS_BTREE_OVERLAPPING) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_OVERLAPPING) {
 		error = xfs_btree_dup_cursor(cur, &tcur);
 		if (error)
 			goto error0;
@@ -2543,7 +2543,7 @@ xfs_btree_rshift(
 	int			error;		/* error return value */
 	int			i;		/* loop counter */
 
-	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
 	    (level == cur->bc_nlevels - 1))
 		goto out0;
 
@@ -2662,7 +2662,7 @@ xfs_btree_rshift(
 		goto error1;
 
 	/* Update the parent high keys of the left block, if needed. */
-	if (cur->bc_flags & XFS_BTREE_OVERLAPPING) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_OVERLAPPING) {
 		error = xfs_btree_update_keys(cur, level);
 		if (error)
 			goto error1;
@@ -2854,7 +2854,7 @@ __xfs_btree_split(
 	}
 
 	/* Update the parent high keys of the left block, if needed. */
-	if (cur->bc_flags & XFS_BTREE_OVERLAPPING) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_OVERLAPPING) {
 		error = xfs_btree_update_keys(cur, level);
 		if (error)
 			goto error0;
@@ -3019,7 +3019,7 @@ xfs_btree_new_iroot(
 
 	XFS_BTREE_STATS_INC(cur, newroot);
 
-	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+	ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
 
 	level = cur->bc_nlevels - 1;
 
@@ -3047,7 +3047,7 @@ xfs_btree_new_iroot(
 	memcpy(cblock, block, xfs_btree_block_len(cur));
 	if (xfs_has_crc(cur->bc_mp)) {
 		__be64 bno = cpu_to_be64(xfs_buf_daddr(cbp));
-		if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
 			cblock->bb_u.l.bb_blkno = bno;
 		else
 			cblock->bb_u.s.bb_blkno = bno;
@@ -3244,7 +3244,7 @@ xfs_btree_make_block_unfull(
 {
 	int			error = 0;
 
-	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
 	    level == cur->bc_nlevels - 1) {
 		struct xfs_inode *ip = cur->bc_ino.ip;
 
@@ -3330,7 +3330,7 @@ xfs_btree_insrec(
 	 * If we have an external root pointer, and we've made it to the
 	 * root level, allocate a new root block and we're done.
 	 */
-	if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	if (!(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
 	    (level >= cur->bc_nlevels)) {
 		error = xfs_btree_new_root(cur, stat);
 		xfs_btree_set_ptr_null(cur, ptrp);
@@ -3618,7 +3618,7 @@ xfs_btree_kill_iroot(
 #endif
 	int			i;
 
-	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+	ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
 	ASSERT(cur->bc_nlevels > 1);
 
 	/*
@@ -3855,7 +3855,7 @@ xfs_btree_delrec(
 	 * nothing left to do.
 	 */
 	if (level == cur->bc_nlevels - 1) {
-		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+		if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) {
 			xfs_iroot_realloc(cur->bc_ino.ip, -1,
 					  cur->bc_ino.whichfork);
 
@@ -3923,7 +3923,7 @@ xfs_btree_delrec(
 	xfs_btree_get_sibling(cur, block, &rptr, XFS_BB_RIGHTSIB);
 	xfs_btree_get_sibling(cur, block, &lptr, XFS_BB_LEFTSIB);
 
-	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) {
 		/*
 		 * One child of root, need to get a chance to copy its contents
 		 * into the root and delete it. Can't go up to next level,
@@ -4240,7 +4240,7 @@ xfs_btree_delrec(
 	 * If we joined with the right neighbor and there's a level above
 	 * us, increment the cursor at that level.
 	 */
-	else if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) ||
+	else if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) ||
 		   (level + 1 < cur->bc_nlevels)) {
 		error = xfs_btree_increment(cur, level + 1, &i);
 		if (error)
@@ -4309,7 +4309,7 @@ xfs_btree_delete(
 	 * If we combined blocks as part of deleting the record, delrec won't
 	 * have updated the parent high keys so we have to do that here.
 	 */
-	if (joined && (cur->bc_flags & XFS_BTREE_OVERLAPPING)) {
+	if (joined && (cur->bc_ops->geom_flags & XFS_BTGEO_OVERLAPPING)) {
 		error = xfs_btree_updkeys_force(cur, 0);
 		if (error)
 			goto error0;
@@ -4406,7 +4406,7 @@ xfs_btree_visit_block(
 	 * return the same block without checking if the right sibling points
 	 * back to us and creates a cyclic reference in the btree.
 	 */
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
 		if (be64_to_cpu(rptr.l) == XFS_DADDR_TO_FSB(cur->bc_mp,
 							xfs_buf_daddr(bp))) {
 			xfs_btree_mark_sick(cur);
@@ -4514,7 +4514,7 @@ xfs_btree_block_change_owner(
 
 	/* modify the owner */
 	block = xfs_btree_get_block(cur, level, &bp);
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
 		if (block->bb_u.l.bb_owner == cpu_to_be64(bbcoi->new_owner))
 			return 0;
 		block->bb_u.l.bb_owner = cpu_to_be64(bbcoi->new_owner);
@@ -4532,7 +4532,7 @@ xfs_btree_block_change_owner(
 	 * though, so everything is consistent in memory.
 	 */
 	if (!bp) {
-		ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+		ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
 		ASSERT(level == cur->bc_nlevels - 1);
 		return 0;
 	}
@@ -5009,7 +5009,7 @@ xfs_btree_query_range(
 	if (!xfs_btree_keycmp_le(cur, &low_key, &high_key))
 		return -EINVAL;
 
-	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
+	if (!(cur->bc_ops->geom_flags & XFS_BTGEO_OVERLAPPING))
 		return xfs_btree_simple_query_range(cur, &low_key,
 				&high_key, fn, priv);
 	return xfs_btree_overlapped_query_range(cur, &low_key, &high_key,
@@ -5063,7 +5063,7 @@ xfs_btree_diff_two_ptrs(
 	const union xfs_btree_ptr	*a,
 	const union xfs_btree_ptr	*b)
 {
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
 		return (int64_t)be64_to_cpu(a->l) - be64_to_cpu(b->l);
 	return (int64_t)be32_to_cpu(a->s) - be32_to_cpu(b->s);
 }
@@ -5117,7 +5117,7 @@ xfs_btree_has_records_helper(
 		key_contig = cur->bc_ops->keys_contiguous(cur, &info->high_key,
 					&rec_key, info->key_mask);
 		if (key_contig == XBTREE_KEY_OVERLAP &&
-				!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
+				!(cur->bc_ops->geom_flags & XFS_BTGEO_OVERLAPPING))
 			return -EFSCORRUPTED;
 		if (key_contig == XBTREE_KEY_GAP)
 			return -ECANCELED;
@@ -5211,7 +5211,7 @@ xfs_btree_has_more_records(
 		return true;
 
 	/* There are more record blocks. */
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
 		return block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK);
 	else
 		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 36fd07b32daf..5a292d7a7096 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -112,6 +112,9 @@ static inline enum xbtree_key_contig xbtree_key_contig(uint64_t x, uint64_t y)
 }
 
 struct xfs_btree_ops {
+	/* XFS_BTGEO_* flags that determine the geometry of the btree */
+	unsigned int		geom_flags;
+
 	/* size of the key and record structures */
 	size_t	key_len;
 	size_t	rec_len;
@@ -199,6 +202,12 @@ struct xfs_btree_ops {
 			       const union xfs_btree_key *mask);
 };
 
+/* btree geometry flags */
+#define XFS_BTGEO_LONG_PTRS		(1U << 0) /* pointers are 64bits long */
+#define XFS_BTGEO_ROOT_IN_INODE		(1U << 1) /* root may be variable size */
+#define XFS_BTGEO_LASTREC_UPDATE	(1U << 2) /* track last rec externally */
+#define XFS_BTGEO_OVERLAPPING		(1U << 3) /* overlapping intervals */
+
 /*
  * Reasons for the update_lastrec method to be called.
  */
@@ -281,7 +290,7 @@ struct xfs_btree_cur
 	/*
 	 * Short btree pointers need an agno to be able to turn the pointers
 	 * into physical addresses for IO, so the btree cursor switches between
-	 * bc_ino and bc_ag based on whether XFS_BTREE_LONG_PTRS is set for the
+	 * bc_ino and bc_ag based on whether XFS_BTGEO_LONG_PTRS is set for the
 	 * cursor.
 	 */
 	union {
@@ -304,17 +313,13 @@ xfs_btree_cur_sizeof(unsigned int nlevels)
 	return struct_size_t(struct xfs_btree_cur, bc_levels, nlevels);
 }
 
-/* cursor flags */
-#define XFS_BTREE_LONG_PTRS		(1<<0)	/* pointers are 64bits long */
-#define XFS_BTREE_ROOT_IN_INODE		(1<<1)	/* root may be variable size */
-#define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
-#define XFS_BTREE_OVERLAPPING		(1<<4)	/* overlapping intervals */
+/* cursor state flags */
 /*
  * The root of this btree is a fakeroot structure so that we can stage a btree
  * rebuild without leaving it accessible via primary metadata.  The ops struct
  * is dynamically allocated and must be freed when the cursor is deleted.
  */
-#define XFS_BTREE_STAGING		(1<<5)
+#define XFS_BTREE_STAGING		(1U << 0)
 
 #define	XFS_BTREE_NOERROR	0
 #define	XFS_BTREE_ERROR		1
@@ -447,7 +452,7 @@ xfs_btree_init_block_int(
 	__u16			level,
 	__u16			numrecs,
 	__u64			owner,
-	unsigned int		flags);
+	unsigned int		geom_flags);
 
 /*
  * Common btree core entry points.
@@ -689,7 +694,7 @@ xfs_btree_islastblock(
 
 	block = xfs_btree_get_block(cur, level, &bp);
 
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
 		return block->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK);
 	return block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK);
 }
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 45ef6aba8514..ac99543e0b3b 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -136,7 +136,7 @@ xfs_btree_stage_afakeroot(
 	struct xfs_btree_ops		*nops;
 
 	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
-	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE));
+	ASSERT(!(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE));
 	ASSERT(cur->bc_tp == NULL);
 
 	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
@@ -217,7 +217,7 @@ xfs_btree_stage_ifakeroot(
 	struct xfs_btree_ops		*nops;
 
 	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
-	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+	ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
 	ASSERT(cur->bc_tp == NULL);
 
 	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
@@ -397,7 +397,7 @@ xfs_btree_bload_prep_block(
 	struct xfs_btree_block		*new_block;
 	int				ret;
 
-	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
 	    level == cur->bc_nlevels - 1) {
 		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
 		size_t			new_size;
@@ -413,7 +413,7 @@ xfs_btree_bload_prep_block(
 		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
 				XFS_BUF_DADDR_NULL, cur->bc_btnum, level,
 				nr_this_block, cur->bc_ino.ip->i_ino,
-				cur->bc_flags);
+				cur->bc_ops->geom_flags);
 
 		*bpp = NULL;
 		*blockp = ifp->if_broot;
@@ -704,7 +704,7 @@ xfs_btree_bload_compute_geometry(
 		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
 				&avg_per_block, &level_blocks, &dontcare64);
 
-		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+		if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) {
 			/*
 			 * If all the items we want to store at this level
 			 * would fit in the inode root block, then we have our
@@ -763,7 +763,7 @@ xfs_btree_bload_compute_geometry(
 		return -EOVERFLOW;
 
 	bbl->btree_height = cur->bc_nlevels;
-	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
 		bbl->nr_blocks = nr_blocks - 1;
 	else
 		bbl->nr_blocks = nr_blocks;
@@ -890,7 +890,7 @@ xfs_btree_bload(
 	}
 
 	/* Initialize the new root. */
-	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) {
 		ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
 		cur->bc_ino.ifake->if_levels = cur->bc_nlevels;
 		cur->bc_ino.ifake->if_blocks = total_blocks - 1;
diff --git a/libxfs/xfs_btree_staging.h b/libxfs/xfs_btree_staging.h
index 055ea43b1e18..9624ae06c83c 100644
--- a/libxfs/xfs_btree_staging.h
+++ b/libxfs/xfs_btree_staging.h
@@ -76,7 +76,7 @@ struct xfs_btree_bload {
 
 	/*
 	 * This function should return the size of the in-core btree root
-	 * block.  It is only necessary for XFS_BTREE_ROOT_IN_INODE btree
+	 * block.  It is only necessary for XFS_BTGEO_ROOT_IN_INODE btree
 	 * types.
 	 */
 	xfs_btree_bload_iroot_size_fn	iroot_size;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index da6bfb901704..7f815522c820 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -471,6 +471,8 @@ xfs_rmapbt_keys_contiguous(
 }
 
 static const struct xfs_btree_ops xfs_rmapbt_ops = {
+	.geom_flags		= XFS_BTGEO_OVERLAPPING,
+
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
 
@@ -503,7 +505,6 @@ xfs_rmapbt_init_common(
 	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
-	cur->bc_flags = XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
diff --git a/repair/bulkload.c b/repair/bulkload.c
index a97839f549dd..31d136bb85ac 100644
--- a/repair/bulkload.c
+++ b/repair/bulkload.c
@@ -314,7 +314,7 @@ bulkload_claim_block(
 	if (resv->used == resv->len)
 		list_move_tail(&resv->list, &bkl->resv_list);
 
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
 		ptr->l = cpu_to_be64(XFS_AGB_TO_FSB(mp, resv->pag->pag_agno,
 								agbno));
 	else


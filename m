Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB41128823
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424770; cv=none; b=e1oBeGkG+m1XVtshan/aCN2ImrA7Ra0l6b9mAC13VI1NUXdKWnSwrFfV5Oq5mzepQLy/01/WG3jE2cv5D36MQ0dMrx3rhpe6AoBc/nhy8KvDIYkkWjd9690/VdjxGWHocD2t4tYPiyHcV72ykYsPxeWRkk7FD7PlAfxignj4oUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424770; c=relaxed/simple;
	bh=JV2Sz5wjCAE6YsrvfEle2KRs0q+Pvt7vjes9/MW4Was=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o1MukGnnEbn6Wl7mio6ybHfKq3kabjrqdJKLvuKevUPx3fITzu7MLpbYzofmw/Msx06lgpE769a3meJwTdWFhUQ124TSgj/WAn38V7wM0lnrgjGh3VgH1P0i6uVTmR+sJMY25zLpNo1KB+OtJ6OzxzduWHyi9nyiYAYMXTj1duQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ie+sRUgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ie+sRUgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6064DC433F1;
	Tue, 26 Mar 2024 03:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424770;
	bh=JV2Sz5wjCAE6YsrvfEle2KRs0q+Pvt7vjes9/MW4Was=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ie+sRUgxv2T5yeaFrA5TQrK/LTi+AXbFsADL30QyiL0jDb863XLj/SOptGEsgeFFy
	 +bRBmFEeZ2rEJPkmPEgOoOowPJxKH+vdQw4m38oSwskFNXbzwTznE0iCFrybVQhcvF
	 HCcsqPMu1DsoeQt48DuJ9xIbff3B9sOKBSSriZc+JWfqFDrw1hkQRJdbUCgsZ4zJBu
	 EWJga5Rz7TL0ddGtguC3qeXwVRyf3bzM6lnaFdfYBbTJsTLtDQ+4CPzFo63vLqrrk/
	 psHb1vxk0R5WIYu8PPimKxkZQ8uI8Jn1CzlVvl8LiaNMQoW07GQT9gxpqAjS6C8uHW
	 d2vITEhbi3raQ==
Date: Mon, 25 Mar 2024 20:46:09 -0700
Subject: [PATCH 068/110] xfs: split xfs_allocbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132359.2215168.3561923930249993887.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 1c8b9fd278c08e16c27a41be484b77383738de1f

Split xfs_allocbt_init_cursor into separate routines for the by-bno
and by-cnt btrees to prepare for the removal of the xfs_btnum global
enumeration of btree types.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    4 ++-
 libxfs/xfs_alloc.c       |   36 +++++++++++++--------------
 libxfs/xfs_alloc_btree.c |   62 +++++++++++++++++++++++++++++++++-------------
 libxfs/xfs_alloc_btree.h |    7 ++++-
 repair/agbtree.c         |    6 +---
 5 files changed, 72 insertions(+), 43 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index b0f9d9edb634..8f4b98080873 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -26,7 +26,6 @@
 
 #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
 #define xfs_allocbt_calc_size		libxfs_allocbt_calc_size
-#define xfs_allocbt_init_cursor		libxfs_allocbt_init_cursor
 #define xfs_allocbt_maxlevels_ondisk	libxfs_allocbt_maxlevels_ondisk
 #define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
 #define xfs_allocbt_stage_cursor	libxfs_allocbt_stage_cursor
@@ -60,6 +59,8 @@
 #define xfs_bmbt_stage_cursor		libxfs_bmbt_stage_cursor
 #define xfs_bmdr_maxrecs		libxfs_bmdr_maxrecs
 
+#define xfs_bnobt_init_cursor		libxfs_bnobt_init_cursor
+
 #define xfs_btree_bload			libxfs_btree_bload
 #define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
@@ -78,6 +79,7 @@
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_bwrite			libxfs_bwrite
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
+#define xfs_cntbt_init_cursor		libxfs_cntbt_init_cursor
 #define xfs_compute_rextslog		libxfs_compute_rextslog
 #define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
 #define xfs_da_get_buf			libxfs_da_get_buf
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index b7690dfde8cc..599271e5c22e 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -858,8 +858,8 @@ xfs_alloc_cur_setup(
 	 * attempt a small allocation.
 	 */
 	if (!acur->cnt)
-		acur->cnt = xfs_allocbt_init_cursor(args->mp, args->tp,
-					args->agbp, args->pag, XFS_BTNUM_CNT);
+		acur->cnt = xfs_cntbt_init_cursor(args->mp, args->tp,
+					args->agbp, args->pag);
 	error = xfs_alloc_lookup_ge(acur->cnt, 0, args->maxlen, &i);
 	if (error)
 		return error;
@@ -868,11 +868,11 @@ xfs_alloc_cur_setup(
 	 * Allocate the bnobt left and right search cursors.
 	 */
 	if (!acur->bnolt)
-		acur->bnolt = xfs_allocbt_init_cursor(args->mp, args->tp,
-					args->agbp, args->pag, XFS_BTNUM_BNO);
+		acur->bnolt = xfs_bnobt_init_cursor(args->mp, args->tp,
+					args->agbp, args->pag);
 	if (!acur->bnogt)
-		acur->bnogt = xfs_allocbt_init_cursor(args->mp, args->tp,
-					args->agbp, args->pag, XFS_BTNUM_BNO);
+		acur->bnogt = xfs_bnobt_init_cursor(args->mp, args->tp,
+					args->agbp, args->pag);
 	return i == 1 ? 0 : -ENOSPC;
 }
 
@@ -1230,8 +1230,8 @@ xfs_alloc_ag_vextent_exact(
 	/*
 	 * Allocate/initialize a cursor for the by-number freespace btree.
 	 */
-	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-					  args->pag, XFS_BTNUM_BNO);
+	bno_cur = xfs_bnobt_init_cursor(args->mp, args->tp, args->agbp,
+					  args->pag);
 
 	/*
 	 * Lookup bno and minlen in the btree (minlen is irrelevant, really).
@@ -1291,8 +1291,8 @@ xfs_alloc_ag_vextent_exact(
 	 * We are allocating agbno for args->len
 	 * Allocate/initialize a cursor for the by-size btree.
 	 */
-	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-					args->pag, XFS_BTNUM_CNT);
+	cnt_cur = xfs_cntbt_init_cursor(args->mp, args->tp, args->agbp,
+					args->pag);
 	ASSERT(args->agbno + args->len <= be32_to_cpu(agf->agf_length));
 	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen, args->agbno,
 				      args->len, XFSA_FIXUP_BNO_OK);
@@ -1706,8 +1706,8 @@ xfs_alloc_ag_vextent_size(
 	/*
 	 * Allocate and initialize a cursor for the by-size btree.
 	 */
-	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-					args->pag, XFS_BTNUM_CNT);
+	cnt_cur = xfs_cntbt_init_cursor(args->mp, args->tp, args->agbp,
+					args->pag);
 	bno_cur = NULL;
 
 	/*
@@ -1892,8 +1892,8 @@ xfs_alloc_ag_vextent_size(
 	/*
 	 * Allocate and initialize a cursor for the by-block tree.
 	 */
-	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-					args->pag, XFS_BTNUM_BNO);
+	bno_cur = xfs_bnobt_init_cursor(args->mp, args->tp, args->agbp,
+					args->pag);
 	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen,
 			rbno, rlen, XFSA_FIXUP_CNT_OK)))
 		goto error0;
@@ -1967,7 +1967,7 @@ xfs_free_ag_extent(
 	/*
 	 * Allocate and initialize a cursor for the by-block btree.
 	 */
-	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_BNO);
+	bno_cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
 	/*
 	 * Look for a neighboring block on the left (lower block numbers)
 	 * that is contiguous with this space.
@@ -2041,7 +2041,7 @@ xfs_free_ag_extent(
 	/*
 	 * Now allocate and initialize a cursor for the by-size tree.
 	 */
-	cnt_cur = xfs_allocbt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_CNT);
+	cnt_cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
 	/*
 	 * Have both left and right contiguous neighbors.
 	 * Merge all three into a single free block.
@@ -2750,8 +2750,8 @@ xfs_exact_minlen_extent_available(
 	xfs_extlen_t		flen;
 	int			error = 0;
 
-	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
-					args->pag, XFS_BTNUM_CNT);
+	cnt_cur = xfs_cntbt_init_cursor(args->mp, args->tp, agbp,
+					args->pag);
 	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
 	if (error)
 		goto out;
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 6ad44c14614d..b219dc6ac136 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -22,13 +22,22 @@
 static struct kmem_cache	*xfs_allocbt_cur_cache;
 
 STATIC struct xfs_btree_cur *
-xfs_allocbt_dup_cursor(
+xfs_bnobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
-	return xfs_allocbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_ag.agbp, cur->bc_ag.pag, cur->bc_btnum);
+	return xfs_bnobt_init_cursor(cur->bc_mp, cur->bc_tp, cur->bc_ag.agbp,
+			cur->bc_ag.pag);
 }
 
+STATIC struct xfs_btree_cur *
+xfs_cntbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_cntbt_init_cursor(cur->bc_mp, cur->bc_tp, cur->bc_ag.agbp,
+			cur->bc_ag.pag);
+}
+
+
 STATIC void
 xfs_allocbt_set_root(
 	struct xfs_btree_cur		*cur,
@@ -478,7 +487,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 	.statoff		= XFS_STATS_CALC_INDEX(xs_abtb_2),
 	.sick_mask		= XFS_SICK_AG_BNOBT,
 
-	.dup_cursor		= xfs_allocbt_dup_cursor,
+	.dup_cursor		= xfs_bnobt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
 	.free_block		= xfs_allocbt_free_block,
@@ -510,7 +519,7 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 	.statoff		= XFS_STATS_CALC_INDEX(xs_abtc_2),
 	.sick_mask		= XFS_SICK_AG_CNTBT,
 
-	.dup_cursor		= xfs_allocbt_dup_cursor,
+	.dup_cursor		= xfs_cntbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
 	.free_block		= xfs_allocbt_free_block,
@@ -530,36 +539,53 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 };
 
 /*
- * Allocate a new allocation btree cursor.
+ * Allocate a new bnobt cursor.
  *
  * For staging cursors tp and agbp are NULL.
  */
 struct xfs_btree_cur *
-xfs_allocbt_init_cursor(
+xfs_bnobt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag,
-	xfs_btnum_t		btnum)
+	struct xfs_perag	*pag)
 {
-	const struct xfs_btree_ops *ops = &xfs_bnobt_ops;
 	struct xfs_btree_cur	*cur;
 
-	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BNO, &xfs_bnobt_ops,
+			mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
+	cur->bc_ag.pag = xfs_perag_hold(pag);
+	cur->bc_ag.agbp = agbp;
+	if (agbp) {
+		struct xfs_agf		*agf = agbp->b_addr;
 
-	if (btnum == XFS_BTNUM_CNT)
-		ops = &xfs_cntbt_ops;
+		cur->bc_nlevels = be32_to_cpu(agf->agf_bno_level);
+	}
+	return cur;
+}
+
+/*
+ * Allocate a new cntbt cursor.
+ *
+ * For staging cursors tp and agbp are NULL.
+ */
+struct xfs_btree_cur *
+xfs_cntbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	struct xfs_perag	*pag)
+{
+	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum, ops, mp->m_alloc_maxlevels,
-			xfs_allocbt_cur_cache);
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_CNT, &xfs_cntbt_ops,
+			mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.agbp = agbp;
 	if (agbp) {
 		struct xfs_agf		*agf = agbp->b_addr;
 
-		cur->bc_nlevels = (btnum == XFS_BTNUM_BNO) ?
-			be32_to_cpu(agf->agf_bno_level) :
-			be32_to_cpu(agf->agf_cnt_level);
+		cur->bc_nlevels = be32_to_cpu(agf->agf_cnt_level);
 	}
 	return cur;
 }
diff --git a/libxfs/xfs_alloc_btree.h b/libxfs/xfs_alloc_btree.h
index 1c910862535f..155b47f231ab 100644
--- a/libxfs/xfs_alloc_btree.h
+++ b/libxfs/xfs_alloc_btree.h
@@ -47,9 +47,12 @@ struct xbtree_afakeroot;
 		 (maxrecs) * sizeof(xfs_alloc_key_t) + \
 		 ((index) - 1) * sizeof(xfs_alloc_ptr_t)))
 
-extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *mp,
+struct xfs_btree_cur *xfs_bnobt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *bp,
-		struct xfs_perag *pag, xfs_btnum_t btnum);
+		struct xfs_perag *pag);
+struct xfs_btree_cur *xfs_cntbt_init_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xfs_buf *bp,
+		struct xfs_perag *pag);
 extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
 extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
diff --git a/repair/agbtree.c b/repair/agbtree.c
index ab97c1d79ba1..bd7368be6523 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -262,12 +262,10 @@ init_freespace_cursors(
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, est_agfreeblocks, btr_bno);
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, est_agfreeblocks, btr_cnt);
 
-	btr_bno->cur = libxfs_allocbt_init_cursor(sc->mp, NULL, NULL, pag,
-			XFS_BTNUM_BNO);
+	btr_bno->cur = libxfs_bnobt_init_cursor(sc->mp, NULL, NULL, pag);
 	libxfs_btree_stage_afakeroot(btr_bno->cur, &btr_bno->newbt.afake);
 
-	btr_cnt->cur = libxfs_allocbt_init_cursor(sc->mp, NULL, NULL, pag,
-			XFS_BTNUM_CNT);
+	btr_cnt->cur = libxfs_cntbt_init_cursor(sc->mp, NULL, NULL, pag);
 	libxfs_btree_stage_afakeroot(btr_cnt->cur, &btr_cnt->newbt.afake);
 
 	btr_bno->bload.get_records = get_bnobt_records;


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AD721353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424833; cv=none; b=hic3Is7cN9LInAIJKLWr2lVFwkxgJlngKHMwN3rtjL02aZT/NTC7kN7fo7tSQ03TkkF0LZqIea5yFB2lHkkr7+If8SLoEKjxoF/u88tCi6yic0g4HPqqkB6931uTuSmwTuBQyfDIYRZlLlJvoI9qxpuVq/SjLw3fdW5LbFk7t+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424833; c=relaxed/simple;
	bh=9gOSxUu6uoxM0WbuKqhMpwMqqQiYy2JKv3Xf4EJAbHY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qv3ZLxMqFrZUTWEMmysDBgiNUJYUtVADcsP/yFCLiHT8CXuVvrwu/8gHrAzt4a4JMl0HMgGO9PHrsL5AXdkwP+kQafh0iYN2yfqzc4+9VXZ/R6zZeJ50sFWOtkddajN4mfwEKuULmaaiNGsTdx1L8ulaug68rJuqHocOgMEaS50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlPt4t6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlPt4t6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFF9C433C7;
	Tue, 26 Mar 2024 03:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424833;
	bh=9gOSxUu6uoxM0WbuKqhMpwMqqQiYy2JKv3Xf4EJAbHY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nlPt4t6+e8dMt6rk7SZOHUOn+mK/AyRDWC6Q1t8OE5CBWlc3cocDaJvXviC6LEhNV
	 roAhNR+lx2IWizSmXIGvQv/iy0TM1V+3yn0AdKexL/9tXyZpn+lpQlX/f8f+Ze37Y3
	 LK82iPfQo10XX9swEeXm6b1ezJdKZBrC60N/kaboU/DX2duKHYbTF6RcBtFc3XJFnw
	 V/HhjoAmK8Cn4wTYr9HPgHHfpSl29voMAHLJklM9Zxlc3Ce3/Za03LIwtp75w9OQMb
	 laiWwnOYjxB6+SCA6CBQjhTXRQVXKUWKuNMwl9hRmYlwrQDdAuqbnO+zsHwjLRD+EX
	 uv8wqbicfKFcg==
Date: Mon, 25 Mar 2024 20:47:12 -0700
Subject: [PATCH 072/110] xfs: split xfs_inobt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132417.2215168.5319398502566495322.stgit@frogsfrogsfrogs>
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

Source kernel commit: 14dd46cf31f4aaffcf26b00de9af39d01ec8d547

Split xfs_inobt_init_cursor into separate routines for the inobt and
finobt to prepare for the removal of the xfs_btnum global enumeration
of btree types.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h  |    1 +
 libxfs/xfs_ialloc.c       |   23 +++++++++++---------
 libxfs/xfs_ialloc_btree.c |   51 ++++++++++++++++++++++++++++++++++-----------
 libxfs/xfs_ialloc_btree.h |    6 ++++-
 repair/agbtree.c          |    6 ++---
 5 files changed, 58 insertions(+), 29 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 8f4b98080873..0e72944bc9aa 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -129,6 +129,7 @@
 #define xfs_dquot_verify		libxfs_dquot_verify
 
 #define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
+#define xfs_finobt_init_cursor		libxfs_finobt_init_cursor
 #define xfs_free_extent			libxfs_free_extent
 #define xfs_free_extent_later		libxfs_free_extent_later
 #define xfs_free_perag			libxfs_free_perag
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 4f3d7d4dcfef..37d014713db1 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -208,7 +208,10 @@ xfs_inobt_insert(
 	int			i;
 	int			error;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, btnum);
+	if (btnum == XFS_BTNUM_FINO)
+		cur = xfs_finobt_init_cursor(pag, tp, agbp);
+	else
+		cur = xfs_inobt_init_cursor(pag, tp, agbp);
 
 	for (thisino = newino;
 	     thisino < newino + newlen;
@@ -549,7 +552,7 @@ xfs_inobt_insert_sprec(
 	int				i;
 	struct xfs_inobt_rec_incore	rec;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp);
 
 	/* the new record is pre-aligned so we know where to look */
 	error = xfs_inobt_lookup(cur, nrec->ir_startino, XFS_LOOKUP_EQ, &i);
@@ -645,7 +648,7 @@ xfs_finobt_insert_sprec(
 	int				error;
 	int				i;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_FINO);
+	cur = xfs_finobt_init_cursor(pag, tp, agbp);
 
 	/* the new record is pre-aligned so we know where to look */
 	error = xfs_inobt_lookup(cur, nrec->ir_startino, XFS_LOOKUP_EQ, &i);
@@ -1078,7 +1081,7 @@ xfs_dialloc_ag_inobt(
 	ASSERT(pag->pagi_freecount > 0);
 
  restart_pagno:
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp);
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
 	 * This must work because we've just allocated some.
@@ -1552,7 +1555,7 @@ xfs_dialloc_ag(
 	if (!pagino)
 		pagino = be32_to_cpu(agi->agi_newino);
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_FINO);
+	cur = xfs_finobt_init_cursor(pag, tp, agbp);
 
 	error = xfs_check_agi_freecount(cur);
 	if (error)
@@ -1595,7 +1598,7 @@ xfs_dialloc_ag(
 	 * the original freecount. If all is well, make the equivalent update to
 	 * the inobt using the finobt record and offset information.
 	 */
-	icur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
+	icur = xfs_inobt_init_cursor(pag, tp, agbp);
 
 	error = xfs_check_agi_freecount(icur);
 	if (error)
@@ -2012,7 +2015,7 @@ xfs_difree_inobt(
 	/*
 	 * Initialize the cursor.
 	 */
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp);
 
 	error = xfs_check_agi_freecount(cur);
 	if (error)
@@ -2139,7 +2142,7 @@ xfs_difree_finobt(
 	int				error;
 	int				i;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_FINO);
+	cur = xfs_finobt_init_cursor(pag, tp, agbp);
 
 	error = xfs_inobt_lookup(cur, ibtrec->ir_startino, XFS_LOOKUP_EQ, &i);
 	if (error)
@@ -2339,7 +2342,7 @@ xfs_imap_lookup(
 	 * we have a record, we need to ensure it contains the inode number
 	 * we are looking up.
 	 */
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp);
 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
 	if (!error) {
 		if (i)
@@ -3058,7 +3061,7 @@ xfs_ialloc_check_shrink(
 	if (!xfs_has_sparseinodes(pag->pag_mount))
 		return 0;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agibp, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agibp);
 
 	/* Look up the inobt record that would correspond to the new EOFS. */
 	agino = XFS_AGB_TO_AGINO(pag->pag_mount, new_length);
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 609f62c65cea..2f095862e153 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -37,7 +37,15 @@ xfs_inobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_inobt_init_cursor(cur->bc_ag.pag, cur->bc_tp,
-			cur->bc_ag.agbp, cur->bc_btnum);
+			cur->bc_ag.agbp);
+}
+
+STATIC struct xfs_btree_cur *
+xfs_finobt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_finobt_init_cursor(cur->bc_ag.pag, cur->bc_tp,
+			cur->bc_ag.agbp);
 }
 
 STATIC void
@@ -440,7 +448,7 @@ const struct xfs_btree_ops xfs_finobt_ops = {
 	.statoff		= XFS_STATS_CALC_INDEX(xs_fibt_2),
 	.sick_mask		= XFS_SICK_AG_FINOBT,
 
-	.dup_cursor		= xfs_inobt_dup_cursor,
+	.dup_cursor		= xfs_finobt_dup_cursor,
 	.set_root		= xfs_finobt_set_root,
 	.alloc_block		= xfs_finobt_alloc_block,
 	.free_block		= xfs_finobt_free_block,
@@ -467,28 +475,45 @@ struct xfs_btree_cur *
 xfs_inobt_init_cursor(
 	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
+	struct xfs_buf		*agbp)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
-	const struct xfs_btree_ops *ops = &xfs_inobt_ops;
 	struct xfs_btree_cur	*cur;
 
-	ASSERT(btnum == XFS_BTNUM_INO || btnum == XFS_BTNUM_FINO);
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_INO, &xfs_inobt_ops,
+			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
+	cur->bc_ag.pag = xfs_perag_hold(pag);
+	cur->bc_ag.agbp = agbp;
+	if (agbp) {
+		struct xfs_agi		*agi = agbp->b_addr;
 
-	if (btnum == XFS_BTNUM_FINO)
-		ops = &xfs_finobt_ops;
+		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
+	}
+	return cur;
+}
+
+/*
+ * Create a free inode btree cursor.
+ *
+ * For staging cursors tp and agbp are NULL.
+ */
+struct xfs_btree_cur *
+xfs_finobt_init_cursor(
+	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum, ops,
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_FINO, &xfs_finobt_ops,
 			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.agbp = agbp;
 	if (agbp) {
 		struct xfs_agi		*agi = agbp->b_addr;
 
-		cur->bc_nlevels = (btnum == XFS_BTNUM_INO) ?
-			be32_to_cpu(agi->agi_level) :
-			be32_to_cpu(agi->agi_free_level);
+		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
 	}
 	return cur;
 }
@@ -723,7 +748,7 @@ xfs_finobt_count_blocks(
 	if (error)
 		return error;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_FINO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp);
 	error = xfs_btree_count_blocks(cur, tree_blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);
diff --git a/libxfs/xfs_ialloc_btree.h b/libxfs/xfs_ialloc_btree.h
index 2f1552d65655..6472ec1ecbb4 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -46,8 +46,10 @@ struct xfs_perag;
 		 (maxrecs) * sizeof(xfs_inobt_key_t) + \
 		 ((index) - 1) * sizeof(xfs_inobt_ptr_t)))
 
-extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_perag *pag,
-		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_btnum_t btnum);
+struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_perag *pag,
+		struct xfs_trans *tp, struct xfs_buf *agbp);
+struct xfs_btree_cur *xfs_finobt_init_cursor(struct xfs_perag *pag,
+		struct xfs_trans *tp, struct xfs_buf *agbp);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 /* ir_holemask to inode allocation bitmap conversion */
diff --git a/repair/agbtree.c b/repair/agbtree.c
index bd7368be6523..7d772715113e 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -522,8 +522,7 @@ init_ino_cursors(
 			fino_recs++;
 	}
 
-	btr_ino->cur = libxfs_inobt_init_cursor(pag, NULL, NULL,
-			XFS_BTNUM_INO);
+	btr_ino->cur = libxfs_inobt_init_cursor(pag, NULL, NULL);
 	libxfs_btree_stage_afakeroot(btr_ino->cur, &btr_ino->newbt.afake);
 
 	btr_ino->bload.get_records = get_inobt_records;
@@ -543,8 +542,7 @@ _("Unable to compute inode btree geometry, error %d.\n"), error);
 		return;
 
 	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, est_agfreeblocks, btr_fino);
-	btr_fino->cur = libxfs_inobt_init_cursor(pag, NULL, NULL,
-			XFS_BTNUM_FINO);
+	btr_fino->cur = libxfs_finobt_init_cursor(pag, NULL, NULL);
 	libxfs_btree_stage_afakeroot(btr_fino->cur, &btr_fino->newbt.afake);
 
 	btr_fino->bload.get_records = get_inobt_records;


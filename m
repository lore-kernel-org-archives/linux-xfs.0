Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B362E43AC7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817131; cv=none; b=gC+R9cTQ2vqRoCl59RdbKCR50epadqtF4p73H/a9Nh4X9RMd5JSfuq/UHUCyQYyErNgHfE56XeTdC+UJwjBpFgcUAQlTXBE1yaE2dx6lo2HGIACJ4M/Cu7DZU+appQKiWOIGzMO9TNW9AKL7KSahu10Pq2UP6JKFvXbN2Pz8dUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817131; c=relaxed/simple;
	bh=lE4wXXmPCLEt1cRFT/PT/jrcq8vBX5MdRoNWhTa08b0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U6Dk6jlyB2ZqOY4jd9ZuijB/X0ofzgAoAgQNs9PFvIx8Oix9oDbe+SNJb5m2Sk3j6I1Kf1/OmpGGiu6OS3LqFwthDs41wWGzl1HnyaUE3lxomniGUVBDYL/MEUi34YbjGyJIUVgXsgIEJ1gIlIUkKsGChx8kfz0JRyc+FUuZsE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J82PoAvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J82PoAvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3207FC43394;
	Thu,  1 Feb 2024 19:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817131;
	bh=lE4wXXmPCLEt1cRFT/PT/jrcq8vBX5MdRoNWhTa08b0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J82PoAvRsL1ctaG0+eLkLklkXATFclPkkDmbj2vZVepRIWD5CX+uJ+Um7WorRGEUq
	 Vb5oybD3zA4cQXyl4AO8Fi9hSvB6AxwcfoF99hEjAsYqKTBilpcbtWSZY4pfeiZ5fH
	 d7FO90x/wr1WZL6Rra/6P40YkUytBPUmSAAfu4s1fv06YB4ka+oJIp7bFqfF+Bw7AM
	 DnuDicCc15AjyU0EbGt77Q4cu8V0RbzatPUkqItaGrnI4kaIwwUrLhcywyYEIi/80Y
	 eAtzXqr2J/+31OQmNIECKXkFztdQZlvSSHwOXCJfviGP2MGwY2PqFXJGLvnJCNphC8
	 eVxOZlrLE8XmQ==
Date: Thu, 01 Feb 2024 11:52:10 -0800
Subject: [PATCH 25/27] xfs: split xfs_inobt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335194.1605438.14503690812214716698.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
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

Split xfs_inobt_init_cursor into separate routines for the inobt and
finobt to prepare for the removal of the xfs_btnum global enumeration
of btree types.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c       |   23 ++++++++++-------
 fs/xfs/libxfs/xfs_ialloc_btree.c |   51 ++++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_ialloc_btree.h |    6 +++-
 fs/xfs/scrub/agheader_repair.c   |    5 +---
 fs/xfs/scrub/common.c            |    8 +++---
 fs/xfs/scrub/ialloc_repair.c     |    5 +---
 fs/xfs/scrub/iscan.c             |    2 +
 fs/xfs/scrub/repair.c            |    6 ++--
 fs/xfs/scrub/rmap.c              |    7 ++---
 fs/xfs/xfs_iwalk.c               |    5 +---
 10 files changed, 72 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 17a53f635c9fb..03af7a729980b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -213,7 +213,10 @@ xfs_inobt_insert(
 	int			i;
 	int			error;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, btnum);
+	if (btnum == XFS_BTNUM_FINO)
+		cur = xfs_finobt_init_cursor(pag, tp, agbp);
+	else
+		cur = xfs_inobt_init_cursor(pag, tp, agbp);
 
 	for (thisino = newino;
 	     thisino < newino + newlen;
@@ -554,7 +557,7 @@ xfs_inobt_insert_sprec(
 	int				i;
 	struct xfs_inobt_rec_incore	rec;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp);
 
 	/* the new record is pre-aligned so we know where to look */
 	error = xfs_inobt_lookup(cur, nrec->ir_startino, XFS_LOOKUP_EQ, &i);
@@ -650,7 +653,7 @@ xfs_finobt_insert_sprec(
 	int				error;
 	int				i;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_FINO);
+	cur = xfs_finobt_init_cursor(pag, tp, agbp);
 
 	/* the new record is pre-aligned so we know where to look */
 	error = xfs_inobt_lookup(cur, nrec->ir_startino, XFS_LOOKUP_EQ, &i);
@@ -1083,7 +1086,7 @@ xfs_dialloc_ag_inobt(
 	ASSERT(pag->pagi_freecount > 0);
 
  restart_pagno:
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp);
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
 	 * This must work because we've just allocated some.
@@ -1557,7 +1560,7 @@ xfs_dialloc_ag(
 	if (!pagino)
 		pagino = be32_to_cpu(agi->agi_newino);
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_FINO);
+	cur = xfs_finobt_init_cursor(pag, tp, agbp);
 
 	error = xfs_check_agi_freecount(cur);
 	if (error)
@@ -1600,7 +1603,7 @@ xfs_dialloc_ag(
 	 * the original freecount. If all is well, make the equivalent update to
 	 * the inobt using the finobt record and offset information.
 	 */
-	icur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
+	icur = xfs_inobt_init_cursor(pag, tp, agbp);
 
 	error = xfs_check_agi_freecount(icur);
 	if (error)
@@ -2017,7 +2020,7 @@ xfs_difree_inobt(
 	/*
 	 * Initialize the cursor.
 	 */
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp);
 
 	error = xfs_check_agi_freecount(cur);
 	if (error)
@@ -2144,7 +2147,7 @@ xfs_difree_finobt(
 	int				error;
 	int				i;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_FINO);
+	cur = xfs_finobt_init_cursor(pag, tp, agbp);
 
 	error = xfs_inobt_lookup(cur, ibtrec->ir_startino, XFS_LOOKUP_EQ, &i);
 	if (error)
@@ -2344,7 +2347,7 @@ xfs_imap_lookup(
 	 * we have a record, we need to ensure it contains the inode number
 	 * we are looking up.
 	 */
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp);
 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
 	if (!error) {
 		if (i)
@@ -3063,7 +3066,7 @@ xfs_ialloc_check_shrink(
 	if (!xfs_has_sparseinodes(pag->pag_mount))
 		return 0;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agibp, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agibp);
 
 	/* Look up the inobt record that would correspond to the new EOFS. */
 	agino = XFS_AGB_TO_AGINO(pag->pag_mount, new_length);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index c920aee4a7daf..9cb5da9be9044 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -38,7 +38,15 @@ xfs_inobt_dup_cursor(
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
@@ -441,7 +449,7 @@ const struct xfs_btree_ops xfs_finobt_ops = {
 	.statoff		= XFS_STATS_CALC_INDEX(xs_fibt_2),
 	.sick_mask		= XFS_SICK_AG_FINOBT,
 
-	.dup_cursor		= xfs_inobt_dup_cursor,
+	.dup_cursor		= xfs_finobt_dup_cursor,
 	.set_root		= xfs_finobt_set_root,
 	.alloc_block		= xfs_finobt_alloc_block,
 	.free_block		= xfs_finobt_free_block,
@@ -468,28 +476,45 @@ struct xfs_btree_cur *
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
@@ -724,7 +749,7 @@ xfs_finobt_count_blocks(
 	if (error)
 		return error;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_FINO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp);
 	error = xfs_btree_count_blocks(cur, tree_blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 2f1552d656559..6472ec1ecbb45 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
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
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index e2374d05bdd1f..427054b65b238 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -894,7 +894,7 @@ xrep_agi_calc_from_btrees(
 	xfs_agino_t		freecount;
 	int			error;
 
-	cur = xfs_inobt_init_cursor(sc->sa.pag, sc->tp, agi_bp, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(sc->sa.pag, sc->tp, agi_bp);
 	error = xfs_ialloc_count_inodes(cur, &count, &freecount);
 	if (error)
 		goto err;
@@ -914,8 +914,7 @@ xrep_agi_calc_from_btrees(
 	if (xfs_has_finobt(mp) && xfs_has_inobtcounts(mp)) {
 		xfs_agblock_t	blocks;
 
-		cur = xfs_inobt_init_cursor(sc->sa.pag, sc->tp, agi_bp,
-				XFS_BTNUM_FINO);
+		cur = xfs_finobt_init_cursor(sc->sa.pag, sc->tp, agi_bp);
 		error = xfs_btree_count_blocks(cur, &blocks);
 		if (error)
 			goto err;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 1233a5604c72b..70746a7db9545 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -620,15 +620,15 @@ xchk_ag_btcur_init(
 
 	if (sa->agi_bp) {
 		/* Set up a inobt cursor for cross-referencing. */
-		sa->ino_cur = xfs_inobt_init_cursor(sa->pag, sc->tp, sa->agi_bp,
-				XFS_BTNUM_INO);
+		sa->ino_cur = xfs_inobt_init_cursor(sa->pag, sc->tp,
+				sa->agi_bp);
 		xchk_ag_btree_del_cursor_if_sick(sc, &sa->ino_cur,
 				XFS_SCRUB_TYPE_INOBT);
 
 		/* Set up a finobt cursor for cross-referencing. */
 		if (xfs_has_finobt(mp)) {
-			sa->fino_cur = xfs_inobt_init_cursor(sa->pag, sc->tp,
-					sa->agi_bp, XFS_BTNUM_FINO);
+			sa->fino_cur = xfs_finobt_init_cursor(sa->pag, sc->tp,
+					sa->agi_bp);
 			xchk_ag_btree_del_cursor_if_sick(sc, &sa->fino_cur,
 					XFS_SCRUB_TYPE_FINOBT);
 		}
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index 04e186d8c7386..a00ec7ae17925 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -663,7 +663,7 @@ xrep_ibt_build_new_trees(
 	ri->new_inobt.bload.claim_block = xrep_ibt_claim_block;
 	ri->new_inobt.bload.get_records = xrep_ibt_get_records;
 
-	ino_cur = xfs_inobt_init_cursor(sc->sa.pag, NULL, NULL, XFS_BTNUM_INO);
+	ino_cur = xfs_inobt_init_cursor(sc->sa.pag, NULL, NULL);
 	xfs_btree_stage_afakeroot(ino_cur, &ri->new_inobt.afake);
 	error = xfs_btree_bload_compute_geometry(ino_cur, &ri->new_inobt.bload,
 			xfarray_length(ri->inode_records));
@@ -684,8 +684,7 @@ xrep_ibt_build_new_trees(
 		ri->new_finobt.bload.claim_block = xrep_fibt_claim_block;
 		ri->new_finobt.bload.get_records = xrep_fibt_get_records;
 
-		fino_cur = xfs_inobt_init_cursor(sc->sa.pag, NULL, NULL,
-				XFS_BTNUM_FINO);
+		fino_cur = xfs_finobt_init_cursor(sc->sa.pag, NULL, NULL);
 		xfs_btree_stage_afakeroot(fino_cur, &ri->new_finobt.afake);
 		error = xfs_btree_bload_compute_geometry(fino_cur,
 				&ri->new_finobt.bload, ri->finobt_recs);
diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index 17af89b519b3f..ec3478bc505ef 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -113,7 +113,7 @@ xchk_iscan_find_next(
 	 * Look up the inode chunk for the current cursor position.  If there
 	 * is no chunk here, we want the next one.
 	 */
-	cur = xfs_inobt_init_cursor(pag, tp, agi_bp, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agi_bp);
 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &has_rec);
 	if (!error && !has_rec)
 		error = xfs_btree_increment(cur, 0, &has_rec);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 078d21598db55..d1a21f380abe9 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -842,10 +842,10 @@ xrep_ag_btcur_init(
 	if (sc->sm->sm_type != XFS_SCRUB_TYPE_INOBT &&
 	    sc->sm->sm_type != XFS_SCRUB_TYPE_FINOBT) {
 		sa->ino_cur = xfs_inobt_init_cursor(sc->sa.pag, sc->tp,
-				sa->agi_bp, XFS_BTNUM_INO);
+				sa->agi_bp);
 		if (xfs_has_finobt(mp))
-			sa->fino_cur = xfs_inobt_init_cursor(sc->sa.pag,
-					sc->tp, sa->agi_bp, XFS_BTNUM_FINO);
+			sa->fino_cur = xfs_finobt_init_cursor(sc->sa.pag,
+					sc->tp, sa->agi_bp);
 	}
 
 	/* Set up a rmapbt cursor for cross-referencing. */
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index e0550e0185849..5afe6650ed6c7 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -447,8 +447,7 @@ xchk_rmapbt_walk_ag_metadata(
 	/* OWN_INOBT: inobt, finobt */
 	cur = sc->sa.ino_cur;
 	if (!cur)
-		cur = xfs_inobt_init_cursor(sc->sa.pag, sc->tp, sc->sa.agi_bp,
-				XFS_BTNUM_INO);
+		cur = xfs_inobt_init_cursor(sc->sa.pag, sc->tp, sc->sa.agi_bp);
 	error = xagb_bitmap_set_btblocks(&cr->inobt_owned, cur);
 	if (cur != sc->sa.ino_cur)
 		xfs_btree_del_cursor(cur, error);
@@ -458,8 +457,8 @@ xchk_rmapbt_walk_ag_metadata(
 	if (xfs_has_finobt(sc->mp)) {
 		cur = sc->sa.fino_cur;
 		if (!cur)
-			cur = xfs_inobt_init_cursor(sc->sa.pag, sc->tp,
-					sc->sa.agi_bp, XFS_BTNUM_FINO);
+			cur = xfs_finobt_init_cursor(sc->sa.pag, sc->tp,
+					sc->sa.agi_bp);
 		error = xagb_bitmap_set_btblocks(&cr->inobt_owned, cur);
 		if (cur != sc->sa.fino_cur)
 			xfs_btree_del_cursor(cur, error);
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index bab4825e259bf..a36f01b4e23d7 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -269,7 +269,7 @@ xfs_iwalk_ag_start(
 	error = xfs_ialloc_read_agi(pag, tp, agi_bpp);
 	if (error)
 		return error;
-	*curpp = xfs_inobt_init_cursor(pag, tp, *agi_bpp, XFS_BTNUM_INO);
+	*curpp = xfs_inobt_init_cursor(pag, tp, *agi_bpp);
 
 	/* Starting at the beginning of the AG?  That's easy! */
 	if (agino == 0)
@@ -387,8 +387,7 @@ xfs_iwalk_run_callbacks(
 	error = xfs_ialloc_read_agi(iwag->pag, iwag->tp, agi_bpp);
 	if (error)
 		return error;
-	*curpp = xfs_inobt_init_cursor(iwag->pag, iwag->tp, *agi_bpp,
-			XFS_BTNUM_INO);
+	*curpp = xfs_inobt_init_cursor(iwag->pag, iwag->tp, *agi_bpp);
 	return xfs_inobt_lookup(*curpp, next_agino, XFS_LOOKUP_GE, has_more);
 }
 


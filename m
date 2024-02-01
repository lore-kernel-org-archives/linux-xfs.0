Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F517C6C1
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817053; cv=none; b=eTlApEQi3CGUnnDpwtnyeJJhWRIagwTYVb4wSBtRpeul/kfZTSwgAL5VFTiFYEiFlvbOFRG+01DfJwQqJxA3kcHaIxiVs/LKbqAGyGjY2mdbWo10dqJQ0oSwsOfjq+oRp0pn9xvYBGyPPnWC6lwShrT4ehAy1F1dn3HPzKH5F2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817053; c=relaxed/simple;
	bh=uv5boWiJhCgBDpHCElwwafAmbel64wnIDtUDonDdN5M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L5UgKG/UDEFIU0IdrqsrZ0BzC62/FaZtUv0S0l9daGFaF0JiMyREx57dm8Ln8sg9gG643A3MzpHZjdoSqzuRnKQIMBOL0RdZrIlqHmJreqX9FsCWRyP4cIXG9KXi605U7Ua29oRZi8TVE41YKFNE/tkjQH55OxAuh8jvC/smB/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBk6/nDm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBk6/nDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E531C433F1;
	Thu,  1 Feb 2024 19:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817053;
	bh=uv5boWiJhCgBDpHCElwwafAmbel64wnIDtUDonDdN5M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UBk6/nDm9dKjzoLDXBEFvfqVMuJxDGzwCUmgJtkrdEJQxL//+1z45WhsRixirZe0x
	 neLFOujqcbRGuOahiqFFpxSQ48ICORlQxH6vddyznuhXnh6BRsaNKTU7Sp44eiFsZy
	 NzXwLw3FPKq2CRGbJ/YM5D6PDADDYURLl/MxsdtB5kLmfe/YYUQrkQqxJJjCSuQw+n
	 arH60cbUhMAoN17cBv/2qRQmeOJqKycyq1NdR/h0CTucFRZ/1nvWllgmX6U188eguV
	 IKRQF/a25uNNCRAjdkx1CQwgsomfCTTTS9CDmEiKmY3DLvDT1WcYaFI6I5yrkb1dQ1
	 4NGv+ycQ+DhPw==
Date: Thu, 01 Feb 2024 11:50:52 -0800
Subject: [PATCH 20/27] xfs: split xfs_allocbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335113.1605438.17431164157824228591.stgit@frogsfrogsfrogs>
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

Split xfs_allocbt_init_cursor into separate routines for the by-bno
and by-cnt btrees to prepare for the removal of the xfs_btnum global
enumeration of btree types.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c       |   36 +++++++++++------------
 fs/xfs/libxfs/xfs_alloc_btree.c |   62 ++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_alloc_btree.h |    7 +++-
 fs/xfs/scrub/agheader_repair.c  |   12 +++-----
 fs/xfs/scrub/alloc_repair.c     |    6 +---
 fs/xfs/scrub/common.c           |    8 +++--
 fs/xfs/scrub/repair.c           |    8 +++--
 fs/xfs/scrub/rmap.c             |    8 +++--
 fs/xfs/xfs_discard.c            |    2 +
 fs/xfs/xfs_fsmap.c              |    4 +--
 10 files changed, 88 insertions(+), 65 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 44d4f0da90bad..2b74aded4a2c7 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -862,8 +862,8 @@ xfs_alloc_cur_setup(
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
@@ -872,11 +872,11 @@ xfs_alloc_cur_setup(
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
 
@@ -1234,8 +1234,8 @@ xfs_alloc_ag_vextent_exact(
 	/*
 	 * Allocate/initialize a cursor for the by-number freespace btree.
 	 */
-	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-					  args->pag, XFS_BTNUM_BNO);
+	bno_cur = xfs_bnobt_init_cursor(args->mp, args->tp, args->agbp,
+					  args->pag);
 
 	/*
 	 * Lookup bno and minlen in the btree (minlen is irrelevant, really).
@@ -1295,8 +1295,8 @@ xfs_alloc_ag_vextent_exact(
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
@@ -1710,8 +1710,8 @@ xfs_alloc_ag_vextent_size(
 	/*
 	 * Allocate and initialize a cursor for the by-size btree.
 	 */
-	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-					args->pag, XFS_BTNUM_CNT);
+	cnt_cur = xfs_cntbt_init_cursor(args->mp, args->tp, args->agbp,
+					args->pag);
 	bno_cur = NULL;
 
 	/*
@@ -1896,8 +1896,8 @@ xfs_alloc_ag_vextent_size(
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
@@ -1971,7 +1971,7 @@ xfs_free_ag_extent(
 	/*
 	 * Allocate and initialize a cursor for the by-block btree.
 	 */
-	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_BNO);
+	bno_cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
 	/*
 	 * Look for a neighboring block on the left (lower block numbers)
 	 * that is contiguous with this space.
@@ -2045,7 +2045,7 @@ xfs_free_ag_extent(
 	/*
 	 * Now allocate and initialize a cursor for the by-size tree.
 	 */
-	cnt_cur = xfs_allocbt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_CNT);
+	cnt_cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
 	/*
 	 * Have both left and right contiguous neighbors.
 	 * Merge all three into a single free block.
@@ -2754,8 +2754,8 @@ xfs_exact_minlen_extent_available(
 	xfs_extlen_t		flen;
 	int			error = 0;
 
-	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
-					args->pag, XFS_BTNUM_CNT);
+	cnt_cur = xfs_cntbt_init_cursor(args->mp, args->tp, agbp,
+					args->pag);
 	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
 	if (error)
 		goto out;
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index e0b0cdd8f344c..7228634642897 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -24,13 +24,22 @@
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
@@ -480,7 +489,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 	.statoff		= XFS_STATS_CALC_INDEX(xs_abtb_2),
 	.sick_mask		= XFS_SICK_AG_BNOBT,
 
-	.dup_cursor		= xfs_allocbt_dup_cursor,
+	.dup_cursor		= xfs_bnobt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
 	.free_block		= xfs_allocbt_free_block,
@@ -512,7 +521,7 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 	.statoff		= XFS_STATS_CALC_INDEX(xs_abtc_2),
 	.sick_mask		= XFS_SICK_AG_CNTBT,
 
-	.dup_cursor		= xfs_allocbt_dup_cursor,
+	.dup_cursor		= xfs_cntbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
 	.free_block		= xfs_allocbt_free_block,
@@ -532,36 +541,53 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
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
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index 1c910862535f7..155b47f231ab2 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
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
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index e4dd4fe84c5f9..e2374d05bdd1f 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -255,8 +255,7 @@ xrep_agf_calc_from_btrees(
 	int			error;
 
 	/* Update the AGF counters from the bnobt. */
-	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp,
-			sc->sa.pag, XFS_BTNUM_BNO);
+	cur = xfs_bnobt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
 	error = xfs_alloc_query_all(cur, xrep_agf_walk_allocbt, &raa);
 	if (error)
 		goto err;
@@ -269,8 +268,7 @@ xrep_agf_calc_from_btrees(
 	agf->agf_longest = cpu_to_be32(raa.longest);
 
 	/* Update the AGF counters from the cntbt. */
-	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp,
-			sc->sa.pag, XFS_BTNUM_CNT);
+	cur = xfs_cntbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
 	error = xfs_btree_count_blocks(cur, &blocks);
 	if (error)
 		goto err;
@@ -549,16 +547,14 @@ xrep_agfl_collect_blocks(
 		goto out_bmp;
 
 	/* Find all blocks currently being used by the bnobt. */
-	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp,
-			sc->sa.pag, XFS_BTNUM_BNO);
+	cur = xfs_bnobt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
 	error = xagb_bitmap_set_btblocks(&ra.agmetablocks, cur);
 	xfs_btree_del_cursor(cur, error);
 	if (error)
 		goto out_bmp;
 
 	/* Find all blocks currently being used by the cntbt. */
-	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp,
-			sc->sa.pag, XFS_BTNUM_CNT);
+	cur = xfs_cntbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
 	error = xagb_bitmap_set_btblocks(&ra.agmetablocks, cur);
 	xfs_btree_del_cursor(cur, error);
 	if (error)
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 0ef27aacbf25c..d421b253923ed 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -735,12 +735,10 @@ xrep_abt_build_new_trees(
 	ra->new_cntbt.bload.claim_block = xrep_abt_claim_block;
 
 	/* Allocate cursors for the staged btrees. */
-	bno_cur = xfs_allocbt_init_cursor(sc->mp, NULL, NULL, pag,
-			XFS_BTNUM_BNO);
+	bno_cur = xfs_bnobt_init_cursor(sc->mp, NULL, NULL, pag);
 	xfs_btree_stage_afakeroot(bno_cur, &ra->new_bnobt.afake);
 
-	cnt_cur = xfs_allocbt_init_cursor(sc->mp, NULL, NULL, pag,
-			XFS_BTNUM_CNT);
+	cnt_cur = xfs_cntbt_init_cursor(sc->mp, NULL, NULL, pag);
 	xfs_btree_stage_afakeroot(cnt_cur, &ra->new_cntbt.afake);
 
 	/* Last chance to abort before we start committing fixes. */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 689d40578bd5b..1233a5604c72b 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -590,14 +590,14 @@ xchk_ag_btcur_init(
 
 	if (sa->agf_bp) {
 		/* Set up a bnobt cursor for cross-referencing. */
-		sa->bno_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
-				sa->pag, XFS_BTNUM_BNO);
+		sa->bno_cur = xfs_bnobt_init_cursor(mp, sc->tp, sa->agf_bp,
+				sa->pag);
 		xchk_ag_btree_del_cursor_if_sick(sc, &sa->bno_cur,
 				XFS_SCRUB_TYPE_BNOBT);
 
 		/* Set up a cntbt cursor for cross-referencing. */
-		sa->cnt_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
-				sa->pag, XFS_BTNUM_CNT);
+		sa->cnt_cur = xfs_cntbt_init_cursor(mp, sc->tp, sa->agf_bp,
+				sa->pag);
 		xchk_ag_btree_del_cursor_if_sick(sc, &sa->cnt_cur,
 				XFS_SCRUB_TYPE_CNTBT);
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index ab510cea96d86..078d21598db55 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -832,10 +832,10 @@ xrep_ag_btcur_init(
 	/* Set up a bnobt cursor for cross-referencing. */
 	if (sc->sm->sm_type != XFS_SCRUB_TYPE_BNOBT &&
 	    sc->sm->sm_type != XFS_SCRUB_TYPE_CNTBT) {
-		sa->bno_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
-				sc->sa.pag, XFS_BTNUM_BNO);
-		sa->cnt_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
-				sc->sa.pag, XFS_BTNUM_CNT);
+		sa->bno_cur = xfs_bnobt_init_cursor(mp, sc->tp, sa->agf_bp,
+				sc->sa.pag);
+		sa->cnt_cur = xfs_cntbt_init_cursor(mp, sc->tp, sa->agf_bp,
+				sc->sa.pag);
 	}
 
 	/* Set up a inobt cursor for cross-referencing. */
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index c99d1714f283b..e0550e0185849 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -412,8 +412,8 @@ xchk_rmapbt_walk_ag_metadata(
 	/* OWN_AG: bnobt, cntbt, rmapbt, and AGFL */
 	cur = sc->sa.bno_cur;
 	if (!cur)
-		cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
-				sc->sa.pag, XFS_BTNUM_BNO);
+		cur = xfs_bnobt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+				sc->sa.pag);
 	error = xagb_bitmap_set_btblocks(&cr->ag_owned, cur);
 	if (cur != sc->sa.bno_cur)
 		xfs_btree_del_cursor(cur, error);
@@ -422,8 +422,8 @@ xchk_rmapbt_walk_ag_metadata(
 
 	cur = sc->sa.cnt_cur;
 	if (!cur)
-		cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
-				sc->sa.pag, XFS_BTNUM_CNT);
+		cur = xfs_cntbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+				sc->sa.pag);
 	error = xagb_bitmap_set_btblocks(&cr->ag_owned, cur);
 	if (cur != sc->sa.cnt_cur)
 		xfs_btree_del_cursor(cur, error);
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index e38c4c46d1275..de0ee6de92fa2 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -173,7 +173,7 @@ xfs_trim_gather_extents(
 	if (error)
 		return error;
 
-	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
+	cur = xfs_cntbt_init_cursor(mp, NULL, agbp, pag);
 
 	/*
 	 * Look up the extent length requested in the AGF and start with it.
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 5a72217f5feb9..de59eec747657 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -763,8 +763,8 @@ xfs_getfsmap_datadev_bnobt_query(
 		return xfs_getfsmap_datadev_bnobt_helper(*curpp, &key[1], info);
 
 	/* Allocate cursor for this AG and query_range it. */
-	*curpp = xfs_allocbt_init_cursor(tp->t_mountp, tp, info->agf_bp,
-			info->pag, XFS_BTNUM_BNO);
+	*curpp = xfs_bnobt_init_cursor(tp->t_mountp, tp, info->agf_bp,
+			info->pag);
 	key->ar_startblock = info->low.rm_startblock;
 	key[1].ar_startblock = info->high.rm_startblock;
 	return xfs_alloc_query_range(*curpp, key, &key[1],


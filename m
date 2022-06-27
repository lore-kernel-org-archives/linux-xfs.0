Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6A4C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 00:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiF0ASq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 20:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiF0ASo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 20:18:44 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A27492BF1
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 17:18:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8ECF510E77AD
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 10:18:36 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSZ-00BTVJ-21
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 10:18:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSZ-000uAv-0l
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 10:18:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/14] xfs: pass perag to xfs_alloc_read_agf()
Date:   Mon, 27 Jun 2022 10:18:23 +1000
Message-Id: <20220627001832.215779-6-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627001832.215779-1-david@fromorbit.com>
References: <20220627001832.215779-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62b8f75c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=DT-L6bsfT1kNlZdnF-gA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_alloc_read_agf() initialises the perag if it hasn't been done
yet, so it makes sense to pass it the perag rather than pull a
reference from the buffer. This allows callers to be per-ag centric
rather than passing mount/agno pairs everywhere.

Whilst modifying the xfs_reflink_find_shared() function definition,
declare it static and remove the extern declaration as it is an
internal function only these days.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c             | 20 ++++++---------
 fs/xfs/libxfs/xfs_ag_resv.c        |  2 +-
 fs/xfs/libxfs/xfs_alloc.c          | 31 +++++++++++------------
 fs/xfs/libxfs/xfs_alloc.h          | 13 ++--------
 fs/xfs/libxfs/xfs_bmap.c           |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c         |  2 +-
 fs/xfs/libxfs/xfs_refcount.c       |  6 ++---
 fs/xfs/libxfs/xfs_refcount_btree.c |  2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  2 +-
 fs/xfs/scrub/agheader_repair.c     |  6 ++---
 fs/xfs/scrub/bmap.c                |  2 +-
 fs/xfs/scrub/common.c              |  2 +-
 fs/xfs/scrub/fscounters.c          |  2 +-
 fs/xfs/scrub/repair.c              |  5 ++--
 fs/xfs/xfs_discard.c               |  2 +-
 fs/xfs/xfs_extfree_item.c          |  6 ++++-
 fs/xfs/xfs_filestream.c            |  2 +-
 fs/xfs/xfs_fsmap.c                 |  3 +--
 fs/xfs/xfs_reflink.c               | 40 ++++++++++++++++--------------
 fs/xfs/xfs_reflink.h               |  3 ---
 20 files changed, 70 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 2ed15839fb3e..1fa172501b3d 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -120,16 +120,13 @@ xfs_initialize_perag_data(
 
 	for (index = 0; index < agcount; index++) {
 		/*
-		 * read the agf, then the agi. This gets us
-		 * all the information we need and populates the
-		 * per-ag structures for us.
+		 * Read the AGF and AGI buffers to populate the per-ag
+		 * structures for us.
 		 */
-		error = xfs_alloc_read_agf(mp, NULL, index, 0, NULL);
-		if (error)
-			return error;
-
 		pag = xfs_perag_get(mp, index);
-		error = xfs_ialloc_read_agi(pag, NULL, NULL);
+		error = xfs_alloc_read_agf(pag, NULL, 0, NULL);
+		if (!error)
+			error = xfs_ialloc_read_agi(pag, NULL, NULL);
 		if (error) {
 			xfs_perag_put(pag);
 			return error;
@@ -792,7 +789,7 @@ xfs_ag_shrink_space(
 
 	agi = agibp->b_addr;
 
-	error = xfs_alloc_read_agf(mp, *tpp, pag->pag_agno, 0, &agfbp);
+	error = xfs_alloc_read_agf(pag, *tpp, 0, &agfbp);
 	if (error)
 		return error;
 
@@ -910,7 +907,7 @@ xfs_ag_extend_space(
 	/*
 	 * Change agf length.
 	 */
-	error = xfs_alloc_read_agf(pag->pag_mount, tp, pag->pag_agno, 0, &bp);
+	error = xfs_alloc_read_agf(pag, tp, 0, &bp);
 	if (error)
 		return error;
 
@@ -953,8 +950,7 @@ xfs_ag_get_geometry(
 	error = xfs_ialloc_read_agi(pag, NULL, &agi_bp);
 	if (error)
 		return error;
-	error = xfs_alloc_read_agf(pag->pag_mount, NULL, pag->pag_agno, 0,
-			&agf_bp);
+	error = xfs_alloc_read_agf(pag, NULL, 0, &agf_bp);
 	if (error)
 		goto out_agi;
 
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index ce28bf8f72dc..5af123d13a63 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -322,7 +322,7 @@ xfs_ag_resv_init(
 	 * address.
 	 */
 	if (has_resv) {
-		error2 = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, NULL);
+		error2 = xfs_alloc_read_agf(pag, tp, 0, NULL);
 		if (error2)
 			return error2;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f7853ab7b962..6912c4efc61e 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2609,7 +2609,7 @@ xfs_alloc_fix_freelist(
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	if (!pag->pagf_init) {
-		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
+		error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
 		if (error) {
 			/* Couldn't lock the AGF so skip this AG. */
 			if (error == -EAGAIN)
@@ -2639,7 +2639,7 @@ xfs_alloc_fix_freelist(
 	 * Can fail if we're not blocking on locks, and it's held.
 	 */
 	if (!agbp) {
-		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
+		error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
 		if (error) {
 			/* Couldn't lock the AGF so skip this AG. */
 			if (error == -EAGAIN)
@@ -3080,34 +3080,30 @@ xfs_read_agf(
  * perag structure if necessary. If the caller provides @agfbpp, then return the
  * locked buffer to the caller, otherwise free it.
  */
-int					/* error */
+int
 xfs_alloc_read_agf(
-	struct xfs_mount	*mp,	/* mount point structure */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_agnumber_t		agno,	/* allocation group number */
-	int			flags,	/* XFS_ALLOC_FLAG_... */
+	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
+	int			flags,
 	struct xfs_buf		**agfbpp)
 {
 	struct xfs_buf		*agfbp;
-	struct xfs_agf		*agf;		/* ag freelist header */
-	struct xfs_perag	*pag;		/* per allocation group data */
+	struct xfs_agf		*agf;
 	int			error;
 	int			allocbt_blks;
 
-	trace_xfs_alloc_read_agf(mp, agno);
+	trace_xfs_alloc_read_agf(pag->pag_mount, pag->pag_agno);
 
 	/* We don't support trylock when freeing. */
 	ASSERT((flags & (XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK)) !=
 			(XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK));
-	ASSERT(agno != NULLAGNUMBER);
-	error = xfs_read_agf(mp, tp, agno,
+	error = xfs_read_agf(pag->pag_mount, tp, pag->pag_agno,
 			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
 			&agfbp);
 	if (error)
 		return error;
 
 	agf = agfbp->b_addr;
-	pag = agfbp->b_pag;
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
 		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
@@ -3121,7 +3117,7 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
 		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 		pag->pagf_init = 1;
-		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
+		pag->pagf_agflreset = xfs_agfl_needs_reset(pag->pag_mount, agf);
 
 		/*
 		 * Update the in-core allocbt counter. Filter out the rmapbt
@@ -3131,13 +3127,14 @@ xfs_alloc_read_agf(
 		 * counter only tracks non-root blocks.
 		 */
 		allocbt_blks = pag->pagf_btreeblks;
-		if (xfs_has_rmapbt(mp))
+		if (xfs_has_rmapbt(pag->pag_mount))
 			allocbt_blks -= be32_to_cpu(agf->agf_rmap_blocks) - 1;
 		if (allocbt_blks > 0)
-			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
+			atomic64_add(allocbt_blks,
+					&pag->pag_mount->m_allocbt_blks);
 	}
 #ifdef DEBUG
-	else if (!xfs_is_shutdown(mp)) {
+	else if (!xfs_is_shutdown(pag->pag_mount)) {
 		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
 		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
 		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 96d5301a5c8b..b8cf5beb26d4 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -134,17 +134,6 @@ xfs_alloc_put_freelist(
 	xfs_agblock_t	bno,	/* block being freed */
 	int		btreeblk); /* owner was a AGF btree */
 
-/*
- * Read in the allocation group header (free/alloc section).
- */
-int					/* error  */
-xfs_alloc_read_agf(
-	struct xfs_mount *mp,		/* mount point structure */
-	struct xfs_trans *tp,		/* transaction pointer */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	int		flags,		/* XFS_ALLOC_FLAG_... */
-	struct xfs_buf	**bpp);		/* buffer for the ag freelist header */
-
 /*
  * Allocate an extent (variable-size).
  */
@@ -198,6 +187,8 @@ xfs_alloc_get_rec(
 
 int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
+int xfs_alloc_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
+		struct xfs_buf **agfbpp);
 int xfs_alloc_read_agfl(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, struct xfs_buf **bpp);
 int xfs_free_agfl_block(struct xfs_trans *, xfs_agnumber_t, xfs_agblock_t,
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a76d5894641b..88828fcf0453 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3185,7 +3185,7 @@ xfs_bmap_longest_free_extent(
 
 	pag = xfs_perag_get(mp, ag);
 	if (!pag->pagf_init) {
-		error = xfs_alloc_read_agf(mp, tp, ag, XFS_ALLOC_FLAG_TRYLOCK,
+		error = xfs_alloc_read_agf(pag, tp, XFS_ALLOC_FLAG_TRYLOCK,
 				NULL);
 		if (error) {
 			/* Couldn't lock the AGF, so skip this AG. */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 8e252207b131..dfa8061f65d9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1621,7 +1621,7 @@ xfs_dialloc_good_ag(
 		return false;
 
 	if (!pag->pagf_init) {
-		error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, flags, NULL);
+		error = xfs_alloc_read_agf(pag, tp, flags, NULL);
 		if (error)
 			return false;
 	}
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 97e9e6020596..098dac888c22 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1177,8 +1177,8 @@ xfs_refcount_finish_one(
 		*pcur = NULL;
 	}
 	if (rcur == NULL) {
-		error = xfs_alloc_read_agf(tp->t_mountp, tp, pag->pag_agno,
-				XFS_ALLOC_FLAG_FREEING, &agbp);
+		error = xfs_alloc_read_agf(pag, tp, XFS_ALLOC_FLAG_FREEING,
+				&agbp);
 		if (error)
 			goto out_drop;
 
@@ -1710,7 +1710,7 @@ xfs_refcount_recover_cow_leftovers(
 	if (error)
 		return error;
 
-	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
+	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
 	if (error)
 		goto out_trans;
 	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index d14c1720b0fb..1063234df34a 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -493,7 +493,7 @@ xfs_refcountbt_calc_reserves(
 	if (!xfs_has_reflink(mp))
 		return 0;
 
-	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
+	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 69e104d0277f..d6d45992fe7b 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -652,7 +652,7 @@ xfs_rmapbt_calc_reserves(
 	if (!xfs_has_rmapbt(mp))
 		return 0;
 
-	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
+	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 6da7f2ca77de..230bdfe36e80 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -666,8 +666,7 @@ xrep_agfl(
 	 * nothing wrong with the AGF, but all the AG header repair functions
 	 * have this chicken-and-egg problem.
 	 */
-	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.pag->pag_agno, 0,
-			&agf_bp);
+	error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &agf_bp);
 	if (error)
 		return error;
 
@@ -742,8 +741,7 @@ xrep_agi_find_btrees(
 	int				error;
 
 	/* Read the AGF. */
-	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.pag->pag_agno, 0,
-			&agf_bp);
+	error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &agf_bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 285995ba3947..9353fd060525 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -540,7 +540,7 @@ xchk_bmap_check_ag_rmaps(
 	struct xfs_buf			*agf;
 	int				error;
 
-	error = xfs_alloc_read_agf(sc->mp, sc->tp, pag->pag_agno, 0, &agf);
+	error = xfs_alloc_read_agf(pag, sc->tp, 0, &agf);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 62997791694a..cd7d4ebd240b 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -420,7 +420,7 @@ xchk_ag_read_headers(
 	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGI))
 		return error;
 
-	error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &sa->agf_bp);
+	error = xfs_alloc_read_agf(sa->pag, sc->tp, 0, &sa->agf_bp);
 	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGF))
 		return error;
 
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index bd06a184c81c..6a6f8fe7f87c 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -81,7 +81,7 @@ xchk_fscount_warmup(
 		error = xfs_ialloc_read_agi(pag, sc->tp, &agi_bp);
 		if (error)
 			break;
-		error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
+		error = xfs_alloc_read_agf(pag, sc->tp, 0, &agf_bp);
 		if (error)
 			break;
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 14acf1df3dd3..1c66f7ee6282 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -207,7 +207,7 @@ xrep_calc_ag_resblks(
 	}
 
 	/* Now grab the block counters from the AGF. */
-	error = xfs_alloc_read_agf(mp, NULL, sm->sm_agno, 0, &bp);
+	error = xfs_alloc_read_agf(pag, NULL, 0, &bp);
 	if (error) {
 		aglen = xfs_ag_block_count(mp, sm->sm_agno);
 		freelen = aglen;
@@ -543,6 +543,7 @@ xrep_reap_block(
 
 	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
 	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
+	ASSERT(agno == sc->sa.pag->pag_agno);
 
 	/*
 	 * If we are repairing per-inode metadata, we need to read in the AGF
@@ -550,7 +551,7 @@ xrep_reap_block(
 	 * the AGF buffer that the setup functions already grabbed.
 	 */
 	if (sc->ip) {
-		error = xfs_alloc_read_agf(sc->mp, sc->tp, agno, 0, &agf_bp);
+		error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &agf_bp);
 		if (error)
 			return error;
 	} else {
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index c6fe3f6ebb6b..bfc829c07f03 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -45,7 +45,7 @@ xfs_trim_extents(
 	 */
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
-	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	error = xfs_alloc_read_agf(pag, NULL, 0, &agbp);
 	if (error)
 		goto out_put_perag;
 	agf = agbp->b_addr;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 765be054dffe..0d0a0b37d8c5 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -11,6 +11,7 @@
 #include "xfs_bit.h"
 #include "xfs_shared.h"
 #include "xfs_mount.h"
+#include "xfs_ag.h"
 #include "xfs_defer.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
@@ -551,6 +552,7 @@ xfs_agfl_free_finish_item(
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	uint				next_extent;
+	struct xfs_perag		*pag;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
 	ASSERT(free->xefi_blockcount == 1);
@@ -560,9 +562,11 @@ xfs_agfl_free_finish_item(
 
 	trace_xfs_agfl_free_deferred(mp, agno, 0, agbno, free->xefi_blockcount);
 
-	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	pag = xfs_perag_get(mp, agno);
+	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
 	if (!error)
 		error = xfs_free_agfl_block(tp, agno, agbno, agbp, &oinfo);
+	xfs_perag_put(pag);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 6b09a30f8d06..34b21a29c39b 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -126,7 +126,7 @@ xfs_filestream_pick_ag(
 		pag = xfs_perag_get(mp, ag);
 
 		if (!pag->pagf_init) {
-			err = xfs_alloc_read_agf(mp, NULL, ag, trylock, NULL);
+			err = xfs_alloc_read_agf(pag, NULL, trylock, NULL);
 			if (err) {
 				if (err != -EAGAIN) {
 					xfs_perag_put(pag);
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index bb23199f65c3..d8337274c74d 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -642,8 +642,7 @@ __xfs_getfsmap_datadev(
 			info->agf_bp = NULL;
 		}
 
-		error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0,
-				&info->agf_bp);
+		error = xfs_alloc_read_agf(pag, tp, 0, &info->agf_bp);
 		if (error)
 			break;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e7a7c00d93be..81994f4706de 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -125,11 +125,10 @@
  * shared blocks.  If there are no shared extents, fbno and flen will
  * be set to NULLAGBLOCK and 0, respectively.
  */
-int
+static int
 xfs_reflink_find_shared(
-	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen,
 	xfs_agblock_t		*fbno,
@@ -140,11 +139,11 @@ xfs_reflink_find_shared(
 	struct xfs_btree_cur	*cur;
 	int			error;
 
-	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
 	if (error)
 		return error;
 
-	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agbp->b_pag);
+	cur = xfs_refcountbt_init_cursor(pag->pag_mount, tp, agbp, pag);
 
 	error = xfs_refcount_find_shared(cur, agbno, aglen, fbno, flen,
 			find_end_of_shared);
@@ -171,7 +170,8 @@ xfs_reflink_trim_around_shared(
 	struct xfs_bmbt_irec	*irec,
 	bool			*shared)
 {
-	xfs_agnumber_t		agno;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
 	xfs_agblock_t		agbno;
 	xfs_extlen_t		aglen;
 	xfs_agblock_t		fbno;
@@ -186,12 +186,13 @@ xfs_reflink_trim_around_shared(
 
 	trace_xfs_reflink_trim_around_shared(ip, irec);
 
-	agno = XFS_FSB_TO_AGNO(ip->i_mount, irec->br_startblock);
-	agbno = XFS_FSB_TO_AGBNO(ip->i_mount, irec->br_startblock);
+	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, irec->br_startblock));
+	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
 	aglen = irec->br_blockcount;
 
-	error = xfs_reflink_find_shared(ip->i_mount, NULL, agno, agbno,
-			aglen, &fbno, &flen, true);
+	error = xfs_reflink_find_shared(pag, NULL, agbno, aglen, &fbno, &flen,
+			true);
+	xfs_perag_put(pag);
 	if (error)
 		return error;
 
@@ -1420,11 +1421,6 @@ xfs_reflink_inode_has_shared_extents(
 	struct xfs_bmbt_irec		got;
 	struct xfs_mount		*mp = ip->i_mount;
 	struct xfs_ifork		*ifp;
-	xfs_agnumber_t			agno;
-	xfs_agblock_t			agbno;
-	xfs_extlen_t			aglen;
-	xfs_agblock_t			rbno;
-	xfs_extlen_t			rlen;
 	struct xfs_iext_cursor		icur;
 	bool				found;
 	int				error;
@@ -1437,17 +1433,25 @@ xfs_reflink_inode_has_shared_extents(
 	*has_shared = false;
 	found = xfs_iext_lookup_extent(ip, ifp, 0, &icur, &got);
 	while (found) {
+		struct xfs_perag	*pag;
+		xfs_agblock_t		agbno;
+		xfs_extlen_t		aglen;
+		xfs_agblock_t		rbno;
+		xfs_extlen_t		rlen;
+
 		if (isnullstartblock(got.br_startblock) ||
 		    got.br_state != XFS_EXT_NORM)
 			goto next;
-		agno = XFS_FSB_TO_AGNO(mp, got.br_startblock);
+
+		pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, got.br_startblock));
 		agbno = XFS_FSB_TO_AGBNO(mp, got.br_startblock);
 		aglen = got.br_blockcount;
-
-		error = xfs_reflink_find_shared(mp, tp, agno, agbno, aglen,
+		error = xfs_reflink_find_shared(pag, tp, agbno, aglen,
 				&rbno, &rlen, false);
+		xfs_perag_put(pag);
 		if (error)
 			return error;
+
 		/* Is there still a shared block here? */
 		if (rbno != NULLAGBLOCK) {
 			*has_shared = true;
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index bea65f2fe657..65c5dfe17ecf 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -16,9 +16,6 @@ static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
 	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
 }
 
-extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
-		xfs_agnumber_t agno, xfs_agblock_t agbno, xfs_extlen_t aglen,
-		xfs_agblock_t *fbno, xfs_extlen_t *flen, bool find_maximal);
 extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared);
 int xfs_bmap_trim_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
-- 
2.36.1


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5D7C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349505AbhLCAEl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:04:41 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:35151 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243809AbhLCAEk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:40 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 07852869D23
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:15 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00G1K9-CM
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:14 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00Bkgb-Am
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/36] xfs: pass perag to xfs_alloc_read_agf()
Date:   Fri,  3 Dec 2021 11:00:40 +1100
Message-Id: <20211203000111.2800982-6-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61a95e4c
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=DT-L6bsfT1kNlZdnF-gA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_alloc_read_agf() initialises the perag if it hasn't been done
yet, so it makes sense to pass it the perag rather than pull a
reference from the buffer. This allows callers to be per-ag centric
rather than passing mount/agno pairs everywhere.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c             | 19 +++++++--------
 fs/xfs/libxfs/xfs_ag_resv.c        |  2 +-
 fs/xfs/libxfs/xfs_alloc.c          | 30 ++++++++++-------------
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
 fs/xfs/xfs_reflink.c               | 38 +++++++++++++++++-------------
 fs/xfs/xfs_reflink.h               |  3 ---
 20 files changed, 68 insertions(+), 81 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index a782b9e584e4..a357ac6bc4ad 100644
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
@@ -793,7 +790,7 @@ xfs_ag_shrink_space(
 
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
 
@@ -953,7 +950,7 @@ xfs_ag_get_geometry(
 	error = xfs_ialloc_read_agi(pag, NULL, &agi_bp);
 	if (error)
 		return error;
-	error = xfs_alloc_read_agf(pag->pag_mount, NULL, pag->pag_agno, 0, &agf_bp);
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
index faa8f7a1ecf8..a8f032e49fcd 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2591,7 +2591,7 @@ xfs_alloc_fix_freelist(
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	if (!pag->pagf_init) {
-		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
+		error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
 		if (error) {
 			/* Couldn't lock the AGF so skip this AG. */
 			if (error == -EAGAIN)
@@ -2621,7 +2621,7 @@ xfs_alloc_fix_freelist(
 	 * Can fail if we're not blocking on locks, and it's held.
 	 */
 	if (!agbp) {
-		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
+		error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
 		if (error) {
 			/* Couldn't lock the AGF so skip this AG. */
 			if (error == -EAGAIN)
@@ -3062,34 +3062,30 @@ xfs_read_agf(
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
@@ -3103,7 +3099,7 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
 		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 		pag->pagf_init = 1;
-		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
+		pag->pagf_agflreset = xfs_agfl_needs_reset(pag->pag_mount, agf);
 
 		/*
 		 * Update the in-core allocbt counter. Filter out the rmapbt
@@ -3113,13 +3109,13 @@ xfs_alloc_read_agf(
 		 * counter only tracks non-root blocks.
 		 */
 		allocbt_blks = pag->pagf_btreeblks;
-		if (xfs_has_rmapbt(mp))
+		if (xfs_has_rmapbt(pag->pag_mount))
 			allocbt_blks -= be32_to_cpu(agf->agf_rmap_blocks) - 1;
 		if (allocbt_blks > 0)
-			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
+			atomic64_add(allocbt_blks, &pag->pag_mount->m_allocbt_blks);
 	}
 #ifdef DEBUG
-	else if (!xfs_is_shutdown(mp)) {
+	else if (!xfs_is_shutdown(pag->pag_mount)) {
 		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
 		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
 		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 76dd3b8b6971..bdf7c1a75057 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -135,17 +135,6 @@ xfs_alloc_put_freelist(
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
@@ -199,6 +188,8 @@ xfs_alloc_get_rec(
 
 int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
+int xfs_alloc_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
+		struct xfs_buf **agfbpp);
 int xfs_alloc_read_agfl(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, struct xfs_buf **bpp);
 int xfs_free_agfl_block(struct xfs_trans *, xfs_agnumber_t, xfs_agblock_t,
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8924b3749e6a..ec856466ed40 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3187,7 +3187,7 @@ xfs_bmap_longest_free_extent(
 
 	pag = xfs_perag_get(mp, ag);
 	if (!pag->pagf_init) {
-		error = xfs_alloc_read_agf(mp, tp, ag, XFS_ALLOC_FLAG_TRYLOCK,
+		error = xfs_alloc_read_agf(pag, tp, XFS_ALLOC_FLAG_TRYLOCK,
 				NULL);
 		if (error) {
 			/* Couldn't lock the AGF, so skip this AG. */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 22edd49cfe81..f2d02231a9e4 100644
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
index 327ba25e9e17..e90a02391906 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1173,8 +1173,8 @@ xfs_refcount_finish_one(
 		*pcur = NULL;
 	}
 	if (rcur == NULL) {
-		error = xfs_alloc_read_agf(tp->t_mountp, tp, pag->pag_agno,
-				XFS_ALLOC_FLAG_FREEING, &agbp);
+		error = xfs_alloc_read_agf(pag, tp, XFS_ALLOC_FLAG_FREEING,
+				&agbp);
 		if (error)
 			goto out_drop;
 
@@ -1706,7 +1706,7 @@ xfs_refcount_recover_cow_leftovers(
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
index d7bfed52f4cd..24cc8c0a9d80 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -654,8 +654,7 @@ xrep_agfl(
 	 * nothing wrong with the AGF, but all the AG header repair functions
 	 * have this chicken-and-egg problem.
 	 */
-	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.pag->pag_agno, 0,
-			&agf_bp);
+	error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &agf_bp);
 	if (error)
 		return error;
 
@@ -730,8 +729,7 @@ xrep_agi_find_btrees(
 	int				error;
 
 	/* Read the AGF. */
-	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.pag->pag_agno, 0,
-			&agf_bp);
+	error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &agf_bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index a4cbbc346f60..570f0076ef2e 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -556,7 +556,7 @@ xchk_bmap_check_ag_rmaps(
 	struct xfs_buf			*agf;
 	int				error;
 
-	error = xfs_alloc_read_agf(sc->mp, sc->tp, pag->pag_agno, 0, &agf);
+	error = xfs_alloc_read_agf(pag, sc->tp, 0, &agf);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 068489030bbb..73f3d729d7f5 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -418,7 +418,7 @@ xchk_ag_read_headers(
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
index 333ee7d7b753..06b41321f425 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -206,7 +206,7 @@ xrep_calc_ag_resblks(
 	}
 
 	/* Now grab the block counters from the AGF. */
-	error = xfs_alloc_read_agf(mp, NULL, sm->sm_agno, 0, &bp);
+	error = xfs_alloc_read_agf(pag, NULL, 0, &bp);
 	if (error) {
 		aglen = xfs_ag_block_count(mp, sm->sm_agno);
 		freelen = aglen;
@@ -542,6 +542,7 @@ xrep_reap_block(
 
 	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
 	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
+	ASSERT(agno == sc->sa.pag->pag_agno);
 
 	/*
 	 * If we are repairing per-inode metadata, we need to read in the AGF
@@ -549,7 +550,7 @@ xrep_reap_block(
 	 * the AGF buffer that the setup functions already grabbed.
 	 */
 	if (sc->ip) {
-		error = xfs_alloc_read_agf(sc->mp, sc->tp, agno, 0, &agf_bp);
+		error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &agf_bp);
 		if (error)
 			return error;
 	} else {
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 0191de8ce9ce..ccec28c914cd 100644
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
index 47ef9c9c5c17..4358ec6e2309 100644
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
@@ -541,6 +542,7 @@ xfs_agfl_free_finish_item(
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	uint				next_extent;
+	struct xfs_perag		*pag;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
 	ASSERT(free->xefi_blockcount == 1);
@@ -550,9 +552,11 @@ xfs_agfl_free_finish_item(
 
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
index e82185aa13f8..fe7a809e230c 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -126,7 +126,7 @@ xfs_filestream_pick_ag(
 		pag = xfs_perag_get(mp, ag);
 
 		if (!pag->pagf_init) {
-			err = xfs_alloc_read_agf(mp, NULL, ag, trylock, NULL);
+			err = xfs_alloc_read_agf(pag, NULL, trylock, NULL);
 			if (err) {
 				xfs_perag_put(pag);
 				if (err != -EAGAIN)
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 48287caad28b..9424b5a22d5e 100644
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
index cb0edb1d68ef..d8281b002dff 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -127,9 +127,8 @@
  */
 int
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
 
@@ -1385,11 +1386,6 @@ xfs_reflink_inode_has_shared_extents(
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
@@ -1402,17 +1398,25 @@ xfs_reflink_inode_has_shared_extents(
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
2.33.0


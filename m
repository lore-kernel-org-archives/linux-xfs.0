Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908BDC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 00:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FB0D60FE6
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 00:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhHLA70 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 20:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhHLA7Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Aug 2021 20:59:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D775601FD;
        Thu, 12 Aug 2021 00:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628729941;
        bh=oBfToJxgfkYG7xSu0IGuRElWY9nTdSCkShB4sPcEsuE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O4tchlBcZ9RjHWScnIR25sY0N7VEyBCvhx9Knx6gecqJXXmPu7Nvgwh4HaiJPawx4
         wkzX4OQfaRvGvokLSPOBpCv5PN5j/m4SJ2XXuXelxNjP4dzxOis8CNfadtqpEEV8Lj
         NizxQ13SA1p1dfd3kv8lC+J0BbG4/5xMhSRe0SADevJhBUizjFc78YYXNhlQpWNhbE
         T+EWkDWHjg9/rX3GwSj8ZR6eH9O7REXQYGVctvLllKouDupRN/69sUStLmUAyAp0+c
         MJnNlCo6RFtvFBqJymP7+GYfozhX3k+bdvxVb9GXIGk/l2uaEpsb5nft71JbcJaLAX
         C3YBBCeuu/Z7Q==
Subject: [PATCH 1/2] xfs: remove unnecessary agno variable from struct xchk_ag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 11 Aug 2021 17:59:00 -0700
Message-ID: <162872994071.1220748.13299032445442241616.stgit@magnolia>
In-Reply-To: <162872993519.1220748.15526308019664551101.stgit@magnolia>
References: <162872993519.1220748.15526308019664551101.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we always grab an active reference to a perag structure when
dealing with perag metadata, we can remove this unnecessary variable.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c        |    2 +-
 fs/xfs/scrub/agheader_repair.c |   34 +++++++++++++++++++++-------------
 fs/xfs/scrub/common.c          |    3 ---
 fs/xfs/scrub/repair.c          |   18 +++++++++---------
 fs/xfs/scrub/scrub.c           |    3 ---
 fs/xfs/scrub/scrub.h           |    1 -
 6 files changed, 31 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 6152ce01c057..efd8b5a9f6b2 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -640,7 +640,7 @@ xchk_agfl_block(
 {
 	struct xchk_agfl_info	*sai = priv;
 	struct xfs_scrub	*sc = sai->sc;
-	xfs_agnumber_t		agno = sc->sa.agno;
+	xfs_agnumber_t		agno = sc->sa.pag->pag_agno;
 
 	if (xfs_verify_agbno(mp, agno, agbno) &&
 	    sai->nr_entries < sai->sz_entries)
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index f122f2e20e79..87da9bca8e57 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -94,7 +94,7 @@ xrep_agf_check_agfl_block(
 {
 	struct xfs_scrub	*sc = priv;
 
-	if (!xfs_verify_agbno(mp, sc->sa.agno, agbno))
+	if (!xfs_verify_agbno(mp, sc->sa.pag->pag_agno, agbno))
 		return -EFSCORRUPTED;
 	return 0;
 }
@@ -188,8 +188,9 @@ xrep_agf_init_header(
 	memset(agf, 0, BBTOB(agf_bp->b_length));
 	agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
 	agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
-	agf->agf_seqno = cpu_to_be32(sc->sa.agno);
-	agf->agf_length = cpu_to_be32(xfs_ag_block_count(mp, sc->sa.agno));
+	agf->agf_seqno = cpu_to_be32(sc->sa.pag->pag_agno);
+	agf->agf_length = cpu_to_be32(xfs_ag_block_count(mp,
+							sc->sa.pag->pag_agno));
 	agf->agf_flfirst = old_agf->agf_flfirst;
 	agf->agf_fllast = old_agf->agf_fllast;
 	agf->agf_flcount = old_agf->agf_flcount;
@@ -371,7 +372,8 @@ xrep_agf(
 	 * was corrupt after xfs_alloc_read_agf failed with -EFSCORRUPTED.
 	 */
 	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGF_DADDR(mp)),
+			XFS_AG_DADDR(mp, sc->sa.pag->pag_agno,
+						XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &agf_bp, NULL);
 	if (error)
 		return error;
@@ -387,7 +389,7 @@ xrep_agf(
 	 * btrees rooted in the AGF.  If the AGFL contents are obviously bad
 	 * then we'll bail out.
 	 */
-	error = xfs_alloc_read_agfl(mp, sc->tp, sc->sa.agno, &agfl_bp);
+	error = xfs_alloc_read_agfl(mp, sc->tp, sc->sa.pag->pag_agno, &agfl_bp);
 	if (error)
 		return error;
 
@@ -585,7 +587,7 @@ xrep_agfl_init_header(
 	agfl = XFS_BUF_TO_AGFL(agfl_bp);
 	memset(agfl, 0xFF, BBTOB(agfl_bp->b_length));
 	agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
-	agfl->agfl_seqno = cpu_to_be32(sc->sa.agno);
+	agfl->agfl_seqno = cpu_to_be32(sc->sa.pag->pag_agno);
 	uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
 
 	/*
@@ -598,7 +600,8 @@ xrep_agfl_init_header(
 	for_each_xbitmap_extent(br, n, agfl_extents) {
 		agbno = XFS_FSB_TO_AGBNO(mp, br->start);
 
-		trace_xrep_agfl_insert(mp, sc->sa.agno, agbno, br->len);
+		trace_xrep_agfl_insert(mp, sc->sa.pag->pag_agno, agbno,
+				br->len);
 
 		while (br->len > 0 && fl_off < flcount) {
 			agfl_bno[fl_off] = cpu_to_be32(agbno);
@@ -647,7 +650,8 @@ xrep_agfl(
 	 * nothing wrong with the AGF, but all the AG header repair functions
 	 * have this chicken-and-egg problem.
 	 */
-	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.agno, 0, &agf_bp);
+	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.pag->pag_agno, 0,
+			&agf_bp);
 	if (error)
 		return error;
 
@@ -656,7 +660,8 @@ xrep_agfl(
 	 * was corrupt after xfs_alloc_read_agfl failed with -EFSCORRUPTED.
 	 */
 	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGFL_DADDR(mp)),
+			XFS_AG_DADDR(mp, sc->sa.pag->pag_agno,
+						XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &agfl_bp, NULL);
 	if (error)
 		return error;
@@ -721,7 +726,8 @@ xrep_agi_find_btrees(
 	int				error;
 
 	/* Read the AGF. */
-	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.agno, 0, &agf_bp);
+	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.pag->pag_agno, 0,
+			&agf_bp);
 	if (error)
 		return error;
 
@@ -759,8 +765,9 @@ xrep_agi_init_header(
 	memset(agi, 0, BBTOB(agi_bp->b_length));
 	agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
 	agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
-	agi->agi_seqno = cpu_to_be32(sc->sa.agno);
-	agi->agi_length = cpu_to_be32(xfs_ag_block_count(mp, sc->sa.agno));
+	agi->agi_seqno = cpu_to_be32(sc->sa.pag->pag_agno);
+	agi->agi_length = cpu_to_be32(xfs_ag_block_count(mp,
+							sc->sa.pag->pag_agno));
 	agi->agi_newino = cpu_to_be32(NULLAGINO);
 	agi->agi_dirino = cpu_to_be32(NULLAGINO);
 	if (xfs_sb_version_hascrc(&mp->m_sb))
@@ -899,7 +906,8 @@ xrep_agi(
 	 * was corrupt after xfs_ialloc_read_agi failed with -EFSCORRUPTED.
 	 */
 	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGI_DADDR(mp)),
+			XFS_AG_DADDR(mp, sc->sa.pag->pag_agno,
+						XFS_AGI_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &agi_bp, NULL);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 0ef96ed71017..691cf243c2c9 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -414,8 +414,6 @@ xchk_ag_read_headers(
 	if (!sa->pag)
 		return -ENOENT;
 
-	sa->agno = agno;
-
 	error = xfs_ialloc_read_agi(mp, sc->tp, agno, &sa->agi_bp);
 	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGI))
 		return error;
@@ -531,7 +529,6 @@ xchk_ag_free(
 		xfs_perag_put(sa->pag);
 		sa->pag = NULL;
 	}
-	sa->agno = NULLAGNUMBER;
 }
 
 /*
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index ebb0e245aa72..7431e181d001 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -306,9 +306,9 @@ xrep_alloc_ag_block(
 			return -ENOSPC;
 		xfs_extent_busy_reuse(sc->mp, sc->sa.pag, bno,
 				1, false);
-		*fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, bno);
+		*fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno, bno);
 		if (resv == XFS_AG_RESV_RMAPBT)
-			xfs_ag_resv_rmapbt_alloc(sc->mp, sc->sa.agno);
+			xfs_ag_resv_rmapbt_alloc(sc->mp, sc->sa.pag->pag_agno);
 		return 0;
 	default:
 		break;
@@ -317,7 +317,7 @@ xrep_alloc_ag_block(
 	args.tp = sc->tp;
 	args.mp = sc->mp;
 	args.oinfo = *oinfo;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, sc->sa.agno, 0);
+	args.fsbno = XFS_AGB_TO_FSB(args.mp, sc->sa.pag->pag_agno, 0);
 	args.minlen = 1;
 	args.maxlen = 1;
 	args.prod = 1;
@@ -352,14 +352,14 @@ xrep_init_btblock(
 	trace_xrep_init_btblock(mp, XFS_FSB_TO_AGNO(mp, fsb),
 			XFS_FSB_TO_AGBNO(mp, fsb), btnum);
 
-	ASSERT(XFS_FSB_TO_AGNO(mp, fsb) == sc->sa.agno);
+	ASSERT(XFS_FSB_TO_AGNO(mp, fsb) == sc->sa.pag->pag_agno);
 	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(mp, fsb), XFS_FSB_TO_BB(mp, 1), 0,
 			&bp);
 	if (error)
 		return error;
 	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
-	xfs_btree_init_block(mp, bp, btnum, 0, 0, sc->sa.agno);
+	xfs_btree_init_block(mp, bp, btnum, 0, 0, sc->sa.pag->pag_agno);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
 	xfs_trans_log_buf(tp, bp, 0, BBTOB(bp->b_length) - 1);
 	bp->b_ops = ops;
@@ -481,7 +481,7 @@ xrep_fix_freelist(
 
 	args.mp = sc->mp;
 	args.tp = sc->tp;
-	args.agno = sc->sa.agno;
+	args.agno = sc->sa.pag->pag_agno;
 	args.alignment = 1;
 	args.pag = sc->sa.pag;
 
@@ -615,7 +615,7 @@ xrep_reap_extents(
 
 	for_each_xbitmap_block(fsbno, bmr, n, bitmap) {
 		ASSERT(sc->ip != NULL ||
-		       XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.agno);
+		       XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.pag->pag_agno);
 		trace_xrep_dispose_btree_extent(sc->mp,
 				XFS_FSB_TO_AGNO(sc->mp, fsbno),
 				XFS_FSB_TO_AGBNO(sc->mp, fsbno), 1);
@@ -690,7 +690,7 @@ xrep_findroot_block(
 	int				block_level;
 	int				error = 0;
 
-	daddr = XFS_AGB_TO_DADDR(mp, ri->sc->sa.agno, agbno);
+	daddr = XFS_AGB_TO_DADDR(mp, ri->sc->sa.pag->pag_agno, agbno);
 
 	/*
 	 * Blocks in the AGFL have stale contents that might just happen to
@@ -819,7 +819,7 @@ xrep_findroot_block(
 	else
 		fab->root = NULLAGBLOCK;
 
-	trace_xrep_findroot_block(mp, ri->sc->sa.agno, agbno,
+	trace_xrep_findroot_block(mp, ri->sc->sa.pag->pag_agno, agbno,
 			be32_to_cpu(btblock->bb_magic), fab->height - 1);
 out:
 	xfs_trans_brelse(ri->sc->tp, bp);
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 0e542636227c..1c65df8628ad 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -464,9 +464,6 @@ xfs_scrub_metadata(
 	struct xfs_scrub		sc = {
 		.file			= file,
 		.sm			= sm,
-		.sa			= {
-			.agno		= NULLAGNUMBER,
-		},
 	};
 	struct xfs_mount		*mp = XFS_I(file_inode(file))->i_mount;
 	int				error = 0;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 08a483cb46e2..c711637d0d06 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -35,7 +35,6 @@ struct xchk_meta_ops {
 
 /* Buffer pointers and btree cursors for an entire AG. */
 struct xchk_ag {
-	xfs_agnumber_t		agno;
 	struct xfs_perag	*pag;
 
 	/* AG btree roots */


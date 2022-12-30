Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6A3C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbiLaAD6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbiLaAD5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:03:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77601E3CE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:03:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 922FAB81DB1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429EBC433EF;
        Sat, 31 Dec 2022 00:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445034;
        bh=yvW4pc7ok3eLpbzjQOPtkUuUCw6iyxUyAByG+RQsiaU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=B8UfCvoEatbg128vz3Z5z44ncH9/1oP04RJ4rwoAOXrIeikr8BWeqzQn+z8XLfBxH
         H6P7lH/8+gzTnGUvmQaiT5pHuwVEQjV7rP0AFrk7dZVHbSeTV9zC+RveSHe1iHEypi
         ej4TThbqCxj55nKSHMJJfURXD5yNif577PZ/0rYtK5cq1Z4gRvYzyYAqw8qnaE9zvW
         ExxxmenD3oyf2cwTE3ZPBQ1LmP5yyR8vB/AlccRQMURjgh+TURkB0Y1eGFHOc5S0jj
         n5aYWqO/xFzFpWLmeOAKJvtqYRMOx6GcfyWpiZ6gjuJoZgB/MtatqY9v0a+fgoJo6Q
         RDT/ceDit0f2g==
Subject: [PATCH 3/4] xfs: hoist AGI repair context to a heap object
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:29 -0800
Message-ID: <167243846952.701054.16159465524790778214.stgit@magnolia>
In-Reply-To: <167243846905.701054.601680294547998738.stgit@magnolia>
References: <167243846905.701054.601680294547998738.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Save ~460 bytes of stack space by moving all the repair context to a
heap object.  We're going to add even more context data in the next
patch, which is why we really need to do this now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |  105 ++++++++++++++++++++++++----------------
 1 file changed, 63 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index daeb88cf5825..26ed60c24386 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -803,15 +803,29 @@ enum {
 	XREP_AGI_MAX
 };
 
+struct xrep_agi {
+	struct xfs_scrub		*sc;
+
+	/* AGI buffer, tracked separately */
+	struct xfs_buf			*agi_bp;
+
+	/* context for finding btree roots */
+	struct xrep_find_ag_btree	fab[XREP_AGI_MAX];
+
+	/* old AGI contents in case we have to revert */
+	struct xfs_agi			old_agi;
+};
+
 /*
  * Given the inode btree roots described by *fab, find the roots, check them
  * for sanity, and pass the root data back out via *fab.
  */
 STATIC int
 xrep_agi_find_btrees(
-	struct xfs_scrub		*sc,
-	struct xrep_find_ag_btree	*fab)
+	struct xrep_agi			*ragi)
 {
+	struct xfs_scrub		*sc = ragi->sc;
+	struct xrep_find_ag_btree	*fab = ragi->fab;
 	struct xfs_buf			*agf_bp;
 	struct xfs_mount		*mp = sc->mp;
 	int				error;
@@ -844,10 +858,11 @@ xrep_agi_find_btrees(
  */
 STATIC void
 xrep_agi_init_header(
-	struct xfs_scrub	*sc,
-	struct xfs_buf		*agi_bp,
-	struct xfs_agi		*old_agi)
+	struct xrep_agi		*ragi)
 {
+	struct xfs_scrub	*sc = ragi->sc;
+	struct xfs_buf		*agi_bp = ragi->agi_bp;
+	struct xfs_agi		*old_agi = &ragi->old_agi;
 	struct xfs_agi		*agi = agi_bp->b_addr;
 	struct xfs_mount	*mp = sc->mp;
 
@@ -874,10 +889,12 @@ xrep_agi_init_header(
 /* Set btree root information in an AGI. */
 STATIC void
 xrep_agi_set_roots(
-	struct xfs_scrub		*sc,
-	struct xfs_agi			*agi,
-	struct xrep_find_ag_btree	*fab)
+	struct xrep_agi			*ragi)
 {
+	struct xfs_scrub		*sc = ragi->sc;
+	struct xfs_agi			*agi = ragi->agi_bp->b_addr;
+	struct xrep_find_ag_btree	*fab = ragi->fab;
+
 	agi->agi_root = cpu_to_be32(fab[XREP_AGI_INOBT].root);
 	agi->agi_level = cpu_to_be32(fab[XREP_AGI_INOBT].height);
 
@@ -890,9 +907,10 @@ xrep_agi_set_roots(
 /* Update the AGI counters. */
 STATIC int
 xrep_agi_calc_from_btrees(
-	struct xfs_scrub	*sc,
-	struct xfs_buf		*agi_bp)
+	struct xrep_agi		*ragi)
 {
+	struct xfs_scrub	*sc = ragi->sc;
+	struct xfs_buf		*agi_bp = ragi->agi_bp;
 	struct xfs_btree_cur	*cur;
 	struct xfs_agi		*agi = agi_bp->b_addr;
 	struct xfs_mount	*mp = sc->mp;
@@ -939,9 +957,10 @@ xrep_agi_calc_from_btrees(
 /* Trigger reinitialization of the in-core data. */
 STATIC int
 xrep_agi_commit_new(
-	struct xfs_scrub	*sc,
-	struct xfs_buf		*agi_bp)
+	struct xrep_agi		*ragi)
 {
+	struct xfs_scrub	*sc = ragi->sc;
+	struct xfs_buf		*agi_bp = ragi->agi_bp;
 	struct xfs_perag	*pag;
 	struct xfs_agi		*agi = agi_bp->b_addr;
 
@@ -964,33 +983,36 @@ xrep_agi_commit_new(
 /* Repair the AGI. */
 int
 xrep_agi(
-	struct xfs_scrub		*sc)
+	struct xfs_scrub	*sc)
 {
-	struct xrep_find_ag_btree	fab[XREP_AGI_MAX] = {
-		[XREP_AGI_INOBT] = {
-			.rmap_owner = XFS_RMAP_OWN_INOBT,
-			.buf_ops = &xfs_inobt_buf_ops,
-			.maxlevels = M_IGEO(sc->mp)->inobt_maxlevels,
-		},
-		[XREP_AGI_FINOBT] = {
-			.rmap_owner = XFS_RMAP_OWN_INOBT,
-			.buf_ops = &xfs_finobt_buf_ops,
-			.maxlevels = M_IGEO(sc->mp)->inobt_maxlevels,
-		},
-		[XREP_AGI_END] = {
-			.buf_ops = NULL
-		},
-	};
-	struct xfs_agi			old_agi;
-	struct xfs_mount		*mp = sc->mp;
-	struct xfs_buf			*agi_bp;
-	struct xfs_agi			*agi;
-	int				error;
+	struct xrep_agi		*ragi;
+	struct xfs_mount	*mp = sc->mp;
+	int			error;
 
 	/* We require the rmapbt to rebuild anything. */
 	if (!xfs_has_rmapbt(mp))
 		return -EOPNOTSUPP;
 
+	sc->buf = kzalloc(sizeof(struct xrep_agi), XCHK_GFP_FLAGS);
+	if (!sc->buf)
+		return -ENOMEM;
+	ragi = sc->buf;
+	ragi->sc = sc;
+
+	ragi->fab[XREP_AGI_INOBT] = (struct xrep_find_ag_btree){
+		.rmap_owner	= XFS_RMAP_OWN_INOBT,
+		.buf_ops	= &xfs_inobt_buf_ops,
+		.maxlevels	= M_IGEO(sc->mp)->inobt_maxlevels,
+	};
+	ragi->fab[XREP_AGI_FINOBT] = (struct xrep_find_ag_btree){
+		.rmap_owner	= XFS_RMAP_OWN_INOBT,
+		.buf_ops	= &xfs_finobt_buf_ops,
+		.maxlevels	= M_IGEO(sc->mp)->inobt_maxlevels,
+	};
+	ragi->fab[XREP_AGI_END] = (struct xrep_find_ag_btree){
+		.buf_ops	= NULL,
+	};
+
 	/*
 	 * Make sure we have the AGI buffer, as scrub might have decided it
 	 * was corrupt after xfs_ialloc_read_agi failed with -EFSCORRUPTED.
@@ -998,14 +1020,13 @@ xrep_agi(
 	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, sc->sa.pag->pag_agno,
 						XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, &agi_bp, NULL);
+			XFS_FSS_TO_BB(mp, 1), 0, &ragi->agi_bp, NULL);
 	if (error)
 		return error;
-	agi_bp->b_ops = &xfs_agi_buf_ops;
-	agi = agi_bp->b_addr;
+	ragi->agi_bp->b_ops = &xfs_agi_buf_ops;
 
 	/* Find the AGI btree roots. */
-	error = xrep_agi_find_btrees(sc, fab);
+	error = xrep_agi_find_btrees(ragi);
 	if (error)
 		return error;
 
@@ -1014,18 +1035,18 @@ xrep_agi(
 		return error;
 
 	/* Start rewriting the header and implant the btrees we found. */
-	xrep_agi_init_header(sc, agi_bp, &old_agi);
-	xrep_agi_set_roots(sc, agi, fab);
-	error = xrep_agi_calc_from_btrees(sc, agi_bp);
+	xrep_agi_init_header(ragi);
+	xrep_agi_set_roots(ragi);
+	error = xrep_agi_calc_from_btrees(ragi);
 	if (error)
 		goto out_revert;
 
 	/* Reinitialize in-core state. */
-	return xrep_agi_commit_new(sc, agi_bp);
+	return xrep_agi_commit_new(ragi);
 
 out_revert:
 	/* Mark the incore AGI state stale and revert the AGI. */
 	sc->sa.pag->pagi_init = 0;
-	memcpy(agi, &old_agi, sizeof(old_agi));
+	memcpy(ragi->agi_bp->b_addr, &ragi->old_agi, sizeof(struct xfs_agi));
 	return error;
 }


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3351D2263E
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711505185; cv=none; b=bO3iUXL6xqr/g7KmKQwkz/Nlz9rbyjsJ1pKLDZ8KeqpzaNdg7im2p4m4b3bJLAdo3YhlDE/uXuIWI0BjIy5n4gmtn+o2gzjSyELsWRZRdak4G8a/8oG/By/bdm2CXU56VRKAb69hcDlkwfYv1zIIS+ROoImJZ++BrbyZwLZ2HVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711505185; c=relaxed/simple;
	bh=jnTC4/5ESnlObR/fTFWTZWuzH7oBWD7VaAz79fTbnwQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NxloPWLNaJKwz5zD6uxy21SzwUnVYCtZ0HmZoEPWNlbCsiuT5vX4HC17jEIVarw2OVDzgsATym738axtkk2v7i1UBZCCPJbDYgYzj29BaU1gNHXmcH+ya4zxAsO0bw795vE2S8BpMmDF3NDb7b9dAYMva4ijK2mMFM24mzs4nBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CgLsq4V0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CgLsq4V0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F488C433C7;
	Wed, 27 Mar 2024 02:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711505185;
	bh=jnTC4/5ESnlObR/fTFWTZWuzH7oBWD7VaAz79fTbnwQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CgLsq4V0wOcwTlCDNdZOcqPMKnPpzqpEqxedz0RzrO7/nGL7/ZJV7KdfgvYhXB5qT
	 Hz8+HC39iK7HSZvgmJMfkPmZ55DHSFbL9wH3lLHa463an45tNWLcw/9+YoQXRnEWQ0
	 qJFzY7qv47RX8jf/ra8O1GkYG9Ne6UDnFEdtBjQTL02DMHm5iz5A6cqkg69SDqv58R
	 umWxIaWDLG5rb572lAz/U9ijuYf2HOZFdcMaGBM/jK/ANyMv/u69ztV/V/KUW8qgGG
	 5Lp8Spfi3HC46RzPQCDD3p8YViBlB34pMoN/N3VQsGjqstIoToBGpx06d/GPWOszMQ
	 Ehz39NRS88m5g==
Date: Tue, 26 Mar 2024 19:06:24 -0700
Subject: [PATCH 2/3] xfs: hoist AGI repair context to a heap object
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150384746.3220168.15329704264390144949.stgit@frogsfrogsfrogs>
In-Reply-To: <171150384705.3220168.3647633643279321481.stgit@frogsfrogsfrogs>
References: <171150384705.3220168.3647633643279321481.stgit@frogsfrogsfrogs>
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

Save ~460 bytes of stack space by moving all the repair context to a
heap object.  We're going to add even more context data in the next
patch, which is why we really need to do this now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader_repair.c |  105 ++++++++++++++++++++++++----------------
 1 file changed, 63 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 427054b65b238..d210bd7d5eb13 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -796,15 +796,29 @@ enum {
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
@@ -837,10 +851,11 @@ xrep_agi_find_btrees(
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
 	struct xfs_perag	*pag = sc->sa.pag;
 	struct xfs_mount	*mp = sc->mp;
@@ -868,10 +883,12 @@ xrep_agi_init_header(
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
 
@@ -884,9 +901,10 @@ xrep_agi_set_roots(
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
@@ -931,9 +949,10 @@ xrep_agi_calc_from_btrees(
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
 
@@ -956,33 +975,36 @@ xrep_agi_commit_new(
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
@@ -990,14 +1012,13 @@ xrep_agi(
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
 
@@ -1006,18 +1027,18 @@ xrep_agi(
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
 	clear_bit(XFS_AGSTATE_AGI_INIT, &sc->sa.pag->pag_opstate);
-	memcpy(agi, &old_agi, sizeof(old_agi));
+	memcpy(ragi->agi_bp->b_addr, &ragi->old_agi, sizeof(struct xfs_agi));
 	return error;
 }


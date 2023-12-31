Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3374415
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMNkZcLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ACFC433C7;
	Sun, 31 Dec 2023 20:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055178;
	bh=JyDpYCDS1afMHlzaL4eW52Wx2jiKRkQEzgKMP+1e1WE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GMNkZcLndlGzOYIxPrRxkh5z3+fAYUDU9dYtjNPJE/SJXZ6rGIjVmzImjhWon93ie
	 vm5WvzBL/WIJtmksgBsTbWl8+v0SCwmamYcCKxYLRiWhmgM6sYBd9C8SWIvfJkSyn4
	 k24hwbRzjPBVeI+imaDEysqEk78ID4EXuqej40IGqB070PofIdoEPnMBfm/o9qv4Rc
	 WUjeJLA25G2yUgNmV9+rr2moDwHOVYpHpi4M93s9iCO6NaXE39d6O/HOGfoku+PKLI
	 gGC2s94gJDC14z9rE66HkA58C6/SaorJuzkuH661Z5vudBl//vaMQUDb2jN+2jOTwG
	 a0z01AG0jp8kQ==
Date: Sun, 31 Dec 2023 12:39:37 -0800
Subject: [PATCH 2/3] xfs: hoist AGI repair context to a heap object
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404837230.1753977.14070952254477847434.stgit@frogsfrogsfrogs>
In-Reply-To: <170404837191.1753977.11382534548825167511.stgit@frogsfrogsfrogs>
References: <170404837191.1753977.11382534548825167511.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/agheader_repair.c |  105 ++++++++++++++++++++++++----------------
 1 file changed, 63 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 26bd1ff68f1be..ca6df7a0b0721 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -810,15 +810,29 @@ enum {
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
@@ -851,10 +865,11 @@ xrep_agi_find_btrees(
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
@@ -882,10 +897,12 @@ xrep_agi_init_header(
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
 
@@ -898,9 +915,10 @@ xrep_agi_set_roots(
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
@@ -946,9 +964,10 @@ xrep_agi_calc_from_btrees(
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
 
@@ -971,33 +990,36 @@ xrep_agi_commit_new(
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
@@ -1005,14 +1027,13 @@ xrep_agi(
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
 
@@ -1021,18 +1042,18 @@ xrep_agi(
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


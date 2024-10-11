Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D508F5E
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609018; cv=none; b=hvkVKwVOKGODZ9ADYLQcQMc2DZ6/HcoMijxvTGy387kQNna3LDqqZlFYU0gM0RufUBs4aXbQYR/7lpOCY2GtuoxeH2GJkYtthPi+/fxHehF8oQEvozaCL6UYTTWuGSl/G0fs9ewF2JXq4Lmew9ZWjW2SYREEXXrnKS4X8HugyiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609018; c=relaxed/simple;
	bh=xNvq6QLJREFs7xD8rv7nHLNCRU6tkURx3RSIbfpcYZ4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=abPiA/E0S3AH6C9Q/MFxKALhJLdJAxV9vBO3WcL7KS5Ycf3HdwR/lqZfq9xRzET8IDk0sTYLeBjBORMACo8B72OvBceBRdWrzGVZr76Nufce9OYM9tCVoKUcd9iUAU/tuAkYc8Hsl01fuD17zpkK5e3HW21kgHcBcUVHsP7O49w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7HAaFVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7HAaFVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE98C4CEC5;
	Fri, 11 Oct 2024 01:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609016;
	bh=xNvq6QLJREFs7xD8rv7nHLNCRU6tkURx3RSIbfpcYZ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P7HAaFVYDDg2Q82JB2uglY8L+Nz/h+tFzJLl0gFcRfPltGNoQAbFnphN/Nvvuj83O
	 4VmZa8o28wI/2NHmRRQMNoBkCTyIiP8aTy60iULWNYsQAmfKln1fvzrnxzrN6fB5XY
	 i9xJuoWhYAKo41lDtWp2xFidZq801SbySgZ6xFf3YnPGMrHE7ZtTNOrEMn1Nk23ayJ
	 9Dtb0djMXSzzDQNtbclnYgSWX8AqZF50l1EsotbPWLSgvHEgLacnr+g1kA8NIjUmlv
	 sxaCpWera60unJ7I6Kp6slogmyJbqKI6dSJGLz9isY9CacXblFAa9Vm3orqRu9bTD7
	 yEpy2qFmslTPA==
Date: Thu, 10 Oct 2024 18:10:16 -0700
Subject: [PATCH 33/36] xfs: move the min and max group block numbers to
 xfs_group
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644812.4178701.7302557147054352474.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

Move the min and max agblock numbers to the generic xfs_group structure
so that we can start building validators for extents within an rtgroup.
While we're at it, use check_add_overflow for the extent length
computation because that has much better overflow checking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c           |   15 ++++++++-------
 fs/xfs/libxfs/xfs_ag.h           |   16 ++--------------
 fs/xfs/libxfs/xfs_group.h        |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc_btree.c |    2 +-
 fs/xfs/libxfs/xfs_rtgroup.c      |   30 +++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_rtgroup.h      |    3 +++
 fs/xfs/scrub/agheader.c          |    4 ++--
 fs/xfs/scrub/agheader_repair.c   |    4 ++--
 fs/xfs/scrub/repair.c            |    6 +++---
 fs/xfs/xfs_discard.c             |    4 ++--
 fs/xfs/xfs_rtalloc.c             |    8 ++++----
 11 files changed, 89 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index ebf645a3dd8963..fe902912605c97 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -220,9 +220,10 @@ xfs_perag_alloc(
 	/*
 	 * Pre-calculated geometry
 	 */
-	pag->block_count = __xfs_ag_block_count(mp, index, agcount, dblocks);
-	pag->min_block = XFS_AGFL_BLOCK(mp) + 1;
-	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+	pag->pag_group.xg_block_count = __xfs_ag_block_count(mp, index, agcount,
+			dblocks);
+	pag->pag_group.xg_min_gbno = XFS_AGFL_BLOCK(mp) + 1;
+	__xfs_agino_range(mp, pag->pag_group.xg_block_count, &pag->agino_min,
 			&pag->agino_max);
 
 	error = xfs_group_insert(mp, &pag->pag_group, index, XG_TYPE_AG);
@@ -831,8 +832,8 @@ xfs_ag_shrink_space(
 	}
 
 	/* Update perag geometry */
-	pag->block_count -= delta;
-	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+	pag->pag_group.xg_block_count -= delta;
+	__xfs_agino_range(mp, pag->pag_group.xg_block_count, &pag->agino_min,
 			&pag->agino_max);
 
 	xfs_ialloc_log_agi(*tpp, agibp, XFS_AGI_LENGTH);
@@ -903,8 +904,8 @@ xfs_ag_extend_space(
 		return error;
 
 	/* Update perag geometry */
-	pag->block_count = be32_to_cpu(agf->agf_length);
-	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+	pag->pag_group.xg_block_count = be32_to_cpu(agf->agf_length);
+	__xfs_agino_range(mp, pag->pag_group.xg_block_count, &pag->agino_min,
 			&pag->agino_max);
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 1671cd5ce3020a..b6d5437393ad92 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -61,8 +61,6 @@ struct xfs_perag {
 	struct xfs_ag_resv	pag_rmapbt_resv;
 
 	/* Precalculated geometry info */
-	xfs_agblock_t		block_count;
-	xfs_agblock_t		min_block;
 	xfs_agino_t		agino_min;
 	xfs_agino_t		agino_max;
 
@@ -214,11 +212,7 @@ void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
 static inline bool
 xfs_verify_agbno(struct xfs_perag *pag, xfs_agblock_t agbno)
 {
-	if (agbno >= pag->block_count)
-		return false;
-	if (agbno < pag->min_block)
-		return false;
-	return true;
+	return xfs_verify_gbno(&pag->pag_group, agbno);
 }
 
 static inline bool
@@ -227,13 +221,7 @@ xfs_verify_agbext(
 	xfs_agblock_t		agbno,
 	xfs_agblock_t		len)
 {
-	if (agbno + len <= agbno)
-		return false;
-
-	if (!xfs_verify_agbno(pag, agbno))
-		return false;
-
-	return xfs_verify_agbno(pag, agbno + len - 1);
+	return xfs_verify_gbext(&pag->pag_group, agbno, len);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 435c8d6fb6cd12..1517d5e2d8c556 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -12,6 +12,10 @@ struct xfs_group {
 	atomic_t		xg_ref;		/* passive reference count */
 	atomic_t		xg_active_ref;	/* active reference count */
 
+	/* Precalculated geometry info */
+	uint32_t		xg_block_count;	/* max usable gbno */
+	uint32_t		xg_min_gbno;	/* min usable gbno */
+
 #ifdef __KERNEL__
 	/* -- kernel only structures below this line -- */
 
@@ -128,4 +132,33 @@ xfs_fsb_to_gbno(
 	return fsbno & mp->m_groups[type].blkmask;
 }
 
+static inline bool
+xfs_verify_gbno(
+	struct xfs_group	*xg,
+	uint32_t		gbno)
+{
+	if (gbno >= xg->xg_block_count)
+		return false;
+	if (gbno < xg->xg_min_gbno)
+		return false;
+	return true;
+}
+
+static inline bool
+xfs_verify_gbext(
+	struct xfs_group	*xg,
+	uint32_t		gbno,
+	uint32_t		glen)
+{
+	uint32_t		end;
+
+	if (!xfs_verify_gbno(xg, gbno))
+		return false;
+	if (glen == 0 || check_add_overflow(gbno, glen - 1, &end))
+		return false;
+	if (!xfs_verify_gbno(xg, end))
+		return false;
+	return true;
+}
+
 #endif /* __LIBXFS_GROUP_H */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 138c687545295d..0251b01944cb16 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -717,7 +717,7 @@ xfs_inobt_max_size(
 	struct xfs_perag	*pag)
 {
 	struct xfs_mount	*mp = pag_mount(pag);
-	xfs_agblock_t		agblocks = pag->block_count;
+	xfs_agblock_t		agblocks = pag->pag_group.xg_block_count;
 
 	/* Bail out if we're uninitialized, which can happen in mkfs. */
 	if (M_IGEO(mp)->inobt_mxr[0] == 0)
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 8d8a8ebb8b50ff..b3577ff4cf9d00 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -34,6 +34,32 @@
 #include "xfs_metafile.h"
 #include "xfs_metadir.h"
 
+/* Find the first usable fsblock in this rtgroup. */
+static inline uint32_t
+xfs_rtgroup_min_block(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	if (xfs_has_rtsb(mp) && rgno == 0)
+		return mp->m_sb.sb_rextsize;
+
+	return 0;
+}
+
+/* Precompute this group's geometry */
+void
+xfs_rtgroup_calc_geometry(
+	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
+	xfs_rgnumber_t		rgno,
+	xfs_rgnumber_t		rgcount,
+	xfs_rtbxlen_t		rextents)
+{
+	rtg->rtg_extents = __xfs_rtgroup_extents(mp, rgno, rgcount, rextents);
+	rtg->rtg_group.xg_block_count = rtg->rtg_extents * mp->m_sb.sb_rextsize;
+	rtg->rtg_group.xg_min_gbno = xfs_rtgroup_min_block(mp, rgno);
+}
+
 int
 xfs_rtgroup_alloc(
 	struct xfs_mount	*mp,
@@ -48,6 +74,8 @@ xfs_rtgroup_alloc(
 	if (!rtg)
 		return -ENOMEM;
 
+	xfs_rtgroup_calc_geometry(mp, rtg, rgno, rgcount, rextents);
+
 	error = xfs_group_insert(mp, &rtg->rtg_group, rgno, XG_TYPE_RTG);
 	if (error)
 		goto out_free_rtg;
@@ -201,7 +229,7 @@ xfs_rtgroup_get_geometry(
 	/* Fill out form. */
 	memset(rgeo, 0, sizeof(*rgeo));
 	rgeo->rg_number = rtg_rgno(rtg);
-	rgeo->rg_length = rtg->rtg_extents * rtg_mount(rtg)->m_sb.sb_rextsize;
+	rgeo->rg_length = rtg->rtg_group.xg_block_count;
 	rgeo->rg_capacity = rgeo->rg_length;
 	xfs_rtgroup_geom_health(rtg, rgeo);
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index f3ee5b8177cc72..9b7866607528ea 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -194,6 +194,9 @@ int xfs_initialize_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
 xfs_rtxnum_t __xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 		xfs_rgnumber_t rgcount, xfs_rtbxlen_t rextents);
 xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
+void xfs_rtgroup_calc_geometry(struct xfs_mount *mp, struct xfs_rtgroup *rtg,
+		xfs_rgnumber_t rgno, xfs_rgnumber_t rgcount,
+		xfs_rtbxlen_t rextents);
 
 /* Lock the rt bitmap inode in exclusive mode */
 #define XFS_RTGLOCK_BITMAP		(1U << 0)
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 31467d71c63e91..e6df4bd9792112 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -564,7 +564,7 @@ xchk_agf(
 
 	/* Check the AG length */
 	eoag = be32_to_cpu(agf->agf_length);
-	if (eoag != pag->block_count)
+	if (eoag != pag->pag_group.xg_block_count)
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	/* Check the AGF btree roots and levels */
@@ -944,7 +944,7 @@ xchk_agi(
 
 	/* Check the AG length */
 	eoag = be32_to_cpu(agi->agi_length);
-	if (eoag != pag->block_count)
+	if (eoag != pag->pag_group.xg_block_count)
 		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 	/* Check btree roots and levels */
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 0ea04d6e21cd83..6f764d2e788667 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -209,7 +209,7 @@ xrep_agf_init_header(
 	agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
 	agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
 	agf->agf_seqno = cpu_to_be32(pag_agno(pag));
-	agf->agf_length = cpu_to_be32(pag->block_count);
+	agf->agf_length = cpu_to_be32(pag->pag_group.xg_block_count);
 	agf->agf_flfirst = old_agf->agf_flfirst;
 	agf->agf_fllast = old_agf->agf_fllast;
 	agf->agf_flcount = old_agf->agf_flcount;
@@ -898,7 +898,7 @@ xrep_agi_init_header(
 	agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
 	agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
 	agi->agi_seqno = cpu_to_be32(pag_agno(pag));
-	agi->agi_length = cpu_to_be32(pag->block_count);
+	agi->agi_length = cpu_to_be32(pag->pag_group.xg_block_count);
 	agi->agi_newino = cpu_to_be32(NULLAGINO);
 	agi->agi_dirino = cpu_to_be32(NULLAGINO);
 	if (xfs_has_crc(mp))
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 3fa009126170e6..588888f30d5e0b 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -306,7 +306,7 @@ xrep_calc_ag_resblks(
 	/* Now grab the block counters from the AGF. */
 	error = xfs_alloc_read_agf(pag, NULL, 0, &bp);
 	if (error) {
-		aglen = pag->block_count;
+		aglen = pag->pag_group.xg_block_count;
 		freelen = aglen;
 		usedlen = aglen;
 	} else {
@@ -326,9 +326,9 @@ xrep_calc_ag_resblks(
 
 	/* If the block counts are impossible, make worst-case assumptions. */
 	if (aglen == NULLAGBLOCK ||
-	    aglen != pag->block_count ||
+	    aglen != pag->pag_group.xg_block_count ||
 	    freelen >= aglen) {
-		aglen = pag->block_count;
+		aglen = pag->pag_group.xg_block_count;
 		freelen = aglen;
 		usedlen = aglen;
 	}
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index cec79220e89621..bcc904e749b276 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -337,7 +337,7 @@ xfs_trim_perag_extents(
 	};
 	int			error = 0;
 
-	if (start != 0 || end != pag->block_count)
+	if (start != 0 || end != pag->pag_group.xg_block_count)
 		tcur.by_bno = true;
 
 	do {
@@ -403,7 +403,7 @@ xfs_trim_datadev_extents(
 	end_agbno = xfs_daddr_to_agbno(mp, ddev_end);
 
 	while ((pag = xfs_perag_next_range(mp, pag, start_agno, end_agno))) {
-		xfs_agblock_t	agend = pag->block_count;
+		xfs_agblock_t	agend = pag->pag_group.xg_block_count;
 
 		if (pag_agno(pag) == end_agno)
 			agend = end_agbno;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index db09c086ff1c01..8f56d5fbe7413a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -878,7 +878,8 @@ xfs_growfs_rt_bmblock(
 	if (!nmp)
 		return -ENOMEM;
 
-	rtg->rtg_extents = xfs_rtgroup_extents(nmp, rtg_rgno(rtg));
+	xfs_rtgroup_calc_geometry(nmp, rtg, rtg_rgno(rtg),
+			nmp->m_sb.sb_rgcount, nmp->m_sb.sb_rextents);
 
 	/*
 	 * Recompute the growfsrt reservation from the new rsumsize, so that the
@@ -1137,7 +1138,8 @@ xfs_growfs_rtg(
 	/*
 	 * Reset rtg_extents to the old value if adding more blocks failed.
 	 */
-	rtg->rtg_extents = xfs_rtgroup_extents(rtg_mount(rtg), rtg_rgno(rtg));
+	xfs_rtgroup_calc_geometry(mp, rtg, rtg_rgno(rtg), mp->m_sb.sb_rgcount,
+			mp->m_sb.sb_rextents);
 	if (old_rsum_cache) {
 		kvfree(rtg->rtg_rsum_cache);
 		rtg->rtg_rsum_cache = old_rsum_cache;
@@ -1517,8 +1519,6 @@ xfs_rtmount_rtg(
 {
 	int			error, i;
 
-	rtg->rtg_extents = xfs_rtgroup_extents(mp, rtg_rgno(rtg));
-
 	for (i = 0; i < XFS_RTGI_MAX; i++) {
 		error = xfs_rtginode_load(rtg, i, tp);
 		if (error)


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CD813FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991656; cv=none; b=ot/IRobt4hb9kCjM0mnRa7Kk/5aDELLrpelCffKc1ZCSubcqGhoNgt11KdBTZu3sKfoTwSw+kLjfaV/ruvM6cIb855k9vjwhk/VGr/636N6pfhNZjSDwcjGiOT7NhVxJwAVh2C4YLuz1qsKR5k+wsMmO2+qg4lkT1jXsYfMc4VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991656; c=relaxed/simple;
	bh=3LKFpi0qcVAue2djHz4sFNtV7IQGFdiS/MRi7uhlhZY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G9Yl1FEejqxRhZQQ7UzAbfKlu5SXJTqec9xaeO+MVI5ltDNji+3afA3IDoXJ3Cle1/rinNmwPTmCJgTMRFMdpq2+3ijQBuJDtqQd9kq/WL/H8K4Zzt4BpV/WNc4SlG1JirK/Ds3hNVtu4VhbrikkCnerH6cEYkKFwK44pZP2YMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NB1aEKSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NB1aEKSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35E5C4CED3;
	Mon, 23 Dec 2024 22:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991656;
	bh=3LKFpi0qcVAue2djHz4sFNtV7IQGFdiS/MRi7uhlhZY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NB1aEKScz0xyGMyV8QR1gc2aloHTCLBtXcMFmtid3J4XFc1JSjePW+MIUa9dgIgbU
	 iijH+sahAH73Me2zkkpdcxETE/fQJocvMqe/emf6cl+juoBafXSC3el1UjgNZ+NK8e
	 dyTL4DhrgD6qKhBAGsnA293CQ5w2ekh31KuFy4A4d6W7mDSm8PTaj0eRSJqwka50ib
	 tw2ESQRJL3beeKXqfCjQyyCcgaqRw0o2Ri/MhR7Ym2WK/DY95tEO4znLuigRvkHqFk
	 podUnRpko+/LVwzpr62I5tq/GQp9qWkm46cckJvDWX6J+IXtBXo4syLSsO6ymOBoDh
	 ndJLwOwi0nHOw==
Date: Mon, 23 Dec 2024 14:07:36 -0800
Subject: [PATCH 36/52] xfs: move the min and max group block numbers to
 xfs_group
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943048.2295836.818304644684064184.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: e0b5b97dde8e4737d06cb5888abd88373abc22df

Move the min and max agblock numbers to the generic xfs_group structure
so that we can start building validators for extents within an rtgroup.
While we're at it, use check_add_overflow for the extent length
computation because that has much better overflow checking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c             |    4 ----
 libxfs/xfs_ag.c           |   22 ++++++++++++----------
 libxfs/xfs_ag.h           |   16 ++--------------
 libxfs/xfs_group.h        |   33 +++++++++++++++++++++++++++++++++
 libxfs/xfs_ialloc_btree.c |    2 +-
 libxfs/xfs_rtgroup.c      |   31 ++++++++++++++++++++++++++++++-
 libxfs/xfs_rtgroup.h      |    3 +++
 7 files changed, 81 insertions(+), 30 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index a037012b77e5f6..6642cd50c00b5f 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -668,7 +668,6 @@ libxfs_mount(
 {
 	struct xfs_buf		*bp;
 	struct xfs_sb		*sbp;
-	struct xfs_rtgroup	*rtg = NULL;
 	xfs_daddr_t		d;
 	int			i;
 	int			error;
@@ -831,9 +830,6 @@ libxfs_mount(
 		exit(1);
 	}
 
-	while ((rtg = xfs_rtgroup_next(mp, rtg)))
-		rtg->rtg_extents = xfs_rtgroup_extents(mp, rtg_rgno(rtg));
-
 	xfs_set_rtgroup_data_loaded(mp);
 
 	return mp;
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 181e929132d855..095b581a116180 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -203,9 +203,10 @@ xfs_update_last_ag_size(
 
 	if (!pag)
 		return -EFSCORRUPTED;
-	pag->block_count = __xfs_ag_block_count(mp, prev_agcount - 1,
-			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks);
-	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+	pag_group(pag)->xg_block_count = __xfs_ag_block_count(mp,
+			prev_agcount - 1, mp->m_sb.sb_agcount,
+			mp->m_sb.sb_dblocks);
+	__xfs_agino_range(mp, pag_group(pag)->xg_block_count, &pag->agino_min,
 			&pag->agino_max);
 	xfs_perag_rele(pag);
 	return 0;
@@ -239,9 +240,10 @@ xfs_perag_alloc(
 	/*
 	 * Pre-calculated geometry
 	 */
-	pag->block_count = __xfs_ag_block_count(mp, index, agcount, dblocks);
-	pag->min_block = XFS_AGFL_BLOCK(mp) + 1;
-	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+	pag_group(pag)->xg_block_count = __xfs_ag_block_count(mp, index, agcount,
+				dblocks);
+	pag_group(pag)->xg_min_gbno = XFS_AGFL_BLOCK(mp) + 1;
+	__xfs_agino_range(mp, pag_group(pag)->xg_block_count, &pag->agino_min,
 			&pag->agino_max);
 
 	error = xfs_group_insert(mp, pag_group(pag), index, XG_TYPE_AG);
@@ -850,8 +852,8 @@ xfs_ag_shrink_space(
 	}
 
 	/* Update perag geometry */
-	pag->block_count -= delta;
-	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+	pag_group(pag)->xg_block_count -= delta;
+	__xfs_agino_range(mp, pag_group(pag)->xg_block_count, &pag->agino_min,
 			&pag->agino_max);
 
 	xfs_ialloc_log_agi(*tpp, agibp, XFS_AGI_LENGTH);
@@ -922,8 +924,8 @@ xfs_ag_extend_space(
 		return error;
 
 	/* Update perag geometry */
-	pag->block_count = be32_to_cpu(agf->agf_length);
-	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+	pag_group(pag)->xg_block_count = be32_to_cpu(agf->agf_length);
+	__xfs_agino_range(mp, pag_group(pag)->xg_block_count, &pag->agino_min,
 			&pag->agino_max);
 	return 0;
 }
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 9c22a76d58cfc2..1f24cfa2732172 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -61,8 +61,6 @@ struct xfs_perag {
 	struct xfs_ag_resv	pag_rmapbt_resv;
 
 	/* Precalculated geometry info */
-	xfs_agblock_t		block_count;
-	xfs_agblock_t		min_block;
 	xfs_agino_t		agino_min;
 	xfs_agino_t		agino_max;
 
@@ -220,11 +218,7 @@ void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
 static inline bool
 xfs_verify_agbno(struct xfs_perag *pag, xfs_agblock_t agbno)
 {
-	if (agbno >= pag->block_count)
-		return false;
-	if (agbno < pag->min_block)
-		return false;
-	return true;
+	return xfs_verify_gbno(pag_group(pag), agbno);
 }
 
 static inline bool
@@ -233,13 +227,7 @@ xfs_verify_agbext(
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
+	return xfs_verify_gbext(pag_group(pag), agbno, len);
 }
 
 /*
diff --git a/libxfs/xfs_group.h b/libxfs/xfs_group.h
index 5b7362277c3f7a..242b05627c7a6e 100644
--- a/libxfs/xfs_group.h
+++ b/libxfs/xfs_group.h
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
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 4eeea240b0bd89..19fca9fad62b1d 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -716,7 +716,7 @@ xfs_inobt_max_size(
 	struct xfs_perag	*pag)
 {
 	struct xfs_mount	*mp = pag_mount(pag);
-	xfs_agblock_t		agblocks = pag->block_count;
+	xfs_agblock_t		agblocks = pag_group(pag)->xg_block_count;
 
 	/* Bail out if we're uninitialized, which can happen in mkfs. */
 	if (M_IGEO(mp)->inobt_mxr[0] == 0)
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 50cfb038f03b79..8189b83d0f184a 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -31,6 +31,32 @@
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
+	rtg_group(rtg)->xg_block_count = rtg->rtg_extents * mp->m_sb.sb_rextsize;
+	rtg_group(rtg)->xg_min_gbno = xfs_rtgroup_min_block(mp, rgno);
+}
+
 int
 xfs_rtgroup_alloc(
 	struct xfs_mount	*mp,
@@ -45,6 +71,8 @@ xfs_rtgroup_alloc(
 	if (!rtg)
 		return -ENOMEM;
 
+	xfs_rtgroup_calc_geometry(mp, rtg, rgno, rgcount, rextents);
+
 	error = xfs_group_insert(mp, rtg_group(rtg), rgno, XG_TYPE_RTG);
 	if (error)
 		goto out_free_rtg;
@@ -146,6 +174,7 @@ xfs_update_last_rtgroup_size(
 		return -EFSCORRUPTED;
 	rtg->rtg_extents = __xfs_rtgroup_extents(mp, prev_rgcount - 1,
 			mp->m_sb.sb_rgcount, mp->m_sb.sb_rextents);
+	rtg_group(rtg)->xg_block_count = rtg->rtg_extents * mp->m_sb.sb_rextsize;
 	xfs_rtgroup_rele(rtg);
 	return 0;
 }
@@ -220,7 +249,7 @@ xfs_rtgroup_get_geometry(
 	/* Fill out form. */
 	memset(rgeo, 0, sizeof(*rgeo));
 	rgeo->rg_number = rtg_rgno(rtg);
-	rgeo->rg_length = rtg->rtg_extents * rtg_mount(rtg)->m_sb.sb_rextsize;
+	rgeo->rg_length = rtg_group(rtg)->xg_block_count;
 	xfs_rtgroup_geom_health(rtg, rgeo);
 	return 0;
 }
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index c15b232e1f8e77..1e51dc62d1143e 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -199,6 +199,9 @@ int xfs_initialize_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
 xfs_rtxnum_t __xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 		xfs_rgnumber_t rgcount, xfs_rtbxlen_t rextents);
 xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
+void xfs_rtgroup_calc_geometry(struct xfs_mount *mp, struct xfs_rtgroup *rtg,
+		xfs_rgnumber_t rgno, xfs_rgnumber_t rgcount,
+		xfs_rtbxlen_t rextents);
 
 int xfs_update_last_rtgroup_size(struct xfs_mount *mp,
 		xfs_rgnumber_t prev_rgcount);


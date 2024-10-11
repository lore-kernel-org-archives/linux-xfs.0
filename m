Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296DD539A
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608970; cv=none; b=eofbcvjR40m1t5SyWQdq+nbrHkI9Op/qM2nMc1pKY0SRqoj9V+CZ32NMN3IIbldY9DBfJGPNBHpW/Odk/LKGt31fjxNyt4hqQ9sefVWWI18bvKMK35WmML9aEBcXZShcPO8yJtBOiVcplB+KGXWeMvRDyS43/r8LjTrfz3nvlEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608970; c=relaxed/simple;
	bh=XM5CqlA6WBUanO6lpgoFFHRWYt80oXrpx5qxg3Uncbw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HyD8aei3/Cyc7Fzlemulao+GzMUlDNnSoXzlW9YNFaW5XSw/hFXEF7DDicvPqFa1CwqDJHXjhrUZHF1V+pK0I+0Cl6D44XfpYzxYm0KcJRlBKXuLqC7bF7MzYhK/7DhulBO/d/m8rdikq8pVmtQyTEtzkGGDkH6A4dm6Xi3ZKuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SJT8i1UC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJT8i1UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012BCC4CEC5;
	Fri, 11 Oct 2024 01:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608970;
	bh=XM5CqlA6WBUanO6lpgoFFHRWYt80oXrpx5qxg3Uncbw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SJT8i1UCBHlt9uw4HqtwIwDqN0m23LBVc3KlFSq3KbUzwlZ4/CM6x4lAEDYGN9f6o
	 CN719pZDhrzLAmpzY2eMnKh3WqAgmnKs4xMoRgt3DT/MHPuUQUR/e7jpI58XzqLXhI
	 j/+VOGmGA4O9ZOBgjaTAl/YMNvigyoY1BLB7IsIYmkJ35q6L6Flx6JFR7g2W6a83Wa
	 BVY7FdXA8tRHZ1T2lR+13mJqpzHY2qugfrs9wnN+jtMjyLfNx1OhMKYtb/ES2LZyjz
	 ev0uH5XW2eUTsyHod9tL7YiKbUyHQ7TEQihWISqUNT8SvqODtcjjTXeCCik/oN92rx
	 iJ3r9WnzIm1+w==
Date: Thu, 10 Oct 2024 18:09:29 -0700
Subject: [PATCH 30/36] xfs: move the group geometry into struct xfs_groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644760.4178701.13593967456112695233.stgit@frogsfrogsfrogs>
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

Add/move the blocks, blklog and blkmask fields to the generic groups
structure so that code can work with AGs and RTGs by just using the
right index into the array.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_group.c    |   34 -----------------------
 fs/xfs/libxfs/xfs_group.h    |   61 ++++++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_rtbitmap.h |   19 ++++++-------
 fs/xfs/libxfs/xfs_rtgroup.h  |   49 ++++++----------------------------
 fs/xfs/libxfs/xfs_sb.c       |   19 ++++++++++---
 fs/xfs/xfs_mount.h           |   32 +++++++++++++++++++++-
 fs/xfs/xfs_trace.c           |    2 +
 fs/xfs/xfs_trace.h           |   33 ++++++++---------------
 8 files changed, 130 insertions(+), 119 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index cf6427cf350bb8..8d0b62e490c0cd 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -12,8 +12,6 @@
 #include "xfs_trace.h"
 #include "xfs_extent_busy.h"
 #include "xfs_group.h"
-#include "xfs_ag.h"
-#include "xfs_rtgroup.h"
 
 /*
  * Groups can have passive and active references.
@@ -217,38 +215,6 @@ xfs_group_insert(
 	return error;
 }
 
-xfs_fsblock_t
-xfs_gbno_to_fsb(
-	struct xfs_group	*xg,
-	xfs_agblock_t		gbno)
-{
-	if (xg->xg_type == XG_TYPE_RTG)
-		return xfs_rgbno_to_rtb(to_rtg(xg), gbno);
-	return xfs_agbno_to_fsb(to_perag(xg), gbno);
-}
-
-xfs_daddr_t
-xfs_gbno_to_daddr(
-	struct xfs_group	*xg,
-	xfs_agblock_t		gbno)
-{
-	if (xg->xg_type == XG_TYPE_RTG)
-		return xfs_rtb_to_daddr(xg->xg_mount,
-			xfs_rgbno_to_rtb(to_rtg(xg), gbno));
-	return xfs_agbno_to_daddr(to_perag(xg), gbno);
-}
-
-uint32_t
-xfs_fsb_to_gno(
-	struct xfs_mount	*mp,
-	xfs_fsblock_t		fsbno,
-	enum xfs_group_type	type)
-{
-	if (type == XG_TYPE_RTG)
-		return xfs_rtb_to_rgno(mp, fsbno);
-	return XFS_FSB_TO_AGNO(mp, fsbno);
-}
-
 struct xfs_group *
 xfs_group_get_by_fsb(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 93a6302e738246..435c8d6fb6cd12 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -46,6 +46,8 @@ struct xfs_group {
 
 struct xfs_group *xfs_group_get(struct xfs_mount *mp, uint32_t index,
 		enum xfs_group_type type);
+struct xfs_group *xfs_group_get_by_fsb(struct xfs_mount *mp,
+		xfs_fsblock_t fsbno, enum xfs_group_type type);
 struct xfs_group *xfs_group_hold(struct xfs_group *xg);
 void xfs_group_put(struct xfs_group *xg);
 
@@ -72,11 +74,58 @@ int xfs_group_insert(struct xfs_mount *mp, struct xfs_group *xg,
 #define xfs_group_marked(_mp, _type, _mark) \
 	xa_marked(&(_mp)->m_groups[(_type)].xa, (_mark))
 
-xfs_fsblock_t xfs_gbno_to_fsb(struct xfs_group *xg, xfs_agblock_t gbno);
-xfs_daddr_t xfs_gbno_to_daddr(struct xfs_group *xg, xfs_agblock_t gbno);
-uint32_t xfs_fsb_to_gno(struct xfs_mount *mp, xfs_fsblock_t fsbno,
-		enum xfs_group_type type);
-struct xfs_group *xfs_group_get_by_fsb(struct xfs_mount *mp,
-		xfs_fsblock_t fsbno, enum xfs_group_type type);
+static inline xfs_agblock_t
+xfs_group_max_blocks(
+	struct xfs_group	*xg)
+{
+	return xg->xg_mount->m_groups[xg->xg_type].blocks;
+}
+
+static inline xfs_fsblock_t
+xfs_group_start_fsb(
+	struct xfs_group	*xg)
+{
+	return ((xfs_fsblock_t)xg->xg_index) <<
+		xg->xg_mount->m_groups[xg->xg_type].blklog;
+}
+
+static inline xfs_fsblock_t
+xfs_gbno_to_fsb(
+	struct xfs_group	*xg,
+	xfs_agblock_t		gbno)
+{
+	return xfs_group_start_fsb(xg) | gbno;
+}
+
+static inline xfs_daddr_t
+xfs_gbno_to_daddr(
+	struct xfs_group	*xg,
+	xfs_agblock_t		gbno)
+{
+	struct xfs_mount	*mp = xg->xg_mount;
+	uint32_t		blocks = mp->m_groups[xg->xg_type].blocks;
+
+	return XFS_FSB_TO_BB(mp, (xfs_fsblock_t)xg->xg_index * blocks + gbno);
+}
+
+static inline uint32_t
+xfs_fsb_to_gno(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsbno,
+	enum xfs_group_type	type)
+{
+	if (!mp->m_groups[type].blklog)
+		return 0;
+	return fsbno >> mp->m_groups[type].blklog;
+}
+
+static inline xfs_agblock_t
+xfs_fsb_to_gbno(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsbno,
+	enum xfs_group_type	type)
+{
+	return fsbno & mp->m_groups[type].blkmask;
+}
 
 #endif /* __LIBXFS_GROUP_H */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 25bf121f7126a2..26f4e3d116f828 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -26,7 +26,7 @@ xfs_rtx_to_rtb(
 	xfs_rtxnum_t		rtx)
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
-	xfs_rtblock_t		start = xfs_rgno_start_rtb(mp, rtg_rgno(rtg));
+	xfs_rtblock_t		start = xfs_group_start_fsb(&rtg->rtg_group);
 
 	if (mp->m_rtxblklog >= 0)
 		return start + (rtx << mp->m_rtxblklog);
@@ -128,11 +128,11 @@ xfs_rtb_to_rtx(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	uint64_t		__rgbno = __xfs_rtb_to_rgbno(mp, rtbno);
-
+	/* open-coded 64-bit masking operation */
+	rtbno &= mp->m_groups[XG_TYPE_RTG].blkmask;
 	if (likely(mp->m_rtxblklog >= 0))
-		return __rgbno >> mp->m_rtxblklog;
-	return div_u64(__rgbno, mp->m_sb.sb_rextsize);
+		return rtbno >> mp->m_rtxblklog;
+	return div_u64(rtbno, mp->m_sb.sb_rextsize);
 }
 
 /* Return the offset of an rt block number within an rt extent. */
@@ -141,12 +141,11 @@ xfs_rtb_to_rtxoff(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	uint64_t		__rgbno = __xfs_rtb_to_rgbno(mp, rtbno);
-
+	/* open-coded 64-bit masking operation */
+	rtbno &= mp->m_groups[XG_TYPE_RTG].blkmask;
 	if (likely(mp->m_rtxblklog >= 0))
-		return __rgbno & mp->m_rtxblkmask;
-
-	return do_div(__rgbno, mp->m_sb.sb_rextsize);
+		return rtbno & mp->m_rtxblkmask;
+	return do_div(rtbno, mp->m_sb.sb_rextsize);
 }
 
 /* Round this file block offset up to the nearest rt extent size. */
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index baa445b15b8523..a0dfe3eae3da6e 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -117,31 +117,12 @@ xfs_rtgroup_next(
 	return xfs_rtgroup_next_range(mp, rtg, 0, mp->m_sb.sb_rgcount - 1);
 }
 
-static inline xfs_rtblock_t
-xfs_rgno_start_rtb(
-	struct xfs_mount	*mp,
-	xfs_rgnumber_t		rgno)
-{
-	if (!xfs_has_rtgroups(mp))
-		return 0;
-	return ((xfs_rtblock_t)rgno << mp->m_sb.sb_rgblklog);
-}
-
-static inline xfs_rtblock_t
-__xfs_rgbno_to_rtb(
-	struct xfs_mount	*mp,
-	xfs_rgnumber_t		rgno,
-	xfs_rgblock_t		rgbno)
-{
-	return xfs_rgno_start_rtb(mp, rgno) + rgbno;
-}
-
 static inline xfs_rtblock_t
 xfs_rgbno_to_rtb(
 	struct xfs_rtgroup	*rtg,
 	xfs_rgblock_t		rgbno)
 {
-	return __xfs_rgbno_to_rtb(rtg_mount(rtg), rtg_rgno(rtg), rgbno);
+	return xfs_gbno_to_fsb(&rtg->rtg_group, rgbno);
 }
 
 static inline xfs_rgnumber_t
@@ -149,21 +130,7 @@ xfs_rtb_to_rgno(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	if (!xfs_has_rtgroups(mp))
-		return 0;
-
-	return rtbno >> mp->m_sb.sb_rgblklog;
-}
-
-static inline uint64_t
-__xfs_rtb_to_rgbno(
-	struct xfs_mount	*mp,
-	xfs_rtblock_t		rtbno)
-{
-	if (!xfs_has_rtgroups(mp))
-		return rtbno;
-
-	return rtbno & mp->m_rgblkmask;
+	return xfs_fsb_to_gno(mp, rtbno, XG_TYPE_RTG);
 }
 
 static inline xfs_rgblock_t
@@ -171,7 +138,7 @@ xfs_rtb_to_rgbno(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	return __xfs_rtb_to_rgbno(mp, rtbno);
+	return xfs_fsb_to_gbno(mp, rtbno, XG_TYPE_RTG);
 }
 
 static inline xfs_daddr_t
@@ -179,10 +146,11 @@ xfs_rtb_to_daddr(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
 	xfs_rgnumber_t		rgno = xfs_rtb_to_rgno(mp, rtbno);
-	uint64_t		start_bno = (xfs_rtblock_t)rgno * mp->m_rgblocks;
+	uint64_t		start_bno = (xfs_rtblock_t)rgno * g->blocks;
 
-	return XFS_FSB_TO_BB(mp, start_bno + (rtbno & mp->m_rgblkmask));
+	return XFS_FSB_TO_BB(mp, start_bno + (rtbno & g->blkmask));
 }
 
 static inline xfs_rtblock_t
@@ -193,11 +161,12 @@ xfs_daddr_to_rtb(
 	xfs_rfsblock_t		bno = XFS_BB_TO_FSBT(mp, daddr);
 
 	if (xfs_has_rtgroups(mp)) {
+		struct xfs_groups *g = &mp->m_groups[XG_TYPE_RTG];
 		xfs_rgnumber_t	rgno;
 		uint32_t	rgbno;
 
-		rgno = div_u64_rem(bno, mp->m_rgblocks, &rgbno);
-		return ((xfs_rtblock_t)rgno << mp->m_sb.sb_rgblklog) + rgbno;
+		rgno = div_u64_rem(bno, g->blocks, &rgbno);
+		return ((xfs_rtblock_t)rgno << g->blklog) + rgbno;
 	}
 
 	return bno;
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ce09c40cfd265f..e5584adde31405 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1125,15 +1125,19 @@ xfs_sb_mount_rextsize(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
+	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
+
 	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
 	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
 
 	if (xfs_sb_version_hasmetadir(sbp)) {
-		mp->m_rgblocks = sbp->sb_rgextents * sbp->sb_rextsize;
-		mp->m_rgblkmask = (1ULL << sbp->sb_rgblklog) - 1;
+		rgs->blocks = sbp->sb_rgextents * sbp->sb_rextsize;
+		rgs->blklog = mp->m_sb.sb_rgblklog;
+		rgs->blkmask = xfs_mask32lo(mp->m_sb.sb_rgblklog);
 	} else {
-		mp->m_rgblocks = 0;
-		mp->m_rgblkmask = 0;
+		rgs->blocks = 0;
+		rgs->blklog = 0;
+		rgs->blkmask = (uint64_t)-1;
 	}
 }
 
@@ -1166,6 +1170,8 @@ xfs_sb_mount_common(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
+	struct xfs_groups	*ags = &mp->m_groups[XG_TYPE_AG];
+
 	mp->m_agfrotor = 0;
 	atomic_set(&mp->m_agirotor, 0);
 	mp->m_maxagi = mp->m_sb.sb_agcount;
@@ -1176,6 +1182,11 @@ xfs_sb_mount_common(
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = xfs_rtbmblock_size(sbp) >> XFS_WORDLOG;
 	mp->m_rtx_per_rbmblock = mp->m_blockwsize << XFS_NBWORDLOG;
+
+	ags->blocks = mp->m_sb.sb_agblocks;
+	ags->blklog = mp->m_sb.sb_agblklog;
+	ags->blkmask = xfs_mask32lo(mp->m_sb.sb_agblklog);
+
 	xfs_sb_mount_rextsize(mp, sbp);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, true);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 07fb3d91a88331..5c9c53b3591b2e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -71,8 +71,38 @@ struct xfs_inodegc {
 	unsigned int		cpu;
 };
 
+/*
+ * Container for each type of groups, used to look up individual groups and
+ * describes the geometry.
+ */
 struct xfs_groups {
 	struct xarray		xa;
+
+	/*
+	 * Maximum capacity of the group in FSBs.
+	 *
+	 * Each group is laid out densely in the daddr space.  For the
+	 * degenerate case of a pre-rtgroups filesystem, the incore rtgroup
+	 * pretends to have a zero-block and zero-blklog rtgroup.
+	 */
+	uint32_t		blocks;
+
+	/*
+	 * Log(2) of the logical size of each group.
+	 *
+	 * Compared to the blocks field above this is rounded up to the next
+	 * power of two, and thus lays out the xfs_fsblock_t/xfs_rtblock_t
+	 * space sparsely with a hole from blocks to (1 << blklog) at the end
+	 * of each group.
+	 */
+	uint8_t			blklog;
+
+	/*
+	 * Mask to extract the group-relative block number from a FSB.
+	 * For a pre-rtgroups filesystem we pretend to have one very large
+	 * rtgroup, so this mask must be 64-bit.
+	 */
+	uint64_t		blkmask;
 };
 
 /*
@@ -147,14 +177,12 @@ typedef struct xfs_mount {
 	int			m_logbsize;	/* size of each log buffer */
 	unsigned int		m_rsumlevels;	/* rt summary levels */
 	xfs_filblks_t		m_rsumblocks;	/* size of rt summary, FSBs */
-	uint32_t		m_rgblocks;	/* size of rtgroup in rtblocks */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint			m_qflags;	/* quota status flags */
 	uint64_t		m_features;	/* active filesystem features */
 	uint64_t		m_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_low_rtexts[XFS_LOWSP_MAX];
 	uint64_t		m_rtxblkmask;	/* rt extent block mask */
-	uint64_t		m_rgblkmask;	/* rt group block mask */
 	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
 						/* low free space thresholds */
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index aaa0ea06910d88..8f530e69c18ae7 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -6,12 +6,12 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
-#include "xfs_group.h"
 #include "xfs_bit.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_group.h"
 #include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0ea03dcd04769f..7beeaac0ad4cf0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2776,12 +2776,8 @@ DECLARE_EVENT_CLASS(xfs_free_extent_deferred_class,
 		__entry->dev = mp->m_super->s_dev;
 		__entry->type = free->xefi_group->xg_type;
 		__entry->agno = free->xefi_group->xg_index;
-		if (free->xefi_group->xg_type == XG_TYPE_RTG)
-			__entry->agbno = xfs_rtb_to_rgbno(mp,
-						free->xefi_startblock);
-		else
-			__entry->agbno = XFS_FSB_TO_AGBNO(mp,
-						free->xefi_startblock);
+		__entry->agbno = xfs_fsb_to_gbno(mp, free->xefi_startblock,
+						free->xefi_group->xg_type);
 		__entry->len = free->xefi_blockcount;
 		__entry->flags = free->xefi_flags;
 	),
@@ -3110,24 +3106,17 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
 		__entry->dev = mp->m_super->s_dev;
 		__entry->type = bi->bi_group->xg_type;
 		__entry->agno = bi->bi_group->xg_index;
-		switch (__entry->type) {
-		case XG_TYPE_RTG:
+		if (bi->bi_group->xg_type == XG_TYPE_RTG &&
+		    !xfs_has_rtgroups(mp)) {
 			/*
-			 * Use the 64-bit version of xfs_rtb_to_rgbno because
-			 * legacy rt filesystems can have group block numbers
-			 * that exceed the size of an xfs_rgblock_t.
+			 * Legacy rt filesystems have linear block numbers
+			 * that can overflow a 32-bit block number.
 			 */
-			__entry->gbno = __xfs_rtb_to_rgbno(mp,
-						bi->bi_bmap.br_startblock);
-			break;
-		case XG_TYPE_AG:
-			__entry->gbno = XFS_FSB_TO_AGBNO(mp,
-						bi->bi_bmap.br_startblock);
-			break;
-		default:
-			/* should never happen */
-			__entry->gbno = -1ULL;
-			break;
+			__entry->gbno = bi->bi_bmap.br_startblock;
+		} else {
+			__entry->gbno = xfs_fsb_to_gbno(mp,
+						bi->bi_bmap.br_startblock,
+						bi->bi_group->xg_type);
 		}
 		__entry->ino = ip->i_ino;
 		__entry->whichfork = bi->bi_whichfork;


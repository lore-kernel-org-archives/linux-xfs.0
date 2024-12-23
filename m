Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC8718052
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990187; cv=none; b=pyalYcMek9/bgHtli+6sN2zOdHBHuSI6qqqScPwDx/DB7hFHH/plFxHsMn+GKtVp+R2kIBc444pas8Lm42ysGA5rqxLJFXj+SQPOhCCWpYDNtic2RaO0vX4MVm7HJVa8RJImJ5GZDf3GHCb+M0SwMK9tw1ajKm6lycfN+os/Ih4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990187; c=relaxed/simple;
	bh=zp+i/tM2/QbTnmStAgeiIqTZHWvDK3lm12XI/xR1OqY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WWKRH6euRUySxnJ6aU4iEQcY7u6UIfZz9Uzzs0GCNYi/o7XcSFQaybK7aey0+PHQ/znvLifkCk0SLGDkKY7oG3DFDNWSx3DHkTfIDPxM0UKZ80iA90rFZUpaNyKxfUiYf6qnuwkNRRVJUV8N5eRGkbgG5p1ghPhcr+zeipSEc6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PO9tTDfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PO9tTDfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D84C4CED3;
	Mon, 23 Dec 2024 21:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990187;
	bh=zp+i/tM2/QbTnmStAgeiIqTZHWvDK3lm12XI/xR1OqY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PO9tTDfLeAmTNtf7MBSPMb8/OdepdbS9jlLPDMIjZphG5A3wC6Hc8UuayDq32P6Uy
	 zyVbY0ZKDazuK4+pkTR3wCP2vOA2SISngykgFaXcYGxQMIVkq0xaTl5qSdMgRKL9Gf
	 yBoKQvt5s8BYil3/lX743jQVAAUxDdo1U/LzEPKsd2ivPKWK4MQfwfckkONR4OpbFH
	 vfqkkLOjCy0GiWsSTmMk+mCeLPVyVdPFcgiUG8TsyBq+q8Vuly/qEIFK7/Ob3YUf5G
	 WRO9/tbmpn3C9X0PHa8MM/wMmA1jdchapa9fK+vXNmhwK0z00NvrGpDYBKYa1tcGkm
	 UHpsf/frXwXog==
Date: Mon, 23 Dec 2024 13:43:06 -0800
Subject: [PATCH 23/36] xfs: add group based bno conversion helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940294.2293042.11609429469117844134.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 759cc1989a53024066b0f2ea52c206b4ff8f522c

Add/move the blocks, blklog and blkmask fields to the generic groups
structure so that code can work with AGs and RTGs by just using the
right index into the array.

Then, add convenience helpers to convert block numbers based on the
generic group.  This will allow writing code that doesn't care if it is
used on AGs or the upcoming realtime groups.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_mount.h      |   26 +++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/xfs_group.c       |    9 +++++++
 libxfs/xfs_group.h       |   56 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_sb.c          |    7 ++++++
 repair/bmap_repair.c     |    2 +-
 6 files changed, 100 insertions(+), 1 deletion(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 2102009aa8df73..1d36e3986ead2f 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -26,6 +26,32 @@ enum {
 
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
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 8f3e9e8694675d..483a7a9a4cbf45 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -168,6 +168,7 @@
 #define xfs_free_extent_later		libxfs_free_extent_later
 #define xfs_free_perag_range		libxfs_free_perag_range
 #define xfs_fs_geometry			libxfs_fs_geometry
+#define xfs_gbno_to_fsb			libxfs_gbno_to_fsb
 #define xfs_get_initial_prid		libxfs_get_initial_prid
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
diff --git a/libxfs/xfs_group.c b/libxfs/xfs_group.c
index 9c7fa99d00b802..80b6993cc9916e 100644
--- a/libxfs/xfs_group.c
+++ b/libxfs/xfs_group.c
@@ -212,3 +212,12 @@ xfs_group_insert(
 #endif
 	return error;
 }
+
+struct xfs_group *
+xfs_group_get_by_fsb(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsbno,
+	enum xfs_group_type	type)
+{
+	return xfs_group_get(mp, xfs_fsb_to_gno(mp, fsbno, type), type);
+}
diff --git a/libxfs/xfs_group.h b/libxfs/xfs_group.h
index 0ff6e1d5635cb1..5b7362277c3f7a 100644
--- a/libxfs/xfs_group.h
+++ b/libxfs/xfs_group.h
@@ -46,6 +46,8 @@ struct xfs_group {
 
 struct xfs_group *xfs_group_get(struct xfs_mount *mp, uint32_t index,
 		enum xfs_group_type type);
+struct xfs_group *xfs_group_get_by_fsb(struct xfs_mount *mp,
+		xfs_fsblock_t fsbno, enum xfs_group_type type);
 struct xfs_group *xfs_group_hold(struct xfs_group *xg);
 void xfs_group_put(struct xfs_group *xg);
 
@@ -72,4 +74,58 @@ int xfs_group_insert(struct xfs_mount *mp, struct xfs_group *xg,
 #define xfs_group_marked(_mp, _type, _mark) \
 	xa_marked(&(_mp)->m_groups[(_type)].xa, (_mark))
 
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
+	return ((xfs_fsblock_t)xg->xg_gno) <<
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
+	return XFS_FSB_TO_BB(mp, (xfs_fsblock_t)xg->xg_gno * blocks + gbno);
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
+
 #endif /* __LIBXFS_GROUP_H */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index d32f789037389f..9120a3377735b0 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -999,6 +999,8 @@ xfs_sb_mount_common(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
+	struct xfs_groups	*ags = &mp->m_groups[XG_TYPE_AG];
+
 	mp->m_agfrotor = 0;
 	atomic_set(&mp->m_agirotor, 0);
 	mp->m_maxagi = mp->m_sb.sb_agcount;
@@ -1009,6 +1011,11 @@ xfs_sb_mount_common(
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
+
+	ags->blocks = mp->m_sb.sb_agblocks;
+	ags->blklog = mp->m_sb.sb_agblklog;
+	ags->blkmask = xfs_mask32lo(mp->m_sb.sb_agblklog);
+
 	xfs_mount_sb_set_rextsize(mp, sbp);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, true);
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index f052b5dcddff08..7e7c2a39f5724b 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -154,7 +154,7 @@ xrep_bmap_walk_rmap(
 	    !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
 		return 0;
 
-	fsbno = xfs_agbno_to_fsb(to_perag(cur->bc_group), rec->rm_startblock);
+	fsbno = libxfs_gbno_to_fsb(cur->bc_group, rec->rm_startblock);
 
 	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
 		rb->old_bmbt_block_count += rec->rm_blockcount;


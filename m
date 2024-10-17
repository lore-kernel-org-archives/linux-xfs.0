Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6E02194A0
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191259; cv=none; b=IZmSZ42soShz7JWiu4c/Ii4udantOmwKvEASxlyyXlwp/mx9gQ4RcAERkE4ninY+fZ2crACIA6rT+XVednNNZQrRp6Wsp7z2LWI5OaGc3+HtBZjQpxdsSMeuWoZPcJdDMVSCaf/5wn0+PNUJJrhmUNBoFL5wF+0Sv6Sb1yORMrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191259; c=relaxed/simple;
	bh=xdSlhFWTnk7OiNjLPJy3W+tiXBvS2g7IZmo4a8qClxc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hGHnnrStesqVByepqsxvJWpPdx3e9yQgUHiMB3Ovph9frGNY7mCd5i9zCncaQabq1WdU5Fo7x8bejkwPaHU9Sb4MeLSdvNmw9fA4KzNJ1OuBXvPYfJcWIAIwKfiyRGRw9qhhmFCoyJo9nyFvujiOVa0ALPDSOwyJhXcTAfopdqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LzSki5bp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LzSki5bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0AEC4CECD;
	Thu, 17 Oct 2024 18:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191257;
	bh=xdSlhFWTnk7OiNjLPJy3W+tiXBvS2g7IZmo4a8qClxc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LzSki5bpwy7CS4/IIuYCdPD0PP/uRn77w4gRdwHVASZnaJfhtXvbYhAgJ9Wc5j/mJ
	 V5hg9Lz0RniZwgTbLM7MI4hpYJetGLKPs18qyV69h090h9fwSi62stMZjQj0bwAr+u
	 Yt3L6BkQDccnhszDHex7EWszv6f758COwJenwsKZoH2Fld65TwL97NQnHIFpk/8XQy
	 lJ1hFrkuDKs5zC15yQpP09CFEkqqTbJmIumYtDCMfcL1M2EnWnDaaCLoARpAwDErGV
	 Vt72z4D6TeDvscl3euZNlZz1lwV0eliu+RSHyw8BjsMEk+X/55PcpPCnLVCosRcXS6
	 dG16k1L/y7bQw==
Date: Thu, 17 Oct 2024 11:54:16 -0700
Subject: [PATCH 14/16] xfs: add group based bno conversion helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068922.3450737.1548793440571079834.stgit@frogsfrogsfrogs>
In-Reply-To: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
References: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Add/move the blocks, blklog and blkmask fields to the generic groups
structure so that code can work with AGs and RTGs by just using the
right index into the array.

Then, add convenience helpers to convert block numbers based on the
generic group.  This will allow writing code that doesn't care if it is
used on AGs or the upcoming realtime groups.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_group.c |    9 +++++++
 fs/xfs/libxfs/xfs_group.h |   56 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c    |    7 ++++++
 fs/xfs/xfs_mount.h        |   30 ++++++++++++++++++++++++
 4 files changed, 102 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 5c6fa5d76a91b1..e9d76bcdc820dd 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -214,3 +214,12 @@ xfs_group_insert(
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
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 0ff6e1d5635cb1..5b7362277c3f7a 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 061c8c961d5bc9..f7a07e61341ded 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -988,6 +988,8 @@ xfs_sb_mount_common(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
+	struct xfs_groups	*ags = &mp->m_groups[XG_TYPE_AG];
+
 	mp->m_agfrotor = 0;
 	atomic_set(&mp->m_agirotor, 0);
 	mp->m_maxagi = mp->m_sb.sb_agcount;
@@ -998,6 +1000,11 @@ xfs_sb_mount_common(
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
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 530d7f025506ce..1b698878f40cb1 100644
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


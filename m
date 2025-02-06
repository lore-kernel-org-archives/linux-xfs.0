Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2992423C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881698; cv=none; b=ZIQrZZ12+nu2dTsLm4FVrPe9As1pZtiPpOBBiiTcLJDNFoSXyX98niflqwz8FT6/hZQQ/7X0KcONxKYViAXID98lU0j4kmR4+0Uhx4gGf4jWR/9iTVjD+VfjSg1Ru8C8nG+WKLcDx3OszwdkQU8un0J6jfPxSXV6MCg9dCcf6BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881698; c=relaxed/simple;
	bh=WnvpUY9rSV+q8AEmRSNEFEwLqzgo6UAlJHHjI7MOY5Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZTBIIffw22g+XfvrVuHACCLsUURQQDWACNtpzjMDpJ/yFteGpBIur6OM72cDc297niOw611UOvH0gqpDISjIcILW6xXTbV1lrH60vlTonmrauJOSfBIzU5zEWbknWr0vtlKQqiW/f7e/8KOtp0UgtD/kfEmsFP7YludRdq16syw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bOcLhZIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bOcLhZIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018BBC4CEDD;
	Thu,  6 Feb 2025 22:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881698;
	bh=WnvpUY9rSV+q8AEmRSNEFEwLqzgo6UAlJHHjI7MOY5Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bOcLhZIvf8MJ/BDCObAfSfVmZYtApokmjqMalizzQOAC0/HFTpYqlIoy4J7MFynCX
	 dT2HNmy/TJpfFbhLyDq355/NsTpS8bJoM2YWEH4CNxUUDsSPW/zdDWLa5nygMcShqG
	 tWsvFJNCBLjZyvQLLNks3zTlCIg6OJJYy0wCtjBZ+tAkVGh0MBuMkUi1FJVDPvSjTu
	 rxB+uFauqvYE/0NqxVr9cd3WJ86twIDUnD7EUbEbo9g5tbkdFmov4xSmIxS8GHnaxs
	 wZnkIifyyFdAhplJkE7yXUEaoIbIYfKdUTAwEZTwohKUOSWfXoLx8ArNLjUSKjnV2m
	 U2QUJqBVzzjrg==
Date: Thu, 06 Feb 2025 14:41:37 -0800
Subject: [PATCH 25/56] xfs: report realtime rmap btree corruption errors to
 the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087174.2739176.13151406990633887326.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 6d4933c221958d1e1848d5092a3e3d1c6e4a6f92

Whenever we encounter corrupt realtime rmap btree blocks, we should
report that to the health monitoring system for later reporting.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree.h        |    2 +-
 libxfs/xfs_fs.h           |    1 +
 libxfs/xfs_health.h       |    4 +++-
 libxfs/xfs_rtgroup.c      |    1 +
 libxfs/xfs_rtrmap_btree.c |   10 ++++++++--
 5 files changed, 14 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index ee82dc777d6d5b..dbc047b2fb2cf5 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -135,7 +135,7 @@ struct xfs_btree_ops {
 	/* offset of btree stats array */
 	unsigned int		statoff;
 
-	/* sick mask for health reporting (only for XFS_BTREE_TYPE_AG) */
+	/* sick mask for health reporting (not for bmap btrees) */
 	unsigned int		sick_mask;
 
 	/* cursor operations */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 41ce4d3d650ec7..7cca458ff81245 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -993,6 +993,7 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1U << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
 #define XFS_RTGROUP_GEOM_SICK_SUMMARY	(1U << 2)  /* rtsummary */
+#define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
 
 /*
  * ioctl commands that are used by Linux filesystems
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index d34986ac18c3fa..5c8a0aff6ba6e9 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -70,6 +70,7 @@ struct xfs_rtgroup;
 #define XFS_SICK_RG_SUPER	(1 << 0)  /* rt group superblock */
 #define XFS_SICK_RG_BITMAP	(1 << 1)  /* rt group bitmap */
 #define XFS_SICK_RG_SUMMARY	(1 << 2)  /* rt groups summary */
+#define XFS_SICK_RG_RMAPBT	(1 << 3)  /* reverse mappings */
 
 /* Observable health issues for AG metadata. */
 #define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
@@ -115,7 +116,8 @@ struct xfs_rtgroup;
 
 #define XFS_SICK_RG_PRIMARY	(XFS_SICK_RG_SUPER | \
 				 XFS_SICK_RG_BITMAP | \
-				 XFS_SICK_RG_SUMMARY)
+				 XFS_SICK_RG_SUMMARY | \
+				 XFS_SICK_RG_RMAPBT)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index c40b02be0f41b9..7e69b6bf96f1ac 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -354,6 +354,7 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 	[XFS_RTGI_RMAP] = {
 		.name		= "rmap",
 		.metafile_type	= XFS_METAFILE_RTRMAP,
+		.sick		= XFS_SICK_RG_RMAPBT,
 		.fmt_mask	= 1U << XFS_DINODE_FMT_META_BTREE,
 		/*
 		 * growfs must create the rtrmap inodes before adding a
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index a14f2bec8aaa52..387c9f17118d52 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -25,6 +25,7 @@
 #include "xfs_cksum.h"
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -494,6 +495,7 @@ const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 
 	.lru_refs		= XFS_RMAP_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_rtrmap_2),
+	.sick_mask		= XFS_SICK_RG_RMAPBT,
 
 	.dup_cursor		= xfs_rtrmapbt_dup_cursor,
 	.alloc_block		= xfs_btree_alloc_metafile_block,
@@ -753,16 +755,20 @@ xfs_iformat_rtrmap(
 	 * growfs must create the rtrmap inodes before adding a realtime volume
 	 * to the filesystem, so we cannot use the rtrmapbt predicate here.
 	 */
-	if (!xfs_has_rmapbt(ip->i_mount))
+	if (!xfs_has_rmapbt(ip->i_mount)) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
+	}
 
 	dsize = XFS_DFORK_SIZE(dip, mp, XFS_DATA_FORK);
 	numrecs = be16_to_cpu(dfp->bb_numrecs);
 	level = be16_to_cpu(dfp->bb_level);
 
 	if (level > mp->m_rtrmap_maxlevels ||
-	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize)
+	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
+	}
 
 	broot = xfs_broot_alloc(xfs_ifork_ptr(ip, XFS_DATA_FORK),
 			xfs_rtrmap_broot_space_calc(mp, level, numrecs));


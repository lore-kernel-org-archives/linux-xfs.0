Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA6B2837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994897; cv=none; b=Im42h+DW2ZGTwmcu/RETgJc4k5az84E4khsauW5vDte6sT1j59RKbKDxelSBbyWtgbKox4SW+4EA/SFULPPgfZwWBm+AImSq38nJAFnew1V6igpGBayyLetLkUVWarqnvjF0iS/k/hLYSTUfA/6zq9b2rU3JD8Xp3ufr7gGB9Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994897; c=relaxed/simple;
	bh=OnPhQR6UEqyau+TqinIqktVmn9ZFqklSTLP4HVgRbw8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JB9zaqUJ5AE3PSrknT7yCt3hEKKYPeECTW3uZ72j5/uQKwEhrOy1qUm0QyGv7kP0MJJkXgcKA/OF6pnWaZK4xj8KYe5m9Ny8uziKsTJvmFZfM5C2+0FgiCI6cYTNjnnkmdTYbU+aWwYjmkBf4DjIcqvtovDcGJit22w7JgBAduY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lHrvNwIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lHrvNwIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F515C4CED3;
	Mon, 23 Dec 2024 23:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994896;
	bh=OnPhQR6UEqyau+TqinIqktVmn9ZFqklSTLP4HVgRbw8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lHrvNwIsQKJ28NzSxAVgmeAmC19Fe8ijdIqNjzZgWWhfUXfXVc9f8GkStg+5jB7m7
	 7vJsW62mybwM5uuK1cmbsdGWaFO6uWEYwY66twUTGl+xKj2/F7lvLJi7Nq8W+ZZNFE
	 yb24Hc8RrU02LzTayN6pyCVAYz0RzwFf9mqh/+f1+K+qUQgz2FHxF32JiDw1g6fFL7
	 90kv/7zcV4JOWfGkIhHC+h1r78gzMXkREyy9XscpxNx7ctcg/XhFGs6OiilicPyvQF
	 gDYMA594mx0eWl9hrzeXQeEOeqN7JyKqtoJSZaJtZW8gaoFvZGgX+hcBWmTr9UlPoT
	 L9g3f+TxJOZnw==
Date: Mon, 23 Dec 2024 15:01:36 -0800
Subject: [PATCH 19/37] xfs: report realtime rmap btree corruption errors to
 the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499419043.2380130.18078444054227332977.stgit@frogsfrogsfrogs>
In-Reply-To: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
References: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Whenever we encounter corrupt realtime rmap btree blocks, we should
report that to the health monitoring system for later reporting.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree.h        |    2 +-
 fs/xfs/libxfs/xfs_fs.h           |    1 +
 fs/xfs/libxfs/xfs_health.h       |    4 +++-
 fs/xfs/libxfs/xfs_rtgroup.c      |    1 +
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   10 ++++++++--
 fs/xfs/xfs_health.c              |    1 +
 6 files changed, 15 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index ee82dc777d6d5b..dbc047b2fb2cf5 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -135,7 +135,7 @@ struct xfs_btree_ops {
 	/* offset of btree stats array */
 	unsigned int		statoff;
 
-	/* sick mask for health reporting (only for XFS_BTREE_TYPE_AG) */
+	/* sick mask for health reporting (not for bmap btrees) */
 	unsigned int		sick_mask;
 
 	/* cursor operations */
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 41ce4d3d650ec7..7cca458ff81245 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -993,6 +993,7 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1U << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
 #define XFS_RTGROUP_GEOM_SICK_SUMMARY	(1U << 2)  /* rtsummary */
+#define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
 
 /*
  * ioctl commands that are used by Linux filesystems
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index d34986ac18c3fa..5c8a0aff6ba6e9 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
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
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 5f31b6e65d5d17..b7ed2d27d54553 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -357,6 +357,7 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 	[XFS_RTGI_RMAP] = {
 		.name		= "rmap",
 		.metafile_type	= XFS_METAFILE_RTRMAP,
+		.sick		= XFS_SICK_RG_RMAPBT,
 		.fmt_mask	= 1U << XFS_DINODE_FMT_META_BTREE,
 		/*
 		 * growfs must create the rtrmap inodes before adding a
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 4de7720d2f4e94..19e5109c3683ce 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -27,6 +27,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -496,6 +497,7 @@ const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 
 	.lru_refs		= XFS_RMAP_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_rtrmap_2),
+	.sick_mask		= XFS_SICK_RG_RMAPBT,
 
 	.dup_cursor		= xfs_rtrmapbt_dup_cursor,
 	.alloc_block		= xfs_btree_alloc_metafile_block,
@@ -755,16 +757,20 @@ xfs_iformat_rtrmap(
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
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index c7c2e656199862..d438c3c001c829 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -447,6 +447,7 @@ static const struct ioctl_sick_map rtgroup_map[] = {
 	{ XFS_SICK_RG_SUPER,	XFS_RTGROUP_GEOM_SICK_SUPER },
 	{ XFS_SICK_RG_BITMAP,	XFS_RTGROUP_GEOM_SICK_BITMAP },
 	{ XFS_SICK_RG_SUMMARY,	XFS_RTGROUP_GEOM_SICK_SUMMARY },
+	{ XFS_SICK_RG_RMAPBT,	XFS_RTGROUP_GEOM_SICK_RMAPBT },
 };
 
 /* Fill out rtgroup geometry health info. */


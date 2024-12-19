Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CAE1A42C4
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637204; cv=none; b=smL4+AKryOfZQriqUHhGcLIpMZhcLiys9qim9jvUmx1oZwhrclqLIpp/33v25ZfcFxRfo8+bqw+8MGMyjxByE17kCS6SQkMFJZSDwTRLicgxxKwFS2sY2S9uOqm55AssBcgDKWQx6sAS5WjcFlyTVzq6j+xihLdmuAPm9KaEm/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637204; c=relaxed/simple;
	bh=R4TKCQ/WbFiYOPkFciYR/JcNGU5i8CMzJ6tVWSqf5ZI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xzd6AE4TYGAbTQbfjJLVi35kKD3Qy90wS9DPf4Y5qB/HsFZfiw6RwL9wo+LjIVYjBquX/b88BLFxbX/KJ/EwLH9i1cwZ/VZn2krAX5mRv4n0gzFmS/Mb7+4zyynP3TInWSckxHzs5tr9UgfmAdqKaXpjAAsnYQTasRaNdZx+Xb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QmiW3OpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QmiW3OpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9865C4CECE;
	Thu, 19 Dec 2024 19:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637204;
	bh=R4TKCQ/WbFiYOPkFciYR/JcNGU5i8CMzJ6tVWSqf5ZI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QmiW3OpQ4Qjh0HOD90lVVFYPbB0XGi3yyieJjqTfETNcJ7CQ6g6CPHO69VG+5jhIZ
	 K5cXJyp4qE1wIrvBaQ9sXX98JebPx39+0MzQSk0Ni0xy+6am4i2nxJm741qaijNKaw
	 Xqpd2Yd/xbLvlQ/y9LtgcM3jNm8TQKuoCfLRbjAJ33YzxJHlzcspoz0sxL1aa5NS2L
	 i0pA4CUvwEsFsZGpVoFpbdwRtVfHVDuMFO2W+0HJroiG4VIiud2iy9rKGJ4ioSh4gf
	 X6JUvtA3P0Mc1SloHpSKUGKGA0gM1mH2U9xZbXvZJQbrCA0Fo1XSdhouXYw0l7qDPQ
	 +gQz/b2tnAJ4A==
Date: Thu, 19 Dec 2024 11:40:04 -0800
Subject: [PATCH 27/43] xfs: report realtime refcount btree corruption errors
 to the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581440.1572761.11893001846505305956.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Whenever we encounter corrupt realtime refcount btree blocks, we should
report that to the health monitoring system for later reporting.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h               |    1 +
 fs/xfs/libxfs/xfs_health.h           |    4 +++-
 fs/xfs/libxfs/xfs_rtgroup.c          |    1 +
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   10 ++++++++--
 fs/xfs/xfs_health.c                  |    1 +
 5 files changed, 14 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d42d3a5617e314..ea9e58a89d92d3 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -996,6 +996,7 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
 #define XFS_RTGROUP_GEOM_SICK_SUMMARY	(1U << 2)  /* rtsummary */
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
+#define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
 
 /*
  * ioctl commands that are used by Linux filesystems
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 5c8a0aff6ba6e9..b31000f7190ce5 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -71,6 +71,7 @@ struct xfs_rtgroup;
 #define XFS_SICK_RG_BITMAP	(1 << 1)  /* rt group bitmap */
 #define XFS_SICK_RG_SUMMARY	(1 << 2)  /* rt groups summary */
 #define XFS_SICK_RG_RMAPBT	(1 << 3)  /* reverse mappings */
+#define XFS_SICK_RG_REFCNTBT	(1 << 4)  /* reference counts */
 
 /* Observable health issues for AG metadata. */
 #define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
@@ -117,7 +118,8 @@ struct xfs_rtgroup;
 #define XFS_SICK_RG_PRIMARY	(XFS_SICK_RG_SUPER | \
 				 XFS_SICK_RG_BITMAP | \
 				 XFS_SICK_RG_SUMMARY | \
-				 XFS_SICK_RG_RMAPBT)
+				 XFS_SICK_RG_RMAPBT | \
+				 XFS_SICK_RG_REFCNTBT)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index eab655a4a9ef5c..a6468e591232c3 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -380,6 +380,7 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 	[XFS_RTGI_REFCOUNT] = {
 		.name		= "refcount",
 		.metafile_type	= XFS_METAFILE_RTREFCOUNT,
+		.sick		= XFS_SICK_RG_REFCNTBT,
 		.fmt_mask	= 1U << XFS_DINODE_FMT_META_BTREE,
 		/* same comment about growfs and rmap inodes applies here */
 		.enabled	= xfs_has_reflink,
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 151fb1ef7db126..3db5e7a4a94567 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -27,6 +27,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_metafile.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_rtrefcountbt_cur_cache;
 
@@ -374,6 +375,7 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 
 	.lru_refs		= XFS_REFC_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_rtrefcbt_2),
+	.sick_mask		= XFS_SICK_RG_REFCNTBT,
 
 	.dup_cursor		= xfs_rtrefcountbt_dup_cursor,
 	.alloc_block		= xfs_btree_alloc_metafile_block,
@@ -640,16 +642,20 @@ xfs_iformat_rtrefcount(
 	 * volume to the filesystem, so we cannot use the rtrefcount predicate
 	 * here.
 	 */
-	if (!xfs_has_reflink(ip->i_mount))
+	if (!xfs_has_reflink(ip->i_mount)) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
+	}
 
 	dsize = XFS_DFORK_SIZE(dip, mp, XFS_DATA_FORK);
 	numrecs = be16_to_cpu(dfp->bb_numrecs);
 	level = be16_to_cpu(dfp->bb_level);
 
 	if (level > mp->m_rtrefc_maxlevels ||
-	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize)
+	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
+	}
 
 	broot = xfs_broot_alloc(xfs_ifork_ptr(ip, XFS_DATA_FORK),
 			xfs_rtrefcount_broot_space_calc(mp, level, numrecs));
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index d438c3c001c829..7c541fb373d5b2 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -448,6 +448,7 @@ static const struct ioctl_sick_map rtgroup_map[] = {
 	{ XFS_SICK_RG_BITMAP,	XFS_RTGROUP_GEOM_SICK_BITMAP },
 	{ XFS_SICK_RG_SUMMARY,	XFS_RTGROUP_GEOM_SICK_SUMMARY },
 	{ XFS_SICK_RG_RMAPBT,	XFS_RTGROUP_GEOM_SICK_RMAPBT },
+	{ XFS_SICK_RG_REFCNTBT,	XFS_RTGROUP_GEOM_SICK_REFCNTBT },
 };
 
 /* Fill out rtgroup geometry health info. */


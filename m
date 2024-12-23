Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2B02837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995600; cv=none; b=hfOwfJgHnIFb/ipiQqAUB3h6EDcpfPf5Ab0iMKvrNgQWPLeJ35AWBuIe8GmRyamj5kImD/pr3/tGZ4a8hz/KnAzRHdce5UPWKbA2N1s2zDHaDR/K+W3zzvWGPCRqhRlXm3Pw7/eQn0VAdDIMUKwlnnHwwvxUHZTJDL9hWgvgsgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995600; c=relaxed/simple;
	bh=R4TKCQ/WbFiYOPkFciYR/JcNGU5i8CMzJ6tVWSqf5ZI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TxGkKhKEFrKALq2cDeLK5W7zhraX4CNYsJa21JYDeTC+3z/AGqew0MFb45lvDIJX3xg9hS7N7UFnnXWj2LEqh96X/DFapQrhjDeh8bQsrC47JrtJVgxfLX3LqhswrSA3Pj9Y2IikRelizh+RJYCN0+iuCxdRA5wsQUDXvPf74uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPQV5aOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPQV5aOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A75C4CED3;
	Mon, 23 Dec 2024 23:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995599;
	bh=R4TKCQ/WbFiYOPkFciYR/JcNGU5i8CMzJ6tVWSqf5ZI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iPQV5aOuxxYgpA7jJosCIcjerXWAHr35ArX0XWWinnThoy/sfzq56SuYnGln71yid
	 rLi0CsGr3+fYpJ+aD8YmXwP6x2zlAd8EoRacks5Sss/mUC9W8YzOYuFX9hxisbtHHh
	 xV7xYCDmPyMr5WNifYVSLbPwKXh1PszpjCE2F+6Snc7BGNtPTSRqhphvJJH5HO09za
	 sAfc3ZMiu8fa1FJ3MyhbeoCRjbqn6oSaB5KPd8tpa5rPI1AdDSVRfL1KqIXHodf877
	 hWjWdS/yuYFOD/CsUrBaEtKaXqobEyTYyy2IJUpvXgd7yKcvcASKwarr6h7+XB7IR6
	 s9/IpFVZCaNvg==
Date: Mon, 23 Dec 2024 15:13:19 -0800
Subject: [PATCH 27/43] xfs: report realtime refcount btree corruption errors
 to the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420401.2381378.1632456717599526900.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
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


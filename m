Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668533D561
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052637; cv=none; b=VYlfazJqjnfuVp989PsHhxDViPwIZwFi1xj61aMa98YysFCtoHkbMn7oxj5j+qHQKxOMxkNML/0eTA0hzeSCj7WsEQm9nrk/zPEI5vbW3FSNwG7x1Wssimhg7iK5s1MgEcDNCLp7A10zMguBP2A+ya9AnpqdSWH1RO3jdonflx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052637; c=relaxed/simple;
	bh=/1ptkg6xGGazqDHvDt5e46mJafKhaJQV270lG4c87K8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MBuGajDYzQ8id4HZeqP/CUuF0HCO8MxT6HISRJe0YNKCEm0b3aBzWNaC2qcK4hlI7Onqvjo6ihjm3UtAtz40NT4bF34ZH+rXNGbJWVgRjV4Q/MdF64S1q0Buw1H5bhZPCWvzMd2NYHllcj3Fz2c0IpRRqbeue+WccMA9/n0kaWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pltc75DM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pltc75DM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B73C4CECE;
	Fri, 13 Dec 2024 01:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052637;
	bh=/1ptkg6xGGazqDHvDt5e46mJafKhaJQV270lG4c87K8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pltc75DMMjeYa3pD9tTx7dY9+FfquXm4firC5Wlz83WVDoxk8Flk7QqhAXOdr9Oi1
	 OHtipkTgKe9YQeJh8ADu8n3OWq8k17DT5F7N1rLU0SRqLcUpnGHpAvwIPhcaTyIAMe
	 dEJYj+BhNXfD+JHgQT3QszVLSdhWXc5WEYAQAb+Hd0Qv9BvLmqFELlcoJYKbZSSLZC
	 UY5dU2XrWlKsiTtYtszrWnJTEw8jiko3CBnX/PeG1FDegXzoZHkwiSMF8p1OpTH0uZ
	 g9HYdYeAm6Hd4Mp4LiWkXtRrOsg4dlAT4+TSKtz7lemHMnjKjg1RCUL1ZcuSbGytHw
	 XVSh34iLYQaYg==
Date: Thu, 12 Dec 2024 17:17:16 -0800
Subject: [PATCH 27/43] xfs: report realtime refcount btree corruption errors
 to the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125029.1182620.6787400699658875832.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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


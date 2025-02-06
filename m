Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA0D19C55E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882075; cv=none; b=XSNqiYU7dQe4m0BeuLuBjUI4mdaghM0QdVLX+n8paBx9QuTx+xl9Tveap4oQ7MH6Nd7uhz59RIhQ2wQvhcQ5UXt5Kd5qBVmCSMeXb3c2sAdpcchwNv1Q5Wu0PKjqlxvr6ARjjyIuacIus6wD4tT1oCvvA4RN3edm1VVGCtN5VBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882075; c=relaxed/simple;
	bh=1RWeZiPCs8Qmw2h4HteqjMDN14+UlWTK3rKed6ZYM1M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R3LsKAQq87gUtP+8FD817MvpyEahBPaY8EXNdhJG/kf07esEoB2NcLUOe7J69xpsITfG7rXrNSXbKirEIvjyePlJFt+MOb1HacFg1OHmoNNKwShdwTCYNUjlfbbvuoX52ofSn6nJ8Kd6Le3Qtqm6wft21QCQR7zpuvbvmmTzXJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AiqyfLDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AiqyfLDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7C9C4CEDD;
	Thu,  6 Feb 2025 22:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882074;
	bh=1RWeZiPCs8Qmw2h4HteqjMDN14+UlWTK3rKed6ZYM1M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AiqyfLDBZaQhMbw/X0zBxFDbbIOGLQGMNRHcWNX4x+8zUFJdyFz+ZiUyW7H4u45I0
	 va4HdqwgOIa09EQm5JZgU5lHPvf81MEpTC8IL2PIxOTSToemgFO37Dhm73OKianwp8
	 dTDYac3Hy8MP2LI1NtcBe1v6AxgoK0iaSdXIld3cCYaDcCEFQ7+4KBDsLNf3m2Hmb5
	 ojAhwWz7AtcGWIybOjrRDbP83F19NO9T1YWdEOVe09WTE92RikJRL79uw9exG6wChW
	 lWom4+LvhwBHZWFlwfG5+9FOdGZPaXAjobEKwkXnlHEUznUOZEtQBgQaS+EzMuasWs
	 fIUYemiLnc2cw==
Date: Thu, 06 Feb 2025 14:47:54 -0800
Subject: [PATCH 49/56] xfs: report realtime refcount btree corruption errors
 to the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087543.2739176.16984791426238847318.stgit@frogsfrogsfrogs>
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

Source kernel commit: 026c8ed8d4580228949f177445c605d475880c93

Whenever we encounter corrupt realtime refcount btree blocks, we should
report that to the health monitoring system for later reporting.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h               |    1 +
 libxfs/xfs_health.h           |    4 +++-
 libxfs/xfs_rtgroup.c          |    1 +
 libxfs/xfs_rtrefcount_btree.c |   10 ++++++++--
 4 files changed, 13 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index d42d3a5617e314..ea9e58a89d92d3 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -996,6 +996,7 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
 #define XFS_RTGROUP_GEOM_SICK_SUMMARY	(1U << 2)  /* rtsummary */
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
+#define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
 
 /*
  * ioctl commands that are used by Linux filesystems
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 5c8a0aff6ba6e9..b31000f7190ce5 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
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
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 74701264265ce2..ba1a38633a6ead 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -377,6 +377,7 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 	[XFS_RTGI_REFCOUNT] = {
 		.name		= "refcount",
 		.metafile_type	= XFS_METAFILE_RTREFCOUNT,
+		.sick		= XFS_SICK_RG_REFCNTBT,
 		.fmt_mask	= 1U << XFS_DINODE_FMT_META_BTREE,
 		/* same comment about growfs and rmap inodes applies here */
 		.enabled	= xfs_has_reflink,
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index fa6c114d9cbc5a..a532476407e913 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -25,6 +25,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_metafile.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_rtrefcountbt_cur_cache;
 
@@ -372,6 +373,7 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 
 	.lru_refs		= XFS_REFC_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_rtrefcbt_2),
+	.sick_mask		= XFS_SICK_RG_REFCNTBT,
 
 	.dup_cursor		= xfs_rtrefcountbt_dup_cursor,
 	.alloc_block		= xfs_btree_alloc_metafile_block,
@@ -638,16 +640,20 @@ xfs_iformat_rtrefcount(
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


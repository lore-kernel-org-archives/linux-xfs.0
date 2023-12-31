Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4B3BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jGxpYVpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDFEC433C7;
	Sun, 31 Dec 2023 21:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058652;
	bh=mVFtsuYnkp5sJOAr7e7qjuzc1/ugqe/dcfPuCSZ1Rao=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jGxpYVpmZeA5d/Juu57M0pZ+jJtfZdO/QPnXQZCyCiBIIvHGAfVUH3dfdmmUZJgPo
	 ERXRrX43ReEMEls3Ypbz86a9auLgPSUwrUB10HfARTxq75hdTo7FYYXHIj1IGTod1K
	 +YupqpGTpdsfuAq1HM2PEqPoWhNp8XZPThcKJDinAAA/aJMhFAGwL16DwG9/FVPYjp
	 wHExEBOIAh8K6krooPNjLqkFpn7OVnIdVMk6WZle+t9iFRPBbyMxnUqGqy4fWZ9Im1
	 /9pxjGZOMgUihG4UNw64aeLsFo/QL0W+baJePRSJbVGcaNMRxMFJouYbZNq9fj4870
	 6qw898P3tamZg==
Date: Sun, 31 Dec 2023 13:37:31 -0800
Subject: [PATCH 22/39] xfs: report realtime rmap btree corruption errors to
 the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850253.1764998.8292417915212123414.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Whenever we encounter corrupt realtime rmap btree blocks, we should
report that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs_staging.h   |    1 +
 fs/xfs/libxfs/xfs_health.h       |    4 +++-
 fs/xfs/libxfs/xfs_inode_fork.c   |    4 +++-
 fs/xfs/libxfs/xfs_rtrmap_btree.c |    5 ++++-
 fs/xfs/xfs_health.c              |    4 ++++
 fs/xfs/xfs_rtalloc.c             |    2 ++
 6 files changed, 17 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs_staging.h b/fs/xfs/libxfs/xfs_fs_staging.h
index 1f57331487791..9d5d6af62b616 100644
--- a/fs/xfs/libxfs/xfs_fs_staging.h
+++ b/fs/xfs/libxfs/xfs_fs_staging.h
@@ -216,6 +216,7 @@ struct xfs_rtgroup_geometry {
 };
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1 << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1 << 1)  /* rtbitmap for this group */
+#define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1 << 2)  /* reverse mappings */
 
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 63, struct xfs_rtgroup_geometry)
 
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 1e9938a417b42..aeeb62769773f 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -68,6 +68,7 @@ struct xfs_rtgroup;
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
 #define XFS_SICK_RT_SUMMARY	(1 << 1)  /* realtime summary */
 #define XFS_SICK_RT_SUPER	(1 << 2)  /* rt group superblock */
+#define XFS_SICK_RT_RMAPBT	(1 << 3)  /* reverse mappings */
 
 /* Observable health issues for AG metadata. */
 #define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
@@ -113,7 +114,8 @@ struct xfs_rtgroup;
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY | \
-				 XFS_SICK_RT_SUPER)
+				 XFS_SICK_RT_SUPER | \
+				 XFS_SICK_RT_RMAPBT)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index ab54a9b27c781..e7ab04aea2db6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -266,8 +266,10 @@ xfs_iformat_data_fork(
 		case XFS_DINODE_FMT_BTREE:
 			return xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
 		case XFS_DINODE_FMT_RMAP:
-			if (!xfs_has_rtrmapbt(ip->i_mount))
+			if (!xfs_has_rtrmapbt(ip->i_mount)) {
+				xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 				return -EFSCORRUPTED;
+			}
 			return xfs_iformat_rtrmap(ip, dip);
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index b824562bdc2ec..355c50196e986 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -27,6 +27,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -800,8 +801,10 @@ xfs_iformat_rtrmap(
 	level = be16_to_cpu(dfp->bb_level);
 
 	if (level > mp->m_rtrmap_maxlevels ||
-	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize)
+	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
+	}
 
 	xfs_iroot_alloc(ip, XFS_DATA_FORK,
 			xfs_rtrmap_broot_space_calc(mp, level, numrecs));
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index b53ef95a37a54..ed0767a6fa15a 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -532,6 +532,7 @@ xfs_ag_geom_health(
 static const struct ioctl_sick_map rtgroup_map[] = {
 	{ XFS_SICK_RT_SUPER,	XFS_RTGROUP_GEOM_SICK_SUPER },
 	{ XFS_SICK_RT_BITMAP,	XFS_RTGROUP_GEOM_SICK_BITMAP },
+	{ XFS_SICK_RT_RMAPBT,	XFS_RTGROUP_GEOM_SICK_RMAPBT },
 	{ 0, 0 },
 };
 
@@ -636,6 +637,9 @@ xfs_btree_mark_sick(
 	case XFS_BTNUM_BMAP:
 		xfs_bmap_mark_sick(cur->bc_ino.ip, cur->bc_ino.whichfork);
 		return;
+	case XFS_BTNUM_RTRMAP:
+		xfs_rtgroup_mark_sick(cur->bc_ino.rtg, XFS_SICK_RT_RMAPBT);
+		return;
 	case XFS_BTNUM_BNO:
 		mask = XFS_SICK_AG_BNOBT;
 		break;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f6b23439b674d..37156cf8acd25 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1781,6 +1781,7 @@ xfs_rtmount_rmapbt(
 		goto out_path;
 
 	if (ino == NULLFSINO) {
+		xfs_rtgroup_mark_sick(rtg, XFS_SICK_RT_RMAPBT);
 		error = -EFSCORRUPTED;
 		goto out_path;
 	}
@@ -1790,6 +1791,7 @@ xfs_rtmount_rmapbt(
 		goto out_path;
 
 	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_RMAP)) {
+		xfs_rtgroup_mark_sick(rtg, XFS_SICK_RT_RMAPBT);
 		error = -EFSCORRUPTED;
 		goto out_rele;
 	}


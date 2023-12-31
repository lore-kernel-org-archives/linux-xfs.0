Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC4AC8CA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJG66Y3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95817C433C7;
	Sun, 31 Dec 2023 21:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059512;
	bh=zZ2tiHsQhAWPnqxOyOyy7TQf2FeeVF+COYbY/hlBjKo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dJG66Y3eHAWVajNbK19rKNUhcfkGrbgmeprrI2qoC5vGlSluckmdlhSMa54D26eT/
	 VHyWhDOs3fatYhm3qJPNW9XnKd0yaZZtf68BIX+W0BsnRMMqsRL51UohSAVXdqgLzU
	 DfHpE5Eek7i9fKzrReYm1tyxQq3gX8Z3f7gCCHCeJ0PBq7dk5A7ojfurikQrvaJcX2
	 hVlMK/0ox1B2aN9IdNp6Hua/Zro68u7Zs4d70oEzAKdVL2tYVcGAJTBNJ+ysRrEdtW
	 1fXjoxZPfFkVeJGgmiILp3Vd0zPP0Yejie9fwC+7akNT93xkJ3hxTmnwqvsp6Xdt9A
	 zpT6H/7pJQUAw==
Date: Sun, 31 Dec 2023 13:51:52 -0800
Subject: [PATCH 28/44] xfs: report realtime refcount btree corruption errors
 to the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852031.1766284.15779582679192002528.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

Whenever we encounter corrupt realtime refcount btree blocks, we should
report that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs_staging.h       |    1 +
 fs/xfs/libxfs/xfs_health.h           |    4 +++-
 fs/xfs/libxfs/xfs_inode_fork.c       |    4 +++-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |    5 ++++-
 fs/xfs/xfs_health.c                  |    4 ++++
 fs/xfs/xfs_rtalloc.c                 |    2 ++
 6 files changed, 17 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs_staging.h b/fs/xfs/libxfs/xfs_fs_staging.h
index 9d5d6af62b616..9f0c03103f05b 100644
--- a/fs/xfs/libxfs/xfs_fs_staging.h
+++ b/fs/xfs/libxfs/xfs_fs_staging.h
@@ -217,6 +217,7 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1 << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1 << 1)  /* rtbitmap for this group */
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1 << 2)  /* reverse mappings */
+#define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1 << 3)  /* reference counts */
 
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 63, struct xfs_rtgroup_geometry)
 
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index aeeb62769773f..4fe4daca4c4f4 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -69,6 +69,7 @@ struct xfs_rtgroup;
 #define XFS_SICK_RT_SUMMARY	(1 << 1)  /* realtime summary */
 #define XFS_SICK_RT_SUPER	(1 << 2)  /* rt group superblock */
 #define XFS_SICK_RT_RMAPBT	(1 << 3)  /* reverse mappings */
+#define XFS_SICK_RT_REFCNTBT	(1 << 4)  /* reference counts */
 
 /* Observable health issues for AG metadata. */
 #define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
@@ -115,7 +116,8 @@ struct xfs_rtgroup;
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY | \
 				 XFS_SICK_RT_SUPER | \
-				 XFS_SICK_RT_RMAPBT)
+				 XFS_SICK_RT_RMAPBT | \
+				 XFS_SICK_RT_REFCNTBT)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index df42ffa15d96e..9ff913d0fa140 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -273,8 +273,10 @@ xfs_iformat_data_fork(
 			}
 			return xfs_iformat_rtrmap(ip, dip);
 		case XFS_DINODE_FMT_REFCOUNT:
-			if (!xfs_has_rtreflink(ip->i_mount))
+			if (!xfs_has_rtreflink(ip->i_mount)) {
+				xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 				return -EFSCORRUPTED;
+			}
 			return xfs_iformat_rtrefcount(ip, dip);
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index fb0e4abcd6f6a..47ce0acd92a19 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -27,6 +27,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_imeta.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_rtrefcountbt_cur_cache;
 
@@ -694,8 +695,10 @@ xfs_iformat_rtrefcount(
 	level = be16_to_cpu(dfp->bb_level);
 
 	if (level > mp->m_rtrefc_maxlevels ||
-	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize)
+	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
+	}
 
 	xfs_iroot_alloc(ip, XFS_DATA_FORK,
 			xfs_rtrefcount_broot_space_calc(mp, level, numrecs));
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index ed0767a6fa15a..6f40e2b728e27 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -533,6 +533,7 @@ static const struct ioctl_sick_map rtgroup_map[] = {
 	{ XFS_SICK_RT_SUPER,	XFS_RTGROUP_GEOM_SICK_SUPER },
 	{ XFS_SICK_RT_BITMAP,	XFS_RTGROUP_GEOM_SICK_BITMAP },
 	{ XFS_SICK_RT_RMAPBT,	XFS_RTGROUP_GEOM_SICK_RMAPBT },
+	{ XFS_SICK_RT_REFCNTBT,	XFS_RTGROUP_GEOM_SICK_REFCNTBT },
 	{ 0, 0 },
 };
 
@@ -640,6 +641,9 @@ xfs_btree_mark_sick(
 	case XFS_BTNUM_RTRMAP:
 		xfs_rtgroup_mark_sick(cur->bc_ino.rtg, XFS_SICK_RT_RMAPBT);
 		return;
+	case XFS_BTNUM_RTREFC:
+		xfs_rtgroup_mark_sick(cur->bc_ino.rtg, XFS_SICK_RT_REFCNTBT);
+		return;
 	case XFS_BTNUM_BNO:
 		mask = XFS_SICK_AG_BNOBT;
 		break;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 1dd76cb757534..11b6645a5a534 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1931,6 +1931,7 @@ xfs_rtmount_refcountbt(
 		goto out_path;
 
 	if (ino == NULLFSINO) {
+		xfs_rtgroup_mark_sick(rtg, XFS_SICK_RT_REFCNTBT);
 		error = -EFSCORRUPTED;
 		goto out_path;
 	}
@@ -1940,6 +1941,7 @@ xfs_rtmount_refcountbt(
 		goto out_path;
 
 	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_REFCOUNT)) {
+		xfs_rtgroup_mark_sick(rtg, XFS_SICK_RT_REFCNTBT);
 		error = -EFSCORRUPTED;
 		goto out_rele;
 	}


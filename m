Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F90384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cWvxFGON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA12C433C8;
	Mon,  1 Jan 2024 00:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068066;
	bh=VzH9xyguqN/CJ4FlituhP5sgsw7tPQDIhUdlL7QjTOY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cWvxFGONkBXBBaSdTDJOmJ6kvFIsIRx5z9QV9UBVFaoTMvFMC3IH5fPn13sud0XWW
	 bK+jJHfe6cjjb6JImjsIpw/VWjKdjNyNLT8tk8RhJiUs6kbTTYhkH6YpDwBipqvd3S
	 IyRVYuqLUDqTm7QxT6dv4o5Pj8vvv/TpLTcePv1x9UBCBaW8kw6omWsuwtFvFWxqv5
	 tegSg5n+8RSYqgni3RvGAh6Iq04WpTvKYfy5vHcR6qSkT0A1VXX0KuI5W3Zb0MtDMJ
	 SJ1AEDmFRVKnqfi9n5UA5P/ZcMiEhTs6HxqOw6kiDTIrs08IX7b2Vc03K6NV0MiVC7
	 FonBOHLxmE+5Q==
Date: Sun, 31 Dec 2023 16:14:25 +9900
Subject: [PATCH 15/47] xfs: report realtime rmap btree corruption errors to
 the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015513.1815505.15975259091873127380.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_fs_staging.h               |    1 +
 libxfs/xfs_health.h                   |    4 +++-
 libxfs/xfs_inode_fork.c               |    4 +++-
 libxfs/xfs_rtrmap_btree.c             |    5 ++++-
 man/man2/ioctl_xfs_rtgroup_geometry.2 |    3 +++
 5 files changed, 14 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_fs_staging.h b/libxfs/xfs_fs_staging.h
index 1f573314877..9d5d6af62b6 100644
--- a/libxfs/xfs_fs_staging.h
+++ b/libxfs/xfs_fs_staging.h
@@ -216,6 +216,7 @@ struct xfs_rtgroup_geometry {
 };
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1 << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1 << 1)  /* rtbitmap for this group */
+#define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1 << 2)  /* reverse mappings */
 
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 63, struct xfs_rtgroup_geometry)
 
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 1e9938a417b..aeeb6276977 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
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
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 0e6cd5bacdb..127571527cf 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -264,8 +264,10 @@ xfs_iformat_data_fork(
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
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 832a58cfe13..5a25791baa5 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -25,6 +25,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
 #include "xfs_imeta.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -798,8 +799,10 @@ xfs_iformat_rtrmap(
 	level = be16_to_cpu(dfp->bb_level);
 
 	if (level > mp->m_rtrmap_maxlevels ||
-	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize)
+	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
+	}
 
 	xfs_iroot_alloc(ip, XFS_DATA_FORK,
 			xfs_rtrmap_broot_space_calc(mp, level, numrecs));
diff --git a/man/man2/ioctl_xfs_rtgroup_geometry.2 b/man/man2/ioctl_xfs_rtgroup_geometry.2
index ccd931d1e17..38753b93055 100644
--- a/man/man2/ioctl_xfs_rtgroup_geometry.2
+++ b/man/man2/ioctl_xfs_rtgroup_geometry.2
@@ -73,6 +73,9 @@ Realtime group superblock.
 .TP
 .B XFS_RTGROUP_GEOM_SICK_BITMAP
 Realtime bitmap for this group.
+.TP
+.B XFS_RTGROUP_GEOM_SICK_RTRMAPBT
+Reverse mapping btree for this group.
 .RE
 .SH RETURN VALUE
 On error, \-1 is returned, and


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9341368
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btMx+snJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B501C433C7;
	Mon,  1 Jan 2024 00:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069082;
	bh=p7SzpXFfWKx9X/L1JBQACXNCAqBhgILpCVro/FX3bmk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=btMx+snJZKzlMxEctM+XChpd9C4rkDJHvUzQR8u8paBBTjXYIofSzGxxDc9lE6Gzf
	 GIPvOQ3CS7+RIdrXMBH8Hept1DIcDGtCyWmMJQQLlcxtvZiG1HrnfHw/3cq7goD5Ib
	 AphtOi5wH5FFj3wjn4CYegumNvljagqHjdhW6SeAbQhDpXzAToAARZw6Y3W/vOD9fR
	 3rPgBK8tDm0Wiib7Z+6Fz2H+QDslMmCIhyzmXjSTvZ/YOmb1RF8BYWxTsjB46Y5wNp
	 vjVX3+v6x/S3jJ23eoF/Vn9v9plcbJ+6GJyvE5xClKzI4BKHf1Sb7dR9urgIrYrfYo
	 aAJ9yImU7MF7Q==
Date: Sun, 31 Dec 2023 16:31:21 +9900
Subject: [PATCH 20/42] xfs: report realtime refcount btree corruption errors
 to the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017393.1817107.357076305390627042.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_fs_staging.h               |    1 +
 libxfs/xfs_health.h                   |    4 +++-
 libxfs/xfs_inode_fork.c               |    4 +++-
 libxfs/xfs_rtrefcount_btree.c         |    5 ++++-
 man/man2/ioctl_xfs_rtgroup_geometry.2 |    3 +++
 5 files changed, 14 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_fs_staging.h b/libxfs/xfs_fs_staging.h
index 9d5d6af62b6..9f0c03103f0 100644
--- a/libxfs/xfs_fs_staging.h
+++ b/libxfs/xfs_fs_staging.h
@@ -217,6 +217,7 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1 << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1 << 1)  /* rtbitmap for this group */
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1 << 2)  /* reverse mappings */
+#define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1 << 3)  /* reference counts */
 
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 63, struct xfs_rtgroup_geometry)
 
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index aeeb6276977..4fe4daca4c4 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
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
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index bfc06af904e..a25f6bd1f20 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -271,8 +271,10 @@ xfs_iformat_data_fork(
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
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index fa04395eed0..035e41137a6 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -25,6 +25,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_imeta.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_rtrefcountbt_cur_cache;
 
@@ -692,8 +693,10 @@ xfs_iformat_rtrefcount(
 	level = be16_to_cpu(dfp->bb_level);
 
 	if (level > mp->m_rtrefc_maxlevels ||
-	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize)
+	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
+	}
 
 	xfs_iroot_alloc(ip, XFS_DATA_FORK,
 			xfs_rtrefcount_broot_space_calc(mp, level, numrecs));
diff --git a/man/man2/ioctl_xfs_rtgroup_geometry.2 b/man/man2/ioctl_xfs_rtgroup_geometry.2
index 38753b93055..0e4e4592b22 100644
--- a/man/man2/ioctl_xfs_rtgroup_geometry.2
+++ b/man/man2/ioctl_xfs_rtgroup_geometry.2
@@ -76,6 +76,9 @@ Realtime bitmap for this group.
 .TP
 .B XFS_RTGROUP_GEOM_SICK_RTRMAPBT
 Reverse mapping btree for this group.
+.TP
+.B XFS_RTGROUP_GEOM_SICK_REFCNTBT
+Reference count btree for this group.
 .RE
 .SH RETURN VALUE
 On error, \-1 is returned, and


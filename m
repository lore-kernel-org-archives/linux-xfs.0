Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 473FC825F
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:38:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B2D2DAC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:38:12 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Np8Fij3utN5jbOkF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:38:10 -0700 (PDT)
Subject: [PATCH 069/145] mkfs: set agsize prior to calculating minimum log size
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:38:03 -0700
Message-ID: <146612748368.16048.1300674297898667346.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Each btree has its own maxlevels variable.  Since the level count of
certain btrees depend on agblocks, it's necessary to know the AG size
prior to calculating the log reservations.  These reservations are
needed to calculate the log size and the kernel will refuse to mount
if we guess too low, so stuff in the real agsize when we're formatting
the log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_multidisk.h |    2 +-
 mkfs/maxtrres.c         |    3 ++-
 mkfs/xfs_mkfs.c         |    3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
index fe3e98f..4429dab 100644
--- a/include/xfs_multidisk.h
+++ b/include/xfs_multidisk.h
@@ -66,7 +66,7 @@ extern void parse_proto (xfs_mount_t *mp, struct fsxattr *fsx, char **pp);
 extern void res_failed (int err);
 
 /* maxtrres.c */
-extern int max_trans_res (int crcs_enabled, int dirversion,
+extern int max_trans_res(unsigned long agsize, int crcs_enabled, int dirversion,
 		int sectorlog, int blocklog, int inodelog, int dirblocklog,
 		int logversion, int log_sunit, int finobt);
 
diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index f48a0f7..c0b1b5d 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -29,6 +29,7 @@
 
 int
 max_trans_res(
+	unsigned long	agsize,
 	int		crcs_enabled,
 	int		dirversion,
 	int		sectorlog,
@@ -50,7 +51,7 @@ max_trans_res(
 	sbp->sb_sectsize = 1 << sbp->sb_sectlog;
 	sbp->sb_blocklog = blocklog;
 	sbp->sb_blocksize = 1 << blocklog;
-	sbp->sb_agblocks = XFS_AG_MIN_BYTES / (1 << blocklog);
+	sbp->sb_agblocks = agsize;
 	sbp->sb_inodelog = inodelog;
 	sbp->sb_inopblog = blocklog - inodelog;
 	sbp->sb_inodesize = 1 << inodelog;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4b5df98..8b3cad8 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2887,7 +2887,8 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		lsunit = (32 * 1024) >> blocklog;
 	}
 
-	min_logblocks = max_trans_res(sb_feat.crcs_enabled, sb_feat.dir_version,
+	min_logblocks = max_trans_res(agsize,
+				   sb_feat.crcs_enabled, sb_feat.dir_version,
 				   sectorlog, blocklog, inodelog, dirblocklog,
 				   sb_feat.log_version, lsunit, sb_feat.finobt);
 	ASSERT(min_logblocks);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

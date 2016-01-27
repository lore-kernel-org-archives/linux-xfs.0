Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8AC507CA2
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 22:45:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35958AC004
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 20:44:58 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id MrzQW3LR4GnlhuBI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jan 2016 20:44:55 -0800 (PST)
Date: Tue, 26 Jan 2016 20:44:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 6/5] mkfs: factor finobt changes into min log size when
	formatting
Message-ID: <20160127044448.GA20038@birch.djwong.org>
References: <20160123003502.2475.99558.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160123003502.2475.99558.stgit@birch.djwong.org>
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
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

Since the finobt affects the size of the log reservations, we need to
be able to include its effects in the calculation of the minimum log
size.

(Not really a problem now, but adding rmapbt will give this one some
bite.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/maxtrres.c |    5 ++++-
 mkfs/xfs_mkfs.c |    2 +-
 mkfs/xfs_mkfs.h |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index e1d5ee9..b97d020 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -36,7 +36,8 @@ max_trans_res(
 	int		inodelog,
 	int		dirblocklog,
 	int		logversion,
-	int		log_sunit)
+	int		log_sunit,
+	int		finobt)
 {
 	xfs_sb_t	*sbp;
 	xfs_mount_t	mount;
@@ -68,6 +69,8 @@ max_trans_res(
 			(dirversion == 2 ? XFS_SB_VERSION_DIRV2BIT : 0) |
 			(logversion > 1 ? XFS_SB_VERSION_LOGV2BIT : 0) |
 			XFS_DFL_SB_VERSION_BITS;
+	if (finobt)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_FINOBT;
 
 	libxfs_mount(&mount, sbp, 0,0,0,0);
 	maxfsb = xfs_log_calc_minimum_size(&mount);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 700d12c..4c3a802 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2406,7 +2406,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 
 	min_logblocks = max_trans_res(crcs_enabled, dirversion,
 				   sectorlog, blocklog, inodelog, dirblocklog,
-				   logversion, lsunit);
+				   logversion, lsunit, finobt);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
 	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
diff --git a/mkfs/xfs_mkfs.h b/mkfs/xfs_mkfs.h
index 9df5f37..128068e 100644
--- a/mkfs/xfs_mkfs.h
+++ b/mkfs/xfs_mkfs.h
@@ -84,6 +84,6 @@ extern void res_failed (int err);
 /* maxtrres.c */
 extern int max_trans_res (int crcs_enabled, int dirversion,
 		int sectorlog, int blocklog, int inodelog, int dirblocklog,
-		int logversion, int log_sunit);
+		int logversion, int log_sunit, int finobt);
 
 #endif	/* __XFS_MKFS_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D54A7834B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:41:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A203930404E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:41:52 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id M8fj8OU9KfxHHBas (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:41:51 -0700 (PDT)
Subject: [PATCH 104/145] xfs: increase log reservations for reflink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:41:43 -0700
Message-ID: <146612770352.16048.10431104509314627818.stgit@birch.djwong.org>
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

Increase the log reservations to handle the increased rolling that
happens at the end of copy-on-write operations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_trans_resv.c |   16 +++++++++++++---
 libxfs/xfs_trans_resv.h |    2 ++
 2 files changed, 15 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 5b6bbcd..5152a5b 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -811,11 +811,18 @@ xfs_trans_resv_calc(
 	 * require a permanent reservation on space.
 	 */
 	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp);
-	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
+	else
+		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
-	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		resp->tr_itruncate.tr_logcount =
+				XFS_ITRUNCATE_LOG_COUNT_REFLINK;
+	else
+		resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
 	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
@@ -872,7 +879,10 @@ xfs_trans_resv_calc(
 	resp->tr_growrtalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_qm_dqalloc.tr_logres = xfs_calc_qm_dqalloc_reservation(mp);
-	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
+	else
+		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	/*
diff --git a/libxfs/xfs_trans_resv.h b/libxfs/xfs_trans_resv.h
index 36a1511..b7e5357 100644
--- a/libxfs/xfs_trans_resv.h
+++ b/libxfs/xfs_trans_resv.h
@@ -87,6 +87,7 @@ struct xfs_trans_resv {
 #define	XFS_DEFAULT_LOG_COUNT		1
 #define	XFS_DEFAULT_PERM_LOG_COUNT	2
 #define	XFS_ITRUNCATE_LOG_COUNT		2
+#define	XFS_ITRUNCATE_LOG_COUNT_REFLINK	8
 #define XFS_INACTIVE_LOG_COUNT		2
 #define	XFS_CREATE_LOG_COUNT		2
 #define	XFS_CREATE_TMPFILE_LOG_COUNT	2
@@ -96,6 +97,7 @@ struct xfs_trans_resv {
 #define	XFS_LINK_LOG_COUNT		2
 #define	XFS_RENAME_LOG_COUNT		2
 #define	XFS_WRITE_LOG_COUNT		2
+#define	XFS_WRITE_LOG_COUNT_REFLINK	8
 #define	XFS_ADDAFORK_LOG_COUNT		2
 #define	XFS_ATTRINVAL_LOG_COUNT		1
 #define	XFS_ATTRSET_LOG_COUNT		3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

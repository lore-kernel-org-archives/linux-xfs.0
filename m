Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49461 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935716AbcI3DLX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:11:23 -0400
Subject: [PATCH 52/63] xfs: increase log reservations for reflink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:11:18 -0700
Message-ID: <147520507840.29434.13617252095470528080.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Increase the log reservations to handle the increased rolling that
happens at the end of copy-on-write operations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c |   16 +++++++++++++---
 fs/xfs/libxfs/xfs_trans_resv.h |    2 ++
 2 files changed, 15 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index a59838f..b456cca 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -812,11 +812,18 @@ xfs_trans_resv_calc(
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
@@ -873,7 +880,10 @@ xfs_trans_resv_calc(
 	resp->tr_growrtalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_qm_dqalloc.tr_logres = xfs_calc_qm_dqalloc_reservation(mp);
-	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
+	else
+		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 36a1511..b7e5357 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
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


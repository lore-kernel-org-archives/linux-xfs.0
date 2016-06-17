Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 90A1B7F6C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:29:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 50DD98F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:29:17 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 6TksABSxAvgpZKfJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:29:15 -0700 (PDT)
Subject: [PATCH 104/119] xfs: increase log reservations for reflink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:29:04 -0700
Message-ID: <146612694469.12839.5547568012324469527.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56382 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbfAACWn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:22:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012E2G9168464
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:22:42 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2pnxedxaun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:22:42 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012MeNq030052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:22:41 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012MeBW027271
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:22:40 GMT
Subject: [PATCH 02/13] xfs: create transaction reservations for metadata
 inode operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:22:39 -0800
Message-ID: <154630935956.21716.7954680040325712549.stgit@magnolia>
In-Reply-To: <154630934595.21716.17416691804044507782.stgit@magnolia>
References: <154630934595.21716.17416691804044507782.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create transaction reservation types and block reservation helpers to
help us calculate transaction requirements.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_imeta.c      |   20 +++++++++++++
 fs/xfs/libxfs/xfs_imeta.h      |    3 ++
 fs/xfs/libxfs/xfs_trans_resv.c |   61 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.h |    2 +
 4 files changed, 86 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index 2599b236f6de..86b05992599a 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -17,6 +17,10 @@
 #include "xfs_imeta.h"
 #include "xfs_trace.h"
 #include "xfs_inode.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_trans_space.h"
 
 /*
  * Metadata Inode Number Management
@@ -379,3 +383,19 @@ xfs_imeta_mount(
 {
 	return 0;
 }
+
+/* Calculate the log block reservation to create a metadata inode. */
+unsigned int
+xfs_imeta_create_space_res(
+	struct xfs_mount	*mp)
+{
+	return XFS_IALLOC_SPACE_RES(mp);
+}
+
+/* Calculate the log block reservation to unlink a metadata inode. */
+unsigned int
+xfs_imeta_unlink_space_res(
+	struct xfs_mount	*mp)
+{
+	return XFS_REMOVE_SPACE_RES(mp);
+}
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index 373d40703dec..7740e7bd03e5 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -40,4 +40,7 @@ void xfs_imeta_end_update(struct xfs_mount *mp, struct xfs_imeta_end *cleanup,
 bool xfs_is_static_meta_ino(struct xfs_mount *mp, xfs_ino_t ino);
 int xfs_imeta_mount(struct xfs_mount *mp);
 
+unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
+unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
+
 #endif /* __XFS_IMETA_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index bf9815743114..dd3bf0c63410 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -778,6 +778,56 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
+/*
+ * Metadata inode creation needs enough space to create or mkdir a directory,
+ * plus logging the superblock.
+ */
+static unsigned int
+xfs_calc_imeta_create_resv(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret;
+
+	ret = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+	ret += resp->tr_create.tr_logres;
+	return ret;
+}
+
+/* Metadata inode creation needs enough rounds to create or mkdir a directory */
+static int
+xfs_calc_imeta_create_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	return resp->tr_create.tr_logcount;
+}
+
+/*
+ * Metadata inode unlink needs enough space to remove a file plus logging the
+ * superblock.
+ */
+static unsigned int
+xfs_calc_imeta_unlink_resv(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret;
+
+	ret = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+	ret += resp->tr_remove.tr_logres;
+	return ret;
+}
+
+/* Metadata inode creation needs enough rounds to remove a file. */
+static int
+xfs_calc_imeta_unlink_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	return resp->tr_remove.tr_logcount;
+}
+
 void
 xfs_trans_resv_calc(
 	struct xfs_mount	*mp,
@@ -888,4 +938,15 @@ xfs_trans_resv_calc(
 	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
 	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
+
+	/* metadata inode creation and unlink */
+	resp->tr_imeta_create.tr_logres = xfs_calc_imeta_create_resv(mp, resp);
+	resp->tr_imeta_create.tr_logcount =
+			xfs_calc_imeta_create_count(mp, resp);
+	resp->tr_imeta_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_imeta_unlink.tr_logres = xfs_calc_imeta_unlink_resv(mp, resp);
+	resp->tr_imeta_unlink.tr_logcount =
+			xfs_calc_imeta_unlink_count(mp, resp);
+	resp->tr_imeta_unlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 }
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 7241ab28cf84..7f7d86671319 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -50,6 +50,8 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
+	struct xfs_trans_res	tr_imeta_create; /* create metadata inode */
+	struct xfs_trans_res	tr_imeta_unlink; /* unlink metadata inode */
 };
 
 /* shorthand way of accessing reservation structure */

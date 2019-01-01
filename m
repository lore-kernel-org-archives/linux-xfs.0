Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56538 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbfAACXA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:23:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012F3BA169015
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:22:59 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2pnxedxaut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:22:58 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012Mrmm015790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:22:53 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012MqoB008360
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:22:53 GMT
Subject: [PATCH 04/13] xfs: convert all users to xfs_imeta_log
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:22:51 -0800
Message-ID: <154630937173.21716.11939017688750544410.stgit@magnolia>
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

Convert all open-coded sb metadata inode pointer logging to use
xfs_imeta_log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_qm.c |   78 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b5f2853a5009..4b8a48fb5780 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -26,6 +26,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_cksum.h"
+#include "xfs_imeta.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -742,6 +743,18 @@ xfs_qm_destroy_quotainfo(
 	mp->m_quotainfo = NULL;
 }
 
+static inline const struct xfs_imeta_path *
+xfs_qflags_to_imeta(
+	unsigned int	qflags)
+{
+	if (qflags & XFS_QMOPT_UQUOTA)
+		return &XFS_IMETA_USRQUOTA;
+	else if (qflags & XFS_QMOPT_GQUOTA)
+		return &XFS_IMETA_GRPQUOTA;
+	else
+		return &XFS_IMETA_PRJQUOTA;
+}
+
 /*
  * Switch the group and project quota in-core inode pointers if needed.
  *
@@ -749,6 +762,12 @@ xfs_qm_destroy_quotainfo(
  * between gquota and pquota. If the on-disk superblock has GQUOTA and the
  * filesystem is now mounted with PQUOTA, just use sb_gquotino for sb_pquotino
  * and vice-versa.
+ *
+ * We tolerate the direct manipulation of the in-core sb quota inode pointers
+ * here because calling xfs_imeta_log is only really required for filesystems
+ * with the metadata directory feature.  That feature requires a v5 superblock,
+ * which always supports simultaneous group and project quotas, so we'll never
+ * get here.
  */
 STATIC int
 xfs_qm_qino_switch(
@@ -783,8 +802,13 @@ xfs_qm_qino_switch(
 	if (error)
 		return error;
 
-	mp->m_sb.sb_gquotino = NULLFSINO;
-	mp->m_sb.sb_pquotino = NULLFSINO;
+	if (flags & XFS_QMOPT_PQUOTA) {
+		mp->m_sb.sb_gquotino = NULLFSINO;
+		mp->m_sb.sb_pquotino = ino;
+	} else if (flags & XFS_QMOPT_GQUOTA) {
+		mp->m_sb.sb_gquotino = ino;
+		mp->m_sb.sb_pquotino = NULLFSINO;
+	}
 	*need_alloc = false;
 	return 0;
 }
@@ -795,37 +819,26 @@ xfs_qm_qino_switch(
  */
 STATIC int
 xfs_qm_qino_alloc(
-	xfs_mount_t	*mp,
-	xfs_inode_t	**ip,
-	uint		flags)
+	struct xfs_mount		*mp,
+	struct xfs_inode		**ip,
+	uint				flags)
 {
-	struct xfs_ialloc_args	args = {
-		.ops	= &xfs_default_ialloc_ops,
-		.nlink	= 1,
-		.mode	= S_IFREG,
-	};
-	xfs_trans_t	*tp;
-	int		error;
-	bool		need_alloc = true;
+	struct xfs_imeta_end		ic;
+	struct xfs_trans		*tp;
+	const struct xfs_imeta_path	*path = xfs_qflags_to_imeta(flags);
+	int				error;
+	bool				need_alloc = true;
 
 	*ip = NULL;
 	error = xfs_qm_qino_switch(mp, ip, flags, &need_alloc);
 	if (error)
 		return error;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
-			XFS_QM_QINOCREATE_SPACE_RES(mp), 0, 0, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			xfs_imeta_create_space_res(mp), 0, 0, &tp);
 	if (error)
 		return error;
 
-	if (need_alloc) {
-		error = xfs_dir_ialloc(&tp, &args, ip);
-		if (error) {
-			xfs_trans_cancel(tp);
-			return error;
-		}
-	}
-
 	/*
 	 * Make the changes in the superblock, and log those too.
 	 * sbfields arg may contain fields other than *QUOTINO;
@@ -843,22 +856,27 @@ xfs_qm_qino_alloc(
 		/* qflags will get updated fully _after_ quotacheck */
 		mp->m_sb.sb_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
 	}
-	if (flags & XFS_QMOPT_UQUOTA)
-		mp->m_sb.sb_uquotino = (*ip)->i_ino;
-	else if (flags & XFS_QMOPT_GQUOTA)
-		mp->m_sb.sb_gquotino = (*ip)->i_ino;
-	else
-		mp->m_sb.sb_pquotino = (*ip)->i_ino;
 	spin_unlock(&mp->m_sb_lock);
 	xfs_log_sb(tp);
 
+	if (need_alloc) {
+		error = xfs_imeta_create(&tp, path, S_IFREG, ip, &ic);
+		if (error) {
+			xfs_trans_cancel(tp);
+			xfs_imeta_end_update(mp, &ic, error);
+			return error;
+		}
+	}
+
 	error = xfs_trans_commit(tp);
 	if (error) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
 	}
-	if (need_alloc)
+	if (need_alloc) {
+		xfs_imeta_end_update(mp, &ic, error);
 		xfs_finish_inode_setup(*ip);
+	}
 	return error;
 }
 

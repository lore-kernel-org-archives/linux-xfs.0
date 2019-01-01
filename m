Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39532 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbfAACXC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:23:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012EFNB173632
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:00 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2pp1jqx45d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:23:00 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012MxwN013443
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:22:59 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012MxAj004382
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:22:59 GMT
Subject: [PATCH 05/13] xfs: iget for metadata inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:22:57 -0800
Message-ID: <154630937786.21716.1154582079168264872.stgit@magnolia>
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

Create a xfs_iget_meta function for metadata inodes to ensure that we
always check that the inobt thinks a metadata inode is in use.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_imeta.h |    5 +++++
 fs/xfs/xfs_icache.c       |   27 +++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c        |    7 +++++++
 fs/xfs/xfs_qm.c           |   33 +++++++++++++++++----------------
 fs/xfs/xfs_qm_syscalls.c  |    4 +++-
 fs/xfs/xfs_rtalloc.c      |   15 +++++++++------
 6 files changed, 68 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index 7740e7bd03e5..5321dba38bbe 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -43,4 +43,9 @@ int xfs_imeta_mount(struct xfs_mount *mp);
 unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
 unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
 
+/* Must be implemented by the libxfs client */
+int xfs_imeta_iget(struct xfs_mount *mp, xfs_ino_t ino, unsigned char ftype,
+		  struct xfs_inode **ipp);
+void xfs_imeta_irele(struct xfs_inode *ip);
+
 #endif /* __XFS_IMETA_H__ */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f00c6f4bc515..7c459e37396d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -22,6 +22,8 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
+#include "xfs_da_format.h"
+#include "xfs_dir2.h"
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -910,6 +912,31 @@ xfs_icache_inode_is_allocated(
 	return 0;
 }
 
+/* Get a metadata inode.  The ftype must match exactly. */
+int
+xfs_imeta_iget(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	unsigned char		ftype,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_inode	*ip;
+	int			error;
+
+	error = xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED, 0, &ip);
+	if (error)
+		return error;
+
+	if (ftype == XFS_DIR3_FT_UNKNOWN ||
+	    xfs_mode_to_ftype(VFS_I(ip)->i_mode) != ftype) {
+		xfs_irele(ip);
+		return -EFSCORRUPTED;
+	}
+
+	*ipp = ip;
+	return 0;
+}
+
 /*
  * The inode lookup is done in batches to keep the amount of lock traffic and
  * radix tree lookups to a minimum. The batch size is a trade off between
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f177e0ded21c..d2de7cd87b07 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2654,6 +2654,13 @@ xfs_irele(
 	iput(VFS_I(ip));
 }
 
+void
+xfs_imeta_irele(
+	struct xfs_inode	*ip)
+{
+	xfs_irele(ip);
+}
+
 /*
  * Decide if this inode have post-EOF blocks.  The caller is responsible
  * for knowing / caring about the PREALLOC/APPEND flags.
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 4b8a48fb5780..c6ab9fe531d5 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -27,6 +27,7 @@
 #include "xfs_icache.h"
 #include "xfs_cksum.h"
 #include "xfs_imeta.h"
+#include "xfs_da_format.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -232,15 +233,15 @@ xfs_qm_unmount_quotas(
 	 */
 	if (mp->m_quotainfo) {
 		if (mp->m_quotainfo->qi_uquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_uquotaip);
+			xfs_imeta_irele(mp->m_quotainfo->qi_uquotaip);
 			mp->m_quotainfo->qi_uquotaip = NULL;
 		}
 		if (mp->m_quotainfo->qi_gquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_gquotaip);
+			xfs_imeta_irele(mp->m_quotainfo->qi_gquotaip);
 			mp->m_quotainfo->qi_gquotaip = NULL;
 		}
 		if (mp->m_quotainfo->qi_pquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_pquotaip);
+			xfs_imeta_irele(mp->m_quotainfo->qi_pquotaip);
 			mp->m_quotainfo->qi_pquotaip = NULL;
 		}
 	}
@@ -798,7 +799,7 @@ xfs_qm_qino_switch(
 	if (ino == NULLFSINO)
 		return 0;
 
-	error = xfs_iget(mp, NULL, ino, 0, 0, ip);
+	error = xfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE, ip);
 	if (error)
 		return error;
 
@@ -1570,24 +1571,24 @@ xfs_qm_init_quotainos(
 		if (XFS_IS_UQUOTA_ON(mp) &&
 		    mp->m_sb.sb_uquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_uquotino > 0);
-			error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
-					     0, 0, &uip);
+			error = xfs_imeta_iget(mp, mp->m_sb.sb_uquotino,
+					XFS_DIR3_FT_REG_FILE, &uip);
 			if (error)
 				return error;
 		}
 		if (XFS_IS_GQUOTA_ON(mp) &&
 		    mp->m_sb.sb_gquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_gquotino > 0);
-			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
-					     0, 0, &gip);
+			error = xfs_imeta_iget(mp, mp->m_sb.sb_gquotino,
+					XFS_DIR3_FT_REG_FILE, &gip);
 			if (error)
 				goto error_rele;
 		}
 		if (XFS_IS_PQUOTA_ON(mp) &&
 		    mp->m_sb.sb_pquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_pquotino > 0);
-			error = xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
-					     0, 0, &pip);
+			error = xfs_imeta_iget(mp, mp->m_sb.sb_pquotino,
+					XFS_DIR3_FT_REG_FILE, &pip);
 			if (error)
 				goto error_rele;
 		}
@@ -1632,11 +1633,11 @@ xfs_qm_init_quotainos(
 
 error_rele:
 	if (uip)
-		xfs_irele(uip);
+		xfs_imeta_irele(uip);
 	if (gip)
-		xfs_irele(gip);
+		xfs_imeta_irele(gip);
 	if (pip)
-		xfs_irele(pip);
+		xfs_imeta_irele(pip);
 	return error;
 }
 
@@ -1645,15 +1646,15 @@ xfs_qm_destroy_quotainos(
 	xfs_quotainfo_t	*qi)
 {
 	if (qi->qi_uquotaip) {
-		xfs_irele(qi->qi_uquotaip);
+		xfs_imeta_irele(qi->qi_uquotaip);
 		qi->qi_uquotaip = NULL; /* paranoia */
 	}
 	if (qi->qi_gquotaip) {
-		xfs_irele(qi->qi_gquotaip);
+		xfs_imeta_irele(qi->qi_gquotaip);
 		qi->qi_gquotaip = NULL;
 	}
 	if (qi->qi_pquotaip) {
-		xfs_irele(qi->qi_pquotaip);
+		xfs_imeta_irele(qi->qi_pquotaip);
 		qi->qi_pquotaip = NULL;
 	}
 }
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index d96f146e3fe6..71c910ea9e6c 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -23,6 +23,8 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_defer.h"
+#include "xfs_imeta.h"
+#include "xfs_da_format.h"
 
 STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
 STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
@@ -225,7 +227,7 @@ xfs_qm_scall_trunc_qfile(
 	if (ino == NULLFSINO)
 		return 0;
 
-	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
+	error = xfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE, &ip);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index afe4d29f7ab4..cedaf2f94362 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -24,7 +24,8 @@
 #include "xfs_buf.h"
 #include "xfs_icache.h"
 #include "xfs_rtalloc.h"
-
+#include "xfs_da_format.h"
+#include "xfs_imeta.h"
 
 /*
  * Read and return the summary information for a given extent size,
@@ -1206,14 +1207,16 @@ xfs_rtmount_inodes(
 	xfs_sb_t	*sbp;
 
 	sbp = &mp->m_sb;
-	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
+	error = xfs_imeta_iget(mp, mp->m_sb.sb_rbmino, XFS_DIR3_FT_REG_FILE,
+			&mp->m_rbmip);
 	if (error)
 		return error;
 	ASSERT(mp->m_rbmip != NULL);
 
-	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
+	error = xfs_imeta_iget(mp, mp->m_sb.sb_rsumino, XFS_DIR3_FT_REG_FILE,
+			&mp->m_rsumip);
 	if (error) {
-		xfs_irele(mp->m_rbmip);
+		xfs_imeta_irele(mp->m_rbmip);
 		return error;
 	}
 	ASSERT(mp->m_rsumip != NULL);
@@ -1234,9 +1237,9 @@ xfs_rtunmount_inodes(
 {
 	kmem_free(mp->m_rsum_cache);
 	if (mp->m_rbmip)
-		xfs_irele(mp->m_rbmip);
+		xfs_imeta_irele(mp->m_rbmip);
 	if (mp->m_rsumip)
-		xfs_irele(mp->m_rsumip);
+		xfs_imeta_irele(mp->m_rsumip);
 }
 
 /*

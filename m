Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0814C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66E3A206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KepEQAud"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgAABP3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:15:29 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55302 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABP2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:15:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EJrZ092059
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=eZ9fpQ/kzjb1VVOPjV+1j3Rmg946EwZ7t+34nk5YpO8=;
 b=KepEQAuddMKZS7giTYbJ2jWEDGJy4YUgoHvUTMuF06oXJdmy8g4+b9krSQ74GKEkIXrA
 NIGpipQaPrl1n+qMC9Pl3HD7spueFmUM2xkLV/oBbQpvNmh5LVFawQksvhwa7DGPujGH
 cbJ8ZN7JMG0Z02sWj+X0902O6D2zoFsHxfs94uQeuIyDf7Q9vImCo7rs0E63nr9LyKmI
 oRY995zF/4hIz1p3VPbfdoAypZ84sY4yebvHBlAoSuPVd/ZSeWDKvDXXiGjRsEKj+Y3e
 wuBLBNuS4qN6G7iltDL3u0KG3xd4VL2jTTu+mS23+gj5lDP6McChXWZUI9wgx0RAZy5D GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vg8190250
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2x8bsrg3ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:26 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011FPj8007916
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:25 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:15:25 -0800
Subject: [PATCH 05/13] xfs: iget for metadata inodes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:15:22 -0800
Message-ID: <157784132277.1366873.767248508508406727.stgit@magnolia>
In-Reply-To: <157784129036.1366873.17175097590750371047.stgit@magnolia>
References: <157784129036.1366873.17175097590750371047.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a xfs_iget_meta function for metadata inodes to ensure that we
always check that the inobt thinks a metadata inode is in use.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_imeta.h |    5 +++++
 fs/xfs/xfs_icache.c       |   28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c        |    7 +++++++
 fs/xfs/xfs_qm.c           |   33 +++++++++++++++++----------------
 fs/xfs/xfs_qm_syscalls.c  |    4 +++-
 fs/xfs/xfs_rtalloc.c      |   14 +++++++++-----
 6 files changed, 69 insertions(+), 22 deletions(-)


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
index 892bb789dcbf..adf5a63129c6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -23,6 +23,9 @@
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
 #include "xfs_health.h"
+#include "xfs_da_format.h"
+#include "xfs_dir2.h"
+#include "xfs_imeta.h"
 
 #include <linux/iversion.h>
 #include <linux/nmi.h>
@@ -873,6 +876,31 @@ xfs_icache_inode_is_allocated(
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
index 1e70cf4a75de..00c633ce1013 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2908,6 +2908,13 @@ xfs_irele(
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
index 2502312ee504..88e097e12e3e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -25,6 +25,7 @@
 #include "xfs_error.h"
 #include "xfs_health.h"
 #include "xfs_imeta.h"
+#include "xfs_da_format.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -230,15 +231,15 @@ xfs_qm_unmount_quotas(
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
@@ -807,7 +808,7 @@ xfs_qm_qino_switch(
 	if (ino == NULLFSINO)
 		return 0;
 
-	error = xfs_iget(mp, NULL, ino, 0, 0, ip);
+	error = xfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE, ip);
 	if (error)
 		return error;
 
@@ -1608,24 +1609,24 @@ xfs_qm_init_quotainos(
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
@@ -1670,11 +1671,11 @@ xfs_qm_init_quotainos(
 
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
 
@@ -1683,15 +1684,15 @@ xfs_qm_destroy_quotainos(
 	struct xfs_quotainfo	*qi)
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
index 47b63f820f50..393bfe0758cc 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -18,6 +18,8 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_icache.h"
+#include "xfs_imeta.h"
+#include "xfs_da_format.h"
 
 STATIC int
 xfs_qm_log_quotaoff(
@@ -283,7 +285,7 @@ xfs_qm_scall_trunc_qfile(
 	if (ino == NULLFSINO)
 		return 0;
 
-	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
+	error = xfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE, &ip);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4ec0fead3177..f0487e1c9cc1 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -19,6 +19,8 @@
 #include "xfs_icache.h"
 #include "xfs_rtalloc.h"
 #include "xfs_health.h"
+#include "xfs_da_format.h"
+#include "xfs_imeta.h"
 
 /*
  * Read and return the summary information for a given extent size,
@@ -1234,18 +1236,20 @@ xfs_rtmount_inodes(
 	xfs_sb_t	*sbp;
 
 	sbp = &mp->m_sb;
-	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
+	error = xfs_imeta_iget(mp, mp->m_sb.sb_rbmino, XFS_DIR3_FT_REG_FILE,
+			&mp->m_rbmip);
 	if (xfs_metadata_is_sick(error))
 		xfs_rt_mark_sick(mp, XFS_SICK_RT_BITMAP);
 	if (error)
 		return error;
 	ASSERT(mp->m_rbmip != NULL);
 
-	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
+	error = xfs_imeta_iget(mp, mp->m_sb.sb_rsumino, XFS_DIR3_FT_REG_FILE,
+			&mp->m_rsumip);
 	if (xfs_metadata_is_sick(error))
 		xfs_rt_mark_sick(mp, XFS_SICK_RT_SUMMARY);
 	if (error) {
-		xfs_irele(mp->m_rbmip);
+		xfs_imeta_irele(mp->m_rbmip);
 		return error;
 	}
 	ASSERT(mp->m_rsumip != NULL);
@@ -1259,9 +1263,9 @@ xfs_rtunmount_inodes(
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


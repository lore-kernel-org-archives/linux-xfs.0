Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC7EC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4139D206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gO807AxX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgAABPk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:15:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56692 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABPk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:15:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011ESYj112755
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=5jx5DQ1IZdHKi0CDTrnP/1I1thdal4Vs7qKUIL85kig=;
 b=gO807AxXEMaxicQkS7ML1yC3rul0qRrO2yIx2TIlgUyiycD5cr9LbfauHxP/SuiOG8nT
 5dccsOJeISsRPZIUa7DkMNIh0T7KsEMcqb4xbuCxPpAO1ZzHgMfYwh8N3zurdyfipM9Z
 qMaS2BdhbHLr+/sbfThZSz2mN7zLDShJSQw6wbcCPmvlf+E6bodsmubRR6Ymp8QzIU/n
 j33BpPS6VvJnfZiafYttwRQIWLFEOGoLZSRSXkAfmsuin1ONyYf3a6ws0SAyMUtlxgtM
 DcW4BmZyPUF5bW+QENk1JspnU3FEToqnSN65KMeQXL2Dd6jm9xipvhZonyOnBCFDZC38 nQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk2mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xkU012519
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2x8guef6rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:38 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011FbNd007930
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:37 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:15:37 -0800
Subject: [PATCH 07/13] xfs: load metadata inode directory at mount time
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:15:35 -0800
Message-ID: <157784133511.1366873.13575338482966972536.stgit@magnolia>
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

Load the metadata directory inode into memory at mount time and release
it at unmount time.  We also make sure that the obsolete inode pointers
in the superblock are not logged or read from the superblock.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c    |   31 +++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.c |    2 +-
 fs/xfs/xfs_mount.c        |   20 ++++++++++++++++++--
 fs/xfs/xfs_mount.h        |    1 +
 4 files changed, 51 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 4e5b27a4b4b4..26bf1d4087fb 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -520,6 +520,25 @@ __xfs_sb_from_disk(
 	/* Convert on-disk flags to in-memory flags? */
 	if (convert_xquota)
 		xfs_sb_quota_from_disk(to);
+
+	if (xfs_sb_version_hasmetadir(to)) {
+		/*
+		 * Set metadirino here and null out the in-core fields for
+		 * the other inodes because metadir initialization will load
+		 * them later.
+		 */
+		to->sb_metadirino = be64_to_cpu(from->sb_rbmino);
+		to->sb_rbmino = NULLFSINO;
+		to->sb_rsumino = NULLFSINO;
+
+		/*
+		 * We don't have to worry about quota inode conversion here
+		 * because metadir requires a v5 filesystem.
+		 */
+		to->sb_uquotino = NULLFSINO;
+		to->sb_gquotino = NULLFSINO;
+		to->sb_pquotino = NULLFSINO;
+	}
 }
 
 void
@@ -661,6 +680,18 @@ xfs_sb_to_disk(
 		if (xfs_sb_version_hasmetauuid(from))
 			uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
 	}
+
+	if (xfs_sb_version_hasmetadir(from)) {
+		/*
+		 * Save metadirino here and null out the on-disk fields for
+		 * the other inodes, at least until we reuse the fields.
+		 */
+		to->sb_rbmino = cpu_to_be64(from->sb_metadirino);
+		to->sb_rsumino = cpu_to_be64(NULLFSINO);
+		to->sb_uquotino = cpu_to_be64(NULLFSINO);
+		to->sb_gquotino = cpu_to_be64(NULLFSINO);
+		to->sb_pquotino = cpu_to_be64(NULLFSINO);
+	}
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 94ae0002a5e1..1e4bab40f7dd 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -157,7 +157,7 @@ xfs_verify_dir_ino(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
 {
-	if (xfs_internal_inum(mp, ino))
+	if (!xfs_sb_version_hasmetadir(&mp->m_sb) && xfs_internal_inum(mp, ino))
 		return false;
 	return xfs_verify_ino(mp, ino);
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5d4196780e79..42de4a398823 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -645,6 +645,16 @@ xfs_mountfs_imeta(
 {
 	int			error;
 
+	/* Load the metadata directory inode into memory. */
+	if (xfs_sb_version_hasmetadir(&mp->m_sb)) {
+		error = xfs_imeta_iget(mp, mp->m_sb.sb_metadirino,
+				XFS_DIR3_FT_DIR, &mp->m_metadirip);
+		if (error) {
+			xfs_warn(mp, "Failed metadir ino init: %d", error);
+			return error;
+		}
+	}
+
 	error = xfs_imeta_mount(mp);
 	if (error) {
 		xfs_warn(mp, "Failed to load metadata inode info, error %d",
@@ -876,7 +886,7 @@ xfs_mountfs(
 
 	error = xfs_mountfs_imeta(mp);
 	if (error)
-		goto out_log_dealloc;
+		goto out_free_metadir;
 
 	/*
 	 * Get and sanity-check the root inode.
@@ -888,7 +898,7 @@ xfs_mountfs(
 		xfs_warn(mp,
 			"Failed to read root inode 0x%llx, error %d",
 			sbp->sb_rootino, -error);
-		goto out_log_dealloc;
+		goto out_free_metadir;
 	}
 
 	ASSERT(rip != NULL);
@@ -1032,6 +1042,9 @@ xfs_mountfs(
 	xfs_irele(rip);
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
+ out_free_metadir:
+	if (mp->m_metadirip)
+		xfs_imeta_irele(mp->m_metadirip);
 	/*
 	 * Shut down all pending inode inactivation work, which will also
 	 * cancel all delayed reclaim work and reclaim the inodes directly.
@@ -1095,6 +1108,9 @@ xfs_unmountfs(
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
 
+	if (mp->m_metadirip)
+		xfs_imeta_irele(mp->m_metadirip);
+
 	/*
 	 * We can potentially deadlock here if we have an inode cluster
 	 * that has been freed has its buffer still pinned in memory because
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 579b6d7c3c75..ea1d57df895d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -120,6 +120,7 @@ typedef struct xfs_mount {
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
+	struct xfs_inode	*m_metadirip;	/* metadata inode directory */
 	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
 	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
 	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */


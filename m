Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA35C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51473206E6
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WZGzpc/9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgAABPQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:15:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55056 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABPP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:15:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EA8l092020
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=LNqhqG8UPmMNHcCYUM51tkXlDjRplMCEwA6Z1FSMVTQ=;
 b=WZGzpc/9QANe1jt0miN1y+fhaJLJ4wQkAlelTebuTMGrSgQDyuZNpPGQ0RMscSkdX7KB
 EpBdr9MzUsyMVL0odFtZ2Ve0WTdiKyto1eK1fyXndJjA+pDJCRtInYccLwr/etBLaYCu
 9qlDPZlzQOSYLEYCMG6ONtjGk4jUmt3WuRNXPRmzY3bUmxqbDKQ35UPT9a+fhAuRj9X7
 Xu47wNNN0npU8ggDZBMZlM6D7RpmdUnZ7iOTBc4YWlYlzzrLABIodkpZflJ7gtHraYhE
 R/9w+ykwEaDp0juqGwDdMH2v6T6kEfnUz7z0wjD4j90BTj0E+nplVyK3DdpGxz6oSBRE SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118wqL172104
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2x8gj919vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:13 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011FCIt001101
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:13 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:15:12 -0800
Subject: [PATCH 03/13] xfs: refactor the v4 group/project inode pointer
 switch
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:15:09 -0800
Message-ID: <157784130969.1366873.3942367281793191882.stgit@magnolia>
In-Reply-To: <157784129036.1366873.17175097590750371047.stgit@magnolia>
References: <157784129036.1366873.17175097590750371047.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the group and project quota inode pointer switcheroo that
happens only on v4 filesystems into a separate function prior to
enhancing the xfs_qm_qino_alloc function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_qm.c |   91 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 54 insertions(+), 37 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 22b6d47670a3..66966178244d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -747,6 +747,57 @@ xfs_qm_destroy_quotainfo(
 	mp->m_quotainfo = NULL;
 }
 
+/*
+ * Switch the group and project quota in-core inode pointers if needed.
+ *
+ * On v4 superblocks that don't have separate pquotino, we share an inode
+ * between gquota and pquota. If the on-disk superblock has GQUOTA and the
+ * filesystem is now mounted with PQUOTA, just use sb_gquotino for sb_pquotino
+ * and vice-versa.
+ */
+STATIC int
+xfs_qm_qino_switch(
+	struct xfs_mount	*mp,
+	struct xfs_inode	**ip,
+	unsigned int		flags,
+	bool			*need_alloc)
+{
+	xfs_ino_t		ino = NULLFSINO;
+	int			error;
+
+	if (xfs_sb_version_has_pquotino(&mp->m_sb) ||
+	    !(flags & (XFS_QMOPT_PQUOTA | XFS_QMOPT_GQUOTA)))
+		return 0;
+
+	if ((flags & XFS_QMOPT_PQUOTA) &&
+	    (mp->m_sb.sb_gquotino != NULLFSINO)) {
+		ino = mp->m_sb.sb_gquotino;
+		if (XFS_IS_CORRUPT(mp, mp->m_sb.sb_pquotino != NULLFSINO)) {
+			xfs_quota_mark_sick(mp, XFS_DQ_PROJ);
+			return -EFSCORRUPTED;
+		}
+	} else if ((flags & XFS_QMOPT_GQUOTA) &&
+		   (mp->m_sb.sb_pquotino != NULLFSINO)) {
+		ino = mp->m_sb.sb_pquotino;
+		if (XFS_IS_CORRUPT(mp, mp->m_sb.sb_gquotino != NULLFSINO)) {
+			xfs_quota_mark_sick(mp, XFS_DQ_GROUP);
+			return -EFSCORRUPTED;
+		}
+	}
+
+	if (ino == NULLFSINO)
+		return 0;
+
+	error = xfs_iget(mp, NULL, ino, 0, 0, ip);
+	if (error)
+		return error;
+
+	mp->m_sb.sb_gquotino = NULLFSINO;
+	mp->m_sb.sb_pquotino = NULLFSINO;
+	*need_alloc = false;
+	return 0;
+}
+
 /*
  * Create an inode and return with a reference already taken, but unlocked
  * This is how we create quota inodes
@@ -766,43 +817,9 @@ xfs_qm_qino_alloc(
 	bool		need_alloc = true;
 
 	*ip = NULL;
-	/*
-	 * With superblock that doesn't have separate pquotino, we
-	 * share an inode between gquota and pquota. If the on-disk
-	 * superblock has GQUOTA and the filesystem is now mounted
-	 * with PQUOTA, just use sb_gquotino for sb_pquotino and
-	 * vice-versa.
-	 */
-	if (!xfs_sb_version_has_pquotino(&mp->m_sb) &&
-			(flags & (XFS_QMOPT_PQUOTA|XFS_QMOPT_GQUOTA))) {
-		xfs_ino_t ino = NULLFSINO;
-
-		if ((flags & XFS_QMOPT_PQUOTA) &&
-			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
-			ino = mp->m_sb.sb_gquotino;
-			if (XFS_IS_CORRUPT(mp,
-					   mp->m_sb.sb_pquotino != NULLFSINO)) {
-				xfs_quota_mark_sick(mp, XFS_DQ_PROJ);
-				return -EFSCORRUPTED;
-			}
-		} else if ((flags & XFS_QMOPT_GQUOTA) &&
-			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
-			ino = mp->m_sb.sb_pquotino;
-			if (XFS_IS_CORRUPT(mp,
-					   mp->m_sb.sb_gquotino != NULLFSINO)) {
-				xfs_quota_mark_sick(mp, XFS_DQ_GROUP);
-				return -EFSCORRUPTED;
-			}
-		}
-		if (ino != NULLFSINO) {
-			error = xfs_iget(mp, NULL, ino, 0, 0, ip);
-			if (error)
-				return error;
-			mp->m_sb.sb_gquotino = NULLFSINO;
-			mp->m_sb.sb_pquotino = NULLFSINO;
-			need_alloc = false;
-		}
-	}
+	error = xfs_qm_qino_switch(mp, ip, flags, &need_alloc);
+	if (error)
+		return error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
 			XFS_QM_QINOCREATE_SPACE_RES(mp), 0, 0, &tp);


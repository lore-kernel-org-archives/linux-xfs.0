Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70018C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38F77206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ua/MZhlD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbgAABPW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:15:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55216 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:15:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011FLei092752
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MsLZ/G0kt9u+XQLzLntYdUFZEegW+aC7KhSTdR621FY=;
 b=Ua/MZhlDSNjVvogoNPrJ5GfbyVLXKdNpM+z6TQddCvdY5B9MjZ/pgKXZTaRwYa078KXt
 W2PV9+nyuFGkXRMirp4YQK2Cz67LPLxFbLeis3HoMLq6yq55bO7gkeUXF9y8bV1sCJYM
 2TAPjxQWCvbvl+BIEcTZNh7MCe7K3aD6HeBQMyEFE4eppJGoJ0svbvlGv+7nmawrzPkr
 ljLaBeIMOoWqvDNEOBE1xqb2cwo7a82fbnh+QEd9of9K2xDgfEaRuz65TddXgzUaKX9n
 RqYbzUD41dRIjpjYbIfxT2IxqCHpprPXv1uJFjah68lHxVtU4xJTSnAnl1vRfoZKTSBM Mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118voc190291
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2x8bsrg3us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:20 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011FJZK013189
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:19 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:15:18 -0800
Subject: [PATCH 04/13] xfs: convert all users to xfs_imeta_log
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:15:16 -0800
Message-ID: <157784131602.1366873.16394167814770541277.stgit@magnolia>
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

Convert all open-coded sb metadata inode pointer logging to use
xfs_imeta_log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_qm.c |   77 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 66966178244d..2502312ee504 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -24,6 +24,7 @@
 #include "xfs_icache.h"
 #include "xfs_error.h"
 #include "xfs_health.h"
+#include "xfs_imeta.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -747,6 +748,18 @@ xfs_qm_destroy_quotainfo(
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
@@ -754,6 +767,12 @@ xfs_qm_destroy_quotainfo(
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
@@ -792,8 +811,13 @@ xfs_qm_qino_switch(
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
@@ -804,36 +828,26 @@ xfs_qm_qino_switch(
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
@@ -851,22 +865,27 @@ xfs_qm_qino_alloc(
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
 


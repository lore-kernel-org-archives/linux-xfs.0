Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FA0C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66BB5206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:16:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JiN84mKp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgAABQJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:16:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56912 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABQI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:16:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EOG4112611
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=uujcEFmCpp6Fl7gdgjbduRaMLQ7q8QDKvTnwGDPI2oU=;
 b=JiN84mKp5NYh67Vqx6DqbND+g3HngEtJjnXRMJI0kdL07knpjhkvRp/KONOnD9vvJPjp
 aJOtCBhX/qhwIT1gL1DudMr4/yr22JMa1DiT+vc5ayS2XrZsP3vmOYlfj2OlZEPxJkt+
 kPaYp56n2Zvrc7KowNFGFzb0hmxz9czTywlT6eyIKlvHYFvGUJDgcJdcI1482i+MwNu3
 XmNCpOHr9ZvtyXhaPZaPU7kLjM1AqJRkHqiyuurokXf7Shj3yxaou9c5jbpdeP4+tWso
 Uygu4o3bfaA+CN5bPNlKfG0Sg9F88QIVCFAQ3RdB8oKAgZjuzBpsKJ6ZWtglBAxxaoJ7 DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk2n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:16:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xfh012445
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2x8guefa2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:16:06 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011G4D4001426
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:04 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:16:03 -0800
Subject: [PATCH 11/13] xfs: ensure metadata directory paths exist before
 creating files
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:15:59 -0800
Message-ID: <157784135972.1366873.2344304878850527463.stgit@magnolia>
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

Since xfs_imeta_create can create new metadata files arbitrarily deep in
the metadata directory tree, we must supply a function that can ensure
that all directories in a path exist, and call it before the quota
functions create the quota inodes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_imeta.h |    2 +
 fs/xfs/xfs_inode.c        |  102 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_qm.c           |   13 ++++++
 3 files changed, 117 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index ecd2db0a4c92..33024889fc71 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -62,5 +62,7 @@ unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
 int xfs_imeta_iget(struct xfs_mount *mp, xfs_ino_t ino, unsigned char ftype,
 		  struct xfs_inode **ipp);
 void xfs_imeta_irele(struct xfs_inode *ip);
+int xfs_imeta_ensure_dirpath(struct xfs_mount *mp,
+			     const struct xfs_imeta_path *path);
 
 #endif /* __XFS_IMETA_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bac26f793746..b4bd82d86277 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -39,6 +39,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_health.h"
+#include "xfs_imeta.h"
 
 kmem_zone_t *xfs_inode_zone;
 
@@ -931,6 +932,107 @@ xfs_create_tmpfile(
 	return error;
 }
 
+/* Create a metadata for the last component of the path. */
+STATIC int
+xfs_imeta_mkdir(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path)
+{
+	struct xfs_imeta_end		ic;
+	struct xfs_inode		*ip = NULL;
+	struct xfs_trans		*tp = NULL;
+	struct xfs_dquot		*udqp = NULL;
+	struct xfs_dquot		*gdqp = NULL;
+	struct xfs_dquot		*pdqp = NULL;
+	uint				resblks;
+	int				error;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	/* Grab the dquots from the metadata directory root. */
+	error = xfs_qm_vop_dqalloc(mp->m_metadirip, 0, 0, 0,
+			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
+			&udqp, &gdqp, &pdqp);
+	if (error)
+		return error;
+
+	/* Allocate a transaction to create the last directory. */
+	resblks = xfs_imeta_create_space_res(mp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create, resblks,
+			0, 0, &tp);
+	if (error)
+		goto out_dqrele;
+
+	/* Reserve quota for the new directory. */
+	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, pdqp,
+			resblks, 1, 0);
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out_dqrele;
+	}
+
+	/* Create the subdirectory. */
+	error = xfs_imeta_create(&tp, path, S_IFDIR, &ip, &ic);
+	if (error) {
+		xfs_trans_cancel(tp);
+		xfs_imeta_end_update(mp, &ic, error);
+		goto out_irele;
+	}
+
+	/*
+	 * Attach the dquot(s) to the inodes and modify them incore.
+	 * These ids of the inode couldn't have changed since the new
+	 * inode has been locked ever since it was created.
+	 */
+	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
+
+	error = xfs_trans_commit(tp);
+	xfs_imeta_end_update(mp, &ic, error);
+
+out_irele:
+	/* Have to finish setting up the inode to ensure it's deleted. */
+	if (ip) {
+		xfs_finish_inode_setup(ip);
+		xfs_irele(ip);
+	}
+
+out_dqrele:
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
+	return error;
+}
+
+/*
+ * Make sure that every metadata directory path component exists and is a
+ * directory.
+ */
+int
+xfs_imeta_ensure_dirpath(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path)
+{
+	struct xfs_imeta_path temp_path = {
+		.im_path		= path->im_path,
+		.im_depth		= 1,
+	};
+	unsigned int			i;
+	int				error = 0;
+
+	if (!xfs_sb_version_hasmetadir(&mp->m_sb))
+		return 0;
+
+	for (i = 0; i < path->im_depth - 1; i++) {
+		temp_path.im_depth = i + 1;
+		error = xfs_imeta_mkdir(mp, &temp_path);
+		if (error && error != -EEXIST)
+			break;
+	}
+
+	return error == -EEXIST ? 0 : error;
+}
+
 int
 xfs_link(
 	xfs_inode_t		*tdp,
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 88e097e12e3e..18e89bab583e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -836,6 +836,7 @@ xfs_qm_qino_alloc(
 	struct xfs_imeta_end		ic;
 	struct xfs_trans		*tp;
 	const struct xfs_imeta_path	*path = xfs_qflags_to_imeta(flags);
+	uint				old_qflags;
 	int				error;
 	bool				need_alloc = true;
 
@@ -844,6 +845,18 @@ xfs_qm_qino_alloc(
 	if (error)
 		return error;
 
+	/*
+	 * Ensure the quota directory exists, being careful to disable quotas
+	 * while we do this.  We'll have to quotacheck anyway, so the loss
+	 * of one inode shouldn't affect the quota count.
+	 */
+	old_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
+	mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
+	error = xfs_imeta_ensure_dirpath(mp, xfs_qflags_to_imeta(flags));
+	mp->m_qflags |= old_qflags;
+	if (error)
+		return error;
+
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
 			xfs_imeta_create_space_res(mp), 0, 0, &tp);
 	if (error)


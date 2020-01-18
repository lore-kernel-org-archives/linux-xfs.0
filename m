Return-Path: <SRS0=0TO6=3H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9790FC35240
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6754B246AB
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:46:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cz7GxOTP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgARWqR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jan 2020 17:46:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50290 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgARWqR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jan 2020 17:46:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcRdn072033
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=hCHeFf3Iw7T3H5RBg4cMJ/tGUBO0GgMocXZHVpsVJO8=;
 b=cz7GxOTPvDUhj/qFdv/iTlETXpUXcMH3/GZlmQUzUGdja7GDf6PNNaJQBkxEkqfegUCt
 koO4FFt9aRKYtkNZAsCPIKwHVPropWfp+2bSG6pqXIjeODYDBAoZlaOrJh+6LktYrL0E
 ol/+oiVFKYcXxdzdVUwmFx6zZXyY1d229K0R1RoHNSi5eOBNk07o/HGisWQPXdueEao9
 mDna3Ft4KVfcJPLjb0W/G/NSqwmuPdx06yBkkU/csK5aP9FUiB4AoYz3Ucd4+chr9KXP
 IjdF6wJw5GprDoltFYNwHx2OQQQ0DvuK7rVxtjVt2MJ3iN39Kk70qo3UTkqEhFW6NcZ1 Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xktnqsvtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcqF3125843
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xkr2dannt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:14 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00IMkDQD025478
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:13 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 18 Jan 2020 14:46:13 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 08/17] xfsprogs: Refactor xfs_attr_try_sf_addname
Date:   Sat, 18 Jan 2020 15:45:49 -0700
Message-Id: <20200118224558.19382-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200118224558.19382-1-allison.henderson@oracle.com>
References: <20200118224558.19382-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001180185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001180185
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To help pre-simplify xfs_attr_set_args, we need to hoist transacation
handling up, while modularizing the adjacent code down into helpers. In
this patch, hoist the commit in xfs_attr_try_sf_addname up into the
calling function, and also pull the attr list creation down.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 30d1335..0b21a6a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -226,8 +226,13 @@ xfs_attr_try_sf_addname(
 	struct xfs_da_args	*args)
 {
 
-	struct xfs_mount	*mp = dp->i_mount;
-	int			error, error2;
+	int			error;
+
+	/*
+	 * Build initial attribute list (if required).
+	 */
+	if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
+		xfs_attr_shortform_create(args);
 
 	error = xfs_attr_shortform_addname(args);
 	if (error == -ENOSPC)
@@ -240,12 +245,10 @@ xfs_attr_try_sf_addname(
 	if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
 		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args->trans);
 
-	error2 = xfs_trans_commit(args->trans);
-	args->trans = NULL;
-	return error ? error : error2;
+	return error;
 }
 
 /*
@@ -257,7 +260,7 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error;
+	int			error, error2 = 0;
 
 	/*
 	 * If the attribute list is non-existent or a shortform list,
@@ -268,17 +271,14 @@ xfs_attr_set_args(
 	     dp->i_d.di_anextents == 0)) {
 
 		/*
-		 * Build initial attribute list (if required).
-		 */
-		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
-			xfs_attr_shortform_create(args);
-
-		/*
 		 * Try to add the attr to the attribute list in the inode.
 		 */
 		error = xfs_attr_try_sf_addname(dp, args);
-		if (error != -ENOSPC)
-			return error;
+		if (error != -ENOSPC) {
+			error2 = xfs_trans_commit(args->trans);
+			args->trans = NULL;
+			return error ? error : error2;
+		}
 
 		/*
 		 * It won't fit in the shortform, transform to a leaf block.
-- 
2.7.4


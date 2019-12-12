Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C2EC2D0C9
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEEA124656
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:15:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GJi16LqL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfLLEPc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 23:15:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45872 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbfLLEPb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 23:15:31 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4EKGv130916
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=kCMsluZ/tWLyo2dhWUj9QOaKNF4voG/UBc6IpsIKzek=;
 b=GJi16LqLZ2g/L2YvB8AGcb5bXJy6dyewAJC9kqUHv3cSm5xgJzHUhwrHmDTBgfAPrCYv
 zZbeZzr/PXY68ji/RShGhkGxg0GE8epVGZKIhCF1EMXDgugTAdgvtZI0pUcXaa7y+5Ys
 2NzGOWNiA8oOh/a6mbFBq6+wmEELuDDgBG6cE7xQsgK6ZnugqcqJ4/4IGPWYtx4zt6Ad
 jeFpv7qPs88IhfnZDe+gLeTaN5aJyKDHvLMsKpVLAtq/B6qF9Ry2vmITyXa2B30+NafP
 Of6HNMY5eATtMUjL/Os+9jlGODdjHt9yHQh7kU7cYId698ZzJUGm4+WXKxSfV5L0/Dfs 8Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wr41qggrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4EIEE073273
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wu3k0b4m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:29 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBC4FS6i024944
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:28 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Dec 2019 20:15:28 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 08/14] xfs: Factor up xfs_attr_try_sf_addname
Date:   Wed, 11 Dec 2019 21:15:07 -0700
Message-Id: <20191212041513.13855-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212041513.13855-1-allison.henderson@oracle.com>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

New delayed attribute routines cannot handle transactions. We
can factor up the commit, but there is little left in this
function other than some error handling and an ichgtime. So
hoist all of xfs_attr_try_sf_addname up at this time.  We will
remove all the commits in this set.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 54 ++++++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 36f6a43..9c78e0d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -221,34 +221,6 @@ xfs_attr_calc_size(
 	return nblks;
 }
 
-STATIC int
-xfs_attr_try_sf_addname(
-	struct xfs_inode	*dp,
-	struct xfs_da_args	*args)
-{
-
-	struct xfs_mount	*mp = dp->i_mount;
-	int			error, error2;
-
-	error = xfs_attr_shortform_addname(args);
-	if (error == -ENOSPC)
-		return error;
-
-	/*
-	 * Commit the shortform mods, and we're done.
-	 * NOTE: this is also the error path (EEXIST, etc).
-	 */
-	if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
-		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
-
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
-		xfs_trans_set_sync(args->trans);
-
-	error2 = xfs_trans_commit(args->trans);
-	args->trans = NULL;
-	return error ? error : error2;
-}
-
 /*
  * Set the attribute specified in @args.
  */
@@ -258,7 +230,7 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error;
+	int			error, error2 = 0;;
 
 	/*
 	 * If the attribute list is non-existent or a shortform list,
@@ -277,9 +249,27 @@ xfs_attr_set_args(
 		/*
 		 * Try to add the attr to the attribute list in the inode.
 		 */
-		error = xfs_attr_try_sf_addname(dp, args);
-		if (error != -ENOSPC)
-			return error;
+
+		error = xfs_attr_shortform_addname(args);
+
+		/* Should only be 0, -EEXIST or ENOSPC */
+		if (error != -ENOSPC) {
+			/*
+			 * Commit the shortform mods, and we're done.
+			 * NOTE: this is also the error path (EEXIST, etc).
+			 */
+			if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
+				xfs_trans_ichgtime(args->trans, dp,
+						   XFS_ICHGTIME_CHG);
+
+			if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
+				xfs_trans_set_sync(args->trans);
+
+			error2 = xfs_trans_commit(args->trans);
+			args->trans = NULL;
+			return error ? error : error2;
+		}
+
 
 		/*
 		 * It won't fit in the shortform, transform to a leaf block.
-- 
2.7.4


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E059C4361B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 666AA23120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgLFXOB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:14:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48764 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgLFXOA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:14:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N5vWV186092;
        Sun, 6 Dec 2020 23:13:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=t5y8DFdD1ZkxAiEaYbywDz8cH8Vc+avCEwX/++OcygQ=;
 b=xJ8KJFy6SuYkyvf4qIUmPW9ArtZa5AUKWULQBoZ12r3ZzdbKcUOhOTyaCIs7tDjQVWSy
 PwgUSgb666b+0b+dxbk0T4ae82MeU8shBuBsKD00QhWHipIHITBq3aYjtafHpFuZ0rGs
 /fV/9svdtD0R3jnLaBGWbfkBTR+KfgC8I/+f3TpFsNpXfyvapJl+A5+5p4hhgR+rlmI+
 hhH7w7hVnzJSrZgtn09rqZQfMv3qaO+RKpFmwYrBJkgVcZ9Er440i8pBvRRbAOXctFc5
 51v4BBCTyQR6ShpxEz+YtaHQdmjdUkLm94QrBMBgAd1rHoY+5RYgKO1mmqzG0m8v5mfn XA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3581mqjvm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:13:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6NAMW6005705;
        Sun, 6 Dec 2020 23:11:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 358m3vpe7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:11:17 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6NBHxc012497;
        Sun, 6 Dec 2020 23:11:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:11:17 -0800
Subject: [PATCH 4/4] xfs: rename xfs_fc_* back to xfs_fs_*
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Sun, 06 Dec 2020 15:11:15 -0800
Message-ID: <160729627541.1608297.18095324548384560045.stgit@magnolia>
In-Reply-To: <160729625074.1608297.13414859761208067117.stgit@magnolia>
References: <160729625074.1608297.13414859761208067117.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=3 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Get rid of this one-off namespace since we're done converting things to
fscontext now.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 36002f460d7c..12d6850aedc6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1159,7 +1159,7 @@ suffix_kstrtoint(
  * NOTE: mp->m_super is NULL here!
  */
 static int
-xfs_fc_parse_param(
+xfs_fs_parse_param(
 	struct fs_context	*fc,
 	struct fs_parameter	*param)
 {
@@ -1317,7 +1317,7 @@ xfs_fc_parse_param(
 }
 
 static int
-xfs_fc_validate_params(
+xfs_fs_validate_params(
 	struct xfs_mount	*mp)
 {
 	/*
@@ -1386,7 +1386,7 @@ xfs_fc_validate_params(
 }
 
 static int
-xfs_fc_fill_super(
+xfs_fs_fill_super(
 	struct super_block	*sb,
 	struct fs_context	*fc)
 {
@@ -1396,7 +1396,7 @@ xfs_fc_fill_super(
 
 	mp->m_super = sb;
 
-	error = xfs_fc_validate_params(mp);
+	error = xfs_fs_validate_params(mp);
 	if (error)
 		goto out_free_names;
 
@@ -1660,10 +1660,10 @@ xfs_fc_fill_super(
 }
 
 static int
-xfs_fc_get_tree(
+xfs_fs_get_tree(
 	struct fs_context	*fc)
 {
-	return get_tree_bdev(fc, xfs_fc_fill_super);
+	return get_tree_bdev(fc, xfs_fs_fill_super);
 }
 
 static int
@@ -1782,7 +1782,7 @@ xfs_remount_ro(
  * silently ignore all options that we can't actually change.
  */
 static int
-xfs_fc_reconfigure(
+xfs_fs_reconfigure(
 	struct fs_context *fc)
 {
 	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
@@ -1795,7 +1795,7 @@ xfs_fc_reconfigure(
 	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
 		fc->sb_flags |= SB_I_VERSION;
 
-	error = xfs_fc_validate_params(new_mp);
+	error = xfs_fs_validate_params(new_mp);
 	if (error)
 		return error;
 
@@ -1832,7 +1832,7 @@ xfs_fc_reconfigure(
 	return 0;
 }
 
-static void xfs_fc_free(
+static void xfs_fs_free(
 	struct fs_context	*fc)
 {
 	struct xfs_mount	*mp = fc->s_fs_info;
@@ -1848,10 +1848,10 @@ static void xfs_fc_free(
 }
 
 static const struct fs_context_operations xfs_context_ops = {
-	.parse_param = xfs_fc_parse_param,
-	.get_tree    = xfs_fc_get_tree,
-	.reconfigure = xfs_fc_reconfigure,
-	.free        = xfs_fc_free,
+	.parse_param = xfs_fs_parse_param,
+	.get_tree    = xfs_fs_get_tree,
+	.reconfigure = xfs_fs_reconfigure,
+	.free        = xfs_fs_free,
 };
 
 static int xfs_init_fs_context(


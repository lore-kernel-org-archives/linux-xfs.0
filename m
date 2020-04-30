Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB24BC4725B
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A78E520774
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:50:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IiZ6WIN+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgD3Wuh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:50:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33048 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgD3Wuh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:50:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMlXOf066938
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=LuTUOnRmMUAFSVWpLj+YlsGrSU/aQbevxZui0HcMYx0=;
 b=IiZ6WIN+TcodLHSQx2mq5kLQXJILTbCFSXdf6x3wImiGciXMKduGuHxEOi4y4j7BaBbI
 ow4y944Nio3NIUj11gG5yZDsY6Vhb9J10ufQSVGaZ0OuQhGOSFgBiB3F0RzEz1KuNRhZ
 NNe8Ak+McvKi+E8+rngsbBDpIFyZcF/v+9BTRRmaTApuLDt/IPV92YLMxt1NvJop/n9f
 MzLMtAaVmChKzUx0n7lv6Ky0xM4O8MNyLEqYkdYsukbhTl+uFwsxa/zM3disMQzuzDwn
 Bv3HHTI0YqvqN4ycws26AWnPWRAkH65wJklCVDXsNIc8sE78d/4lY2ZJKULjOHKSuu/H 3g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30r7f802jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhPuT181155
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30r7fesask-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:36 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UMoZgj014743
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:35 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:50:35 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 12/24] xfs: Add helper function xfs_attr_node_shrink
Date:   Thu, 30 Apr 2020 15:50:04 -0700
Message-Id: <20200430225016.4287-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430225016.4287-1-allison.henderson@oracle.com>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=1 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=1 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a new helper function xfs_attr_node_shrink used to
shrink an attr name into an inode if it is small enough.  This helps to
modularize the greater calling function xfs_attr_node_removename.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 68 ++++++++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 4fdfab9..d83443c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1108,6 +1108,45 @@ xfs_attr_node_addname(
 }
 
 /*
+ * Shrink an attribute from leaf to shortform
+ */
+STATIC int
+xfs_attr_node_shrink(
+	struct xfs_da_args	*args,
+	struct xfs_da_state     *state)
+{
+	struct xfs_inode	*dp = args->dp;
+	int			error, forkoff;
+	struct xfs_buf		*bp;
+
+	/*
+	 * Have to get rid of the copy of this dabuf in the state.
+	 */
+	ASSERT(state->path.active == 1);
+	ASSERT(state->path.blk[0].bp);
+	state->path.blk[0].bp = NULL;
+
+	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+	if (error)
+		return error;
+
+	forkoff = xfs_attr_shortform_allfit(bp, dp);
+	if (forkoff) {
+		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+		/* bp is gone due to xfs_da_shrink_inode */
+		if (error)
+			return error;
+
+		error = xfs_defer_finish(&args->trans);
+		if (error)
+			return error;
+	} else
+		xfs_trans_brelse(args->trans, bp);
+
+	return 0;
+}
+
+/*
  * Remove a name from a B-tree attribute list.
  *
  * This will involve walking down the Btree, and may involve joining
@@ -1120,8 +1159,7 @@ xfs_attr_node_removename(
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
-	struct xfs_buf		*bp;
-	int			retval, error, forkoff;
+	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
@@ -1206,30 +1244,8 @@ xfs_attr_node_removename(
 	/*
 	 * If the result is small enough, push it all into the inode.
 	 */
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		/*
-		 * Have to get rid of the copy of this dabuf in the state.
-		 */
-		ASSERT(state->path.active == 1);
-		ASSERT(state->path.blk[0].bp);
-		state->path.blk[0].bp = NULL;
-
-		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
-		if (error)
-			goto out;
-
-		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
-			/* bp is gone due to xfs_da_shrink_inode */
-			if (error)
-				goto out;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
-		} else
-			xfs_trans_brelse(args->trans, bp);
-	}
-	error = 0;
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+		error = xfs_attr_node_shrink(args, state);
 
 out:
 	if (state)
-- 
2.7.4


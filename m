Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F003BC433E4
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D09272087C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pCq8v2EL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgH0A3V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:29:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37736 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgH0A3T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:29:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0TIDs165395
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=yoAkyTnt2lENWm854HDxxaVxNZsPcpWwzPUNl6Z3pWo=;
 b=pCq8v2ELjqlMAkxcyyOibZTaQn/sUcHrUrnzNXF0CVdkaplGhUsZGvrLXM0izTSL3uZ9
 N5TVu7qmbLnpI13jcyvpmOfyRpIMba4CLx9G+iOuPLOVNSog0tvgX1kQ4lqjEbWnebFx
 cH/c+ky/PN1LfqBgZI8+ckHCLHmB2NTVLN8XufgzeyZ8wklVhCbUiVRQCExFQ4uONaZq
 0ETIIKpTp/q/zq7kXqwc7aYh/vuvwx91Izi/TeDesWqFioLlMhr/1bOSbLuIRQHfwiJv
 jIr4F6AZfGO8zrytf+rQpd1chi/vWW5iJ/Bw2Sfj5GnOvo/LlNoLucD1HHHmumoWKPx/ JQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 333w6u1yvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0BM5L038033
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 333r9mk52x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:13 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07R0TDpI024802
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:13 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:29:13 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 12/32] xfsprogs: Add helper function xfs_attr_node_shrink
Date:   Wed, 26 Aug 2020 17:28:36 -0700
Message-Id: <20200827002856.1131-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827002856.1131-1-allison.henderson@oracle.com>
References: <20200827002856.1131-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=1 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a new helper function xfs_attr_node_shrink used to
shrink an attr name into an inode if it is small enough.  This helps to
modularize the greater calling function xfs_attr_node_removename.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr.c | 68 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 26 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 310b925..bd96bc4 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1109,6 +1109,45 @@ out:
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
@@ -1121,8 +1160,7 @@ xfs_attr_node_removename(
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
-	struct xfs_buf		*bp;
-	int			retval, error, forkoff;
+	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
@@ -1207,30 +1245,8 @@ xfs_attr_node_removename(
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


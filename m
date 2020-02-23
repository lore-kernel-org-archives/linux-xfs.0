Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45521C35673
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CF67206EF
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="za7hF258"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgBWCG1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:06:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45898 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbgBWCG0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N21ENV189118
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=E6Pa4UGDfF1E+tl4F7nsCAsX+lPdDH1XuEIuQgiA4t0=;
 b=za7hF258As830kqwk9WS20TmBZiFFa3lq6bh5WEoMgPK87KuEhg/esOV5zuLz0uhr6FM
 b2jRuW0pGa68Ji8ZN9MDjbEznDvu/T5TONDmHagpxRXeGxJ9uoRrwZM1CovPkvpc8NyN
 5J4RXobDmmvKikI3nDVzJLl08/U5u3Xu8fHSIRN5RZV3IXr10FcaLktFaKVBtJWj46aP
 kWxTyxGItLq96K1Vn+nTAVw83Euw8ER9oGTOczCX2bY88MPEFZ8XNiP6dgUcMVK7Heqx
 IVYgtEssWJB/2H4Fl7VEZ+3SdZNUMPNkpBw4aZaTOJsKpkTaHTJ1lxMW86AF5l3yleq6 6g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2yauqu21xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N26OS7184265
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ybdure4fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:23 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01N26MKl004648
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:23 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:22 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 15/19] xfs: Add helper function xfs_attr_node_shrink
Date:   Sat, 22 Feb 2020 19:06:07 -0700
Message-Id: <20200223020611.1802-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223020611.1802-1-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a new helper function xfs_attr_node_shrink used to shrink an
attr name into an inode if it is small enough.  This helps to modularize
the greater calling function xfs_attr_node_removename.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 66 +++++++++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 4b788f2..30a16fe 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1366,6 +1366,43 @@ xfs_attr_node_addname(
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
+		args->dac.flags |= XFS_DAC_FINISH_TRANS;
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
@@ -1383,8 +1420,7 @@ xfs_attr_node_removename(
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
-	struct xfs_buf		*bp;
-	int			retval, error, forkoff;
+	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
@@ -1493,30 +1529,8 @@ xfs_attr_node_removename(
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


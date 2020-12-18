Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AACC4361B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF3C723A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732866AbgLRHaF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:30:05 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36398 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732844AbgLRHaF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:30:05 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7KF2n001543
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=YE32u/N4K3yxBoCmBjIM2/pvP4X8BxStE4nsVs7sFpc=;
 b=iORpVvRPuZl4HCatcsXNVmZnFkXxmmAizFZdPscx3kvAS78yHuvsbQIvk1EzA30Hrtam
 LU3RxgeuIWqEjclRs4fPMs64EH7MgqsdKMtj5zVcuecSbojt0rAS5eE8T5Qh71PjZ3tn
 Dv7+DpgZPrJgUi8ZS4gSq5xPoKtCVk7AZkIRTSvNrKFXivnOee4Xy17CbPg8yiPseKk2
 YvXK7iDeThWiZ958lUseuXM4v8a0v3nEp9ebKGFPxIviOJQOQHgLOpiqiLgcy2I5X4UR
 o2Ogysrnv/cqsOND85rGql5vF593nxt3QXFghO5xxJoolq4aO2wTAhKTeNF+VIzjLp7q 1w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcbs6q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7LM0J044746
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35d7eryv0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:23 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BI7TNHs003408
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:23 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:29:22 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 03/15] xfs: Hoist transaction handling in xfs_attr_node_remove_step
Date:   Fri, 18 Dec 2020 00:29:05 -0700
Message-Id: <20201218072917.16805-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218072917.16805-1-allison.henderson@oracle.com>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180052
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists transaction handling in xfs_attr_node_remove to
xfs_attr_node_remove_step.  This will help keep transaction handling in
higher level functions instead of buried in subfunctions when we
introduce delay attributes

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e93d76a..1969b88 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1251,7 +1251,7 @@ xfs_attr_node_remove_step(
 	struct xfs_da_args	*args,
 	struct xfs_da_state	*state)
 {
-	int			retval, error;
+	int			error;
 	struct xfs_inode	*dp = args->dp;
 
 
@@ -1265,25 +1265,6 @@ xfs_attr_node_remove_step(
 		if (error)
 			return error;
 	}
-	retval = xfs_attr_node_remove_cleanup(args, state);
-
-	/*
-	 * Check to see if the tree needs to be collapsed.
-	 */
-	if (retval && (state->path.active > 1)) {
-		error = xfs_da3_join(state);
-		if (error)
-			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-		/*
-		 * Commit the Btree join operation and start a new trans.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
 
 	return error;
 }
@@ -1299,7 +1280,7 @@ xfs_attr_node_removename(
 	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state = NULL;
-	int			error;
+	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
@@ -1312,6 +1293,26 @@ xfs_attr_node_removename(
 	if (error)
 		goto out;
 
+	retval = xfs_attr_node_remove_cleanup(args, state);
+
+	/*
+	 * Check to see if the tree needs to be collapsed.
+	 */
+	if (retval && (state->path.active > 1)) {
+		error = xfs_da3_join(state);
+		if (error)
+			return error;
+		error = xfs_defer_finish(&args->trans);
+		if (error)
+			return error;
+		/*
+		 * Commit the Btree join operation and start a new trans.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * If the result is small enough, push it all into the inode.
 	 */
-- 
2.7.4


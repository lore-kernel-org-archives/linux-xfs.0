Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E69C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0163622BF3
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W7XfQtUt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgGUAQW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:16:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40472 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbgGUAQS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 20:16:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L03SFi181772
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=n3A49ztHSXVSoi9r38Z6L7X1Hiu/EfmMx8ekraK3DCA=;
 b=W7XfQtUteEWMcFZM/yLSnHm4bHvI6Wm0jzDGriZIP8RrA/V4XnFeMv5YUJokcLUafDIy
 7RDLQGlNNFohSR9wwPjnRa7s5xJPG+BOJ6IO6lscvYXn97wZ7k7G/CfIoEKvOfaqRh8T
 tvCjqeVA6AZgejhFT2opNIBovd8xN+sm1OWj+tex/3fdtzFcmjJVtcx0S1dRCyZXdx3A
 15N4/lXWSoe/flXbEc+sTwUKGc2gaC1BC7PyE8z9BlN/Iz72jRc3oIMtTGvQcaWSLLlF
 GsEsl2RIU57PdnlMFy/YLpFydX/56PnUejp9aQFRPhrp4Q8AZ8VuI3189gO9bCZTQhRU Fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32bs1m9x8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L04B33000953
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32dnae12j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:16 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06L0GGGA014532
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:16 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 17:16:16 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 13/25] xfs: Remove unneeded xfs_trans_roll_inode calls
Date:   Mon, 20 Jul 2020 17:15:54 -0700
Message-Id: <20200721001606.10781-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721001606.10781-1-allison.henderson@oracle.com>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Some calls to xfs_trans_roll_inode and xfs_defer_finish routines are not
needed. If they are the last operations executed in these functions, and
no further changes are made, then higher level routines will roll or
commit the transactions.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 61 ++++++------------------------------------------
 1 file changed, 7 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 4eff875..1a78023 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -693,34 +693,15 @@ xfs_attr_leaf_addname(
 		/*
 		 * If the result is small enough, shrink it all into the inode.
 		 */
-		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
+		forkoff = xfs_attr_shortform_allfit(bp, dp);
+		if (forkoff)
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
-			if (error)
-				return error;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				return error;
-		}
-
-		/*
-		 * Commit the remove and start the next trans in series.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-
 	} else if (args->rmtblkno > 0) {
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
 		error = xfs_attr3_leaf_clearflag(args);
-		if (error)
-			return error;
-
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
 	}
 	return error;
 }
@@ -780,15 +761,11 @@ xfs_attr_leaf_removename(
 	/*
 	 * If the result is small enough, shrink it all into the inode.
 	 */
-	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+	forkoff = xfs_attr_shortform_allfit(bp, dp);
+	if (forkoff)
+		return xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
-		if (error)
-			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-	}
+
 	return 0;
 }
 
@@ -1070,18 +1047,8 @@ xfs_attr_node_addname(
 			error = xfs_da3_join(state);
 			if (error)
 				goto out;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
 		}
 
-		/*
-		 * Commit and start the next trans in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			goto out;
-
 	} else if (args->rmtblkno > 0) {
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
@@ -1089,14 +1056,6 @@ xfs_attr_node_addname(
 		error = xfs_attr3_leaf_clearflag(args);
 		if (error)
 			goto out;
-
-		 /*
-		  * Commit the flag value change and start the next trans in
-		  * series.
-		  */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			goto out;
 	}
 	retval = error = 0;
 
@@ -1135,16 +1094,10 @@ xfs_attr_node_shrink(
 	if (forkoff) {
 		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
-		if (error)
-			return error;
-
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
 	} else
 		xfs_trans_brelse(args->trans, bp);
 
-	return 0;
+	return error;
 }
 
 /*
-- 
2.7.4


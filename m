Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AACDC04E30
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3FB82464B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SVid3ZDs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfLLEPb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 23:15:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48448 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbfLLEPb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 23:15:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4EfBF144767
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=QHmyw6+1seDQsjsz+7LMb3t2gT8TS3nFWSCOq/e7sgE=;
 b=SVid3ZDsrgcg1T/cnqE2n1pJJzUmo2fpttUdxgbvQ8OD629dS/7DK63WI/YkO1/YThaP
 xsChoKeBuw2AVZ8K9lmZQTqswnl8PDwDvVyjnNkFUxrUCbd89UfPNoEEWamx6CNTKl/A
 Prf0Jp+83oY7oqlX/Etq2fqDnKxWSoOsWpIb3ZYvatczbOU0sDBmLHplp1jeUQSu6WJI
 ZirQXEP4SF3CfnJD8FJ444u+nosxilaZNP37mk2t1TDdHG+mBV8WHMQ/YrzkZfqgdMRA
 U/FkFcbR5acFMrnwi9KO724z7nmpPplpDl0jk8Cg0JyA4zFzoSglDPatYos+TVVJukRv vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wrw4ndbe5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4E6hS128104
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wu5cs3db1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:28 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBC4FSFl017135
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:28 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Dec 2019 20:15:28 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 07/14] xfs: Factor out xfs_attr_leaf_addname helper
Date:   Wed, 11 Dec 2019 21:15:06 -0700
Message-Id: <20191212041513.13855-8-allison.henderson@oracle.com>
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

Factor out new helper function xfs_attr_leaf_try_add.
Because new delayed attribute routines cannot roll
transactions, we carve off the parts of
xfs_attr_leaf_addname that we can use.  This will help
to reduce repetitive code later when we introduce
delayed attributes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 83 ++++++++++++++++++++++++++++--------------------
 1 file changed, 49 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ee973d2..36f6a43 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -305,10 +305,30 @@ xfs_attr_set_args(
 		}
 	}
 
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_addname(args);
-	else
-		error = xfs_attr_node_addname(args);
+		if (error == 0 || error != -ENOSPC)
+			return 0;
+
+		/*
+		 * Commit that transaction so that the node_addname()
+		 * call can manage its own transactions.
+		 */
+		error = xfs_defer_finish(&args->trans);
+		if (error)
+			return error;
+
+		/*
+		 * Commit the current trans (including the inode) and
+		 * start a new one.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (error)
+			return error;
+
+	}
+
+	error = xfs_attr_node_addname(args);
 	return error;
 }
 
@@ -606,21 +626,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
  * External routines when attribute list is one block
  *========================================================================*/
 
-/*
- * Add a name to the leaf attribute list structure
- *
- * This leaf block cannot have a "remote" value, we only call this routine
- * if bmap_one_block() says there is only one block (ie: no remote blks).
- */
 STATIC int
-xfs_attr_leaf_addname(
-	struct xfs_da_args	*args)
+xfs_attr_leaf_try_add(
+	struct xfs_da_args	*args,
+	struct xfs_buf		*bp)
 {
-	struct xfs_buf		*bp;
-	int			retval, error, forkoff;
-	struct xfs_inode	*dp = args->dp;
-
-	trace_xfs_attr_leaf_addname(args);
+	int			retval, error;
 
 	/*
 	 * Look up the given attribute in the leaf block.  Figure out if
@@ -666,31 +677,35 @@ xfs_attr_leaf_addname(
 	retval = xfs_attr3_leaf_add(bp, args);
 	if (retval == -ENOSPC) {
 		/*
-		 * Promote the attribute list to the Btree format, then
-		 * Commit that transaction so that the node_addname() call
-		 * can manage its own transactions.
+		 * Promote the attribute list to the Btree format.
+		 * Unless an error occurs, retain the -ENOSPC retval
 		 */
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
+	}
+	return retval;
+}
 
-		/*
-		 * Commit the current trans (including the inode) and start
-		 * a new one.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
 
-		/*
-		 * Fob the whole rest of the problem off on the Btree code.
-		 */
-		error = xfs_attr_node_addname(args);
+/*
+ * Add a name to the leaf attribute list structure
+ *
+ * This leaf block cannot have a "remote" value, we only call this routine
+ * if bmap_one_block() says there is only one block (ie: no remote blks).
+ */
+STATIC int
+xfs_attr_leaf_addname(struct xfs_da_args	*args)
+{
+	int			error, forkoff;
+	struct xfs_buf		*bp = NULL;
+	struct xfs_inode	*dp = args->dp;
+
+	trace_xfs_attr_leaf_addname(args);
+
+	error = xfs_attr_leaf_try_add(args, bp);
+	if (error)
 		return error;
-	}
 
 	/*
 	 * Commit the transaction that added the attr name so that
-- 
2.7.4


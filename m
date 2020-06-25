Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A0CC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F7EA2084D
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:30:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lf0+1P6n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgFYXas (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:30:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50596 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbgFYXar (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:30:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSFpa151925
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=sfLCpDuqNxz7/mtPHH4lVBqsgedNtOs7SCbLgSbR4ZY=;
 b=Lf0+1P6nouHYlFx58JctY6vUzVIeopxkyJqJE2mFsV2xEHozm0we2cSLPx0EcpBqh5AV
 diQ1ymJi3cPwiz3ybaavcIkFWv+Bg7+Sn1UCTOiZy9PmwOqKR4E7YCb3W0ytCGigGuY/
 ZqyzhZ025cUJK4H5ODquSR8SMGf5HsN0kGa++uVFhCCMxRpsdWF2BG3sZG9AlNgc9M4o
 Q/hPHGv6hZQOxgJrEjKfF0RzN58dJl9YZp7u8sMSBrcS61UdxdryVxX475yNh3mfdQUT
 OaJiA/pmqhrQobeZymnZVdOdhGWveiZ7/Y54EYvGg/Ui3lUtw4rhkAMLwrGPXeBxrfpv Xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31uusu3ady-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNRSre015481
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31uurt9ktd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:44 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PNUi46008395
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:44 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:30:44 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 05/25] xfs: Split apart xfs_attr_leaf_addname
Date:   Thu, 25 Jun 2020 16:29:58 -0700
Message-Id: <20200625233018.14585-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625233018.14585-1-allison.henderson@oracle.com>
References: <20200625233018.14585-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Split out new helper function xfs_attr_leaf_try_add from
xfs_attr_leaf_addname. Because new delayed attribute routines cannot
roll transactions, we split off the parts of xfs_attr_leaf_addname that
we can use, and move the commit into the calling function.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 95 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 61 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 28a9f8e..6fc6dc6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -256,10 +256,31 @@ xfs_attr_set_args(
 		}
 	}
 
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_addname(args);
-	else
-		error = xfs_attr_node_addname(args);
+		if (error != -ENOSPC)
+			return error;
+
+		/*
+		 * Finish any deferred work items and roll the transaction once
+		 * more.  The goal here is to call node_addname with the inode
+		 * and transaction in the same state (inode locked and joined,
+		 * transaction clean) no matter how we got to this step.
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
+	}
+
+	error = xfs_attr_node_addname(args);
 	return error;
 }
 
@@ -507,20 +528,21 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
  *========================================================================*/
 
 /*
- * Add a name to the leaf attribute list structure
+ * Tries to add an attribute to an inode in leaf form
  *
- * This leaf block cannot have a "remote" value, we only call this routine
- * if bmap_one_block() says there is only one block (ie: no remote blks).
+ * This function is meant to execute as part of a delayed operation and leaves
+ * the transaction handling to the caller.  On success the attribute is added
+ * and the inode and transaction are left dirty.  If there is not enough space,
+ * the attr data is converted to node format and -ENOSPC is returned. Caller is
+ * responsible for handling the dirty inode and transaction or adding the attr
+ * in node format.
  */
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
@@ -562,31 +584,39 @@ xfs_attr_leaf_addname(
 	retval = xfs_attr3_leaf_add(bp, args);
 	if (retval == -ENOSPC) {
 		/*
-		 * Promote the attribute list to the Btree format, then
-		 * Commit that transaction so that the node_addname() call
-		 * can manage its own transactions.
+		 * Promote the attribute list to the Btree format. Unless an
+		 * error occurs, retain the -ENOSPC retval
 		 */
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
+	}
+	return retval;
+out_brelse:
+	xfs_trans_brelse(args->trans, bp);
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
+xfs_attr_leaf_addname(
+	struct xfs_da_args	*args)
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
@@ -681,9 +711,6 @@ xfs_attr_leaf_addname(
 		error = xfs_attr3_leaf_clearflag(args);
 	}
 	return error;
-out_brelse:
-	xfs_trans_brelse(args->trans, bp);
-	return retval;
 }
 
 /*
-- 
2.7.4


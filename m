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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88976C4361B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58FCF23A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732953AbgLRH0s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:26:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37608 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732935AbgLRH0s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:26:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7KOtM003145
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=e9T4Rm5tPmgFW7EoWtY/IBOx6vw56Cs0jKi3s1PgjIM=;
 b=qXu9O+MQ5xpMlIq6kIIZkeY3KqZeeMsoPfhHdfgoY481Ayf7giJrWXd3bW4oPQGpPJrF
 GzKDSToMs7q1vAhRK4mcY0G0CpNu5qHvyonzHO1MJaJEJi3bCq3y9CthEEQUNW2BecRv
 XFwE2Dm/fdZX9EKbt04TJW7uSVXR++SSbJScvHntYuu5yroxvpmBnII6imPseEVpNDnc
 5C+38x9AjWvCuWtyKglSlWTzpnwY/V6GMmXQuPEVC1VFY+nDkHE7UZTSFGhQwjPxkwTA
 l8oOsr58AFtkNXBLyfY9UJS2idIirLugLVziia92/zlGg08/2aIQ3lvuCZxomPigxQdF Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35cn9rs17x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7LKsS044417
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35d7erys5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:06 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BI7Q5Xn002806
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:05 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:26:05 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 01/14] xfsprogs: Add helper xfs_attr_node_remove_step
Date:   Fri, 18 Dec 2020 00:25:42 -0700
Message-Id: <20201218072555.16694-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218072555.16694-1-allison.henderson@oracle.com>
References: <20201218072555.16694-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180052
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

Source kernel commit: 5e2aff99f8f0b7ff511b7bbd1213743f59806878

This patch as a new helper function xfs_attr_node_remove_step.  This
will help simplify and modularize the calling function
xfs_attr_node_remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 0c75f46..3645398 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1228,19 +1228,14 @@ xfs_attr_node_remove_rmt(
  * the root node (a special case of an intermediate node).
  */
 STATIC int
-xfs_attr_node_removename(
-	struct xfs_da_args	*args)
+xfs_attr_node_remove_step(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
 {
-	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
-	trace_xfs_attr_node_removename(args);
-
-	error = xfs_attr_node_removename_setup(args, &state);
-	if (error)
-		goto out;
 
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1250,7 +1245,7 @@ xfs_attr_node_removename(
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_node_remove_rmt(args, state);
 		if (error)
-			goto out;
+			return error;
 	}
 
 	/*
@@ -1267,18 +1262,45 @@ xfs_attr_node_removename(
 	if (retval && (state->path.active > 1)) {
 		error = xfs_da3_join(state);
 		if (error)
-			goto out;
+			return error;
 		error = xfs_defer_finish(&args->trans);
 		if (error)
-			goto out;
+			return error;
 		/*
 		 * Commit the Btree join operation and start a new trans.
 		 */
 		error = xfs_trans_roll_inode(&args->trans, dp);
 		if (error)
-			goto out;
+			return error;
 	}
 
+	return error;
+}
+
+/*
+ * Remove a name from a B-tree attribute list.
+ *
+ * This routine will find the blocks of the name to remove, remove them and
+ * shrink the tree if needed.
+ */
+STATIC int
+xfs_attr_node_removename(
+	struct xfs_da_args	*args)
+{
+	struct xfs_da_state	*state = NULL;
+	int			error;
+	struct xfs_inode	*dp = args->dp;
+
+	trace_xfs_attr_node_removename(args);
+
+	error = xfs_attr_node_removename_setup(args, &state);
+	if (error)
+		goto out;
+
+	error = xfs_attr_node_remove_step(args, state);
+	if (error)
+		goto out;
+
 	/*
 	 * If the result is small enough, push it all into the inode.
 	 */
-- 
2.7.4


Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0318C47262
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C631B2166E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="blHR2K+C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgD3WrS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:47:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48484 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbgD3WrQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:47:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhQUq047381
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=w+I3OagRhMYLMUZJw+WPUyN7E9lI74SNVgwVmXMzHXk=;
 b=blHR2K+Cjmhg9nfzfg0RlZxQmxUCkalGY49gCRXO2aqeCwn6pqEFwK0wGdf2hB+UOmvn
 lsF/s1utRM7UfR6YS3l8Pb4z26x+XFWCMLt0LUKWLx7IN4KzmqpKLxzr1Q319OEUsBcY
 1tOiuD/+cxEhcQO+RhBhoF+n1LgbrNT2yuj0wxg/m18YaGRHfXTK9dzcVHgEd1Iawbxp
 w7kT9mvzgqYAIRcZOwC9s+wIseAfRlJvFarOkH4R7tigW+mJPrr//SoLUqJrY0cLR0DV
 CFpcsoWJ+r6RDdqwWxowjCtfOS50mfLjiephSOIshgKasZPCocO22bJamyTIFuQg2Svs CQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30r7f5r277-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgD2M141447
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30qtg23dxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:15 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMlELC012416
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:14 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:14 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 36/43] xfsprogs: Add helper function xfs_attr_node_removename_setup
Date:   Thu, 30 Apr 2020 15:46:53 -0700
Message-Id: <20200430224700.4183-37-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 impostorscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a new helper function xfs_attr_node_removename_setup.
This will help modularize xfs_attr_node_removename when we add delay
ready attributes later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 48 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 64cc6b3..7ca925a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1185,6 +1185,39 @@ xfs_attr_leaf_mark_incomplete(
 }
 
 /*
+ * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
+ * the blocks are valid.  Any remote blocks will be marked incomplete.
+ */
+STATIC
+int xfs_attr_node_removename_setup(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	**state)
+{
+	int			error;
+	struct xfs_da_state_blk	*blk;
+
+	error = xfs_attr_node_hasname(args, state);
+	if (error != -EEXIST)
+		return error;
+
+	blk = &(*state)->path.blk[(*state)->path.active - 1];
+	ASSERT(blk->bp != NULL);
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+
+	if (args->rmtblkno > 0) {
+		error = xfs_attr_leaf_mark_incomplete(args, *state);
+		if (error)
+			return error;
+
+		error = xfs_attr_rmtval_invalidate(args);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/*
  * Remove a name from a B-tree attribute list.
  *
  * This will involve walking down the Btree, and may involve joining
@@ -1202,8 +1235,8 @@ xfs_attr_node_removename(
 
 	trace_xfs_attr_node_removename(args);
 
-	error = xfs_attr_node_hasname(args, &state);
-	if (error != -EEXIST)
+	error = xfs_attr_node_removename_setup(args, &state);
+	if (error)
 		goto out;
 
 	/*
@@ -1211,18 +1244,7 @@ xfs_attr_node_removename(
 	 * This is done before we remove the attribute so that we don't
 	 * overflow the maximum size of a transaction and/or hit a deadlock.
 	 */
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->bp != NULL);
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_leaf_mark_incomplete(args, state);
-		if (error)
-			goto out;
-
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
-
 		error = xfs_attr_rmtval_remove(args);
 		if (error)
 			goto out;
-- 
2.7.4


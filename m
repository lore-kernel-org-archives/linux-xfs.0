Return-Path: <SRS0=IYU2=A5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D50C433F1
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3463F207FB
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:34:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PzfAuIcd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgGREd7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jul 2020 00:33:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42870 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgGREd6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jul 2020 00:33:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4XmIu004179
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=gowtgMYszVpWh3SgHDnFVU66peufeSYFbgGbY7JHIl4=;
 b=PzfAuIcd3RK/ESJXhLyqADC4GGA2fFSg4PkN9jXbM0VOwGhN74lLlLauQUs15TmaD40U
 z57aGkDH48+z7nQpNrpSUMpV3RMqX/5pCoXSMo8XX6JoauF+RH952NIFdI9Ssa5j5Wwe
 BHiDhTq3q946kwIuqLLBNnmkFH2ZGJva1Ujn6X7/MUOscvgPGSyhI1aFnTYjsMFJjDBQ
 Or17ZwAs42jrhZAq5h88FzGDHS8ahYSLJm1qtfqUkX8x8UBsgP5izdQL1il18ojCwNrv
 9UIFgndR1a/qs9SLO3ABwivJLcAoJIvWMojHiYmuoaGXJF9fwoYM1DtLJxO0izhK0XEW XA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32bs1m03r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4Xl44169348
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32brw1w7cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:57 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06I4XuuZ008272
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:56 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 21:33:56 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 19/26] xfsprogs: Add helper function xfs_attr_node_removename_setup
Date:   Fri, 17 Jul 2020 21:33:35 -0700
Message-Id: <20200718043342.6432-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200718043342.6432-1-allison.henderson@oracle.com>
References: <20200718043342.6432-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
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
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c | 47 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 25f5572..ec08c74 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1174,6 +1174,38 @@ xfs_attr_leaf_mark_incomplete(
 }
 
 /*
+ * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
+ * the blocks are valid.  Attr keys with remote blocks will be marked
+ * incomplete.
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
+		return xfs_attr_rmtval_invalidate(args);
+	}
+
+	return 0;
+}
+
+/*
  * Remove a name from a B-tree attribute list.
  *
  * This will involve walking down the Btree, and may involve joining
@@ -1191,8 +1223,8 @@ xfs_attr_node_removename(
 
 	trace_xfs_attr_node_removename(args);
 
-	error = xfs_attr_node_hasname(args, &state);
-	if (error != -EEXIST)
+	error = xfs_attr_node_removename_setup(args, &state);
+	if (error)
 		goto out;
 
 	/*
@@ -1200,18 +1232,7 @@ xfs_attr_node_removename(
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


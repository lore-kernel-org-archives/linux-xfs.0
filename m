Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0060EC433E5
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D363B20899
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:29:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NETUbwPv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgFYX3n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:29:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51230 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732051AbgFYX3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:29:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNS5eI012342
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=gowtgMYszVpWh3SgHDnFVU66peufeSYFbgGbY7JHIl4=;
 b=NETUbwPv85QldmqFWQ2xG9M3LJLjCbrdtEG06DSZlAnbGmwWMk7To50XBICL3zAZowO6
 MZBQZIbuV7gFOjCTCU13DG5dZ/8NXOEsVAPSuBKsngFjWR9OPFroPwGTTh3ZvvLcqu9W
 KzCVIhX/1kvTZTas4RvUGHnQLLfDCc1PGI1Lt0oUS7U6fAsQIld/yO6EAtoRRGvNczLN
 hF2sFshFIxwcEOSfdrj2hmpGc+SHRLP979k72U8FLp0IG4EmWWCl1jLH3psQL4QZo4jr
 o3V31wwJzOgnmYdOLTxIX9GaiVUQJG8+LD4ypYHWASKJfl+nzU1YUQLHnKEo6RofMscS Gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31uustu966-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSIH7111025
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31uur9r3nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:06 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PNT5I5015775
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:05 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:29:05 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 19/26] xfsprogs: Add helper function xfs_attr_node_removename_setup
Date:   Thu, 25 Jun 2020 16:28:41 -0700
Message-Id: <20200625232848.14465-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625232848.14465-1-allison.henderson@oracle.com>
References: <20200625232848.14465-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=1 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250136
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


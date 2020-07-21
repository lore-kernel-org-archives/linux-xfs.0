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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D74C433F4
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC01822C9C
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NfA/bpMd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgGUAQW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:16:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38420 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728123AbgGUAQV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 20:16:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L02ccQ102328
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=90CbwzHsP0hq3e05PD0aS29mUCM34YsOMehY16ut0dQ=;
 b=NfA/bpMdEWJVmN2BcC0bYqQx6Rvp5omtgerf8GzT/LfzbQzZ9/Glw2N0iuE4f7BTNyMP
 EhhvutqXfhoTFhcuUTs0nBcq3knQH/T3JUz7QatnToaDl9uyHplQhArc05c/vt2IHpFP
 qu/OKB+fvHjNFwRYrSFKyakXJ2kvfVhvjST8ByBtJ505e/B7Pv/Ux75ksYRGgwkwBJRy
 fr45y+HWpBoo1dblCSBDh6/qcOvgi1CKzuxR9i2DAiZ80xIIKGYoC4yWD1LroRbGHd+c
 oCZQ9PPmTr9jNrYYFGMMtO+ZcKIjetbMoEsd0XRDMoBpCAaz8H2I1uRO9P1se5y/tMo9 Og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32brgr9ymm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L0DNti177051
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32dnmq82vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:18 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06L0GHxJ001244
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 17:16:17 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 18/25] xfs: Add helper function xfs_attr_node_removename_setup
Date:   Mon, 20 Jul 2020 17:15:59 -0700
Message-Id: <20200721001606.10781-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721001606.10781-1-allison.henderson@oracle.com>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=1 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200146
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
 fs/xfs/libxfs/xfs_attr.c | 47 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ff7523f..f84c163 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
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


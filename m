Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD30C2BA17
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64FAA2078C
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CR2bm3xf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgDCWMq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:12:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56698 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728312AbgDCWMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:12:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M9e7m092971
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=LY61E3mfXbMNsF9+fhaTN7Rajqj7ZoMZTQXQS5P3s+w=;
 b=CR2bm3xfTs2TvI4UUyIDCmzDSdcU8mWPERe+bMSTcVe0CHXXFjiTfQj4t9Y9BI3EplHs
 EEyX/5kdoxq0uEW7CNQnDdnOo55P7MNKKHiuDniNqZPNQ3eKU6TpfMyqBsTf5V5hil0X
 OV23NnmS7UANq741/8UYhPheuKNnsw1I9wclSsq80UmCZnIROhGrc5d0Yqs1PptfbUT3
 YbpxcVs8HcT64lP7tAS79mwsA/KWk/z9fgDVtUpkN1Skjh0MP3FZ6etVdtE9afCCOYHL
 +lERt/y5t3Jwr1WLMHCnXz3+sLCD2B1QWP/H3mMBvExzV9nTnZTKJGsg8xGb9w31JN4h RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 303yunp0r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:12:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M7Jsr167773
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 304sju4htw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:12:43 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033MChNg008076
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:43 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:12:43 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 16/20] xfs: Add helper function xfs_attr_node_removename_setup
Date:   Fri,  3 Apr 2020 15:12:25 -0700
Message-Id: <20200403221229.4995-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403221229.4995-1-allison.henderson@oracle.com>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 mlxlogscore=992 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=1 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a new helper function xfs_attr_node_removename_setup.
This will help modularize xfs_attr_node_removename when we add delay
ready attributes later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f70b4f2..3c33dc5 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1193,6 +1193,35 @@ xfs_attr_leaf_mark_incomplete(
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
+	}
+
+	return 0;
+}
+
+/*
  * Remove a name from a B-tree attribute list.
  *
  * This will involve walking down the Btree, and may involve joining
@@ -1210,8 +1239,8 @@ xfs_attr_node_removename(
 
 	trace_xfs_attr_node_removename(args);
 
-	error = xfs_attr_node_hasname(args, &state);
-	if (error != -EEXIST)
+	error = xfs_attr_node_removename_setup(args, &state);
+	if (error)
 		goto out;
 
 	/*
@@ -1219,14 +1248,7 @@ xfs_attr_node_removename(
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
 		error = xfs_attr_rmtval_remove(args);
 		if (error)
 			goto out;
-- 
2.7.4


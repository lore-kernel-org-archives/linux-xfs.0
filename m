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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B63EC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEBDF22BF5
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:18:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IJzcPCay"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgGUAST (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:18:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41772 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728220AbgGUAST (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 20:18:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L05g65183361
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:18:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Hwc0nfekKDWxm9PMWFYSa9E4oFWDt+Wjbbe7ytdGIzA=;
 b=IJzcPCayiF0GyEbjiWBFOD2ensyXy8TUUorEpfDwHz7TZf1oEatd+/n0XYBFa1LnAzi8
 9Vgz9m5N6AoS2luq6S2lXBuuphwZ1HasujUW7pEZEQQji+ri0fP8BzC5mO2paBpor2FI
 L8dDy5fcSHuZLvVrxVFhKgK9dIy9F3Gs787xf9+2OGXn1rgPS0xywCF3oy32QYxuhdTj
 FPWyt2ofDNv9WIbymcrspk5KCn1N8KEXTh9x3i4mbap99hOCGoCN8zZK3Zn/MuMtOCjM
 9s8uCiS2+D9bh1nc1GERLKpKWQ2wI/jHUl9a2pX85MKE0NC+77FvjJqA+OgUXsoBFANj Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32bs1m9xgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:18:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L0E3g7008919
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32dnafgn5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06L0GHal001238
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 17:16:17 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 16/25] xfs: Add helper function xfs_attr_leaf_mark_incomplete
Date:   Mon, 20 Jul 2020 17:15:57 -0700
Message-Id: <20200721001606.10781-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721001606.10781-1-allison.henderson@oracle.com>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200146
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

This patch helps to simplify xfs_attr_node_removename by modularizing
the code around the transactions into helper functions.  This will make
the function easier to follow when we introduce delayed attributes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b828f3b..229940c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1138,6 +1138,32 @@ xfs_attr_node_shrink(
 }
 
 /*
+ * Mark an attribute entry INCOMPLETE and save pointers to the relevant buffers
+ * for later deletion of the entry.
+ */
+STATIC int
+xfs_attr_leaf_mark_incomplete(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	int			error;
+
+	/*
+	 * Fill in disk block numbers in the state structure
+	 * so that we can get the buffers back after we commit
+	 * several transactions in the following calls.
+	 */
+	error = xfs_attr_fillstate(state);
+	if (error)
+		return error;
+
+	/*
+	 * Mark the attribute as INCOMPLETE
+	 */
+	return xfs_attr3_leaf_setflag(args);
+}
+
+/*
  * Remove a name from a B-tree attribute list.
  *
  * This will involve walking down the Btree, and may involve joining
@@ -1168,20 +1194,7 @@ xfs_attr_node_removename(
 	ASSERT(blk->bp != NULL);
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 	if (args->rmtblkno > 0) {
-		/*
-		 * Fill in disk block numbers in the state structure
-		 * so that we can get the buffers back after we commit
-		 * several transactions in the following calls.
-		 */
-		error = xfs_attr_fillstate(state);
-		if (error)
-			goto out;
-
-		/*
-		 * Mark the attribute as INCOMPLETE, then bunmapi() the
-		 * remote value.
-		 */
-		error = xfs_attr3_leaf_setflag(args);
+		error = xfs_attr_leaf_mark_incomplete(args, state);
 		if (error)
 			goto out;
 
-- 
2.7.4


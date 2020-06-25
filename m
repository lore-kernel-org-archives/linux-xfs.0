Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BC1C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1698F20885
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:29:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FHxyecMk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbgFYX3k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:29:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51224 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732046AbgFYX3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:29:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNS4mV012327
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=D5Tx3jyUdrycvSVYi+hZtg5tXMu6sB7svp45Cq5N+70=;
 b=FHxyecMkWHjkUl0h4i++M/ybYpO6M5xr4NOiTzniI1vbRtRDLGoGC3NOMohAk/jaFzX0
 YqZVk73loaPdS3v3A1H68BRr5gD9xpNsk4eIqSc6GuzkPR3XZtAZfOoHPvhHNvXA4QkX
 rwvhHP7/prehR7O5NKjlj1reqkVHtdjPuTdhul0rkdmWXzIFm6kZ4a7hdRxbMOm4hR+P
 NEeGv73nR3pSTpTmaibhMu6LfYQBRfdNSM7TiZbwaNtAZVf/eV6XAYHjBzIzgI6JYFgJ
 uxWQkNseEloLKspPoWxwQJSIOG5wlNJ0NLAr+j3V2jItUA9lKBimxoCNoqBtgvuc9q/T LA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31uustu964-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNS2Dm141065
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31uur1wayr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:05 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05PNT4Di016790
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:05 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:29:04 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 17/26] xfsprogs: Add helper function xfs_attr_leaf_mark_incomplete
Date:   Thu, 25 Jun 2020 16:28:39 -0700
Message-Id: <20200625232848.14465-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625232848.14465-1-allison.henderson@oracle.com>
References: <20200625232848.14465-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=1 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250136
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

This patch helps to simplify xfs_attr_node_removename by modularizing
the code around the transactions into helper functions.  This will make
the function easier to follow when we introduce delayed attributes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 3fecd3b..ded489a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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


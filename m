Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1722C47263
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8C4320774
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N8MxX3g0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgD3WrT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:47:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48492 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgD3WrR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:47:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhNBZ047342
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=+SneujZt3CMM0UMXLynvi+p4Z4BRi2M1/qSxhCPJuLM=;
 b=N8MxX3g0PKS/CCzkauoskHAw8Sytncp7Ca0AMDTcDrvDcisLh7ViewHOjoenyCJ9knjZ
 EzkOiPERi8hNCOB2ss+yJeMMWvbNon3TfKB3kgbOYQoA8pTyEfmDxBvtD7SemFy1p8Tb
 3reZoBCEgOIL4nZc5ow0ZnmUR7ErbeG2FaIYWv4rFuy+KE2bBwIZ5cbxENE5jRUiC0ag
 wHsG510KHYDl0aVkqZjUcno6jxAYcnGFV63QDsBrNcNvTgvV7qF1rGwJ9BtWHyOQBAZH
 dZr4x3ODoW4NJXv30l+nnZr4asINiXqtwLSZIL345S6xUT62cBjzP2ncMifNSka1jNO5 IQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30r7f5r278-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgthi076901
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30r7f8a08n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:15 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UMlEO7012925
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:14 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:13 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 34/43] xfsprogs: Add helper function xfs_attr_leaf_mark_incomplete
Date:   Thu, 30 Apr 2020 15:46:51 -0700
Message-Id: <20200430224700.4183-35-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

This patch helps to simplify xfs_attr_node_removename by modularizing
the code around the transactions into helper functions.  This will make
the function easier to follow when we introduce delayed attributes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index b8dad2a..0a46827 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1149,6 +1149,32 @@ xfs_attr_node_shrink(
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
@@ -1179,20 +1205,7 @@ xfs_attr_node_removename(
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


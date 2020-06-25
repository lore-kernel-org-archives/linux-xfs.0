Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A8BC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2769420768
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:30:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zm6rR3BD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgFYXax (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:30:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50630 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgFYXau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:30:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNRwvK151811
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=dL7zwg5UAGryUSiDX1lZpdhJ3jd7OdihPavDoKjrK8o=;
 b=zm6rR3BD+suUsGKFHIMXkkJTX/iX22KMm41Nk/o5azjfo+TD2zfw2lsi/94yAQNmhP1E
 Qc2BpNw8hkmb5zSEaqCRGtRSifxwMDSpcCQ9bDA1u8FnlpJUZLQa38wU0JaaeWVnV/2P
 yjK1YHy/urV+RMtCYObzVvrg78kXUJpBcjTdPZOdX1AySAHK9d2dEJu9fYjqGqnY+enx
 GK6rhRZKgyTCzX3RH/STs0ekdz0MfvaW+N0o1ADHLXqzxh0W46bOnvMtyD6AlPWDSe2O
 0sSQW4bYf1LAJZ8PDYJflQA1O2lSoFFX+GxzE1f6EAfro74LN2S/NAsgc+X4BWMwLXA4 +w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31uusu3ae4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNRSjl015488
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31uurt9kvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PNUlkM008515
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:47 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:30:47 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 17/25] xfs: Add remote block helper functions
Date:   Thu, 25 Jun 2020 16:30:10 -0700
Message-Id: <20200625233018.14585-18-allison.henderson@oracle.com>
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

This patch adds two new helper functions xfs_attr_store_rmt_blk and
xfs_attr_restore_rmt_blk. These two helpers assist to remove redundant
code associated with storing and retrieving remote blocks during the
attr set operations.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 50 +++++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 229940c..ff7523f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -564,6 +564,30 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
  * External routines when attribute list is one block
  *========================================================================*/
 
+/* Store info about a remote block */
+STATIC void
+xfs_attr_save_rmt_blk(
+	struct xfs_da_args	*args)
+{
+	args->blkno2 = args->blkno;
+	args->index2 = args->index;
+	args->rmtblkno2 = args->rmtblkno;
+	args->rmtblkcnt2 = args->rmtblkcnt;
+	args->rmtvaluelen2 = args->rmtvaluelen;
+}
+
+/* Set stored info about a remote block */
+STATIC void
+xfs_attr_restore_rmt_blk(
+	struct xfs_da_args	*args)
+{
+	args->blkno = args->blkno2;
+	args->index = args->index2;
+	args->rmtblkno = args->rmtblkno2;
+	args->rmtblkcnt = args->rmtblkcnt2;
+	args->rmtvaluelen = args->rmtvaluelen2;
+}
+
 /*
  * Tries to add an attribute to an inode in leaf form
  *
@@ -598,11 +622,7 @@ xfs_attr_leaf_try_add(
 
 		/* save the attribute state for later removal*/
 		args->op_flags |= XFS_DA_OP_RENAME;	/* an atomic rename */
-		args->blkno2 = args->blkno;		/* set 2nd entry info*/
-		args->index2 = args->index;
-		args->rmtblkno2 = args->rmtblkno;
-		args->rmtblkcnt2 = args->rmtblkcnt;
-		args->rmtvaluelen2 = args->rmtvaluelen;
+		xfs_attr_save_rmt_blk(args);
 
 		/*
 		 * clear the remote attr state now that it is saved so that the
@@ -701,11 +721,8 @@ xfs_attr_leaf_addname(
 		 * Dismantle the "old" attribute/value pair by removing
 		 * a "remote" value (if it exists).
 		 */
-		args->index = args->index2;
-		args->blkno = args->blkno2;
-		args->rmtblkno = args->rmtblkno2;
-		args->rmtblkcnt = args->rmtblkcnt2;
-		args->rmtvaluelen = args->rmtvaluelen2;
+		xfs_attr_restore_rmt_blk(args);
+
 		if (args->rmtblkno) {
 			error = xfs_attr_rmtval_invalidate(args);
 			if (error)
@@ -924,11 +941,7 @@ xfs_attr_node_addname(
 
 		/* save the attribute state for later removal*/
 		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
-		args->blkno2 = args->blkno;		/* set 2nd entry info*/
-		args->index2 = args->index;
-		args->rmtblkno2 = args->rmtblkno;
-		args->rmtblkcnt2 = args->rmtblkcnt;
-		args->rmtvaluelen2 = args->rmtvaluelen;
+		xfs_attr_save_rmt_blk(args);
 
 		/*
 		 * clear the remote attr state now that it is saved so that the
@@ -1040,11 +1053,8 @@ xfs_attr_node_addname(
 		 * Dismantle the "old" attribute/value pair by removing
 		 * a "remote" value (if it exists).
 		 */
-		args->index = args->index2;
-		args->blkno = args->blkno2;
-		args->rmtblkno = args->rmtblkno2;
-		args->rmtblkcnt = args->rmtblkcnt2;
-		args->rmtvaluelen = args->rmtvaluelen2;
+		xfs_attr_restore_rmt_blk(args);
+
 		if (args->rmtblkno) {
 			error = xfs_attr_rmtval_invalidate(args);
 			if (error)
-- 
2.7.4


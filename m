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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064EEC433EC
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8B6722B4E
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KuC2H+xu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgGUAQV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:16:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40490 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728085AbgGUAQT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 20:16:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L03WFC181817
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=dL7zwg5UAGryUSiDX1lZpdhJ3jd7OdihPavDoKjrK8o=;
 b=KuC2H+xupRRqDwBp4o8LZ+R0CPnNMnFU4S1ro9xrVQQ460tYpkuCoaFzV4hv1O0AcATl
 8G+gY4jXd2u1ZI5nCGr5qsJHov9jxyS6/MngjONDYa5v087VrlTS36zVEhNriJZeaI0A
 nEW5iWSIDULLmtN4Ai70gCvMQrZGRozJOSaASKN0kYx6YUW8Ct5plZtyLs26khXEoXiq
 k+x4AKURY7ajk1HsNiI3HGa5/69EQgsnRCTmvbb6h3Pm+t2KpI071WbqGQDSy7BErx9r
 kLcfEWG5eqC5DBIBElZMHIYbUmzq6SBxSX1gnVi+KeVJqDNJvFsm1BzdCvqKgEZh9c5s WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32bs1m9x8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L0E6jG009110
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32dnafgn5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:18 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06L0GHog001241
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 17:16:17 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 17/25] xfs: Add remote block helper functions
Date:   Mon, 20 Jul 2020 17:15:58 -0700
Message-Id: <20200721001606.10781-18-allison.henderson@oracle.com>
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


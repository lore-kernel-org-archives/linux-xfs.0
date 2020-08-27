Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A48C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2E3E2087C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FEI0XfYZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgH0A3U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:29:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37740 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgH0A3U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:29:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0TIgV165398
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=voPYxhxdm1WNeMd9tSikSTqQ0t+Fj2LTASAcXXVeiGQ=;
 b=FEI0XfYZGfiqZm/cIaAx+6iFzR41XHpiwXxoSYzecLaeJ/S8jT687C0s0gv0Dm/4xHol
 1730V+MWCZRzMYv4zVIS+tiXRB07PJwNWJ5EUenTk50/zp7l/P3GStQVoBOgPR7+cpYd
 j3Q3PMKGaQ/eKqfswqlMWTXXcHvSZ/QCmB8/b+9ibQhIF9H7n/IBF9k+P3a6p5is2k+Z
 thEpG8eO3Vur6znO6vZJaQKEDGGWdirqwKhpueYYDiA17L7gGObnJJ6U5W1GbopeSrMc
 to7cdkygES1ezk4xLRoIsjCYRIpQ61guyfsDKRepa9YSxc4Alox1jkZaNRfVWP7RT7H6 pA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 333w6u1yw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0AfVb127471
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 333ru0t3c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:16 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07R0TFiO016897
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:15 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:29:15 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 17/32] xfsprogs: Add remote block helper functions
Date:   Wed, 26 Aug 2020 17:28:41 -0700
Message-Id: <20200827002856.1131-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827002856.1131-1-allison.henderson@oracle.com>
References: <20200827002856.1131-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270001
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
 libxfs/xfs_attr.c | 50 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 11fc469..6f9fa9e 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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
@@ -924,11 +941,7 @@ restart:
 
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
@@ -1040,11 +1053,8 @@ restart:
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


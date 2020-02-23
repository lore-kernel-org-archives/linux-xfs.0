Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040BCC35669
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D067520702
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jxozAmpH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgBWCG1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:06:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46440 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbgBWCG0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:26 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N22Ti6179973
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=YDqKo7KpSgI0xjXmxokjgh982EdYy6zFMqDfw+Gcozk=;
 b=jxozAmpH7ao5iWjRcKPmbxUw/RkxMomTayuF+NE32Zs6LqoGtKL0AQ4yeIjH+/kK1HJg
 h7SR2LCYS2XkltbYtCJNktIbllXR/6zmVM05yChIsWj7ImT7tmO3NIKdSKM+iF0KUwk2
 Vite0yh9jl364pOT2iJ0QDZ8GFRwigTY2lANvlll/Lj6EoLcNAWH7UHwZpucoOnkbIzS
 ncTzBVk8msVqauv+H1lTfzw1Tbvj6dQ0lbN1Htt5czPtWiRzYqCG4GZM+GIcmgnappMb
 8GdZUdMibpH8qVtgzsdxBzJ2riphUyJBLZFvKOjoKrJPXVLGp3ogdaWfMVhqWPIBvvOV zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yavxra00f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N1xFp1147617
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ybdsd6qc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:25 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01N26OOA013241
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:24 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:23 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 18/19] xfs: Add remote block helper functions
Date:   Sat, 22 Feb 2020 19:06:10 -0700
Message-Id: <20200223020611.1802-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223020611.1802-1-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=1 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds two new helper functions xfs_attr_store_rmt_blk and
xfs_attr_restore_rmt_blk. These two helpers assist to remove redunant code
associated with storing and retrieving remote blocks during the attr set operations.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b9728d1..f88be36 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -786,6 +786,30 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
  * External routines when attribute list is one block
  *========================================================================*/
 
+/* Store info about a remote block */
+STATIC void
+xfs_attr_store_rmt_blk(
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
@@ -824,11 +848,7 @@ xfs_attr_leaf_try_add(
 
 		/* save the attribute state for later removal*/
 		args->op_flags |= XFS_DA_OP_RENAME;	/* an atomic rename */
-		args->blkno2 = args->blkno;		/* set 2nd entry info*/
-		args->index2 = args->index;
-		args->rmtblkno2 = args->rmtblkno;
-		args->rmtblkcnt2 = args->rmtblkcnt;
-		args->rmtvaluelen2 = args->rmtvaluelen;
+		xfs_attr_store_rmt_blk(args);
 
 		/*
 		 * clear the remote attr state now that it is saved so that the
@@ -939,11 +959,7 @@ xfs_attr_leaf_addname(
 		 * Dismantle the "old" attribute/value pair by removing
 		 * a "remote" value (if it exists).
 		 */
-		args->index = args->index2;
-		args->blkno = args->blkno2;
-		args->rmtblkno = args->rmtblkno2;
-		args->rmtblkcnt = args->rmtblkcnt2;
-		args->rmtvaluelen = args->rmtvaluelen2;
+		xfs_attr_restore_rmt_blk(args);
 
 		args->dac.dela_state = XFS_DAS_FLIP_LFLAG;
 		return -EAGAIN;
@@ -1189,11 +1205,7 @@ xfs_attr_node_addname(
 
 		/* save the attribute state for later removal*/
 		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
-		args->blkno2 = args->blkno;		/* set 2nd entry info*/
-		args->index2 = args->index;
-		args->rmtblkno2 = args->rmtblkno;
-		args->rmtblkcnt2 = args->rmtblkcnt;
-		args->rmtvaluelen2 = args->rmtvaluelen;
+		xfs_attr_store_rmt_blk(args);
 
 		/*
 		 * clear the remote attr state now that it is saved so that the
@@ -1306,11 +1318,7 @@ xfs_attr_node_addname(
 		 * Dismantle the "old" attribute/value pair by removing
 		 * a "remote" value (if it exists).
 		 */
-		args->index = args->index2;
-		args->blkno = args->blkno2;
-		args->rmtblkno = args->rmtblkno2;
-		args->rmtblkcnt = args->rmtblkcnt2;
-		args->rmtvaluelen = args->rmtvaluelen2;
+		xfs_attr_restore_rmt_blk(args);
 
 		/*
 		 * Commit the flag value change and start the next trans in
-- 
2.7.4


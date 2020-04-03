Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C06C2BA1E
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C2C02078C
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GVB1pr0U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgDCWKS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:10:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38516 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbgDCWKS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:10:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M8su0018974
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=A83UBX1zwm0wdp+dAu5y5SlW6lrX67RzwWj+vGCIedA=;
 b=GVB1pr0UCOY79IVSvB2vmvcexD4puwKYIVc8xdFlMRNTckD4sI0TjZDiq8ZTWZmsimEu
 fyEpHw428blJIwIR4VrGX3SO0Y4izCVlVzenhNwt9WzZ5iUtqsnPl8ywyxVKpX49TIhs
 xftE9A1Rzqmx/anVUlQ0EcBx0tHqMHlojnmqj3N/M4S5Z4zRXMT76VqljHGDJZh79N8o
 T01hdTAUK6/wLJYjGIzHbWgPvImyP2X638J8QVAa25jAc7/ecDWd/TfkhHbwmNyMhZyz
 jHDP5W7K2qH+MMH/0U37wWPnKB/ouHY1YV6BsD+P60ZAuRIqpHA6OziQduNgyQ7E1TtC UQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 303aqj3w4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M8Oqh062433
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 302ga6124w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:16 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033MAFsg009990
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:15 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:15 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 34/39] xfsprogs: Add remote block helper functions
Date:   Fri,  3 Apr 2020 15:09:53 -0700
Message-Id: <20200403220958.4944-35-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
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
---
 libxfs/xfs_attr.c | 50 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 42a435a..9e70f16 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -566,6 +566,30 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
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
@@ -600,11 +624,7 @@ xfs_attr_leaf_try_add(
 
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
@@ -703,11 +723,8 @@ xfs_attr_leaf_addname(
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
 			error = xfs_attr_rmtval_remove(args);
 			if (error)
@@ -935,11 +952,7 @@ restart:
 
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
@@ -1051,11 +1064,8 @@ restart:
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
 			error = xfs_attr_rmtval_remove(args);
 			if (error)
-- 
2.7.4


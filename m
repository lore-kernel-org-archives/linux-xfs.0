Return-Path: <SRS0=IYU2=A5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47DE3C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 270EA2076D
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lfqteOh9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgGREf7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jul 2020 00:35:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60464 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgGREf7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jul 2020 00:35:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4SSRG055680
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:35:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=6wDRmDGVNOY4KKvhFohIQJe4UDJc48KAqo7/PmNAt2s=;
 b=lfqteOh9NgZritSHbgp5ZStTXZqGCn/QFHyDtN2KfpwAO9+HrfvNZlY65aC7ZvEwnhKF
 BBlGV+36LoIa9GCFVUvda7jmXXj8F2Lp/T/9dIRz7fmrFK0BKi00upbk7A6c6bjs569w
 ctb2H1Saw3rHesyroNVxOehU92u5LrrJwvArIBN7v/RIk8CaT/bUbD84snMWpDdhHIUy
 BWtM50+k98VqbGaBT8MQznTEm/23uPCLcqfl6wQe8SSgrpa6FaBzhD3RtFPNfyzOmsKn
 T3l6638KizqO3GHFKd31rt4trOeBAA8QYf3AI7C79elGpwMygZEMvMvtXZdQ6HaeyuPk sA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32brgr05gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:35:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4XlM0169328
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32brw1w7cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:57 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06I4Xu42003184
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:56 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 21:33:56 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 21/26] xfsprogs: Simplify xfs_attr_leaf_addname
Date:   Fri, 17 Jul 2020 21:33:37 -0700
Message-Id: <20200718043342.6432-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200718043342.6432-1-allison.henderson@oracle.com>
References: <20200718043342.6432-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Invert the rename logic in xfs_attr_leaf_addname to simplify the
delayed attr logic later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr.c | 107 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 55 insertions(+), 52 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index f8100b8..0cf48ed 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -695,68 +695,71 @@ xfs_attr_leaf_addname(
 			return error;
 	}
 
-	/*
-	 * If this is an atomic rename operation, we must "flip" the
-	 * incomplete flags on the "new" and "old" attribute/value pairs
-	 * so that one disappears and one appears atomically.  Then we
-	 * must remove the "old" attribute/value pair.
-	 */
-	if (args->op_flags & XFS_DA_OP_RENAME) {
+	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
 		/*
-		 * In a separate transaction, set the incomplete flag on the
-		 * "old" attr and clear the incomplete flag on the "new" attr.
-		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			return error;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
+		 * Added a "remote" value, just clear the incomplete flag.
 		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			return error;
+		if (args->rmtblkno > 0)
+			error = xfs_attr3_leaf_clearflag(args);
 
-		/*
-		 * Dismantle the "old" attribute/value pair by removing
-		 * a "remote" value (if it exists).
-		 */
-		xfs_attr_restore_rmt_blk(args);
+		return error;
+	}
 
-		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_invalidate(args);
-			if (error)
-				return error;
+	/*
+	 * If this is an atomic rename operation, we must "flip" the incomplete
+	 * flags on the "new" and "old" attribute/value pairs so that one
+	 * disappears and one appears atomically.  Then we must remove the "old"
+	 * attribute/value pair.
+	 *
+	 * In a separate transaction, set the incomplete flag on the "old" attr
+	 * and clear the incomplete flag on the "new" attr.
+	 */
 
-			error = xfs_attr_rmtval_remove(args);
-			if (error)
-				return error;
-		}
+	error = xfs_attr3_leaf_flipflags(args);
+	if (error)
+		return error;
+	/*
+	 * Commit the flag value change and start the next trans in series.
+	 */
+	error = xfs_trans_roll_inode(&args->trans, args->dp);
+	if (error)
+		return error;
 
-		/*
-		 * Read in the block containing the "old" attr, then
-		 * remove the "old" attr from that block (neat, huh!)
-		 */
-		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
-					   &bp);
+	/*
+	 * Dismantle the "old" attribute/value pair by removing a "remote" value
+	 * (if it exists).
+	 */
+	xfs_attr_restore_rmt_blk(args);
+
+	if (args->rmtblkno) {
+		error = xfs_attr_rmtval_invalidate(args);
 		if (error)
 			return error;
 
-		xfs_attr3_leaf_remove(bp, args);
-
-		/*
-		 * If the result is small enough, shrink it all into the inode.
-		 */
-		forkoff = xfs_attr_shortform_allfit(bp, dp);
-		if (forkoff)
-			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
-			/* bp is gone due to xfs_da_shrink_inode */
-	} else if (args->rmtblkno > 0) {
-		/*
-		 * Added a "remote" value, just clear the incomplete flag.
-		 */
-		error = xfs_attr3_leaf_clearflag(args);
+		error = xfs_attr_rmtval_remove(args);
+		if (error)
+			return error;
 	}
+
+	/*
+	 * Read in the block containing the "old" attr, then remove the "old"
+	 * attr from that block (neat, huh!)
+	 */
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+				   &bp);
+	if (error)
+		return error;
+
+	xfs_attr3_leaf_remove(bp, args);
+
+	/*
+	 * If the result is small enough, shrink it all into the inode.
+	 */
+	forkoff = xfs_attr_shortform_allfit(bp, dp);
+	if (forkoff)
+		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+		/* bp is gone due to xfs_da_shrink_inode */
+
 	return error;
 }
 
-- 
2.7.4


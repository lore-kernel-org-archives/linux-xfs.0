Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2B7C433EA
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D21D2089D
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YSoJetVv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgFYX3o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:29:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53290 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732145AbgFYX3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:29:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSMjE038982
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=6wDRmDGVNOY4KKvhFohIQJe4UDJc48KAqo7/PmNAt2s=;
 b=YSoJetVv7P+X57r7WaxttSf0NQJhmEZ/jO4z2hqt0IatxnfGh/ER+DkU+Cn5a1jlhBBA
 ycyupEC7On5TRwOhdPgIE9aZ9ig/2ZFO/VyIUbMdNxasGmtCvQUMVN2qGjW5H1/NH7QC
 iI4EtIIiwM6p4Yr+EvTSRLuUONmcX92AHqAxbWz1QTQD3nH232mNHoqPYbyV/bmkgqXJ
 Fh4K0OPIX63oW0E2EM1WdWChZCpQ1rcXbFJXowe9f9jrObIuGWha3NHdsLtJ3SCek5Tr
 IyNT1a39q5goIxogloDtUk2/+qEISEbCJVgHSOZfh++AzsYWGrGtdqdsb7mFbeTYJA3k lA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31uut5u9tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSIjJ117320
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31uuram150-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:07 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05PNT63f016795
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:06 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:29:06 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 21/26] xfsprogs: Simplify xfs_attr_leaf_addname
Date:   Thu, 25 Jun 2020 16:28:43 -0700
Message-Id: <20200625232848.14465-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625232848.14465-1-allison.henderson@oracle.com>
References: <20200625232848.14465-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=1
 phishscore=0 impostorscore=0 cotscore=-2147483648 priorityscore=1501
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250136
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


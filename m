Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53BBFC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 318B72081A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:32:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="trk4/r83"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgFYXcv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:32:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53372 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgFYXcu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:32:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSWXa012439
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:32:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=xot8efOUoQ6pLHmJNTTf9PdiPFeM0UUl/A20FYsUqWc=;
 b=trk4/r83okMpFLIyoSUDKY8gQxvpP6srQzZpd5oAG3uekZVw/upmScde+t4TfcFnApVs
 ADKhLd8+QuclUIM0mmTq7VBhzU0pFKEg7UgqkavepXzN+M94JKSPRocKDsJkmUMEt5IG
 FDLXudTImrW5z6d4N2l6KfR7WcdLmURnUQwXFEL7w7DTmppFiSzpSwwzQTnwFET7tEKo
 MOhSekrpadcXfaYsrPbWnMOR2v88SHMxtIEgv5JkbFDp9WlzXz+x7k/ZA3d8Kf6ADFhm
 7bZcg9J5zoS08HQx/xEh2DMNK1tj2UOrFHaevBlnuF0pirCJIMs3/vLOxIPWBD2as/3X Eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31uustu9et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:32:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSIL0110933
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31uur9r6ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PNUm9g008524
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:48 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:30:48 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 20/25] xfs: Simplify xfs_attr_leaf_addname
Date:   Thu, 25 Jun 2020 16:30:13 -0700
Message-Id: <20200625233018.14585-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625233018.14585-1-allison.henderson@oracle.com>
References: <20200625233018.14585-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
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

Invert the rename logic in xfs_attr_leaf_addname to simplify the
delayed attr logic later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 107 ++++++++++++++++++++++++-----------------------
 1 file changed, 55 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f993af5..ca1e851 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
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


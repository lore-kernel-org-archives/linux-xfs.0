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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99DEEC433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A3C62087C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AIwTldU7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgH0A3U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:29:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54138 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgH0A3U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:29:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0Do21045155
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=y9gjkHS94Nt+KjIt7iPHyi0y3Rc7KRSa23fgK7rQ0Cw=;
 b=AIwTldU7uFbSXa/eQJUBw5dvKgsLatqe4ziqsdlNDBuw3jn0nWRQtL1Diy23DJZvcgFI
 3mIs+bQuad8mINSfIHHK5hi6jH6uk0uOJj2Gk9Zbn4wODC1GgS9GKuqH0dnYSKzRVmjP
 vE8VVj1YSi9Q6Tz2RpKHx0HKlKbXGGSj09w8U2XwNJAcazm37CmY+MCvv3svYNBo5tI+
 doS1pa9D/T3ZNMsZJE4ZcmrL9HKj01t5uc3QMCRciUlyDMTRY0hyZDqK4iaNj09N/6uw
 A6dWj1ujTI7+3AkqQsgeF045WAvwrvuuWx5iFupdkwkyStRguZEZIQJ+J9h6pOaq0VzE bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 333dbs3dx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0AqMH025881
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 333r9mswvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:18 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07R0TGeM019331
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:17 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:29:16 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 21/32] xfsprogs: Simplify xfs_attr_node_addname
Date:   Wed, 26 Aug 2020 17:28:45 -0700
Message-Id: <20200827002856.1131-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827002856.1131-1-allison.henderson@oracle.com>
References: <20200827002856.1131-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Invert the rename logic in xfs_attr_node_addname to simplify the
delayed attr logic later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr.c | 125 ++++++++++++++++++++++++++----------------------------
 1 file changed, 61 insertions(+), 64 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index b4ad0eb..592ba30 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1030,80 +1030,77 @@ restart:
 			return error;
 	}
 
-	/*
-	 * If this is an atomic rename operation, we must "flip" the
-	 * incomplete flags on the "new" and "old" attribute/value pairs
-	 * so that one disappears and one appears atomically.  Then we
-	 * must remove the "old" attribute/value pair.
-	 */
-	if (args->op_flags & XFS_DA_OP_RENAME) {
-		/*
-		 * In a separate transaction, set the incomplete flag on the
-		 * "old" attr and clear the incomplete flag on the "new" attr.
-		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			goto out;
+	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
 		/*
-		 * Commit the flag value change and start the next trans in
-		 * series
+		 * Added a "remote" value, just clear the incomplete flag.
 		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			goto out;
+		if (args->rmtblkno > 0)
+			error = xfs_attr3_leaf_clearflag(args);
+		retval = error;
+		goto out;
+	}
 
-		/*
-		 * Dismantle the "old" attribute/value pair by removing
-		 * a "remote" value (if it exists).
-		 */
-		xfs_attr_restore_rmt_blk(args);
+	/*
+	 * If this is an atomic rename operation, we must "flip" the incomplete
+	 * flags on the "new" and "old" attribute/value pairs so that one
+	 * disappears and one appears atomically.  Then we must remove the "old"
+	 * attribute/value pair.
+	 *
+	 * In a separate transaction, set the incomplete flag on the "old" attr
+	 * and clear the incomplete flag on the "new" attr.
+	 */
+	error = xfs_attr3_leaf_flipflags(args);
+	if (error)
+		goto out;
+	/*
+	 * Commit the flag value change and start the next trans in series
+	 */
+	error = xfs_trans_roll_inode(&args->trans, args->dp);
+	if (error)
+		goto out;
 
-		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_invalidate(args);
-			if (error)
-				return error;
+	/*
+	 * Dismantle the "old" attribute/value pair by removing a "remote" value
+	 * (if it exists).
+	 */
+	xfs_attr_restore_rmt_blk(args);
 
-			error = xfs_attr_rmtval_remove(args);
-			if (error)
-				return error;
-		}
+	if (args->rmtblkno) {
+		error = xfs_attr_rmtval_invalidate(args);
+		if (error)
+			return error;
 
-		/*
-		 * Re-find the "old" attribute entry after any split ops.
-		 * The INCOMPLETE flag means that we will find the "old"
-		 * attr, not the "new" one.
-		 */
-		args->attr_filter |= XFS_ATTR_INCOMPLETE;
-		state = xfs_da_state_alloc();
-		state->args = args;
-		state->mp = mp;
-		state->inleaf = 0;
-		error = xfs_da3_node_lookup_int(state, &retval);
+		error = xfs_attr_rmtval_remove(args);
 		if (error)
-			goto out;
+			return error;
+	}
 
-		/*
-		 * Remove the name and update the hashvals in the tree.
-		 */
-		blk = &state->path.blk[ state->path.active-1 ];
-		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-		error = xfs_attr3_leaf_remove(blk->bp, args);
-		xfs_da3_fixhashpath(state, &state->path);
+	/*
+	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
+	 * flag means that we will find the "old" attr, not the "new" one.
+	 */
+	args->attr_filter |= XFS_ATTR_INCOMPLETE;
+	state = xfs_da_state_alloc();
+	state->args = args;
+	state->mp = mp;
+	state->inleaf = 0;
+	error = xfs_da3_node_lookup_int(state, &retval);
+	if (error)
+		goto out;
 
-		/*
-		 * Check to see if the tree needs to be collapsed.
-		 */
-		if (retval && (state->path.active > 1)) {
-			error = xfs_da3_join(state);
-			if (error)
-				goto out;
-		}
+	/*
+	 * Remove the name and update the hashvals in the tree.
+	 */
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	error = xfs_attr3_leaf_remove(blk->bp, args);
+	xfs_da3_fixhashpath(state, &state->path);
 
-	} else if (args->rmtblkno > 0) {
-		/*
-		 * Added a "remote" value, just clear the incomplete flag.
-		 */
-		error = xfs_attr3_leaf_clearflag(args);
+	/*
+	 * Check to see if the tree needs to be collapsed.
+	 */
+	if (retval && (state->path.active > 1)) {
+		error = xfs_da3_join(state);
 		if (error)
 			goto out;
 	}
-- 
2.7.4


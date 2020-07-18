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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F32CC433F4
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E779207FB
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nj39s8pf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgGREeA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jul 2020 00:34:00 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59570 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgGREd7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jul 2020 00:33:59 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4W1s3051663
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=tzVni6vCXrbdYOArdDFNSqzFxoZc20260j5Fd+XinwI=;
 b=Nj39s8pfFgs+8te/Yze0TDd+CvfuWkZE/681fBZ6vSNfHdoCPXtVgH3IYI+6rHlmWql5
 L0EEQHAiMzBvz9l0VIkO5V63mnCiwNJ+NjHFDQBcuLCy5dhpBTSOpoaaKTrMFJ61YAEo
 g/IZ+TzDKR+S6Nayg0tq+8aHUm9gdWHptyEcCkZ/4VWCTESvgFYGyfDO7+ObI2RKImv6
 MUxJmnIQlZsoRMByUXwYhuk7Myd9Yyfd1jFtBpCSeyVrSYQHC2V7QafrCUm7MgD3FdT3
 1mHY5tp2of0ziK9APhJ7paDz21XUtzlSuMCsEQxTbDC0iYxkgdWdSIfZcPwfKs+QUh1S 1g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 32bpkarbjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4XnI8058277
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32br1n3nha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:58 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06I4XvHG008275
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:57 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 21:33:56 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 22/26] xfsprogs: Simplify xfs_attr_node_addname
Date:   Fri, 17 Jul 2020 21:33:38 -0700
Message-Id: <20200718043342.6432-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200718043342.6432-1-allison.henderson@oracle.com>
References: <20200718043342.6432-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 suspectscore=1 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007180030
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
index 0cf48ed..6ff064d 100644
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


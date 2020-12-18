Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B19C3526B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B634123A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732889AbgLRHaI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:30:08 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36436 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732892AbgLRHaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:30:07 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7JmRR000772
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Zi/4xEBuKJbAIUtPr6KayjWVkGZIxNPS9U7BJBcQKjU=;
 b=0eGNYRF4Cqs0Jm9daG8QwwS+I4GloTSJ/e+2ATUyl41DMeI8RycmU0Xh+hzxRWWZTF2a
 cMJBlb/PmxH5C/uiNzqm130YFKvzkWL0k+F7CiLs71QWjX1QfpeyxZccbPwlWo85Dy2Y
 BWM/pYb5dM2uMsWCuxgH3dQ0cohGUNi4tLowpo33zfY4Ig+jJxWx9phPxuShMcxP4aUg
 wydJk3mXJrZ0llTeKizEfJOLlxqUcK74f/qOZ5cuD4JWP4dm5X2aeCrFWeZ4BtW4NNKO
 T1dv/5ntT8rIPjeQRqARjptelHRCaJcgpTuK5JLvaxlEfXBJRxSPadFV2DSFd16UXUH/ kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35ckcbs6q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7LJN3119493
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35g3rft615-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:25 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BI7TPHx020751
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:25 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:29:24 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 10/15] xfs: Skip flip flags for delayed attrs
Date:   Fri, 18 Dec 2020 00:29:12 -0700
Message-Id: <20201218072917.16805-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218072917.16805-1-allison.henderson@oracle.com>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180052
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a clean up patch that skips the flip flag logic for delayed attr
renames.  Since the log replay keeps the inode locked, we do not need to
worry about race windows with attr lookups.  So we can skip over
flipping the flag and the extra transaction roll for it

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 43 ++++++++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_attr_leaf.c |  3 ++-
 2 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d108866..99f6539 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -805,6 +805,7 @@ xfs_attr_leaf_addname(
 	struct xfs_buf			*bp = NULL;
 	int				error, forkoff;
 	struct xfs_inode		*dp = args->dp;
+	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
 	switch (dac->dela_state) {
@@ -870,15 +871,17 @@ xfs_attr_leaf_addname(
 	 * In a separate transaction, set the incomplete flag on the "old" attr
 	 * and clear the incomplete flag on the "new" attr.
 	 */
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		return error;
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	dac->dela_state = XFS_DAS_FLIP_LFLAG;
-	trace_xfs_das_state_return(dac->dela_state);
-	return -EAGAIN;
+	if (!xfs_hasdelattr(mp)) {
+		error = xfs_attr3_leaf_flipflags(args);
+		if (error)
+			return error;
+		/*
+		 * Commit the flag value change and start the next trans in series.
+		 */
+		dac->dela_state = XFS_DAS_FLIP_LFLAG;
+		trace_xfs_das_state_return(dac->dela_state);
+		return -EAGAIN;
+	}
 das_flip_flag:
 	/*
 	 * Dismantle the "old" attribute/value pair by removing a "remote" value
@@ -1077,6 +1080,7 @@ xfs_attr_node_addname(
 	struct xfs_da_state_blk		*blk;
 	int				retval = 0;
 	int				error = 0;
+	struct xfs_mount		*mp = args->dp->i_mount;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -1238,15 +1242,17 @@ xfs_attr_node_addname(
 	 * In a separate transaction, set the incomplete flag on the "old" attr
 	 * and clear the incomplete flag on the "new" attr.
 	 */
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		goto out;
-	/*
-	 * Commit the flag value change and start the next trans in series
-	 */
-	dac->dela_state = XFS_DAS_FLIP_NFLAG;
-	trace_xfs_das_state_return(dac->dela_state);
-	return -EAGAIN;
+	if (!xfs_hasdelattr(mp)) {
+		error = xfs_attr3_leaf_flipflags(args);
+		if (error)
+			goto out;
+		/*
+		 * Commit the flag value change and start the next trans in series
+		 */
+		dac->dela_state = XFS_DAS_FLIP_NFLAG;
+		trace_xfs_das_state_return(dac->dela_state);
+		return -EAGAIN;
+	}
 das_flip_flag:
 	/*
 	 * Dismantle the "old" attribute/value pair by removing a "remote" value
@@ -1275,7 +1281,6 @@ xfs_attr_node_addname(
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
 	 */
-	args->attr_filter |= XFS_ATTR_INCOMPLETE;
 	state = xfs_da_state_alloc(args);
 	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 3780141..ec707bd 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1486,7 +1486,8 @@ xfs_attr3_leaf_add_work(
 	if (tmp)
 		entry->flags |= XFS_ATTR_LOCAL;
 	if (args->op_flags & XFS_DA_OP_RENAME) {
-		entry->flags |= XFS_ATTR_INCOMPLETE;
+		if (!xfs_hasdelattr(mp))
+			entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
 		    (args->index2 <= args->index)) {
 			args->index2++;
-- 
2.7.4


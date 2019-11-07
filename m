Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52606FA372C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 079AA21929
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:29:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fxdq54eV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfKGB34 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:29:56 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38332 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732849AbfKGB3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:29:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SsIR180066
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=/rMgmXfuZRhpqkfiItkNsJnkcgdRj9++rShKNFB3Flw=;
 b=fxdq54eVfV8d3UcdHJZq01EFv4zqBymbSgN2GUTujGt5X7uklirJxyo9WUDShm8mJajq
 lhguyb66wsJRSExcWawH7npukn8ask8sRV85Rs6BmA9xG+iXKT5YcR4k2iQ1kIcXWSP2
 0YFG/ZlbEkofv7g3a+H4gkAKYpO+9QU2mj5gXjVnAhAeqOECCOa1E7IEiid8mRozwOTl
 Y1tADhrB8IG4lmF/VospGrmQrbIIdXLlXvBlcodnfrR7RxAggUkZ3V0YG0HWUtcu0Cue
 1Zd8SVkPcAhjLeu9MpRBwBTDDfsvXgdzIuexoTRCC9EiZ4bEMI93Deh8D+Wi/rOwcnhF NQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w41w12pxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SkxR088063
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w41wfeeym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:52 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA71TpRO032443
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:52 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:29:51 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 04/17] xfsprogs: Add xfs_dabuf defines
Date:   Wed,  6 Nov 2019 18:29:32 -0700
Message-Id: <20191107012945.22941-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107012945.22941-1-allison.henderson@oracle.com>
References: <20191107012945.22941-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds two new defines XFS_DABUF_MAP_NOMAPPING and
XFS_DABUF_MAP_HOLE_OK.  This helps to clean up hard numbers and
makes the code easier to read

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c       | 14 +++++++++-----
 libxfs/xfs_attr_leaf.c  | 23 ++++++++++++++---------
 libxfs/xfs_attr_leaf.h  |  3 +++
 libxfs/xfs_da_btree.c   | 50 ++++++++++++++++++++++++++++++++-----------------
 libxfs/xfs_dir2_block.c |  6 ++++--
 libxfs/xfs_dir2_data.c  |  3 ++-
 libxfs/xfs_dir2_leaf.c  |  9 ++++++---
 libxfs/xfs_dir2_node.c  | 10 ++++++----
 8 files changed, 77 insertions(+), 41 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 09c9b31..3c5e7cb 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -557,7 +557,8 @@ xfs_attr_leaf_addname(
 	 */
 	dp = args->dp;
 	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+				    XFS_DABUF_MAP_NOMAPPING, &bp);
 	if (error)
 		return error;
 
@@ -683,7 +684,7 @@ xfs_attr_leaf_addname(
 		 * remove the "old" attr from that block (neat, huh!)
 		 */
 		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
-					   -1, &bp);
+					   XFS_DABUF_MAP_NOMAPPING, &bp);
 		if (error)
 			return error;
 
@@ -737,7 +738,8 @@ xfs_attr_leaf_removename(
 	 */
 	dp = args->dp;
 	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+				    XFS_DABUF_MAP_NOMAPPING, &bp);
 	if (error)
 		return error;
 
@@ -779,7 +781,8 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 	trace_xfs_attr_leaf_get(args);
 
 	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+				    XFS_DABUF_MAP_NOMAPPING, &bp);
 	if (error)
 		return error;
 
@@ -1143,7 +1146,8 @@ xfs_attr_node_removename(
 		ASSERT(state->path.blk[0].bp);
 		state->path.blk[0].bp = NULL;
 
-		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, -1, &bp);
+		error = xfs_attr3_leaf_read(args->trans, args->dp, 0,
+					    XFS_DABUF_MAP_NOMAPPING, &bp);
 		if (error)
 			goto out;
 
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index b8136ed..a5c4c73 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1068,11 +1068,13 @@ xfs_attr3_leaf_to_node(
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
-	error = xfs_attr3_leaf_read(args->trans, dp, 0, -1, &bp1);
+	error = xfs_attr3_leaf_read(args->trans, dp, 0, XFS_DABUF_MAP_NOMAPPING,
+				    &bp1);
 	if (error)
 		goto out;
 
-	error = xfs_da_get_buf(args->trans, dp, blkno, -1, &bp2, XFS_ATTR_FORK);
+	error = xfs_da_get_buf(args->trans, dp, blkno, XFS_DABUF_MAP_NOMAPPING,
+			       &bp2, XFS_ATTR_FORK);
 	if (error)
 		goto out;
 
@@ -1134,8 +1136,8 @@ xfs_attr3_leaf_create(
 
 	trace_xfs_attr_leaf_create(args);
 
-	error = xfs_da_get_buf(args->trans, args->dp, blkno, -1, &bp,
-					    XFS_ATTR_FORK);
+	error = xfs_da_get_buf(args->trans, args->dp, blkno,
+			       XFS_DABUF_MAP_NOMAPPING, &bp, XFS_ATTR_FORK);
 	if (error)
 		return error;
 	bp->b_ops = &xfs_attr3_leaf_buf_ops;
@@ -1905,7 +1907,7 @@ xfs_attr3_leaf_toosmall(
 		if (blkno == 0)
 			continue;
 		error = xfs_attr3_leaf_read(state->args->trans, state->args->dp,
-					blkno, -1, &bp);
+					blkno, XFS_DABUF_MAP_NOMAPPING, &bp);
 		if (error)
 			return error;
 
@@ -2654,7 +2656,8 @@ xfs_attr3_leaf_clearflag(
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+				    XFS_DABUF_MAP_NOMAPPING, &bp);
 	if (error)
 		return error;
 
@@ -2721,7 +2724,8 @@ xfs_attr3_leaf_setflag(
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+				    XFS_DABUF_MAP_NOMAPPING, &bp);
 	if (error)
 		return error;
 
@@ -2783,7 +2787,8 @@ xfs_attr3_leaf_flipflags(
 	/*
 	 * Read the block containing the "old" attr
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp1);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+				    XFS_DABUF_MAP_NOMAPPING, &bp1);
 	if (error)
 		return error;
 
@@ -2792,7 +2797,7 @@ xfs_attr3_leaf_flipflags(
 	 */
 	if (args->blkno2 != args->blkno) {
 		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno2,
-					   -1, &bp2);
+					    XFS_DABUF_MAP_NOMAPPING, &bp2);
 		if (error)
 			return error;
 	} else {
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 7b74e18..536a290 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -16,6 +16,9 @@ struct xfs_da_state_blk;
 struct xfs_inode;
 struct xfs_trans;
 
+#define XFS_DABUF_MAP_NOMAPPING	(-1) /* Caller doesn't have a mapping. */
+#define XFS_DABUF_MAP_HOLE_OK	(-2) /* don't complain if we land in a hole. */
+
 /*
  * Used to keep a list of "remote value" extents when unlinking an inode.
  */
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index f8e0432..7fb44f7 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -340,7 +340,8 @@ xfs_da3_node_create(
 	trace_xfs_da_node_create(args);
 	ASSERT(level <= XFS_DA_NODE_MAXDEPTH);
 
-	error = xfs_da_get_buf(tp, dp, blkno, -1, &bp, whichfork);
+	error = xfs_da_get_buf(tp, dp, blkno, XFS_DABUF_MAP_NOMAPPING, &bp,
+			       whichfork);
 	if (error)
 		return error;
 	bp->b_ops = &xfs_da3_node_buf_ops;
@@ -565,7 +566,8 @@ xfs_da3_root_split(
 
 	dp = args->dp;
 	tp = args->trans;
-	error = xfs_da_get_buf(tp, dp, blkno, -1, &bp, args->whichfork);
+	error = xfs_da_get_buf(tp, dp, blkno, XFS_DABUF_MAP_NOMAPPING, &bp,
+			       args->whichfork);
 	if (error)
 		return error;
 	node = bp->b_addr;
@@ -1106,8 +1108,9 @@ xfs_da3_root_join(
 	btree = dp->d_ops->node_tree_p(oldroot);
 	child = be32_to_cpu(btree[0].before);
 	ASSERT(child != 0);
-	error = xfs_da3_node_read(args->trans, dp, child, -1, &bp,
-					     args->whichfork);
+	error = xfs_da3_node_read(args->trans, dp, child,
+				  XFS_DABUF_MAP_NOMAPPING, &bp,
+				  args->whichfork);
 	if (error)
 		return error;
 	xfs_da_blkinfo_onlychild_validate(bp->b_addr, oldroothdr.level);
@@ -1222,7 +1225,8 @@ xfs_da3_node_toosmall(
 		if (blkno == 0)
 			continue;
 		error = xfs_da3_node_read(state->args->trans, dp,
-					blkno, -1, &bp, state->args->whichfork);
+					blkno, XFS_DABUF_MAP_NOMAPPING, &bp,
+					state->args->whichfork);
 		if (error)
 			return error;
 
@@ -1514,7 +1518,8 @@ xfs_da3_node_lookup_int(
 		 */
 		blk->blkno = blkno;
 		error = xfs_da3_node_read(args->trans, args->dp, blkno,
-					-1, &blk->bp, args->whichfork);
+					XFS_DABUF_MAP_NOMAPPING, &blk->bp,
+					args->whichfork);
 		if (error) {
 			blk->blkno = 0;
 			state->path.active--;
@@ -1743,7 +1748,8 @@ xfs_da3_blk_link(
 		if (old_info->back) {
 			error = xfs_da3_node_read(args->trans, dp,
 						be32_to_cpu(old_info->back),
-						-1, &bp, args->whichfork);
+						XFS_DABUF_MAP_NOMAPPING, &bp,
+						args->whichfork);
 			if (error)
 				return error;
 			ASSERT(bp != NULL);
@@ -1764,7 +1770,8 @@ xfs_da3_blk_link(
 		if (old_info->forw) {
 			error = xfs_da3_node_read(args->trans, dp,
 						be32_to_cpu(old_info->forw),
-						-1, &bp, args->whichfork);
+						XFS_DABUF_MAP_NOMAPPING, &bp,
+						args->whichfork);
 			if (error)
 				return error;
 			ASSERT(bp != NULL);
@@ -1823,7 +1830,8 @@ xfs_da3_blk_unlink(
 		if (drop_info->back) {
 			error = xfs_da3_node_read(args->trans, args->dp,
 						be32_to_cpu(drop_info->back),
-						-1, &bp, args->whichfork);
+						XFS_DABUF_MAP_NOMAPPING, &bp,
+						args->whichfork);
 			if (error)
 				return error;
 			ASSERT(bp != NULL);
@@ -1840,7 +1848,8 @@ xfs_da3_blk_unlink(
 		if (drop_info->forw) {
 			error = xfs_da3_node_read(args->trans, args->dp,
 						be32_to_cpu(drop_info->forw),
-						-1, &bp, args->whichfork);
+						XFS_DABUF_MAP_NOMAPPING, &bp,
+						args->whichfork);
 			if (error)
 				return error;
 			ASSERT(bp != NULL);
@@ -1926,7 +1935,8 @@ xfs_da3_path_shift(
 		/*
 		 * Read the next child block into a local buffer.
 		 */
-		error = xfs_da3_node_read(args->trans, dp, blkno, -1, &bp,
+		error = xfs_da3_node_read(args->trans, dp, blkno,
+					  XFS_DABUF_MAP_NOMAPPING, &bp,
 					  args->whichfork);
 		if (error)
 			return error;
@@ -2220,7 +2230,8 @@ xfs_da3_swap_lastblock(
 	 * Read the last block in the btree space.
 	 */
 	last_blkno = (xfs_dablk_t)lastoff - args->geo->fsbcount;
-	error = xfs_da3_node_read(tp, dp, last_blkno, -1, &last_buf, w);
+	error = xfs_da3_node_read(tp, dp, last_blkno, XFS_DABUF_MAP_NOMAPPING,
+				  &last_buf, w);
 	if (error)
 		return error;
 	/*
@@ -2256,7 +2267,8 @@ xfs_da3_swap_lastblock(
 	 * If the moved block has a left sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->back))) {
-		error = xfs_da3_node_read(tp, dp, sib_blkno, -1, &sib_buf, w);
+		error = xfs_da3_node_read(tp, dp, sib_blkno,
+					  XFS_DABUF_MAP_NOMAPPING, &sib_buf, w);
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
@@ -2278,7 +2290,8 @@ xfs_da3_swap_lastblock(
 	 * If the moved block has a right sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->forw))) {
-		error = xfs_da3_node_read(tp, dp, sib_blkno, -1, &sib_buf, w);
+		error = xfs_da3_node_read(tp, dp, sib_blkno,
+					  XFS_DABUF_MAP_NOMAPPING, &sib_buf, w);
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
@@ -2302,7 +2315,8 @@ xfs_da3_swap_lastblock(
 	 * Walk down the tree looking for the parent of the moved block.
 	 */
 	for (;;) {
-		error = xfs_da3_node_read(tp, dp, par_blkno, -1, &par_buf, w);
+		error = xfs_da3_node_read(tp, dp, par_blkno,
+					  XFS_DABUF_MAP_NOMAPPING, &par_buf, w);
 		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
@@ -2353,7 +2367,8 @@ xfs_da3_swap_lastblock(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		error = xfs_da3_node_read(tp, dp, par_blkno, -1, &par_buf, w);
+		error = xfs_da3_node_read(tp, dp, par_blkno,
+					  XFS_DABUF_MAP_NOMAPPING, &par_buf, w);
 		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
@@ -2531,7 +2546,8 @@ xfs_dabuf_map(
 	 * Caller doesn't have a mapping.  -2 means don't complain
 	 * if we land in a hole.
 	 */
-	if (mappedbno == -1 || mappedbno == -2) {
+	if (mappedbno == XFS_DABUF_MAP_NOMAPPING ||
+	    mappedbno == XFS_DABUF_MAP_HOLE_OK) {
 		/*
 		 * Optimize the one-block case.
 		 */
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 048fce7..e175e3e 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -17,6 +17,7 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
+#include "xfs_attr_leaf.h"
 
 /*
  * Local function prototypes.
@@ -120,8 +121,9 @@ xfs_dir3_block_read(
 	struct xfs_mount	*mp = dp->i_mount;
 	int			err;
 
-	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, -1, bpp,
-				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
+	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk,
+			      XFS_DABUF_MAP_NOMAPPING, bpp, XFS_DATA_FORK,
+			      &xfs_dir3_block_buf_ops);
 	if (!err && tp && *bpp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
 	return err;
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 68da426..59c9233 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -14,6 +14,7 @@
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_trans.h"
+#include "xfs_attr_leaf.h"
 
 static xfs_failaddr_t xfs_dir2_data_freefind_verify(
 		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
@@ -650,7 +651,7 @@ xfs_dir3_data_init(
 	 * Get the buffer set up for the block.
 	 */
 	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, blkno),
-			       -1, &bp, XFS_DATA_FORK);
+			       XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
 	if (error)
 		return error;
 	bp->b_ops = &xfs_dir3_data_buf_ops;
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 6bf063c..2d99928 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -17,6 +17,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_attr_leaf.h"
 
 /*
  * Local function declarations.
@@ -309,7 +310,7 @@ xfs_dir3_leaf_get_buf(
 	       bno < xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET));
 
 	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, bno),
-			       -1, &bp, XFS_DATA_FORK);
+			       XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
 	if (error)
 		return error;
 
@@ -592,7 +593,8 @@ xfs_dir2_leaf_addname(
 
 	trace_xfs_dir2_leaf_addname(args);
 
-	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk,
+				   XFS_DABUF_MAP_NOMAPPING, &lbp);
 	if (error)
 		return error;
 
@@ -1187,7 +1189,8 @@ xfs_dir2_leaf_lookup_int(
 	tp = args->trans;
 	mp = dp->i_mount;
 
-	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk,
+				   XFS_DABUF_MAP_NOMAPPING, &lbp);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index f644495..32d8729 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -17,6 +17,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_attr_leaf.h"
 
 /*
  * Function declarations.
@@ -226,7 +227,7 @@ xfs_dir2_free_read(
 	xfs_dablk_t		fbno,
 	struct xfs_buf		**bpp)
 {
-	return __xfs_dir3_free_read(tp, dp, fbno, -1, bpp);
+	return __xfs_dir3_free_read(tp, dp, fbno, XFS_DABUF_MAP_NOMAPPING, bpp);
 }
 
 static int
@@ -236,7 +237,7 @@ xfs_dir2_free_try_read(
 	xfs_dablk_t		fbno,
 	struct xfs_buf		**bpp)
 {
-	return __xfs_dir3_free_read(tp, dp, fbno, -2, bpp);
+	return __xfs_dir3_free_read(tp, dp, fbno, XFS_DABUF_MAP_HOLE_OK, bpp);
 }
 
 static int
@@ -253,7 +254,7 @@ xfs_dir3_free_get_buf(
 	struct xfs_dir3_icfree_hdr hdr;
 
 	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, fbno),
-				   -1, &bp, XFS_DATA_FORK);
+				   XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
 	if (error)
 		return error;
 
@@ -1494,7 +1495,8 @@ xfs_dir2_leafn_toosmall(
 		 * Read the sibling leaf block.
 		 */
 		error = xfs_dir3_leafn_read(state->args->trans, dp,
-					    blkno, -1, &bp);
+					    blkno, XFS_DABUF_MAP_NOMAPPING,
+					    &bp);
 		if (error)
 			return error;
 
-- 
2.7.4


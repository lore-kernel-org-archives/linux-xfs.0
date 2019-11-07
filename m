Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A486FC6194
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04948217D7
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:29:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q42F/NFQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732582AbfKGB3F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:29:05 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37510 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732423AbfKGB3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:29:05 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SrXj180055
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=HlG0o69SY9zxsJBU72c+/MKYjwHKrJf5nts55XVCK8A=;
 b=q42F/NFQzHAz1AIkUBGdI5bEzHoCBqLHj3D42OVh95OKUispnWo175V9fxuuzEu4mRBX
 Pn1gkwciwl64SqhQfwXWRTSxcrV6gw3SbqajMIYvfmTSL21oI2Dyne4PQAE0hGKIkRp2
 NrD5mHTPWcrIfA8Faphr4bH+wpBrMd473pJWLMizM70S/eMH4F4D/3d5E02wDO806soz
 2F2dWYXwaqO1hGlD3ABgFJED7a1P0hMX54EB7DHm62SUP0SHf1NBq0YgnqkPDFE7LFoF
 INPica0ouAPVGMo5oEXPT5D/RrggnEeEO7C/j77lQgG9V9SmSrwp4K7xh5i6ktltFGAh Gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w41w12pv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71Sxen008400
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w41wdmsw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:00 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA71Sknu015678
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:46 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:28:45 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 04/17] xfs: Add xfs_dabuf defines
Date:   Wed,  6 Nov 2019 18:27:48 -0700
Message-Id: <20191107012801.22863-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107012801.22863-1-allison.henderson@oracle.com>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
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
 fs/xfs/libxfs/xfs_attr.c       | 14 +++++++-----
 fs/xfs/libxfs/xfs_attr_leaf.c  | 23 +++++++++++--------
 fs/xfs/libxfs/xfs_attr_leaf.h  |  3 +++
 fs/xfs/libxfs/xfs_da_btree.c   | 50 ++++++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_dir2_block.c |  6 +++--
 fs/xfs/libxfs/xfs_dir2_data.c  |  3 ++-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  9 +++++---
 fs/xfs/libxfs/xfs_dir2_node.c  | 10 +++++----
 fs/xfs/scrub/dabtree.c         |  6 ++---
 fs/xfs/scrub/dir.c             |  4 +++-
 fs/xfs/xfs_attr_inactive.c     |  6 +++--
 fs/xfs/xfs_attr_list.c         | 16 +++++++++-----
 12 files changed, 97 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b77b985..5cb83a8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -591,7 +591,8 @@ xfs_attr_leaf_addname(
 	 */
 	dp = args->dp;
 	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+				    XFS_DABUF_MAP_NOMAPPING, &bp);
 	if (error)
 		return error;
 
@@ -717,7 +718,7 @@ xfs_attr_leaf_addname(
 		 * remove the "old" attr from that block (neat, huh!)
 		 */
 		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
-					   -1, &bp);
+					   XFS_DABUF_MAP_NOMAPPING, &bp);
 		if (error)
 			return error;
 
@@ -771,7 +772,8 @@ xfs_attr_leaf_removename(
 	 */
 	dp = args->dp;
 	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+				    XFS_DABUF_MAP_NOMAPPING, &bp);
 	if (error)
 		return error;
 
@@ -815,7 +817,8 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 	trace_xfs_attr_leaf_get(args);
 
 	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+				    XFS_DABUF_MAP_NOMAPPING, &bp);
 	if (error)
 		return error;
 
@@ -1175,7 +1178,8 @@ xfs_attr_node_removename(
 		ASSERT(state->path.blk[0].bp);
 		state->path.blk[0].bp = NULL;
 
-		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, -1, &bp);
+		error = xfs_attr3_leaf_read(args->trans, args->dp, 0,
+					    XFS_DABUF_MAP_NOMAPPING, &bp);
 		if (error)
 			goto out;
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index cf5de30..93c3496 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1160,11 +1160,13 @@ xfs_attr3_leaf_to_node(
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
 
@@ -1226,8 +1228,8 @@ xfs_attr3_leaf_create(
 
 	trace_xfs_attr_leaf_create(args);
 
-	error = xfs_da_get_buf(args->trans, args->dp, blkno, -1, &bp,
-					    XFS_ATTR_FORK);
+	error = xfs_da_get_buf(args->trans, args->dp, blkno,
+			       XFS_DABUF_MAP_NOMAPPING, &bp, XFS_ATTR_FORK);
 	if (error)
 		return error;
 	bp->b_ops = &xfs_attr3_leaf_buf_ops;
@@ -1997,7 +1999,7 @@ xfs_attr3_leaf_toosmall(
 		if (blkno == 0)
 			continue;
 		error = xfs_attr3_leaf_read(state->args->trans, state->args->dp,
-					blkno, -1, &bp);
+					blkno, XFS_DABUF_MAP_NOMAPPING, &bp);
 		if (error)
 			return error;
 
@@ -2730,7 +2732,8 @@ xfs_attr3_leaf_clearflag(
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+				    XFS_DABUF_MAP_NOMAPPING, &bp);
 	if (error)
 		return error;
 
@@ -2797,7 +2800,8 @@ xfs_attr3_leaf_setflag(
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+				    XFS_DABUF_MAP_NOMAPPING, &bp);
 	if (error)
 		return error;
 
@@ -2859,7 +2863,8 @@ xfs_attr3_leaf_flipflags(
 	/*
 	 * Read the block containing the "old" attr
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp1);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+				    XFS_DABUF_MAP_NOMAPPING, &bp1);
 	if (error)
 		return error;
 
@@ -2868,7 +2873,7 @@ xfs_attr3_leaf_flipflags(
 	 */
 	if (args->blkno2 != args->blkno) {
 		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno2,
-					   -1, &bp2);
+					    XFS_DABUF_MAP_NOMAPPING, &bp2);
 		if (error)
 			return error;
 	} else {
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index bb08800..017480e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -16,6 +16,9 @@ struct xfs_da_state_blk;
 struct xfs_inode;
 struct xfs_trans;
 
+#define XFS_DABUF_MAP_NOMAPPING	(-1) /* Caller doesn't have a mapping. */
+#define XFS_DABUF_MAP_HOLE_OK	(-2) /* don't complain if we land in a hole. */
+
 /*
  * Used to keep a list of "remote value" extents when unlinking an inode.
  */
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 129ec09..ba49ffc 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -343,7 +343,8 @@ xfs_da3_node_create(
 	trace_xfs_da_node_create(args);
 	ASSERT(level <= XFS_DA_NODE_MAXDEPTH);
 
-	error = xfs_da_get_buf(tp, dp, blkno, -1, &bp, whichfork);
+	error = xfs_da_get_buf(tp, dp, blkno, XFS_DABUF_MAP_NOMAPPING, &bp,
+			       whichfork);
 	if (error)
 		return error;
 	bp->b_ops = &xfs_da3_node_buf_ops;
@@ -568,7 +569,8 @@ xfs_da3_root_split(
 
 	dp = args->dp;
 	tp = args->trans;
-	error = xfs_da_get_buf(tp, dp, blkno, -1, &bp, args->whichfork);
+	error = xfs_da_get_buf(tp, dp, blkno, XFS_DABUF_MAP_NOMAPPING, &bp,
+			       args->whichfork);
 	if (error)
 		return error;
 	node = bp->b_addr;
@@ -1109,8 +1111,9 @@ xfs_da3_root_join(
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
@@ -1225,7 +1228,8 @@ xfs_da3_node_toosmall(
 		if (blkno == 0)
 			continue;
 		error = xfs_da3_node_read(state->args->trans, dp,
-					blkno, -1, &bp, state->args->whichfork);
+					blkno, XFS_DABUF_MAP_NOMAPPING, &bp,
+					state->args->whichfork);
 		if (error)
 			return error;
 
@@ -1517,7 +1521,8 @@ xfs_da3_node_lookup_int(
 		 */
 		blk->blkno = blkno;
 		error = xfs_da3_node_read(args->trans, args->dp, blkno,
-					-1, &blk->bp, args->whichfork);
+					XFS_DABUF_MAP_NOMAPPING, &blk->bp,
+					args->whichfork);
 		if (error) {
 			blk->blkno = 0;
 			state->path.active--;
@@ -1746,7 +1751,8 @@ xfs_da3_blk_link(
 		if (old_info->back) {
 			error = xfs_da3_node_read(args->trans, dp,
 						be32_to_cpu(old_info->back),
-						-1, &bp, args->whichfork);
+						XFS_DABUF_MAP_NOMAPPING, &bp,
+						args->whichfork);
 			if (error)
 				return error;
 			ASSERT(bp != NULL);
@@ -1767,7 +1773,8 @@ xfs_da3_blk_link(
 		if (old_info->forw) {
 			error = xfs_da3_node_read(args->trans, dp,
 						be32_to_cpu(old_info->forw),
-						-1, &bp, args->whichfork);
+						XFS_DABUF_MAP_NOMAPPING, &bp,
+						args->whichfork);
 			if (error)
 				return error;
 			ASSERT(bp != NULL);
@@ -1826,7 +1833,8 @@ xfs_da3_blk_unlink(
 		if (drop_info->back) {
 			error = xfs_da3_node_read(args->trans, args->dp,
 						be32_to_cpu(drop_info->back),
-						-1, &bp, args->whichfork);
+						XFS_DABUF_MAP_NOMAPPING, &bp,
+						args->whichfork);
 			if (error)
 				return error;
 			ASSERT(bp != NULL);
@@ -1843,7 +1851,8 @@ xfs_da3_blk_unlink(
 		if (drop_info->forw) {
 			error = xfs_da3_node_read(args->trans, args->dp,
 						be32_to_cpu(drop_info->forw),
-						-1, &bp, args->whichfork);
+						XFS_DABUF_MAP_NOMAPPING, &bp,
+						args->whichfork);
 			if (error)
 				return error;
 			ASSERT(bp != NULL);
@@ -1929,7 +1938,8 @@ xfs_da3_path_shift(
 		/*
 		 * Read the next child block into a local buffer.
 		 */
-		error = xfs_da3_node_read(args->trans, dp, blkno, -1, &bp,
+		error = xfs_da3_node_read(args->trans, dp, blkno,
+					  XFS_DABUF_MAP_NOMAPPING, &bp,
 					  args->whichfork);
 		if (error)
 			return error;
@@ -2223,7 +2233,8 @@ xfs_da3_swap_lastblock(
 	 * Read the last block in the btree space.
 	 */
 	last_blkno = (xfs_dablk_t)lastoff - args->geo->fsbcount;
-	error = xfs_da3_node_read(tp, dp, last_blkno, -1, &last_buf, w);
+	error = xfs_da3_node_read(tp, dp, last_blkno, XFS_DABUF_MAP_NOMAPPING,
+				  &last_buf, w);
 	if (error)
 		return error;
 	/*
@@ -2259,7 +2270,8 @@ xfs_da3_swap_lastblock(
 	 * If the moved block has a left sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->back))) {
-		error = xfs_da3_node_read(tp, dp, sib_blkno, -1, &sib_buf, w);
+		error = xfs_da3_node_read(tp, dp, sib_blkno,
+					  XFS_DABUF_MAP_NOMAPPING, &sib_buf, w);
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
@@ -2281,7 +2293,8 @@ xfs_da3_swap_lastblock(
 	 * If the moved block has a right sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->forw))) {
-		error = xfs_da3_node_read(tp, dp, sib_blkno, -1, &sib_buf, w);
+		error = xfs_da3_node_read(tp, dp, sib_blkno,
+					  XFS_DABUF_MAP_NOMAPPING, &sib_buf, w);
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
@@ -2305,7 +2318,8 @@ xfs_da3_swap_lastblock(
 	 * Walk down the tree looking for the parent of the moved block.
 	 */
 	for (;;) {
-		error = xfs_da3_node_read(tp, dp, par_blkno, -1, &par_buf, w);
+		error = xfs_da3_node_read(tp, dp, par_blkno,
+					  XFS_DABUF_MAP_NOMAPPING, &par_buf, w);
 		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
@@ -2356,7 +2370,8 @@ xfs_da3_swap_lastblock(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		error = xfs_da3_node_read(tp, dp, par_blkno, -1, &par_buf, w);
+		error = xfs_da3_node_read(tp, dp, par_blkno,
+					  XFS_DABUF_MAP_NOMAPPING, &par_buf, w);
 		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
@@ -2534,7 +2549,8 @@ xfs_dabuf_map(
 	 * Caller doesn't have a mapping.  -2 means don't complain
 	 * if we land in a hole.
 	 */
-	if (mappedbno == -1 || mappedbno == -2) {
+	if (mappedbno == XFS_DABUF_MAP_NOMAPPING ||
+	    mappedbno == XFS_DABUF_MAP_HOLE_OK) {
 		/*
 		 * Optimize the one-block case.
 		 */
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 8dedc30..6bc7651 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -20,6 +20,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_attr_leaf.h"
 
 /*
  * Local function prototypes.
@@ -123,8 +124,9 @@ xfs_dir3_block_read(
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
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 2c79be4..a4188de 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -17,6 +17,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_attr_leaf.h"
 
 static xfs_failaddr_t xfs_dir2_data_freefind_verify(
 		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
@@ -653,7 +654,7 @@ xfs_dir3_data_init(
 	 * Get the buffer set up for the block.
 	 */
 	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, blkno),
-			       -1, &bp, XFS_DATA_FORK);
+			       XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
 	if (error)
 		return error;
 	bp->b_ops = &xfs_dir3_data_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index b7046e2..a2cba6bd 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -19,6 +19,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_attr_leaf.h"
 
 /*
  * Local function declarations.
@@ -311,7 +312,7 @@ xfs_dir3_leaf_get_buf(
 	       bno < xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET));
 
 	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, bno),
-			       -1, &bp, XFS_DATA_FORK);
+			       XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
 	if (error)
 		return error;
 
@@ -594,7 +595,8 @@ xfs_dir2_leaf_addname(
 
 	trace_xfs_dir2_leaf_addname(args);
 
-	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk,
+				   XFS_DABUF_MAP_NOMAPPING, &lbp);
 	if (error)
 		return error;
 
@@ -1189,7 +1191,8 @@ xfs_dir2_leaf_lookup_int(
 	tp = args->trans;
 	mp = dp->i_mount;
 
-	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk,
+				   XFS_DABUF_MAP_NOMAPPING, &lbp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 8bbd742..0a803e4 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -20,6 +20,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_attr_leaf.h"
 
 /*
  * Function declarations.
@@ -227,7 +228,7 @@ xfs_dir2_free_read(
 	xfs_dablk_t		fbno,
 	struct xfs_buf		**bpp)
 {
-	return __xfs_dir3_free_read(tp, dp, fbno, -1, bpp);
+	return __xfs_dir3_free_read(tp, dp, fbno, XFS_DABUF_MAP_NOMAPPING, bpp);
 }
 
 static int
@@ -237,7 +238,7 @@ xfs_dir2_free_try_read(
 	xfs_dablk_t		fbno,
 	struct xfs_buf		**bpp)
 {
-	return __xfs_dir3_free_read(tp, dp, fbno, -2, bpp);
+	return __xfs_dir3_free_read(tp, dp, fbno, XFS_DABUF_MAP_HOLE_OK, bpp);
 }
 
 static int
@@ -254,7 +255,7 @@ xfs_dir3_free_get_buf(
 	struct xfs_dir3_icfree_hdr hdr;
 
 	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, fbno),
-				   -1, &bp, XFS_DATA_FORK);
+				   XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
 	if (error)
 		return error;
 
@@ -1495,7 +1496,8 @@ xfs_dir2_leafn_toosmall(
 		 * Read the sibling leaf block.
 		 */
 		error = xfs_dir3_leafn_read(state->args->trans, dp,
-					    blkno, -1, &bp);
+					    blkno, XFS_DABUF_MAP_NOMAPPING,
+					    &bp);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 77ff9f9..353455c 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -355,9 +355,9 @@ xchk_da_btree_block(
 		goto out_nobuf;
 
 	/* Read the buffer. */
-	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno, -2,
-			&blk->bp, dargs->whichfork,
-			&xchk_da_btree_buf_ops);
+	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno,
+				XFS_DABUF_MAP_HOLE_OK, &blk->bp,
+				dargs->whichfork, &xchk_da_btree_buf_ops);
 	if (!xchk_da_process_error(ds, level, &error))
 		goto out_nobuf;
 	if (blk->bp)
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 1e2e117..eb0fa0f 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -18,6 +18,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
+#include "xfs_attr_leaf.h"
 
 /* Set us up to scrub directories. */
 int
@@ -492,7 +493,8 @@ xchk_directory_leaf1_bestfree(
 	int				error;
 
 	/* Read the free space block. */
-	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
+	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk,
+				   XFS_DABUF_MAP_NOMAPPING, &bp);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;
 	xchk_buffer_recheck(sc, bp);
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index f83f11d..9c22915 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -235,7 +235,8 @@ xfs_attr3_node_inactive(
 		 * traversal of the tree so we may deal with many blocks
 		 * before we come back to this one.
 		 */
-		error = xfs_da3_node_read(*trans, dp, child_fsb, -1, &child_bp,
+		error = xfs_da3_node_read(*trans, dp, child_fsb,
+					  XFS_DABUF_MAP_NOMAPPING, &child_bp,
 					  XFS_ATTR_FORK);
 		if (error)
 			return error;
@@ -321,7 +322,8 @@ xfs_attr3_root_inactive(
 	 * the extents in reverse order the extent containing
 	 * block 0 must still be there.
 	 */
-	error = xfs_da3_node_read(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
+	error = xfs_da3_node_read(*trans, dp, 0, XFS_DABUF_MAP_NOMAPPING, &bp,
+				  XFS_ATTR_FORK);
 	if (error)
 		return error;
 	blkno = bp->b_bn;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index c02f22d..fab416c 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -224,8 +224,9 @@ xfs_attr_node_list_lookup(
 	ASSERT(*pbp == NULL);
 	cursor->blkno = 0;
 	for (;;) {
-		error = xfs_da3_node_read(tp, dp, cursor->blkno, -1, &bp,
-				XFS_ATTR_FORK);
+		error = xfs_da3_node_read(tp, dp, cursor->blkno,
+					  XFS_DABUF_MAP_NOMAPPING, &bp,
+					  XFS_ATTR_FORK);
 		if (error)
 			return error;
 		node = bp->b_addr;
@@ -309,8 +310,9 @@ xfs_attr_node_list(
 	 */
 	bp = NULL;
 	if (cursor->blkno > 0) {
-		error = xfs_da3_node_read(context->tp, dp, cursor->blkno, -1,
-					      &bp, XFS_ATTR_FORK);
+		error = xfs_da3_node_read(context->tp, dp, cursor->blkno,
+					  XFS_DABUF_MAP_NOMAPPING, &bp,
+					  XFS_ATTR_FORK);
 		if ((error != 0) && (error != -EFSCORRUPTED))
 			return error;
 		if (bp) {
@@ -377,7 +379,8 @@ xfs_attr_node_list(
 			break;
 		cursor->blkno = leafhdr.forw;
 		xfs_trans_brelse(context->tp, bp);
-		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno, -1, &bp);
+		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno,
+					    XFS_DABUF_MAP_NOMAPPING, &bp);
 		if (error)
 			return error;
 	}
@@ -497,7 +500,8 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
 	trace_xfs_attr_leaf_list(context);
 
 	context->cursor->blkno = 0;
-	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, -1, &bp);
+	error = xfs_attr3_leaf_read(context->tp, context->dp, 0,
+				    XFS_DABUF_MAP_NOMAPPING, &bp);
 	if (error)
 		return error;
 
-- 
2.7.4


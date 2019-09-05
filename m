Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CE3C0030E
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A86B220828
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EhpALhKG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391160AbfIEWTP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58968 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391156AbfIEWTL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ9oA049740
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=525O1lDQ3fOBBj2FD/mIEFxLXewBAaS5X2MkcplB0/A=;
 b=EhpALhKGLgJs9v2PLCzMvvWEYGRdU829/cxf15Z4X6iom7eBITr8cqwjyE+L1+1eSL5B
 THjjyY38x+xxsujI++ee1qWS9dmGoDbxf8KYvFzJDnUq2Mnwpq431mnIBOfPk7pskT5S
 c0zLILF7bqz33T3vNey/ZCXJKXYIdp5WJzAWPl4xWKpz96BUhGwCCrBdCDh4mPRZagFu
 +iBlzerr3eZHugZYNfXEbCfeGztqNQmvtJOn/IeBptkYv3zGboG94SANhLHsoyQMSUx0
 o2na7yGEvhb8JBC9cu71V0WrgLVUxiHpHQ2rQ9wQ7jSAFEIfnRkjj1qsu4mM+QtXG4XT fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uuarc820f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIeNW123412
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uthq27v3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:05 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MJ4Zi008914
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:04 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:19:04 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 14/21] xfsprogs: Add delayed attribute routines
Date:   Thu,  5 Sep 2019 15:18:48 -0700
Message-Id: <20190905221855.17555-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221855.17555-1-allison.henderson@oracle.com>
References: <20190905221855.17555-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds new delayed attribute routines:

xfs_attr_set_later
xfs_attr_remove_later
xfs_leaf_addname_later
xfs_node_addname_later
xfs_node_removename_later

These routines are similar to their existing counter parts,
but they do not roll or commit transactions.  They instead
return -EAGAIN to allow the calling function to roll the
transaction and recall the function.  This allows the
attribute operations to be logged in multiple smaller
transactions.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 592 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_attr.h |   2 +
 2 files changed, 593 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 3f354c8..e4d1c0c 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -44,6 +44,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
+STATIC int xfs_leaf_addname_later(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_leaf_has_attr(struct xfs_da_args *args, struct xfs_buf **bp);
 
@@ -52,12 +53,14 @@ STATIC int xfs_leaf_has_attr(struct xfs_da_args *args, struct xfs_buf **bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
+STATIC int xfs_node_addname_later(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_node_removename_later(xfs_da_args_t *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
-
+STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
 
 STATIC int
 xfs_attr_args_init(
@@ -279,6 +282,112 @@ xfs_attr_set_args(
 }
 
 /*
+ * Set the attribute specified in @args.
+ * This routine is meant to function as a delayed operation, and may return
+ * -EGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ * returned.
+ */
+int
+xfs_attr_set_later(
+	struct xfs_da_args	*args,
+	struct xfs_buf          **leaf_bp)
+{
+	struct xfs_inode	*dp = args->dp;
+	int			error = 0;
+	int			sf_size;
+
+	/*
+	 * New inodes may not have an attribute fork yet. So set the attribute
+	 * fork appropriately
+	 */
+	if (XFS_IFORK_Q((args->dp)) == 0) {
+		sf_size = sizeof(struct xfs_attr_sf_hdr) +
+		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
+		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
+		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
+		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
+	}
+
+	/*
+	 * If the attribute list is non-existent or a shortform list,
+	 * upgrade it to a single-leaf-block attribute list.
+	 */
+	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
+	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
+	     dp->i_d.di_anextents == 0)) {
+		/*
+		 * Build initial attribute list (if required).
+		 */
+		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
+			xfs_attr_shortform_create(args);
+
+		/*
+		 * Try to add the attr to the attribute list in the inode.
+		 */
+		error = xfs_attr_try_sf_addname(dp, args);
+		if (error != -ENOSPC)
+			return error;
+
+		/*
+		 * It won't fit in the shortform, transform to a leaf block.
+		 * GROT: another possible req'mt for a double-split btree op.
+		 */
+		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+		if (error)
+			return error;
+
+		/*
+		 * Prevent the leaf buffer from being unlocked so that a
+		 * concurrent AIL push cannot grab the half-baked leaf
+		 * buffer and run into problems with the write verifier.
+		 */
+
+		xfs_trans_bhold(args->trans, *leaf_bp);
+		return -EAGAIN;
+	}
+
+	/*
+	 * After a shortform to leaf conversion, we need to hold the leaf and
+	 * cylce out the transaction.  When we get back, we need to release
+	 * the leaf.
+	 */
+	if (*leaf_bp != NULL) {
+		xfs_trans_bhold_release(args->trans, *leaf_bp);
+		*leaf_bp = NULL;
+	}
+
+	/*
+	 * If we fit in a block, or we are in the middle of adding a leaf name.
+	 * xfs_attr_da_leaf_addname will set the XFS_DC_ALLOC_LEAF to indicate
+	 * that it is not done yet, and need to be recalled to finish up from
+	 * the last EAGAIN it returned
+	 */
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK) ||
+	    args->dc.flags & XFS_DC_ALLOC_LEAF) {
+		if (!(args->dc.flags & XFS_DC_FOUND_LBLK)) {
+			error = xfs_attr_leaf_try_add(args, *leaf_bp);
+			args->dc.flags |= XFS_DC_FOUND_LBLK;
+
+			if (error && error != -ENOSPC)
+				return error;
+
+			return -EAGAIN;
+		}
+
+		error = xfs_leaf_addname_later(args);
+		if (error && error != -ENOSPC)
+			return error;
+	} else {
+		error = xfs_node_addname_later(args);
+	}
+
+	return error;
+}
+
+
+
+/*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
 int
@@ -328,6 +437,57 @@ xfs_attr_remove_args(
 	return error;
 }
 
+/*
+ * Remove the attribute specified in @args.
+ * This routine is meant to function as a delayed operation, and may return
+ * -EGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ * returned.
+ */
+int
+xfs_attr_remove_later(
+	struct xfs_da_args      *args)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf		*bp;
+	int			forkoff, error = 0;
+
+	if (!xfs_inode_hasattr(dp)) {
+		error = -ENOATTR;
+	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
+		error = xfs_attr_shortform_remove(args);
+	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK) &&
+		   !(args->dc.flags & XFS_DC_RM_NODE_BLKS)) {
+		/*
+		 * If we fit in a block AND we are not in the middle of
+		 * removing node blocks, remove the leaf attribute.
+		 * xfs_attr_da_node_removename will set XFS_DC_RM_NODE_BLKS to
+		 * signal that it is not done yet, and needs to be recalled to
+		 * to finish up from the last -EAGAIN
+		 */
+		error = xfs_leaf_has_attr(args, &bp);
+		if (error == -ENOATTR) {
+			xfs_trans_brelse(args->trans, bp);
+			return error;
+		}
+		error = 0;
+
+		xfs_attr3_leaf_remove(bp, args);
+
+		/* If the result is small enough, shrink it into the inode.*/
+		forkoff = xfs_attr_shortform_allfit(bp, dp);
+		if (forkoff)
+			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+	} else {
+		error = xfs_node_removename_later(args);
+	}
+
+	return error;
+}
+
+
+
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
@@ -760,6 +920,87 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
 }
 
 /*
+ * Add a name to the leaf attribute list structure
+ *
+ * This leaf block cannot have a "remote" value, we only call this routine
+ * if bmap_one_block() says there is only one block (ie: no remote blks).
+ *
+ * This routine is meant to function as a delayed operation, and may return
+ * -EGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ * returned.
+ */
+STATIC int
+xfs_leaf_addname_later(
+	struct xfs_da_args	*args)
+{
+	int			error, nmap;
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_bmbt_irec	*map = &args->dc.map;
+
+	/*
+	 * If there was an out-of-line value, allocate the blocks we
+	 * identified for its storage and copy the value.  This is done
+	 * after we create the attribute so that we don't overflow the
+	 * maximum size of a transaction and/or hit a deadlock.
+	 */
+	if (args->rmtblkno > 0) {
+		if (!(args->dc.flags & XFS_DC_ALLOC_LEAF)) {
+			args->dc.lfileoff = 0;
+			args->dc.lblkno = 0;
+			args->dc.blkcnt = 0;
+			args->rmtblkcnt = 0;
+			args->rmtblkno = 0;
+			memset(map, 0, sizeof(struct xfs_bmbt_irec));
+
+			error = xfs_attr_rmt_find_hole(args);
+			if (error)
+				return error;
+
+			args->dc.blkcnt = args->rmtblkcnt;
+			args->dc.lblkno = args->rmtblkno;
+			args->dc.flags |= XFS_DC_ALLOC_LEAF;
+		}
+
+		/*
+		 * Roll through the "value", allocating blocks on disk as
+		 * required.
+		 */
+		while (args->dc.blkcnt > 0) {
+			nmap = 1;
+			error = xfs_bmapi_write(args->trans, dp,
+				  (xfs_fileoff_t)args->dc.lblkno,
+				  args->dc.blkcnt, XFS_BMAPI_ATTRFORK,
+				  args->total, map, &nmap);
+			if (error)
+				return error;
+			ASSERT(nmap == 1);
+			ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
+			       (map->br_startblock != HOLESTARTBLOCK));
+
+			/* roll attribute extent map forwards */
+			args->dc.lblkno += map->br_blockcount;
+			args->dc.blkcnt -= map->br_blockcount;
+
+			return -EAGAIN;
+		}
+
+		error = xfs_attr_rmtval_set_value(args);
+		if (error)
+			return error;
+	}
+
+	if (args->rmtblkno > 0) {
+		/*
+		 * Added a "remote" value, just clear the incomplete flag.
+		 */
+		error = xfs_attr3_leaf_clearflag(args);
+	}
+	args->dc.flags &= ~XFS_DC_ALLOC_LEAF;
+	return error;
+}
+
+/*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
 STATIC int
@@ -1259,6 +1500,355 @@ out:
 }
 
 /*
+ * Remove a name from a B-tree attribute list.
+ *
+ * This will involve walking down the Btree, and may involve joining
+ * leaf nodes and even joining intermediate nodes up to and including
+ * the root node (a special case of an intermediate node).
+ *
+ * This routine is meant to function as a delayed operation, and may return
+ * -EGAIN when the transaction needs to be rolled.  Calling functions
+ * will need to handle this, and recall the function until a successful error
+ * code is returned.
+ */
+STATIC int
+xfs_node_removename_later(
+	struct xfs_da_args	*args)
+{
+	struct xfs_da_state	*state = NULL;
+	struct xfs_da_state_blk	*blk;
+	struct xfs_buf		*bp;
+	int			error, forkoff, retval = 0;
+	struct xfs_inode	*dp = args->dp;
+	int			done = 0;
+
+	trace_xfs_attr_node_removename(args);
+
+	if (args->dc.state == NULL) {
+		error = xfs_attr_node_hasname(args, &args->dc.state);
+		if (error != -EEXIST)
+			goto out;
+		else
+			error = 0;
+
+		/*
+		 * If there is an out-of-line value, de-allocate the blocks.
+		 * This is done before we remove the attribute so that we don't
+		 * overflow the maximum size of a transaction and/or hit a
+		 * deadlock.
+		 */
+		state = args->dc.state;
+		args->dc.blk = &state->path.blk[state->path.active - 1];
+		ASSERT(args->dc.blk->bp != NULL);
+		ASSERT(args->dc.blk->magic == XFS_ATTR_LEAF_MAGIC);
+	}
+	state = args->dc.state;
+	blk = args->dc.blk;
+
+	if (args->rmtblkno > 0 && !(args->dc.flags & XFS_DC_RM_LEAF_BLKS)) {
+		bool isset;
+
+		error = xfs_attr3_leaf_flag_is_set(args, &isset);
+		if (error)
+			goto out;
+		if (!isset) {
+			/*
+			 * Fill in disk block numbers in the state structure
+			 * so that we can get the buffers back after we commit
+			 * several transactions in the following calls.
+			 */
+			error = xfs_attr_fillstate(state);
+			if (error)
+				goto out;
+
+			/*
+			 * Mark the attribute as INCOMPLETE, then bunmapi() the
+			 * remote value.
+			 */
+			error = xfs_attr3_leaf_setflag(args);
+			if (error)
+				goto out;
+
+			return -EAGAIN;
+		}
+
+		if (!(args->dc.flags & XFS_DC_RM_NODE_BLKS)) {
+			args->dc.flags |= XFS_DC_RM_NODE_BLKS;
+			error = xfs_attr_rmtval_invalidate(args);
+			if (error)
+				goto out;
+		}
+
+		/*
+		 * Unmap value blocks for this attr.  This is similar to
+		 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
+		 * for new transactions
+		 */
+		while (!done && !error) {
+			error = xfs_bunmapi(args->trans, args->dp,
+				    args->rmtblkno, args->rmtblkcnt,
+				    XFS_BMAPI_ATTRFORK, 1, &done);
+			if (error)
+				return error;
+
+			if (!done)
+				return -EAGAIN;
+		}
+
+		if (error)
+			goto out;
+
+		/*
+		 * Refill the state structure with buffers, the prior calls
+		 * released our buffers.
+		 */
+		error = xfs_attr_refillstate(state);
+		if (error)
+			goto out;
+	}
+
+	/*
+	 * Remove the name and update the hashvals in the tree.
+	 */
+	if (!(args->dc.flags & XFS_DC_RM_LEAF_BLKS)) {
+		blk = &state->path.blk[state->path.active - 1];
+		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+		retval = xfs_attr3_leaf_remove(blk->bp, args);
+		xfs_da3_fixhashpath(state, &state->path);
+
+		args->dc.flags |= XFS_DC_RM_LEAF_BLKS;
+	}
+
+	/*
+	 * Check to see if the tree needs to be collapsed.
+	 */
+	if (retval && (state->path.active > 1)) {
+		args->dc.flags |= XFS_DC_RM_NODE_BLKS;
+		error = xfs_da3_join(state);
+		if (error)
+			goto out;
+
+		return -EAGAIN;
+	}
+
+	/*
+	 * If the result is small enough, push it all into the inode.
+	 */
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+		/*
+		 * Have to get rid of the copy of this dabuf in the state.
+		 */
+		ASSERT(state->path.active == 1);
+		ASSERT(state->path.blk[0].bp);
+		state->path.blk[0].bp = NULL;
+
+		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, -1, &bp);
+		if (error)
+			goto out;
+
+		forkoff = xfs_attr_shortform_allfit(bp, dp);
+		if (forkoff) {
+			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+			/* bp is gone due to xfs_da_shrink_inode */
+			if (error)
+				goto out;
+		} else
+			xfs_trans_brelse(args->trans, bp);
+	}
+out:
+	if (state != NULL)
+		xfs_da_state_free(state);
+
+	return error;
+}
+
+/*
+ * Add a name to a Btree-format attribute list.
+ *
+ * This will involve walking down the Btree, and may involve splitting
+ * leaf nodes and even splitting intermediate nodes up to and including
+ * the root node (a special case of an intermediate node).
+ *
+ * "Remote" attribute values confuse the issue and atomic rename operations
+ * add a whole extra layer of confusion on top of that.
+ *
+ * This routine is meant to function as a delayed operation, and may return
+ * -EGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ *returned.
+ */
+STATIC int
+xfs_node_addname_later(
+	struct xfs_da_args	*args)
+{
+	struct xfs_da_state	*state = NULL;
+	struct xfs_da_state_blk	*blk;
+	struct xfs_inode	*dp;
+	int			retval = 0;
+	int			error = 0;
+	int			nmap;
+	struct xfs_bmbt_irec    *map = &args->dc.map;
+
+	trace_xfs_attr_node_addname(args);
+
+	/*
+	 * Fill in bucket of arguments/results/context to carry around.
+	 */
+	dp = args->dp;
+
+	if (args->dc.flags & XFS_DC_FOUND_NBLK)
+		goto found_blk;
+
+	/*
+	 * Search to see if name already exists, and get back a pointer
+	 * to where it should go.
+	 */
+	retval = xfs_attr_node_hasname(args, &state);
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
+		goto out;
+	} else if (retval == -EEXIST) {
+		if (args->name.type & ATTR_CREATE)
+			goto out;
+
+		trace_xfs_attr_node_replace(args);
+
+		/* save the attribute state for later removal*/
+		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
+		args->blkno2 = args->blkno;		/* set 2nd entry info*/
+		args->index2 = args->index;
+		args->rmtblkno2 = args->rmtblkno;
+		args->rmtblkcnt2 = args->rmtblkcnt;
+		args->rmtvaluelen2 = args->rmtvaluelen;
+
+		/*
+		 * clear the remote attr state now that it is saved so that the
+		 * values reflect the state of the attribute we are about to
+		 * add, not the attribute we just found and will remove later.
+		 */
+		args->rmtblkno = 0;
+		args->rmtblkcnt = 0;
+		args->rmtvaluelen = 0;
+	}
+
+	retval = xfs_attr3_leaf_add(blk->bp, state->args);
+	if (retval == -ENOSPC) {
+		if (state->path.active == 1) {
+			/*
+			 * Its really a single leaf node, but it had
+			 * out-of-line values so it looked like it *might*
+			 * have been a b-tree.
+			 */
+			xfs_da_state_free(state);
+			state = NULL;
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				goto out;
+
+			return -EAGAIN;
+		}
+
+		/*
+		 * Split as many Btree elements as required.
+		 * This code tracks the new and old attr's location
+		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
+		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
+		 */
+		error = xfs_da3_split(state);
+		if (error)
+			goto out;
+	} else {
+		/*
+		 * Addition succeeded, update Btree hashvals.
+		 */
+		xfs_da3_fixhashpath(state, &state->path);
+	}
+
+	/*
+	 * Kill the state structure, we're done with it and need to
+	 * allow the buffers to come back later.
+	 */
+	xfs_da_state_free(state);
+	state = NULL;
+
+	args->dc.flags |= XFS_DC_FOUND_NBLK;
+	return -EAGAIN;
+found_blk:
+
+	/*
+	 * If there was an out-of-line value, allocate the blocks we
+	 * identified for its storage and copy the value.  This is done
+	 * after we create the attribute so that we don't overflow the
+	 * maximum size of a transaction and/or hit a deadlock.
+	 */
+	if (args->rmtblkno > 0) {
+		if (!(args->dc.flags & XFS_DC_ALLOC_NODE)) {
+			args->dc.flags |= XFS_DC_ALLOC_NODE;
+			args->dc.lblkno = 0;
+			args->dc.lfileoff = 0;
+			args->dc.blkcnt = 0;
+			args->rmtblkcnt = 0;
+			args->rmtblkno = 0;
+			memset(map, 0, sizeof(struct xfs_bmbt_irec));
+
+			error = xfs_attr_rmt_find_hole(args);
+			if (error)
+				return error;
+
+			args->dc.blkcnt = args->rmtblkcnt;
+			args->dc.lblkno = args->rmtblkno;
+		}
+		/*
+		 * Roll through the "value", allocating blocks on disk as
+		 * required.
+		 */
+		while (args->dc.blkcnt > 0) {
+			nmap = 1;
+			error = xfs_bmapi_write(args->trans, dp,
+				(xfs_fileoff_t)args->dc.lblkno, args->dc.blkcnt,
+				XFS_BMAPI_ATTRFORK, args->total, map, &nmap);
+			if (error)
+				return error;
+
+			ASSERT(nmap == 1);
+			ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
+			       (map->br_startblock != HOLESTARTBLOCK));
+
+			/* roll attribute extent map forwards */
+			args->dc.lblkno += map->br_blockcount;
+			args->dc.blkcnt -= map->br_blockcount;
+
+			return -EAGAIN;
+		}
+
+		error = xfs_attr_rmtval_set_value(args);
+		if (error)
+			return error;
+	}
+
+	if (args->rmtblkno > 0) {
+		/*
+		 * Added a "remote" value, just clear the incomplete flag.
+		 */
+		error = xfs_attr3_leaf_clearflag(args);
+		if (error)
+			goto out;
+	}
+	retval = error = 0;
+
+out:
+	if (state)
+		xfs_da_state_free(state);
+	if (error)
+		return error;
+
+	return retval;
+}
+
+
+
+/*
  * Fill in the disk block numbers in the state structure for the buffers
  * that are attached to the state structure.
  * This is done so that we can quickly reattach ourselves to those buffers
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 6bd783c..9828728 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -147,9 +147,11 @@ int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
 int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
 		 unsigned char *value, int valuelen);
 int xfs_attr_set_args(struct xfs_da_args *args);
+int xfs_attr_set_later(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
 int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_later(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 bool xfs_attr_namecheck(const void *name, size_t length);
-- 
2.7.4


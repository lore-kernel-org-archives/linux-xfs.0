Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDACC433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 08:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67D3020DD4
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 08:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbhAPIPd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Jan 2021 03:15:33 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54138 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbhAPIPd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Jan 2021 03:15:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10G8Afwk172645
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 08:14:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=TRokMc2aGor1OwF6d1Mnp+h6xKxAtjTZ5utv1YTp6fM=;
 b=LdBx1dVAZP36fRiMDen9Qn7bRX/c/G+a4hFk8B68xuV1/ld2igqBgja+jFCjIZJ8rjCT
 EH/jT9fb5z+/adJc2NjYLpzn3zN7TX8yqJpy17le/X+9jt9Bl2EYBggpxXJZCrTSbCOH
 uDCqDrCJ89LMTaCqarejP3iiF16yc8qmI3Kjw+HCn4fA1nIb5PuD7y2ma+yZMzUZwHJ3
 R6o+KjPBoZgkGpi0hPNI0HYWQQlPHjqPPlkIzGZPnLSih7NbTPNOdKdfU5exZ/qED0nV
 sKaxMhKSFOO5QUGp+PWlOBGFBgCWuzl+W3QXMrCoc1hT0tzo0Am8y3P+79DscKI25UN6 Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 363qjqgb7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 08:14:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10G8Acep009891
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 08:12:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 363p6c011f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 08:12:47 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10G8ClPM024591
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 08:12:47 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 Jan 2021 00:12:47 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 1/1] xfs: refactor xfs_attr_set follow up
Date:   Sat, 16 Jan 2021 01:12:40 -0700
Message-Id: <20210116081240.12478-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101160049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101160048
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a follow up to Brians earlier patch
"[PATCH RFC] xfs: refactor xfs_attr_set() into incremental components"

This patch resembles the earlier patch, but it is seated at the top of
the parent pointers set rather than the bottom to give a better
illustraion of what this approach might end up looking like in the
bigger picture.  This patch is both compiled and tested, and is meant to
be more of an exploratory effort than anything.

Most of the state management is collapsed into the *_iter functions
similar to Brians patch which collapsed them into the *_args routines.
Though there are a few states that a still in a few subfunctions.

In anycase, I think it gives decent idea of what the solution might
look like in practice.  Questions, comments and feedback appreciated.

Thanks!
Allison

---
 fs/xfs/libxfs/xfs_attr.c | 596 +++++++++++++++++++----------------------------
 fs/xfs/libxfs/xfs_attr.h |   4 +-
 2 files changed, 247 insertions(+), 353 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 6ba8f4b..356e35c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -45,8 +45,8 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
 /*
  * Internal routines when attribute list is one block.
  */
+STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args      *args);
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_addname(struct xfs_attr_item *attr);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 
@@ -55,6 +55,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(struct xfs_attr_item *attr);
+STATIC int xfs_attr_node_addname_work(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_removename_iter(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
@@ -219,52 +220,77 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-/*
- * Attempts to set an attr in shortform, or converts short form to leaf form if
- * there is not enough room.  This function is meant to operate as a helper
- * routine to the delayed attribute functions.  It returns -EAGAIN to indicate
- * that the calling function should roll the transaction, and then proceed to
- * add the attr in leaf form.  This subroutine does not expect to be recalled
- * again like the other delayed attr routines do.
- */
-STATIC int
-xfs_attr_set_shortform(
-	struct xfs_da_args	*args,
-	struct xfs_buf		**leaf_bp)
+int
+xfs_attr_set_fmt(
+	struct xfs_attr_item	*attr,
+	bool			*done)
 {
+	struct xfs_da_args	*args = attr->xattri_da_args;
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf		**leaf_bp = &attr->xattri_leaf_bp;
 	int			error = 0;
 
-	/*
-	 * Try to add the attr to the attribute list in the inode.
-	 */
-	error = xfs_attr_try_sf_addname(dp, args);
+	*done = false;
+	if (xfs_attr_is_shortform(dp)) {
 
-	/* Should only be 0, -EEXIST or -ENOSPC */
-	if (error != -ENOSPC) {
-		return error;
+		*done = true;
+		error = xfs_attr_try_sf_addname(dp, args);
+		if (!error)
+			*done = true;
+
+		if (error != -ENOSPC)
+			return error;
+
+		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+		if (error)
+			return error;
+
+		xfs_trans_bhold(args->trans, *leaf_bp);
+
+		trace_xfs_das_state_return(XFS_DAS_UNINIT);
+		return -EAGAIN;
 	}
 	/*
-	 * It won't fit in the shortform, transform to a leaf block.  GROT:
-	 * another possible req'mt for a double-split btree op.
+	 * After a shortform to leaf conversion, we need to hold the leaf and
+	 * cycle out the transaction.  When we get back, we need to release
+	 * the leaf to release the hold on the leaf buffer.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
-	if (error)
-		return error;
+	if (*leaf_bp != NULL) {
+		xfs_trans_bhold_release(args->trans, *leaf_bp);
+		*leaf_bp = NULL;
+	}
 
-	/*
-	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
-	 * push cannot grab the half-baked leaf buffer and run into problems
-	 * with the write verifier.
-	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+		error = xfs_attr_leaf_try_add(args, *leaf_bp);
+		switch (error) {
+		case -ENOSPC:
+			/*
+			 * Promote the attribute list to the Btree format.
+			 */
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
 
-	/*
-	 * We're still in XFS_DAS_UNINIT state here.  We've converted the attr
-	 * fork to leaf format and will restart with the leaf add.
-	 */
-	trace_xfs_das_state_return(XFS_DAS_UNINIT);
-	return -EAGAIN;
+			/*
+			 * Finish any deferred work items and roll the
+			 * transaction once more.  The goal here is to call
+			 * node_addname with the inode and transaction in the
+			 * same state (inode locked and joined, transaction
+			 * clean) no matter how we got to this step.
+			 *
+			 * At this point, we are still in XFS_DAS_UNINIT, but
+			 * when we come back, we'll be a node, so we'll fall
+			 * down into the node handling code below
+			 */
+			trace_xfs_das_state_return(attr->xattri_dela_state);
+			return -EAGAIN;
+		case 0:
+			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+			trace_xfs_das_state_return(attr->xattri_dela_state);
+			return -EAGAIN;
+		}
+	}
+	return error;
 }
 
 /*
@@ -274,108 +300,197 @@ xfs_attr_set_shortform(
  * to handle this, and recall the function until a successful error code is
  * returned.
  */
-int
-xfs_attr_set_iter(
-	struct xfs_attr_item		*attr)
+STATIC int
+__xfs_attr_set_iter(
+	struct xfs_attr_item		*attr,
+	bool				*done)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
-	struct xfs_inode		*dp = args->dp;
-	struct xfs_buf			**leaf_bp = &attr->xattri_leaf_bp;
-	int				error = 0;
 	int				sf_size;
+	struct xfs_buf			*bp = NULL;
+	int				error, forkoff;
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
 	switch (attr->xattri_dela_state) {
-	case XFS_DAS_FLIP_LFLAG:
-	case XFS_DAS_FOUND_LBLK:
-	case XFS_DAS_RM_LBLK:
-		return xfs_attr_leaf_addname(attr);
-	case XFS_DAS_FOUND_NBLK:
-	case XFS_DAS_FLIP_NFLAG:
-	case XFS_DAS_ALLOC_NODE:
-		return xfs_attr_node_addname(attr);
 	case XFS_DAS_UNINIT:
-		break;
-	default:
-		ASSERT(attr->xattri_dela_state != XFS_DAS_RM_SHRINK);
-		break;
-	}
+		if (XFS_IFORK_Q((args->dp)) == 0) {
+			sf_size = sizeof(struct xfs_attr_sf_hdr) +
+				  xfs_attr_sf_entsize_byname(args->namelen,
+							     args->valuelen);
+			xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
+			args->dp->i_afp = kmem_cache_zalloc(xfs_ifork_zone, 0);
+			args->dp->i_afp->if_flags = XFS_IFEXTENTS;
+			args->dp->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
+		}
 
-	/*
-	 * New inodes may not have an attribute fork yet. So set the attribute
-	 * fork appropriately
-	 */
-	if (XFS_IFORK_Q((args->dp)) == 0) {
-		sf_size = sizeof(struct xfs_attr_sf_hdr) +
-				 xfs_attr_sf_entsize_byname(args->namelen,
-							    args->valuelen);
-		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
-		args->dp->i_afp = kmem_cache_zalloc(xfs_ifork_zone, 0);
-		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
-		args->dp->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
-	}
+		return xfs_attr_set_fmt(attr, done);
+	case XFS_DAS_FOUND_LBLK:
+		if (args->rmtblkno > 0) {
+			error = xfs_attr_rmtval_find_space(attr);
+			if (error)
+				return error;
+		}
+		attr->xattri_dela_state = XFS_DAS_ALLOC_LBLK;
+	case XFS_DAS_ALLOC_LBLK:
+		if (attr->xattri_blkcnt > 0) {
+			error = xfs_attr_rmtval_set_blk(attr);
+			if (error)
+				return error;
 
-	/*
-	 * If the attribute list is already in leaf format, jump straight to
-	 * leaf handling.  Otherwise, try to add the attribute to the shortform
-	 * list; if there's no room then convert the list to leaf format and try
-	 * again. No need to set state as we will be in leaf form when we come
-	 * back
-	 */
-	if (xfs_attr_is_shortform(dp)) {
+			trace_xfs_das_state_return(attr->xattri_dela_state);
+			return -EAGAIN;
+		}
+		attr->xattri_dela_state = XFS_DAS_SET_LBLK;
+	case XFS_DAS_SET_LBLK:
+		error = xfs_attr_rmtval_set_value(args);
+		if (error)
+			return error;
 
-		/*
-		 * If the attr was successfully set in shortform, no need to
-		 * continue.  Otherwise, is it converted from shortform to leaf
-		 * and -EAGAIN is returned.
-		 */
-		return xfs_attr_set_shortform(args, leaf_bp);
-	}
+		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+			/*
+			 * Added a "remote" value, just clear the incomplete flag.
+			 */
+			if (args->rmtblkno > 0)
+				error = xfs_attr3_leaf_clearflag(args);
 
-	/*
-	 * After a shortform to leaf conversion, we need to hold the leaf and
-	 * cycle out the transaction.  When we get back, we need to release
-	 * the leaf to release the hold on the leaf buffer.
-	 */
-	if (*leaf_bp != NULL) {
-		xfs_trans_bhold_release(args->trans, *leaf_bp);
-		*leaf_bp = NULL;
-	}
+			return error;
+		}
 
-	if (!xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		return xfs_attr_node_addname(attr);
+		if (xfs_hasdelattr(mp))
+			return error;
 
-	error = xfs_attr_leaf_try_add(args, *leaf_bp);
-	switch (error) {
-	case -ENOSPC:
+		error = xfs_attr3_leaf_flipflags(args);
+		if (error)
+			return error;
 		/*
-		 * Promote the attribute list to the Btree format.
+		 * Commit the flag value change and start the next trans in series.
 		 */
-		error = xfs_attr3_leaf_to_node(args);
+		attr->xattri_dela_state = XFS_DAS_INVAL_LBLK;
+		trace_xfs_das_state_return(attr->xattri_dela_state);
+		return -EAGAIN;
+
+	case XFS_DAS_INVAL_LBLK:
+		xfs_attr_restore_rmt_blk(args);
+
+		error = xfs_attr_rmtval_invalidate(args);
 		if (error)
 			return error;
 
+		attr->xattri_dela_state = XFS_DAS_RM_LBLK;
+	case XFS_DAS_RM_LBLK:
+		if (args->rmtblkno) {
+			error = xfs_attr_rmtval_remove(attr);
+			if (error == -EAGAIN)
+				trace_xfs_das_state_return(attr->xattri_dela_state);
+			if (error)
+				return error;
+		}
+
+		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+				   &bp);
+		if (error)
+			return error;
+
+		xfs_attr3_leaf_remove(bp, args);
+
+		forkoff = xfs_attr_shortform_allfit(bp, dp);
+		if (forkoff)
+			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+			/* bp is gone due to xfs_da_shrink_inode */
+
+		return error;
+	case XFS_DAS_FOUND_NBLK:
+		if (args->rmtblkno > 0) {
+			error = xfs_attr_rmtval_find_space(attr);
+			if (error)
+				return error;
+
+		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
+	case XFS_DAS_ALLOC_NODE:
+			if (attr->xattri_blkcnt > 0) {
+				error = xfs_attr_rmtval_set_blk(attr);
+				if (error)
+					return error;
+
+				trace_xfs_das_state_return(attr->xattri_dela_state);
+				return -EAGAIN;
+			}
+
+			error = xfs_attr_rmtval_set_value(args);
+			if (error)
+				return error;
+		}
+
+		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+			/*
+			 * Added a rmt value, just clear the incomplete flag.
+			 */
+			if (args->rmtblkno > 0)
+				error = xfs_attr3_leaf_clearflag(args);
+			return error;
+		}
+
+		if (!xfs_hasdelattr(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				return error;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series
+			 */
+			attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_das_state_return(attr->xattri_dela_state);
+			return -EAGAIN;
+		}
+	case XFS_DAS_FLIP_NFLAG:
 		/*
-		 * Finish any deferred work items and roll the
-		 * transaction once more.  The goal here is to call
-		 * node_addname with the inode and transaction in the
-		 * same state (inode locked and joined, transaction
-		 * clean) no matter how we got to this step.
-		 *
-		 * At this point, we are still in XFS_DAS_UNINIT, but
-		 * when we come back, we'll be a node, so we'll fall
-		 * down into the node handling code below
+		 * Dismantle the "old" attribute/value pair by removing a
+		 * "remote" value (if it exists).
 		 */
-		trace_xfs_das_state_return(attr->xattri_dela_state);
-		return -EAGAIN;
-	case 0:
-		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
-		trace_xfs_das_state_return(attr->xattri_dela_state);
-		return -EAGAIN;
+		xfs_attr_restore_rmt_blk(args);
+
+		error = xfs_attr_rmtval_invalidate(args);
+		if (error)
+			return error;
+
+		attr->xattri_dela_state = XFS_DAS_RM_NBLK;
+	case XFS_DAS_RM_NBLK:
+		if (args->rmtblkno) {
+			error = xfs_attr_rmtval_remove(attr);
+
+			if (error == -EAGAIN) {
+				attr->xattri_dela_state = XFS_DAS_RM_NBLK;
+				trace_xfs_das_state_return(attr->xattri_dela_state);
+			}
+
+			if (error)
+				return error;
+		}
+
+		return xfs_attr_node_addname_work(attr);
+	default:
+		ASSERT(attr->xattri_dela_state != XFS_DAS_RM_SHRINK);
+		break;
 	}
+
 	return error;
 }
 
+int xfs_attr_set_iter(
+	struct xfs_attr_item	*attr)
+{
+	bool	done = true;
+	int 	error;
+
+	error =  __xfs_attr_set_iter(attr, &done);
+	if (error || done)
+		return error;
+
+	return xfs_attr_node_addname(attr);
+}
+
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
@@ -773,145 +888,6 @@ xfs_attr_leaf_try_add(
 
 
 /*
- * Add a name to the leaf attribute list structure
- *
- * This leaf block cannot have a "remote" value, we only call this routine
- * if bmap_one_block() says there is only one block (ie: no remote blks).
- *
- * This routine is meant to function as a delayed operation, and may return
- * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
- * to handle this, and recall the function until a successful error code is
- * returned.
- */
-STATIC int
-xfs_attr_leaf_addname(
-	struct xfs_attr_item		*attr)
-{
-	struct xfs_da_args		*args = attr->xattri_da_args;
-	struct xfs_buf			*bp = NULL;
-	int				error, forkoff;
-	struct xfs_inode		*dp = args->dp;
-	struct xfs_mount		*mp = args->dp->i_mount;
-
-	/* State machine switch */
-	switch (attr->xattri_dela_state) {
-	case XFS_DAS_FLIP_LFLAG:
-		goto das_flip_flag;
-	case XFS_DAS_RM_LBLK:
-		goto das_rm_lblk;
-	default:
-		break;
-	}
-
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-
-	/* Open coded xfs_attr_rmtval_set without trans handling */
-	if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
-		attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
-		if (args->rmtblkno > 0) {
-			error = xfs_attr_rmtval_find_space(attr);
-			if (error)
-				return error;
-		}
-	}
-
-	/*
-	 * Roll through the "value", allocating blocks on disk as
-	 * required.
-	 */
-	if (attr->xattri_blkcnt > 0) {
-		error = xfs_attr_rmtval_set_blk(attr);
-		if (error)
-			return error;
-
-		trace_xfs_das_state_return(attr->xattri_dela_state);
-		return -EAGAIN;
-	}
-
-	error = xfs_attr_rmtval_set_value(args);
-	if (error)
-		return error;
-
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-		/*
-		 * Added a "remote" value, just clear the incomplete flag.
-		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-
-		return error;
-	}
-
-	/*
-	 * If this is an atomic rename operation, we must "flip" the incomplete
-	 * flags on the "new" and "old" attribute/value pairs so that one
-	 * disappears and one appears atomically.  Then we must remove the "old"
-	 * attribute/value pair.
-	 *
-	 * In a separate transaction, set the incomplete flag on the "old" attr
-	 * and clear the incomplete flag on the "new" attr.
-	 */
-	if (!xfs_hasdelattr(mp)) {
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			return error;
-		/*
-		 * Commit the flag value change and start the next trans in series.
-		 */
-		attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
-		trace_xfs_das_state_return(attr->xattri_dela_state);
-		return -EAGAIN;
-	}
-das_flip_flag:
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
-
-	error = xfs_attr_rmtval_invalidate(args);
-	if (error)
-		return error;
-
-	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-	attr->xattri_dela_state = XFS_DAS_RM_LBLK;
-das_rm_lblk:
-	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_remove(attr);
-		if (error == -EAGAIN)
-			trace_xfs_das_state_return(attr->xattri_dela_state);
-		if (error)
-			return error;
-	}
-
-	/*
-	 * Read in the block containing the "old" attr, then remove the "old"
-	 * attr from that block (neat, huh!)
-	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
-				   &bp);
-	if (error)
-		return error;
-
-	xfs_attr3_leaf_remove(bp, args);
-
-	/*
-	 * If the result is small enough, shrink it all into the inode.
-	 */
-	forkoff = xfs_attr_shortform_allfit(bp, dp);
-	if (forkoff)
-		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
-		/* bp is gone due to xfs_da_shrink_inode */
-
-	return error;
-}
-
-/*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
 STATIC int
@@ -1065,24 +1041,9 @@ xfs_attr_node_addname(
 	struct xfs_da_state_blk		*blk;
 	int				retval = 0;
 	int				error = 0;
-	struct xfs_mount		*mp = args->dp->i_mount;
 
 	trace_xfs_attr_node_addname(args);
 
-	/* State machine switch */
-	switch (attr->xattri_dela_state) {
-	case XFS_DAS_FLIP_NFLAG:
-		goto das_flip_flag;
-	case XFS_DAS_FOUND_NBLK:
-		goto das_found_nblk;
-	case XFS_DAS_ALLOC_NODE:
-		goto das_alloc_node;
-	case XFS_DAS_RM_NBLK:
-		goto das_rm_nblk;
-	default:
-		break;
-	}
-
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
@@ -1171,93 +1132,24 @@ xfs_attr_node_addname(
 	attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
 	trace_xfs_das_state_return(attr->xattri_dela_state);
 	return -EAGAIN;
-das_found_nblk:
-
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		/* Open coded xfs_attr_rmtval_set without trans handling */
-		error = xfs_attr_rmtval_find_space(attr);
-		if (error)
-			return error;
-
-		/*
-		 * Roll through the "value", allocating blocks on disk as
-		 * required.  Set the state in case of -EAGAIN return code
-		 */
-		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
-das_alloc_node:
-		if (attr->xattri_blkcnt > 0) {
-			error = xfs_attr_rmtval_set_blk(attr);
-			if (error)
-				return error;
-
-			trace_xfs_das_state_return(attr->xattri_dela_state);
-			return -EAGAIN;
-		}
-
-		error = xfs_attr_rmtval_set_value(args);
-		if (error)
-			return error;
-	}
-
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-		/*
-		 * Added a "remote" value, just clear the incomplete flag.
-		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-		retval = error;
-		goto out;
-	}
-
-	/*
-	 * If this is an atomic rename operation, we must "flip" the incomplete
-	 * flags on the "new" and "old" attribute/value pairs so that one
-	 * disappears and one appears atomically.  Then we must remove the "old"
-	 * attribute/value pair.
-	 *
-	 * In a separate transaction, set the incomplete flag on the "old" attr
-	 * and clear the incomplete flag on the "new" attr.
-	 */
-	if (!xfs_hasdelattr(mp)) {
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			goto out;
-		/*
-		 * Commit the flag value change and start the next trans in series
-		 */
-		attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
-		trace_xfs_das_state_return(attr->xattri_dela_state);
-		return -EAGAIN;
-	}
-das_flip_flag:
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
+out:
+	if (state)
+		xfs_da_state_free(state);
 
-	error = xfs_attr_rmtval_invalidate(args);
 	if (error)
 		return error;
+	return retval;
+}
 
-	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-	attr->xattri_dela_state = XFS_DAS_RM_NBLK;
-das_rm_nblk:
-	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_remove(attr);
-
-		if (error == -EAGAIN)
-			trace_xfs_das_state_return(attr->xattri_dela_state);
-
-		if (error)
-			return error;
-	}
+STATIC
+int xfs_attr_node_addname_work(
+	struct xfs_attr_item		*attr)
+{
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		*state = NULL;
+	struct xfs_da_state_blk		*blk;
+	int				retval = 0;
+	int				error = 0;
 
 	/*
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index c80575a..050e5be 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -376,8 +376,10 @@ enum xfs_delattr_state {
 	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
 	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
 	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
+	XFS_DAS_ALLOC_LBLK,
+	XFS_DAS_SET_LBLK,
 	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
-	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
+	XFS_DAS_INVAL_LBLK,	      /* Invalidate leaf blks */
 	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
 	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
 	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
-- 
2.7.4


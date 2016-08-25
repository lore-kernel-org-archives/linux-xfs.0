Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8D1C583D0
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:59:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 24BC5304043
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:02 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 1agNBmMjDE0D169i (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:58:59 -0700 (PDT)
Subject: [PATCH 03/29] xfs: support storing records in the inode core root
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:58:52 -0700
Message-ID: <147216953246.7022.3740454279098105542.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Make it so that we can actually store btree records in the inode
core (i.e. enable bb_level == 0) so that the rtrmapbt can do this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_btree.c |  201 +++++++++++++++++++++++++++++++++++++++-------------
 libxfs/xfs_btree.h |    1 
 2 files changed, 150 insertions(+), 52 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 0fdbe78..26b8e62 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -153,6 +153,11 @@ xfs_btree_check_block(
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp)	/* buffer containing block, if any */
 {
+	/* Don't check the inode-core root. */
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    level == cur->bc_nlevels - 1)
+		return 0;
+
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		return xfs_btree_check_lblock(cur, block, level, bp);
 	else
@@ -1416,10 +1421,15 @@ xfs_btree_log_recs(
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
 	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
 
-	xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
-	xfs_trans_log_buf(cur->bc_tp, bp,
-			  xfs_btree_rec_offset(cur, first),
-			  xfs_btree_rec_offset(cur, last + 1) - 1);
+	if (bp) {
+		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
+		xfs_trans_log_buf(cur->bc_tp, bp,
+				  xfs_btree_rec_offset(cur, first),
+				  xfs_btree_rec_offset(cur, last + 1) - 1);
+	} else {
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
+				xfs_ilog_fbroot(cur->bc_private.b.whichfork));
+	}
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 }
@@ -2917,8 +2927,11 @@ xfs_btree_new_iroot(
 	struct xfs_btree_block	*cblock;	/* child btree block */
 	union xfs_btree_key	*ckp;		/* child key pointer */
 	union xfs_btree_ptr	*cpp;		/* child ptr pointer */
+	union xfs_btree_rec	*crp;
 	union xfs_btree_key	*kp;		/* pointer to btree key */
 	union xfs_btree_ptr	*pp;		/* pointer to block addr */
+	union xfs_btree_rec	*rp;
+	union xfs_btree_ptr	aptr;
 	union xfs_btree_ptr	nptr;		/* new block addr */
 	int			level;		/* btree level */
 	int			error;		/* error return code */
@@ -2934,10 +2947,15 @@ xfs_btree_new_iroot(
 	level = cur->bc_nlevels - 1;
 
 	block = xfs_btree_get_iroot(cur);
-	pp = xfs_btree_ptr_addr(cur, 1, block);
+	ASSERT(level > 0 || (cur->bc_flags & XFS_BTREE_IROOT_RECORDS));
+	if (level > 0)
+		aptr = *xfs_btree_ptr_addr(cur, 1, block);
+	else
+		aptr.l = cpu_to_be64(XFS_INO_TO_FSB(cur->bc_mp,
+				cur->bc_private.b.ip->i_ino));
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, pp, &nptr, stat);
+	error = cur->bc_ops->alloc_block(cur, &aptr, &nptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0) {
@@ -2963,43 +2981,93 @@ xfs_btree_new_iroot(
 			cblock->bb_u.s.bb_blkno = cpu_to_be64(cbp->b_bn);
 	}
 
-	be16_add_cpu(&block->bb_level, 1);
 	xfs_btree_set_numrecs(block, 1);
 	cur->bc_nlevels++;
 	cur->bc_ptrs[level + 1] = 1;
 
-	kp = xfs_btree_key_addr(cur, 1, block);
-	ckp = xfs_btree_key_addr(cur, 1, cblock);
-	xfs_btree_copy_keys(cur, ckp, kp, xfs_btree_get_numrecs(cblock));
+	if (level > 0) {
+		/*
+		 * We already incremented nlevels, so we have to do the
+		 * same to bb_level or else pp will be calculated with the
+		 * maxrecs for regular blocks and point at the wrong place.
+		 */
+		be16_add_cpu(&block->bb_level, 1);
+
+		kp = xfs_btree_key_addr(cur, 1, block);
+		ckp = xfs_btree_key_addr(cur, 1, cblock);
+		xfs_btree_copy_keys(cur, ckp, kp,
+				xfs_btree_get_numrecs(cblock));
 
-	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
+		pp = xfs_btree_ptr_addr(cur, 1, block);
+		cpp = xfs_btree_ptr_addr(cur, 1, cblock);
 #ifdef DEBUG
-	for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
-		error = xfs_btree_check_ptr(cur, pp, i, level);
-		if (error)
-			goto error0;
-	}
+		for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
+			error = xfs_btree_check_ptr(cur, pp, i, level);
+			if (error)
+				goto error0;
+		}
 #endif
-	xfs_btree_copy_ptrs(cur, cpp, pp, xfs_btree_get_numrecs(cblock));
+		xfs_btree_copy_ptrs(cur, cpp, pp,
+				xfs_btree_get_numrecs(cblock));
 
 #ifdef DEBUG
-	error = xfs_btree_check_ptr(cur, &nptr, 0, level);
-	if (error)
-		goto error0;
+		error = xfs_btree_check_ptr(cur, &nptr, 0, level);
+		if (error)
+			goto error0;
 #endif
-	xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
+		xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
 
-	cur->bc_ops->iroot_realloc(cur, 1 - xfs_btree_get_numrecs(cblock));
+		cur->bc_ops->iroot_realloc(cur,
+				1 - xfs_btree_get_numrecs(cblock));
+		block = xfs_btree_get_iroot(cur);
 
-	xfs_btree_setbuf(cur, level, cbp);
+		xfs_btree_setbuf(cur, level, cbp);
 
-	/*
-	 * Do all this logging at the end so that
-	 * the root is at the right level.
-	 */
-	xfs_btree_log_block(cur, cbp, XFS_BB_ALL_BITS);
-	xfs_btree_log_keys(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
-	xfs_btree_log_ptrs(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
+		/*
+		 * Do all this logging at the end so that
+		 * the root is at the right level.
+		 */
+		xfs_btree_log_block(cur, cbp, XFS_BB_ALL_BITS);
+		xfs_btree_log_keys(cur, cbp, 1,
+				be16_to_cpu(cblock->bb_numrecs));
+		xfs_btree_log_ptrs(cur, cbp, 1,
+				be16_to_cpu(cblock->bb_numrecs));
+	} else {
+		rp = xfs_btree_rec_addr(cur, 1, block);
+		crp = xfs_btree_rec_addr(cur, 1, cblock);
+		xfs_btree_copy_recs(cur, crp, rp,
+				xfs_btree_get_numrecs(cblock));
+
+		/*
+		 * Trickery here: The number of records we think we have
+		 * changes when we convert a leaf to a node.  Therefore,
+		 * set the length to zero, increment the level, and set
+		 * the length to 1 record.
+		 */
+		cur->bc_ops->iroot_realloc(cur, -xfs_btree_get_numrecs(cblock));
+		block = xfs_btree_get_iroot(cur);
+		be16_add_cpu(&block->bb_level, 1);
+		cur->bc_ops->iroot_realloc(cur, 1);
+		block = xfs_btree_get_iroot(cur);
+
+		/* Copy pointer into the block. */
+		xfs_btree_copy_ptrs(cur, xfs_btree_ptr_addr(cur, 1, block),
+				&nptr, 1);
+
+		xfs_btree_setbuf(cur, level, cbp);
+
+		/*
+		 * Do all this logging at the end so that
+		 * the root is at the right level.
+		 */
+		xfs_btree_log_block(cur, cbp, XFS_BB_ALL_BITS);
+		xfs_btree_log_recs(cur, cbp, 1,
+				be16_to_cpu(cblock->bb_numrecs));
+
+		/* Write the new keys into the root block. */
+	}
+	/* Get the keys for the new block and put them into the root. */
+	xfs_btree_get_keys(cur, cblock, xfs_btree_key_addr(cur, 1, block));
 
 	*logflags |=
 		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork);
@@ -3522,15 +3590,15 @@ STATIC int
 xfs_btree_kill_iroot(
 	struct xfs_btree_cur	*cur)
 {
-	int			whichfork = cur->bc_private.b.whichfork;
 	struct xfs_inode	*ip = cur->bc_private.b.ip;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_block	*block;
 	struct xfs_btree_block	*cblock;
 	union xfs_btree_key	*kp;
 	union xfs_btree_key	*ckp;
 	union xfs_btree_ptr	*pp;
 	union xfs_btree_ptr	*cpp;
+	union xfs_btree_rec	*rp;
+	union xfs_btree_rec	*crp;
 	struct xfs_buf		*cbp;
 	int			level;
 	int			index;
@@ -3544,14 +3612,19 @@ xfs_btree_kill_iroot(
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
 
 	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
-	ASSERT(cur->bc_nlevels > 1);
+	ASSERT((cur->bc_flags & XFS_BTREE_IROOT_RECORDS) ||
+	       cur->bc_nlevels > 1);
 
 	/*
 	 * Don't deal with the root block needs to be a leaf case.
 	 * We're just going to turn the thing back into extents anyway.
 	 */
 	level = cur->bc_nlevels - 1;
-	if (level == 1)
+	if (level == 1 && !(cur->bc_flags & XFS_BTREE_IROOT_RECORDS))
+		goto out0;
+
+	/* If we're already a leaf, jump out. */
+	if (level == 0)
 		goto out0;
 
 	/*
@@ -3582,30 +3655,55 @@ xfs_btree_kill_iroot(
 #endif
 
 	index = numrecs - cur->bc_ops->get_maxrecs(cur, level);
-	if (index) {
-		cur->bc_ops->iroot_realloc(cur, index);
-		block = ifp->if_broot;
-	}
-
 	be16_add_cpu(&block->bb_numrecs, index);
 	ASSERT(block->bb_numrecs == cblock->bb_numrecs);
 
-	kp = xfs_btree_key_addr(cur, 1, block);
-	ckp = xfs_btree_key_addr(cur, 1, cblock);
-	xfs_btree_copy_keys(cur, kp, ckp, numrecs);
+	if (be16_to_cpu(cblock->bb_level) > 0) {
+		if (index) {
+			cur->bc_ops->iroot_realloc(cur, index);
+			block = xfs_btree_get_iroot(cur);
+		}
+
+		kp = xfs_btree_key_addr(cur, 1, block);
+		ckp = xfs_btree_key_addr(cur, 1, cblock);
+		xfs_btree_copy_keys(cur, kp, ckp, numrecs);
 
-	pp = xfs_btree_ptr_addr(cur, 1, block);
-	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
+		pp = xfs_btree_ptr_addr(cur, 1, block);
+		cpp = xfs_btree_ptr_addr(cur, 1, cblock);
 #ifdef DEBUG
-	for (i = 0; i < numrecs; i++) {
-		error = xfs_btree_check_ptr(cur, cpp, i, level - 1);
-		if (error) {
-			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
-			return error;
+		for (i = 0; i < numrecs; i++) {
+			error = xfs_btree_check_ptr(cur, cpp, i, level - 1);
+			if (error) {
+				XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+				return error;
+			}
 		}
-	}
 #endif
-	xfs_btree_copy_ptrs(cur, pp, cpp, numrecs);
+		xfs_btree_copy_ptrs(cur, pp, cpp, numrecs);
+		/*
+		 * Decrement the (root) block's level after copying the
+		 * pointers or else pp will be calculated using maxrecs
+		 * for a regular block and won't point to the right place.
+		 * Notice how we don't adjust nlevels until later.
+		 */
+		be16_add_cpu(&block->bb_level, -1);
+	} else {
+		/*
+		 * Trickery here: The number of records we think we have
+		 * changes when we convert a leaf to a node.  Therefore,
+		 * set the length to zero, change the level, and set
+		 * the length to however many records we're getting.
+		 */
+		cur->bc_ops->iroot_realloc(cur, -xfs_btree_get_numrecs(block));
+		block = xfs_btree_get_iroot(cur);
+		be16_add_cpu(&block->bb_level, -1);
+		cur->bc_ops->iroot_realloc(cur, numrecs);
+		block = xfs_btree_get_iroot(cur);
+
+		rp = xfs_btree_rec_addr(cur, 1, block);
+		crp = xfs_btree_rec_addr(cur, 1, cblock);
+		xfs_btree_copy_recs(cur, rp, crp, numrecs);
+	}
 
 	error = xfs_btree_free_block(cur, cbp);
 	if (error) {
@@ -3614,7 +3712,6 @@ xfs_btree_kill_iroot(
 	}
 
 	cur->bc_bufs[level - 1] = NULL;
-	be16_add_cpu(&block->bb_level, -1);
 	xfs_trans_log_inode(cur->bc_tp, ip,
 		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork));
 	cur->bc_nlevels--;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index ea15b1e..8918b81 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -284,6 +284,7 @@ typedef struct xfs_btree_cur
 #define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
 #define XFS_BTREE_CRC_BLOCKS		(1<<3)	/* uses extended btree blocks */
 #define XFS_BTREE_OVERLAPPING		(1<<4)	/* overlapping intervals */
+#define XFS_BTREE_IROOT_RECORDS		(1<<5)	/* iroot can store records */
 
 
 #define	XFS_BTREE_NOERROR	0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35534 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdHaUdl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:33:41 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7VKXeAE021687
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:33:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKXdGq009272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:33:40 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKXdgg017724
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:33:39 GMT
Subject: [PATCH 02/19] xfs: support storing records in the inode core root
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Aug 2017 13:33:37 -0700
Message-ID: <150421161692.17458.7471014924584143407.stgit@magnolia>
In-Reply-To: <150421160433.17458.10817316901867396010.stgit@magnolia>
References: <150421160433.17458.10817316901867396010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make it so that we can actually store btree records in the inode
core (i.e. enable bb_level == 0) so that the rtrmapbt can do this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |  201 +++++++++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_btree.h |    1 
 2 files changed, 150 insertions(+), 52 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 3437905..d0a357e 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -171,6 +171,11 @@ xfs_btree_check_block(
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
@@ -1440,10 +1445,15 @@ xfs_btree_log_recs(
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
@@ -2957,8 +2967,11 @@ xfs_btree_new_iroot(
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
@@ -2974,10 +2987,15 @@ xfs_btree_new_iroot(
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
@@ -3003,43 +3021,93 @@ xfs_btree_new_iroot(
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
@@ -3562,15 +3630,15 @@ STATIC int
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
@@ -3584,14 +3652,19 @@ xfs_btree_kill_iroot(
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
@@ -3622,30 +3695,55 @@ xfs_btree_kill_iroot(
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
@@ -3654,7 +3752,6 @@ xfs_btree_kill_iroot(
 	}
 
 	cur->bc_bufs[level - 1] = NULL;
-	be16_add_cpu(&block->bb_level, -1);
 	xfs_trans_log_inode(cur->bc_tp, ip,
 		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork));
 	cur->bc_nlevels--;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 2636252..39d2143 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -251,6 +251,7 @@ typedef struct xfs_btree_cur
 #define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
 #define XFS_BTREE_CRC_BLOCKS		(1<<3)	/* uses extended btree blocks */
 #define XFS_BTREE_OVERLAPPING		(1<<4)	/* overlapping intervals */
+#define XFS_BTREE_IROOT_RECORDS		(1<<5)	/* iroot can store records */
 
 
 #define	XFS_BTREE_NOERROR	0


Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640C3C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 314B020718
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:18:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LNV3nM4Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgAABSk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:18:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58258 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:18:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EGEq112552
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Qtz1HLMiAHWPwLmNd/RIOfEMmGfdjuIom+tUHoVnyao=;
 b=LNV3nM4ZhzeuHx7loWd0ShQrAry6920YqO+FocrLn0jvuqFPMQOjsuvJh771xEM1J/Mg
 4SYiTTB1Z2gO+lUFtel0g8HRtQrAYMOzIMT5zZe1S4jx+91OEDbNKSTiO28BGLUhcw/p
 /ZMTCuxILPBkPkRo+OvDuTSbX2EmLmdbYIkGL+xW9IEZ9K9zRQ0HdLLosoV86kIu0XOt
 F5L3FUaHxDZ2TImR/LjHagGBJ5qOXNsgXM/vyYIG+7NZwdHwPPGQl4rrRDgrfjsH0hPa
 kRyKX6nJvuOfHZbJg05sUgJuC+A2XLF6h1JPwFe7qJRvB1JHV3gUiaLX7UCrpV9LElyl kA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftk2q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:18:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118uko045262
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2x7medffrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:16:37 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011GZjL001716
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:36 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:16:34 -0800
Subject: [PATCH 02/21] xfs: support storing records in the inode core root
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:16:32 -0800
Message-ID: <157784139231.1368137.12784304397583642340.stgit@magnolia>
In-Reply-To: <157784137939.1368137.1149711841610071256.stgit@magnolia>
References: <157784137939.1368137.1149711841610071256.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make it so that we can actually store btree records in the inode
core (i.e. enable bb_level == 0) so that the rtrmapbt can do this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |  199 ++++++++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_btree.h |    1 
 2 files changed, 150 insertions(+), 50 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 464ae3eafe16..bc0a329e7dda 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -190,6 +190,11 @@ xfs_btree_check_block(
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
@@ -1466,10 +1471,15 @@ xfs_btree_log_recs(
 	int			last)
 {
 
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
 
 }
 
@@ -2941,8 +2951,11 @@ xfs_btree_new_iroot(
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
@@ -2955,10 +2968,15 @@ xfs_btree_new_iroot(
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
 	if (*stat == 0)
@@ -2983,41 +3001,92 @@ xfs_btree_new_iroot(
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
+
+		pp = xfs_btree_ptr_addr(cur, 1, block);
+		cpp = xfs_btree_ptr_addr(cur, 1, cblock);
+
+		for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
+			error = xfs_btree_debug_check_ptr(cur, pp, i, level);
+			if (error)
+				goto error0;
+		}
 
-	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
-	for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
-		error = xfs_btree_debug_check_ptr(cur, pp, i, level);
+		xfs_btree_copy_ptrs(cur, cpp, pp,
+				xfs_btree_get_numrecs(cblock));
+
+		error = xfs_btree_debug_check_ptr(cur, &nptr, 0, level);
 		if (error)
 			goto error0;
-	}
 
-	xfs_btree_copy_ptrs(cur, cpp, pp, xfs_btree_get_numrecs(cblock));
+		xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
 
-	error = xfs_btree_debug_check_ptr(cur, &nptr, 0, level);
-	if (error)
-		goto error0;
+		cur->bc_ops->iroot_realloc(cur,
+				1 - xfs_btree_get_numrecs(cblock));
+		block = xfs_btree_get_iroot(cur);
 
-	xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
+		xfs_btree_setbuf(cur, level, cbp);
 
-	cur->bc_ops->iroot_realloc(cur, 1 - xfs_btree_get_numrecs(cblock));
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
 
-	xfs_btree_setbuf(cur, level, cbp);
+		/*
+		 * Trickery here: The amount of memory we need for the root
+		 * changes when we convert a leaf to a node.  Therefore,
+		 * set the length to zero, increment the level, and set
+		 * the length to 1 record.
+		 */
+		cur->bc_ops->iroot_realloc(cur, -xfs_btree_get_numrecs(cblock));
+		block = xfs_btree_get_iroot(cur);
+		be16_add_cpu(&block->bb_level, 1);
+		cur->bc_ops->iroot_realloc(cur, 1);
+		block = xfs_btree_get_iroot(cur);
 
-	/*
-	 * Do all this logging at the end so that
-	 * the root is at the right level.
-	 */
-	xfs_btree_log_block(cur, cbp, XFS_BB_ALL_BITS);
-	xfs_btree_log_keys(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
-	xfs_btree_log_ptrs(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
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
@@ -3523,15 +3592,15 @@ STATIC int
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
@@ -3543,14 +3612,19 @@ xfs_btree_kill_iroot(
 	int			i;
 
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
@@ -3581,35 +3655,59 @@ xfs_btree_kill_iroot(
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
 
-	pp = xfs_btree_ptr_addr(cur, 1, block);
-	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
+		kp = xfs_btree_key_addr(cur, 1, block);
+		ckp = xfs_btree_key_addr(cur, 1, cblock);
+		xfs_btree_copy_keys(cur, kp, ckp, numrecs);
 
-	for (i = 0; i < numrecs; i++) {
-		error = xfs_btree_debug_check_ptr(cur, cpp, i, level - 1);
-		if (error)
-			return error;
-	}
+		pp = xfs_btree_ptr_addr(cur, 1, block);
+		cpp = xfs_btree_ptr_addr(cur, 1, cblock);
 
-	xfs_btree_copy_ptrs(cur, pp, cpp, numrecs);
+		for (i = 0; i < numrecs; i++) {
+			error = xfs_btree_debug_check_ptr(cur, cpp, i, level - 1);
+			if (error)
+				return error;
+		}
+
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
+		 * Trickery here: The amount of memory we need for the root
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
 	if (error)
 		return error;
 
 	cur->bc_bufs[level - 1] = NULL;
-	be16_add_cpu(&block->bb_level, -1);
 	xfs_trans_log_inode(cur->bc_tp, ip,
 		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork));
 	cur->bc_nlevels--;
@@ -5561,7 +5659,8 @@ xfs_btree_bload_compute_geometry(
 		 * done.  Note that bmap btrees do not allow records in the
 		 * root.
 		 */
-		if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) || level != 0) {
+		if ((cur->bc_flags & XFS_BTREE_IROOT_RECORDS) ||
+		    !(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) || level != 0) {
 			xfs_btree_bload_level_geometry(cur, bbl, level,
 					nr_this_level, &avg_per_block,
 					&level_blocks, &dontcare64);
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 4bf6eadf9b0a..02220758ee99 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -256,6 +256,7 @@ typedef struct xfs_btree_cur
  * is dynamically allocated and must be freed when the cursor is deleted.
  */
 #define XFS_BTREE_STAGING		(1<<5)
+#define XFS_BTREE_IROOT_RECORDS		(1<<6)	/* iroot can store records */
 
 
 #define	XFS_BTREE_NOERROR	0


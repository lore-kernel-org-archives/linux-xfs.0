Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48622 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbeFDQKv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 12:10:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w54GAowe064158
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 16:10:50 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2jbvypc8b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jun 2018 16:10:50 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w54GAlgG001004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 16:10:47 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w54GAlOJ013646
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 16:10:47 GMT
Subject: [PATCH 4/4] xfs: strengthen btree pointer checks before use
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Jun 2018 09:10:46 -0700
Message-ID: <152812864651.2736.14013770828662833917.stgit@magnolia>
In-Reply-To: <152812862079.2736.15381483104759513267.stgit@magnolia>
References: <152812862079.2736.15381483104759513267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Instead of ASSERTing on null btree pointers in xfs_btree_ptr_to_daddr,
use the new block number verifiers to ensure that the btree pointer
doesn't point to any sensitive areas (AG headers, past-EOFS) and return
-EFSCORRUPTED if this is the case.  Remove the ASSERT because on-disk
corruptions shouldn't trigger ASSERTs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |   50 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5d5fe6b96e09..43171a22f085 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1001,22 +1001,30 @@ xfs_btree_readahead(
 	return xfs_btree_readahead_sblock(cur, lr, block);
 }
 
-STATIC xfs_daddr_t
+STATIC int
 xfs_btree_ptr_to_daddr(
 	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*ptr)
+	union xfs_btree_ptr	*ptr,
+	xfs_daddr_t		*daddr)
 {
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		ASSERT(ptr->l != cpu_to_be64(NULLFSBLOCK));
+	xfs_fsblock_t		fsbno;
+	xfs_agblock_t		agbno;
+	int			error;
 
-		return XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
-	} else {
-		ASSERT(cur->bc_private.a.agno != NULLAGNUMBER);
-		ASSERT(ptr->s != cpu_to_be32(NULLAGBLOCK));
+	error = xfs_btree_check_ptr(cur, ptr, 0, 1);
+	if (error)
+		return error;
 
-		return XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
-					be32_to_cpu(ptr->s));
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		fsbno = be64_to_cpu(ptr->l);
+		*daddr = XFS_FSB_TO_DADDR(cur->bc_mp, fsbno);
+	} else {
+		agbno = be32_to_cpu(ptr->s);
+		*daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
+				agbno);
 	}
+
+	return 0;
 }
 
 /*
@@ -1031,8 +1039,11 @@ xfs_btree_readahead_ptr(
 	union xfs_btree_ptr	*ptr,
 	xfs_extlen_t		count)
 {
-	xfs_buf_readahead(cur->bc_mp->m_ddev_targp,
-			  xfs_btree_ptr_to_daddr(cur, ptr),
+	xfs_daddr_t		daddr;
+
+	if (xfs_btree_ptr_to_daddr(cur, ptr, &daddr))
+		return;
+	xfs_buf_readahead(cur->bc_mp->m_ddev_targp, daddr,
 			  cur->bc_mp->m_bsize * count, cur->bc_ops->buf_ops);
 }
 
@@ -1295,11 +1306,14 @@ xfs_btree_get_buf_block(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_daddr_t		d;
+	int			error;
 
 	/* need to sort out how callers deal with failures first */
 	ASSERT(!(flags & XBF_TRYLOCK));
 
-	d = xfs_btree_ptr_to_daddr(cur, ptr);
+	error = xfs_btree_ptr_to_daddr(cur, ptr, &d);
+	if (error)
+		return error;
 	*bpp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
 				 mp->m_bsize, flags);
 
@@ -1330,7 +1344,9 @@ xfs_btree_read_buf_block(
 	/* need to sort out how callers deal with failures first */
 	ASSERT(!(flags & XBF_TRYLOCK));
 
-	d = xfs_btree_ptr_to_daddr(cur, ptr);
+	error = xfs_btree_ptr_to_daddr(cur, ptr, &d);
+	if (error)
+		return error;
 	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
 				   mp->m_bsize, flags, bpp,
 				   cur->bc_ops->buf_ops);
@@ -1777,6 +1793,7 @@ xfs_btree_lookup_get_block(
 	struct xfs_btree_block	**blkp) /* return btree block */
 {
 	struct xfs_buf		*bp;	/* buffer pointer for btree block */
+	xfs_daddr_t		daddr;
 	int			error = 0;
 
 	/* special case the root block if in an inode */
@@ -1793,7 +1810,10 @@ xfs_btree_lookup_get_block(
 	 * Otherwise throw it away and get a new one.
 	 */
 	bp = cur->bc_bufs[level];
-	if (bp && XFS_BUF_ADDR(bp) == xfs_btree_ptr_to_daddr(cur, pp)) {
+	error = xfs_btree_ptr_to_daddr(cur, pp, &daddr);
+	if (error)
+		return error;
+	if (bp && XFS_BUF_ADDR(bp) == daddr) {
 		*blkp = XFS_BUF_TO_BLOCK(bp);
 		return 0;
 	}


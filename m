Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48088 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeFCXWh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:22:37 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w53NLibh052174
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:22:37 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2jbvynsfgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Jun 2018 23:22:37 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w53NMaOK020786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:22:36 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w53NMajx000367
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:22:36 GMT
Subject: [PATCH 02/10] xfs: strengthen btree pointer checks before use
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 03 Jun 2018 16:22:34 -0700
Message-ID: <152806815486.18187.14504589975269520134.stgit@magnolia>
In-Reply-To: <152806814253.18187.4009340462930782844.stgit@magnolia>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_btree.c |   60 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index c825c8182b30..2ddf47f3be52 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -988,22 +988,44 @@ xfs_btree_readahead(
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
+	xfs_fsblock_t		fsbno;
+	xfs_agblock_t		agbno;
+
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		ASSERT(ptr->l != cpu_to_be64(NULLFSBLOCK));
+		fsbno = be64_to_cpu(ptr->l);
+
+		if (!xfs_btree_check_lptr(cur, fsbno, 1)) {
+			xfs_err(cur->bc_mp,
+"Inode %llu fork %d: Corrupt btree %d pointer to fsblock %llu",
+					cur->bc_private.b.ip->i_ino,
+					cur->bc_private.b.whichfork,
+					cur->bc_btnum, fsbno);
+			return -EFSCORRUPTED;
+		}
 
-		return XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
+		*daddr = XFS_FSB_TO_DADDR(cur->bc_mp, fsbno);
 	} else {
-		ASSERT(cur->bc_private.a.agno != NULLAGNUMBER);
-		ASSERT(ptr->s != cpu_to_be32(NULLAGBLOCK));
+		agbno = be32_to_cpu(ptr->s);
+
+		if (!xfs_btree_check_sptr(cur, agbno, 1)) {
+			xfs_err(cur->bc_mp,
+"AG %u: Corrupt btree %d pointer to agbno %u",
+					cur->bc_private.a.agno, cur->bc_btnum,
+					agbno);
+			return -EFSCORRUPTED;
+		}
 
-		return XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
-					be32_to_cpu(ptr->s));
+		*daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
+					agbno);
 	}
+
+	return 0;
 }
 
 /*
@@ -1018,8 +1040,11 @@ xfs_btree_readahead_ptr(
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
 
@@ -1282,11 +1307,14 @@ xfs_btree_get_buf_block(
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
 
@@ -1317,7 +1345,9 @@ xfs_btree_read_buf_block(
 	/* need to sort out how callers deal with failures first */
 	ASSERT(!(flags & XBF_TRYLOCK));
 
-	d = xfs_btree_ptr_to_daddr(cur, ptr);
+	error = xfs_btree_ptr_to_daddr(cur, ptr, &d);
+	if (error)
+		return error;
 	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
 				   mp->m_bsize, flags, bpp,
 				   cur->bc_ops->buf_ops);
@@ -1764,6 +1794,7 @@ xfs_btree_lookup_get_block(
 	struct xfs_btree_block	**blkp) /* return btree block */
 {
 	struct xfs_buf		*bp;	/* buffer pointer for btree block */
+	xfs_daddr_t		daddr;
 	int			error = 0;
 
 	/* special case the root block if in an inode */
@@ -1780,7 +1811,10 @@ xfs_btree_lookup_get_block(
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


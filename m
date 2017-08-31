Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48273 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdHaUeL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:34:11 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7VKYA37014416
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKYAGR021000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:10 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7VKYAJH029276
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:10 GMT
Subject: [PATCH 07/19] xfs: add realtime rmap btree operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Aug 2017 13:34:07 -0700
Message-ID: <150421164771.17458.13143230856479505565.stgit@magnolia>
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

Implement the generic btree operations needed to manipulate rtrmap
btree blocks. This is different from the regular rmapbt in that we
allocate space from the filesystem at large, and are neither
constrained to the free space nor any particular AG.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c |  319 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 319 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index c65db0b..31d61d3 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -31,12 +31,14 @@
 #include "xfs_trans.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
+#include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
 #include "xfs_ag_resv.h"
+#include "xfs_bmap.h"
 
 /*
  * Realtime Reverse map btree.
@@ -70,6 +72,275 @@ xfs_rtrmapbt_dup_cursor(
 	return new;
 }
 
+STATIC int
+xfs_rtrmapbt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			*stat)
+{
+	struct xfs_alloc_arg	args;
+	int			error;
+
+	memset(&args, 0, sizeof(args));
+	args.tp = cur->bc_tp;
+	args.mp = cur->bc_mp;
+	args.fsbno = cur->bc_private.b.firstblock;
+	args.firstblock = args.fsbno;
+	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_private.b.ip->i_ino,
+			cur->bc_private.b.whichfork);
+
+	if (args.fsbno == NULLFSBLOCK) {
+		args.fsbno = be64_to_cpu(start->l);
+		args.type = XFS_ALLOCTYPE_START_BNO;
+		/*
+		 * Make sure there is sufficient room left in the AG to
+		 * complete a full tree split for an extent insert.  If
+		 * we are converting the middle part of an extent then
+		 * we may need space for two tree splits.
+		 *
+		 * We are relying on the caller to make the correct block
+		 * reservation for this operation to succeed.  If the
+		 * reservation amount is insufficient then we may fail a
+		 * block allocation here and corrupt the filesystem.
+		 */
+		args.minleft = args.tp->t_blk_res;
+	} else if (cur->bc_private.b.dfops->dop_low) {
+		args.type = XFS_ALLOCTYPE_START_BNO;
+	} else {
+		args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	}
+
+	args.minlen = args.maxlen = args.prod = 1;
+	args.wasdel = 0;
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		goto error0;
+
+	if (args.fsbno == NULLFSBLOCK && args.minleft) {
+		/*
+		 * Could not find an AG with enough free space to satisfy
+		 * a full btree split.  Try again without minleft and if
+		 * successful activate the lowspace algorithm.
+		 */
+		args.fsbno = 0;
+		args.type = XFS_ALLOCTYPE_FIRST_AG;
+		args.minleft = 0;
+		error = xfs_alloc_vextent(&args);
+		if (error)
+			goto error0;
+		cur->bc_private.b.dfops->dop_low = true;
+	}
+	if (args.fsbno == NULLFSBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+	ASSERT(args.len == 1);
+	cur->bc_private.b.firstblock = args.fsbno;
+	cur->bc_private.b.allocated++;
+	cur->bc_private.b.ip->i_d.di_nblocks++;
+	xfs_trans_log_inode(args.tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
+
+	new->l = cpu_to_be64(args.fsbno);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+
+ error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+STATIC int
+xfs_rtrmapbt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	struct xfs_trans	*tp = cur->bc_tp;
+	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	struct xfs_owner_info	oinfo;
+
+	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_private.b.whichfork);
+	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, fsbno, 1, &oinfo);
+	ip->i_d.di_nblocks--;
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
+
+/*
+ * Calculate number of records in the in-core realtime rmap btree inode root.
+ */
+STATIC int
+xfs_rtrmapbt_broot_maxrecs(
+	int			blocklen,
+	bool			leaf)
+{
+	blocklen -= XFS_RTRMAP_BLOCK_LEN;
+
+	if (leaf)
+		return blocklen / sizeof(struct xfs_rtrmap_rec);
+	return blocklen / (2 * sizeof(struct xfs_rtrmap_key) +
+			sizeof(xfs_rtrmap_ptr_t));
+}
+
+STATIC int
+xfs_rtrmapbt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	struct xfs_ifork	*ifp;
+
+	if (level == cur->bc_nlevels - 1) {
+		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip,
+				    cur->bc_private.b.whichfork);
+
+		return xfs_rtrmapbt_broot_maxrecs(ifp->if_broot_bytes,
+				level == 0) / 2;
+	}
+
+	return cur->bc_mp->m_rtrmap_mnr[level != 0];
+}
+
+STATIC int
+xfs_rtrmapbt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	struct xfs_ifork	*ifp;
+
+	if (level == cur->bc_nlevels - 1) {
+		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip,
+				    cur->bc_private.b.whichfork);
+
+		return xfs_rtrmapbt_broot_maxrecs(ifp->if_broot_bytes,
+				level == 0);
+	}
+
+	return cur->bc_mp->m_rtrmap_mxr[level != 0];
+}
+
+STATIC void
+xfs_rtrmapbt_init_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	key->rtrmap.rm_startblock = rec->rtrmap.rm_startblock;
+	key->rtrmap.rm_owner = rec->rtrmap.rm_owner;
+	key->rtrmap.rm_offset = rec->rtrmap.rm_offset;
+}
+
+STATIC void
+xfs_rtrmapbt_init_high_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	uint64_t		off;
+	int			adj;
+
+	adj = be64_to_cpu(rec->rtrmap.rm_blockcount) - 1;
+
+	key->rtrmap.rm_startblock = rec->rtrmap.rm_startblock;
+	be64_add_cpu(&key->rtrmap.rm_startblock, adj);
+	key->rtrmap.rm_owner = rec->rtrmap.rm_owner;
+	key->rtrmap.rm_offset = rec->rtrmap.rm_offset;
+	if (XFS_RMAP_NON_INODE_OWNER(be64_to_cpu(rec->rtrmap.rm_owner)) ||
+	    XFS_RMAP_IS_BMBT_BLOCK(be64_to_cpu(rec->rtrmap.rm_offset)))
+		return;
+	off = be64_to_cpu(key->rtrmap.rm_offset);
+	off = (XFS_RMAP_OFF(off) + adj) | (off & ~XFS_RMAP_OFF_MASK);
+	key->rtrmap.rm_offset = cpu_to_be64(off);
+}
+
+STATIC void
+xfs_rtrmapbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	rec->rtrmap.rm_startblock = cpu_to_be64(cur->bc_rec.r.rm_startblock);
+	rec->rtrmap.rm_blockcount = cpu_to_be64(cur->bc_rec.r.rm_blockcount);
+	rec->rtrmap.rm_owner = cpu_to_be64(cur->bc_rec.r.rm_owner);
+	rec->rtrmap.rm_offset = cpu_to_be64(
+			xfs_rmap_irec_offset_pack(&cur->bc_rec.r));
+}
+
+STATIC void
+xfs_rtrmapbt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	ptr->l = 0;
+}
+
+STATIC int64_t
+xfs_rtrmapbt_key_diff(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key)
+{
+	struct xfs_rmap_irec	*rec = &cur->bc_rec.r;
+	struct xfs_rtrmap_key	*kp = &key->rtrmap;
+	__u64			x, y;
+
+	x = be64_to_cpu(kp->rm_startblock);
+	y = rec->rm_startblock;
+	if (x > y)
+		return 1;
+	else if (y > x)
+		return -1;
+
+	x = be64_to_cpu(kp->rm_owner);
+	y = rec->rm_owner;
+	if (x > y)
+		return 1;
+	else if (y > x)
+		return -1;
+
+	x = XFS_RMAP_OFF(be64_to_cpu(kp->rm_offset));
+	y = rec->rm_offset;
+	if (x > y)
+		return 1;
+	else if (y > x)
+		return -1;
+	return 0;
+}
+
+STATIC int64_t
+xfs_rtrmapbt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	struct xfs_rtrmap_key	*kp1 = &k1->rtrmap;
+	struct xfs_rtrmap_key	*kp2 = &k2->rtrmap;
+	__u64			x, y;
+
+	x = be64_to_cpu(kp1->rm_startblock);
+	y = be64_to_cpu(kp2->rm_startblock);
+	if (x > y)
+		return 1;
+	else if (y > x)
+		return -1;
+
+	x = be64_to_cpu(kp1->rm_owner);
+	y = be64_to_cpu(kp2->rm_owner);
+	if (x > y)
+		return 1;
+	else if (y > x)
+		return -1;
+
+	x = XFS_RMAP_OFF(be64_to_cpu(kp1->rm_offset));
+	y = XFS_RMAP_OFF(be64_to_cpu(kp2->rm_offset));
+	if (x > y)
+		return 1;
+	else if (y > x)
+		return -1;
+	return 0;
+}
+
 static void *
 xfs_rtrmapbt_verify(
 	struct xfs_buf		*bp)
@@ -134,12 +405,60 @@ const struct xfs_buf_ops xfs_rtrmapbt_buf_ops = {
 	.verify_struct		= xfs_rtrmapbt_verify,
 };
 
+STATIC int
+xfs_rtrmapbt_keys_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	if (be64_to_cpu(k1->rtrmap.rm_startblock) <
+	    be64_to_cpu(k2->rtrmap.rm_startblock))
+		return 1;
+	if (be64_to_cpu(k1->rtrmap.rm_owner) <
+	    be64_to_cpu(k2->rtrmap.rm_owner))
+		return 1;
+	if (XFS_RMAP_OFF(be64_to_cpu(k1->rtrmap.rm_offset)) <=
+	    XFS_RMAP_OFF(be64_to_cpu(k2->rtrmap.rm_offset)))
+		return 1;
+	return 0;
+}
+
+STATIC int
+xfs_rtrmapbt_recs_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*r1,
+	union xfs_btree_rec	*r2)
+{
+	if (be64_to_cpu(r1->rtrmap.rm_startblock) <
+	    be64_to_cpu(r2->rtrmap.rm_startblock))
+		return 1;
+	if (XFS_RMAP_OFF(be64_to_cpu(r1->rtrmap.rm_offset)) <
+	    XFS_RMAP_OFF(be64_to_cpu(r2->rtrmap.rm_offset)))
+		return 1;
+	if (be64_to_cpu(r1->rtrmap.rm_owner) <=
+	    be64_to_cpu(r2->rtrmap.rm_owner))
+		return 1;
+	return 0;
+}
+
 static const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rtrmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rtrmap_key),
 
 	.dup_cursor		= xfs_rtrmapbt_dup_cursor,
+	.alloc_block		= xfs_rtrmapbt_alloc_block,
+	.free_block		= xfs_rtrmapbt_free_block,
+	.get_minrecs		= xfs_rtrmapbt_get_minrecs,
+	.get_maxrecs		= xfs_rtrmapbt_get_maxrecs,
+	.init_key_from_rec	= xfs_rtrmapbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
+	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_rtrmapbt_init_ptr_from_cur,
+	.key_diff		= xfs_rtrmapbt_key_diff,
 	.buf_ops		= &xfs_rtrmapbt_buf_ops,
+	.diff_two_keys		= xfs_rtrmapbt_diff_two_keys,
+	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
+	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
 };
 
 /*


Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C6E4C83FF
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:59:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2E75EAC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:33 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id BAZIZHaHt6slw1rt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:30 -0700 (PDT)
Subject: [PATCH 08/29] xfs: add realtime rmap btree operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:59:26 -0700
Message-ID: <147216956639.7022.7959437975156604082.stgit@birch.djwong.org>
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

Implement the generic btree operations needed to manipulate rtrmap
btree blocks. This is different from the regular rmapbt in that we
allocate space from the filesystem at large, and are neither
constrained to the free space nor any particular AG.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_rtrmap_btree.c |  319 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 319 insertions(+)


diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index c62e5c8..66c9190 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -31,10 +31,12 @@
 #include "xfs_trans.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
+#include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_ag_resv.h"
+#include "xfs_bmap.h"
 
 /*
  * Realtime Reverse map btree.
@@ -68,6 +70,275 @@ xfs_rtrmapbt_dup_cursor(
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
+	__uint64_t		off;
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
+STATIC __int64_t
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
+STATIC __int64_t
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
 static bool
 xfs_rtrmapbt_verify(
 	struct xfs_buf		*bp)
@@ -125,12 +396,60 @@ const struct xfs_buf_ops xfs_rtrmapbt_buf_ops = {
 	.verify_write		= xfs_rtrmapbt_write_verify,
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 641587D1C
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:59:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ABD9DAC005
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:59:31 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 1ayEqlm9lPsErU1J (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:59:28 -0700 (PDT)
Subject: [PATCH 30/47] xfs: add rmap btree operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:59:23 -0700
Message-ID: <146907716318.25461.166766599068910333.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Implement the generic btree operations needed to manipulate rmap
btree blocks. This is very similar to the per-ag freespace btree
implementation, and uses the AGFL for allocation and freeing of
blocks.

Adapt the rmap btree to store owner offsets within each rmap record,
and to handle the primary key being redefined as the tuple
[agblk, owner, offset].  The expansion of the primary key is crucial
to allowing multiple owners per extent.

v2: Don't double-invalidate a freed btree block, and fix a major
logic error in the inorder functions.

[darrick: adapt the btree ops to deal with offsets]
[darrick: remove init_rec_from_key]
[darrick: move unwritten bit to rm_offset]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_btree.h      |    1 
 fs/xfs/libxfs/xfs_rmap.c       |   96 ++++++++++++++
 fs/xfs/libxfs/xfs_rmap.h       |    9 +
 fs/xfs/libxfs/xfs_rmap_btree.c |  267 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h             |    3 
 5 files changed, 376 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 2a478b9..2695480 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -241,6 +241,7 @@ union xfs_btree_irec {
 	struct xfs_alloc_rec_incore	a;
 	struct xfs_bmbt_irec		b;
 	struct xfs_inobt_rec_incore	i;
+	struct xfs_rmap_irec		r;
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index b522bfc..ce29d6b 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -36,6 +36,102 @@
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
 
+/*
+ * Lookup the first record less than or equal to [bno, len, owner, offset]
+ * in the btree given by cur.
+ */
+int
+xfs_rmap_lookup_le(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	uint64_t		owner,
+	uint64_t		offset,
+	unsigned int		flags,
+	int			*stat)
+{
+	cur->bc_rec.r.rm_startblock = bno;
+	cur->bc_rec.r.rm_blockcount = len;
+	cur->bc_rec.r.rm_owner = owner;
+	cur->bc_rec.r.rm_offset = offset;
+	cur->bc_rec.r.rm_flags = flags;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+}
+
+/*
+ * Lookup the record exactly matching [bno, len, owner, offset]
+ * in the btree given by cur.
+ */
+int
+xfs_rmap_lookup_eq(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	uint64_t		owner,
+	uint64_t		offset,
+	unsigned int		flags,
+	int			*stat)
+{
+	cur->bc_rec.r.rm_startblock = bno;
+	cur->bc_rec.r.rm_blockcount = len;
+	cur->bc_rec.r.rm_owner = owner;
+	cur->bc_rec.r.rm_offset = offset;
+	cur->bc_rec.r.rm_flags = flags;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
+}
+
+/*
+ * Update the record referred to by cur to the value given
+ * by [bno, len, owner, offset].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int
+xfs_rmap_update(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*irec)
+{
+	union xfs_btree_rec	rec;
+
+	rec.rmap.rm_startblock = cpu_to_be32(irec->rm_startblock);
+	rec.rmap.rm_blockcount = cpu_to_be32(irec->rm_blockcount);
+	rec.rmap.rm_owner = cpu_to_be64(irec->rm_owner);
+	rec.rmap.rm_offset = cpu_to_be64(
+			xfs_rmap_irec_offset_pack(irec));
+	return xfs_btree_update(cur, &rec);
+}
+
+static int
+xfs_rmap_btrec_to_irec(
+	union xfs_btree_rec	*rec,
+	struct xfs_rmap_irec	*irec)
+{
+	irec->rm_flags = 0;
+	irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
+	irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
+	irec->rm_owner = be64_to_cpu(rec->rmap.rm_owner);
+	return xfs_rmap_irec_offset_unpack(be64_to_cpu(rec->rmap.rm_offset),
+			irec);
+}
+
+/*
+ * Get the data from the pointed-to record.
+ */
+int
+xfs_rmap_get_rec(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*irec,
+	int			*stat)
+{
+	union xfs_btree_rec	*rec;
+	int			error;
+
+	error = xfs_btree_get_rec(cur, &rec, stat);
+	if (error || !*stat)
+		return error;
+
+	return xfs_rmap_btrec_to_irec(rec, irec);
+}
+
 int
 xfs_rmap_free(
 	struct xfs_trans	*tp,
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index e7a6704..aa39a2a 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -142,4 +142,13 @@ int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
 		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
 		  struct xfs_owner_info *oinfo);
 
+int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, uint64_t owner, uint64_t offset,
+		unsigned int flags, int *stat);
+int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, uint64_t owner, uint64_t offset,
+		unsigned int flags, int *stat);
+int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
+		int *stat);
+
 #endif	/* __XFS_RMAP_H__ */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index a9ddc191..95cb964 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -29,12 +29,38 @@
 #include "xfs_trans.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
+#include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
 
+/*
+ * Reverse map btree.
+ *
+ * This is a per-ag tree used to track the owner(s) of a given extent. With
+ * reflink it is possible for there to be multiple owners, which is a departure
+ * from classic XFS. Owner records for data extents are inserted when the
+ * extent is mapped and removed when an extent is unmapped.  Owner records for
+ * all other block types (i.e. metadata) are inserted when an extent is
+ * allocated and removed when an extent is freed. There can only be one owner
+ * of a metadata extent, usually an inode or some other metadata structure like
+ * an AG btree.
+ *
+ * The rmap btree is part of the free space management, so blocks for the tree
+ * are sourced from the agfl. Hence we need transaction reservation support for
+ * this tree so that the freelist is always large enough. This also impacts on
+ * the minimum space we need to leave free in the AG.
+ *
+ * The tree is ordered by [ag block, owner, offset]. This is a large key size,
+ * but it is the only way to enforce unique keys when a block can be owned by
+ * multiple files at any offset. There's no need to order/search by extent
+ * size for online updating/management of the tree. It is intended that most
+ * reverse lookups will be to find the owner(s) of a particular block, or to
+ * try to recover tree and file data from corrupt primary metadata.
+ */
+
 static struct xfs_btree_cur *
 xfs_rmapbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
@@ -43,6 +69,172 @@ xfs_rmapbt_dup_cursor(
 			cur->bc_private.a.agbp, cur->bc_private.a.agno);
 }
 
+STATIC void
+xfs_rmapbt_set_root(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			inc)
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	int			btnum = cur->bc_btnum;
+	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
+
+	ASSERT(ptr->s != 0);
+
+	agf->agf_roots[btnum] = ptr->s;
+	be32_add_cpu(&agf->agf_levels[btnum], inc);
+	pag->pagf_levels[btnum] += inc;
+	xfs_perag_put(pag);
+
+	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
+}
+
+STATIC int
+xfs_rmapbt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			*stat)
+{
+	int			error;
+	xfs_agblock_t		bno;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+
+	/* Allocate the new block from the freelist. If we can't, give up.  */
+	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
+				       &bno, 1);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+		return error;
+	}
+
+	trace_xfs_rmapbt_alloc_block(cur->bc_mp, cur->bc_private.a.agno,
+			bno, 1);
+	if (bno == NULLAGBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+
+	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_private.a.agno, bno, 1,
+			false);
+
+	xfs_trans_agbtree_delta(cur->bc_tp, 1);
+	new->s = cpu_to_be32(bno);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+}
+
+STATIC int
+xfs_rmapbt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	xfs_agblock_t		bno;
+	int			error;
+
+	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
+	trace_xfs_rmapbt_free_block(cur->bc_mp, cur->bc_private.a.agno,
+			bno, 1);
+	error = xfs_alloc_put_freelist(cur->bc_tp, agbp, NULL, bno, 1);
+	if (error)
+		return error;
+
+	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
+			      XFS_EXTENT_BUSY_SKIP_DISCARD);
+	xfs_trans_agbtree_delta(cur->bc_tp, -1);
+
+	return 0;
+}
+
+STATIC int
+xfs_rmapbt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_rmap_mnr[level != 0];
+}
+
+STATIC int
+xfs_rmapbt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_rmap_mxr[level != 0];
+}
+
+STATIC void
+xfs_rmapbt_init_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	key->rmap.rm_startblock = rec->rmap.rm_startblock;
+	key->rmap.rm_owner = rec->rmap.rm_owner;
+	key->rmap.rm_offset = rec->rmap.rm_offset;
+}
+
+STATIC void
+xfs_rmapbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	rec->rmap.rm_startblock = cpu_to_be32(cur->bc_rec.r.rm_startblock);
+	rec->rmap.rm_blockcount = cpu_to_be32(cur->bc_rec.r.rm_blockcount);
+	rec->rmap.rm_owner = cpu_to_be64(cur->bc_rec.r.rm_owner);
+	rec->rmap.rm_offset = cpu_to_be64(
+			xfs_rmap_irec_offset_pack(&cur->bc_rec.r));
+}
+
+STATIC void
+xfs_rmapbt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+
+	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(agf->agf_roots[cur->bc_btnum] != 0);
+
+	ptr->s = agf->agf_roots[cur->bc_btnum];
+}
+
+STATIC __int64_t
+xfs_rmapbt_key_diff(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key)
+{
+	struct xfs_rmap_irec	*rec = &cur->bc_rec.r;
+	struct xfs_rmap_key	*kp = &key->rmap;
+	__u64			x, y;
+	__int64_t		d;
+
+	d = (__int64_t)be32_to_cpu(kp->rm_startblock) - rec->rm_startblock;
+	if (d)
+		return d;
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
 static bool
 xfs_rmapbt_verify(
 	struct xfs_buf		*bp)
@@ -117,12 +309,87 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.verify_write		= xfs_rmapbt_write_verify,
 };
 
+#if defined(DEBUG) || defined(XFS_WARN)
+STATIC int
+xfs_rmapbt_keys_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	__uint32_t		x;
+	__uint32_t		y;
+	__uint64_t		a;
+	__uint64_t		b;
+
+	x = be32_to_cpu(k1->rmap.rm_startblock);
+	y = be32_to_cpu(k2->rmap.rm_startblock);
+	if (x < y)
+		return 1;
+	else if (x > y)
+		return 0;
+	a = be64_to_cpu(k1->rmap.rm_owner);
+	b = be64_to_cpu(k2->rmap.rm_owner);
+	if (a < b)
+		return 1;
+	else if (a > b)
+		return 0;
+	a = XFS_RMAP_OFF(be64_to_cpu(k1->rmap.rm_offset));
+	b = XFS_RMAP_OFF(be64_to_cpu(k2->rmap.rm_offset));
+	if (a <= b)
+		return 1;
+	return 0;
+}
+
+STATIC int
+xfs_rmapbt_recs_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*r1,
+	union xfs_btree_rec	*r2)
+{
+	__uint32_t		x;
+	__uint32_t		y;
+	__uint64_t		a;
+	__uint64_t		b;
+
+	x = be32_to_cpu(r1->rmap.rm_startblock);
+	y = be32_to_cpu(r2->rmap.rm_startblock);
+	if (x < y)
+		return 1;
+	else if (x > y)
+		return 0;
+	a = be64_to_cpu(r1->rmap.rm_owner);
+	b = be64_to_cpu(r2->rmap.rm_owner);
+	if (a < b)
+		return 1;
+	else if (a > b)
+		return 0;
+	a = XFS_RMAP_OFF(be64_to_cpu(r1->rmap.rm_offset));
+	b = XFS_RMAP_OFF(be64_to_cpu(r2->rmap.rm_offset));
+	if (a <= b)
+		return 1;
+	return 0;
+}
+#endif	/* DEBUG */
+
 static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
 
 	.dup_cursor		= xfs_rmapbt_dup_cursor,
+	.set_root		= xfs_rmapbt_set_root,
+	.alloc_block		= xfs_rmapbt_alloc_block,
+	.free_block		= xfs_rmapbt_free_block,
+	.get_minrecs		= xfs_rmapbt_get_minrecs,
+	.get_maxrecs		= xfs_rmapbt_get_maxrecs,
+	.init_key_from_rec	= xfs_rmapbt_init_key_from_rec,
+	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_rmapbt_init_ptr_from_cur,
+	.key_diff		= xfs_rmapbt_key_diff,
 	.buf_ops		= &xfs_rmapbt_buf_ops,
+#if defined(DEBUG) || defined(XFS_WARN)
+	.keys_inorder		= xfs_rmapbt_keys_inorder,
+	.recs_inorder		= xfs_rmapbt_recs_inorder,
+#endif
 
 	.get_leaf_keys		= xfs_btree_get_leaf_keys_overlapped,
 	.get_node_keys		= xfs_btree_get_node_keys_overlapped,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4c3418b..e69912a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2502,6 +2502,9 @@ DEFINE_RMAP_EVENT(xfs_rmap_map);
 DEFINE_RMAP_EVENT(xfs_rmap_map_done);
 DEFINE_AG_ERROR_EVENT(xfs_rmap_map_error);
 
+DEFINE_BUSY_EVENT(xfs_rmapbt_alloc_block);
+DEFINE_BUSY_EVENT(xfs_rmapbt_free_block);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

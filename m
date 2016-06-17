Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 55654810B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:34:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25CEC304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:34:42 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id YbmrWiU5qiW247FU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:34:39 -0700 (PDT)
Subject: [PATCH 036/145] xfs: add rmap btree operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:34:31 -0700
Message-ID: <146612727120.16048.13165169801894764616.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Implement the generic btree operations needed to manipulate rmap
btree blocks. This is very similar to the per-ag freespace btree
implementation, and uses the AGFL for allocation and freeing of
blocks.

Adapt the rmap btree to store owner offsets within each rmap record,
and to handle the primary key being redefined as the tuple
[agblk, owner, offset].  The expansion of the primary key is crucial
to allowing multiple owners per extent.

[darrick: adapt the btree ops to deal with offsets]
[darrick: remove init_rec_from_key]
[darrick: move unwritten bit to rm_offset]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 include/xfs_trace.h     |    2 
 libxfs/xfs_btree.h      |    1 
 libxfs/xfs_rmap.c       |   96 +++++++++++++++++++
 libxfs/xfs_rmap_btree.c |  243 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap_btree.h |    9 ++
 5 files changed, 351 insertions(+)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index b4174a3..af3f68b 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -192,6 +192,8 @@
 #define trace_xfs_rmap_alloc_extent_error(...)	((void) 0)
 #define trace_xfs_rmap_alloc_extent_done(...)	((void) 0)
 #define trace_xfs_rmap_free_extent_done(...)	((void) 0)
+#define trace_xfs_rmapbt_free_block(...)	((void) 0)
+#define trace_xfs_rmapbt_alloc_block(...)	((void) 0)
 
 /* set c = c to avoid unused var warnings */
 #define trace_xfs_perag_get(a,b,c,d)	((c) = (c))
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 90ea2a7..9963c48 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -216,6 +216,7 @@ union xfs_btree_irec {
 	xfs_alloc_rec_incore_t		a;
 	xfs_bmbt_irec_t			b;
 	xfs_inobt_rec_incore_t		i;
+	struct xfs_rmap_irec		r;
 };
 
 /*
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 31c6336..5034fd3 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -35,6 +35,102 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 
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
+xfs_rmapbt_btrec_to_irec(
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
+	return xfs_rmapbt_btrec_to_irec(rec, irec);
+}
+
 int
 xfs_rmap_free(
 	struct xfs_trans	*tp,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 02636f6..c8fd99e 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -33,6 +33,31 @@
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 
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
@@ -41,6 +66,173 @@ xfs_rmapbt_dup_cursor(
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
+	xfs_trans_binval(cur->bc_tp, bp);
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
@@ -115,12 +307,63 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.verify_write		= xfs_rmapbt_write_verify,
 };
 
+#if defined(DEBUG) || defined(XFS_WARN)
+STATIC int
+xfs_rmapbt_keys_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	if (be32_to_cpu(k1->rmap.rm_startblock) <
+	    be32_to_cpu(k2->rmap.rm_startblock))
+		return 1;
+	if (be64_to_cpu(k1->rmap.rm_owner) <
+	    be64_to_cpu(k2->rmap.rm_owner))
+		return 1;
+	if (XFS_RMAP_OFF(be64_to_cpu(k1->rmap.rm_offset)) <=
+	    XFS_RMAP_OFF(be64_to_cpu(k2->rmap.rm_offset)))
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
+	if (be32_to_cpu(r1->rmap.rm_startblock) <
+	    be32_to_cpu(r2->rmap.rm_startblock))
+		return 1;
+	if (XFS_RMAP_OFF(be64_to_cpu(r1->rmap.rm_offset)) <
+	    XFS_RMAP_OFF(be64_to_cpu(r2->rmap.rm_offset)))
+		return 1;
+	if (be64_to_cpu(r1->rmap.rm_owner) <=
+	    be64_to_cpu(r2->rmap.rm_owner))
+		return 1;
+	return 0;
+}
+#endif	/* DEBUG */
+
 static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= sizeof(struct xfs_rmap_key),
 
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
 };
 
 /*
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index 462767f..17fa383 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -52,6 +52,15 @@ struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
 int xfs_rmapbt_maxrecs(struct xfs_mount *mp, int blocklen, int leaf);
 extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
 
+int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, uint64_t owner, uint64_t offset,
+		unsigned int flags, int *stat);
+int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, uint64_t owner, uint64_t offset,
+		unsigned int flags, int *stat);
+int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
+		int *stat);
+
 int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
 		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
 		   struct xfs_owner_info *oinfo);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

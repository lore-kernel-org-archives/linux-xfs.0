Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B66757FBF
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:58:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3BCEAAC004
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:58:40 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id BYoCNkJxj2IujHbc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:58:37 -0800 (PST)
Subject: [PATCH 20/76] xfs: add rmap btree operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:58:34 -0800
Message-ID: <20151219085834.12713.42258.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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

>From : Dave Chinner <dchinner@redhat.com>

Implement the generic btree operations needed to manipulate rmap
btree blocks. This is very similar to the per-ag freespace btree
implementation, and uses the AGFL for allocation and freeing of
blocks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.h      |    1 
 fs/xfs/libxfs/xfs_rmap.c       |   58 +++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.c |  204 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 263 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index f7a049b..35e7754 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -212,6 +212,7 @@ typedef struct xfs_btree_cur
 		xfs_alloc_rec_incore_t	a;
 		xfs_bmbt_irec_t		b;
 		xfs_inobt_rec_incore_t	i;
+		struct xfs_rmap_irec	r;
 	}		bc_rec;		/* current insert/search record value */
 	struct xfs_buf	*bc_bufs[XFS_BTREE_MAXLEVELS];	/* buf ptr per level */
 	int		bc_ptrs[XFS_BTREE_MAXLEVELS];	/* key/record # */
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 3e17294..64b2525 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -36,6 +36,64 @@
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
 
+/*
+ * Lookup the first record less than or equal to [bno, len]
+ * in the btree given by cur.
+ */
+STATIC int
+xfs_rmap_lookup_le(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	uint64_t		owner,
+	int			*stat)
+{
+	cur->bc_rec.r.rm_startblock = bno;
+	cur->bc_rec.r.rm_blockcount = len;
+	cur->bc_rec.r.rm_owner = owner;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+}
+
+/*
+ * Update the record referred to by cur to the value given
+ * by [bno, len, ref].
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
+	return xfs_btree_update(cur, &rec);
+}
+
+/*
+ * Get the data from the pointed-to record.
+ */
+STATIC int
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
+	irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
+	irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
+	irec->rm_owner = be64_to_cpu(rec->rmap.rm_owner);
+	return 0;
+}
+
 int
 xfs_rmap_free(
 	struct xfs_trans	*tp,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 5671771..58bdac3 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -34,6 +34,26 @@
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
 
+/*
+ * Reverse map btree.
+ *
+ * This is a per-ag tree used to track the owner of a given extent. Owner
+ * records are inserted when an extent is allocated, and removed when an extent
+ * is freed. There can only be one owner of an extent, usually an inode or some
+ * other metadata structure like a AG btree.
+ *
+ * The rmap btree is part of the free space management, so blocks for the tree
+ * are sourced from the agfl. Hence we need transaction reservation support for
+ * this tree so that the freelist is always large enough. This also impacts on
+ * the minimum space we need to leave free in the AG.
+ *
+ * The tree is ordered by block number - there's no need to order/search by
+ * extent size for online updating/management of the tree, and the reverse
+ * lookups are going to be "who owns this block" and so are by-block ordering is
+ * perfect for this.
+ *
+ */
+
 static struct xfs_btree_cur *
 xfs_rmapbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
@@ -42,6 +62,153 @@ xfs_rmapbt_dup_cursor(
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
+	if (bno == NULLAGBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+
+	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_private.a.agno, bno, 1, false);
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
+}
+
+STATIC void
+xfs_rmapbt_init_rec_from_key(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	rec->rmap.rm_startblock = key->rmap.rm_startblock;
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
+
+	return (__int64_t)be32_to_cpu(kp->rm_startblock) - rec->rm_startblock;
+}
+
 static bool
 xfs_rmapbt_verify(
 	struct xfs_buf		*bp)
@@ -133,12 +300,49 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.verify_write = xfs_rmapbt_write_verify,
 };
 
+#if defined(DEBUG) || defined(XFS_WARN)
+STATIC int
+xfs_rmapbt_keys_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return be32_to_cpu(k1->rmap.rm_startblock) <
+	       be32_to_cpu(k2->rmap.rm_startblock);
+}
+
+STATIC int
+xfs_rmapbt_recs_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*r1,
+	union xfs_btree_rec	*r2)
+{
+	return be32_to_cpu(r1->rmap.rm_startblock) +
+		be32_to_cpu(r1->rmap.rm_blockcount) <=
+		be32_to_cpu(r2->rmap.rm_startblock);
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
+	.init_rec_from_key	= xfs_rmapbt_init_rec_from_key,
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

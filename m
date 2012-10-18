Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9I4mxUs147146 for <xfs@oss.sgi.com>; Wed, 17 Oct 2012 23:48:59 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GYUdie0nBk11s2Qc for <xfs@oss.sgi.com>;
	Wed, 17 Oct 2012 21:50:32 -0700 (PDT)
Date: Thu, 18 Oct 2012 15:50:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 24/23] xfs: convert buffer verifiers to an ops structure.
Message-ID: <20121018045028.GQ2739@dastard>
References: <1350020669-19504-1-git-send-email-david@fromorbit.com>
	<1350020669-19504-23-git-send-email-david@fromorbit.com>
	<20121013160212.GA24337@infradead.org>
	<20121014001219.GR2739@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121014001219.GR2739@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Oct 14, 2012 at 11:12:19AM +1100, Dave Chinner wrote:
> On Sat, Oct 13, 2012 at 12:02:12PM -0400, Christoph Hellwig wrote:
> > > +xfs_agfl_write_verify(
> > > +	struct xfs_buf	*bp)
> > > +{
> > > +	xfs_agfl_verify(bp);
> > > +}
> > > +
> > > +void
> > > +xfs_agfl_read_verify(
> > > +	struct xfs_buf	*bp)
> > > +{
> > > +	xfs_agfl_verify(bp);
> > > +	bp->b_pre_io = xfs_agfl_write_verify;
> > >  	bp->b_iodone = NULL;
> > >  	xfs_buf_ioend(bp, 0);
> > 
> > I have to say I hate the way the API works for the buffer callbacks
> > even more now that I see the write side.  I know you're a bit annoyed
> > about churn from review requests, but I'd really prefer if this
> > was redone.
.....
> >    of it it might make sense to have two callbacks, but I'd
> >    again prefer to not overload b_iodone.  Maybe just pass a:
> > 
> > struct xfs_buf_ops {
> > 	int (*verify_read)(struct xfs_buf *);
> > 	int (*verify_write)(struct xfs_buf *);
> > };
> >
> > to all the buffer read/write API calls, and let that deal with it.
> 
> This was the other option I considered (and would prefer), but again
> had the issue of having to determine the write verifier at the time
> of the get_buf call. The write verifiers are much harder to get
> right, because we change the format of buffers all the time in the
> directory code (e.g. leaf -> block, node -> leaf, etc) and that
> means write verifiers have to be changed along with the magic number
> of the buffer.
> 
> However, now that I have solved that problem, I can go back and
> review how much of an issue it really is when it comes to using an
> ops structure. It's probably less of a concern than I thought
> initially, because now I actually know exactly what is needed in the
> dir/attr code.
> 
> FWIW, one thing I'll look at doing is adding a patch on top of this
> patch set to convert it to an ops structure, rather than rewriting
> the patch set from the ground up. It will be much faster to do that
> than rewrite the 20-odd patches in this series again....

Here's a patch that does this. It adds on top of the series, and
points out more changes needed to growfs to support CRC checking
properly.

-- 
Dave Chinner
david@fromorbit.com

xfs: convert buffer verifiers to an ops structure.

From: Dave Chinner <dchinner@redhat.com>

To separate the verifiers from iodone functions and associate read
and write verifiers at the same time, introduce a buffer verifier
operations structure to the xfs_buf.

This avoids the need for assigning the write verifier, clearing the
iodone function and re-running ioend processing in the read
verifier, and gets rid of the nasty "b_pre_io" name for the write
verifier function pointer. If we ever need to, it will also be
easier to add further content specific callbacks to a buffer with an
ops structure in place.

We also avoid needing to export verifier functions, instead we
can simply export the ops structures for those that are needed
outside the function they are defined in.

This patch also fixes a directory block readahead verifier issue
it exposed.

This patch also adds ops callbacks to the inode/alloc btree blocks
initialised by growfs. These will need more work before they will
work with CRCs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ag.h           |    4 +++
 fs/xfs/xfs_alloc.c        |   33 +++++++++++++-----------
 fs/xfs/xfs_alloc.h        |    2 +-
 fs/xfs/xfs_alloc_btree.c  |   18 +++++++------
 fs/xfs/xfs_alloc_btree.h  |    2 ++
 fs/xfs/xfs_attr_leaf.c    |   19 +++++++-------
 fs/xfs/xfs_attr_leaf.h    |    3 ++-
 fs/xfs/xfs_bmap.c         |   22 ++++++++--------
 fs/xfs/xfs_bmap_btree.c   |   20 +++++++-------
 fs/xfs/xfs_bmap_btree.h   |    3 +--
 fs/xfs/xfs_btree.c        |   26 +++++++++----------
 fs/xfs/xfs_btree.h        |    9 +++----
 fs/xfs/xfs_buf.c          |   63 ++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_buf.h          |   24 ++++++++++-------
 fs/xfs/xfs_da_btree.c     |   28 ++++++++++----------
 fs/xfs/xfs_da_btree.h     |    4 +--
 fs/xfs/xfs_dir2_block.c   |   20 +++++++-------
 fs/xfs/xfs_dir2_data.c    |   52 ++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_dir2_leaf.c    |   36 ++++++++++++++------------
 fs/xfs/xfs_dir2_node.c    |   26 ++++++++++---------
 fs/xfs/xfs_dir2_priv.h    |   10 ++++---
 fs/xfs/xfs_dquot.c        |   16 +++++++-----
 fs/xfs/xfs_fsops.c        |   26 ++++++++++++++++---
 fs/xfs/xfs_ialloc.c       |   18 +++++++------
 fs/xfs/xfs_ialloc.h       |    2 +-
 fs/xfs/xfs_ialloc_btree.c |   17 ++++++------
 fs/xfs/xfs_ialloc_btree.h |    2 ++
 fs/xfs/xfs_inode.c        |   22 +++++++++-------
 fs/xfs/xfs_inode.h        |    3 +--
 fs/xfs/xfs_itable.c       |    2 +-
 fs/xfs/xfs_log_recover.c  |    2 +-
 fs/xfs/xfs_mount.c        |   19 ++++++++------
 fs/xfs/xfs_mount.h        |    4 +--
 fs/xfs/xfs_trans.h        |    6 ++---
 fs/xfs/xfs_trans_buf.c    |    8 +++---
 35 files changed, 339 insertions(+), 232 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 44d65c1..48c873a 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -108,6 +108,8 @@ typedef struct xfs_agf {
 extern int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
 
+extern const struct xfs_buf_ops xfs_agf_buf_ops;
+
 /*
  * Size of the unlinked inode hash table in the agi.
  */
@@ -161,6 +163,8 @@ typedef struct xfs_agi {
 extern int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 				xfs_agnumber_t agno, struct xfs_buf **bpp);
 
+extern const struct xfs_buf_ops xfs_agi_buf_ops;
+
 /*
  * The third a.g. block contains the a.g. freelist, an array
  * of block pointers to blocks owned by the allocation btree code.
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 7ac8965..a8de9fd 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -445,29 +445,30 @@ xfs_agfl_verify(
 	}
 
 	if (!agfl_ok) {
-		XFS_CORRUPTION_ERROR("xfs_agfl_read_verify",
-				     XFS_ERRLEVEL_LOW, mp, agfl);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, agfl);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
 }
 
 static void
-xfs_agfl_write_verify(
+xfs_agfl_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_agfl_verify(bp);
 }
 
 static void
-xfs_agfl_read_verify(
+xfs_agfl_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_agfl_verify(bp);
-	bp->b_pre_io = xfs_agfl_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+static const struct xfs_buf_ops xfs_agfl_buf_ops = {
+	.verify_read = xfs_agfl_read_verify,
+	.verify_write = xfs_agfl_write_verify,
+};
+
 /*
  * Read in the allocation group free block array.
  */
@@ -485,7 +486,7 @@ xfs_alloc_read_agfl(
 	error = xfs_trans_read_buf(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, &bp, xfs_agfl_read_verify);
+			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
 	if (error)
 		return error;
 	ASSERT(!xfs_buf_geterror(bp));
@@ -2159,23 +2160,25 @@ xfs_agf_verify(
 	}
 }
 
-void
-xfs_agf_write_verify(
+static void
+xfs_agf_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_agf_verify(bp);
 }
 
 static void
-xfs_agf_read_verify(
+xfs_agf_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_agf_verify(bp);
-	bp->b_pre_io = xfs_agf_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+const struct xfs_buf_ops xfs_agf_buf_ops = {
+	.verify_read = xfs_agf_read_verify,
+	.verify_write = xfs_agf_write_verify,
+};
+
 /*
  * Read in the allocation group header (free/alloc section).
  */
@@ -2193,7 +2196,7 @@ xfs_read_agf(
 	error = xfs_trans_read_buf(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), flags, bpp, xfs_agf_read_verify);
+			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
 	if (error)
 		return error;
 	if (!*bpp)
diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index 4b6c2c4..aaf7ff1 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -231,6 +231,6 @@ xfs_alloc_get_rec(
 	xfs_extlen_t		*len,	/* output: length of extent */
 	int			*stat);	/* output: success/failure */
 
-void xfs_agf_write_verify(struct xfs_buf *bp);
+extern const struct xfs_buf_ops xfs_agf_buf_ops;
 
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index 7f8e704..b14ff21 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -317,22 +317,25 @@ xfs_allocbt_verify(
 }
 
 static void
-xfs_allocbt_write_verify(
+xfs_allocbt_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_allocbt_verify(bp);
 }
 
-void
-xfs_allocbt_read_verify(
+static void
+xfs_allocbt_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_allocbt_verify(bp);
-	bp->b_pre_io = xfs_allocbt_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+const struct xfs_buf_ops xfs_allocbt_buf_ops = {
+	.verify_read = xfs_allocbt_read_verify,
+	.verify_write = xfs_allocbt_write_verify,
+};
+
+
 #ifdef DEBUG
 STATIC int
 xfs_allocbt_keys_inorder(
@@ -388,8 +391,7 @@ static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.key_diff		= xfs_allocbt_key_diff,
-	.read_verify		= xfs_allocbt_read_verify,
-	.write_verify		= xfs_allocbt_write_verify,
+	.buf_ops		= &xfs_allocbt_buf_ops,
 #ifdef DEBUG
 	.keys_inorder		= xfs_allocbt_keys_inorder,
 	.recs_inorder		= xfs_allocbt_recs_inorder,
diff --git a/fs/xfs/xfs_alloc_btree.h b/fs/xfs/xfs_alloc_btree.h
index 359fb86..7e89a2b 100644
--- a/fs/xfs/xfs_alloc_btree.h
+++ b/fs/xfs/xfs_alloc_btree.h
@@ -93,4 +93,6 @@ extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		xfs_agnumber_t, xfs_btnum_t);
 extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
 
+extern const struct xfs_buf_ops xfs_allocbt_buf_ops;
+
 #endif	/* __XFS_ALLOC_BTREE_H__ */
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 5d56886..d790860 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -103,22 +103,23 @@ xfs_attr_leaf_verify(
 }
 
 static void
-xfs_attr_leaf_write_verify(
+xfs_attr_leaf_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_attr_leaf_verify(bp);
 }
 
-void
-xfs_attr_leaf_read_verify(
+static void
+xfs_attr_leaf_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_attr_leaf_verify(bp);
-	bp->b_pre_io = xfs_attr_leaf_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+const struct xfs_buf_ops xfs_attr_leaf_buf_ops = {
+	.verify_read = xfs_attr_leaf_read_verify,
+	.verify_write = xfs_attr_leaf_write_verify,
+};
 
 int
 xfs_attr_leaf_read(
@@ -129,7 +130,7 @@ xfs_attr_leaf_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
-				XFS_ATTR_FORK, xfs_attr_leaf_read_verify);
+				XFS_ATTR_FORK, &xfs_attr_leaf_buf_ops);
 }
 
 /*========================================================================
@@ -923,7 +924,7 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
 					    XFS_ATTR_FORK);
 	if (error)
 		goto out;
-	bp2->b_pre_io = bp1->b_pre_io;
+	bp2->b_ops = bp1->b_ops;
 	memcpy(bp2->b_addr, bp1->b_addr, XFS_LBSIZE(dp->i_mount));
 	bp1 = NULL;
 	xfs_trans_log_buf(args->trans, bp2, 0, XFS_LBSIZE(dp->i_mount) - 1);
@@ -977,7 +978,7 @@ xfs_attr_leaf_create(
 					    XFS_ATTR_FORK);
 	if (error)
 		return(error);
-	bp->b_pre_io = xfs_attr_leaf_write_verify;
+	bp->b_ops = &xfs_attr_leaf_buf_ops;
 	leaf = bp->b_addr;
 	memset((char *)leaf, 0, XFS_LBSIZE(dp->i_mount));
 	hdr = &leaf->hdr;
diff --git a/fs/xfs/xfs_attr_leaf.h b/fs/xfs/xfs_attr_leaf.h
index 3bbf627..77de139 100644
--- a/fs/xfs/xfs_attr_leaf.h
+++ b/fs/xfs/xfs_attr_leaf.h
@@ -264,6 +264,7 @@ int	xfs_attr_leaf_newentsize(int namelen, int valuelen, int blocksize,
 int	xfs_attr_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			struct xfs_buf **bpp);
-void	xfs_attr_leaf_read_verify(struct xfs_buf *bp);
+
+extern const struct xfs_buf_ops xfs_attr_leaf_buf_ops;
 
 #endif	/* __XFS_ATTR_LEAF_H__ */
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index fe5438b..4fb8276 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -2663,7 +2663,7 @@ xfs_bmap_btree_to_extents(
 		return error;
 #endif
 	error = xfs_btree_read_bufl(mp, tp, cbno, 0, &cbp, XFS_BMAP_BTREE_REF,
-				xfs_bmbt_read_verify);
+				&xfs_bmbt_buf_ops);
 	if (error)
 		return error;
 	cblock = XFS_BUF_TO_BLOCK(cbp);
@@ -3124,7 +3124,7 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the child block.
 	 */
-	abp->b_pre_io = xfs_bmbt_write_verify;
+	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
 	ablock->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
 	ablock->bb_level = 0;
@@ -3271,7 +3271,7 @@ xfs_bmap_local_to_extents(
 		ASSERT(args.len == 1);
 		*firstblock = args.fsbno;
 		bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno, 0);
-		bp->b_pre_io = xfs_bmbt_write_verify;
+		bp->b_ops = &xfs_bmbt_buf_ops;
 		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
 		xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
 		xfs_bmap_forkoff_reset(args.mp, ip, whichfork);
@@ -4082,7 +4082,7 @@ xfs_bmap_read_extents(
 	 */
 	while (level-- > 0) {
 		error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
-				XFS_BMAP_BTREE_REF, xfs_bmbt_read_verify);
+				XFS_BMAP_BTREE_REF, &xfs_bmbt_buf_ops);
 		if (error)
 			return error;
 		block = XFS_BUF_TO_BLOCK(bp);
@@ -4129,7 +4129,7 @@ xfs_bmap_read_extents(
 		nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
 		if (nextbno != NULLFSBLOCK)
 			xfs_btree_reada_bufl(mp, nextbno, 1,
-					     xfs_bmbt_read_verify);
+					     &xfs_bmbt_buf_ops);
 		/*
 		 * Copy records into the extent records.
 		 */
@@ -4162,7 +4162,7 @@ xfs_bmap_read_extents(
 		if (bno == NULLFSBLOCK)
 			break;
 		error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
-				XFS_BMAP_BTREE_REF, xfs_bmbt_read_verify);
+				XFS_BMAP_BTREE_REF, &xfs_bmbt_buf_ops);
 		if (error)
 			return error;
 		block = XFS_BUF_TO_BLOCK(bp);
@@ -5880,7 +5880,7 @@ xfs_bmap_check_leaf_extents(
 			bp_release = 1;
 			error = xfs_btree_read_bufl(mp, NULL, bno, 0, &bp,
 						XFS_BMAP_BTREE_REF,
-						xfs_bmbt_read_verify);
+						&xfs_bmbt_buf_ops);
 			if (error)
 				goto error_norelse;
 		}
@@ -5966,7 +5966,7 @@ xfs_bmap_check_leaf_extents(
 			bp_release = 1;
 			error = xfs_btree_read_bufl(mp, NULL, bno, 0, &bp,
 						XFS_BMAP_BTREE_REF,
-						xfs_bmbt_read_verify);
+						&xfs_bmbt_buf_ops);
 			if (error)
 				goto error_norelse;
 		}
@@ -6061,7 +6061,7 @@ xfs_bmap_count_tree(
 	int			numrecs;
 
 	error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp, XFS_BMAP_BTREE_REF,
-						xfs_bmbt_read_verify);
+						&xfs_bmbt_buf_ops);
 	if (error)
 		return error;
 	*count += 1;
@@ -6073,7 +6073,7 @@ xfs_bmap_count_tree(
 		while (nextbno != NULLFSBLOCK) {
 			error = xfs_btree_read_bufl(mp, tp, nextbno, 0, &nbp,
 						XFS_BMAP_BTREE_REF,
-						xfs_bmbt_read_verify);
+						&xfs_bmbt_buf_ops);
 			if (error)
 				return error;
 			*count += 1;
@@ -6105,7 +6105,7 @@ xfs_bmap_count_tree(
 			bno = nextbno;
 			error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
 						XFS_BMAP_BTREE_REF,
-						xfs_bmbt_read_verify);
+						&xfs_bmbt_buf_ops);
 			if (error)
 				return error;
 			*count += 1;
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index 79758e1..061b45c 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -749,23 +749,26 @@ xfs_bmbt_verify(
 	}
 }
 
-void
-xfs_bmbt_write_verify(
+static void
+xfs_bmbt_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_bmbt_verify(bp);
 }
 
-void
-xfs_bmbt_read_verify(
+static void
+xfs_bmbt_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_bmbt_verify(bp);
-	bp->b_pre_io = xfs_bmbt_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+const struct xfs_buf_ops xfs_bmbt_buf_ops = {
+	.verify_read = xfs_bmbt_read_verify,
+	.verify_write = xfs_bmbt_write_verify,
+};
+
+
 #ifdef DEBUG
 STATIC int
 xfs_bmbt_keys_inorder(
@@ -805,8 +808,7 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
-	.read_verify		= xfs_bmbt_read_verify,
-	.write_verify		= xfs_bmbt_write_verify,
+	.buf_ops		= &xfs_bmbt_buf_ops,
 #ifdef DEBUG
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
index 938c859..88469ca 100644
--- a/fs/xfs/xfs_bmap_btree.h
+++ b/fs/xfs/xfs_bmap_btree.h
@@ -232,11 +232,10 @@ extern void xfs_bmbt_to_bmdr(struct xfs_mount *, struct xfs_btree_block *, int,
 extern int xfs_bmbt_get_maxrecs(struct xfs_btree_cur *, int level);
 extern int xfs_bmdr_maxrecs(struct xfs_mount *, int blocklen, int leaf);
 extern int xfs_bmbt_maxrecs(struct xfs_mount *, int blocklen, int leaf);
-extern void xfs_bmbt_read_verify(struct xfs_buf *bp);
-extern void xfs_bmbt_write_verify(struct xfs_buf *bp);
 
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
 
+extern const struct xfs_buf_ops xfs_bmbt_buf_ops;
 
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 1ccd42b..79039fa 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -271,7 +271,7 @@ xfs_btree_dup_cursor(
 			error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 						   XFS_BUF_ADDR(bp), mp->m_bsize,
 						   0, &bp,
-						   cur->bc_ops->read_verify);
+						   cur->bc_ops->buf_ops);
 			if (error) {
 				xfs_btree_del_cursor(new, error);
 				*ncur = NULL;
@@ -621,7 +621,7 @@ xfs_btree_read_bufl(
 	uint			lock,		/* lock flags for read_buf */
 	struct xfs_buf		**bpp,		/* buffer for fsbno */
 	int			refval,		/* ref count value for buffer */
-	xfs_buf_iodone_t	verify)
+	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;		/* return value */
 	xfs_daddr_t		d;		/* real disk block address */
@@ -630,7 +630,7 @@ xfs_btree_read_bufl(
 	ASSERT(fsbno != NULLFSBLOCK);
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, d,
-				   mp->m_bsize, lock, &bp, verify);
+				   mp->m_bsize, lock, &bp, ops);
 	if (error)
 		return error;
 	ASSERT(!xfs_buf_geterror(bp));
@@ -650,13 +650,13 @@ xfs_btree_reada_bufl(
 	struct xfs_mount	*mp,		/* file system mount point */
 	xfs_fsblock_t		fsbno,		/* file system block number */
 	xfs_extlen_t		count,		/* count of filesystem blocks */
-	xfs_buf_iodone_t	verify)
+	const struct xfs_buf_ops *ops)
 {
 	xfs_daddr_t		d;
 
 	ASSERT(fsbno != NULLFSBLOCK);
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
-	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, verify);
+	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, ops);
 }
 
 /*
@@ -670,14 +670,14 @@ xfs_btree_reada_bufs(
 	xfs_agnumber_t		agno,		/* allocation group number */
 	xfs_agblock_t		agbno,		/* allocation group block number */
 	xfs_extlen_t		count,		/* count of filesystem blocks */
-	xfs_buf_iodone_t	verify)
+	const struct xfs_buf_ops *ops)
 {
 	xfs_daddr_t		d;
 
 	ASSERT(agno != NULLAGNUMBER);
 	ASSERT(agbno != NULLAGBLOCK);
 	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
-	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, verify);
+	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, ops);
 }
 
 STATIC int
@@ -692,13 +692,13 @@ xfs_btree_readahead_lblock(
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLDFSBNO) {
 		xfs_btree_reada_bufl(cur->bc_mp, left, 1,
-				     cur->bc_ops->read_verify);
+				     cur->bc_ops->buf_ops);
 		rval++;
 	}
 
 	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLDFSBNO) {
 		xfs_btree_reada_bufl(cur->bc_mp, right, 1,
-				     cur->bc_ops->read_verify);
+				     cur->bc_ops->buf_ops);
 		rval++;
 	}
 
@@ -718,13 +718,13 @@ xfs_btree_readahead_sblock(
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLAGBLOCK) {
 		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
-				     left, 1, cur->bc_ops->read_verify);
+				     left, 1, cur->bc_ops->buf_ops);
 		rval++;
 	}
 
 	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLAGBLOCK) {
 		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
-				     right, 1, cur->bc_ops->read_verify);
+				     right, 1, cur->bc_ops->buf_ops);
 		rval++;
 	}
 
@@ -981,7 +981,7 @@ xfs_btree_get_buf_block(
 	if (!*bpp)
 		return ENOMEM;
 
-	(*bpp)->b_pre_io = cur->bc_ops->write_verify;
+	(*bpp)->b_ops = cur->bc_ops->buf_ops;
 	*block = XFS_BUF_TO_BLOCK(*bpp);
 	return 0;
 }
@@ -1009,7 +1009,7 @@ xfs_btree_read_buf_block(
 	d = xfs_btree_ptr_to_daddr(cur, ptr);
 	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
 				   mp->m_bsize, flags, bpp,
-				   cur->bc_ops->read_verify);
+				   cur->bc_ops->buf_ops);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index 2ac403a..c7f187a 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
@@ -188,8 +188,7 @@ struct xfs_btree_ops {
 	__int64_t (*key_diff)(struct xfs_btree_cur *cur,
 			      union xfs_btree_key *key);
 
-	void	(*read_verify)(struct xfs_buf *bp);
-	void	(*write_verify)(struct xfs_buf *bp);
+	const struct xfs_buf_ops	*buf_ops;
 
 #ifdef DEBUG
 	/* check that k1 is lower than k2 */
@@ -359,7 +358,7 @@ xfs_btree_read_bufl(
 	uint			lock,	/* lock flags for read_buf */
 	struct xfs_buf		**bpp,	/* buffer for fsbno */
 	int			refval,	/* ref count value for buffer */
-	xfs_buf_iodone_t	verify);
+	const struct xfs_buf_ops *ops);
 
 /*
  * Read-ahead the block, don't wait for it, don't return a buffer.
@@ -370,7 +369,7 @@ xfs_btree_reada_bufl(
 	struct xfs_mount	*mp,	/* file system mount point */
 	xfs_fsblock_t		fsbno,	/* file system block number */
 	xfs_extlen_t		count,	/* count of filesystem blocks */
-	xfs_buf_iodone_t	verify);
+	const struct xfs_buf_ops *ops);
 
 /*
  * Read-ahead the block, don't wait for it, don't return a buffer.
@@ -382,7 +381,7 @@ xfs_btree_reada_bufs(
 	xfs_agnumber_t		agno,	/* allocation group number */
 	xfs_agblock_t		agbno,	/* allocation group block number */
 	xfs_extlen_t		count,	/* count of filesystem blocks */
-	xfs_buf_iodone_t	verify);
+	const struct xfs_buf_ops *ops);
 
 
 /*
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index c073236..aacd017 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -571,7 +571,7 @@ found:
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
 		ASSERT(bp->b_iodone == NULL);
 		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
-		bp->b_pre_io = NULL;
+		bp->b_ops = NULL;
 	}
 
 	trace_xfs_buf_find(bp, flags, _RET_IP_);
@@ -657,7 +657,7 @@ xfs_buf_read_map(
 	struct xfs_buf_map	*map,
 	int			nmaps,
 	xfs_buf_flags_t		flags,
-	xfs_buf_iodone_t	verify)
+	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
 
@@ -669,7 +669,7 @@ xfs_buf_read_map(
 
 		if (!XFS_BUF_ISDONE(bp)) {
 			XFS_STATS_INC(xb_get_read);
-			bp->b_iodone = verify;
+			bp->b_ops = ops;
 			_xfs_buf_read(bp, flags);
 		} else if (flags & XBF_ASYNC) {
 			/*
@@ -696,13 +696,13 @@ xfs_buf_readahead_map(
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
-	xfs_buf_iodone_t	verify)
+	const struct xfs_buf_ops *ops)
 {
 	if (bdi_read_congested(target->bt_bdi))
 		return;
 
 	xfs_buf_read_map(target, map, nmaps,
-		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD, verify);
+		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD, ops);
 }
 
 /*
@@ -715,7 +715,7 @@ xfs_buf_read_uncached(
 	xfs_daddr_t		daddr,
 	size_t			numblks,
 	int			flags,
-	xfs_buf_iodone_t	verify)
+	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
 
@@ -728,7 +728,7 @@ xfs_buf_read_uncached(
 	bp->b_bn = daddr;
 	bp->b_maps[0].bm_bn = daddr;
 	bp->b_flags |= XBF_READ;
-	bp->b_iodone = verify;
+	bp->b_ops = ops;
 
 	xfsbdstrat(target->bt_mount, bp);
 	xfs_buf_iowait(bp);
@@ -1001,27 +1001,37 @@ STATIC void
 xfs_buf_iodone_work(
 	struct work_struct	*work)
 {
-	xfs_buf_t		*bp =
+	struct xfs_buf		*bp =
 		container_of(work, xfs_buf_t, b_iodone_work);
+	bool			read = !!(bp->b_flags & XBF_READ);
+
+	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
+	if (read && bp->b_ops)
+		bp->b_ops->verify_read(bp);
 
 	if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
 	else if (bp->b_flags & XBF_ASYNC)
 		xfs_buf_relse(bp);
+	else {
+		ASSERT(read && bp->b_ops);
+		complete(&bp->b_iowait);
+	}
 }
 
 void
 xfs_buf_ioend(
-	xfs_buf_t		*bp,
-	int			schedule)
+	struct xfs_buf	*bp,
+	int		schedule)
 {
+	bool		read = !!(bp->b_flags & XBF_READ);
+
 	trace_xfs_buf_iodone(bp, _RET_IP_);
 
-	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
 	if (bp->b_error == 0)
 		bp->b_flags |= XBF_DONE;
 
-	if ((bp->b_iodone) || (bp->b_flags & XBF_ASYNC)) {
+	if (bp->b_iodone || (read && bp->b_ops) || (bp->b_flags & XBF_ASYNC)) {
 		if (schedule) {
 			INIT_WORK(&bp->b_iodone_work, xfs_buf_iodone_work);
 			queue_work(xfslogd_workqueue, &bp->b_iodone_work);
@@ -1029,6 +1039,7 @@ xfs_buf_ioend(
 			xfs_buf_iodone_work(&bp->b_iodone_work);
 		}
 	} else {
+		bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
 		complete(&bp->b_iowait);
 	}
 }
@@ -1306,6 +1317,20 @@ _xfs_buf_ioapply(
 			rw |= REQ_FUA;
 		if (bp->b_flags & XBF_FLUSH)
 			rw |= REQ_FLUSH;
+
+		/*
+		 * Run the write verifier callback function if it exists. If
+		 * this function fails it will mark the buffer with an error and
+		 * the IO should not be dispatched.
+		 */
+		if (bp->b_ops) {
+			bp->b_ops->verify_write(bp);
+			if (bp->b_error) {
+				xfs_force_shutdown(bp->b_target->bt_mount,
+						   SHUTDOWN_CORRUPT_INCORE);
+				return;
+			}
+		}
 	} else if (bp->b_flags & XBF_READ_AHEAD) {
 		rw = READA;
 	} else {
@@ -1316,20 +1341,6 @@ _xfs_buf_ioapply(
 	rw |= REQ_META;
 
 	/*
-	 * run the pre-io callback function if it exists. If this function
-	 * fails it will mark the buffer with an error and the IO should
-	 * not be dispatched.
-	 */
-	if (bp->b_pre_io) {
-		bp->b_pre_io(bp);
-		if (bp->b_error) {
-			xfs_force_shutdown(bp->b_target->bt_mount,
-					   SHUTDOWN_CORRUPT_INCORE);
-			return;
-		}
-	}
-
-	/*
 	 * Walk all the vectors issuing IO on them. Set up the initial offset
 	 * into the buffer and the desired IO size before we start -
 	 * _xfs_buf_ioapply_vec() will modify them appropriately for each
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 51bc16a..23f5642 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -111,6 +111,11 @@ struct xfs_buf_map {
 #define DEFINE_SINGLE_BUF_MAP(map, blkno, numblk) \
 	struct xfs_buf_map (map) = { .bm_bn = (blkno), .bm_len = (numblk) };
 
+struct xfs_buf_ops {
+	void (*verify_read)(struct xfs_buf *);
+	void (*verify_write)(struct xfs_buf *);
+};
+
 typedef struct xfs_buf {
 	/*
 	 * first cacheline holds all the fields needed for an uncontended cache
@@ -154,9 +159,7 @@ typedef struct xfs_buf {
 	unsigned int		b_page_count;	/* size of page array */
 	unsigned int		b_offset;	/* page offset in first page */
 	unsigned short		b_error;	/* error code on I/O */
-
-	void			(*b_pre_io)(struct xfs_buf *);
-						/* pre-io callback function */
+	const struct xfs_buf_ops	*b_ops;
 
 #ifdef XFS_BUF_LOCK_TRACKING
 	int			b_last_holder;
@@ -199,10 +202,11 @@ struct xfs_buf *xfs_buf_get_map(struct xfs_buftarg *target,
 			       xfs_buf_flags_t flags);
 struct xfs_buf *xfs_buf_read_map(struct xfs_buftarg *target,
 			       struct xfs_buf_map *map, int nmaps,
-			       xfs_buf_flags_t flags, xfs_buf_iodone_t verify);
+			       xfs_buf_flags_t flags,
+			       const struct xfs_buf_ops *ops);
 void xfs_buf_readahead_map(struct xfs_buftarg *target,
 			       struct xfs_buf_map *map, int nmaps,
-			       xfs_buf_iodone_t verify);
+			       const struct xfs_buf_ops *ops);
 
 static inline struct xfs_buf *
 xfs_buf_get(
@@ -221,10 +225,10 @@ xfs_buf_read(
 	xfs_daddr_t		blkno,
 	size_t			numblks,
 	xfs_buf_flags_t		flags,
-	xfs_buf_iodone_t	verify)
+	const struct xfs_buf_ops *ops)
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return xfs_buf_read_map(target, &map, 1, flags, verify);
+	return xfs_buf_read_map(target, &map, 1, flags, ops);
 }
 
 static inline void
@@ -232,10 +236,10 @@ xfs_buf_readahead(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		blkno,
 	size_t			numblks,
-	xfs_buf_iodone_t	verify)
+	const struct xfs_buf_ops *ops)
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return xfs_buf_readahead_map(target, &map, 1, verify);
+	return xfs_buf_readahead_map(target, &map, 1, ops);
 }
 
 struct xfs_buf *xfs_buf_get_empty(struct xfs_buftarg *target, size_t numblks);
@@ -246,7 +250,7 @@ struct xfs_buf *xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
 				int flags);
 struct xfs_buf *xfs_buf_read_uncached(struct xfs_buftarg *target,
 				xfs_daddr_t daddr, size_t numblks, int flags,
-				xfs_buf_iodone_t verify);
+				const struct xfs_buf_ops *ops);
 void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index eff604f..816cade 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -128,10 +128,10 @@ xfs_da_node_read_verify(
 			xfs_da_node_verify(bp);
 			break;
 		case XFS_ATTR_LEAF_MAGIC:
-			xfs_attr_leaf_read_verify(bp);
+			xfs_attr_leaf_buf_ops.verify_read(bp);
 			return;
 		case XFS_DIR2_LEAFN_MAGIC:
-			xfs_dir2_leafn_read_verify(bp);
+			xfs_dir2_leafn_buf_ops.verify_read(bp);
 			return;
 		default:
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
@@ -139,12 +139,14 @@ xfs_da_node_read_verify(
 			xfs_buf_ioerror(bp, EFSCORRUPTED);
 			break;
 	}
-
-	bp->b_pre_io = xfs_da_node_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+const struct xfs_buf_ops xfs_da_node_buf_ops = {
+	.verify_read = xfs_da_node_read_verify,
+	.verify_write = xfs_da_node_write_verify,
+};
+
+
 int
 xfs_da_node_read(
 	struct xfs_trans	*tp,
@@ -155,7 +157,7 @@ xfs_da_node_read(
 	int			which_fork)
 {
 	return xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
-					which_fork, xfs_da_node_read_verify);
+					which_fork, &xfs_da_node_buf_ops);
 }
 
 /*========================================================================
@@ -192,7 +194,7 @@ xfs_da_node_create(xfs_da_args_t *args, xfs_dablk_t blkno, int level,
 	xfs_trans_log_buf(tp, bp,
 		XFS_DA_LOGRANGE(node, &node->hdr, sizeof(node->hdr)));
 
-	bp->b_pre_io = xfs_da_node_write_verify;
+	bp->b_ops = &xfs_da_node_buf_ops;
 	*bpp = bp;
 	return(0);
 }
@@ -393,7 +395,7 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	memcpy(node, oldroot, size);
 	xfs_trans_log_buf(tp, bp, 0, size - 1);
 
-	bp->b_pre_io = blk1->bp->b_pre_io;
+	bp->b_ops = blk1->bp->b_ops;
 	blk1->bp = bp;
 	blk1->blkno = blkno;
 
@@ -2209,7 +2211,7 @@ xfs_da_read_buf(
 	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp,
 	int			whichfork,
-	xfs_buf_iodone_t	verifier)
+	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
 	struct xfs_buf_map	map;
@@ -2231,7 +2233,7 @@ xfs_da_read_buf(
 
 	error = xfs_trans_read_buf_map(dp->i_mount, trans,
 					dp->i_mount->m_ddev_targp,
-					mapp, nmap, 0, &bp, verifier);
+					mapp, nmap, 0, &bp, ops);
 	if (error)
 		goto out_free;
 
@@ -2289,7 +2291,7 @@ xfs_da_reada_buf(
 	xfs_dablk_t		bno,
 	xfs_daddr_t		mappedbno,
 	int			whichfork,
-	xfs_buf_iodone_t	verifier)
+	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf_map	map;
 	struct xfs_buf_map	*mapp;
@@ -2308,7 +2310,7 @@ xfs_da_reada_buf(
 	}
 
 	mappedbno = mapp[0].bm_bn;
-	xfs_buf_readahead_map(dp->i_mount->m_ddev_targp, mapp, nmap, NULL);
+	xfs_buf_readahead_map(dp->i_mount->m_ddev_targp, mapp, nmap, ops);
 
 out_free:
 	if (mapp != &map)
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index 521b008..ee5170c 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -229,10 +229,10 @@ int	xfs_da_get_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 int	xfs_da_read_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 			       xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			       struct xfs_buf **bpp, int whichfork,
-			       xfs_buf_iodone_t verifier);
+			       const struct xfs_buf_ops *ops);
 xfs_daddr_t	xfs_da_reada_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 				xfs_dablk_t bno, xfs_daddr_t mapped_bno,
-				int whichfork, xfs_buf_iodone_t verifier);
+				int whichfork, const struct xfs_buf_ops *ops);
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 					  struct xfs_buf *dead_buf);
 
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index e2fdc6f..7536faa 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -74,22 +74,24 @@ xfs_dir2_block_verify(
 }
 
 static void
-xfs_dir2_block_write_verify(
+xfs_dir2_block_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_dir2_block_verify(bp);
 }
 
-void
-xfs_dir2_block_read_verify(
+static void
+xfs_dir2_block_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_dir2_block_verify(bp);
-	bp->b_pre_io = xfs_dir2_block_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+const struct xfs_buf_ops xfs_dir2_block_buf_ops = {
+	.verify_read = xfs_dir2_block_read_verify,
+	.verify_write = xfs_dir2_block_write_verify,
+};
+
 static int
 xfs_dir2_block_read(
 	struct xfs_trans	*tp,
@@ -99,7 +101,7 @@ xfs_dir2_block_read(
 	struct xfs_mount	*mp = dp->i_mount;
 
 	return xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, bpp,
-				XFS_DATA_FORK, xfs_dir2_block_read_verify);
+				XFS_DATA_FORK, &xfs_dir2_block_buf_ops);
 }
 
 static void
@@ -1010,7 +1012,7 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Start converting it to block form.
 	 */
-	dbp->b_pre_io = xfs_dir2_block_write_verify;
+	dbp->b_ops = &xfs_dir2_block_buf_ops;
 	hdr->magic = cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
 	needlog = 1;
 	needscan = 0;
@@ -1140,7 +1142,7 @@ xfs_dir2_sf_to_block(
 		kmem_free(sfp);
 		return error;
 	}
-	bp->b_pre_io = xfs_dir2_block_write_verify;
+	bp->b_ops = &xfs_dir2_block_buf_ops;
 	hdr = bp->b_addr;
 	hdr->magic = cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
 	/*
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index c759c7b..5ea838b 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -202,23 +202,57 @@ xfs_dir2_data_verify(
 	}
 }
 
-void
-xfs_dir2_data_write_verify(
+/*
+ * Readahead of the first block of the directory when it is opened is completely
+ * oblivious to the format of the directory. Hence we can either get a block
+ * format buffer or a data format buffer on readahead.
+ */
+static void
+xfs_dir2_data_reada_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
+
+	switch (hdr->magic) {
+	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
+		bp->b_ops = &xfs_dir2_block_buf_ops;
+		bp->b_ops->verify_read(bp);
+		return;
+	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
+		xfs_dir2_data_verify(bp);
+		return;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		break;
+	}
+}
+
+static void
+xfs_dir2_data_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_dir2_data_verify(bp);
 }
 
 static void
-xfs_dir2_data_read_verify(
+xfs_dir2_data_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_dir2_data_verify(bp);
-	bp->b_pre_io = xfs_dir2_data_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+const struct xfs_buf_ops xfs_dir2_data_buf_ops = {
+	.verify_read = xfs_dir2_data_read_verify,
+	.verify_write = xfs_dir2_data_write_verify,
+};
+
+static const struct xfs_buf_ops xfs_dir2_data_reada_buf_ops = {
+	.verify_read = xfs_dir2_data_reada_verify,
+	.verify_write = xfs_dir2_data_write_verify,
+};
+
 
 int
 xfs_dir2_data_read(
@@ -229,7 +263,7 @@ xfs_dir2_data_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, bno, mapped_bno, bpp,
-				XFS_DATA_FORK, xfs_dir2_data_read_verify);
+				XFS_DATA_FORK, &xfs_dir2_data_buf_ops);
 }
 
 int
@@ -240,7 +274,7 @@ xfs_dir2_data_readahead(
 	xfs_daddr_t		mapped_bno)
 {
 	return xfs_da_reada_buf(tp, dp, bno, mapped_bno,
-				XFS_DATA_FORK, xfs_dir2_data_read_verify);
+				XFS_DATA_FORK, &xfs_dir2_data_reada_buf_ops);
 }
 
 /*
@@ -484,7 +518,7 @@ xfs_dir2_data_init(
 		XFS_DATA_FORK);
 	if (error)
 		return error;
-	bp->b_pre_io = xfs_dir2_data_write_verify;
+	bp->b_ops = &xfs_dir2_data_buf_ops;
 
 	/*
 	 * Initialize the header.
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 3002ab7..60cd2fa 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -65,39 +65,43 @@ xfs_dir2_leaf_verify(
 }
 
 static void
-xfs_dir2_leaf1_write_verify(
+xfs_dir2_leaf1_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
 }
 
 static void
-xfs_dir2_leaf1_read_verify(
+xfs_dir2_leaf1_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
-	bp->b_pre_io = xfs_dir2_leaf1_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
 void
-xfs_dir2_leafn_write_verify(
+xfs_dir2_leafn_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 }
 
 void
-xfs_dir2_leafn_read_verify(
+xfs_dir2_leafn_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
-	bp->b_pre_io = xfs_dir2_leafn_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+static const struct xfs_buf_ops xfs_dir2_leaf1_buf_ops = {
+	.verify_read = xfs_dir2_leaf1_read_verify,
+	.verify_write = xfs_dir2_leaf1_write_verify,
+};
+
+const struct xfs_buf_ops xfs_dir2_leafn_buf_ops = {
+	.verify_read = xfs_dir2_leafn_read_verify,
+	.verify_write = xfs_dir2_leafn_write_verify,
+};
+
 static int
 xfs_dir2_leaf_read(
 	struct xfs_trans	*tp,
@@ -107,7 +111,7 @@ xfs_dir2_leaf_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
-				XFS_DATA_FORK, xfs_dir2_leaf1_read_verify);
+				XFS_DATA_FORK, &xfs_dir2_leaf1_buf_ops);
 }
 
 int
@@ -119,7 +123,7 @@ xfs_dir2_leafn_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
-				XFS_DATA_FORK, xfs_dir2_leafn_read_verify);
+				XFS_DATA_FORK, &xfs_dir2_leafn_buf_ops);
 }
 
 /*
@@ -198,7 +202,7 @@ xfs_dir2_block_to_leaf(
 	/*
 	 * Fix up the block header, make it a data block.
 	 */
-	dbp->b_pre_io = xfs_dir2_data_write_verify;
+	dbp->b_ops = &xfs_dir2_data_buf_ops;
 	hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 	if (needscan)
 		xfs_dir2_data_freescan(mp, hdr, &needlog);
@@ -1264,12 +1268,12 @@ xfs_dir2_leaf_init(
 	 * the block.
 	 */
 	if (magic == XFS_DIR2_LEAF1_MAGIC) {
-		bp->b_pre_io = xfs_dir2_leaf1_write_verify;
+		bp->b_ops = &xfs_dir2_leaf1_buf_ops;
 		ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 		ltp->bestcount = 0;
 		xfs_dir2_leaf_log_tail(tp, bp);
 	} else
-		bp->b_pre_io = xfs_dir2_leafn_write_verify;
+		bp->b_ops = &xfs_dir2_leafn_buf_ops;
 	*bpp = bp;
 	return 0;
 }
@@ -1954,7 +1958,7 @@ xfs_dir2_node_to_leaf(
 	else
 		xfs_dir2_leaf_log_header(tp, lbp);
 
-	lbp->b_pre_io = xfs_dir2_leaf1_write_verify;
+	lbp->b_ops = &xfs_dir2_leaf1_buf_ops;
 	leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAF1_MAGIC);
 
 	/*
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index da90a91..5980f9b 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -72,22 +72,24 @@ xfs_dir2_free_verify(
 }
 
 static void
-xfs_dir2_free_write_verify(
+xfs_dir2_free_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_dir2_free_verify(bp);
 }
 
-void
-xfs_dir2_free_read_verify(
+static void
+xfs_dir2_free_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_dir2_free_verify(bp);
-	bp->b_pre_io = xfs_dir2_free_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+static const struct xfs_buf_ops xfs_dir2_free_buf_ops = {
+	.verify_read = xfs_dir2_free_read_verify,
+	.verify_write = xfs_dir2_free_write_verify,
+};
+
 
 static int
 __xfs_dir2_free_read(
@@ -98,7 +100,7 @@ __xfs_dir2_free_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
-				XFS_DATA_FORK, xfs_dir2_free_read_verify);
+				XFS_DATA_FORK, &xfs_dir2_free_buf_ops);
 }
 
 int
@@ -201,7 +203,7 @@ xfs_dir2_leaf_to_node(
 				XFS_DATA_FORK);
 	if (error)
 		return error;
-	fbp->b_pre_io = xfs_dir2_free_write_verify;
+	fbp->b_ops = &xfs_dir2_free_buf_ops;
 
 	free = fbp->b_addr;
 	leaf = lbp->b_addr;
@@ -225,7 +227,7 @@ xfs_dir2_leaf_to_node(
 	}
 	free->hdr.nused = cpu_to_be32(n);
 
-	lbp->b_pre_io = xfs_dir2_leafn_write_verify;
+	lbp->b_ops = &xfs_dir2_leafn_buf_ops;
 	leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAFN_MAGIC);
 
 	/*
@@ -636,7 +638,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			state->extrablk.index = (int)((char *)dep -
 							(char *)curbp->b_addr);
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
-			curbp->b_pre_io = xfs_dir2_data_write_verify;
+			curbp->b_ops = &xfs_dir2_data_buf_ops;
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
 		}
@@ -651,7 +653,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			state->extrablk.index = -1;
 			state->extrablk.blkno = curdb;
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
-			curbp->b_pre_io = xfs_dir2_data_write_verify;
+			curbp->b_ops = &xfs_dir2_data_buf_ops;
 		} else {
 			/* If the curbp is not the CI match block, drop it */
 			if (state->extrablk.bp != curbp)
@@ -1649,7 +1651,7 @@ xfs_dir2_node_addname_int(
 					       -1, &fbp, XFS_DATA_FORK);
 			if (error)
 				return error;
-			fbp->b_pre_io = xfs_dir2_free_write_verify;
+			fbp->b_ops = &xfs_dir2_free_buf_ops;
 
 			/*
 			 * Initialize the new block to be empty, and remember
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index ac49e12..b9a033b 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -30,6 +30,8 @@ extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
 				const unsigned char *name, int len);
 
 /* xfs_dir2_block.c */
+extern const struct xfs_buf_ops xfs_dir2_block_buf_ops;
+
 extern int xfs_dir2_block_addname(struct xfs_da_args *args);
 extern int xfs_dir2_block_getdents(struct xfs_inode *dp, void *dirent,
 		xfs_off_t *offset, filldir_t filldir);
@@ -45,7 +47,9 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 #else
 #define	xfs_dir2_data_check(dp,bp)
 #endif
-extern void xfs_dir2_data_write_verify(struct xfs_buf *bp);
+
+extern const struct xfs_buf_ops xfs_dir2_data_buf_ops;
+
 extern bool __xfs_dir2_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 extern int xfs_dir2_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
@@ -73,8 +77,8 @@ extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
 		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
 
 /* xfs_dir2_leaf.c */
-extern void xfs_dir2_leafn_read_verify(struct xfs_buf *bp);
-extern void xfs_dir2_leafn_write_verify(struct xfs_buf *bp);
+extern const struct xfs_buf_ops xfs_dir2_leafn_buf_ops;
+
 extern int xfs_dir2_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
 extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index d6d4d6b..14d4088 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -285,22 +285,24 @@ xfs_dquot_buf_verify(
 }
 
 static void
-xfs_dquot_buf_write_verify(
+xfs_dquot_buf_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_dquot_buf_verify(bp);
 }
 
 static void
-xfs_dquot_buf_read_verify(
+xfs_dquot_buf_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_dquot_buf_verify(bp);
-	bp->b_pre_io = xfs_dquot_buf_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+static const struct xfs_buf_ops xfs_dquot_buf_ops = {
+	.verify_read = xfs_dquot_buf_read_verify,
+	.verify_write = xfs_dquot_buf_write_verify,
+};
+
 /*
  * Allocate a block and fill it with dquots.
  * This is called when the bmapi finds a hole.
@@ -366,7 +368,7 @@ xfs_qm_dqalloc(
 	error = xfs_buf_geterror(bp);
 	if (error)
 		goto error1;
-	bp->b_pre_io = xfs_dquot_buf_write_verify;
+	bp->b_ops = &xfs_dquot_buf_ops;
 
 	/*
 	 * Make a chunk of dquots out of this buffer and log
@@ -535,7 +537,7 @@ xfs_qm_dqtobp(
 		error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 					   dqp->q_blkno,
 					   mp->m_quotainfo->qi_dqchunklen,
-					   0, &bp, xfs_dquot_buf_read_verify);
+					   0, &bp, &xfs_dquot_buf_ops);
 
 		if (error == EFSCORRUPTED && (flags & XFS_QMOPT_DQREPAIR)) {
 			xfs_dqid_t firstid = (xfs_dqid_t)map.br_startoff *
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 8ebc457..f477723 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -200,7 +200,7 @@ xfs_growfs_data_private(
 			error = ENOMEM;
 			goto error0;
 		}
-		bp->b_pre_io = xfs_agf_write_verify;
+		bp->b_ops = &xfs_agf_buf_ops;
 		agf = XFS_BUF_TO_AGF(bp);
 		memset(agf, 0, mp->m_sb.sb_sectsize);
 		agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
@@ -238,7 +238,7 @@ xfs_growfs_data_private(
 			error = ENOMEM;
 			goto error0;
 		}
-		bp->b_pre_io = xfs_agi_write_verify;
+		bp->b_ops = &xfs_agi_buf_ops;
 		agi = XFS_BUF_TO_AGI(bp);
 		memset(agi, 0, mp->m_sb.sb_sectsize);
 		agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
@@ -260,6 +260,11 @@ xfs_growfs_data_private(
 
 		/*
 		 * BNO btree root block
+		 *
+		 * XXX: we attach the buf ops after writing the buffer becaus
+		 * the perag is not yet initialised fully and hence the buffer
+		 * will fail write verification. Attach it after writing. This
+		 * needs fixing before CRC protection will work.
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
@@ -280,12 +285,18 @@ xfs_growfs_data_private(
 		arec->ar_blockcount = cpu_to_be32(
 			agsize - be32_to_cpu(arec->ar_startblock));
 		error = xfs_bwrite(bp);
+		bp->b_ops = &xfs_allocbt_buf_ops;
 		xfs_buf_relse(bp);
 		if (error)
 			goto error0;
 
 		/*
 		 * CNT btree root block
+		 *
+		 * XXX: we attach the buf ops after writing the buffer becaus
+		 * the perag is not yet initialised fully and hence the buffer
+		 * will fail write verification. Attach it after writing. This
+		 * needs fixing before CRC protection will work.
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
@@ -307,12 +318,18 @@ xfs_growfs_data_private(
 			agsize - be32_to_cpu(arec->ar_startblock));
 		nfree += be32_to_cpu(arec->ar_blockcount);
 		error = xfs_bwrite(bp);
+		bp->b_ops = &xfs_allocbt_buf_ops;
 		xfs_buf_relse(bp);
 		if (error)
 			goto error0;
 
 		/*
 		 * INO btree root block
+		 *
+		 * XXX: we attach the buf ops after writing the buffer becaus
+		 * the perag is not yet initialised fully and hence the buffer
+		 * will fail write verification. Attach it after writing. This
+		 * needs fixing before CRC protection will work.
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
@@ -329,6 +346,7 @@ xfs_growfs_data_private(
 		block->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 		block->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
 		error = xfs_bwrite(bp);
+		bp->b_ops = &xfs_inobt_buf_ops;
 		xfs_buf_relse(bp);
 		if (error)
 			goto error0;
@@ -416,14 +434,14 @@ xfs_growfs_data_private(
 			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
 				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 				  XFS_FSS_TO_BB(mp, 1), 0, &bp,
-				  xfs_sb_read_verify);
+				  &xfs_sb_buf_ops);
 		} else {
 			bp = xfs_trans_get_buf(NULL, mp->m_ddev_targp,
 				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 				  XFS_FSS_TO_BB(mp, 1), 0);
 			if (bp) {
+				bp->b_ops = &xfs_sb_buf_ops;
 				xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
-				bp->b_pre_io = xfs_sb_write_verify;
 			} else
 				error = ENOMEM;
 		}
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 12d1c94..878efd7 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -210,7 +210,7 @@ xfs_ialloc_inode_init(
 		 *	to log a whole cluster of inodes instead of all the
 		 *	individual transactions causing a lot of log traffic.
 		 */
-		fbuf->b_pre_io = xfs_inode_buf_write_verify;
+		fbuf->b_ops = &xfs_inode_buf_ops;
 		xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
 		for (i = 0; i < ninodes; i++) {
 			int	ioffset = i << mp->m_sb.sb_inodelog;
@@ -1496,23 +1496,25 @@ xfs_agi_verify(
 	xfs_check_agi_unlinked(agi);
 }
 
-void
-xfs_agi_write_verify(
+static void
+xfs_agi_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_agi_verify(bp);
 }
 
 static void
-xfs_agi_read_verify(
+xfs_agi_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_agi_verify(bp);
-	bp->b_pre_io = xfs_agi_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+const struct xfs_buf_ops xfs_agi_buf_ops = {
+	.verify_read = xfs_agi_read_verify,
+	.verify_write = xfs_agi_write_verify,
+};
+
 /*
  * Read in the allocation group header (inode allocation section)
  */
@@ -1529,7 +1531,7 @@ xfs_read_agi(
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, bpp, xfs_agi_read_verify);
+			XFS_FSS_TO_BB(mp, 1), 0, bpp, &xfs_agi_buf_ops);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index 7a169e3..c8da3df 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -150,6 +150,6 @@ int xfs_inobt_lookup(struct xfs_btree_cur *cur, xfs_agino_t ino,
 int xfs_inobt_get_rec(struct xfs_btree_cur *cur,
 		xfs_inobt_rec_incore_t *rec, int *stat);
 
-void xfs_agi_write_verify(struct xfs_buf *bp);
+extern const struct xfs_buf_ops xfs_agi_buf_ops;
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index 7761e1e..bec344b 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -217,22 +217,24 @@ xfs_inobt_verify(
 }
 
 static void
-xfs_inobt_write_verify(
+xfs_inobt_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_inobt_verify(bp);
 }
 
-void
-xfs_inobt_read_verify(
+static void
+xfs_inobt_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_inobt_verify(bp);
-	bp->b_pre_io = xfs_inobt_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+const struct xfs_buf_ops xfs_inobt_buf_ops = {
+	.verify_read = xfs_inobt_read_verify,
+	.verify_write = xfs_inobt_write_verify,
+};
+
 #ifdef DEBUG
 STATIC int
 xfs_inobt_keys_inorder(
@@ -270,8 +272,7 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
-	.read_verify		= xfs_inobt_read_verify,
-	.write_verify		= xfs_inobt_write_verify,
+	.buf_ops		= &xfs_inobt_buf_ops,
 #ifdef DEBUG
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
diff --git a/fs/xfs/xfs_ialloc_btree.h b/fs/xfs/xfs_ialloc_btree.h
index f782ad0..25c0239 100644
--- a/fs/xfs/xfs_ialloc_btree.h
+++ b/fs/xfs/xfs_ialloc_btree.h
@@ -109,4 +109,6 @@ extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
+extern const struct xfs_buf_ops xfs_inobt_buf_ops;
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4f2e99a..c4add46 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -420,23 +420,27 @@ xfs_inode_buf_verify(
 	xfs_inobp_check(mp, bp);
 }
 
-void
-xfs_inode_buf_write_verify(
+
+static void
+xfs_inode_buf_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_inode_buf_verify(bp);
 }
 
-void
-xfs_inode_buf_read_verify(
+static void
+xfs_inode_buf_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_inode_buf_verify(bp);
-	bp->b_pre_io = xfs_inode_buf_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+const struct xfs_buf_ops xfs_inode_buf_ops = {
+	.verify_read = xfs_inode_buf_read_verify,
+	.verify_write = xfs_inode_buf_write_verify,
+};
+
+
 /*
  * This routine is called to map an inode to the buffer containing the on-disk
  * version of the inode.  It returns a pointer to the buffer containing the
@@ -462,7 +466,7 @@ xfs_imap_to_bp(
 	buf_flags |= XBF_UNMAPPED;
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
 				   (int)imap->im_len, buf_flags, &bp,
-				   xfs_inode_buf_read_verify);
+				   &xfs_inode_buf_ops);
 	if (error) {
 		if (error == EAGAIN) {
 			ASSERT(buf_flags & XBF_TRYLOCK);
@@ -1791,7 +1795,7 @@ xfs_ifree_cluster(
 		 * want it to fail. We can acheive this by adding a write
 		 * verifier to the buffer.
 		 */
-		 bp->b_pre_io = xfs_inode_buf_write_verify;
+		 bp->b_ops = &xfs_inode_buf_ops;
 
 		/*
 		 * Walk the inodes already attached to the buffer and mark them
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index a866d28..0a5d3c0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -554,8 +554,6 @@ int		xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
 			       struct xfs_buf **, uint, uint);
 int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, uint);
-void		xfs_inode_buf_read_verify(struct xfs_buf *);
-void		xfs_inode_buf_write_verify(struct xfs_buf *);
 void		xfs_dinode_to_disk(struct xfs_dinode *,
 				   struct xfs_icdinode *);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
@@ -599,5 +597,6 @@ void		xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 extern struct kmem_zone	*xfs_ifork_zone;
 extern struct kmem_zone	*xfs_inode_zone;
 extern struct kmem_zone	*xfs_ili_zone;
+extern const struct xfs_buf_ops xfs_inode_buf_ops;
 
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 7f86fda..2ea7d40 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -397,7 +397,7 @@ xfs_bulkstat(
 							& ~r.ir_free)
 						xfs_btree_reada_bufs(mp, agno,
 							agbno, nbcluster,
-							xfs_inode_buf_read_verify);
+							&xfs_inode_buf_ops);
 				}
 				irbp->ir_startino = r.ir_startino;
 				irbp->ir_freecount = r.ir_freecount;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4cf7ae8..d63d0ca 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3699,7 +3699,7 @@ xlog_do_recover(
 	ASSERT(!(XFS_BUF_ISWRITE(bp)));
 	XFS_BUF_READ(bp);
 	XFS_BUF_UNASYNC(bp);
-	bp->b_iodone = xfs_sb_read_verify;
+	bp->b_ops = &xfs_sb_buf_ops;
 	xfsbdstrat(log->l_mp, bp);
 	error = xfs_buf_iowait(bp);
 	if (error) {
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1311185..1ce91de 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -631,23 +631,26 @@ xfs_sb_verify(
 		xfs_buf_ioerror(bp, error);
 }
 
-void
-xfs_sb_write_verify(
+static void
+xfs_sb_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_sb_verify(bp);
 }
 
-void
-xfs_sb_read_verify(
+static void
+xfs_sb_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_sb_verify(bp);
-	bp->b_pre_io = xfs_sb_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
+const struct xfs_buf_ops xfs_sb_buf_ops = {
+	.verify_read = xfs_sb_read_verify,
+	.verify_write = xfs_sb_write_verify,
+};
+
+
 /*
  * xfs_readsb
  *
@@ -673,7 +676,7 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 
 reread:
 	bp = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
-				   BTOBB(sector_size), 0, xfs_sb_read_verify);
+				   BTOBB(sector_size), 0, &xfs_sb_buf_ops);
 	if (!bp) {
 		if (loud)
 			xfs_warn(mp, "SB buffer read failed");
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 69e4082..e4d1510 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -382,12 +382,12 @@ extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 
 #endif	/* __KERNEL__ */
 
-extern void	xfs_sb_read_verify(struct xfs_buf *);
-extern void	xfs_sb_write_verify(struct xfs_buf *bp);
 extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
 extern int	xfs_initialize_perag(struct xfs_mount *, xfs_agnumber_t,
 					xfs_agnumber_t *);
 extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
 extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
 
+extern const struct xfs_buf_ops xfs_sb_buf_ops;
+
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index f02d402..c6c0601 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -474,7 +474,7 @@ int		xfs_trans_read_buf_map(struct xfs_mount *mp,
 				       struct xfs_buf_map *map, int nmaps,
 				       xfs_buf_flags_t flags,
 				       struct xfs_buf **bpp,
-				       xfs_buf_iodone_t verify);
+				       const struct xfs_buf_ops *ops);
 
 static inline int
 xfs_trans_read_buf(
@@ -485,11 +485,11 @@ xfs_trans_read_buf(
 	int			numblks,
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp,
-	xfs_buf_iodone_t	verify)
+	const struct xfs_buf_ops *ops)
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 	return xfs_trans_read_buf_map(mp, tp, target, &map, 1,
-				      flags, bpp, verify);
+				      flags, bpp, ops);
 }
 
 struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *, int);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 9776282..4fc17d4 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -258,7 +258,7 @@ xfs_trans_read_buf_map(
 	int			nmaps,
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp,
-	xfs_buf_iodone_t	verify)
+	const struct xfs_buf_ops *ops)
 {
 	xfs_buf_t		*bp;
 	xfs_buf_log_item_t	*bip;
@@ -266,7 +266,7 @@ xfs_trans_read_buf_map(
 
 	*bpp = NULL;
 	if (!tp) {
-		bp = xfs_buf_read_map(target, map, nmaps, flags, verify);
+		bp = xfs_buf_read_map(target, map, nmaps, flags, ops);
 		if (!bp)
 			return (flags & XBF_TRYLOCK) ?
 					EAGAIN : XFS_ERROR(ENOMEM);
@@ -315,7 +315,7 @@ xfs_trans_read_buf_map(
 			ASSERT(!XFS_BUF_ISASYNC(bp));
 			ASSERT(bp->b_iodone == NULL);
 			XFS_BUF_READ(bp);
-			bp->b_iodone = verify;
+			bp->b_ops = ops;
 			xfsbdstrat(tp->t_mountp, bp);
 			error = xfs_buf_iowait(bp);
 			if (error) {
@@ -352,7 +352,7 @@ xfs_trans_read_buf_map(
 		return 0;
 	}
 
-	bp = xfs_buf_read_map(target, map, nmaps, flags, verify);
+	bp = xfs_buf_read_map(target, map, nmaps, flags, ops);
 	if (bp == NULL) {
 		*bpp = NULL;
 		return (flags & XBF_TRYLOCK) ?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

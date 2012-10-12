Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9C5h77A072010 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 00:43:07 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	cG5nsmU3K95BTbpb for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 22:44:37 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TMY2x-0003ZB-Il
	for xfs@oss.sgi.com; Fri, 12 Oct 2012 16:44:31 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TMY2x-00055m-Ft
	for xfs@oss.sgi.com; Fri, 12 Oct 2012 16:44:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/23] xfs: make buffer read verication an IO completion
	function
Date: Fri, 12 Oct 2012 16:44:09 +1100
Message-Id: <1350020669-19504-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1350020669-19504-1-git-send-email-david@fromorbit.com>
References: <1350020669-19504-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Add a verifier function callback capability to the buffer read
interfaces.  This will be used by the callers to supply a function
that verifies the contents of the buffer when it is read from disk.
This patch does not provide callback functions, but simply modifies
the interfaces to allow them to be called.

The reason for adding this to the read interfaces is that it is very
difficult to tell fom the outside is a buffer was just read from
disk or whether we just pulled it out of cache. Supplying a callbck
allows the buffer cache to use it's internal knowledge of the buffer
to execute it only when the buffer is read from disk.

It is intended that the verifier functions will mark the buffer with
an EFSCORRUPTED error when verification fails. This allows the
reading context to distinguish a verification error from an IO
error, and potentially take further actions on the buffer (e.g.
attempt repair) based on the error reported.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c       |    4 ++--
 fs/xfs/xfs_attr.c        |    2 +-
 fs/xfs/xfs_btree.c       |   21 ++++++++++++---------
 fs/xfs/xfs_buf.c         |   13 +++++++++----
 fs/xfs/xfs_buf.h         |   20 ++++++++++++--------
 fs/xfs/xfs_da_btree.c    |    4 ++--
 fs/xfs/xfs_dir2_leaf.c   |    2 +-
 fs/xfs/xfs_dquot.c       |    4 ++--
 fs/xfs/xfs_fsops.c       |    4 ++--
 fs/xfs/xfs_ialloc.c      |    2 +-
 fs/xfs/xfs_inode.c       |    2 +-
 fs/xfs/xfs_log.c         |    3 +--
 fs/xfs/xfs_log_recover.c |    8 +++++---
 fs/xfs/xfs_mount.c       |    6 +++---
 fs/xfs/xfs_qm.c          |    5 +++--
 fs/xfs/xfs_rtalloc.c     |    6 +++---
 fs/xfs/xfs_trans.h       |   19 ++++++++-----------
 fs/xfs/xfs_trans_buf.c   |    9 ++++++---
 fs/xfs/xfs_vnodeops.c    |    2 +-
 19 files changed, 75 insertions(+), 61 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 335206a..21c3db0 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -447,7 +447,7 @@ xfs_alloc_read_agfl(
 	error = xfs_trans_read_buf(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, &bp);
+			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
 	if (error)
 		return error;
 	ASSERT(!xfs_buf_geterror(bp));
@@ -2110,7 +2110,7 @@ xfs_read_agf(
 	error = xfs_trans_read_buf(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), flags, bpp);
+			XFS_FSS_TO_BB(mp, 1), flags, bpp, NULL);
 	if (error)
 		return error;
 	if (!*bpp)
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 0ca1f0b..ebacb8d 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -1980,7 +1980,7 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			blkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
-						   dblkno, blkcnt, 0, &bp);
+						   dblkno, blkcnt, 0, &bp, NULL);
 			if (error)
 				return(error);
 
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index e53e317..1937c9b 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -266,9 +266,12 @@ xfs_btree_dup_cursor(
 	for (i = 0; i < new->bc_nlevels; i++) {
 		new->bc_ptrs[i] = cur->bc_ptrs[i];
 		new->bc_ra[i] = cur->bc_ra[i];
-		if ((bp = cur->bc_bufs[i])) {
-			if ((error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-				XFS_BUF_ADDR(bp), mp->m_bsize, 0, &bp))) {
+		bp = cur->bc_bufs[i];
+		if (bp) {
+			error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+						   XFS_BUF_ADDR(bp), mp->m_bsize,
+						   0, &bp, NULL);
+			if (error) {
 				xfs_btree_del_cursor(new, error);
 				*ncur = NULL;
 				return error;
@@ -624,10 +627,10 @@ xfs_btree_read_bufl(
 
 	ASSERT(fsbno != NULLFSBLOCK);
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
-	if ((error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, d,
-			mp->m_bsize, lock, &bp))) {
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, d,
+				   mp->m_bsize, lock, &bp, NULL);
+	if (error)
 		return error;
-	}
 	ASSERT(!xfs_buf_geterror(bp));
 	if (bp)
 		xfs_buf_set_ref(bp, refval);
@@ -650,7 +653,7 @@ xfs_btree_reada_bufl(
 
 	ASSERT(fsbno != NULLFSBLOCK);
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
-	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count);
+	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, NULL);
 }
 
 /*
@@ -670,7 +673,7 @@ xfs_btree_reada_bufs(
 	ASSERT(agno != NULLAGNUMBER);
 	ASSERT(agbno != NULLAGBLOCK);
 	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
-	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count);
+	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, NULL);
 }
 
 STATIC int
@@ -998,7 +1001,7 @@ xfs_btree_read_buf_block(
 
 	d = xfs_btree_ptr_to_daddr(cur, ptr);
 	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
-				   mp->m_bsize, flags, bpp);
+				   mp->m_bsize, flags, bpp, NULL);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 933b793..7cab1b3 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -654,7 +654,8 @@ xfs_buf_read_map(
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
-	xfs_buf_flags_t		flags)
+	xfs_buf_flags_t		flags,
+	xfs_buf_iodone_t	verify)
 {
 	struct xfs_buf		*bp;
 
@@ -666,6 +667,7 @@ xfs_buf_read_map(
 
 		if (!XFS_BUF_ISDONE(bp)) {
 			XFS_STATS_INC(xb_get_read);
+			bp->b_iodone = verify;
 			_xfs_buf_read(bp, flags);
 		} else if (flags & XBF_ASYNC) {
 			/*
@@ -691,13 +693,14 @@ void
 xfs_buf_readahead_map(
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
-	int			nmaps)
+	int			nmaps,
+	xfs_buf_iodone_t	verify)
 {
 	if (bdi_read_congested(target->bt_bdi))
 		return;
 
 	xfs_buf_read_map(target, map, nmaps,
-		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD);
+		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD, verify);
 }
 
 /*
@@ -709,7 +712,8 @@ xfs_buf_read_uncached(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		daddr,
 	size_t			numblks,
-	int			flags)
+	int			flags,
+	xfs_buf_iodone_t	verify)
 {
 	xfs_buf_t		*bp;
 	int			error;
@@ -723,6 +727,7 @@ xfs_buf_read_uncached(
 	bp->b_bn = daddr;
 	bp->b_maps[0].bm_bn = daddr;
 	bp->b_flags |= XBF_READ;
+	bp->b_iodone = verify;
 
 	xfsbdstrat(target->bt_mount, bp);
 	error = xfs_buf_iowait(bp);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 7c0b6a0..677b1dc 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -100,6 +100,7 @@ typedef struct xfs_buftarg {
 struct xfs_buf;
 typedef void (*xfs_buf_iodone_t)(struct xfs_buf *);
 
+
 #define XB_PAGES	2
 
 struct xfs_buf_map {
@@ -159,7 +160,6 @@ typedef struct xfs_buf {
 #endif
 } xfs_buf_t;
 
-
 /* Finding and Reading Buffers */
 struct xfs_buf *_xfs_buf_find(struct xfs_buftarg *target,
 			      struct xfs_buf_map *map, int nmaps,
@@ -196,9 +196,10 @@ struct xfs_buf *xfs_buf_get_map(struct xfs_buftarg *target,
 			       xfs_buf_flags_t flags);
 struct xfs_buf *xfs_buf_read_map(struct xfs_buftarg *target,
 			       struct xfs_buf_map *map, int nmaps,
-			       xfs_buf_flags_t flags);
+			       xfs_buf_flags_t flags, xfs_buf_iodone_t verify);
 void xfs_buf_readahead_map(struct xfs_buftarg *target,
-			       struct xfs_buf_map *map, int nmaps);
+			       struct xfs_buf_map *map, int nmaps,
+			       xfs_buf_iodone_t verify);
 
 static inline struct xfs_buf *
 xfs_buf_get(
@@ -216,20 +217,22 @@ xfs_buf_read(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		blkno,
 	size_t			numblks,
-	xfs_buf_flags_t		flags)
+	xfs_buf_flags_t		flags,
+	xfs_buf_iodone_t	verify)
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return xfs_buf_read_map(target, &map, 1, flags);
+	return xfs_buf_read_map(target, &map, 1, flags, verify);
 }
 
 static inline void
 xfs_buf_readahead(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		blkno,
-	size_t			numblks)
+	size_t			numblks,
+	xfs_buf_iodone_t	verify)
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return xfs_buf_readahead_map(target, &map, 1);
+	return xfs_buf_readahead_map(target, &map, 1, verify);
 }
 
 struct xfs_buf *xfs_buf_get_empty(struct xfs_buftarg *target, size_t numblks);
@@ -239,7 +242,8 @@ int xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t length);
 struct xfs_buf *xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
 				int flags);
 struct xfs_buf *xfs_buf_read_uncached(struct xfs_buftarg *target,
-				xfs_daddr_t daddr, size_t numblks, int flags);
+				xfs_daddr_t daddr, size_t numblks, int flags,
+				xfs_buf_iodone_t verify);
 void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 7bfb7dd..41d8764 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2155,7 +2155,7 @@ xfs_da_read_buf(
 
 	error = xfs_trans_read_buf_map(dp->i_mount, trans,
 					dp->i_mount->m_ddev_targp,
-					mapp, nmap, 0, &bp);
+					mapp, nmap, 0, &bp, NULL);
 	if (error)
 		goto out_free;
 
@@ -2231,7 +2231,7 @@ xfs_da_reada_buf(
 	}
 
 	mappedbno = mapp[0].bm_bn;
-	xfs_buf_readahead_map(dp->i_mount->m_ddev_targp, mapp, nmap);
+	xfs_buf_readahead_map(dp->i_mount->m_ddev_targp, mapp, nmap, NULL);
 
 out_free:
 	if (mapp != &map)
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 0b29625..bac8698 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -926,7 +926,7 @@ xfs_dir2_leaf_readbuf(
 				XFS_FSB_TO_DADDR(mp,
 					map[mip->ra_index].br_startblock +
 							mip->ra_offset),
-				(int)BTOBB(mp->m_dirblksize));
+				(int)BTOBB(mp->m_dirblksize), NULL);
 			mip->ra_current = i;
 		}
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bf27fcc..e95f800 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -439,7 +439,7 @@ xfs_qm_dqtobp(
 		error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 					   dqp->q_blkno,
 					   mp->m_quotainfo->qi_dqchunklen,
-					   0, &bp);
+					   0, &bp, NULL);
 		if (error || !bp)
 			return XFS_ERROR(error);
 	}
@@ -920,7 +920,7 @@ xfs_qm_dqflush(
 	 * Get the buffer containing the on-disk dquot
 	 */
 	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
-				   mp->m_quotainfo->qi_dqchunklen, 0, &bp);
+				   mp->m_quotainfo->qi_dqchunklen, 0, &bp, NULL);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 4beaede..917e121 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -146,7 +146,7 @@ xfs_growfs_data_private(
 	dpct = pct - mp->m_sb.sb_imax_pct;
 	bp = xfs_buf_read_uncached(mp->m_ddev_targp,
 				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
-				XFS_FSS_TO_BB(mp, 1), 0);
+				XFS_FSS_TO_BB(mp, 1), 0, NULL);
 	if (!bp)
 		return EIO;
 	xfs_buf_relse(bp);
@@ -408,7 +408,7 @@ xfs_growfs_data_private(
 		if (agno < oagcount) {
 			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
 				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
-				  XFS_FSS_TO_BB(mp, 1), 0, &bp);
+				  XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
 		} else {
 			bp = xfs_trans_get_buf(NULL, mp->m_ddev_targp,
 				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index c5c4ef4..7c944e1 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1490,7 +1490,7 @@ xfs_read_agi(
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, bpp);
+			XFS_FSS_TO_BB(mp, 1), 0, bpp, NULL);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bba8f37..0b03578 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -408,7 +408,7 @@ xfs_imap_to_bp(
 
 	buf_flags |= XBF_UNMAPPED;
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
-				   (int)imap->im_len, buf_flags, &bp);
+				   (int)imap->im_len, buf_flags, &bp, NULL);
 	if (error) {
 		if (error != EAGAIN) {
 			xfs_warn(mp,
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 46b6986..1d6d2ee 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1129,8 +1129,7 @@ xlog_iodone(xfs_buf_t *bp)
 	 * with it being freed after writing the unmount record to the
 	 * log.
 	 */
-
-}	/* xlog_iodone */
+}
 
 /*
  * Return size of each in-core log record buffer.
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 651c988..757688a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2144,7 +2144,7 @@ xlog_recover_buffer_pass2(
 		buf_flags |= XBF_UNMAPPED;
 
 	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
-			  buf_flags);
+			  buf_flags, NULL);
 	if (!bp)
 		return XFS_ERROR(ENOMEM);
 	error = bp->b_error;
@@ -2237,7 +2237,8 @@ xlog_recover_inode_pass2(
 	}
 	trace_xfs_log_recover_inode_recover(log, in_f);
 
-	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len, 0);
+	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len, 0,
+			  NULL);
 	if (!bp) {
 		error = ENOMEM;
 		goto error;
@@ -2548,7 +2549,8 @@ xlog_recover_dquot_pass2(
 	ASSERT(dq_f->qlf_len == 1);
 
 	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
-				   XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp);
+				   XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp,
+				   NULL);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6f1c997..d39ad72 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -652,7 +652,7 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 
 reread:
 	bp = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
-					BTOBB(sector_size), 0);
+					BTOBB(sector_size), 0, NULL);
 	if (!bp) {
 		if (loud)
 			xfs_warn(mp, "SB buffer read failed");
@@ -1002,7 +1002,7 @@ xfs_check_sizes(xfs_mount_t *mp)
 	}
 	bp = xfs_buf_read_uncached(mp->m_ddev_targp,
 					d - XFS_FSS_TO_BB(mp, 1),
-					XFS_FSS_TO_BB(mp, 1), 0);
+					XFS_FSS_TO_BB(mp, 1), 0, NULL);
 	if (!bp) {
 		xfs_warn(mp, "last sector read failed");
 		return EIO;
@@ -1017,7 +1017,7 @@ xfs_check_sizes(xfs_mount_t *mp)
 		}
 		bp = xfs_buf_read_uncached(mp->m_logdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
-					XFS_FSB_TO_BB(mp, 1), 0);
+					XFS_FSB_TO_BB(mp, 1), 0, NULL);
 		if (!bp) {
 			xfs_warn(mp, "log device read failed");
 			return EIO;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 48c750b..688f608 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -892,7 +892,7 @@ xfs_qm_dqiter_bufs(
 	while (blkcnt--) {
 		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
 			      XFS_FSB_TO_DADDR(mp, bno),
-			      mp->m_quotainfo->qi_dqchunklen, 0, &bp);
+			      mp->m_quotainfo->qi_dqchunklen, 0, &bp, NULL);
 		if (error)
 			break;
 
@@ -979,7 +979,8 @@ xfs_qm_dqiterate(
 				while (rablkcnt--) {
 					xfs_buf_readahead(mp->m_ddev_targp,
 					       XFS_FSB_TO_DADDR(mp, rablkno),
-					       mp->m_quotainfo->qi_dqchunklen);
+					       mp->m_quotainfo->qi_dqchunklen,
+					       NULL);
 					rablkno++;
 				}
 			}
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a69e0b4..b271ed9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -870,7 +870,7 @@ xfs_rtbuf_get(
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
-				   mp->m_bsize, 0, &bp);
+				   mp->m_bsize, 0, &bp, NULL);
 	if (error)
 		return error;
 	ASSERT(!xfs_buf_geterror(bp));
@@ -1873,7 +1873,7 @@ xfs_growfs_rt(
 	 */
 	bp = xfs_buf_read_uncached(mp->m_rtdev_targp,
 				XFS_FSB_TO_BB(mp, nrblocks - 1),
-				XFS_FSB_TO_BB(mp, 1), 0);
+				XFS_FSB_TO_BB(mp, 1), 0, NULL);
 	if (!bp)
 		return EIO;
 	xfs_buf_relse(bp);
@@ -2220,7 +2220,7 @@ xfs_rtmount_init(
 	}
 	bp = xfs_buf_read_uncached(mp->m_rtdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
-					XFS_FSB_TO_BB(mp, 1), 0);
+					XFS_FSB_TO_BB(mp, 1), 0, NULL);
 	if (!bp) {
 		xfs_warn(mp, "realtime device size check failed");
 		return EIO;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index db05654..f02d402 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -464,10 +464,7 @@ xfs_trans_get_buf(
 	int			numblks,
 	uint			flags)
 {
-	struct xfs_buf_map	map = {
-		.bm_bn = blkno,
-		.bm_len = numblks,
-	};
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 	return xfs_trans_get_buf_map(tp, target, &map, 1, flags);
 }
 
@@ -476,7 +473,8 @@ int		xfs_trans_read_buf_map(struct xfs_mount *mp,
 				       struct xfs_buftarg *target,
 				       struct xfs_buf_map *map, int nmaps,
 				       xfs_buf_flags_t flags,
-				       struct xfs_buf **bpp);
+				       struct xfs_buf **bpp,
+				       xfs_buf_iodone_t verify);
 
 static inline int
 xfs_trans_read_buf(
@@ -486,13 +484,12 @@ xfs_trans_read_buf(
 	xfs_daddr_t		blkno,
 	int			numblks,
 	xfs_buf_flags_t		flags,
-	struct xfs_buf		**bpp)
+	struct xfs_buf		**bpp,
+	xfs_buf_iodone_t	verify)
 {
-	struct xfs_buf_map	map = {
-		.bm_bn = blkno,
-		.bm_len = numblks,
-	};
-	return xfs_trans_read_buf_map(mp, tp, target, &map, 1, flags, bpp);
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+	return xfs_trans_read_buf_map(mp, tp, target, &map, 1,
+				      flags, bpp, verify);
 }
 
 struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *, int);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 6311b99..9776282 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -257,7 +257,8 @@ xfs_trans_read_buf_map(
 	struct xfs_buf_map	*map,
 	int			nmaps,
 	xfs_buf_flags_t		flags,
-	struct xfs_buf		**bpp)
+	struct xfs_buf		**bpp,
+	xfs_buf_iodone_t	verify)
 {
 	xfs_buf_t		*bp;
 	xfs_buf_log_item_t	*bip;
@@ -265,7 +266,7 @@ xfs_trans_read_buf_map(
 
 	*bpp = NULL;
 	if (!tp) {
-		bp = xfs_buf_read_map(target, map, nmaps, flags);
+		bp = xfs_buf_read_map(target, map, nmaps, flags, verify);
 		if (!bp)
 			return (flags & XBF_TRYLOCK) ?
 					EAGAIN : XFS_ERROR(ENOMEM);
@@ -312,7 +313,9 @@ xfs_trans_read_buf_map(
 		if (!(XFS_BUF_ISDONE(bp))) {
 			trace_xfs_trans_read_buf_io(bp, _RET_IP_);
 			ASSERT(!XFS_BUF_ISASYNC(bp));
+			ASSERT(bp->b_iodone == NULL);
 			XFS_BUF_READ(bp);
+			bp->b_iodone = verify;
 			xfsbdstrat(tp->t_mountp, bp);
 			error = xfs_buf_iowait(bp);
 			if (error) {
@@ -349,7 +352,7 @@ xfs_trans_read_buf_map(
 		return 0;
 	}
 
-	bp = xfs_buf_read_map(target, map, nmaps, flags);
+	bp = xfs_buf_read_map(target, map, nmaps, flags, verify);
 	if (bp == NULL) {
 		*bpp = NULL;
 		return (flags & XBF_TRYLOCK) ?
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 2ee1f49..f409fda 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -80,7 +80,7 @@ xfs_readlink_bmap(
 		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
 		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 
-		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0);
+		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0, NULL);
 		if (!bp)
 			return XFS_ERROR(ENOMEM);
 		error = bp->b_error;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

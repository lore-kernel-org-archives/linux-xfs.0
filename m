Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE2367F56
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 03:22:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C52F30406A
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 01:22:14 -0800 (PST)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id FRdLMAgAtmr3HPAq (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Feb 2015 01:22:11 -0800 (PST)
Received: from epcpsbgr2.samsung.com
	(u142.gpu120.samsung.co.kr [203.254.230.142])
	by mailout4.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NJW005YASOXUB70@mailout4.samsung.com> for
	xfs@oss.sgi.com; Tue, 17 Feb 2015 18:22:09 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v10 2/12] xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
Date: Tue, 17 Feb 2015 18:22:09 +0900
Message-id: <003901d04a93$3451fa20$9cf5ee60$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com

This patch implements fallocate's FALLOC_FL_INSERT_RANGE for XFS.

1) Make sure that both offset and len are block size aligned.
2) Update the i_size of inode by len bytes.
3) Compute the file's logical block number against offset. If the computed
   block number is not the starting block of the extent, split the extent
   such that the block number is the starting block of the extent.
4) Shift all the extents which are lying bewteen [offset, last allocated extent]
   towards right by len bytes. This step will make a hole of len bytes
   at offset.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 356 +++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_bmap.h |  13 +-
 fs/xfs/xfs_bmap_util.c   | 131 ++++++++++++-----
 fs/xfs/xfs_bmap_util.h   |   2 +
 fs/xfs/xfs_file.c        |  41 +++++-
 fs/xfs/xfs_trace.h       |   1 +
 6 files changed, 461 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 61ec015..e4e95b4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5518,50 +5518,90 @@ xfs_bmse_shift_one(
 	int				*current_ext,
 	struct xfs_bmbt_rec_host	*gotp,
 	struct xfs_btree_cur		*cur,
-	int				*logflags)
+	int				*logflags,
+	enum shift_direction		direction)
 {
 	struct xfs_ifork		*ifp;
 	xfs_fileoff_t			startoff;
-	struct xfs_bmbt_rec_host	*leftp;
+	struct xfs_bmbt_rec_host	*adj_irecp;
 	struct xfs_bmbt_irec		got;
-	struct xfs_bmbt_irec		left;
+	struct xfs_bmbt_irec		adj_irec;
 	int				error;
 	int				i;
+	int				total_extents;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
+	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
 
 	xfs_bmbt_get_all(gotp, &got);
-	startoff = got.br_startoff - offset_shift_fsb;
 
 	/* delalloc extents should be prevented by caller */
 	XFS_WANT_CORRUPTED_RETURN(!isnullstartblock(got.br_startblock));
 
-	/*
-	 * Check for merge if we've got an extent to the left, otherwise make
-	 * sure there's enough room at the start of the file for the shift.
-	 */
-	if (*current_ext) {
-		/* grab the left extent and check for a large enough hole */
-		leftp = xfs_iext_get_ext(ifp, *current_ext - 1);
-		xfs_bmbt_get_all(leftp, &left);
+	if (direction == SHIFT_LEFT) {
+		startoff = got.br_startoff - offset_shift_fsb;
+
+		/*
+		 * Check for merge if we've got an extent to the left,
+		 * otherwise make sure there's enough room at the start
+		 * of the file for the shift.
+		 */
+		if (!*current_ext) {
+			if (got.br_startoff < offset_shift_fsb)
+				return -EINVAL;
+			goto update_current_ext;
+		}
+		/*
+		 * grab the left extent and check for a large
+		 * enough hole.
+		 */
+		adj_irecp = xfs_iext_get_ext(ifp, *current_ext - 1);
+		xfs_bmbt_get_all(adj_irecp, &adj_irec);
 
-		if (startoff < left.br_startoff + left.br_blockcount)
+		if (startoff <
+		    adj_irec.br_startoff + adj_irec.br_blockcount)
 			return -EINVAL;
 
 		/* check whether to merge the extent or shift it down */
-		if (xfs_bmse_can_merge(&left, &got, offset_shift_fsb)) {
+		if (xfs_bmse_can_merge(&adj_irec, &got,
+				       offset_shift_fsb)) {
 			return xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
-					      *current_ext, gotp, leftp, cur,
-					      logflags);
+					      *current_ext, gotp, adj_irecp,
+					      cur, logflags);
 		}
-	} else if (got.br_startoff < offset_shift_fsb)
-		return -EINVAL;
-
+	} else {
+		startoff = got.br_startoff + offset_shift_fsb;
+		/* nothing to move if this is the last extent */
+		if (*current_ext >= (total_extents - 1))
+			goto update_current_ext;
+		/*
+		 * If this is not the last extent in the file, make sure there
+		 * is enough room between current extent and next extent for
+		 * accommodating the shift.
+		 */
+		adj_irecp = xfs_iext_get_ext(ifp, *current_ext + 1);
+		xfs_bmbt_get_all(adj_irecp, &adj_irec);
+		if (startoff + got.br_blockcount > adj_irec.br_startoff)
+			return -EINVAL;
+		/*
+		 * Unlike a left shift (which involves a hole punch),
+		 * a right shift does not modify extent neighbors
+		 * in any way. We should never find mergeable extents
+		 * in this scenario. Check anyways and warn if we
+		 * encounter two extents that could be one.
+		 */
+		if (xfs_bmse_can_merge(&got, &adj_irec, offset_shift_fsb))
+			WARN_ON_ONCE(1);
+	}
 	/*
 	 * Increment the extent index for the next iteration, update the start
 	 * offset of the in-core extent and update the btree if applicable.
 	 */
-	(*current_ext)++;
+update_current_ext:
+	if (direction == SHIFT_LEFT)
+		(*current_ext)++;
+	else
+		(*current_ext)--;
 	xfs_bmbt_set_startoff(gotp, startoff);
 	*logflags |= XFS_ILOG_CORE;
 	if (!cur) {
@@ -5577,14 +5617,14 @@ xfs_bmse_shift_one(
 
 	got.br_startoff = startoff;
 	return xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
-				got.br_blockcount, got.br_state);
+			       got.br_blockcount, got.br_state);
 }
 
 /*
- * Shift extent records to the left to cover a hole.
+ * Shift extent records to the left/right to cover/create a hole.
  *
  * The maximum number of extents to be shifted in a single operation is
- * @num_exts. @start_fsb specifies the file offset to start the shift and the
+ * @num_exts. @stop_fsb specifies the file offset at which to stop shift and the
  * file offset where we've left off is returned in @next_fsb. @offset_shift_fsb
  * is the length by which each extent is shifted. If there is no hole to shift
  * the extents into, this will be considered invalid operation and we abort
@@ -5594,12 +5634,13 @@ int
 xfs_bmap_shift_extents(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
-	xfs_fileoff_t		start_fsb,
+	xfs_fileoff_t		*next_fsb,
 	xfs_fileoff_t		offset_shift_fsb,
 	int			*done,
-	xfs_fileoff_t		*next_fsb,
+	xfs_fileoff_t		stop_fsb,
 	xfs_fsblock_t		*firstblock,
 	struct xfs_bmap_free	*flist,
+	enum shift_direction	direction,
 	int			num_exts)
 {
 	struct xfs_btree_cur		*cur = NULL;
@@ -5609,10 +5650,11 @@ xfs_bmap_shift_extents(
 	struct xfs_ifork		*ifp;
 	xfs_extnum_t			nexts = 0;
 	xfs_extnum_t			current_ext;
+	xfs_extnum_t			total_extents;
+	xfs_extnum_t			stop_extent;
 	int				error = 0;
 	int				whichfork = XFS_DATA_FORK;
 	int				logflags = 0;
-	int				total_extents;
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -5628,6 +5670,8 @@ xfs_bmap_shift_extents(
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(direction == SHIFT_LEFT || direction == SHIFT_RIGHT);
+	ASSERT(*next_fsb != NULLFSBLOCK || direction == SHIFT_RIGHT);
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
@@ -5645,43 +5689,83 @@ xfs_bmap_shift_extents(
 	}
 
 	/*
+	 * There may be delalloc extents in the data fork before the range we
+	 * are collapsing out, so we cannot use the count of real extents here.
+	 * Instead we have to calculate it from the incore fork.
+	 */
+	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
+	if (total_extents == 0) {
+		*done = 1;
+		goto del_cursor;
+	}
+
+	/*
+	 * In case of first right shift, we need to initialize next_fsb
+	 */
+	if (*next_fsb == NULLFSBLOCK) {
+		gotp = xfs_iext_get_ext(ifp, total_extents - 1);
+		xfs_bmbt_get_all(gotp, &got);
+		*next_fsb = got.br_startoff;
+		if (stop_fsb > *next_fsb) {
+			*done = 1;
+			goto del_cursor;
+		}
+	}
+
+	/* Lookup the extent index at which we have to stop */
+	if (direction == SHIFT_RIGHT) {
+		gotp = xfs_iext_bno_to_ext(ifp, stop_fsb, &stop_extent);
+		/* Make stop_extent exclusive of shift range */
+		stop_extent--;
+	} else
+		stop_extent = total_extents;
+
+	/*
 	 * Look up the extent index for the fsb where we start shifting. We can
 	 * henceforth iterate with current_ext as extent list changes are locked
 	 * out via ilock.
 	 *
 	 * gotp can be null in 2 cases: 1) if there are no extents or 2)
-	 * start_fsb lies in a hole beyond which there are no extents. Either
+	 * *next_fsb lies in a hole beyond which there are no extents. Either
 	 * way, we are done.
 	 */
-	gotp = xfs_iext_bno_to_ext(ifp, start_fsb, &current_ext);
+	gotp = xfs_iext_bno_to_ext(ifp, *next_fsb, &current_ext);
 	if (!gotp) {
 		*done = 1;
 		goto del_cursor;
 	}
 
-	/*
-	 * There may be delalloc extents in the data fork before the range we
-	 * are collapsing out, so we cannot use the count of real extents here.
-	 * Instead we have to calculate it from the incore fork.
-	 */
-	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
-	while (nexts++ < num_exts && current_ext < total_extents) {
+	/* some sanity checking before we finally start shifting extents */
+	if ((direction == SHIFT_LEFT && current_ext >= stop_extent) ||
+	     (direction == SHIFT_RIGHT && current_ext <= stop_extent)) {
+		error = -EIO;
+		goto del_cursor;
+	}
+
+	while (nexts++ < num_exts) {
 		error = xfs_bmse_shift_one(ip, whichfork, offset_shift_fsb,
-					&current_ext, gotp, cur, &logflags);
+					   &current_ext, gotp, cur, &logflags,
+					   direction);
 		if (error)
 			goto del_cursor;
+		/*
+		 * If there was an extent merge during the shift, the extent
+		 * count can change. Update the total and grade the next record.
+		 */
+		if (direction == SHIFT_LEFT) {
+			total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
+			stop_extent = total_extents;
+		}
 
-		/* update total extent count and grab the next record */
-		total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
-		if (current_ext >= total_extents)
+		if (current_ext == stop_extent) {
+			*done = 1;
+			*next_fsb = NULLFSBLOCK;
 			break;
+		}
 		gotp = xfs_iext_get_ext(ifp, current_ext);
 	}
 
-	/* Check if we are done */
-	if (current_ext == total_extents) {
-		*done = 1;
-	} else if (next_fsb) {
+	if (!*done) {
 		xfs_bmbt_get_all(gotp, &got);
 		*next_fsb = got.br_startoff;
 	}
@@ -5696,3 +5780,189 @@ del_cursor:
 
 	return error;
 }
+
+/*
+ * Splits an extent into two extents at split_fsb block such that it is
+ * the first block of the current_ext. @current_ext is a target extent
+ * to be split. @split_fsb is a block where the extents is split.
+ * If split_fsb lies in a hole or the first block of extents, just return 0.
+ */
+STATIC int
+xfs_bmap_split_extent_at(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		split_fsb,
+	xfs_fsblock_t		*firstfsb,
+	struct xfs_bmap_free	*free_list)
+{
+	int				whichfork = XFS_DATA_FORK;
+	struct xfs_btree_cur		*cur = NULL;
+	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_bmbt_irec		got;
+	struct xfs_bmbt_irec		new; /* split extent */
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_ifork		*ifp;
+	xfs_fsblock_t			gotblkcnt; /* new block count for got */
+	xfs_extnum_t			current_ext;
+	int				error = 0;
+	int				logflags = 0;
+	int				i = 0;
+
+	if (unlikely(XFS_TEST_ERROR(
+	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
+	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
+		XFS_ERROR_REPORT("xfs_bmap_split_extent_at",
+				 XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		/* Read in all the extents */
+		error = xfs_iread_extents(tp, ip, whichfork);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * gotp can be null in 2 cases: 1) if there are no extents
+	 * or 2) split_fsb lies in a hole beyond which there are
+	 * no extents. Either way, we are done.
+	 */
+	gotp = xfs_iext_bno_to_ext(ifp, split_fsb, &current_ext);
+	if (!gotp)
+		return 0;
+
+	xfs_bmbt_get_all(gotp, &got);
+
+	/*
+	 * Check split_fsb lies in a hole or the start boundary offset
+	 * of the extent.
+	 */
+	if (got.br_startoff >= split_fsb)
+		return 0;
+
+	gotblkcnt = split_fsb - got.br_startoff;
+	new.br_startoff = split_fsb;
+	new.br_startblock = got.br_startblock + gotblkcnt;
+	new.br_blockcount = got.br_blockcount - gotblkcnt;
+	new.br_state = got.br_state;
+
+	if (ifp->if_flags & XFS_IFBROOT) {
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
+		cur->bc_private.b.firstblock = *firstfsb;
+		cur->bc_private.b.flist = free_list;
+		cur->bc_private.b.flags = 0;
+		error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
+				got.br_startblock,
+				got.br_blockcount,
+				&i);
+		if (error)
+			goto del_cursor;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+	}
+
+	xfs_bmbt_set_blockcount(gotp, gotblkcnt);
+	got.br_blockcount = gotblkcnt;
+
+	logflags = XFS_ILOG_CORE;
+	if (cur) {
+		error = xfs_bmbt_update(cur, got.br_startoff,
+				got.br_startblock,
+				got.br_blockcount,
+				got.br_state);
+		if (error)
+			goto del_cursor;
+	} else
+		logflags |= XFS_ILOG_DEXT;
+
+	/* Add new extent */
+	current_ext++;
+	xfs_iext_insert(ip, current_ext, 1, &new, 0);
+	XFS_IFORK_NEXT_SET(ip, whichfork,
+			   XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
+
+	if (cur) {
+		error = xfs_bmbt_lookup_eq(cur, new.br_startoff,
+				new.br_startblock, new.br_blockcount,
+				&i);
+		if (error)
+			goto del_cursor;
+		XFS_WANT_CORRUPTED_GOTO(i == 0, del_cursor);
+		cur->bc_rec.b.br_state = new.br_state;
+
+		error = xfs_btree_insert(cur, &i);
+		if (error)
+			goto del_cursor;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+	}
+
+	/*
+	 * Convert to a btree if necessary.
+	 */
+	if (xfs_bmap_needs_btree(ip, whichfork)) {
+		int tmp_logflags; /* partial log flag return val */
+
+		ASSERT(cur == NULL);
+		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, free_list,
+				&cur, 0, &tmp_logflags, whichfork);
+		logflags |= tmp_logflags;
+	}
+
+del_cursor:
+	if (cur) {
+		cur->bc_private.b.allocated = 0;
+		xfs_btree_del_cursor(cur,
+				error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	}
+
+	if (logflags)
+		xfs_trans_log_inode(tp, ip, logflags);
+	return error;
+}
+
+int
+xfs_bmap_split_extent(
+	struct xfs_inode        *ip,
+	xfs_fileoff_t           split_fsb)
+{
+	struct xfs_mount        *mp = ip->i_mount;
+	struct xfs_trans        *tp;
+	struct xfs_bmap_free    free_list;
+	xfs_fsblock_t           firstfsb;
+	int                     committed;
+	int                     error;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	xfs_bmap_init(&free_list, &firstfsb);
+
+	error = xfs_bmap_split_extent_at(tp, ip, split_fsb,
+			&firstfsb, &free_list);
+	if (error)
+		goto out;
+
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	if (error)
+		goto out;
+
+	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+
+
+out:
+	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b9d8a49..6aaa0c1 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -166,6 +166,11 @@ static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
  */
 #define XFS_BMAP_MAX_SHIFT_EXTENTS	1
 
+enum shift_direction {
+	SHIFT_LEFT = 0,
+	SHIFT_RIGHT,
+};
+
 #ifdef DEBUG
 void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 		int whichfork, unsigned long caller_ip);
@@ -211,8 +216,10 @@ int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
 		xfs_extnum_t num);
 uint	xfs_default_attroffset(struct xfs_inode *ip);
 int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
-		xfs_fileoff_t start_fsb, xfs_fileoff_t offset_shift_fsb,
-		int *done, xfs_fileoff_t *next_fsb, xfs_fsblock_t *firstblock,
-		struct xfs_bmap_free *flist, int num_exts);
+		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
+		int *done, xfs_fileoff_t stop_fsb, xfs_fsblock_t *firstblock,
+		struct xfs_bmap_free *flist, enum shift_direction direction,
+		int num_exts);
+int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
 
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 22a5dcb..fe1f11b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1376,22 +1376,19 @@ out:
 }
 
 /*
- * xfs_collapse_file_space()
- *	This routine frees disk space and shift extent for the given file.
- *	The first thing we do is to free data blocks in the specified range
- *	by calling xfs_free_file_space(). It would also sync dirty data
- *	and invalidate page cache over the region on which collapse range
- *	is working. And Shift extent records to the left to cover a hole.
- * RETURNS:
- *	0 on success
- *	errno on error
- *
+ * @next_fsb will keep track of the extent currently undergoing shift.
+ * @stop_fsb will keep track of the extent at which we have to stop.
+ * If we are shifting left, we will start with block (offset + len) and
+ * shift each extent till last extent.
+ * If we are shifting right, we will start with last extent inside file space
+ * and continue until we reach the block corresponding to offset.
  */
 int
-xfs_collapse_file_space(
-	struct xfs_inode	*ip,
-	xfs_off_t		offset,
-	xfs_off_t		len)
+xfs_shift_file_space(
+	struct xfs_inode        *ip,
+	xfs_off_t               offset,
+	xfs_off_t               len,
+	enum shift_direction	direction)
 {
 	int			done = 0;
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1400,21 +1397,26 @@ xfs_collapse_file_space(
 	struct xfs_bmap_free	free_list;
 	xfs_fsblock_t		first_block;
 	int			committed;
-	xfs_fileoff_t		start_fsb;
+	xfs_fileoff_t		stop_fsb;
 	xfs_fileoff_t		next_fsb;
 	xfs_fileoff_t		shift_fsb;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(direction == SHIFT_LEFT || direction == SHIFT_RIGHT);
 
-	trace_xfs_collapse_file_space(ip);
+	if (direction == SHIFT_LEFT) {
+		next_fsb = XFS_B_TO_FSB(mp, offset + len);
+		stop_fsb = XFS_B_TO_FSB(mp, VFS_I(ip)->i_size);
+	} else {
+		/*
+		 * If right shift, delegate the work of initialization of
+		 * next_fsb to xfs_bmap_shift_extent as it has ilock held.
+		 */
+		next_fsb = NULLFSBLOCK;
+		stop_fsb = XFS_B_TO_FSB(mp, offset);
+	}
 
-	next_fsb = XFS_B_TO_FSB(mp, offset + len);
 	shift_fsb = XFS_B_TO_FSB(mp, len);
 
-	error = xfs_free_file_space(ip, offset, len);
-	if (error)
-		return error;
-
 	/*
 	 * Trim eofblocks to avoid shifting uninitialized post-eof preallocation
 	 * into the accessible region of the file.
@@ -1427,20 +1429,28 @@ xfs_collapse_file_space(
 
 	/*
 	 * Writeback and invalidate cache for the remainder of the file as we're
-	 * about to shift down every extent from the collapse range to EOF. The
-	 * free of the collapse range above might have already done some of
-	 * this, but we shouldn't rely on it to do anything outside of the range
-	 * that was freed.
+	 * about to shift down every extent from offset to EOF.
 	 */
 	error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-					     offset + len, -1);
+					     offset, -1);
 	if (error)
 		return error;
 	error = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
-					(offset + len) >> PAGE_CACHE_SHIFT, -1);
+					offset >> PAGE_CACHE_SHIFT, -1);
 	if (error)
 		return error;
 
+	/*
+	 * The extent shiting code works on extent granularity. So, if
+	 * stop_fsb is not the starting block of extent, we need to split
+	 * the extent at stop_fsb.
+	 */
+	if (direction == SHIFT_RIGHT) {
+		error = xfs_bmap_split_extent(ip, stop_fsb);
+		if (error)
+			return error;
+	}
+
 	while (!error && !done) {
 		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
 		/*
@@ -1464,7 +1474,7 @@ xfs_collapse_file_space(
 		if (error)
 			goto out;
 
-		xfs_trans_ijoin(tp, ip, 0);
+		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 		xfs_bmap_init(&free_list, &first_block);
 
@@ -1472,10 +1482,9 @@ xfs_collapse_file_space(
 		 * We are using the write transaction in which max 2 bmbt
 		 * updates are allowed
 		 */
-		start_fsb = next_fsb;
-		error = xfs_bmap_shift_extents(tp, ip, start_fsb, shift_fsb,
-				&done, &next_fsb, &first_block, &free_list,
-				XFS_BMAP_MAX_SHIFT_EXTENTS);
+		error = xfs_bmap_shift_extents(tp, ip, &next_fsb, shift_fsb,
+				&done, stop_fsb, &first_block, &free_list,
+				direction, XFS_BMAP_MAX_SHIFT_EXTENTS);
 		if (error)
 			goto out;
 
@@ -1484,18 +1493,70 @@ xfs_collapse_file_space(
 			goto out;
 
 		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
 	return error;
 
 out:
 	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
 /*
+ * xfs_collapse_file_space()
+ *	This routine frees disk space and shift extent for the given file.
+ *	The first thing we do is to free data blocks in the specified range
+ *	by calling xfs_free_file_space(). It would also sync dirty data
+ *	and invalidate page cache over the region on which collapse range
+ *	is working. And Shift extent records to the left to cover a hole.
+ * RETURNS:
+ *	0 on success
+ *	errno on error
+ *
+ */
+int
+xfs_collapse_file_space(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		len)
+{
+	int error;
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	trace_xfs_collapse_file_space(ip);
+
+	error = xfs_free_file_space(ip, offset, len);
+	if (error)
+		return error;
+
+	return xfs_shift_file_space(ip, offset, len, SHIFT_LEFT);
+}
+
+/*
+ * xfs_insert_file_space()
+ *	This routine create hole space by shifting extents for the given file.
+ *	The first thing we do is to sync dirty data and invalidate page cache
+ *	over the region on which insert range is working. And split an extent
+ *	to two extents at given offset by calling xfs_bmap_split_extent.
+ *	And shift all extent records which are laying between [offset,
+ *	last allocated extent] to the right to reserve hole range.
+ * RETURNS:
+ *	0 on success
+ *	errno on error
+ */
+int
+xfs_insert_file_space(
+	struct xfs_inode	*ip,
+	loff_t			offset,
+	loff_t			len)
+{
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	trace_xfs_insert_file_space(ip);
+
+	return xfs_shift_file_space(ip, offset, len, SHIFT_RIGHT);
+}
+
+/*
  * We need to check that the format of the data fork in the temporary inode is
  * valid for the target inode before doing the swap. This is not a problem with
  * attr1 because of the fixed fork offset, but attr2 has a dynamically sized
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 736429a..af97d9a 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -63,6 +63,8 @@ int	xfs_zero_file_space(struct xfs_inode *ip, xfs_off_t offset,
 			    xfs_off_t len);
 int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
 				xfs_off_t len);
+int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
+				xfs_off_t len);
 
 /* EOF block manipulation functions */
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1cdba95..174687c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -811,6 +811,11 @@ xfs_file_write_iter(
 	return ret;
 }
 
+#define	XFS_FALLOC_FL_SUPPORTED						\
+		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
+		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
+		 FALLOC_FL_INSERT_RANGE)
+
 STATIC long
 xfs_file_fallocate(
 	struct file		*file,
@@ -823,11 +828,11 @@ xfs_file_fallocate(
 	long			error;
 	enum xfs_prealloc_flags	flags = 0;
 	loff_t			new_size = 0;
+	bool			do_file_insert = 0;
 
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
-		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
+	if (mode & ~XFS_FALLOC_FL_SUPPORTED)
 		return -EOPNOTSUPP;
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
@@ -857,6 +862,27 @@ xfs_file_fallocate(
 		error = xfs_collapse_file_space(ip, offset, len);
 		if (error)
 			goto out_unlock;
+	} else if (mode & FALLOC_FL_INSERT_RANGE) {
+		unsigned blksize_mask = (1 << inode->i_blkbits) - 1;
+
+		new_size = i_size_read(inode) + len;
+		if (offset & blksize_mask || len & blksize_mask) {
+			error = -EINVAL;
+			goto out_unlock;
+		}
+
+		/* check the new inode size does not wrap through zero */
+		if (new_size > inode->i_sb->s_maxbytes) {
+			error = -EFBIG;
+			goto out_unlock;
+		}
+
+		/* Offset should be less than i_size */
+		if (offset >= i_size_read(inode)) {
+			error = -EINVAL;
+			goto out_unlock;
+		}
+		do_file_insert = 1;
 	} else {
 		flags |= XFS_PREALLOC_SET;
 
@@ -891,8 +917,19 @@ xfs_file_fallocate(
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = new_size;
 		error = xfs_setattr_size(ip, &iattr);
+		if (error)
+			goto out_unlock;
 	}
 
+	/*
+	 * Perform hole insertion now that the file size has been
+	 * updated so that if we crash during the operation we don't
+	 * leave shifted extents past EOF and hence losing access to
+	 * the data that is contained within them.
+	 */
+	if (do_file_insert)
+		error = xfs_insert_file_space(ip, offset, len);
+
 out_unlock:
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	return error;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 51372e3..7e45fa1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -664,6 +664,7 @@ DEFINE_INODE_EVENT(xfs_alloc_file_space);
 DEFINE_INODE_EVENT(xfs_free_file_space);
 DEFINE_INODE_EVENT(xfs_zero_file_space);
 DEFINE_INODE_EVENT(xfs_collapse_file_space);
+DEFINE_INODE_EVENT(xfs_insert_file_space);
 DEFINE_INODE_EVENT(xfs_readdir);
 #ifdef CONFIG_XFS_POSIX_ACL
 DEFINE_INODE_EVENT(xfs_get_acl);
-- 
1.8.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D89529E18
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 09:54:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 05300AC003
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 07:54:39 -0700 (PDT)
Received: from mail-pb0-f41.google.com (mail-pb0-f41.google.com
	[209.85.160.41]) by cuda.sgi.com with ESMTP id VzNeCYXu7oXfRg8H
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 31 Mar 2014 07:54:37 -0700 (PDT)
Received: by mail-pb0-f41.google.com with SMTP id jt11so8342553pbb.0
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 07:54:37 -0700 (PDT)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 2/3] xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
Date: Mon, 31 Mar 2014 23:54:28 +0900
Message-Id: <1396277668-10861-1-git-send-email-linkinjeon@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: viro@zeniv.linux.org.uk, david@fromorbit.com, hch@infradead.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, lczerner@redhat.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch implements fallocate's FALLOC_FL_INSERT_RANGE for XFS.

1) Make sure that both offset and len are block size aligned.
2) Compute the file's logical block number against offset. If the computed
   block number is not the starting block of the extent, split the extent
   such that the block number is the starting block of the extent.
3) Shift all the extents which are lying bewteen [offset, last allocated extent]
   towards right by len bytes. This step will make a hole of len bytes
   at offset.
4) Allocate unwritten extents for the hole created in step 3.
5) Update the i_size of inode by len bytes.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/xfs/xfs_bmap.c      | 371 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_bmap.h      |   9 +-
 fs/xfs/xfs_bmap_util.c | 123 +++++++++++++++-
 fs/xfs/xfs_bmap_util.h |   2 +
 fs/xfs/xfs_file.c      |  17 ++-
 fs/xfs/xfs_trace.h     |   1 +
 6 files changed, 518 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 5b6092e..66635a5 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5389,7 +5389,7 @@ error0:
  * into, this will be considered invalid operation and we abort immediately.
  */
 int
-xfs_bmap_shift_extents(
+xfs_bmap_shift_extents_left(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	int			*done,
@@ -5418,7 +5418,7 @@ xfs_bmap_shift_extents(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
 	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
 	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT("xfs_bmap_shift_extents",
+		XFS_ERROR_REPORT("xfs_bmap_shift_extents_left",
 				 XFS_ERRLEVEL_LOW, mp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
@@ -5571,3 +5571,370 @@ del_cursor:
 
 	return error;
 }
+
+/*
+ * Splits an extent into two extents at split_fsb block that it is
+ * the first block of the current_ext. @current_ext is a target extent
+ * to be splitted. @split_fsb is a block where the extents is spliited.
+ * If split_fsb lies in a hole or the first block of extents, just return 0.
+ */
+STATIC int
+xfs_bmap_split_extent_at(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		split_fsb,
+	xfs_extnum_t		*current_ext,
+	xfs_fsblock_t		*firstfsb,
+	struct xfs_bmap_free	*free_list)
+{
+	int				whichfork = XFS_DATA_FORK;
+	struct xfs_btree_cur		*cur;
+	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_bmbt_irec		got;
+	struct xfs_bmbt_irec		new; /* splitted extent */
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_ifork		*ifp;
+	xfs_fsblock_t			gotblkcnt; /* new block count for got */
+	int				error = 0;
+	int				logflags;
+	int				i = 0;
+
+	if (unlikely(XFS_TEST_ERROR(
+	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
+	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
+		XFS_ERROR_REPORT("xfs_bmap_split_extent_at",
+				 XFS_ERRLEVEL_LOW, mp);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	ASSERT(current_ext != NULL);
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		/* Read in all the extents */
+		error = xfs_iread_extents(tp, ip, whichfork);
+		if (error)
+			return error;
+	}
+
+	gotp = xfs_iext_bno_to_ext(ifp, split_fsb, current_ext);
+	/*
+	 * gotp can be null in 2 cases: 1) if there are no extents
+	 * or 2) split_fsb lies in a hole beyond which there are
+	 * no extents. Either way, we are done.
+	 */
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
+	/* We are going to change core inode */
+	logflags = XFS_ILOG_CORE;
+
+	if (ifp->if_flags & XFS_IFBROOT) {
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
+		cur->bc_private.b.firstblock = *firstfsb;
+		cur->bc_private.b.flist = free_list;
+		cur->bc_private.b.flags = 0;
+	} else {
+		cur = NULL;
+		logflags |= XFS_ILOG_DEXT;
+	}
+
+	if (cur) {
+		error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
+					   got.br_startblock,
+					   got.br_blockcount,
+					   &i);
+		if (error)
+			goto del_cursor;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+	}
+
+	xfs_bmbt_set_blockcount(gotp, gotblkcnt);
+	got.br_blockcount = gotblkcnt;
+	if (cur) {
+		error = xfs_bmbt_update(cur, got.br_startoff,
+					got.br_startblock,
+					got.br_blockcount,
+					got.br_state);
+		if (error)
+			goto del_cursor;
+	}
+
+	/* Add new extent */
+	(*current_ext)++;
+	xfs_iext_insert(ip, *current_ext, 1, &new, 0);
+	XFS_IFORK_NEXT_SET(ip, whichfork,
+		XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
+
+	if (cur) {
+		error = xfs_bmbt_lookup_eq(cur, new.br_startoff,
+					   new.br_startblock, new.br_blockcount,
+					   &i);
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
+		ASSERT(cur == NULL);
+		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, free_list,
+				&cur, 0, &tmp_logflags, whichfork);
+		logflags |= tmp_logflags;
+	}
+
+del_cursor:
+	if (cur)
+		xfs_btree_del_cursor(cur,
+			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_trans_log_inode(tp, ip, logflags);
+	return error;
+}
+
+int
+xfs_bmap_split_extent(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		split_fsb,
+	xfs_extnum_t		*split_ext)
+{
+	struct xfs_mount        *mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	struct xfs_bmap_free	free_list;
+	xfs_fsblock_t		firstfsb;
+	int			committed;
+	int			error;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
+	tp->t_flags |= XFS_TRANS_RESERVE;
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
+
+	/*
+	 * check for running out of space
+	 */
+	if (error) {
+		/*
+		 * Free the transaction structure.
+		 */
+		ASSERT(error == ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
+			ip->i_gdquot, ip->i_pdquot,
+			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0,
+			XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		goto error1;
+
+	xfs_trans_ijoin(tp, ip, 0);
+	xfs_bmap_init(&free_list, &firstfsb);
+
+	error = xfs_bmap_split_extent_at(tp, ip, split_fsb, split_ext,
+					 &firstfsb, &free_list);
+	if (error)
+		goto error0;
+
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	if (error)
+		goto error0;
+
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	return error;
+error0:
+	xfs_bmap_cancel(&free_list);
+error1:
+	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
+/*
+ * Shift extent records to the right to make a hole.
+ * The maximum number of extents to be shifted in a single operation
+ * is @num_exts, and @current_ext keeps track of the current extent
+ * index we have shifted. @offset_shift_fsb is the length by which each
+ * extent is shifted. @end_ext is the last extent to be shifted.
+ */
+int
+xfs_bmap_shift_extents_right(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			*done,
+	xfs_fileoff_t		offset_shift_fsb,
+	xfs_extnum_t		*current_ext,
+	xfs_extnum_t		end_ext,
+	xfs_fsblock_t		*firstblock,
+	struct xfs_bmap_free	*flist,
+	int			num_exts)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_btree_cur		*cur;
+	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_bmbt_irec		got;
+	struct xfs_bmbt_irec            right;
+	xfs_ifork_t			*ifp;
+	xfs_fileoff_t			startoff;
+	xfs_filblks_t			blockcount = 0;
+	int				error = 0;
+	int				i;
+	int				whichfork = XFS_DATA_FORK;
+	int				logflags;
+
+	if (unlikely(XFS_TEST_ERROR(
+	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
+	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
+		XFS_ERROR_REPORT("xfs_bmap_shift_extents_right",
+				 XFS_ERRLEVEL_LOW, mp);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	ASSERT(current_ext != NULL);
+
+	/* We are going to change core inode */
+	logflags = XFS_ILOG_CORE;
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+
+	if (ifp->if_flags & XFS_IFBROOT) {
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
+		cur->bc_private.b.firstblock = *firstblock;
+		cur->bc_private.b.flist = flist;
+		cur->bc_private.b.flags = 0;
+	} else {
+		cur = NULL;
+		logflags |= XFS_ILOG_DEXT;
+	}
+
+	/* start shifting extents to right */
+	while (num_exts-- > 0) {
+		if (*current_ext < end_ext) {
+			*done = 1;
+			break;
+		}
+
+		gotp = xfs_iext_get_ext(ifp, *current_ext);
+		xfs_bmbt_get_all(gotp, &got);
+		startoff = got.br_startoff + offset_shift_fsb;
+
+		/*
+		 * Before shifting extent into hole, make sure that the hole
+		 * is large enough to accomodate the shift. This checking has
+		 * to be performed for all except the last extent.
+		 */
+		if ((XFS_IFORK_NEXTENTS(ip, whichfork) - 1) != *current_ext) {
+			xfs_bmbt_get_all(xfs_iext_get_ext(ifp,
+						*current_ext + 1), &right);
+			if (startoff + got.br_blockcount > right.br_startoff) {
+				error = XFS_ERROR(EINVAL);
+				if (error)
+					goto del_cursor;
+			}
+		}
+
+		/* Check if we can merge 2 adjacent extents */
+		if ((XFS_IFORK_NEXTENTS(ip, whichfork) - 1) != *current_ext &&
+		    right.br_startoff == startoff + got.br_blockcount &&
+		    right.br_startblock ==
+				got.br_startblock + got.br_blockcount &&
+		    right.br_state == got.br_state &&
+		    right.br_blockcount + got.br_blockcount <= MAXEXTLEN) {
+			blockcount = right.br_blockcount + got.br_blockcount;
+
+			/* Make cursor point to the extent we will update */
+			if (cur) {
+				error = xfs_bmbt_lookup_eq(cur,
+							   right.br_startoff,
+							   right.br_startblock,
+							   right.br_blockcount,
+							   &i);
+				if (error)
+					goto del_cursor;
+				XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+			}
+
+			xfs_iext_remove(ip, *current_ext + 1, 1, 0);
+			if (cur) {
+				error = xfs_btree_delete(cur, &i);
+				if (error)
+					goto del_cursor;
+				XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+			}
+			XFS_IFORK_NEXT_SET(ip, whichfork,
+					XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
+
+		}
+
+		if (cur) {
+			error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
+						   got.br_startblock,
+						   got.br_blockcount,
+						   &i);
+			if (error)
+				goto del_cursor;
+			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+		}
+
+		if (got.br_blockcount < blockcount) {
+			xfs_bmbt_set_blockcount(gotp, blockcount);
+			got.br_blockcount = blockcount;
+		}
+
+
+		xfs_bmbt_set_startoff(gotp, startoff);
+		got.br_startoff = startoff;
+
+		if (cur) {
+			error = xfs_bmbt_update(cur, got.br_startoff,
+						got.br_startblock,
+						got.br_blockcount,
+						got.br_state);
+			if (error)
+				goto del_cursor;
+		}
+
+		(*current_ext)--;
+	}
+
+del_cursor:
+	if (cur)
+		xfs_btree_del_cursor(cur,
+			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_trans_log_inode(tp, ip, logflags);
+	return error;
+}
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index f84bd7a..91ca1a7 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -179,10 +179,17 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
 		xfs_extnum_t num);
 uint	xfs_default_attroffset(struct xfs_inode *ip);
-int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
+int	xfs_bmap_shift_extents_left(struct xfs_trans *tp, struct xfs_inode *ip,
 		int *done, xfs_fileoff_t start_fsb,
 		xfs_fileoff_t offset_shift_fsb, xfs_extnum_t *current_ext,
 		xfs_fsblock_t *firstblock, struct xfs_bmap_free	*flist,
 		int num_exts);
+int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset,
+		xfs_extnum_t *split_ext);
+int	xfs_bmap_shift_extents_right(struct xfs_trans *tp, struct xfs_inode *ip,
+		int *done, xfs_fsblock_t offset_shift_fsb,
+		xfs_extnum_t *current_ext, xfs_extnum_t end_ext,
+		xfs_fsblock_t *firstblock, struct xfs_bmap_free *flist,
+		int num_exts);
 
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 01f6a64..8b10d6d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1539,7 +1539,7 @@ xfs_collapse_file_space(
 		 * We are using the write transaction in which max 2 bmbt
 		 * updates are allowed
 		 */
-		error = xfs_bmap_shift_extents(tp, ip, &done, start_fsb,
+		error = xfs_bmap_shift_extents_left(tp, ip, &done, start_fsb,
 					       shift_fsb, &current_ext,
 					       &first_block, &free_list,
 					       XFS_BMAP_MAX_SHIFT_EXTENTS);
@@ -1563,6 +1563,127 @@ out:
 }
 
 /*
+ * xfs_insert_file_space()
+ *	This routine allocate disk space and shift extent for the given file.
+ *	The first thing we do is to sync dirty data and invalidate page cache
+ *	over the region on which insert range is working. And split an extent
+ *	to two extents at given offset by calling xfs_bmap_split_extent.
+ *	And shift all extent records which are laying between [offset,
+ *	last allocated extent] to the right to reserve hole range. Lastly
+ *	allocate an unwritten extent in hole range created by shifting extents.
+ *
+ * RETURNS:
+ *	0 on success
+ *	errno on error
+ *
+ */
+int
+xfs_insert_file_space(
+	struct xfs_inode	*ip,
+	loff_t			offset,
+	loff_t			len)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	struct xfs_bmap_free	free_list;
+	xfs_fsblock_t		first_block;
+	int			done = 0;
+	int			committed;
+	int			error;
+	uint			rounding;
+	xfs_fileoff_t		start_fsb;
+	xfs_fileoff_t		shift_fsb;
+	xfs_extnum_t		split_ext;
+	xfs_extnum_t		current_ext = 0;
+	xfs_off_t		ioffset;
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	trace_xfs_insert_file_space(ip);
+
+	/* wait for the completion of any pending DIOs */
+	inode_dio_wait(VFS_I(ip));
+
+	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
+	ioffset = offset & ~(rounding - 1);
+	error = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
+			ioffset, -1);
+	if (error)
+		return error;
+	truncate_pagecache_range(VFS_I(ip), ioffset, -1);
+
+	start_fsb = XFS_B_TO_FSB(mp, offset);
+	shift_fsb = XFS_B_TO_FSB(mp, len);
+
+	error = xfs_bmap_split_extent(ip, start_fsb, &split_ext);
+	if (error)
+		return error;
+
+	current_ext = XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) - 1;
+	while (!error && !done) {
+		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
+		tp->t_flags |= XFS_TRANS_RESERVE;
+		/*
+		 * We would need to reserve permanent block for transaction.
+		 * This will come into picture when after shifting extent into
+		 * hole we found that adjacent extents can be merged which
+		 * may lead to freeing of a block during record update.
+		 */
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
+		if (error) {
+			ASSERT(error == ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+			xfs_trans_cancel(tp, 0);
+			break;
+		}
+
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
+				ip->i_gdquot, ip->i_pdquot,
+				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0,
+				XFS_QMOPT_RES_REGBLKS);
+		if (error)
+			goto error1;
+
+		xfs_trans_ijoin(tp, ip, 0);
+
+		xfs_bmap_init(&free_list, &first_block);
+
+		/*
+		 * We are using the write transaction in which max 2 bmbt
+		 * updates are allowed
+		 */
+		error = xfs_bmap_shift_extents_right(tp, ip, &done, shift_fsb,
+						&current_ext, split_ext,
+						&first_block, &free_list,
+						XFS_BMAP_MAX_SHIFT_EXTENTS);
+		if (error)
+			goto error0;
+
+		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		if (error)
+			goto error0;
+
+		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		if (error)
+			goto out;
+	}
+
+	/* make unwritten extent in a hole range. */
+	error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_PREALLOC);
+
+out:
+	return error;
+
+error0:
+	xfs_bmap_cancel(&free_list);
+error1:
+	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
+/*
  * We need to check that the format of the data fork in the temporary inode is
  * valid for the target inode before doing the swap. This is not a problem with
  * attr1 because of the fixed fork offset, but attr2 has a dynamically sized
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 935ed2b..d62ab4b 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -101,6 +101,8 @@ int	xfs_zero_file_space(struct xfs_inode *ip, xfs_off_t offset,
 			    xfs_off_t len);
 int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
 				xfs_off_t len);
+int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
+				xfs_off_t len);
 
 /* EOF block manipulation functions */
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 003c005..6603b36 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -824,7 +824,8 @@ xfs_file_fallocate(
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
-		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
+		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
+		     FALLOC_FL_INSERT_RANGE))
 		return -EOPNOTSUPP;
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
@@ -846,6 +847,20 @@ xfs_file_fallocate(
 		error = xfs_collapse_file_space(ip, offset, len);
 		if (error)
 			goto out_unlock;
+	} else if (mode & FALLOC_FL_INSERT_RANGE) {
+		unsigned blksize_mask = (1 << inode->i_blkbits) - 1;
+
+		if (offset & blksize_mask || len & blksize_mask) {
+			error = -EINVAL;
+			goto out_unlock;
+		}
+
+		ASSERT(offset < i_size_read(inode));
+		new_size = i_size_read(inode) + len;
+
+		error = xfs_insert_file_space(ip, offset, len);
+		if (error)
+			goto out_unlock;
 	} else {
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    offset + len > i_size_read(inode)) {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a4ae41c..c870288 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -604,6 +604,7 @@ DEFINE_INODE_EVENT(xfs_inactive_symlink);
 DEFINE_INODE_EVENT(xfs_alloc_file_space);
 DEFINE_INODE_EVENT(xfs_free_file_space);
 DEFINE_INODE_EVENT(xfs_collapse_file_space);
+DEFINE_INODE_EVENT(xfs_insert_file_space);
 DEFINE_INODE_EVENT(xfs_readdir);
 #ifdef CONFIG_XFS_POSIX_ACL
 DEFINE_INODE_EVENT(xfs_get_acl);
-- 
1.7.11-rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

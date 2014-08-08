Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2448F7FA1
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 00:06:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 10028304053
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 22:06:17 -0700 (PDT)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id DUlQ6alS7bM5QGEZ (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Aug 2014 22:06:15 -0700 (PDT)
Received: from epcpsbgr4.samsung.com
	(u144.gpu120.samsung.co.kr [203.254.230.144])
	by mailout4.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N9Z001I825X5140@mailout4.samsung.com> for
	xfs@oss.sgi.com; Fri, 08 Aug 2014 14:05:57 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v5 2/10] xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
Date: Fri, 08 Aug 2014 14:05:55 +0900
Message-id: <004301cfb2c6$6ef2d330$4cd87990$@samsung.com>
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
To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>

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
Changelog

v5:
 - remove allocation part.

v4:
 - set cur->bc_private.b.allocated to zero before calling xfs_btree_del_cursor.

v3:
 - remove XFS_TRANS_RESERVE and assert.
 - update the comment of blockcount calculation.
 - use 'if(blockcount)' instead of 'if (got.br_blockcount < blockcount)'.
 - move insert_file_space() calling under xfs_setattr_size to avoid code duplicate.

v2:
 - remove reserved enable.
 - add xfs_qm_dqattach.
 - reset blockcount in xfs_bmap_shift_extents_right.
 - update i_size to avoid data loss before insert_file_space() is called.
 - use in-memory extent array size that delayed allocation extents

 fs/xfs/libxfs/xfs_bmap.c | 379 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_bmap.h |   9 +-
 fs/xfs/xfs_bmap_util.c   | 123 ++++++++++++++-
 fs/xfs/xfs_bmap_util.h   |   2 +
 fs/xfs/xfs_file.c        |  38 ++++-
 fs/xfs/xfs_trace.h       |   1 +
 6 files changed, 547 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index de2d26d..62f5aa7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5413,7 +5413,7 @@ error0:
  * into, this will be considered invalid operation and we abort immediately.
  */
 int
-xfs_bmap_shift_extents(
+xfs_bmap_shift_extents_left(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	int			*done,
@@ -5443,7 +5443,7 @@ xfs_bmap_shift_extents(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
 	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
 	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT("xfs_bmap_shift_extents",
+		XFS_ERROR_REPORT("xfs_bmap_shift_extents_left",
 				 XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
@@ -5600,3 +5600,378 @@ del_cursor:
 	xfs_trans_log_inode(tp, ip, logflags);
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
+		return -EFSCORRUPTED;
+	}
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
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
+			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	}
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
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
+
+	if (error) {
+		/*
+		 * Free the transaction structure.
+		 */
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
+	xfs_extnum_t			last_extent;
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
+		return -EFSCORRUPTED;
+	}
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
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
+		blockcount = 0;
+
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
+		last_extent = (ifp->if_bytes / sizeof(xfs_bmbt_rec_t)) - 1;
+		if (last_extent != *current_ext) {
+			xfs_bmbt_get_all(xfs_iext_get_ext(ifp,
+						*current_ext + 1), &right);
+			if (startoff + got.br_blockcount > right.br_startoff) {
+				error = -EINVAL;
+				if (error)
+					goto del_cursor;
+			}
+		}
+
+		/* Check if we can merge 2 adjacent extents */
+		if (last_extent != *current_ext &&
+		    right.br_startoff == startoff + got.br_blockcount &&
+		    right.br_startblock ==
+				got.br_startblock + got.br_blockcount &&
+		    right.br_state == got.br_state &&
+		    right.br_blockcount + got.br_blockcount <= MAXEXTLEN) {
+
+			/*
+			 * Merge the current extent with the extent to
+			 * the right. Remove the right extent, calculate
+			 * a new block count for the current extent to cover
+			 * the range of both and decrement the number of extents
+			 * in the fork.
+			 */
+			blockcount = right.br_blockcount + got.br_blockcount;
+
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
+		if (blockcount) {
+			xfs_bmbt_set_blockcount(gotp, blockcount);
+			got.br_blockcount = blockcount;
+		}
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
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b879ca5..135cf81 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -177,10 +177,17 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
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
index d32889a..815584e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1505,7 +1505,7 @@ xfs_collapse_file_space(
 		 * We are using the write transaction in which max 2 bmbt
 		 * updates are allowed
 		 */
-		error = xfs_bmap_shift_extents(tp, ip, &done, start_fsb,
+		error = xfs_bmap_shift_extents_left(tp, ip, &done, start_fsb,
 					       shift_fsb, &current_ext,
 					       &first_block, &free_list,
 					       XFS_BMAP_MAX_SHIFT_EXTENTS);
@@ -1529,6 +1529,127 @@ out:
 }
 
 /*
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
+	xfs_ifork_t		*ifp;
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
+	error = xfs_qm_dqattach(ip, 0);
+	if (error)
+		return error;
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
+
+	truncate_pagecache_range(VFS_I(ip), ioffset, -1);
+
+	start_fsb = XFS_B_TO_FSB(mp, offset);
+	shift_fsb = XFS_B_TO_FSB(mp, len);
+
+	error = xfs_bmap_split_extent(ip, start_fsb, &split_ext);
+	if (error)
+		return error;
+
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	current_ext = (ifp->if_bytes / sizeof(xfs_bmbt_rec_t)) - 1;
+	while (!error && !done) {
+		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
+		/*
+		 * We would need to reserve permanent block for transaction.
+		 * This will come into picture when after shifting extent into
+		 * hole we found that adjacent extents can be merged which
+		 * may lead to freeing of a block during record update.
+		 */
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
+		if (error) {
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
index 2fdb72d..6cb116c 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -98,6 +98,8 @@ int	xfs_zero_file_space(struct xfs_inode *ip, xfs_off_t offset,
 			    xfs_off_t len);
 int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
 				xfs_off_t len);
+int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
+				xfs_off_t len);
 
 /* EOF block manipulation functions */
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index fcf91a2..09c82e7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -771,11 +771,13 @@ xfs_file_fallocate(
 	struct xfs_trans	*tp;
 	long			error;
 	loff_t			new_size = 0;
+	int			do_file_insert = 0;
 
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
-		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
+		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
+		     FALLOC_FL_INSERT_RANGE))
 		return -EOPNOTSUPP;
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
@@ -805,6 +807,28 @@ xfs_file_fallocate(
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
+		/* Check for wrap through zero */
+		if (inode->i_size + len > inode->i_sb->s_maxbytes) {
+			error = -EFBIG;
+			goto out_unlock;
+		}
+
+		/* Offset should be less than i_size */
+		if (offset >= i_size_read(inode)) {
+			error = -EINVAL;
+			goto out_unlock;
+		}
+
+		new_size = i_size_read(inode) + len;
+		do_file_insert = 1;
 	} else {
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    offset + len > i_size_read(inode)) {
@@ -855,8 +879,20 @@ xfs_file_fallocate(
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = new_size;
 		error = xfs_setattr_size(ip, &iattr);
+		if (error)
+			goto out_unlock;
 	}
 
+	/*
+	 * Some operations are performed after the inode size is updated. For
+	 * example, insert range expands the address space of the file, shifts
+	 * all subsequent extents to create a hole inside the file. Updating
+	 * the size first ensures that shifted extents aren't left hanging
+	 * past EOF in the event of a crash or failure.
+	 */
+	if (do_file_insert)
+		error = xfs_insert_file_space(ip, offset, len);
+
 out_unlock:
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	return error;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 152f827..8943c9f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -663,6 +663,7 @@ DEFINE_INODE_EVENT(xfs_alloc_file_space);
 DEFINE_INODE_EVENT(xfs_free_file_space);
 DEFINE_INODE_EVENT(xfs_zero_file_space);
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

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E8B4D29E01
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:34:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 549A2AC005
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 15:34:58 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id xkKwrk9bjOO8kCbw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 15:34:55 -0700 (PDT)
Subject: [PATCH 18/24] xfs: reflink extents from one file to another
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 Jul 2015 15:34:53 -0700
Message-ID: <20150729223453.17414.53321.stgit@birch.djwong.org>
In-Reply-To: <20150729223258.17414.91354.stgit@birch.djwong.org>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Reflink extents from one file to another; that is to say, iteratively
remove the mappings from the destination file, copy the mappings from
the source file to the destination file, and increment the reference
count of all the blocks that got remapped.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |  509 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    3 
 2 files changed, 512 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 04eeb30..7605519 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -928,3 +928,512 @@ out_error:
 	trace_xfs_reflink_finish_fork_buf_error(ip, error, _RET_IP_);
 	return error;
 }
+
+/*
+ * Reflinking (Block) Ranges of Two Files Together
+ *
+ * First, ensure that the reflink flag is set on both inodes.  The flag is an
+ * optimization to avoid unnecessary refcount btree lookups in the write path.
+ *
+ * Now we can iteratively remap the range of extents (and holes) in src to the
+ * corresponding ranges in dest.  Let drange and srange denote the ranges of
+ * logical blocks in dest and src touched by the reflink operation.
+ *
+ * While the length of drange is greater than zero,
+ *    - Read src's bmbt at the start of srange ("imap")
+ *    - If imap doesn't exist, make imap appear to start at the end of srange
+ *      with zero length.
+ *    - If imap starts before srange, advance imap to start at srange.
+ *    - If imap goes beyond srange, truncate imap to end at the end of srange.
+ *    - Punch (imap start - srange start + imap len) blocks from dest at
+ *      offset (drange start).
+ *    - If imap points to a real range of pblks,
+ *         > Increase the refcount of the imap's pblks
+ *         > Map imap's pblks into dest at the offset
+ *           (drange start + imap start - srange start)
+ *    - Advance drange and srange by (imap start - srange start + imap len)
+ *
+ * Finally, if the reflink made dest longer, update both the in-core and
+ * on-disk file sizes.
+ *
+ * ASCII Art Demonstration:
+ *
+ * Let's say we want to reflink this source file:
+ *
+ * ----SSSSSSS-SSSSS----SSSSSS (src file)
+ *   <-------------------->
+ *
+ * into this destination file:
+ *
+ * --DDDDDDDDDDDDDDDDDDD--DDD (dest file)
+ *        <-------------------->
+ * '-' means a hole, and 'S' and 'D' are written blocks in the src and dest.
+ * Observe that the range has different logical offsets in either file.
+ *
+ * Consider that the first extent in the source file doesn't line up with our
+ * reflink range.  Unmapping  and remapping are separate operations, so we can
+ * unmap more blocks from the destination file than we remap.
+ *
+ * ----SSSSSSS-SSSSS----SSSSSS
+ *   <------->
+ * --DDDDD---------DDDDD--DDD
+ *        <------->
+ *
+ * Now remap the source extent into the destination file:
+ *
+ * ----SSSSSSS-SSSSS----SSSSSS
+ *   <------->
+ * --DDDDD--SSSSSSSDDDDD--DDD
+ *        <------->
+ *
+ * Do likewise with the second hole and extent in our range.  Holes in the
+ * unmap range don't affect our operation.
+ *
+ * ----SSSSSSS-SSSSS----SSSSSS
+ *            <---->
+ * --DDDDD--SSSSSSS-SSSSS-DDD
+ *                 <---->
+ *
+ * Finally, unmap and remap part of the third extent.  This will increase the
+ * size of the destination file.
+ *
+ * ----SSSSSSS-SSSSS----SSSSSS
+ *                  <----->
+ * --DDDDD--SSSSSSS-SSSSS----SSS
+ *                       <----->
+ *
+ * Once we update the destination file's i_size, we're done.
+ */
+
+/*
+ * Ensure the reflink bit is set in both inodes.
+ */
+STATIC int
+set_inode_reflink_flag(
+	struct xfs_inode	*src,
+	struct xfs_inode	*dest)
+{
+	struct xfs_mount	*mp = src->i_mount;
+	int			error;
+	struct xfs_trans	*tp;
+
+	if (xfs_is_reflink_inode(src) && xfs_is_reflink_inode(dest))
+		return 0;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
+
+	/*
+	 * check for running out of space
+	 */
+	if (error) {
+		/*
+		 * Free the transaction structure.
+		 */
+		ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+		goto out_cancel;
+	}
+
+	/* Lock both files against IO */
+	if (src->i_ino == dest->i_ino)
+		xfs_ilock(src, XFS_ILOCK_EXCL);
+	else
+		xfs_lock_two_inodes(src, dest, XFS_ILOCK_EXCL);
+
+	if (!xfs_is_reflink_inode(src)) {
+		trace_xfs_reflink_set_inode_flag(src);
+		xfs_trans_ijoin(tp, src, XFS_ILOCK_EXCL);
+		src->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
+		xfs_trans_log_inode(tp, src, XFS_ILOG_CORE);
+	} else
+		xfs_iunlock(src, XFS_ILOCK_EXCL);
+
+	if (src->i_ino == dest->i_ino)
+		goto commit_flags;
+
+	if (!xfs_is_reflink_inode(dest)) {
+		trace_xfs_reflink_set_inode_flag(dest);
+		xfs_trans_ijoin(tp, dest, XFS_ILOCK_EXCL);
+		dest->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
+		xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
+	} else
+		xfs_iunlock(dest, XFS_ILOCK_EXCL);
+
+commit_flags:
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_error;
+	return error;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+out_error:
+	trace_xfs_reflink_set_inode_flag_error(dest, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Update destination inode size, if necessary.
+ */
+STATIC int
+update_dest_isize(
+	struct xfs_inode	*dest,
+	xfs_off_t		newlen)
+{
+	struct xfs_mount	*mp = dest->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+
+	if (newlen <= i_size_read(VFS_I(dest)))
+		return 0;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
+
+	/*
+	 * check for running out of space
+	 */
+	if (error) {
+		/*
+		 * Free the transaction structure.
+		 */
+		ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+		goto out_cancel;
+	}
+
+	xfs_ilock(dest, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dest, XFS_ILOCK_EXCL);
+
+	trace_xfs_reflink_update_inode_size(dest, newlen);
+	i_size_write(VFS_I(dest), newlen);
+	dest->i_d.di_size = newlen;
+	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_error;
+	return error;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+out_error:
+	trace_xfs_reflink_update_inode_size_error(dest, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Punch a range of file blocks, assuming that there's no remapping in
+ * progress and that the file is eligible for reflink.
+ *
+ * XXX: Could we just use xfs_free_file_space?
+ */
+STATIC int
+punch_range(
+	struct xfs_inode	*dest,
+	xfs_fileoff_t		off,
+	xfs_filblks_t		len)
+{
+	struct xfs_mount	*mp = dest->i_mount;
+	int			error, done;
+	uint			resblks;
+	struct xfs_trans	*tp;
+	xfs_fsblock_t		firstfsb;
+	struct xfs_bmap_free	free_list;
+	int			committed;
+
+	/*
+	 * free file space until done or until there is an error
+	 */
+	trace_xfs_reflink_punch_range(dest, off, len);
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+	error = done = 0;
+	while (!error && !done) {
+		/*
+		 * allocate and setup the transaction. Allow this
+		 * transaction to dip into the reserve blocks to ensure
+		 * the freeing of the space succeeds at ENOSPC.
+		 */
+		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
+
+		/*
+		 * check for running out of space
+		 */
+		if (error) {
+			/*
+			 * Free the transaction structure.
+			 */
+			ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+			goto out_cancel;
+		}
+		xfs_ilock(dest, XFS_ILOCK_EXCL);
+		error = xfs_trans_reserve_quota(tp, mp,
+				dest->i_udquot, dest->i_gdquot, dest->i_pdquot,
+				resblks, 0, XFS_QMOPT_RES_REGBLKS);
+		if (error)
+			goto out_cancel;
+
+		xfs_trans_ijoin(tp, dest, XFS_ILOCK_EXCL);
+
+		/*
+		 * issue the bunmapi() call to free the blocks
+		 */
+		xfs_bmap_init(&free_list, &firstfsb);
+		error = xfs_bunmapi(tp, dest, off, len,
+				  0, 2, &firstfsb, &free_list, &done);
+		if (error)
+			goto out_freelist;
+
+		/*
+		 * complete the transaction
+		 */
+		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		if (error)
+			goto out_freelist;
+
+		error = xfs_trans_commit(tp);
+	}
+	if (error)
+		goto out_error;
+
+	return error;
+out_freelist:
+	xfs_bmap_cancel(&free_list);
+out_cancel:
+	xfs_trans_cancel(tp);
+out_error:
+	trace_xfs_reflink_punch_range_error(dest, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Reflink a continuous range of blocks.
+ */
+STATIC int
+remap_one_range(
+	struct xfs_inode	*dest,
+	struct xfs_bmbt_irec	*imap,
+	xfs_fileoff_t		destoff)
+{
+	struct xfs_mount	*mp = dest->i_mount;
+	int			error;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	struct xfs_trans	*tp;
+	uint			resblks;
+	struct xfs_buf		*agbp;
+	xfs_fsblock_t		firstfsb;
+	struct xfs_bmap_free	free_list;
+	struct xfs_bmbt_irec	imap_tmp;
+	int			nimaps;
+	int			committed;
+
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 1);
+	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
+	/*
+	 * Check for running out of space
+	 */
+	if (error) {
+		/*
+		 * Free the transaction structure.
+		 */
+		ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+		goto out_cancel;
+	}
+
+	xfs_ilock(dest, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dest, XFS_ILOCK_EXCL);
+
+	/* Update the refcount tree */
+	agno = XFS_FSB_TO_AGNO(mp, imap->br_startblock);
+	agbno = XFS_FSB_TO_AGBNO(mp, imap->br_startblock);
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	if (error)
+		goto out_cancel;
+	xfs_bmap_init(&free_list, &firstfsb);
+	error = xfs_refcount_increase(mp, tp, agbp, agno, agbno,
+				      imap->br_blockcount, &free_list);
+	xfs_trans_brelse(tp, agbp);
+	if (error)
+		goto out_freelist;
+
+	/* Add this extent to the destination file */
+	trace_xfs_reflink_remap_range(dest, destoff, imap->br_blockcount,
+			imap->br_startblock);
+	nimaps = 1;
+	error = xfs_bmapi_write(tp, dest, destoff, imap->br_blockcount,
+				XFS_BMAPI_EXACT, &imap->br_startblock,
+				0, &imap_tmp, &nimaps, &free_list);
+	if (error)
+		goto out_freelist;
+
+	/*
+	 * Complete the transaction
+	 */
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	if (error)
+		goto out_freelist;
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_error;
+	return error;
+
+out_freelist:
+	xfs_bmap_cancel(&free_list);
+out_cancel:
+	xfs_trans_cancel(tp);
+out_error:
+	trace_xfs_reflink_remap_range_error(dest, error, _RET_IP_);
+	return error;
+}
+
+/**
+ * Iteratively remap one file's extents (and holes) to another's.
+ */
+#define IMAPNEXT(i) ((i).br_startoff + (i).br_blockcount)
+STATIC int
+remap_blocks(
+	struct xfs_inode	*src,
+	xfs_fileoff_t		srcoff,
+	struct xfs_inode	*dest,
+	xfs_fileoff_t		destoff,
+	xfs_filblks_t		len)
+{
+	struct xfs_bmbt_irec	imap;
+	int			nimaps;
+	int			error;
+	xfs_fileoff_t		srcioff;
+
+	/* drange = (destoff, destoff + len); srange = (srcoff, srcoff + len) */
+	while (len) {
+		trace_xfs_reflink_main_loop(src, srcoff, len, dest, destoff);
+		/* Read extent from the source file */
+		nimaps = 1;
+		xfs_ilock(src, XFS_ILOCK_EXCL);
+		error = xfs_bmapi_read(src, srcoff, len, &imap, &nimaps, 0);
+		xfs_iunlock(src, XFS_ILOCK_EXCL);
+		if (error)
+			break;
+
+		/*
+		 * If imap doesn't exist, pretend that it does just past
+		 * srange.
+		 */
+		if (nimaps == 0) {
+			imap.br_startoff = srcoff + len;
+			imap.br_startblock = HOLESTARTBLOCK;
+			imap.br_blockcount = 0;
+			imap.br_state = XFS_EXT_INVALID;
+		}
+		trace_xfs_reflink_read_iomap(src, srcoff, len, XFS_IO_FORKED,
+				&imap);
+
+		/* If imap starts before srange, advance it to start there */
+		if (imap.br_startoff < srcoff) {
+			imap.br_blockcount -= srcoff - imap.br_startoff;
+			imap.br_startoff = srcoff;
+		}
+
+		/* If imap ends after srange, truncate it to match srange */
+		if (IMAPNEXT(imap) > srcoff + len)
+			imap.br_blockcount -= IMAPNEXT(imap) - (srcoff + len);
+
+		srcioff = imap.br_startoff - srcoff;
+
+		/* Punch logical blocks from drange */
+		error = punch_range(dest, destoff, srcioff + imap.br_blockcount);
+		if (error)
+			break;
+
+		/*
+		 * If imap points to real blocks, increase refcount and map;
+		 * otherwise, skip it.
+		 */
+		if (imap.br_startblock == HOLESTARTBLOCK ||
+		    imap.br_startblock == DELAYSTARTBLOCK ||
+		    ISUNWRITTEN(&imap))
+			goto advloop;
+
+		error = remap_one_range(dest, &imap, destoff + srcioff);
+		if (error)
+			break;
+advloop:
+		/* Advance drange/srange */
+		srcoff += srcioff + imap.br_blockcount;
+		destoff += srcioff + imap.br_blockcount;
+		len -= srcioff + imap.br_blockcount;
+	}
+
+	return error;
+}
+#undef IMAPNEXT
+
+/**
+ * xfs_reflink() - link a range of blocks from one inode to another
+ *
+ * @src: Inode to clone from
+ * @srcoff: Offset within source to start clone from
+ * @dest: Inode to clone to
+ * @destoff: Offset within @inode to start clone
+ * @len: Original length, passed by user, of range to clone
+ */
+int
+xfs_reflink(
+	struct xfs_inode	*src,
+	xfs_off_t		srcoff,
+	struct xfs_inode	*dest,
+	xfs_off_t		destoff,
+	xfs_off_t		len)
+{
+	struct xfs_mount	*mp = src->i_mount;
+	xfs_fileoff_t		sfsbno, dfsbno;
+	xfs_filblks_t		fsblen;
+	int			error;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	/* Don't reflink realtime inodes */
+	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
+		return -EINVAL;
+
+	trace_xfs_reflink_range(src, srcoff, len, dest, destoff);
+
+	/* Lock both files against IO */
+	if (src->i_ino == dest->i_ino) {
+		xfs_ilock(src, XFS_IOLOCK_EXCL);
+		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
+	} else {
+		xfs_lock_two_inodes(src, dest, XFS_IOLOCK_EXCL);
+		xfs_lock_two_inodes(src, dest, XFS_MMAPLOCK_EXCL);
+	}
+
+	error = set_inode_reflink_flag(src, dest);
+	if (error)
+		goto out_error;
+
+	dfsbno = XFS_B_TO_FSBT(mp, destoff);
+	sfsbno = XFS_B_TO_FSBT(mp, srcoff);
+	fsblen = XFS_B_TO_FSB(mp, len);
+	error = remap_blocks(src, sfsbno, dest, dfsbno, fsblen);
+	if (error)
+		goto out_error;
+
+	error = update_dest_isize(dest, destoff + len);
+
+out_error:
+	xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
+	xfs_iunlock(src, XFS_IOLOCK_EXCL);
+	if (src->i_ino != dest->i_ino) {
+		xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
+		xfs_iunlock(dest, XFS_IOLOCK_EXCL);
+	}
+	if (error)
+		trace_xfs_reflink_range_error(dest, error, _RET_IP_);
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index ce00cf6..b633824 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -44,4 +44,7 @@ extern int xfs_reflink_finish_fork_buf(struct xfs_inode *ip, struct xfs_buf *bp,
 		xfs_fileoff_t fileoff, struct xfs_trans *tp, int write_error,
 		xfs_fsblock_t old_fsbno);
 
+extern int xfs_reflink(struct xfs_inode *src, xfs_off_t srcoff,
+		struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

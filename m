Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19788 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933939AbcI1C55 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:57:57 -0400
Subject: [PATCH 40/63] xfs: reflink extents from one file to another
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:57:53 -0700
Message-ID: <147503147382.30303.17060862931728249933.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Reflink extents from one file to another; that is to say, iteratively
remove the mappings from the destination file, copy the mappings from
the source file to the destination file, and increment the reference
count of all the blocks that got remapped.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: Call xfs_defer_cancel before cancelling the transaction if the
remap operation fails.  Use the deferred operations system to avoid
deadlocks or blowing out the transaction reservation, and make the
entire reflink operation atomic for each extent being remapped.  The
destination file's i_size will be updated if necessary to avoid
violating the assumption that there are no shared blocks past the EOF
block.
---
 fs/xfs/xfs_reflink.c |  425 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    2 
 2 files changed, 427 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 57796ea..a2b5ad5 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -920,3 +920,428 @@ xfs_reflink_recover_cow(
 
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
+xfs_reflink_set_inode_flag(
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
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
+		goto out_error;
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
+		xfs_ifork_init_cow(src);
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
+		xfs_ifork_init_cow(dest);
+	} else
+		xfs_iunlock(dest, XFS_ILOCK_EXCL);
+
+commit_flags:
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_error;
+	return error;
+
+out_error:
+	trace_xfs_reflink_set_inode_flag_error(dest, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Update destination inode size, if necessary.
+ */
+STATIC int
+xfs_reflink_update_dest(
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
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
+		goto out_error;
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
+out_error:
+	trace_xfs_reflink_update_inode_size_error(dest, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Unmap a range of blocks from a file, then map other blocks into the hole.
+ * The range to unmap is (destoff : destoff + srcioff + irec->br_blockcount).
+ * The extent irec is mapped into dest at irec->br_startoff.
+ */
+STATIC int
+xfs_reflink_remap_extent(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*irec,
+	xfs_fileoff_t		destoff,
+	xfs_off_t		new_isize)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	xfs_fsblock_t		firstfsb;
+	unsigned int		resblks;
+	struct xfs_defer_ops	dfops;
+	struct xfs_bmbt_irec	uirec;
+	bool			real_extent;
+	xfs_filblks_t		rlen;
+	xfs_filblks_t		unmap_len;
+	xfs_off_t		newlen;
+	int			error;
+
+	unmap_len = irec->br_startoff + irec->br_blockcount - destoff;
+	trace_xfs_reflink_punch_range(ip, destoff, unmap_len);
+
+	/* Only remap normal extents. */
+	real_extent =  (irec->br_startblock != HOLESTARTBLOCK &&
+			irec->br_startblock != DELAYSTARTBLOCK &&
+			!ISUNWRITTEN(irec));
+
+	/* Start a rolling transaction to switch the mappings */
+	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	if (error)
+		goto out;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	/* If we're not just clearing space, then do we have enough quota? */
+	if (real_extent) {
+		error = xfs_trans_reserve_quota_nblks(tp, ip,
+				irec->br_blockcount, 0, XFS_QMOPT_RES_REGBLKS);
+		if (error)
+			goto out_cancel;
+	}
+
+	trace_xfs_reflink_remap(ip, irec->br_startoff,
+				irec->br_blockcount, irec->br_startblock);
+
+	/* Unmap the old blocks in the data fork. */
+	rlen = unmap_len;
+	while (rlen) {
+		xfs_defer_init(&dfops, &firstfsb);
+		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1,
+				&firstfsb, &dfops);
+		if (error)
+			goto out_defer;
+
+		/* Trim the extent to whatever got unmapped. */
+		uirec = *irec;
+		xfs_trim_extent(&uirec, destoff + rlen, unmap_len - rlen);
+		unmap_len = rlen;
+
+		/* If this isn't a real mapping, we're done. */
+		if (!real_extent || uirec.br_blockcount == 0)
+			goto next_extent;
+
+		trace_xfs_reflink_remap(ip, uirec.br_startoff,
+				uirec.br_blockcount, uirec.br_startblock);
+
+		/* Update the refcount tree */
+		error = xfs_refcount_increase_extent(mp, &dfops, &uirec);
+		if (error)
+			goto out_defer;
+
+		/* Map the new blocks into the data fork. */
+		error = xfs_bmap_map_extent(mp, &dfops, ip, XFS_DATA_FORK,
+				&uirec);
+		if (error)
+			goto out_defer;
+
+		/* Update quota accounting. */
+		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
+				uirec.br_blockcount);
+
+		/* Update dest isize if needed. */
+		newlen = XFS_FSB_TO_B(mp,
+				uirec.br_startoff + uirec.br_blockcount);
+		newlen = min_t(xfs_off_t, newlen, new_isize);
+		if (newlen > i_size_read(VFS_I(ip))) {
+			trace_xfs_reflink_update_inode_size(ip, newlen);
+			i_size_write(VFS_I(ip), newlen);
+			ip->i_d.di_size = newlen;
+			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		}
+
+next_extent:
+		/* Process all the deferred stuff. */
+		error = xfs_defer_finish(&tp, &dfops, ip);
+		if (error)
+			goto out_defer;
+	}
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error)
+		goto out;
+	return 0;
+
+out_defer:
+	xfs_defer_cancel(&dfops);
+out_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out:
+	trace_xfs_reflink_remap_extent_error(ip, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Iteratively remap one file's extents (and holes) to another's.
+ */
+STATIC int
+xfs_reflink_remap_blocks(
+	struct xfs_inode	*src,
+	xfs_fileoff_t		srcoff,
+	struct xfs_inode	*dest,
+	xfs_fileoff_t		destoff,
+	xfs_filblks_t		len,
+	xfs_off_t		new_isize)
+{
+	struct xfs_bmbt_irec	imap;
+	int			nimaps;
+	int			error = 0;
+	xfs_filblks_t		range_len;
+
+	/* drange = (destoff, destoff + len); srange = (srcoff, srcoff + len) */
+	while (len) {
+		trace_xfs_reflink_remap_blocks_loop(src, srcoff, len,
+				dest, destoff);
+		/* Read extent from the source file */
+		nimaps = 1;
+		xfs_ilock(src, XFS_ILOCK_EXCL);
+		error = xfs_bmapi_read(src, srcoff, len, &imap, &nimaps, 0);
+		xfs_iunlock(src, XFS_ILOCK_EXCL);
+		if (error)
+			goto err;
+		ASSERT(nimaps == 1);
+
+		trace_xfs_reflink_remap_imap(src, srcoff, len, XFS_IO_OVERWRITE,
+				&imap);
+
+		/* Translate imap into the destination file. */
+		range_len = imap.br_startoff + imap.br_blockcount - srcoff;
+		imap.br_startoff += destoff - srcoff;
+
+		/* Clear dest from destoff to the end of imap and map it in. */
+		error = xfs_reflink_remap_extent(dest, &imap, destoff,
+				new_isize);
+		if (error)
+			goto err;
+
+		if (fatal_signal_pending(current)) {
+			error = -EINTR;
+			goto err;
+		}
+
+		/* Advance drange/srange */
+		srcoff += range_len;
+		destoff += range_len;
+		len -= range_len;
+	}
+
+	return 0;
+
+err:
+	trace_xfs_reflink_remap_blocks_error(dest, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Link a range of blocks from one file to another.
+ */
+int
+xfs_reflink_remap_range(
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
+	trace_xfs_reflink_remap_range(src, srcoff, len, dest, destoff);
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
+	error = xfs_reflink_set_inode_flag(src, dest);
+	if (error)
+		goto out_error;
+
+	/*
+	 * Invalidate the page cache so that we can clear any CoW mappings
+	 * in the destination file.
+	 */
+	truncate_inode_pages_range(&VFS_I(dest)->i_data, destoff,
+				   PAGE_ALIGN(destoff + len) - 1);
+
+	dfsbno = XFS_B_TO_FSBT(mp, destoff);
+	sfsbno = XFS_B_TO_FSBT(mp, srcoff);
+	fsblen = XFS_B_TO_FSB(mp, len);
+	error = xfs_reflink_remap_blocks(src, sfsbno, dest, dfsbno, fsblen,
+			destoff + len);
+	if (error)
+		goto out_error;
+
+	error = xfs_reflink_update_dest(dest, destoff + len);
+	if (error)
+		goto out_error;
+
+out_error:
+	xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
+	xfs_iunlock(src, XFS_IOLOCK_EXCL);
+	if (src->i_ino != dest->i_ino) {
+		xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
+		xfs_iunlock(dest, XFS_IOLOCK_EXCL);
+	}
+	if (error)
+		trace_xfs_reflink_remap_range_error(dest, error, _RET_IP_);
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 1d2f180..c35ce29 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -43,5 +43,7 @@ extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
 extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
+extern int xfs_reflink_remap_range(struct xfs_inode *src, xfs_off_t srcoff,
+		struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len);
 
 #endif /* __XFS_REFLINK_H */


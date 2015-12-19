Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 680B680D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:03:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 599E28F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:38 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id YoXb3R59e3BFoKQE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:35 -0800 (PST)
Subject: [PATCH 64/76] xfs: reflink extents from one file to another
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:03:32 -0800
Message-ID: <20151219090332.12713.41005.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Reflink extents from one file to another; that is to say, iteratively
remove the mappings from the destination file, copy the mappings from
the source file to the destination file, and increment the reference
count of all the blocks that got remapped.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |  445 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    3 
 2 files changed, 448 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index dcc71b9..3de3c9a 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -722,3 +722,448 @@ advloop:
 
 	return 0;
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
+static int
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
+static int
+xfs_reflink_update_dest_isize(
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
+/**
+ * xfs_reflink_remap_extent() -- Unmap a range of blocks from a file, then
+ *				 map other blocks into the hole.  The range
+ *				 to unmap is:
+ *				 (@destoff:@destoff+@srcioff+@irec.blockcount).
+ *				 The extent @irec is mapped at
+ *				 @destoff+@srcioff.
+ * @ip: XFS inode.
+ * @irec: The mapping to put into the file.
+ * @destoff: How far into the the file to start unmapping.
+ * @srcioff: How far past @destoff to start mapping.
+ */
+static int
+xfs_reflink_remap_extent(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*irec,
+	xfs_fileoff_t		destoff,
+	xfs_fileoff_t		srcioff)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	xfs_fsblock_t		firstfsb;
+	unsigned int		resblks;
+	struct xfs_bmap_free	free_list;
+	struct xfs_bmbt_irec	imap;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	struct xfs_buf		*agbp;
+	int			nimaps;
+	int			done;
+	int			committed;
+	int			error;
+
+	trace_xfs_reflink_punch_range(ip, destoff,
+			srcioff + irec->br_blockcount);
+
+	/* Start a rolling transaction to switch the mappings */
+	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
+	tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_STRAT_WRITE);
+	error = xfs_trans_reserve(tp, &M_RES(ip->i_mount)->tr_write,
+			resblks, 0);
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+	xfs_bmap_init(&free_list, &firstfsb);
+
+	/* Unmap the old blocks in the data fork. */
+	done = false;
+	while (!done) {
+		error = xfs_bunmapi(tp, ip, destoff,
+				srcioff + irec->br_blockcount, 0, 1,
+				&firstfsb, &free_list, &done);
+		if (error)
+			goto out_freelist;
+
+		error = xfs_trans_roll(&tp, ip);
+		if (error)
+			goto out_freelist;
+	}
+
+	/* If this isn't a real mapping, we're done. */
+	if (irec->br_startblock == HOLESTARTBLOCK ||
+	    irec->br_startblock == DELAYSTARTBLOCK ||
+	    ISUNWRITTEN(irec))
+		goto done;
+
+	trace_xfs_reflink_remap(ip, destoff + srcioff,
+			irec->br_blockcount, irec->br_startblock);
+
+	/* Update the refcount tree */
+	agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
+	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	if (error)
+		goto out_freelist;
+	error = xfs_refcount_increase(mp, tp, agbp, agno, agbno,
+				      irec->br_blockcount, &free_list);
+	xfs_trans_brelse(tp, agbp);
+	if (error)
+		goto out_freelist;
+
+	error = xfs_trans_roll(&tp, ip);
+	if (error)
+		goto out_freelist;
+
+	/* Map the new blocks into the data fork. */
+	firstfsb = irec->br_startblock;
+	nimaps = 1;
+	error = xfs_bmapi_write(tp, ip, destoff + srcioff,
+				irec->br_blockcount,
+				XFS_BMAPI_REMAP, &firstfsb,
+				irec->br_blockcount, &imap, &nimaps,
+				&free_list);
+	if (error)
+		goto out_freelist;
+
+	/* Process all the deferred stuff. */
+done:
+	error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error)
+		goto out;
+	return 0;
+
+out_freelist:
+	xfs_bmap_cancel(&free_list);
+out_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out:
+	trace_xfs_reflink_remap_extent_error(ip, error, _RET_IP_);
+	return error;
+}
+
+/**
+ * Iteratively remap one file's extents (and holes) to another's.
+ */
+static int
+xfs_reflink_remap_blocks(
+	struct xfs_inode	*src,
+	xfs_fileoff_t		srcoff,
+	struct xfs_inode	*dest,
+	xfs_fileoff_t		destoff,
+	xfs_filblks_t		len)
+{
+	struct xfs_bmbt_irec	imap;
+	int			nimaps;
+	int			error = 0;
+	xfs_fileoff_t		srcioff;
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
+		} else
+			xfs_trim_extent(&imap, srcoff, len);
+
+		trace_xfs_reflink_remap_imap(src, srcoff, len, XFS_IO_OVERWRITE,
+				&imap);
+
+		srcioff = imap.br_startoff - srcoff;
+		error = xfs_reflink_remap_extent(dest, &imap, destoff, srcioff);
+		if (error)
+			goto err;
+
+		/* Advance drange/srange */
+		srcoff += srcioff + imap.br_blockcount;
+		destoff += srcioff + imap.br_blockcount;
+		len -= srcioff + imap.br_blockcount;
+	}
+
+	return 0;
+
+err:
+	trace_xfs_reflink_remap_blocks_error(dest, error, _RET_IP_);
+	return error;
+}
+
+/**
+ * xfs_reflink_remap_range() -- Link a range of blocks from one file to another.
+ *
+ * @src: Inode to clone from
+ * @srcoff: Offset within source to start clone from
+ * @dest: Inode to clone to
+ * @destoff: Offset within @inode to start clone
+ * @len: Original length, passed by user, of range to clone
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
+	dfsbno = XFS_B_TO_FSBT(mp, destoff);
+	sfsbno = XFS_B_TO_FSBT(mp, srcoff);
+	fsblen = XFS_B_TO_FSB(mp, len);
+	error = xfs_reflink_remap_blocks(src, sfsbno, dest, dfsbno, fsblen);
+	if (error)
+		goto out_error;
+
+	error = xfs_reflink_update_dest_isize(dest, destoff + len);
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
index cf4b43b..df33044 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -37,4 +37,7 @@ extern int xfs_reflink_cancel_pending_cow(struct xfs_inode *ip);
 int	xfs_map_cow_blocks(struct inode *inode, xfs_off_t offset,
 			   struct xfs_bmbt_irec	*imap);
 
+extern int xfs_reflink_remap_range(struct xfs_inode *src, xfs_off_t srcoff,
+		struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

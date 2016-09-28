Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20500 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964876AbcI1DAb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 23:00:31 -0400
Subject: [PATCH 63/63] xfs: implement swapext for rmap filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 20:00:22 -0700
Message-ID: <147503162219.30303.6965672535722206241.stgit@birch.djwong.org>
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

Implement swapext for filesystems that have reverse mapping.  Back in
the reflink patches, we augmented the bmap code with a 'REMAP' flag
that updates only the bmbt and doesn't touch the allocator and
implemented log redo items for those two operations.  Now we can
rewrite extent swapping as a (looong) series of remap operations.

This is far less efficient than the fork swapping method implemented
in the past, so we only switch this on for rmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |  162 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h     |    5 +
 2 files changed, 164 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 41e25af..b9a2588 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1568,6 +1568,13 @@ xfs_swap_extents_check_format(
 		return -EINVAL;
 
 	/*
+	 * If we have to use the (expensive) rmap swap method, we can
+	 * handle any number of extents and any format.
+	 */
+	if (xfs_sb_version_hasrmapbt(&ip->i_mount->m_sb))
+		return 0;
+
+	/*
 	 * if the target inode is in extent form and the temp inode is in btree
 	 * form then we will end up with the target inode in the wrong format
 	 * as we already know there are less extents in the temp inode.
@@ -1636,6 +1643,130 @@ xfs_swap_extent_flush(
 	return 0;
 }
 
+/*
+ * Move extents from one file to another, when rmap is enabled.
+ */
+STATIC int
+xfs_swap_extent_rmap(
+	struct xfs_trans		**tpp,
+	struct xfs_inode		*ip,
+	struct xfs_inode		*tip)
+{
+	struct xfs_bmbt_irec		irec;
+	struct xfs_bmbt_irec		uirec;
+	struct xfs_bmbt_irec		tirec;
+	xfs_fileoff_t			offset_fsb;
+	xfs_fileoff_t			end_fsb;
+	xfs_filblks_t			count_fsb;
+	xfs_fsblock_t			firstfsb;
+	struct xfs_defer_ops		dfops;
+	int				error;
+	xfs_filblks_t			ilen;
+	xfs_filblks_t			rlen;
+	int				nimaps;
+	__uint64_t			tip_flags2;
+
+	/*
+	 * If the source file has shared blocks, we must flag the donor
+	 * file as having shared blocks so that we get the shared-block
+	 * rmap functions when we go to fix up the rmaps.  The flags
+	 * will be switch for reals later.
+	 */
+	tip_flags2 = tip->i_d.di_flags2;
+	if (ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK)
+		tip->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
+
+	offset_fsb = 0;
+	end_fsb = XFS_B_TO_FSB(ip->i_mount, i_size_read(VFS_I(ip)));
+	count_fsb = (xfs_filblks_t)(end_fsb - offset_fsb);
+
+	while (count_fsb) {
+		/* Read extent from the donor file */
+		nimaps = 1;
+		error = xfs_bmapi_read(tip, offset_fsb, count_fsb, &tirec,
+				&nimaps, 0);
+		if (error)
+			goto out;
+		ASSERT(nimaps == 1);
+		ASSERT(tirec.br_startblock != DELAYSTARTBLOCK);
+
+		trace_xfs_swap_extent_rmap_remap(tip, &tirec);
+		ilen = tirec.br_blockcount;
+
+		/* Unmap the old blocks in the source file. */
+		while (tirec.br_blockcount) {
+			xfs_defer_init(&dfops, &firstfsb);
+			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
+
+			/* Read extent from the source file */
+			nimaps = 1;
+			error = xfs_bmapi_read(ip, tirec.br_startoff,
+					tirec.br_blockcount, &irec,
+					&nimaps, 0);
+			if (error)
+				goto out_defer;
+			ASSERT(nimaps == 1);
+			ASSERT(tirec.br_startoff == irec.br_startoff);
+			trace_xfs_swap_extent_rmap_remap_piece(ip, &irec);
+
+			/* Trim the extent. */
+			uirec = tirec;
+			uirec.br_blockcount = rlen = min_t(xfs_filblks_t,
+					tirec.br_blockcount,
+					irec.br_blockcount);
+			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
+
+			/* Remove the mapping from the donor file. */
+			error = xfs_bmap_unmap_extent((*tpp)->t_mountp, &dfops,
+					tip, XFS_DATA_FORK, &uirec);
+			if (error)
+				goto out_defer;
+
+			/* Remove the mapping from the source file. */
+			error = xfs_bmap_unmap_extent((*tpp)->t_mountp, &dfops,
+					ip, XFS_DATA_FORK, &irec);
+			if (error)
+				goto out_defer;
+
+			/* Map the donor file's blocks into the source file. */
+			error = xfs_bmap_map_extent((*tpp)->t_mountp, &dfops,
+					ip, XFS_DATA_FORK, &uirec);
+			if (error)
+				goto out_defer;
+
+			/* Map the source file's blocks into the donor file. */
+			error = xfs_bmap_map_extent((*tpp)->t_mountp, &dfops,
+					tip, XFS_DATA_FORK, &irec);
+			if (error)
+				goto out_defer;
+
+			error = xfs_defer_finish(tpp, &dfops, ip);
+			if (error)
+				goto out_defer;
+
+			tirec.br_startoff += rlen;
+			if (tirec.br_startblock != HOLESTARTBLOCK &&
+			    tirec.br_startblock != DELAYSTARTBLOCK)
+				tirec.br_startblock += rlen;
+			tirec.br_blockcount -= rlen;
+		}
+
+		/* Roll on... */
+		count_fsb -= ilen;
+		offset_fsb += ilen;
+	}
+
+	tip->i_d.di_flags2 = tip_flags2;
+	return 0;
+
+out_defer:
+	xfs_defer_cancel(&dfops);
+out:
+	trace_xfs_swap_extent_rmap_error(ip, error, _RET_IP_);
+	tip->i_d.di_flags2 = tip_flags2;
+	return error;
+}
+
 /* Swap the extents of two files by swapping data forks. */
 STATIC int
 xfs_swap_extent_forks(
@@ -1786,6 +1917,7 @@ xfs_swap_extents(
 	int			lock_flags;
 	struct xfs_ifork	*cowfp;
 	__uint64_t		f;
+	int			resblks;
 
 	/*
 	 * Lock the inodes against other IO, page faults and truncate to
@@ -1816,7 +1948,28 @@ xfs_swap_extents(
 	if (error)
 		goto out_unlock;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	/*
+	 * Extent "swapping" with rmap requires a permanent reservation and
+	 * a block reservation because it's really just a remap operation
+	 * performed with log redo items!
+	 */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		/*
+		 * Conceptually this shouldn't affect the shape of either
+		 * bmbt, but since we atomically move extents one by one,
+		 * we reserve enough space to rebuild both trees.
+		 */
+		resblks = XFS_NEXTENTADD_SPACE_RES(mp,
+				XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK),
+				XFS_DATA_FORK) +
+			  XFS_NEXTENTADD_SPACE_RES(mp,
+				XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK),
+				XFS_DATA_FORK);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
+				0, 0, &tp);
+	} else
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0,
+				0, 0, &tp);
 	if (error)
 		goto out_unlock;
 
@@ -1875,8 +2028,11 @@ xfs_swap_extents(
 	src_log_flags = XFS_ILOG_CORE;
 	target_log_flags = XFS_ILOG_CORE;
 
-	error = xfs_swap_extent_forks(tp, ip, tip, &src_log_flags,
-			&target_log_flags);
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		error = xfs_swap_extent_rmap(&tp, ip, tip);
+	else
+		error = xfs_swap_extent_forks(tp, ip, tip, &src_log_flags,
+				&target_log_flags);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8f32481..e03f30c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3371,6 +3371,11 @@ DEFINE_INODE_EVENT(xfs_reflink_cancel_pending_cow);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cancel_cow);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_pending_cow_error);
 
+/* rmap swapext tracepoints */
+DEFINE_INODE_IREC_EVENT(xfs_swap_extent_rmap_remap);
+DEFINE_INODE_IREC_EVENT(xfs_swap_extent_rmap_remap_piece);
+DEFINE_INODE_ERROR_EVENT(xfs_swap_extent_rmap_error);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH


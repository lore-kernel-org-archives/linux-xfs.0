Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57044 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbeLAG3c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Dec 2018 01:29:32 -0500
Date: Fri, 30 Nov 2018 11:19:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: split up the xfs_reflink_end_cow work into smaller
 transactions
Message-ID: <20181130191910.GN8125@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_reflink_end_cow, we allocate a single transaction for the entire
end_cow operation and then loop the CoW fork mappings to move them to
the data fork.  This design fails on a heavily fragmented filesystem
where an inode's data fork has exactly one more extent than would fit in
an extents-format fork, because the unmap can collapse the data fork
into extents format (freeing the bmbt block) but the remap can expand
the data fork back into a (newly allocated) bmbt block.  If the number
of extents we end up remapping is large, we can overflow the block
reservation because we reserved blocks assuming that we were adding
mappings into an already-cleared area of the data fork.

Let's say we have 8 extents in the data fork, 8 extents in the CoW fork,
and the data fork can hold at most 7 extents before needing to convert
to btree format; and that blocks A-P are discontiguous single-block
extents:

   0......7
D: ABCDEFGH
C: IJKLMNOP

When a write to file blocks 0-7 completes, we must remap I-P into the
data fork.  We start by removing H from the btree-format data fork.  Now
we have 7 extents, so we convert the fork to extents format, freeing the
bmbt block.   We then move P into the data fork and it now has 8 extents
again.  We must convert the data fork back to btree format, requiring a
block allocation.  If we repeat this sequence for blocks 6-5-4-3-2-1-0,
we'll need a total of 8 block allocations to remap all 8 blocks.  We
reserved only enough blocks to handle one btree split (5 blocks on a 4k
block filesystem), which means we overflow the block reservation.

To fix this issue, create a separate helper function to remap a single
extent, and change _reflink_end_cow to call it in a tight loop over the
entire range we're completing.  As a side effect this also removes the
size restrictions on how many extents we can end_cow at a time, though
nobody ever hit that.  It is not reasonable to reserve N blocks to remap
N blocks.

Note that this can be reproduced after ~320 million fsx ops while
running generic/938 (long soak directio fsx exerciser):

XFS: Assertion failed: tp->t_blk_res >= tp->t_blk_res_used, file: fs/xfs/xfs_trans.c, line: 116
<machine registers snipped>
Call Trace:
 xfs_trans_dup+0x211/0x250 [xfs]
 xfs_trans_roll+0x6d/0x180 [xfs]
 xfs_defer_trans_roll+0x10c/0x3b0 [xfs]
 xfs_defer_finish_noroll+0xdf/0x740 [xfs]
 xfs_defer_finish+0x13/0x70 [xfs]
 xfs_reflink_end_cow+0x2c6/0x680 [xfs]
 xfs_dio_write_end_io+0x115/0x220 [xfs]
 iomap_dio_complete+0x3f/0x130
 iomap_dio_rw+0x3c3/0x420
 xfs_file_dio_aio_write+0x132/0x3c0 [xfs]
 xfs_file_write_iter+0x8b/0xc0 [xfs]
 __vfs_write+0x193/0x1f0
 vfs_write+0xba/0x1c0
 ksys_write+0x52/0xc0
 do_syscall_64+0x50/0x160
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |  202 ++++++++++++++++++++++++++------------------------
 1 file changed, 105 insertions(+), 97 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 322a852ce284..af0b2da76adf 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -623,53 +623,41 @@ xfs_reflink_cancel_cow_range(
 }
 
 /*
- * Remap parts of a file's data fork after a successful CoW.
+ * Remap part of the CoW fork into the data fork.
+ *
+ * We aim to remap the range starting at @offset_fsb and ending at @end_fsb
+ * into the data fork; this function will remap what it can (at the end of the
+ * range) and update @end_fsb appropriately.  Each remap gets its own
+ * transaction because we can end up merging and splitting bmbt blocks for
+ * every remap operation and we'd like to keep the block reservation
+ * requirements as low as possible.
  */
-int
-xfs_reflink_end_cow(
-	struct xfs_inode		*ip,
-	xfs_off_t			offset,
-	xfs_off_t			count)
+STATIC int
+xfs_reflink_end_cow_extent(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		offset_fsb,
+	xfs_fileoff_t		*end_fsb)
 {
-	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
-	struct xfs_bmbt_irec		got, del;
-	struct xfs_trans		*tp;
-	xfs_fileoff_t			offset_fsb;
-	xfs_fileoff_t			end_fsb;
-	int				error;
-	unsigned int			resblks;
-	xfs_filblks_t			rlen;
-	struct xfs_iext_cursor		icur;
-
-	trace_xfs_reflink_end_cow(ip, offset, count);
+	struct xfs_bmbt_irec	got, del;
+	struct xfs_iext_cursor	icur;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	xfs_filblks_t		rlen;
+	unsigned int		resblks;
+	int			error;
 
 	/* No COW extents?  That's easy! */
-	if (ifp->if_bytes == 0)
+	if (ifp->if_bytes == 0) {
+		*end_fsb = offset_fsb;
 		return 0;
-
-	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
-	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
-
-	/*
-	 * Start a rolling transaction to switch the mappings.  We're
-	 * unlikely ever to have to remap 16T worth of single-block
-	 * extents, so just cap the worst case extent count to 2^32-1.
-	 * Stick a warning in just in case, and avoid 64-bit division.
-	 */
-	BUILD_BUG_ON(MAX_RW_COUNT > UINT_MAX);
-	if (end_fsb - offset_fsb > UINT_MAX) {
-		error = -EFSCORRUPTED;
-		xfs_force_shutdown(ip->i_mount, SHUTDOWN_CORRUPT_INCORE);
-		ASSERT(0);
-		goto out;
 	}
-	resblks = XFS_NEXTENTADD_SPACE_RES(ip->i_mount,
-			(unsigned int)(end_fsb - offset_fsb),
-			XFS_DATA_FORK);
-	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
-			resblks, 0, XFS_TRANS_RESERVE | XFS_TRANS_NOFS, &tp);
+
+	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
+			XFS_TRANS_RESERVE | XFS_TRANS_NOFS, &tp);
 	if (error)
-		goto out;
+		goto out_err;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
@@ -679,80 +667,100 @@ xfs_reflink_end_cow(
 	 * left by the time I/O completes for the loser of the race.  In that
 	 * case we are done.
 	 */
-	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
+	if (!xfs_iext_lookup_extent_before(ip, ifp, end_fsb, &icur, &got) ||
+	    got.br_startoff + got.br_blockcount <= offset_fsb) {
+		*end_fsb = offset_fsb;
 		goto out_cancel;
+	}
 
-	/* Walk backwards until we're out of the I/O range... */
-	while (got.br_startoff + got.br_blockcount > offset_fsb) {
-		del = got;
-		xfs_trim_extent(&del, offset_fsb, end_fsb - offset_fsb);
-
-		/* Extent delete may have bumped ext forward */
-		if (!del.br_blockcount)
-			goto prev_extent;
+	/*
+	 * Structure copy @got into @del, then trim @del to the range that we
+	 * were asked to remap.  We preserve @got for the eventual CoW fork
+	 * deletion; from now on @del represents the mapping that we're
+	 * actually remapping.
+	 */
+	del = got;
+	xfs_trim_extent(&del, offset_fsb, *end_fsb - offset_fsb);
 
-		/*
-		 * Only remap real extent that contain data.  With AIO
-		 * speculatively preallocations can leak into the range we
-		 * are called upon, and we need to skip them.
-		 */
-		if (!xfs_bmap_is_real_extent(&got))
-			goto prev_extent;
+	ASSERT(del.br_blockcount > 0);
 
-		/* Unmap the old blocks in the data fork. */
-		ASSERT(tp->t_firstblock == NULLFSBLOCK);
-		rlen = del.br_blockcount;
-		error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1);
-		if (error)
-			goto out_cancel;
+	/*
+	 * Only remap real extents that contain data.  With AIO, speculative
+	 * preallocations can leak into the range we are called upon, and we
+	 * need to skip them.
+	 */
+	if (!xfs_bmap_is_real_extent(&got)) {
+		*end_fsb = del.br_startoff;
+		goto out_cancel;
+	}
 
-		/* Trim the extent to whatever got unmapped. */
-		if (rlen) {
-			xfs_trim_extent(&del, del.br_startoff + rlen,
-				del.br_blockcount - rlen);
-		}
-		trace_xfs_reflink_cow_remap(ip, &del);
+	/* Unmap the old blocks in the data fork. */
+	rlen = del.br_blockcount;
+	error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1);
+	if (error)
+		goto out_cancel;
 
-		/* Free the CoW orphan record. */
-		error = xfs_refcount_free_cow_extent(tp, del.br_startblock,
-				del.br_blockcount);
-		if (error)
-			goto out_cancel;
+	/* Trim the extent to whatever got unmapped. */
+	xfs_trim_extent(&del, del.br_startoff + rlen, del.br_blockcount - rlen);
+	trace_xfs_reflink_cow_remap(ip, &del);
 
-		/* Map the new blocks into the data fork. */
-		error = xfs_bmap_map_extent(tp, ip, &del);
-		if (error)
-			goto out_cancel;
+	/* Free the CoW orphan record. */
+	error = xfs_refcount_free_cow_extent(tp, del.br_startblock,
+			del.br_blockcount);
+	if (error)
+		goto out_cancel;
 
-		/* Charge this new data fork mapping to the on-disk quota. */
-		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
-				(long)del.br_blockcount);
+	/* Map the new blocks into the data fork. */
+	error = xfs_bmap_map_extent(tp, ip, &del);
+	if (error)
+		goto out_cancel;
 
-		/* Remove the mapping from the CoW fork. */
-		xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
+	/* Charge this new data fork mapping to the on-disk quota. */
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
+			(long)del.br_blockcount);
 
-		error = xfs_defer_finish(&tp);
-		if (error)
-			goto out_cancel;
-		if (!xfs_iext_get_extent(ifp, &icur, &got))
-			break;
-		continue;
-prev_extent:
-		if (!xfs_iext_prev_extent(ifp, &icur, &got))
-			break;
-	}
+	/* Remove the mapping from the CoW fork. */
+	xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
 
 	error = xfs_trans_commit(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	if (error)
-		goto out;
-	return 0;
+		goto out_unlock;
 
+	/* Update the caller about how much progress we made. */
+	*end_fsb = del.br_startoff;
+	goto out_unlock;
 out_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-out:
-	trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
+out_err:
+	return error;
+}
+
+/*
+ * Remap parts of a file's data fork after a successful CoW.
+ */
+int
+xfs_reflink_end_cow(
+	struct xfs_inode		*ip,
+	xfs_off_t			offset,
+	xfs_off_t			count)
+{
+	xfs_fileoff_t			offset_fsb;
+	xfs_fileoff_t			end_fsb;
+	int				error = 0;
+
+	trace_xfs_reflink_end_cow(ip, offset, count);
+
+	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
+	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
+
+	/* Walk backwards until we're out of the I/O range... */
+	while (end_fsb > offset_fsb && !error)
+		error = xfs_reflink_end_cow_extent(ip, offset_fsb, &end_fsb);
+
+	if (error)
+		trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
 	return error;
 }
 

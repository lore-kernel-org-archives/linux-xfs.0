Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:45517 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbeHTIDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Aug 2018 04:03:17 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0006S6-7E
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0000QM-6I
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/10] xfs: replace XFS_FORCED_SHUTDOWN with xfs_is_shut_down
Date: Mon, 20 Aug 2018 14:48:47 +1000
Message-Id: <20180820044851.414-7-david@fromorbit.com>
In-Reply-To: <20180820044851.414-1-david@fromorbit.com>
References: <20180820044851.414-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Remove the shouty macro and instead use the inline function that
matches other state/feature check wrapper naming. This conversion
was done with sed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c      |  2 +-
 fs/xfs/libxfs/xfs_attr.c       |  6 +++---
 fs/xfs/libxfs/xfs_bmap.c       | 16 ++++++++--------
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |  8 ++++----
 fs/xfs/libxfs/xfs_ialloc.c     |  6 +++---
 fs/xfs/scrub/scrub.c           |  2 +-
 fs/xfs/xfs_aops.c              |  8 ++++----
 fs/xfs/xfs_attr_list.c         |  2 +-
 fs/xfs/xfs_bmap_util.c         |  8 ++++----
 fs/xfs/xfs_buf.c               |  2 +-
 fs/xfs/xfs_buf_item.c          |  4 ++--
 fs/xfs/xfs_dir2_readdir.c      |  2 +-
 fs/xfs/xfs_dquot.c             |  2 +-
 fs/xfs/xfs_file.c              | 12 ++++++------
 fs/xfs/xfs_fsops.c             |  2 +-
 fs/xfs/xfs_icache.c            |  4 ++--
 fs/xfs/xfs_inode.c             | 20 ++++++++++----------
 fs/xfs/xfs_inode_item.c        |  6 +++---
 fs/xfs/xfs_ioctl.c             |  8 ++++----
 fs/xfs/xfs_ioctl32.c           |  2 +-
 fs/xfs/xfs_iomap.c             |  6 +++---
 fs/xfs/xfs_iops.c              |  4 ++--
 fs/xfs/xfs_log_recover.c       |  8 ++++----
 fs/xfs/xfs_mount.c             |  2 +-
 fs/xfs/xfs_mount.h             |  4 +---
 fs/xfs/xfs_pnfs.c              |  2 +-
 fs/xfs/xfs_qm.c                |  4 ++--
 fs/xfs/xfs_reflink.c           |  2 +-
 fs/xfs/xfs_super.c             |  2 +-
 fs/xfs/xfs_symlink.c           |  8 ++++----
 fs/xfs/xfs_trans.c             |  8 ++++----
 fs/xfs/xfs_trans_ail.c         |  8 ++++----
 fs/xfs/xfs_trans_buf.c         | 10 +++++-----
 34 files changed, 95 insertions(+), 97 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ad7e63d2cd67..f23d3c7ea537 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2751,7 +2751,7 @@ xfs_alloc_read_agf(
 		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
 	}
 #ifdef DEBUG
-	else if (!XFS_FORCED_SHUTDOWN(mp)) {
+	else if (!xfs_is_shut_down(mp)) {
 		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
 		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
 		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 5ca0233fe135..1932758b8faf 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -135,7 +135,7 @@ xfs_attr_get(
 
 	XFS_STATS_INC(ip->i_mount, xs_attr_get);
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (xfs_is_shut_down(ip->i_mount))
 		return -EIO;
 
 	error = xfs_attr_args_init(&args, ip, name, flags);
@@ -208,7 +208,7 @@ xfs_attr_set(
 
 	XFS_STATS_INC(mp, xs_attr_set);
 
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+	if (xfs_is_shut_down(dp->i_mount))
 		return -EIO;
 
 	error = xfs_attr_args_init(&args, dp, name, flags);
@@ -387,7 +387,7 @@ xfs_attr_remove(
 
 	XFS_STATS_INC(mp, xs_attr_remove);
 
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+	if (xfs_is_shut_down(dp->i_mount))
 		return -EIO;
 
 	error = xfs_attr_args_init(&args, dp, name, flags);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 459b08856f3f..5e12f6b3be7f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3816,7 +3816,7 @@ xfs_bmapi_read(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_blk_mapr);
@@ -4260,7 +4260,7 @@ xfs_bmapi_write(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -4485,7 +4485,7 @@ xfs_bmapi_remap(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
@@ -5124,7 +5124,7 @@ __xfs_bunmapi(
 		return -EFSCORRUPTED;
 	}
 	mp = ip->i_mount;
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -5632,7 +5632,7 @@ xfs_bmap_collapse_extents(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
@@ -5710,7 +5710,7 @@ xfs_bmap_can_insert_extents(
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (xfs_is_shut_down(ip->i_mount))
 		return -EIO;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -5750,7 +5750,7 @@ xfs_bmap_insert_extents(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
@@ -5857,7 +5857,7 @@ xfs_bmap_split_extent_at(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 7ae94e0c111c..79052c19881b 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1080,7 +1080,7 @@ xfs_dir2_sf_to_block(
 	 * Bomb out if the shortform directory is way too short.
 	 */
 	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		ASSERT(xfs_is_shut_down(mp));
 		return -EIO;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 8f5e17f79151..223eb7ccb927 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -284,7 +284,7 @@ xfs_dir2_sf_addname(
 	 * Make sure the shortform value has some of its header.
 	 */
 	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
-		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
+		ASSERT(xfs_is_shut_down(dp->i_mount));
 		return -EIO;
 	}
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
@@ -800,7 +800,7 @@ xfs_dir2_sf_lookup(
 	 * Bail out if the directory is way too short.
 	 */
 	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
-		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
+		ASSERT(xfs_is_shut_down(dp->i_mount));
 		return -EIO;
 	}
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
@@ -886,7 +886,7 @@ xfs_dir2_sf_removename(
 	 * Bail out if the directory is way too short.
 	 */
 	if (oldsize < offsetof(xfs_dir2_sf_hdr_t, parent)) {
-		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
+		ASSERT(xfs_is_shut_down(dp->i_mount));
 		return -EIO;
 	}
 	ASSERT(dp->i_df.if_bytes == oldsize);
@@ -970,7 +970,7 @@ xfs_dir2_sf_replace(
 	 * Bail out if the shortform directory is way too small.
 	 */
 	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
-		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
+		ASSERT(xfs_is_shut_down(dp->i_mount));
 		return -EIO;
 	}
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index ffb1caf4c34a..bbf9efcd6aea 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -260,7 +260,7 @@ xfs_check_agi_freecount(
 			}
 		} while (i == 1);
 
-		if (!XFS_FORCED_SHUTDOWN(cur->bc_mp))
+		if (!xfs_is_shut_down(cur->bc_mp))
 			ASSERT(freecount == be32_to_cpu(agi->agi_freecount));
 	}
 	return 0;
@@ -1035,7 +1035,7 @@ xfs_ialloc_ag_select(
 		 * No point in iterating over the rest, if we're shutting
 		 * down.
 		 */
-		if (XFS_FORCED_SHUTDOWN(mp))
+		if (xfs_is_shut_down(mp))
 			return NULLAGNUMBER;
 		agno++;
 		if (agno >= agcount)
@@ -2648,7 +2648,7 @@ xfs_ialloc_read_agi(
 	 * we are in the middle of a forced shutdown.
 	 */
 	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		XFS_FORCED_SHUTDOWN(mp));
+		xfs_is_shut_down(mp));
 	xfs_perag_put(pag);
 	return 0;
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index f2cb022a23ab..8c1edb39fb8c 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -492,7 +492,7 @@ xfs_scrub_metadata(
 
 	/* Forbidden if we are shut down or mounted norecovery. */
 	error = -ESHUTDOWN;
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		goto out;
 	error = -ENOTRECOVERABLE;
 	if (xfs_has_norecovery(mp))
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 49f5f5896a43..83fa2c85239c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -245,7 +245,7 @@ xfs_end_io(
 	/*
 	 * Just clean up the in-memory strutures if the fs has been shut down.
 	 */
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+	if (xfs_is_shut_down(ip->i_mount)) {
 		error = -EIO;
 		goto done;
 	}
@@ -354,7 +354,7 @@ xfs_map_blocks(
 	     wpc->cow_seq == READ_ONCE(ip->i_cowfp->if_seq)))
 		return 0;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	/*
@@ -658,7 +658,7 @@ xfs_aops_discard_page(
 	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, offset);
 	int			error;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		goto out_invalidate;
 
 	xfs_alert(mp,
@@ -667,7 +667,7 @@ xfs_aops_discard_page(
 
 	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
 			PAGE_SIZE / i_blocksize(inode));
-	if (error && !XFS_FORCED_SHUTDOWN(mp))
+	if (error && !xfs_is_shut_down(mp))
 		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
 out_invalidate:
 	xfs_vm_invalidatepage(page, 0, PAGE_SIZE);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index a58034049995..ef6465e3275a 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -523,7 +523,7 @@ xfs_attr_list_int(
 
 	XFS_STATS_INC(dp->i_mount, xs_attr_list);
 
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+	if (xfs_is_shut_down(dp->i_mount))
 		return -EIO;
 
 	lock_mode = xfs_ilock_attr_map_shared(dp);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index bd733b256fee..8bdaa39f3812 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -828,7 +828,7 @@ xfs_free_eofblocks(
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0,
 				&tp);
 		if (error) {
-			ASSERT(XFS_FORCED_SHUTDOWN(mp));
+			ASSERT(xfs_is_shut_down(mp));
 			return error;
 		}
 
@@ -883,7 +883,7 @@ xfs_alloc_file_space(
 
 	trace_xfs_alloc_file_space(ip);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	error = xfs_qm_dqattach(ip);
@@ -959,7 +959,7 @@ xfs_alloc_file_space(
 			/*
 			 * Free the transaction structure.
 			 */
-			ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+			ASSERT(error == -ENOSPC || xfs_is_shut_down(mp));
 			break;
 		}
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -1020,7 +1020,7 @@ xfs_unmap_extent(
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	if (error) {
-		ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+		ASSERT(error == -ENOSPC || xfs_is_shut_down(mp));
 		return error;
 	}
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8043c7a8c2e0..3290a7d10824 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1466,7 +1466,7 @@ __xfs_buf_submit(
 	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 
 	/* on shutdown we stale and complete the buffer immediately */
-	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
+	if (xfs_is_shut_down(bp->b_target->bt_mount)) {
 		xfs_buf_ioerror(bp, -EIO);
 		bp->b_flags &= ~XBF_DONE;
 		xfs_buf_stale(bp);
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index de99015fd715..1b2b05ed2a99 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -617,7 +617,7 @@ xfs_buf_item_unlock(
 	 */
 	if (atomic_dec_and_test(&bip->bli_refcount)) {
 		if (aborted) {
-			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
+			ASSERT(xfs_is_shut_down(lip->li_mountp));
 			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
 		} else if (!dirty)
@@ -1081,7 +1081,7 @@ xfs_buf_iodone_callback_error(
 	 * If we've already decided to shutdown the filesystem because of
 	 * I/O errors, there's no point in giving this a retry.
 	 */
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		goto out_stale;
 
 	if (bp->b_target != lasttarg ||
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 5b1d16b2a823..acbe265a0031 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -506,7 +506,7 @@ xfs_readdir(
 
 	trace_xfs_readdir(dp);
 
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+	if (xfs_is_shut_down(dp->i_mount))
 		return -EIO;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 296d6cdfe7aa..5e55d369a56e 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1094,7 +1094,7 @@ xfs_qm_dqflush(
 	 * We also have to remove the log item from the AIL in this case,
 	 * as we wait for an emptry AIL as part of the unmount process.
 	 */
-	if (XFS_FORCED_SHUTDOWN(mp)) {
+	if (xfs_is_shut_down(mp)) {
 		struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
 		dqp->dq_flags &= ~XFS_DQ_DIRTY;
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5eaef2c17293..2111b1883394 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -119,7 +119,7 @@ xfs_file_fsync(
 	if (error)
 		return error;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
@@ -259,7 +259,7 @@ xfs_file_read_iter(
 
 	XFS_STATS_INC(mp, xs_read_calls);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	if (IS_DAX(inode))
@@ -396,7 +396,7 @@ xfs_dio_write_end_io(
 
 	trace_xfs_end_io_direct_write(ip, offset, size);
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (xfs_is_shut_down(ip->i_mount))
 		return -EIO;
 
 	if (size <= 0)
@@ -698,7 +698,7 @@ xfs_file_write_iter(
 	if (ocount == 0)
 		return 0;
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (xfs_is_shut_down(ip->i_mount))
 		return -EIO;
 
 	if (IS_DAX(inode))
@@ -965,7 +965,7 @@ xfs_file_open(
 {
 	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
 		return -EFBIG;
-	if (XFS_FORCED_SHUTDOWN(XFS_M(inode->i_sb)))
+	if (xfs_is_shut_down(XFS_M(inode->i_sb)))
 		return -EIO;
 	file->f_mode |= FMODE_NOWAIT;
 	return 0;
@@ -1037,7 +1037,7 @@ xfs_file_llseek(
 {
 	struct inode		*inode = file->f_mapping->host;
 
-	if (XFS_FORCED_SHUTDOWN(XFS_I(inode)->i_mount))
+	if (xfs_is_shut_down(XFS_I(inode)->i_mount))
 		return -EIO;
 
 	switch (whence) {
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 7c429c5b3a53..ed29294e1b4f 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -487,7 +487,7 @@ xfs_do_force_shutdown(
 	/*
 	 * No need to duplicate efforts.
 	 */
-	if (XFS_FORCED_SHUTDOWN(mp) && !logerror)
+	if (xfs_is_shut_down(mp) && !logerror)
 		return;
 
 	/*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 245483cc282b..4878f958a0c3 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -758,7 +758,7 @@ xfs_inode_ag_walk_grab(
 	spin_unlock(&ip->i_flags_lock);
 
 	/* nothing to sync during shutdown */
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (xfs_is_shut_down(ip->i_mount))
 		return -EFSCORRUPTED;
 
 	/* If we can't grab the inode, it must on it's way to reclaim. */
@@ -1106,7 +1106,7 @@ xfs_reclaim_inode(
 		xfs_iflock(ip);
 	}
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+	if (xfs_is_shut_down(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
 		/* xfs_iflush_abort() drops the flush lock */
 		xfs_iflush_abort(ip, false);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5e396dca456e..c1e6d94efd6c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -693,7 +693,7 @@ xfs_lookup(
 
 	trace_xfs_lookup(dp, name);
 
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+	if (xfs_is_shut_down(dp->i_mount))
 		return -EIO;
 
 	error = xfs_dir_lookup(NULL, dp, name, &inum, ci_name);
@@ -1152,7 +1152,7 @@ xfs_create(
 
 	trace_xfs_create(dp, name);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	prid = xfs_get_initial_prid(dp);
@@ -1305,7 +1305,7 @@ xfs_create_tmpfile(
 	struct xfs_trans_res	*tres;
 	uint			resblks;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	prid = xfs_get_initial_prid(dp);
@@ -1396,7 +1396,7 @@ xfs_link(
 
 	ASSERT(!S_ISDIR(VFS_I(sip)->i_mode));
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	error = xfs_qm_dqattach(sip);
@@ -1623,7 +1623,7 @@ xfs_release(
 	if (xfs_is_readonly(mp))
 		return 0;
 
-	if (!XFS_FORCED_SHUTDOWN(mp)) {
+	if (!xfs_is_shut_down(mp)) {
 		int truncated;
 
 		/*
@@ -1704,7 +1704,7 @@ xfs_inactive_truncate(
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		ASSERT(xfs_is_shut_down(mp));
 		return error;
 	}
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -1775,7 +1775,7 @@ xfs_inactive_ifree(
 			"Failed to remove inode(s) from unlinked list. "
 			"Please free space, unmount and run xfs_repair.");
 		} else {
-			ASSERT(XFS_FORCED_SHUTDOWN(mp));
+			ASSERT(xfs_is_shut_down(mp));
 		}
 		return error;
 	}
@@ -1790,7 +1790,7 @@ xfs_inactive_ifree(
 		 * might do that, we need to make sure.  Otherwise the
 		 * inode might be lost for a long time or forever.
 		 */
-		if (!XFS_FORCED_SHUTDOWN(mp)) {
+		if (!xfs_is_shut_down(mp)) {
 			xfs_notice(mp, "%s: xfs_ifree returned error %d",
 				__func__, error);
 			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
@@ -2541,7 +2541,7 @@ xfs_remove(
 
 	trace_xfs_remove(dp, name);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	error = xfs_qm_dqattach(dp);
@@ -3352,7 +3352,7 @@ xfs_iflush(
 	 * We also have to remove the log item from the AIL in this case,
 	 * as we wait for an empty AIL as part of the unmount process.
 	 */
-	if (XFS_FORCED_SHUTDOWN(mp)) {
+	if (xfs_is_shut_down(mp)) {
 		error = -EIO;
 		goto abort_out;
 	}
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index fa1c4fe2ffbf..f97430a237d4 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -543,8 +543,8 @@ xfs_inode_item_push(
 		goto out_unlock;
 	}
 
-	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
-	ASSERT(iip->ili_logged == 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
+	ASSERT(iip->ili_fields != 0 || xfs_is_shut_down(ip->i_mount));
+	ASSERT(iip->ili_logged == 0 || xfs_is_shut_down(ip->i_mount));
 
 	spin_unlock(&lip->li_ailp->ail_lock);
 
@@ -747,7 +747,7 @@ xfs_iflush_done(
 		}
 
 		if (mlip_changed) {
-			if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
+			if (!xfs_is_shut_down(ailp->ail_mount))
 				xlog_assign_tail_lsn_locked(ailp->ail_mount);
 			if (list_empty(&ailp->ail_head))
 				wake_up_all(&ailp->ail_empty);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d3bd93ba29a8..6238b6bb7653 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -309,7 +309,7 @@ xfs_set_dmattrs(
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
@@ -745,7 +745,7 @@ xfs_ioc_bulkstat(
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	if (copy_from_user(&bulkreq, arg, sizeof(xfs_fsop_bulkreq_t)))
@@ -1145,7 +1145,7 @@ xfs_ioctl_setattr_get_trans(
 	if (xfs_is_readonly(mp))
 		goto out_unlock;
 	error = -EIO;
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		goto out_unlock;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
@@ -1786,7 +1786,7 @@ xfs_ioc_swapext(
 		goto out_put_tmp_file;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+	if (xfs_is_shut_down(ip->i_mount)) {
 		error = -EIO;
 		goto out_put_tmp_file;
 	}
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index fba115f4103a..375d5baead9e 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -247,7 +247,7 @@ xfs_compat_ioc_bulkstat(
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	if (get_user(addr, &p32->lastip))
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 3c999ea64021..d975f35594e7 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1006,7 +1006,7 @@ xfs_file_iomap_begin(
 	bool			shared = false, trimmed = false;
 	unsigned		lockmode;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
@@ -1181,7 +1181,7 @@ xfs_file_iomap_end_delalloc(
 
 		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
 					       end_fsb - start_fsb);
-		if (error && !XFS_FORCED_SHUTDOWN(mp)) {
+		if (error && !xfs_is_shut_down(mp)) {
 			xfs_alert(mp, "%s: unable to clean up ino %lld",
 				__func__, ip->i_ino);
 			return error;
@@ -1227,7 +1227,7 @@ xfs_xattr_iomap_begin(
 	int			nimaps = 1, error = 0;
 	unsigned		lockmode;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	lockmode = xfs_ilock_attr_map_shared(ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 58ef007bccea..c2f028c3f8f5 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -488,7 +488,7 @@ xfs_vn_getattr(
 
 	trace_xfs_getattr(ip);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	stat->size = XFS_ISIZE(ip);
@@ -584,7 +584,7 @@ xfs_vn_change_ok(
 	if (xfs_is_readonly(mp))
 		return -EROFS;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	return setattr_prepare(dentry, iattr);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 49579de464f6..043b1a6c5ebd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -197,7 +197,7 @@ xlog_bread_noalign(
 	bp->b_error = 0;
 
 	error = xfs_buf_submit(bp);
-	if (error && !XFS_FORCED_SHUTDOWN(log->l_mp))
+	if (error && !xfs_is_shut_down(log->l_mp))
 		xfs_buf_ioerror_alert(bp, __func__);
 	return error;
 }
@@ -377,7 +377,7 @@ xlog_recover_iodone(
 		 * We're not going to bother about retrying
 		 * this during recovery. One strike!
 		 */
-		if (!XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
+		if (!xfs_is_shut_down(bp->b_target->bt_mount)) {
 			xfs_buf_ioerror_alert(bp, __func__);
 			xfs_force_shutdown(bp->b_target->bt_mount,
 						SHUTDOWN_META_IO_ERROR);
@@ -5682,7 +5682,7 @@ xlog_do_recover(
 	/*
 	 * If IO errors happened during recovery, bail out.
 	 */
-	if (XFS_FORCED_SHUTDOWN(mp)) {
+	if (xfs_is_shut_down(mp)) {
 		return -EIO;
 	}
 
@@ -5709,7 +5709,7 @@ xlog_do_recover(
 
 	error = xfs_buf_submit(bp);
 	if (error) {
-		if (!XFS_FORCED_SHUTDOWN(mp)) {
+		if (!xfs_is_shut_down(mp)) {
 			xfs_buf_ioerror_alert(bp, __func__);
 			ASSERT(0);
 		}
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7cb2577dbd73..d7b5ed30d4c9 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1187,7 +1187,7 @@ xfs_fs_writable(
 {
 	ASSERT(level > SB_UNFROZEN);
 	if ((mp->m_super->s_writers.frozen >= level) ||
-	    XFS_FORCED_SHUTDOWN(mp) || xfs_is_readonly(mp))
+	    xfs_is_shut_down(mp) || xfs_is_readonly(mp))
 		return false;
 
 	return true;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 03f4681c1ba6..2a7e7ef7c338 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -296,7 +296,7 @@ __XFS_HAS_FEAT(realtime, REALTIME)
  * Mount features
  *
  * These do not change dynamically - features that can come and go,
- * such as 32 bit inodes and read-only state, are kept as flags rather than
+ * such as 32 bit inodes and read-only state, are kept as state rather than
  * features.
  */
 __XFS_HAS_FEAT(wsync, WSYNC)
@@ -383,8 +383,6 @@ xfs_preferred_iosize(xfs_mount_t *mp)
 	return PAGE_SIZE;
 }
 
-#define XFS_FORCED_SHUTDOWN(mp) \
-		test_bit(XFS_STATE_SHUTDOWN, &(mp)->m_state)
 void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 		int lnnum);
 #define xfs_force_shutdown(m,f)	\
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index f44c3599527d..2908dcfa9ecf 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -99,7 +99,7 @@ xfs_fs_map_blocks(
 	uint			lock_flags;
 	int			error = 0;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	/*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 9ee840472138..1957042882d5 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -157,7 +157,7 @@ xfs_qm_dqpurge(
 	}
 
 	ASSERT(atomic_read(&dqp->q_pincount) == 0);
-	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
+	ASSERT(xfs_is_shut_down(mp) ||
 		!test_bit(XFS_LI_IN_AIL, &dqp->q_logitem.qli_item.li_flags));
 
 	xfs_dqfunlock(dqp);
@@ -815,7 +815,7 @@ xfs_qm_qino_alloc(
 
 	error = xfs_trans_commit(tp);
 	if (error) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		ASSERT(xfs_is_shut_down(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
 	}
 	if (need_alloc)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 66ba7c4446d5..b1196911a8b2 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1221,7 +1221,7 @@ xfs_reflink_remap_range(
 	if (!xfs_has_reflink(mp))
 		return -EOPNOTSUPP;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	/* Lock both files against IO */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9938d9fb420b..7c1e03539b5e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -949,7 +949,7 @@ xfs_fs_destroy_inode(
 
 	xfs_inactive(ip);
 
-	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
+	ASSERT(xfs_is_shut_down(ip->i_mount) || ip->i_delayed_blks == 0);
 	XFS_STATS_INC(ip->i_mount, vn_reclaim);
 
 	/*
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 675481028292..41e1054748e5 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -124,7 +124,7 @@ xfs_readlink(
 
 	ASSERT(!(ip->i_df.if_flags & XFS_IFINLINE));
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
@@ -183,7 +183,7 @@ xfs_symlink(
 
 	trace_xfs_symlink(dp, link_name);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	/*
@@ -456,7 +456,7 @@ xfs_inactive_symlink_rmt(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = xfs_trans_commit(tp);
 	if (error) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		ASSERT(xfs_is_shut_down(mp));
 		goto error_unlock;
 	}
 
@@ -489,7 +489,7 @@ xfs_inactive_symlink(
 
 	trace_xfs_inactive_symlink(ip);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shut_down(mp))
 		return -EIO;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index db4367baab34..5c064bc8d49a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -857,7 +857,7 @@ xfs_trans_committed_bulk(
 		 * object into the AIL as we are in a shutdown situation.
 		 */
 		if (aborted) {
-			ASSERT(XFS_FORCED_SHUTDOWN(ailp->ail_mount));
+			ASSERT(xfs_is_shut_down(ailp->ail_mount));
 			lip->li_ops->iop_unpin(lip, 1);
 			continue;
 		}
@@ -944,7 +944,7 @@ __xfs_trans_commit(
 	if (!(tp->t_flags & XFS_TRANS_DIRTY))
 		goto out_unreserve;
 
-	if (XFS_FORCED_SHUTDOWN(mp)) {
+	if (xfs_is_shut_down(mp)) {
 		error = -EIO;
 		goto out_unreserve;
 	}
@@ -1031,12 +1031,12 @@ xfs_trans_cancel(
 	 * filesystem.  This happens in paths where we detect
 	 * corruption and decide to give up.
 	 */
-	if (dirty && !XFS_FORCED_SHUTDOWN(mp)) {
+	if (dirty && !xfs_is_shut_down(mp)) {
 		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	}
 #ifdef DEBUG
-	if (!dirty && !XFS_FORCED_SHUTDOWN(mp)) {
+	if (!dirty && !xfs_is_shut_down(mp)) {
 		struct xfs_log_item *lip;
 
 		list_for_each_entry(lip, &tp->t_items, li_trans)
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 55326f971cb3..19e79d8279fc 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -601,7 +601,7 @@ xfs_ail_push(
 	xfs_log_item_t	*lip;
 
 	lip = xfs_ail_min(ailp);
-	if (!lip || XFS_FORCED_SHUTDOWN(ailp->ail_mount) ||
+	if (!lip || xfs_is_shut_down(ailp->ail_mount) ||
 	    XFS_LSN_CMP(threshold_lsn, ailp->ail_target) <= 0)
 		return;
 
@@ -713,7 +713,7 @@ xfs_trans_ail_update_bulk(
 		xfs_ail_splice(ailp, cur, &tmp, lsn);
 
 	if (mlip_changed) {
-		if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
+		if (!xfs_is_shut_down(ailp->ail_mount))
 			xlog_assign_tail_lsn_locked(ailp->ail_mount);
 		spin_unlock(&ailp->ail_lock);
 
@@ -771,7 +771,7 @@ xfs_trans_ail_delete(
 
 	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 		spin_unlock(&ailp->ail_lock);
-		if (!XFS_FORCED_SHUTDOWN(mp)) {
+		if (!xfs_is_shut_down(mp)) {
 			xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
 	"%s: attempting to delete a log item that is not in the AIL",
 					__func__);
@@ -782,7 +782,7 @@ xfs_trans_ail_delete(
 
 	mlip_changed = xfs_ail_delete_one(ailp, lip);
 	if (mlip_changed) {
-		if (!XFS_FORCED_SHUTDOWN(mp))
+		if (!xfs_is_shut_down(mp))
 			xlog_assign_tail_lsn_locked(mp);
 		if (list_empty(&ailp->ail_head))
 			wake_up_all(&ailp->ail_empty);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 15919f67a88f..f18d5cd0f606 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -137,7 +137,7 @@ xfs_trans_get_buf_map(
 	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
 	if (bp != NULL) {
 		ASSERT(xfs_buf_islocked(bp));
-		if (XFS_FORCED_SHUTDOWN(tp->t_mountp)) {
+		if (xfs_is_shut_down(tp->t_mountp)) {
 			xfs_buf_stale(bp);
 			bp->b_flags |= XBF_DONE;
 		}
@@ -259,7 +259,7 @@ xfs_trans_read_buf_map(
 		 * We never locked this buf ourselves, so we shouldn't
 		 * brelse it either. Just get out.
 		 */
-		if (XFS_FORCED_SHUTDOWN(mp)) {
+		if (xfs_is_shut_down(mp)) {
 			trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
 			return -EIO;
 		}
@@ -291,7 +291,7 @@ xfs_trans_read_buf_map(
 	 */
 	if (bp->b_error) {
 		error = bp->b_error;
-		if (!XFS_FORCED_SHUTDOWN(mp))
+		if (!xfs_is_shut_down(mp))
 			xfs_buf_ioerror_alert(bp, __func__);
 		bp->b_flags &= ~XBF_DONE;
 		xfs_buf_stale(bp);
@@ -306,7 +306,7 @@ xfs_trans_read_buf_map(
 		return error;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp)) {
+	if (xfs_is_shut_down(mp)) {
 		xfs_buf_relse(bp);
 		trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
 		return -EIO;
@@ -418,7 +418,7 @@ xfs_trans_brelse(
 	 * due to our reference). Since we're already shutdown and need
 	 * ail_lock, just force remove from the AIL and release the bli here.
 	 */
-	if (XFS_FORCED_SHUTDOWN(tp->t_mountp) && freed) {
+	if (xfs_is_shut_down(tp->t_mountp) && freed) {
 		xfs_trans_ail_remove(&bip->bli_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_buf_item_relse(bp);
 	} else if (!(bip->bli_flags & XFS_BLI_DIRTY)) {
-- 
2.17.0

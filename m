Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D079C07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 04:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67D57613B7
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 04:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhGNEWS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 00:22:18 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36443 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237655AbhGNEWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 00:22:10 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B3B3D86498C
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 14:19:16 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3WMe-006JK0-8p
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 14:19:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m3WMe-00B15A-09
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 14:19:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/16] xfs: replace XFS_FORCED_SHUTDOWN with xfs_is_shutdown
Date:   Wed, 14 Jul 2021 14:19:05 +1000
Message-Id: <20210714041912.2625692-10-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714041912.2625692-1-david@fromorbit.com>
References: <20210714041912.2625692-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=O9NoNXZM8T9xC8cM3boA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Remove the shouty macro and instead use the inline function that
matches other state/feature check wrapper naming. This conversion
was done with sed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c  |  2 +-
 fs/xfs/libxfs/xfs_attr.c   |  4 ++--
 fs/xfs/libxfs/xfs_bmap.c   | 16 ++++++++--------
 fs/xfs/libxfs/xfs_btree.c  |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c |  6 +++---
 fs/xfs/scrub/scrub.c       |  2 +-
 fs/xfs/xfs_aops.c          |  8 ++++----
 fs/xfs/xfs_attr_list.c     |  2 +-
 fs/xfs/xfs_bmap_util.c     |  4 ++--
 fs/xfs/xfs_buf.c           |  8 ++++----
 fs/xfs/xfs_buf_item.c      |  2 +-
 fs/xfs/xfs_dir2_readdir.c  |  2 +-
 fs/xfs/xfs_dquot_item.c    |  2 +-
 fs/xfs/xfs_file.c          | 14 +++++++-------
 fs/xfs/xfs_health.c        |  2 +-
 fs/xfs/xfs_icache.c        |  6 +++---
 fs/xfs/xfs_inode.c         | 22 +++++++++++-----------
 fs/xfs/xfs_ioctl.c         | 10 +++++-----
 fs/xfs/xfs_ioctl32.c       |  2 +-
 fs/xfs/xfs_iomap.c         | 12 ++++++------
 fs/xfs/xfs_iops.c          |  4 ++--
 fs/xfs/xfs_mount.c         |  2 +-
 fs/xfs/xfs_mount.h         |  4 ++--
 fs/xfs/xfs_pnfs.c          |  2 +-
 fs/xfs/xfs_qm.c            |  4 ++--
 fs/xfs/xfs_super.c         |  4 ++--
 fs/xfs/xfs_symlink.c       |  8 ++++----
 fs/xfs/xfs_trans.c         |  8 ++++----
 fs/xfs/xfs_trans_ail.c     |  8 ++++----
 fs/xfs/xfs_trans_buf.c     |  6 +++---
 30 files changed, 89 insertions(+), 89 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f408ea68dbd0..e40235bc487d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3079,7 +3079,7 @@ xfs_alloc_read_agf(
 			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
 	}
 #ifdef DEBUG
-	else if (!XFS_FORCED_SHUTDOWN(mp)) {
+	else if (!xfs_is_shutdown(mp)) {
 		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
 		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
 		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 11fb9e3ccf95..7decbab55faa 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -146,7 +146,7 @@ xfs_attr_get(
 
 	XFS_STATS_INC(args->dp->i_mount, xs_attr_get);
 
-	if (XFS_FORCED_SHUTDOWN(args->dp->i_mount))
+	if (xfs_is_shutdown(args->dp->i_mount))
 		return -EIO;
 
 	args->geo = args->dp->i_mount->m_attr_geo;
@@ -691,7 +691,7 @@ xfs_attr_set(
 	int			rmt_blks = 0;
 	unsigned int		total;
 
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
 	error = xfs_qm_dqattach(dp);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 51f091108a20..75354023cea7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3938,7 +3938,7 @@ xfs_bmapi_read(
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT))
 		return -EFSCORRUPTED;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_blk_mapr);
@@ -4420,7 +4420,7 @@ xfs_bmapi_write(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_blk_mapw);
@@ -4703,7 +4703,7 @@ xfs_bmapi_remap(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	error = xfs_iread_extents(tp, ip, whichfork);
@@ -5361,7 +5361,7 @@ __xfs_bunmapi(
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)))
 		return -EFSCORRUPTED;
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -5852,7 +5852,7 @@ xfs_bmap_collapse_extents(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
@@ -5930,7 +5930,7 @@ xfs_bmap_can_insert_extents(
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (xfs_is_shutdown(ip->i_mount))
 		return -EIO;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -5967,7 +5967,7 @@ xfs_bmap_insert_extents(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
@@ -6070,7 +6070,7 @@ xfs_bmap_split_extent(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	/* Read in all the extents */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5ff3c0474c6a..08b58135b424 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -374,7 +374,7 @@ xfs_btree_del_cursor(
 	}
 
 	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
-	       XFS_FORCED_SHUTDOWN(cur->bc_mp));
+	       xfs_is_shutdown(cur->bc_mp));
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
 		kmem_free(cur->bc_ops);
 	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index a9fc71a96666..41bc382a91ec 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -241,7 +241,7 @@ xfs_check_agi_freecount(
 			}
 		} while (i == 1);
 
-		if (!XFS_FORCED_SHUTDOWN(cur->bc_mp))
+		if (!xfs_is_shutdown(cur->bc_mp))
 			ASSERT(freecount == cur->bc_ag.pag->pagi_freecount);
 	}
 	return 0;
@@ -1784,7 +1784,7 @@ xfs_dialloc(
 				break;
 		}
 
-		if (XFS_FORCED_SHUTDOWN(mp)) {
+		if (xfs_is_shutdown(mp)) {
 			error = -EFSCORRUPTED;
 			break;
 		}
@@ -2624,7 +2624,7 @@ xfs_ialloc_read_agi(
 	 * we are in the middle of a forced shutdown.
 	 */
 	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		XFS_FORCED_SHUTDOWN(mp));
+		xfs_is_shutdown(mp));
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 96c623c464f0..a5b1ea9361b3 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -480,7 +480,7 @@ xfs_scrub_metadata(
 
 	/* Forbidden if we are shut down or mounted norecovery. */
 	error = -ESHUTDOWN;
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		goto out;
 	error = -ENOTRECOVERABLE;
 	if (xfs_has_norecovery(mp))
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index cb4e0fcf4c76..42fd83d4a6d5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -97,7 +97,7 @@ xfs_end_ioend(
 	/*
 	 * Just clean up the in-memory structures if the fs has been shut down.
 	 */
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+	if (xfs_is_shutdown(ip->i_mount)) {
 		error = -EIO;
 		goto done;
 	}
@@ -260,7 +260,7 @@ xfs_map_blocks(
 	int			retries = 0;
 	int			error = 0;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	/*
@@ -440,7 +440,7 @@ xfs_discard_page(
 	xfs_fileoff_t		pageoff_fsb = XFS_B_TO_FSBT(mp, pageoff);
 	int			error;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		goto out_invalidate;
 
 	xfs_alert_ratelimited(mp,
@@ -449,7 +449,7 @@ xfs_discard_page(
 
 	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
 			i_blocks_per_page(inode, page) - pageoff_fsb);
-	if (error && !XFS_FORCED_SHUTDOWN(mp))
+	if (error && !xfs_is_shutdown(mp))
 		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
 out_invalidate:
 	iomap_invalidatepage(page, pageoff, PAGE_SIZE - pageoff);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 25dcc98d50e6..2d1e5134cebe 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -529,7 +529,7 @@ xfs_attr_list(
 
 	XFS_STATS_INC(dp->i_mount, xs_attr_list);
 
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
 	lock_mode = xfs_ilock_attr_map_shared(dp);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index a43220dba739..674c078c6e9e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -731,7 +731,7 @@ xfs_free_eofblocks(
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		ASSERT(xfs_is_shutdown(mp));
 		return error;
 	}
 
@@ -789,7 +789,7 @@ xfs_alloc_file_space(
 
 	trace_xfs_alloc_file_space(ip);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	error = xfs_qm_dqattach(ip);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 49ae68086945..090fc13b8254 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -814,7 +814,7 @@ xfs_buf_read_map(
 	 * buffer.
 	 */
 	if (error) {
-		if (!XFS_FORCED_SHUTDOWN(target->bt_mount))
+		if (!xfs_is_shutdown(target->bt_mount))
 			xfs_buf_ioerror_alert(bp, fa);
 
 		bp->b_flags &= ~XBF_DONE;
@@ -1179,7 +1179,7 @@ xfs_buf_ioend_handle_error(
 	 * If we've already decided to shutdown the filesystem because of I/O
 	 * errors, there's no point in giving this a retry.
 	 */
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		goto out_stale;
 
 	xfs_buf_ioerror_alert_ratelimited(bp);
@@ -1592,7 +1592,7 @@ __xfs_buf_submit(
 	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 
 	/* on shutdown we stale and complete the buffer immediately */
-	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
+	if (xfs_is_shutdown(bp->b_mount)) {
 		xfs_buf_ioend_fail(bp);
 		return -EIO;
 	}
@@ -1809,7 +1809,7 @@ xfs_buftarg_drain(
 	 * down the fs.
 	 */
 	if (write_fail) {
-		ASSERT(XFS_FORCED_SHUTDOWN(btp->bt_mount));
+		ASSERT(xfs_is_shutdown(btp->bt_mount));
 		xfs_alert(btp->bt_mount,
 	      "Please run xfs_repair to determine the extent of the problem.");
 	}
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 0136cde9359b..d81b0c5e6e9c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -616,7 +616,7 @@ xfs_buf_item_put(
 	 * that case, the bli is freed on buffer writeback completion.
 	 */
 	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-		  XFS_FORCED_SHUTDOWN(lip->li_mountp);
+		  xfs_is_shutdown(lip->li_mountp);
 	dirty = bip->bli_flags & XFS_BLI_DIRTY;
 	if (dirty && !aborted)
 		return false;
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 8e2408290727..8310005af00f 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -512,7 +512,7 @@ xfs_readdir(
 
 	trace_xfs_readdir(dp);
 
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 8ed47b739b6c..6ee11ca1a1c1 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -326,7 +326,7 @@ xfs_qm_qoff_logitem_relse(
 
 	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
 	       test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-	       XFS_FORCED_SHUTDOWN(lip->li_mountp));
+	       xfs_is_shutdown(lip->li_mountp));
 	xfs_trans_ail_delete(lip, 0);
 	kmem_free(lip->li_lv_shadow);
 	kmem_free(qoff);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0fa02ea21ade..f9a88cc33c7d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -185,7 +185,7 @@ xfs_file_fsync(
 	if (error)
 		return error;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
@@ -318,7 +318,7 @@ xfs_file_read_iter(
 
 	XFS_STATS_INC(mp, xs_read_calls);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	if (IS_DAX(inode))
@@ -462,7 +462,7 @@ xfs_dio_write_end_io(
 
 	trace_xfs_end_io_direct_write(ip, offset, size);
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (xfs_is_shutdown(ip->i_mount))
 		return -EIO;
 
 	if (error)
@@ -814,7 +814,7 @@ xfs_file_write_iter(
 	if (ocount == 0)
 		return 0;
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (xfs_is_shutdown(ip->i_mount))
 		return -EIO;
 
 	if (IS_DAX(inode))
@@ -1156,7 +1156,7 @@ xfs_file_remap_range(
 	if (!xfs_has_reflink(mp))
 		return -EOPNOTSUPP;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	/* Prepare and then clone file data. */
@@ -1205,7 +1205,7 @@ xfs_file_open(
 {
 	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
 		return -EFBIG;
-	if (XFS_FORCED_SHUTDOWN(XFS_M(inode->i_sb)))
+	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
 	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
 	return 0;
@@ -1277,7 +1277,7 @@ xfs_file_llseek(
 {
 	struct inode		*inode = file->f_mapping->host;
 
-	if (XFS_FORCED_SHUTDOWN(XFS_I(inode)->i_mount))
+	if (xfs_is_shutdown(XFS_I(inode)->i_mount))
 		return -EIO;
 
 	switch (whence) {
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index eb10eacabc8f..72a075bb2c10 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -30,7 +30,7 @@ xfs_health_unmount(
 	unsigned int		checked = 0;
 	bool			warn = false;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return;
 
 	/* Measure AG corruption levels. */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8e65cd47a061..6dd7b982a9b6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -976,7 +976,7 @@ xfs_reclaim_inode(
 	if (xfs_iflags_test_and_set(ip, XFS_IFLUSHING))
 		goto out_iunlock;
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+	if (xfs_is_shutdown(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
 		xfs_iflush_abort(ip);
 		goto reclaim;
@@ -1053,7 +1053,7 @@ xfs_want_reclaim_sick(
 	struct xfs_mount	*mp)
 {
 	return xfs_is_unmounting(mp) || xfs_has_norecovery(mp) ||
-	       XFS_FORCED_SHUTDOWN(mp);
+	       xfs_is_shutdown(mp);
 }
 
 void
@@ -1489,7 +1489,7 @@ xfs_blockgc_igrab(
 	spin_unlock(&ip->i_flags_lock);
 
 	/* nothing to sync during shutdown */
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (xfs_is_shutdown(ip->i_mount))
 		return false;
 
 	/* If we can't grab the inode, it must on it's way to reclaim. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 09b4aba8edc5..582e261d1e41 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -663,7 +663,7 @@ xfs_lookup(
 
 	trace_xfs_lookup(dp, name);
 
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
 	error = xfs_dir_lookup(NULL, dp, name, &inum, ci_name);
@@ -975,7 +975,7 @@ xfs_create(
 
 	trace_xfs_create(dp, name);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	prid = xfs_get_initial_prid(dp);
@@ -1129,7 +1129,7 @@ xfs_create_tmpfile(
 	uint			resblks;
 	xfs_ino_t		ino;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	prid = xfs_get_initial_prid(dp);
@@ -1219,7 +1219,7 @@ xfs_link(
 
 	ASSERT(!S_ISDIR(VFS_I(sip)->i_mode));
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	error = xfs_qm_dqattach(sip);
@@ -1437,7 +1437,7 @@ xfs_release(
 	if (xfs_is_readonly(mp))
 		return 0;
 
-	if (!XFS_FORCED_SHUTDOWN(mp)) {
+	if (!xfs_is_shutdown(mp)) {
 		int truncated;
 
 		/*
@@ -1520,7 +1520,7 @@ xfs_inactive_truncate(
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		ASSERT(xfs_is_shutdown(mp));
 		return error;
 	}
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -1591,7 +1591,7 @@ xfs_inactive_ifree(
 			"Failed to remove inode(s) from unlinked list. "
 			"Please free space, unmount and run xfs_repair.");
 		} else {
-			ASSERT(XFS_FORCED_SHUTDOWN(mp));
+			ASSERT(xfs_is_shutdown(mp));
 		}
 		return error;
 	}
@@ -1627,7 +1627,7 @@ xfs_inactive_ifree(
 		 * might do that, we need to make sure.  Otherwise the
 		 * inode might be lost for a long time or forever.
 		 */
-		if (!XFS_FORCED_SHUTDOWN(mp)) {
+		if (!xfs_is_shutdown(mp)) {
 			xfs_notice(mp, "%s: xfs_ifree returned error %d",
 				__func__, error);
 			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
@@ -1957,7 +1957,7 @@ xfs_iunlink_destroy(
 	rhashtable_free_and_destroy(&pag->pagi_unlinked_hash,
 			xfs_iunlink_free_item, &freed_anything);
 
-	ASSERT(freed_anything == false || XFS_FORCED_SHUTDOWN(pag->pag_mount));
+	ASSERT(freed_anything == false || xfs_is_shutdown(pag->pag_mount));
 }
 
 /*
@@ -2702,7 +2702,7 @@ xfs_remove(
 
 	trace_xfs_remove(dp, name);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	error = xfs_qm_dqattach(dp);
@@ -3589,7 +3589,7 @@ xfs_iflush_cluster(
 		 * AIL, leaving a dirty/unpinned inode attached to the buffer
 		 * that otherwise looks like it should be flushed.
 		 */
-		if (XFS_FORCED_SHUTDOWN(mp)) {
+		if (xfs_is_shutdown(mp)) {
 			xfs_iunpin_wait(ip);
 			xfs_iflush_abort(ip);
 			xfs_iunlock(ip, XFS_ILOCK_SHARED);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d9c2aaad2a4f..d54f2e0875d7 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -756,7 +756,7 @@ xfs_ioc_fsbulkstat(
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	if (copy_from_user(&bulkreq, arg, sizeof(struct xfs_fsop_bulkreq)))
@@ -927,7 +927,7 @@ xfs_ioc_bulkstat(
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	if (copy_from_user(&hdr, &arg->hdr, sizeof(hdr)))
@@ -977,7 +977,7 @@ xfs_ioc_inumbers(
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	if (copy_from_user(&hdr, &arg->hdr, sizeof(hdr)))
@@ -1248,7 +1248,7 @@ xfs_ioctl_setattr_get_trans(
 	if (xfs_is_readonly(mp))
 		goto out_error;
 	error = -EIO;
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		goto out_error;
 
 	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
@@ -1774,7 +1774,7 @@ xfs_ioc_swapext(
 		goto out_put_tmp_file;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+	if (xfs_is_shutdown(ip->i_mount)) {
 		error = -EIO;
 		goto out_put_tmp_file;
 	}
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index e6506773ba55..20adf35aa37b 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -254,7 +254,7 @@ xfs_compat_ioc_fsbulkstat(
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	if (get_user(addr, &p32->lastip))
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 3e46ad99dd63..7c69b124a475 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -734,7 +734,7 @@ xfs_direct_write_iomap_begin(
 
 	ASSERT(flags & (IOMAP_WRITE | IOMAP_ZERO));
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	/*
@@ -874,7 +874,7 @@ xfs_buffered_write_iomap_begin(
 	int			allocfork = XFS_DATA_FORK;
 	int			error = 0;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	/* we can't use delayed allocations when using extent size hints */
@@ -1127,7 +1127,7 @@ xfs_buffered_write_iomap_end(
 
 		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
 					       end_fsb - start_fsb);
-		if (error && !XFS_FORCED_SHUTDOWN(mp)) {
+		if (error && !xfs_is_shutdown(mp)) {
 			xfs_alert(mp, "%s: unable to clean up ino %lld",
 				__func__, ip->i_ino);
 			return error;
@@ -1162,7 +1162,7 @@ xfs_read_iomap_begin(
 
 	ASSERT(!(flags & (IOMAP_WRITE | IOMAP_ZERO)));
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
@@ -1203,7 +1203,7 @@ xfs_seek_iomap_begin(
 	int			error = 0;
 	unsigned		lockmode;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	lockmode = xfs_ilock_data_map_shared(ip);
@@ -1285,7 +1285,7 @@ xfs_xattr_iomap_begin(
 	int			nimaps = 1, error = 0;
 	unsigned		lockmode;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	lockmode = xfs_ilock_attr_map_shared(ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 6e37d89cdf02..7e08229aac61 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -582,7 +582,7 @@ xfs_vn_getattr(
 
 	trace_xfs_getattr(ip);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	stat->size = XFS_ISIZE(ip);
@@ -676,7 +676,7 @@ xfs_vn_change_ok(
 	if (xfs_is_readonly(mp))
 		return -EROFS;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	return setattr_prepare(mnt_userns, dentry, iattr);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index feb10fa7029a..2ac5c149664c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1043,7 +1043,7 @@ xfs_fs_writable(
 {
 	ASSERT(level > SB_UNFROZEN);
 	if ((mp->m_super->s_writers.frozen >= level) ||
-	    XFS_FORCED_SHUTDOWN(mp) || xfs_is_readonly(mp))
+	    xfs_is_shutdown(mp) || xfs_is_readonly(mp))
 		return false;
 
 	return true;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 0b9b84b31179..d4da6f54e7ae 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -324,7 +324,7 @@ __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
  * Mount features
  *
  * These do not change dynamically - features that can come and go,
- * such as 32 bit inodes and read-only state, are kept as flags rather than
+ * such as 32 bit inodes and read-only state, are kept as state rather than
  * features.
  */
 __XFS_HAS_FEAT(noattr2, NOATTR2)
@@ -373,7 +373,7 @@ __XFS_IS_STATE(readonly, READONLY)
 #define XFS_MAX_IO_LOG		30	/* 1G */
 #define XFS_MIN_IO_LOG		PAGE_SHIFT
 
-#define XFS_FORCED_SHUTDOWN(mp)		xfs_is_shutdown(mp)
+#define xfs_is_shutdown(mp)		xfs_is_shutdown(mp)
 void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 		int lnnum);
 #define xfs_force_shutdown(m,f)	\
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 956cca24e67f..5e1d29d8b2e7 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -92,7 +92,7 @@ xfs_fs_map_blocks(
 	uint			lock_flags;
 	int			error = 0;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	/*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b327b9dcca04..5f24720e0ba2 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -157,7 +157,7 @@ xfs_qm_dqpurge(
 	}
 
 	ASSERT(atomic_read(&dqp->q_pincount) == 0);
-	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
+	ASSERT(xfs_is_shutdown(mp) ||
 		!test_bit(XFS_LI_IN_AIL, &dqp->q_logitem.qli_item.li_flags));
 
 	xfs_dqfunlock(dqp);
@@ -829,7 +829,7 @@ xfs_qm_qino_alloc(
 
 	error = xfs_trans_commit(tp);
 	if (error) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		ASSERT(xfs_is_shutdown(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
 	}
 	if (need_alloc)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index cc7eb9a73e85..2463848f92ff 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -639,7 +639,7 @@ xfs_fs_destroy_inode(
 
 	xfs_inactive(ip);
 
-	if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
+	if (!xfs_is_shutdown(ip->i_mount) && ip->i_delayed_blks) {
 		xfs_check_delalloc(ip, XFS_DATA_FORK);
 		xfs_check_delalloc(ip, XFS_COW_FORK);
 		ASSERT(0);
@@ -1010,7 +1010,7 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_icount);
 	percpu_counter_destroy(&mp->m_ifree);
 	percpu_counter_destroy(&mp->m_fdblocks);
-	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
+	ASSERT(xfs_is_shutdown(mp) ||
 	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
 	percpu_counter_destroy(&mp->m_delalloc_blks);
 }
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 701a78fbf7a9..fc2c6a404647 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -107,7 +107,7 @@ xfs_readlink(
 
 	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_LOCAL);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
@@ -168,7 +168,7 @@ xfs_symlink(
 
 	trace_xfs_symlink(dp, link_name);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	/*
@@ -444,7 +444,7 @@ xfs_inactive_symlink_rmt(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = xfs_trans_commit(tp);
 	if (error) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		ASSERT(xfs_is_shutdown(mp));
 		goto error_unlock;
 	}
 
@@ -477,7 +477,7 @@ xfs_inactive_symlink(
 
 	trace_xfs_inactive_symlink(ip);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bc1cad33daf8..c5f111235e44 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -778,7 +778,7 @@ xfs_trans_committed_bulk(
 		 * object into the AIL as we are in a shutdown situation.
 		 */
 		if (aborted) {
-			ASSERT(XFS_FORCED_SHUTDOWN(ailp->ail_mount));
+			ASSERT(xfs_is_shutdown(ailp->ail_mount));
 			if (lip->li_ops->iop_unpin)
 				lip->li_ops->iop_unpin(lip, 1);
 			continue;
@@ -867,7 +867,7 @@ __xfs_trans_commit(
 	if (!(tp->t_flags & XFS_TRANS_DIRTY))
 		goto out_unreserve;
 
-	if (XFS_FORCED_SHUTDOWN(mp)) {
+	if (xfs_is_shutdown(mp)) {
 		error = -EIO;
 		goto out_unreserve;
 	}
@@ -953,12 +953,12 @@ xfs_trans_cancel(
 	 * filesystem.  This happens in paths where we detect
 	 * corruption and decide to give up.
 	 */
-	if (dirty && !XFS_FORCED_SHUTDOWN(mp)) {
+	if (dirty && !xfs_is_shutdown(mp)) {
 		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	}
 #ifdef DEBUG
-	if (!dirty && !XFS_FORCED_SHUTDOWN(mp)) {
+	if (!dirty && !xfs_is_shutdown(mp)) {
 		struct xfs_log_item *lip;
 
 		list_for_each_entry(lip, &tp->t_items, li_trans)
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index dbb69b4bf3ed..fd9b04b6bbb4 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -615,7 +615,7 @@ xfsaild(
 			 * opportunity to release such buffers from the queue.
 			 */
 			ASSERT(list_empty(&ailp->ail_buf_list) ||
-			       XFS_FORCED_SHUTDOWN(ailp->ail_mount));
+			       xfs_is_shutdown(ailp->ail_mount));
 			xfs_buf_delwri_cancel(&ailp->ail_buf_list);
 			break;
 		}
@@ -678,7 +678,7 @@ xfs_ail_push(
 	struct xfs_log_item	*lip;
 
 	lip = xfs_ail_min(ailp);
-	if (!lip || XFS_FORCED_SHUTDOWN(ailp->ail_mount) ||
+	if (!lip || xfs_is_shutdown(ailp->ail_mount) ||
 	    XFS_LSN_CMP(threshold_lsn, ailp->ail_target) <= 0)
 		return;
 
@@ -743,7 +743,7 @@ xfs_ail_update_finish(
 		return;
 	}
 
-	if (!XFS_FORCED_SHUTDOWN(mp))
+	if (!xfs_is_shutdown(mp))
 		xlog_assign_tail_lsn_locked(mp);
 
 	if (list_empty(&ailp->ail_head))
@@ -863,7 +863,7 @@ xfs_trans_ail_delete(
 	spin_lock(&ailp->ail_lock);
 	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 		spin_unlock(&ailp->ail_lock);
-		if (shutdown_type && !XFS_FORCED_SHUTDOWN(mp)) {
+		if (shutdown_type && !xfs_is_shutdown(mp)) {
 			xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
 	"%s: attempting to delete a log item that is not in the AIL",
 					__func__);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index d11d032da0b4..4ff274ce31c4 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -138,7 +138,7 @@ xfs_trans_get_buf_map(
 	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
 	if (bp != NULL) {
 		ASSERT(xfs_buf_islocked(bp));
-		if (XFS_FORCED_SHUTDOWN(tp->t_mountp)) {
+		if (xfs_is_shutdown(tp->t_mountp)) {
 			xfs_buf_stale(bp);
 			bp->b_flags |= XBF_DONE;
 		}
@@ -244,7 +244,7 @@ xfs_trans_read_buf_map(
 		 * We never locked this buf ourselves, so we shouldn't
 		 * brelse it either. Just get out.
 		 */
-		if (XFS_FORCED_SHUTDOWN(mp)) {
+		if (xfs_is_shutdown(mp)) {
 			trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
 			return -EIO;
 		}
@@ -300,7 +300,7 @@ xfs_trans_read_buf_map(
 		return error;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp)) {
+	if (xfs_is_shutdown(mp)) {
 		xfs_buf_relse(bp);
 		trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
 		return -EIO;
-- 
2.31.1


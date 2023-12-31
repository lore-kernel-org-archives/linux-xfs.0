Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A43ABA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IxnXJe3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F345C433C7;
	Sun, 31 Dec 2023 20:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053661;
	bh=/UgwqNed3gyo9QqpmjrJN5exWf/E7cQ9wx3w2p2npIA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IxnXJe3NHAgpcp1uAwzQh25pbWwY6PPT9p82zYr/ciGyhU0uhYvo1XptyPwag/6/g
	 4v2Ptvdpg3eRiGlz6mjTsIjutr3EVWsiG57BakNQiwzH5f6mkVwY1huhxVxYfX8D/i
	 a0PBjBK/Gdc8FQfm9SKqPhu94mKTi6IDtbd6LaCXbeQp0AkP0l8n/F8zU94KkHNvqb
	 Wq1a16NuVE4IDgvLPIj1R6rulGEG9JEBWL1nKPNLEUJSzh69tkv8wi61yuQ35i+ghm
	 NkYS1Ukswaie+kUvZRHw+qHkheWBQzXvSKeT39Znlw45nZU+Xja4XGGfhJ6gUJYYQH
	 LWqdUiG3KxIOw==
Date: Sun, 31 Dec 2023 12:14:20 -0800
Subject: [PATCH 3/9] xfs: create buftarg helpers to abstract block_device
 operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170404829626.1748854.5183924360781583435.stgit@frogsfrogsfrogs>
In-Reply-To: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In the next few patches, we're going into introduce buffer targets that
are not block devices.  Introduce block_device helpers so that the
compiler can check that we're not feeding an xfile object to something
expecting a block device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c        |    5 ++++-
 fs/xfs/xfs_bmap_util.c   |    8 ++++----
 fs/xfs/xfs_buf.h         |   37 +++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_discard.c     |    9 +++++----
 fs/xfs/xfs_file.c        |    6 +++---
 fs/xfs/xfs_ioctl.c       |    3 ++-
 fs/xfs/xfs_iomap.c       |    4 ++--
 fs/xfs/xfs_log.c         |    4 ++--
 fs/xfs/xfs_log_recover.c |    3 ++-
 9 files changed, 59 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 465d7630bb218..3001ddf48d6c6 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -569,7 +569,10 @@ xfs_iomap_swapfile_activate(
 	struct file			*swap_file,
 	sector_t			*span)
 {
-	sis->bdev = xfs_inode_buftarg(XFS_I(file_inode(swap_file)))->bt_bdev;
+	struct xfs_inode		*ip = XFS_I(file_inode(swap_file));
+	struct xfs_buftarg		*btp = xfs_inode_buftarg(ip);
+
+	sis->bdev = xfs_buftarg_bdev(btp);
 	return iomap_swapfile_activate(sis, swap_file, span,
 			&xfs_read_iomap_ops);
 }
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 731260a5af6db..6b5a9ad18fcb3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -63,10 +63,10 @@ xfs_zero_extent(
 	xfs_daddr_t		sector = xfs_fsb_to_db(ip, start_fsb);
 	sector_t		block = XFS_BB_TO_FSBT(mp, sector);
 
-	return blkdev_issue_zeroout(target->bt_bdev,
-		block << (mp->m_super->s_blocksize_bits - 9),
-		count_fsb << (mp->m_super->s_blocksize_bits - 9),
-		GFP_NOFS, 0);
+	return xfs_buftarg_zeroout(target,
+			block << (mp->m_super->s_blocksize_bits - 9),
+			count_fsb << (mp->m_super->s_blocksize_bits - 9),
+			GFP_NOFS, 0);
 }
 
 #ifdef CONFIG_XFS_RT
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index d4b6b58b16009..4e964470587ce 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -382,8 +382,41 @@ extern void xfs_buftarg_wait(struct xfs_buftarg *);
 extern void xfs_buftarg_drain(struct xfs_buftarg *);
 extern int xfs_setsize_buftarg(struct xfs_buftarg *, unsigned int);
 
-#define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
-#define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
+static inline struct block_device *
+xfs_buftarg_bdev(struct xfs_buftarg *btp)
+{
+	return btp->bt_bdev;
+}
+
+static inline unsigned int
+xfs_getsize_buftarg(struct xfs_buftarg *btp)
+{
+	return block_size(btp->bt_bdev);
+}
+
+static inline bool
+xfs_readonly_buftarg(struct xfs_buftarg *btp)
+{
+	return bdev_read_only(btp->bt_bdev);
+}
+
+static inline int
+xfs_buftarg_flush(struct xfs_buftarg *btp)
+{
+	return blkdev_issue_flush(btp->bt_bdev);
+}
+
+static inline int
+xfs_buftarg_zeroout(
+	struct xfs_buftarg	*btp,
+	sector_t		sector,
+	sector_t		nr_sects,
+	gfp_t			gfp_mask,
+	unsigned int		flags)
+{
+	return blkdev_issue_zeroout(btp->bt_bdev, sector, nr_sects, gfp_mask,
+			flags);
+}
 
 int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index e38c4c46d1275..2ec6b99188a28 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -108,6 +108,7 @@ xfs_discard_extents(
 	struct xfs_mount	*mp,
 	struct xfs_busy_extents	*extents)
 {
+	struct block_device	*bdev = xfs_buftarg_bdev(mp->m_ddev_targp);
 	struct xfs_extent_busy	*busyp;
 	struct bio		*bio = NULL;
 	struct blk_plug		plug;
@@ -118,7 +119,7 @@ xfs_discard_extents(
 		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
 					 busyp->length);
 
-		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
+		error = __blkdev_issue_discard(bdev,
 				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
 				XFS_FSB_TO_BB(mp, busyp->length),
 				GFP_NOFS, &bio);
@@ -368,8 +369,8 @@ xfs_ioc_trim(
 	struct fstrim_range __user	*urange)
 {
 	struct xfs_perag	*pag;
-	unsigned int		granularity =
-		bdev_discard_granularity(mp->m_ddev_targp->bt_bdev);
+	struct block_device	*bdev = xfs_buftarg_bdev(mp->m_ddev_targp);
+	unsigned int		granularity = bdev_discard_granularity(bdev);
 	struct fstrim_range	range;
 	xfs_daddr_t		start, end, minlen;
 	xfs_agnumber_t		agno;
@@ -378,7 +379,7 @@ xfs_ioc_trim(
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (!bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev))
+	if (!bdev_max_discard_sectors(bdev))
 		return -EOPNOTSUPP;
 
 	/*
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e33e5e13b95f4..0a38dde178738 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -164,9 +164,9 @@ xfs_file_fsync(
 	 * inode size in case of an extending write.
 	 */
 	if (XFS_IS_REALTIME_INODE(ip))
-		error = blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
+		error = xfs_buftarg_flush(mp->m_rtdev_targp);
 	else if (mp->m_logdev_targp != mp->m_ddev_targp)
-		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
+		error = xfs_buftarg_flush(mp->m_ddev_targp);
 
 	/*
 	 * Any inode that has dirty modifications in the log is pinned.  The
@@ -189,7 +189,7 @@ xfs_file_fsync(
 	 */
 	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
 	    mp->m_logdev_targp == mp->m_ddev_targp) {
-		err2 = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
+		err2 = xfs_buftarg_flush(mp->m_ddev_targp);
 		if (err2 && !error)
 			error = err2;
 	}
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6c3919687ea6b..8dcd6ca2a903b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1773,6 +1773,7 @@ xfs_ioc_setlabel(
 	char			__user *newlabel)
 {
 	struct xfs_sb		*sbp = &mp->m_sb;
+	struct block_device	*bdev = xfs_buftarg_bdev(mp->m_ddev_targp);
 	char			label[XFSLABEL_MAX + 1];
 	size_t			len;
 	int			error;
@@ -1819,7 +1820,7 @@ xfs_ioc_setlabel(
 	error = xfs_update_secondary_sbs(mp);
 	mutex_unlock(&mp->m_growlock);
 
-	invalidate_bdev(mp->m_ddev_targp->bt_bdev);
+	invalidate_bdev(bdev);
 
 out:
 	mnt_drop_write_file(filp);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0ff46e3997e0e..559e8e7855952 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -129,7 +129,7 @@ xfs_bmbt_to_iomap(
 	if (mapping_flags & IOMAP_DAX)
 		iomap->dax_dev = target->bt_daxdev;
 	else
-		iomap->bdev = target->bt_bdev;
+		iomap->bdev = xfs_buftarg_bdev(target);
 	iomap->flags = iomap_flags;
 
 	if (xfs_ipincount(ip) &&
@@ -154,7 +154,7 @@ xfs_hole_to_iomap(
 	iomap->type = IOMAP_HOLE;
 	iomap->offset = XFS_FSB_TO_B(ip->i_mount, offset_fsb);
 	iomap->length = XFS_FSB_TO_B(ip->i_mount, end_fsb - offset_fsb);
-	iomap->bdev = target->bt_bdev;
+	iomap->bdev = xfs_buftarg_bdev(target);
 	iomap->dax_dev = target->bt_daxdev;
 }
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a1650fc81382f..a9a8311e112c2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1903,7 +1903,7 @@ xlog_write_iclog(
 	 * writeback throttle from throttling log writes behind background
 	 * metadata writeback and causing priority inversions.
 	 */
-	bio_init(&iclog->ic_bio, log->l_targ->bt_bdev, iclog->ic_bvec,
+	bio_init(&iclog->ic_bio, xfs_buftarg_bdev(log->l_targ), iclog->ic_bvec,
 		 howmany(count, PAGE_SIZE),
 		 REQ_OP_WRITE | REQ_META | REQ_SYNC | REQ_IDLE);
 	iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart + bno;
@@ -1924,7 +1924,7 @@ xlog_write_iclog(
 		 * avoid shutdown re-entering this path and erroring out again.
 		 */
 		if (log->l_targ != log->l_mp->m_ddev_targp &&
-		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev))
+		    xfs_buftarg_flush(log->l_mp->m_ddev_targp))
 			goto shutdown;
 	}
 	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1251c81e55f98..53ffbb9dfd974 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -137,7 +137,8 @@ xlog_do_io(
 	nbblks = round_up(nbblks, log->l_sectBBsize);
 	ASSERT(nbblks > 0);
 
-	error = xfs_rw_bdev(log->l_targ->bt_bdev, log->l_logBBstart + blk_no,
+	error = xfs_rw_bdev(xfs_buftarg_bdev(log->l_targ),
+			log->l_logBBstart + blk_no,
 			BBTOB(nbblks), data, op);
 	if (error && !xlog_is_shutdown(log)) {
 		xfs_alert(log->l_mp,


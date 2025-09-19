Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40881226D02
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 13:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758287547; cv=none; b=sp6+BHD6agtc46Oo/zbfAjmd1nRZgoN5NPJeJGPPK2TUMY/7f4pvK2d9sTTXT4pFZtwEyOvMW1k3qtIDn4h2S4E1OGiMiftwC61cqbw0T4Ui/hlpLS6fQ9//HXbpOwgXYIJ4GBDFwnj3lrvZubhbuMA4drDSFUyi31UZJQ0mdeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758287547; c=relaxed/simple;
	bh=i3TZ69YuuOENEVN1iVXVLLeR2DJEF+KLKEscDigN6eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfzs99hgvv4OVuZOfDqnU1WGe4Zw5E0NAOgdXPVBSrw3oXJ7KpM5oHNT4IvuQPFDqLu149vQpwCEY8fEhDbDXljrCdQPAQQVRWzuZ9cNLx4R3yGWdE0nZDooc2cIy/wWbThy2j/uLfzGAqKcyj+j3RdCcyCOknbCf2I+Iytcx4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mB5Zxqkh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mB5Zxqkh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cFkdlxyOBqdACjr+rG81Yig6ATfCrkSQ4gzDUD9WqYw=; b=mB5ZxqkhMkC4xxhAoCZnyZGQZ7
	QGWrAqjxvpDvDu5MJVVOhQdRUfxR+VGwZA7FvbYNx5fEOQnoXlzQKn6IT1Mw7CZaRiii0LZceE4Xx
	Ak9DzNH3mM6p7bOVfJwOBwdAFgjiKOLOI9y2peFl+d1R7nE8cUolihVPzdpkP7r8qXBsbyfoNtDeE
	pgNC7vwZmvC3WWjrKr7U4S7Al2qJt5UQhqN7H7BKJVOgtQKxBzu7cCvTZhiDxPIu9s7WGbWIXQaRy
	M49zmpNQ1bWLlCYdq+rzOjRbXO5K750AhqCMMF+eY1FmgnoxgM61QEI3qvgDpfvDXfCUqj6SKNvF4
	/xB7o2zQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzauV-00000002x17-39cw;
	Fri, 19 Sep 2025 13:12:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: track the number of blocks in each buftarg
Date: Fri, 19 Sep 2025 06:12:08 -0700
Message-ID: <20250919131222.802840-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250919131222.802840-1-hch@lst.de>
References: <20250919131222.802840-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a bt_nr_sectors to track the number of sector in each buftarg, and
replace the check that hard codes sb_dblock in xfs_buf_map_verify with
this new value so that it is correct for non-ddev buftargs.  The
RT buftarg only has a superblock in the first block, so it is unlikely
to trigger this, or are we likely to ever have enough blocks in the
in-memory buftargs, but we might as well get the check right.

Fixes: 10616b806d1d ("xfs: fix _xfs_buf_find oops on blocks beyond the filesystem end")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c              | 42 +++++++++++++++++++----------------
 fs/xfs/xfs_buf.h              |  4 +++-
 fs/xfs/xfs_buf_item_recover.c | 10 +++++++++
 fs/xfs/xfs_super.c            |  7 +++---
 fs/xfs/xfs_trans.c            | 23 ++++++++++---------
 5 files changed, 52 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f9ef3b2a332a..2037c88e604a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -387,8 +387,6 @@ xfs_buf_map_verify(
 	struct xfs_buftarg	*btp,
 	struct xfs_buf_map	*map)
 {
-	xfs_daddr_t		eofs;
-
 	/* Check for IOs smaller than the sector size / not sector aligned */
 	ASSERT(!(BBTOB(map->bm_len) < btp->bt_meta_sectorsize));
 	ASSERT(!(BBTOB(map->bm_bn) & (xfs_off_t)btp->bt_meta_sectormask));
@@ -397,11 +395,10 @@ xfs_buf_map_verify(
 	 * Corrupted block numbers can get through to here, unfortunately, so we
 	 * have to check that the buffer falls within the filesystem bounds.
 	 */
-	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
-	if (map->bm_bn < 0 || map->bm_bn >= eofs) {
+	if (map->bm_bn < 0 || map->bm_bn >= btp->bt_nr_sectors) {
 		xfs_alert(btp->bt_mount,
 			  "%s: daddr 0x%llx out of range, EOFS 0x%llx",
-			  __func__, map->bm_bn, eofs);
+			  __func__, map->bm_bn, btp->bt_nr_sectors);
 		WARN_ON(1);
 		return -EFSCORRUPTED;
 	}
@@ -1720,26 +1717,30 @@ xfs_configure_buftarg_atomic_writes(
 int
 xfs_configure_buftarg(
 	struct xfs_buftarg	*btp,
-	unsigned int		sectorsize)
+	unsigned int		sectorsize,
+	xfs_rfsblock_t		nr_blocks)
 {
-	int			error;
+	struct xfs_mount	*mp = btp->bt_mount;
 
-	ASSERT(btp->bt_bdev != NULL);
+	if (btp->bt_bdev) {
+		int		error;
 
-	/* Set up metadata sector size info */
-	btp->bt_meta_sectorsize = sectorsize;
-	btp->bt_meta_sectormask = sectorsize - 1;
+		error = bdev_validate_blocksize(btp->bt_bdev, sectorsize);
+		if (error) {
+			xfs_warn(mp,
+				"Cannot use blocksize %u on device %pg, err %d",
+				sectorsize, btp->bt_bdev, error);
+			return -EINVAL;
+		}
 
-	error = bdev_validate_blocksize(btp->bt_bdev, sectorsize);
-	if (error) {
-		xfs_warn(btp->bt_mount,
-			"Cannot use blocksize %u on device %pg, err %d",
-			sectorsize, btp->bt_bdev, error);
-		return -EINVAL;
+		if (bdev_can_atomic_write(btp->bt_bdev))
+			xfs_configure_buftarg_atomic_writes(btp);
 	}
 
-	if (bdev_can_atomic_write(btp->bt_bdev))
-		xfs_configure_buftarg_atomic_writes(btp);
+	btp->bt_meta_sectorsize = sectorsize;
+	btp->bt_meta_sectormask = sectorsize - 1;
+	/* m_blkbb_log is not set up yet */
+	btp->bt_nr_sectors = nr_blocks << (mp->m_sb.sb_blocklog - BBSHIFT);
 	return 0;
 }
 
@@ -1749,6 +1750,9 @@ xfs_init_buftarg(
 	size_t				logical_sectorsize,
 	const char			*descr)
 {
+	/* The maximum size of the buftarg is only known once the sb is read. */
+	btp->bt_nr_sectors = (xfs_daddr_t)-1;
+
 	/* Set up device logical sector size mask */
 	btp->bt_logical_sectorsize = logical_sectorsize;
 	btp->bt_logical_sectormask = logical_sectorsize - 1;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index b269e115d9ac..8fa7bdf59c91 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -103,6 +103,7 @@ struct xfs_buftarg {
 	size_t			bt_meta_sectormask;
 	size_t			bt_logical_sectorsize;
 	size_t			bt_logical_sectormask;
+	xfs_daddr_t		bt_nr_sectors;
 
 	/* LRU control structures */
 	struct shrinker		*bt_shrinker;
@@ -372,7 +373,8 @@ struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *mp,
 extern void xfs_free_buftarg(struct xfs_buftarg *);
 extern void xfs_buftarg_wait(struct xfs_buftarg *);
 extern void xfs_buftarg_drain(struct xfs_buftarg *);
-int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize);
+int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize,
+		xfs_fsblock_t nr_blocks);
 
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 5d58e2ae4972..e4c8af873632 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -736,6 +736,16 @@ xlog_recover_do_primary_sb_buffer(
 	 */
 	xfs_sb_from_disk(&mp->m_sb, dsb);
 
+	/*
+	 * Grow can change the device size.  Mirror that into the buftarg.
+	 */
+	mp->m_ddev_targp->bt_nr_sectors =
+		XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
+		mp->m_rtdev_targp->bt_nr_sectors =
+			XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	}
+
 	if (mp->m_sb.sb_agcount < orig_agcount) {
 		xfs_alert(mp, "Shrinking AG count in log recovery not supported");
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 77acb3e5a4ec..9e759c5b1096 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -535,7 +535,8 @@ xfs_setup_devices(
 {
 	int			error;
 
-	error = xfs_configure_buftarg(mp->m_ddev_targp, mp->m_sb.sb_sectsize);
+	error = xfs_configure_buftarg(mp->m_ddev_targp, mp->m_sb.sb_sectsize,
+			mp->m_sb.sb_dblocks);
 	if (error)
 		return error;
 
@@ -545,7 +546,7 @@ xfs_setup_devices(
 		if (xfs_has_sector(mp))
 			log_sector_size = mp->m_sb.sb_logsectsize;
 		error = xfs_configure_buftarg(mp->m_logdev_targp,
-					    log_sector_size);
+				log_sector_size, mp->m_sb.sb_logblocks);
 		if (error)
 			return error;
 	}
@@ -559,7 +560,7 @@ xfs_setup_devices(
 		mp->m_rtdev_targp = mp->m_ddev_targp;
 	} else if (mp->m_rtname) {
 		error = xfs_configure_buftarg(mp->m_rtdev_targp,
-					    mp->m_sb.sb_sectsize);
+				mp->m_sb.sb_sectsize, mp->m_sb.sb_rblocks);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 575e7028f423..474f5a04ec63 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -452,19 +452,17 @@ xfs_trans_mod_sb(
  */
 STATIC void
 xfs_trans_apply_sb_deltas(
-	xfs_trans_t	*tp)
+	struct xfs_trans	*tp)
 {
-	struct xfs_dsb	*sbp;
-	struct xfs_buf	*bp;
-	int		whole = 0;
-
-	bp = xfs_trans_getsb(tp);
-	sbp = bp->b_addr;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*bp = xfs_trans_getsb(tp);
+	struct xfs_dsb		*sbp = bp->b_addr;
+	int			whole = 0;
 
 	/*
 	 * Only update the superblock counters if we are logging them
 	 */
-	if (!xfs_has_lazysbcount((tp->t_mountp))) {
+	if (!xfs_has_lazysbcount(mp)) {
 		if (tp->t_icount_delta)
 			be64_add_cpu(&sbp->sb_icount, tp->t_icount_delta);
 		if (tp->t_ifree_delta)
@@ -491,8 +489,7 @@ xfs_trans_apply_sb_deltas(
 	 * write the correct value ondisk.
 	 */
 	if ((tp->t_frextents_delta || tp->t_res_frextents_delta) &&
-	    !xfs_has_rtgroups(tp->t_mountp)) {
-		struct xfs_mount	*mp = tp->t_mountp;
+	    !xfs_has_rtgroups(mp)) {
 		int64_t			rtxdelta;
 
 		rtxdelta = tp->t_frextents_delta + tp->t_res_frextents_delta;
@@ -505,6 +502,8 @@ xfs_trans_apply_sb_deltas(
 
 	if (tp->t_dblocks_delta) {
 		be64_add_cpu(&sbp->sb_dblocks, tp->t_dblocks_delta);
+		mp->m_ddev_targp->bt_nr_sectors +=
+			XFS_FSB_TO_BB(mp, tp->t_dblocks_delta);
 		whole = 1;
 	}
 	if (tp->t_agcount_delta) {
@@ -524,7 +523,7 @@ xfs_trans_apply_sb_deltas(
 		 * recompute the ondisk rtgroup block log.  The incore values
 		 * will be recomputed in xfs_trans_unreserve_and_mod_sb.
 		 */
-		if (xfs_has_rtgroups(tp->t_mountp)) {
+		if (xfs_has_rtgroups(mp)) {
 			sbp->sb_rgblklog = xfs_compute_rgblklog(
 						be32_to_cpu(sbp->sb_rgextents),
 						be32_to_cpu(sbp->sb_rextsize));
@@ -537,6 +536,8 @@ xfs_trans_apply_sb_deltas(
 	}
 	if (tp->t_rblocks_delta) {
 		be64_add_cpu(&sbp->sb_rblocks, tp->t_rblocks_delta);
+		mp->m_rtdev_targp->bt_nr_sectors +=
+			XFS_FSB_TO_BB(mp, tp->t_rblocks_delta);
 		whole = 1;
 	}
 	if (tp->t_rextents_delta) {
-- 
2.47.2


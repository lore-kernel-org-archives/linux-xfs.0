Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FAB2C35266
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50A9822260
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgJOHWO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:14 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34908 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729208AbgJOHWL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:11 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1941758C50A
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hvD-F9
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qLX-7a
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/27] libxfs: rename buftarg->dev to btdev
Date:   Thu, 15 Oct 2020 18:21:32 +1100
Message-Id: <20201015072155.1631135-5-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=jLA7tAb40fkNERpc_z0A:9
        a=Rftds6ucSMzUh7mU:21 a=twI9za5h2MWdf_kv:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To prepare for alignment with kernel buftarg code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/init.c      | 14 +++++++-------
 libxfs/libxfs_io.h |  3 +--
 libxfs/logitem.c   |  2 +-
 libxfs/rdwr.c      | 20 ++++++++++----------
 mkfs/xfs_mkfs.c    |  2 +-
 repair/prefetch.c  |  2 +-
 6 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 330c645190d9..bd176b50bf63 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -443,7 +443,7 @@ rtmount_init(
 		return -1;
 	}
 
-	if (mp->m_rtdev_targp->dev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
+	if (mp->m_rtdev_targp->bt_bdev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
 		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
 			progname);
 		return -1;
@@ -601,7 +601,7 @@ libxfs_buftarg_alloc(
 		exit(1);
 	}
 	btp->bt_mount = mp;
-	btp->dev = dev;
+	btp->bt_bdev = dev;
 	btp->flags = 0;
 
 	return btp;
@@ -616,7 +616,7 @@ libxfs_buftarg_init(
 {
 	if (mp->m_ddev_targp) {
 		/* should already have all buftargs initialised */
-		if (mp->m_ddev_targp->dev != dev ||
+		if (mp->m_ddev_targp->bt_bdev != dev ||
 		    mp->m_ddev_targp->bt_mount != mp) {
 			fprintf(stderr,
 				_("%s: bad buftarg reinit, ddev\n"),
@@ -630,14 +630,14 @@ libxfs_buftarg_init(
 					progname);
 				exit(1);
 			}
-		} else if (mp->m_logdev_targp->dev != logdev ||
+		} else if (mp->m_logdev_targp->bt_bdev != logdev ||
 			   mp->m_logdev_targp->bt_mount != mp) {
 			fprintf(stderr,
 				_("%s: bad buftarg reinit, logdev\n"),
 				progname);
 			exit(1);
 		}
-		if (rtdev && (mp->m_rtdev_targp->dev != rtdev ||
+		if (rtdev && (mp->m_rtdev_targp->bt_bdev != rtdev ||
 			      mp->m_rtdev_targp->bt_mount != mp)) {
 			fprintf(stderr,
 				_("%s: bad buftarg reinit, rtdev\n"),
@@ -760,8 +760,8 @@ libxfs_mount(
 	} else
 		libxfs_buf_relse(bp);
 
-	if (mp->m_logdev_targp->dev &&
-	    mp->m_logdev_targp->dev != mp->m_ddev_targp->dev) {
+	if (mp->m_logdev_targp->bt_bdev &&
+	    mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev) {
 		d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks ||
 		    libxfs_buf_read(mp->m_logdev_targp,
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 9d65cf808c6a..1eccedfc5fe1 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -22,7 +22,7 @@ struct xfs_perag;
  */
 struct xfs_buftarg {
 	struct xfs_mount	*bt_mount;
-	dev_t			dev;
+	dev_t			bt_bdev;
 	unsigned int		flags;
 };
 
@@ -63,7 +63,6 @@ typedef struct xfs_buf {
 	xfs_daddr_t		b_bn;
 	unsigned int		b_length;
 	struct xfs_buftarg	*b_target;
-#define b_dev		b_target->dev
 	pthread_mutex_t		b_lock;
 	pthread_t		b_holder;
 	unsigned int		b_recur;
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index e4ad748ed6e1..43a98f284129 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -45,7 +45,7 @@ xfs_trans_buf_item_match(
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		blip = (struct xfs_buf_log_item *)lip;
 		if (blip->bli_item.li_type == XFS_LI_BUF &&
-		    blip->bli_buf->b_target->dev == btp->dev &&
+		    blip->bli_buf->b_target->bt_bdev == btp->bt_bdev &&
 		    XFS_BUF_ADDR(blip->bli_buf) == map[0].bm_bn &&
 		    blip->bli_buf->b_length == len) {
 			ASSERT(blip->bli_buf->b_map_count == nmaps);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 81ab4dd76f19..345fddc63d14 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -68,7 +68,7 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 	char		*z;
 	int		error, fd;
 
-	fd = libxfs_device_to_fd(btp->dev);
+	fd = libxfs_device_to_fd(btp->bt_bdev);
 	start_offset = LIBXFS_BBTOOFF64(start);
 
 	/* try to use special zeroing methods, fall back to writes if needed */
@@ -201,7 +201,7 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
 						   b_node);
 	struct xfs_bufkey	*bkey = (struct xfs_bufkey *)key;
 
-	if (bp->b_target->dev == bkey->buftarg->dev &&
+	if (bp->b_target->bt_bdev == bkey->buftarg->bt_bdev &&
 	    bp->b_bn == bkey->blkno) {
 		if (bp->b_length == bkey->bblen)
 			return CACHE_HIT;
@@ -577,7 +577,7 @@ int
 libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, xfs_buf_t *bp,
 		int len, int flags)
 {
-	int	fd = libxfs_device_to_fd(btp->dev);
+	int	fd = libxfs_device_to_fd(btp->bt_bdev);
 	int	bytes = BBTOB(len);
 	int	error;
 
@@ -585,7 +585,7 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, xfs_buf_t *bp,
 
 	error = __read_buf(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno), flags);
 	if (!error &&
-	    bp->b_target->dev == btp->dev &&
+	    bp->b_target->bt_bdev == btp->bt_bdev &&
 	    bp->b_bn == blkno &&
 	    bp->b_length == len)
 		bp->b_flags |= LIBXFS_B_UPTODATE;
@@ -615,7 +615,7 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 	void	*buf;
 	int	i;
 
-	fd = libxfs_device_to_fd(btp->dev);
+	fd = libxfs_device_to_fd(btp->bt_bdev);
 	buf = bp->b_addr;
 	for (i = 0; i < bp->b_nmaps; i++) {
 		off64_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
@@ -799,7 +799,7 @@ int
 libxfs_bwrite(
 	struct xfs_buf	*bp)
 {
-	int		fd = libxfs_device_to_fd(bp->b_target->dev);
+	int		fd = libxfs_device_to_fd(bp->b_target->bt_bdev);
 
 	/*
 	 * we never write buffers that are marked stale. This indicates they
@@ -1126,11 +1126,11 @@ libxfs_blkdev_issue_flush(
 {
 	int			fd, ret;
 
-	if (btp->dev == 0)
+	if (btp->bt_bdev == 0)
 		return 0;
 
-	fd = libxfs_device_to_fd(btp->dev);
-	ret = platform_flush_device(fd, btp->dev);
+	fd = libxfs_device_to_fd(btp->bt_bdev);
+	ret = platform_flush_device(fd, btp->bt_bdev);
 	return ret ? -errno : 0;
 }
 
@@ -1207,7 +1207,7 @@ libxfs_log_clear(
 	char			*ptr;
 
 	if (((btp && dptr) || (!btp && !dptr)) ||
-	    (btp && !btp->dev) || !fs_uuid)
+	    (btp && !btp->bt_bdev) || !fs_uuid)
 		return -EINVAL;
 
 	/* first zero the log */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 370ac6194e2f..ffbeda16faa7 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3524,7 +3524,7 @@ prepare_devices(
 			 lsunit, XLOG_FMT, XLOG_INIT_CYCLE, false);
 
 	/* finally, check we can write the last block in the realtime area */
-	if (mp->m_rtdev_targp->dev && cfg->rtblocks > 0) {
+	if (mp->m_rtdev_targp->bt_bdev && cfg->rtblocks > 0) {
 		buf = alloc_write_buf(mp->m_rtdev_targp,
 				XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
 				BTOBB(cfg->blocksize));
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 9bb9c5b9c0b9..3e63b8bea484 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -871,7 +871,7 @@ init_prefetch(
 	xfs_mount_t		*pmp)
 {
 	mp = pmp;
-	mp_fd = libxfs_device_to_fd(mp->m_ddev_targp->dev);
+	mp_fd = libxfs_device_to_fd(mp->m_ddev_targp->bt_bdev);
 	pf_max_bytes = sysconf(_SC_PAGE_SIZE) << 7;
 	pf_max_bbs = pf_max_bytes >> BBSHIFT;
 	pf_max_fsbs = pf_max_bytes >> mp->m_sb.sb_blocklog;
-- 
2.28.0


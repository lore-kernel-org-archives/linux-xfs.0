Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC043F8EB7
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313235; cv=none; b=MWQ97qdddt1gpvpdX3vHL3W4KTJouR+jcmwngnYGHNvpSNUqahi4eo8HPWDY13F8L5GfyCec2XrrphHU0YeLhObBhE9hDY0GR8ptM94Fm8/vPYxK+SuS+eGpCc3XE8i3Wr2fhJjIaVzWq6Fh4bZCcHZNvKsk9HlNcPfVHT9WOdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313235; c=relaxed/simple;
	bh=NWSQkVtJFqK/IVhQ1wBlkM49ACHlvrO7jOixaEKFWlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fP/wwfIzXkFN5kXxCMoluQhujnBuOGQ0TJnOw/9Qlnf3P4Zm9S+hY9nMLPdwzAC2kk1JQnXHaqyCYI8uWuCP++/1iqrmnL/Ffbrk2NUbR4Ss98zWW5Z/qJk45byeofs2VGgudb3dn1L41bBOKOoh0HO73ctC95nRlHEM5G0L3Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rETtvPJs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rETtvPJs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=K3IgZ2ydyfxOJQtDPr79HiLE9k7GKWFAdTxq8vf4lZc=; b=rETtvPJsNrTvtolvBT2CGDekbf
	GfvKKtjn0n0kapDy+o3aMx4Qg/ZQSRYRgR/uxiVKLy+ZSnJ3TVKgCVJ3kWuylxLpq2DJes9ItWrbq
	YY82ks3NRUxkWsMj7ZMLvELx/XA+FP9r0u86buTyqER6Jt1BKNK9W9hduaRAmdfkf8OI4s68BK08B
	sw7izVObPkxcWWg6PtCx571ULBoE6ycHyFNssLacu+yvrOIqFGvkzW2dEMS4WT2m7jFxJDMFON90p
	ms9SlbkoIHGbQH1vFnFpotfMYMOI+jd/EwOTFdqVOuG+hrxMyMRDDvDqYbPODFKNneGmZwrXxeOw5
	oT+71o8A==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yFr-0000000Cgbf-1Sv2;
	Fri, 25 Sep 2026 05:13:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/10] libxfs: unify buftarg handling with the kernel
Date: Fri, 25 Sep 2026 07:12:50 +0200
Message-ID: <20260925051336.2997014-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925051336.2997014-1-hch@lst.de>
References: <20260925051336.2997014-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

In the kernel, the RT buftarg is set to NULL when not realtime device is
present, but libxfs still allocates one, and all users instead check for
a NULL ->bt_bdev.

Switch to the kernel model of never allocating the buftarg, and check
mp->m_rtdev_targp for NULL instead of just ->bt_bdev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/io.c         |  4 ++--
 db/metadump.c   |  7 +++----
 libxfs/init.c   | 40 +++++++++++++++++++---------------------
 libxfs/rdwr.c   | 25 ++++++++++++++++---------
 mkfs/xfs_mkfs.c |  6 ++----
 5 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/db/io.c b/db/io.c
index fc9a25d41024..6aafe5bd8a15 100644
--- a/db/io.c
+++ b/db/io.c
@@ -651,7 +651,7 @@ set_log_cur(
 	int		ring_flag,
 	bbmap_t		*bbmap)
 {
-	if (mp->m_logdev_targp->bt_bdev == mp->m_ddev_targp->bt_bdev) {
+	if (mp->m_logdev_targp == mp->m_ddev_targp) {
 		fprintf(stderr, "no external log specified\n");
 		exitcode = 1;
 		return;
@@ -668,7 +668,7 @@ set_rt_cur(
 	int		ring_flag,
 	bbmap_t		*bbmap)
 {
-	if (!mp->m_rtdev_targp->bt_bdev) {
+	if (!mp->m_rtdev_targp) {
 		printf(_("realtime device not loaded, use -R.\n"));
 		return ENODEV;
 	}
diff --git a/db/metadump.c b/db/metadump.c
index 39639a0d51b0..6c12a5270fea 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -3344,8 +3344,7 @@ write_metadump_v2(
 	uint64_t		addr;
 
 	addr = off;
-	if (type == TYP_LOG &&
-	    mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
+	if (type == TYP_LOG && mp->m_logdev_targp != mp->m_ddev_targp)
 		addr |= XME_ADDR_LOG_DEVICE;
 	else if (type == TYP_RTSB)
 		addr |= XME_ADDR_RT_DEVICE;
@@ -3464,7 +3463,7 @@ metadump_f(
 		return 0;
 	}
 
-	if (mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
+	if (mp->m_logdev_targp != mp->m_ddev_targp)
 		metadump.external_log = true;
 
 	if (metadump.external_log && !version_opt_set)
@@ -3481,7 +3480,7 @@ metadump_f(
 	 * enabled.
 	 */
 	if (xfs_has_realtime(mp) && xfs_has_rtsb(mp)) {
-		if (mp->m_rtdev_targp->bt_bdev) {
+		if (mp->m_rtdev_targp) {
 			metadump.realtime_data = true;
 			if (!version_opt_set)
 				metadump.version = 2;
diff --git a/libxfs/init.c b/libxfs/init.c
index 1613ce2d14a3..65dadb1a23f7 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -307,7 +307,7 @@ rtmount_init(
 		return -1;
 	}
 
-	if (mp->m_rtdev_targp->bt_bdev == 0 && !xfs_is_debugger(mp)) {
+	if (!mp->m_rtdev_targp && !xfs_is_debugger(mp)) {
 		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
 			progname);
 		return -1;
@@ -541,27 +541,26 @@ libxfs_buftarg_reinit(
 		exit(1);
 	}
 
-	if (!xi->log.dev || xi->log.dev == xi->data.dev) {
-		if (mp->m_logdev_targp != mp->m_ddev_targp) {
+	if (mp->m_logdev_targp != mp->m_ddev_targp) {
+		if ((xi->log.dev && xi->log.dev == xi->data.dev) ||
+		    mp->m_logdev_targp->bt_bdev != xi->log.dev ||
+		    mp->m_logdev_targp->bt_mount != mp) {
 			fprintf(stderr,
-			_("%s: bad buftarg reinit, ldev mismatch\n"),
+				_("%s: bad buftarg reinit, logdev\n"),
 				progname);
 			exit(1);
 		}
-	} else if (mp->m_logdev_targp->bt_bdev != xi->log.dev ||
-		   mp->m_logdev_targp->bt_mount != mp) {
-		fprintf(stderr,
-			_("%s: bad buftarg reinit, logdev\n"),
-			progname);
-		exit(1);
 	}
-	if ((xi->rt.dev || xi->rt.dev == xi->data.dev) &&
-	    (mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
-	     mp->m_rtdev_targp->bt_mount != mp)) {
-		fprintf(stderr,
-			_("%s: bad buftarg reinit, rtdev\n"),
-			progname);
-		exit(1);
+
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
+		if ((xi->rt.dev && xi->rt.dev == xi->data.dev) ||
+		    mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
+		    mp->m_rtdev_targp->bt_mount != mp) {
+			fprintf(stderr,
+				_("%s: bad buftarg reinit, rtdev\n"),
+				progname);
+			exit(1);
+		}
 	}
 }
 
@@ -687,7 +686,7 @@ check_many_rtgroups(
 	xfs_daddr_t		d;
 	int			error;
 
-	if (!mp->m_rtdev_targp->bt_bdev) {
+	if (!mp->m_rtdev_targp) {
 		fprintf(stderr, _("%s: no rt device, ignoring rgcount %u\n"),
 				progname, sbp->sb_rgcount);
 		if (!xfs_is_debugger(mp))
@@ -824,8 +823,7 @@ libxfs_mount(
 	} else
 		libxfs_buf_relse(bp);
 
-	if (mp->m_logdev_targp->bt_bdev &&
-	    mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev) {
+	if (mp->m_logdev_targp != mp->m_ddev_targp) {
 		d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks ||
 		    libxfs_buf_read(mp->m_logdev_targp,
@@ -1045,7 +1043,7 @@ libxfs_umount(
 	free(mp->m_fsname);
 	mp->m_fsname = NULL;
 
-	if (mp->m_rtdev_targp != mp->m_ddev_targp)
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp)
 		libxfs_buftarg_free(mp->m_rtdev_targp);
 	if (mp->m_logdev_targp != mp->m_ddev_targp)
 		libxfs_buftarg_free(mp->m_logdev_targp);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 90f2d56687ca..14cfec7a2859 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -171,7 +171,7 @@ libxfs_getrtsb(
 	struct xfs_buf		*bp;
 	int			error;
 
-	if (!mp->m_rtdev_targp->bt_bdev)
+	if (!mp->m_rtdev_targp)
 		return NULL;
 
 	ASSERT(!mp->m_sb.sb_rtstart);
@@ -1028,7 +1028,8 @@ libxfs_bcache_purge(struct xfs_mount *mp)
 		return;
 	cache_purge(mp->m_ddev_targp->bcache);
 	cache_purge(mp->m_logdev_targp->bcache);
-	cache_purge(mp->m_rtdev_targp->bcache);
+	if (mp->m_rtdev_targp)
+		cache_purge(mp->m_rtdev_targp->bcache);
 }
 
 void
@@ -1038,7 +1039,8 @@ libxfs_bcache_flush(struct xfs_mount *mp)
 		return;
 	cache_flush(mp->m_ddev_targp->bcache);
 	cache_flush(mp->m_logdev_targp->bcache);
-	cache_flush(mp->m_rtdev_targp->bcache);
+	if (mp->m_rtdev_targp)
+		cache_flush(mp->m_rtdev_targp->bcache);
 }
 
 int
@@ -1046,7 +1048,8 @@ libxfs_bcache_overflowed(struct xfs_mount *mp)
 {
 	return cache_overflowed(mp->m_ddev_targp->bcache) ||
 		cache_overflowed(mp->m_logdev_targp->bcache) ||
-		cache_overflowed(mp->m_rtdev_targp->bcache);
+		(mp->m_rtdev_targp &&
+		 cache_overflowed(mp->m_rtdev_targp->bcache));
 }
 
 struct cache_operations libxfs_bcache_operations = {
@@ -1185,15 +1188,19 @@ libxfs_log_clear(
 	xfs_daddr_t		end_blk;
 	char			*ptr;
 
-	if (((btp && dptr) || (!btp && !dptr)) ||
-	    (btp && !btp->bt_bdev) || !fs_uuid)
+	if (!fs_uuid)
 		return -EINVAL;
 
-	/* first zero the log */
-	if (btp)
+	if (btp) {
+		if (dptr)
+			return -EINVAL;
+		/* first zero the log */
 		libxfs_device_zero(btp, start, length);
-	else
+	} else {
+		if (!dptr)
+			return -EINVAL;
 		memset(dptr, 0, BBTOB(length));
+	}
 
 	/*
 	 * Initialize the log record length and LSNs. XLOG_INIT_CYCLE is a
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 3ce49a36eaa8..6eca76f0c3c9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -5632,10 +5632,8 @@ prepare_devices(
 			 &sbp->sb_uuid, cfg->sb_feat.log_version,
 			 lsunit, XLOG_FMT, XLOG_INIT_CYCLE, false);
 	/* finally, check we can write the last block in the realtime area */
-	if (mp->m_rtdev_targp->bt_bdev &&
-	    mp->m_rtdev_targp != mp->m_ddev_targp &&
-	    cfg->rtblocks > 0 &&
-	    !xfs_has_zoned(mp)) {
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp &&
+	    cfg->rtblocks > 0 && !xfs_has_zoned(mp)) {
 		buf = alloc_write_buf(mp->m_rtdev_targp,
 				XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
 				BTOBB(cfg->blocksize));
-- 
2.53.0


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE41226198
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824359; cv=none; b=WUzgUH70ST1ZCogEwOW7OxLBtBDQLs9fHKWMbuL26eDS2gcmYMbvIkK/9K/jc8LzZo6jIUCEc0ozsxQ0FxRTmXA4AfZQjkwJcviDNXh7GwuBUo8wVZA8wS8p7X7x01lS0Up6Ew7hBa46f7M6Gq+al2EEMILVAdvoljDH5RcSETw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824359; c=relaxed/simple;
	bh=WUov6V1iqUcqKVgKRn3h/vqf5m4KwebtmTgqBmGdvic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlngxZcFSpyZTCX23Br4iJG3SAlosOZuqGUquU60N/6r88zRguq2Dvgy5ipau/UdRdR8hGUzEvm6B1mAH7s6mPV5DXW9iih1ybPTrjBgLwriX35SjFin6Tc0Dwtud83D0VSLuH2023oZEAIxYvEmptaZjrr5qBzs6SLOJy9Dwn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vqrlnMZr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vqrlnMZr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=f1eV9nAraZjKIxkG7n3qAVsv0Fo47Nsqo//aBPe8KpM=; b=vqrlnMZrz8lxs8yBOv/yocsST8
	R3AR2qfkSfqGJKl1x2+qUDJ24qi2W0V6dkpn035/+d64fI9CEBSutP1FkbERjjRzrhSpa9YUtDrq/
	5Lp1QkLfD7Xf1QiKeC8uEXW+d9yzK2TSYcZh++Z5KFcfLgNA9HVTSd+qPO+J1VhrtH6sTTzr3kJKi
	p9LDSsx5g0wS4aQIsWqiimzwowa0UrW3SCEkCbauz7n9ja08XIFuFhxRDZZKweGlhw0BvpDWmYbrW
	7i704rvHwvgd4WdjTRd/MgVURDG0o/qhp9mG9fO9WESB3SdT+nGqrKpkXSMt61qbMKMQCdtjtXwMG
	LjED3uWw==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfve9-00000005QIr-06Qx;
	Thu, 06 Feb 2025 06:45:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 15/43] xfs: allow internal RT devices for zoned mode
Date: Thu,  6 Feb 2025 07:44:31 +0100
Message-ID: <20250206064511.2323878-16-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Allow creating an RT subvolume on the same device as the main data
device.  This is mostly used for SMR HDDs where the conventional zones
are used for the data device and the sequential write required zones
for the zoned RT section.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_group.h   |  6 ++++--
 fs/xfs/libxfs/xfs_rtgroup.h |  8 +++++---
 fs/xfs/libxfs/xfs_sb.c      |  1 +
 fs/xfs/xfs_file.c           |  2 +-
 fs/xfs/xfs_fsops.c          |  4 ++++
 fs/xfs/xfs_mount.h          |  7 +++++++
 fs/xfs/xfs_rtalloc.c        |  3 ++-
 fs/xfs/xfs_super.c          | 12 ++++++++++--
 8 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 242b05627c7a..a70096113384 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -107,9 +107,11 @@ xfs_gbno_to_daddr(
 	xfs_agblock_t		gbno)
 {
 	struct xfs_mount	*mp = xg->xg_mount;
-	uint32_t		blocks = mp->m_groups[xg->xg_type].blocks;
+	struct xfs_groups	*g = &mp->m_groups[xg->xg_type];
+	xfs_fsblock_t		fsbno;
 
-	return XFS_FSB_TO_BB(mp, (xfs_fsblock_t)xg->xg_gno * blocks + gbno);
+	fsbno = (xfs_fsblock_t)xg->xg_gno * g->blocks + gbno;
+	return XFS_FSB_TO_BB(mp, g->start_fsb + fsbno);
 }
 
 static inline uint32_t
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 9c7e03f913cb..e35d1d798327 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -230,7 +230,8 @@ xfs_rtb_to_daddr(
 	xfs_rgnumber_t		rgno = xfs_rtb_to_rgno(mp, rtbno);
 	uint64_t		start_bno = (xfs_rtblock_t)rgno * g->blocks;
 
-	return XFS_FSB_TO_BB(mp, start_bno + (rtbno & g->blkmask));
+	return XFS_FSB_TO_BB(mp,
+		g->start_fsb + start_bno + (rtbno & g->blkmask));
 }
 
 static inline xfs_rtblock_t
@@ -238,10 +239,11 @@ xfs_daddr_to_rtb(
 	struct xfs_mount	*mp,
 	xfs_daddr_t		daddr)
 {
-	xfs_rfsblock_t		bno = XFS_BB_TO_FSBT(mp, daddr);
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+	xfs_rfsblock_t		bno;
 
+	bno = XFS_BB_TO_FSBT(mp, daddr) - g->start_fsb;
 	if (xfs_has_rtgroups(mp)) {
-		struct xfs_groups *g = &mp->m_groups[XG_TYPE_RTG];
 		xfs_rgnumber_t	rgno;
 		uint32_t	rgbno;
 
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 8f57b14995c8..088c192810f5 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1204,6 +1204,7 @@ xfs_sb_mount_rextsize(
 		rgs->blocks = sbp->sb_rgextents * sbp->sb_rextsize;
 		rgs->blklog = mp->m_sb.sb_rgblklog;
 		rgs->blkmask = xfs_mask32lo(mp->m_sb.sb_rgblklog);
+		rgs->start_fsb = mp->m_sb.sb_rtstart;
 	} else {
 		rgs->blocks = 0;
 		rgs->blklog = 0;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d88a771d4c23..807e85e16a52 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -150,7 +150,7 @@ xfs_file_fsync(
 	 * ensure newly written file data make it to disk before logging the new
 	 * inode size in case of an extending write.
 	 */
-	if (XFS_IS_REALTIME_INODE(ip))
+	if (XFS_IS_REALTIME_INODE(ip) && mp->m_rtdev_targp != mp->m_ddev_targp)
 		error = blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
 	else if (mp->m_logdev_targp != mp->m_ddev_targp)
 		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 22d50f8acd92..56886f12c862 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -308,6 +308,10 @@ xfs_growfs_data(
 	if (!mutex_trylock(&mp->m_growlock))
 		return -EWOULDBLOCK;
 
+	/* we can't grow the data section when an internal RT section exists */
+	if (in->newblocks != mp->m_sb.sb_dblocks && mp->m_sb.sb_rtstart)
+		return -EINVAL;
+
 	/* update imaxpct separately to the physical grow of the filesystem */
 	if (in->imaxpct != mp->m_sb.sb_imax_pct) {
 		error = xfs_growfs_imaxpct(mp, in->imaxpct);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 5a1184ff1995..7c29f3f9ba78 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -103,6 +103,13 @@ struct xfs_groups {
 	 * rtgroup, so this mask must be 64-bit.
 	 */
 	uint64_t		blkmask;
+
+	/*
+	 * Start of the first group in the device.  This is used to support a
+	 * RT device following the data device on the same block device for
+	 * SMR hard drives.
+	 */
+	xfs_fsblock_t		start_fsb;
 };
 
 /*
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index c3a8efc7f09b..a0fd1dc5d362 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1266,7 +1266,8 @@ xfs_rt_check_size(
 		return -EFBIG;
 	}
 
-	error = xfs_buf_read_uncached(mp->m_rtdev_targp, daddr,
+	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
+			XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart) + daddr,
 			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
 	if (error)
 		xfs_warn(mp, "cannot read last RT device sector (%lld)",
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8a4b94dab6dd..42ca459e6b86 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -533,7 +533,15 @@ xfs_setup_devices(
 		if (error)
 			return error;
 	}
-	if (mp->m_rtdev_targp) {
+
+	if (mp->m_sb.sb_rtstart) {
+		if (mp->m_rtdev_targp) {
+			xfs_warn(mp,
+		"can't use internal and external rtdev at the same time");
+			return -EINVAL;
+		}
+		mp->m_rtdev_targp = mp->m_ddev_targp;
+	} else if (mp->m_rtname) {
 		error = xfs_setsize_buftarg(mp->m_rtdev_targp,
 					    mp->m_sb.sb_sectsize);
 		if (error)
@@ -757,7 +765,7 @@ xfs_mount_free(
 {
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_free_buftarg(mp->m_logdev_targp);
-	if (mp->m_rtdev_targp)
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp)
 		xfs_free_buftarg(mp->m_rtdev_targp);
 	if (mp->m_ddev_targp)
 		xfs_free_buftarg(mp->m_ddev_targp);
-- 
2.45.2


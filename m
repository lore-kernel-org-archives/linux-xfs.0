Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA041EC4D9
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907442; cv=none; b=qdQHTZVOCrxIzNxxyCeUTzv+yjeIwVwD24ESEd2/IPn1axFDWczWi5jrlTGooDQppXoAD67Epm4aBux9kyRVN8Wn+XVf0jU3dieOJSOn/rN2g+BPit2q9hDqr1BQjQCvO9UQue/GIprbPjP3P6gxGE9HKhsvWWN1uAM7ZAdOzmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907442; c=relaxed/simple;
	bh=MGf0vgRXFeMAZw3AOOCfKpJiCs7+wHZHor19jl1sDqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmSnb6VZ/3VMuze0w1tVEXPx8f/5V8VCZcgqCpBUee+5Diu0lQgZExV2GTcOCOLove78vvOfJZ2Qox2ZFUOHCTSKCxTodImq+VRdo5fknwDanlMma/tQZp63z4xgKzM9mvSdXefBBODMPARss3nWYzcVNIqeqr05pRVSOZ/6LUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GqH1rvt9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GqH1rvt9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BwUCDcJIfNJBMA2K4LyRJVdbYtat3uxvK7L31+5FOAQ=; b=GqH1rvt9sxgdmontBVdIDF0HxY
	Y8Z6WMGxRUPVp57G4i16iz6X/89iUeEqc4/wC/IBm415OizWkMlC1s/uAMCA3Gr/JKYdQn2d2Taoz
	z6hISYYy22FNe49aLhkxmqQlfWI1iZ0kuP3K2l5aqr0tFelilZ7bIRDJu9Trd0/JAdCX40QxzxBAl
	zhRBvmVNISpDpCbrM4ZPmZapUWGNifq1mjU1iIhYAqmcorSoofVTLmgRWP266rqHIcnHocT2KjbjQ
	pIsUScWgvy0+0MVgSSoUlM6P9dY4mDXFVZuF5VcAlbqVaEf3UK+TFBO5eSRq9vkWV1UnVuR697ZTu
	h45eJC+Q==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIX2-0000000EJAU-2AbK;
	Wed, 11 Dec 2024 08:57:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 16/43] xfs: allow internal RT devices for zoned mode
Date: Wed, 11 Dec 2024 09:54:41 +0100
Message-ID: <20241211085636.1380516-17-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
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
---
 fs/xfs/libxfs/xfs_group.h   |  6 ++++--
 fs/xfs/libxfs/xfs_rtgroup.h |  8 +++++---
 fs/xfs/libxfs/xfs_sb.c      |  1 +
 fs/xfs/xfs_file.c           |  2 +-
 fs/xfs/xfs_mount.h          |  7 +++++++
 fs/xfs/xfs_rtalloc.c        |  3 ++-
 fs/xfs/xfs_super.c          | 12 ++++++++++--
 7 files changed, 30 insertions(+), 9 deletions(-)

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
index 0e1d9474ab77..d4c15c706b17 100644
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
index 0bbe0b87bf04..20b8318d4a59 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1175,6 +1175,7 @@ xfs_sb_mount_rextsize(
 		rgs->blocks = sbp->sb_rgextents * sbp->sb_rextsize;
 		rgs->blklog = mp->m_sb.sb_rgblklog;
 		rgs->blkmask = xfs_mask32lo(mp->m_sb.sb_rgblklog);
+		rgs->start_fsb = mp->m_sb.sb_rtstart;
 	} else {
 		rgs->blocks = 0;
 		rgs->blklog = 0;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6bcfd4c34a37..27301229011b 100644
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
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 72c5389ff78b..3d92678d2c3b 100644
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
 
 enum xfs_free_counter {
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e457a2c2d561..7ef62e7a91c1 100644
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
index 92dd44965943..18430e975c53 100644
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


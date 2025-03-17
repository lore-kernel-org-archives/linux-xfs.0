Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C6818C33B
	for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 05:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742190549; cv=none; b=LYPnH3/pNPBc1OVE0gYcNZe6GU04y+Tv3tq5JbKhuKTh5YrDRBCSVTv4HOR0l+A/XE1csZIApRpw/e4HGpjN0/AAMjUGyXMIcYo29mV42L790s4Gu8dXzZTc1ba7e5sa4BCs0wCa3oxbos9bk2WiG2Sfqsgu6HHzQIbS/LG5wzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742190549; c=relaxed/simple;
	bh=dW2HpItAVqEkwy7f8DrHeAaCzWiLCLKBWzvum2XhjbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AaKCS2FaFzDxT+WGkukpWuR/JVJHjMBm+Mw6TDWdzMEoM0DVvjxPRc64bAPg9mbcvKVQmqkp+MsP0cJixb3gQOf5h48C5+/5JW9JDbc+EWguEVNy12hzlQwaJsna2QdpUTbOOjhaapStEEzLxVNRgI9syGZLdMw951Xup2xAhmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wALO3RTJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wALO3RTJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tHSrUAa4jQhSdH96RwDas/FsSCOLFogmIVur0Z59fzU=; b=wALO3RTJOPfjBVubRh+hY5hKiC
	PnuGR8QkXEuwwPCTDl6duR2ksHtJFjV/IzdoHCZMMGpQHeJAzRLmUSZyK+jaJoAEwE7G1xEWVUdOe
	NfINBoM5FAflP0UQxKwdFlVuYxaeP/deUH6woZ7NCgpaRDWzwhhl6vn6QVqgMBXKoWdxxMn39LUev
	4UhHbICdV77egSMmjZmQbm8AQ2aij7js3xrlSoccBz0pHZ3Mphs63A5dyumpnp/dlWGnMD4TXBJwa
	Eq4qJIxcHU7ucAsLVdgeBK+nXoWXqKKTSEBSFgbc4LiCe/n9nsW8A8VvQgDIoicifIsp7vJ7/+pDl
	6AVmTpIQ==;
Received: from [2001:4bb8:2dd:4138:8d2f:1fda:8eb2:7cb7] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tu3LW-00000001Ip1-2WLh;
	Mon, 17 Mar 2025 05:49:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfs: remove the flags argument to xfs_buf_read_uncached
Date: Mon, 17 Mar 2025 06:48:35 +0100
Message-ID: <20250317054850.1132557-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250317054850.1132557-1-hch@lst.de>
References: <20250317054850.1132557-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

No callers passes flags to xfs_buf_read_uncached, which makes sense
given that the flags apply to behavior not used for uncached buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c     | 3 +--
 fs/xfs/xfs_buf.h     | 2 +-
 fs/xfs/xfs_fsops.c   | 2 +-
 fs/xfs/xfs_mount.c   | 6 +++---
 fs/xfs/xfs_rtalloc.c | 4 ++--
 5 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index bf75964bbfe8..6469a69b18fe 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -802,7 +802,6 @@ xfs_buf_read_uncached(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		daddr,
 	size_t			numblks,
-	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
@@ -811,7 +810,7 @@ xfs_buf_read_uncached(
 
 	*bpp = NULL;
 
-	error = xfs_buf_get_uncached(target, numblks, flags, &bp);
+	error = xfs_buf_get_uncached(target, numblks, 0, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index db43bdc17f55..6a426a8d6197 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -275,7 +275,7 @@ xfs_buf_readahead(
 int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
 		xfs_buf_flags_t flags, struct xfs_buf **bpp);
 int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
-		size_t numblks, xfs_buf_flags_t flags, struct xfs_buf **bpp,
+		size_t numblks, struct xfs_buf **bpp,
 		const struct xfs_buf_ops *ops);
 int _xfs_buf_read(struct xfs_buf *bp);
 void xfs_buf_hold(struct xfs_buf *bp);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b6f3d7abdae5..0ada73569394 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -111,7 +111,7 @@ xfs_growfs_data_private(
 	if (nb > mp->m_sb.sb_dblocks) {
 		error = xfs_buf_read_uncached(mp->m_ddev_targp,
 				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
-				XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+				XFS_FSS_TO_BB(mp, 1), &bp, NULL);
 		if (error)
 			return error;
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e65a659901d5..00b53f479ece 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -186,7 +186,7 @@ xfs_readsb(
 	 */
 reread:
 	error = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
-				      BTOBB(sector_size), 0, &bp, buf_ops);
+				      BTOBB(sector_size), &bp, buf_ops);
 	if (error) {
 		if (loud)
 			xfs_warn(mp, "SB validate failed with error %d.", error);
@@ -414,7 +414,7 @@ xfs_check_sizes(
 	}
 	error = xfs_buf_read_uncached(mp->m_ddev_targp,
 					d - XFS_FSS_TO_BB(mp, 1),
-					XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+					XFS_FSS_TO_BB(mp, 1), &bp, NULL);
 	if (error) {
 		xfs_warn(mp, "last sector read failed");
 		return error;
@@ -431,7 +431,7 @@ xfs_check_sizes(
 	}
 	error = xfs_buf_read_uncached(mp->m_logdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
-					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+					XFS_FSB_TO_BB(mp, 1), &bp, NULL);
 	if (error) {
 		xfs_warn(mp, "log device read failed");
 		return error;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3aa222ea9500..e35c728f222e 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1350,7 +1350,7 @@ xfs_rt_check_size(
 
 	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
 			XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart) + daddr,
-			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+			XFS_FSB_TO_BB(mp, 1), &bp, NULL);
 	if (error)
 		xfs_warn(mp, "cannot read last RT device sector (%lld)",
 				last_block);
@@ -1511,7 +1511,7 @@ xfs_rtmount_readsb(
 
 	/* m_blkbb_log is not set up yet */
 	error = xfs_buf_read_uncached(mp->m_rtdev_targp, XFS_RTSB_DADDR,
-			mp->m_sb.sb_blocksize >> BBSHIFT, 0, &bp,
+			mp->m_sb.sb_blocksize >> BBSHIFT, &bp,
 			&xfs_rtsb_buf_ops);
 	if (error) {
 		xfs_warn(mp, "rt sb validate failed with error %d.", error);
-- 
2.45.2


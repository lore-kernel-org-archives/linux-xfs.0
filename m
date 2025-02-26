Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F9E2376E9
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596248; cv=none; b=HBQ3HetgTUcMAuXkGyFIAolC/CmKlmBoA1K36rcVjpWAFuC/k9c/WEGufQn5/7WHohF1UEaP9WDvraPxhYeHwT5aq6lIGm+6yrr4jbXZSwMK9ar6aWhXL7tfi2slpE5YIX6RV/Neu4uOxE8Jf/dzr3kA7nnoAFPQ39HyMsCqNWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596248; c=relaxed/simple;
	bh=e0oCtHOtE5sglUoikCluKBchmvbNG+/s+DQxLe5wAPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8oszKOOOKaX+J3kj/mc4j8QmnMcaW+FZX6yoKjFpZrA46P+Ftxaq30lny0zPB7qOHua/OFIdhngCP3NNHRoi5MoXMJaJgq1CVCwd08nEJJqKOeXyLUoZ35mklBAP+RctV5OmbXYFvAZNvjukTXNUzzs1kap+OkuBGF6VHe6hlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PpfVyg3O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PpfVyg3O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SJ7xmHs5gQY+W/fm2PHxOoOvs0UNK2dkzCE56MWvQ6A=; b=PpfVyg3Odr0lp0Zh3Y+GZEE0+I
	FkmVdRhi6D6ltp7u1m5J77dbKuAQ9SW1YF5ZgG5K5CwmX0xghz1vd15d7ar4QMnBc8OGvzLSMA8ve
	M1rsQCe8fQus/Y3Z2LsSPH4OB7INk203zvAqqN+XpH1JF4ihb7UqiptWS3a/Cx6GEnTd2Y/OJAYC6
	KACSHoF21cYPnhmKAbeQtLyQ0D/Y7iONi0au4fyJ52i0w3S7Vco3fpwIjj5XoX95YwebujWte12fW
	pfrd8acezH2HEW/o2Na7cwrHape2YqZoJy+q4TVIc8mwYbSZpYRzq32tbSVikMo6YssNtbayQPI8Z
	YLHSOZqw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb0-000000053sD-3B2U;
	Wed, 26 Feb 2025 18:57:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/44] xfs: factor out a xfs_rt_check_size helper
Date: Wed, 26 Feb 2025 10:56:40 -0800
Message-ID: <20250226185723.518867-9-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper to check that the last block of a RT device is readable
to share the code between mount and growfs.  This also adds the mount
time overflow check to growfs and improves the error messages.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 62 ++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4e5e9142457f..f5a0dbc46a14 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1248,6 +1248,34 @@ xfs_grow_last_rtg(
 			mp->m_sb.sb_rgextents;
 }
 
+/*
+ * Read in the last block of the RT device to make sure it is accessible.
+ */
+static int
+xfs_rt_check_size(
+	struct xfs_mount	*mp,
+	xfs_rfsblock_t		last_block)
+{
+	xfs_daddr_t		daddr = XFS_FSB_TO_BB(mp, last_block);
+	struct xfs_buf		*bp;
+	int			error;
+
+	if (XFS_BB_TO_FSB(mp, daddr) != last_block) {
+		xfs_warn(mp, "RT device size overflow: %llu != %llu",
+			XFS_BB_TO_FSB(mp, daddr), last_block);
+		return -EFBIG;
+	}
+
+	error = xfs_buf_read_uncached(mp->m_rtdev_targp, daddr,
+			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error)
+		xfs_warn(mp, "cannot read last RT device sector (%lld)",
+				last_block);
+	else
+		xfs_buf_relse(bp);
+	return error;
+}
+
 /*
  * Grow the realtime area of the filesystem.
  */
@@ -1259,7 +1287,6 @@ xfs_growfs_rt(
 	xfs_rgnumber_t		old_rgcount = mp->m_sb.sb_rgcount;
 	xfs_rgnumber_t		new_rgcount = 1;
 	xfs_rgnumber_t		rgno;
-	struct xfs_buf		*bp;
 	xfs_agblock_t		old_rextsize = mp->m_sb.sb_rextsize;
 	int			error;
 
@@ -1302,15 +1329,10 @@ xfs_growfs_rt(
 	error = xfs_sb_validate_fsb_count(&mp->m_sb, in->newblocks);
 	if (error)
 		goto out_unlock;
-	/*
-	 * Read in the last block of the device, make sure it exists.
-	 */
-	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
-				XFS_FSB_TO_BB(mp, in->newblocks - 1),
-				XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+
+	error = xfs_rt_check_size(mp, in->newblocks - 1);
 	if (error)
 		goto out_unlock;
-	xfs_buf_relse(bp);
 
 	/*
 	 * Calculate new parameters.  These are the final values to be reached.
@@ -1443,10 +1465,6 @@ int				/* error */
 xfs_rtmount_init(
 	struct xfs_mount	*mp)	/* file system mount structure */
 {
-	struct xfs_buf		*bp;	/* buffer for last block of subvolume */
-	xfs_daddr_t		d;	/* address of last block of subvolume */
-	int			error;
-
 	if (mp->m_sb.sb_rblocks == 0)
 		return 0;
 	if (mp->m_rtdev_targp == NULL) {
@@ -1457,25 +1475,7 @@ xfs_rtmount_init(
 
 	mp->m_rsumblocks = xfs_rtsummary_blockcount(mp, &mp->m_rsumlevels);
 
-	/*
-	 * Check that the realtime section is an ok size.
-	 */
-	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
-	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_rblocks) {
-		xfs_warn(mp, "realtime mount -- %llu != %llu",
-			(unsigned long long) XFS_BB_TO_FSB(mp, d),
-			(unsigned long long) mp->m_sb.sb_rblocks);
-		return -EFBIG;
-	}
-	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
-					d - XFS_FSB_TO_BB(mp, 1),
-					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
-	if (error) {
-		xfs_warn(mp, "realtime device size check failed");
-		return error;
-	}
-	xfs_buf_relse(bp);
-	return 0;
+	return xfs_rt_check_size(mp, mp->m_sb.sb_rblocks - 1);
 }
 
 static int
-- 
2.45.2


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F04F1EC4F1
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907406; cv=none; b=cz0ZfOezh9VlE5FNxntjIyQ2tJaH4dHO5cmngYXjlhphpP/PzoYJ3KrGB7AAEDBMlxa5QFsT2HlHG6bhV79MLVaD4R9XOMzwcT48iQ1tQ61p6jBC3BLygTz7yK6zRrGq5yZqh1icfsnuJZUnG8lT4OV7lF73SmRVqkBtTHH1NzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907406; c=relaxed/simple;
	bh=JR8guXsJmFUD6IaxAWy5XVx3T6faZNrt3Pz0XzfhASg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOSKRJ4/kYh6ilvlUHgmli6mDy2DBTQkstCLOlo88dQPP58C8Sc3JkjxYk4Q4Ae9Zi8Bep5IyTFCNr6HMjF2wZTdbZ1GWIuG1D+qh19W2avLh0yT7kGU0VIGBYp+54iocjkZJ5AqaMuO2B95WyD3wutid0sMivJNK+2zfJMHkLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NR1r9oCC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NR1r9oCC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yCK8ebZKhCCNRgQ3qH9jSdin+s+AyB7+2EQ1PgmtpGY=; b=NR1r9oCC4kTOyq1j1ZRJCkHG+y
	VjnXDHyCuXe0wUKwhST27YuB1zKjGn+l63Gw4ZV8CASZ6b3JE348BqegejeX4koDOlgc3WsAP+/JL
	y0+LdNzWMOKXHItZvx7bjmBEhLiEySSLGa5LJ0/8j7uTeHih86rEpCzaPBOSIe+nLPu/2XpE7LRhx
	rjRJPl6AHwjDdjZEmY/j2QBeREYtU9eKdNGP1JghRQlqui1Arwp1YInMfElJyPa4WpymaM2Ligwx1
	MU3E9x/zJ4Xb1m4sueFY0d+NAPOfgm/DACRzGiTM2CK4aqfDjTggFPTSpJpPj6anNTelJQdxeCllQ
	cdJXtBuQ==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIWR-0000000EIyc-2T5Z;
	Wed, 11 Dec 2024 08:56:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/43] xfs: factor out a xfs_rt_check_size helper
Date: Wed, 11 Dec 2024 09:54:27 +0100
Message-ID: <20241211085636.1380516-3-hch@lst.de>
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

Add a helper to check that the last block of a RT device is readable
to share the code between mount and growfs.  This also adds the mount
time overflow check to growfs and improves the error messages.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 62 ++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d8e6d073d64d..bc18b694db75 100644
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
@@ -1444,10 +1466,6 @@ int				/* error */
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
@@ -1458,25 +1476,7 @@ xfs_rtmount_init(
 
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


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6ED13B792
	for <linux-xfs@vger.kernel.org>; Fri, 16 Aug 2024 08:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723796362; cv=none; b=XBHoWekW1r+kFZylL5yrE82v8eFIrLhW9tWsyj9xZJlCOU0KG8/d12TV1DZ4vtQPfB5pKcUJw5DPeGC/IMGclOIl65rdtB7ZE0SSfUVExk/FP/9m2N59Zpn2SpKKSiGLFpKLrhgM95/QJFmltGRScFfT1paeCAGdVoUONtqEh8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723796362; c=relaxed/simple;
	bh=f0NboTu6ECgfBFKS4wegeQZeaZu28X/xSRmPUz/8MDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjM8nDTza4HFxVFAStk6U1kzgK9hWmo1+GP4MRHmF261z/qOEl8L+hQ46kOayJfzffb6zzpxS3u81rfN6FtRDe4wKqlPd/VSo/VxH4NLUkD9tuPnBUjI6CgxMT/vK6wMLyqmqmlgHYE6825LmpOT+LRM5oLZA7F8lJiJtKBsob8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2S4t3IOx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2S4t3IOx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XQSVqKToxiCaMR4zygTL6j13GbGvGrgQHxQ3pmcKixk=; b=2S4t3IOx9BGco/lBkLC1Q5cTEl
	ZRrcEzdgJd5iNrLgdhOU3s2VxmND7pOClLYZt1U3MwE7v2SpgXnlUbK6dantT/XFJz7rKYDCU0fiV
	0uOSeJgvd9BGXRw16t875NLs42RE10WtBnuKhiArLMkBGVMh9oVsr22z15MNVJPSEQXGbSLAuTzQT
	l0p1cwn+rWHG5Fdar/PMImEUpo9tR/zyM/ody1PbuxdhFnrmbJXz+zYTpYoTymLwgO2DOthGbKdG2
	Id86KEQ/DANgKEVBtLinpEdaWcaEkuAN7m1butLQL6rJEEAz3K8o1iDNNXv7g9kT3tysa7T4k9iz+
	ySJw30/w==;
Received: from 2a02-8389-2341-5b80-2de7-24a4-8123-7c8f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2de7:24a4:8123:7c8f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sesB5-0000000CEyg-3g57;
	Fri, 16 Aug 2024 08:19:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: don't extend the FITRIM range if the rt device does not support discard
Date: Fri, 16 Aug 2024 10:18:43 +0200
Message-ID: <20240816081908.467810-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240816081908.467810-1-hch@lst.de>
References: <20240816081908.467810-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Fix the newly added discard support to only offer a FITRIM range that
spans the RT device in addition to the main device if the RT device
actually supports discard.  Without this we'll incorrectly accept
a larger range than actually supported and confuse user space if the
RT device does not support discard.  This can easily happen when the
main device is a SSD but the RT device is a hard driver.

Move the code around a bit to keep the max_blocks and granularity
assignments together and explicitly reject that case where only the
RT device supports discard, as that does not fit the way the FITRIM ABI
works very well and is a very fringe use case.

Fixes: 3ba3ab1f6719 ("xfs: enable FITRIM on the realtime device")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_discard.c | 50 +++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index d56efe9eae2cef..77d9d2b39f9b00 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -685,27 +685,18 @@ xfs_ioc_trim(
 	struct xfs_mount		*mp,
 	struct fstrim_range __user	*urange)
 {
-	unsigned int		granularity =
-		bdev_discard_granularity(mp->m_ddev_targp->bt_bdev);
+	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
 	struct block_device	*rt_bdev = NULL;
+	unsigned int		granularity = bdev_discard_granularity(bdev);
+	xfs_rfsblock_t		max_blocks = mp->m_sb.sb_dblocks;
 	struct fstrim_range	range;
 	xfs_daddr_t		start, end;
 	xfs_extlen_t		minlen;
-	xfs_rfsblock_t		max_blocks;
 	uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (mp->m_rtdev_targp &&
-	    bdev_max_discard_sectors(mp->m_rtdev_targp->bt_bdev))
-		rt_bdev = mp->m_rtdev_targp->bt_bdev;
-	if (!bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev) && !rt_bdev)
-		return -EOPNOTSUPP;
-
-	if (rt_bdev)
-		granularity = max(granularity,
-				  bdev_discard_granularity(rt_bdev));
 
 	/*
 	 * We haven't recovered the log, so we cannot use our bnobt-guided
@@ -714,13 +705,36 @@ xfs_ioc_trim(
 	if (xfs_has_norecovery(mp))
 		return -EROFS;
 
+	/*
+	 * If the main device doesn't support discards, fail the entire ioctl
+	 * as the RT blocks are mapped after the main device blocks, and we'd
+	 * have to fake operation results for the main device for the ABI to
+	 * work.
+	 *
+	 * Note that while a main device that supports discards (SSD) and a RT
+	 * device that does not (HDD) is a fairly common setup, the reverse is
+	 * theoretically possible but rather odd, so this is not much of a loss.
+	 */
+	if (!bdev_max_discard_sectors(bdev))
+		return -EOPNOTSUPP;
+
+	if (mp->m_rtdev_targp) {
+		rt_bdev = mp->m_rtdev_targp->bt_bdev;
+		if (!bdev_max_discard_sectors(rt_bdev))
+			rt_bdev = NULL;
+	}
+	if (rt_bdev) {
+		max_blocks += mp->m_sb.sb_rblocks;
+		granularity =
+			max(granularity, bdev_discard_granularity(rt_bdev));
+	}
+
 	if (copy_from_user(&range, urange, sizeof(range)))
 		return -EFAULT;
 
 	range.minlen = max_t(u64, granularity, range.minlen);
 	minlen = XFS_B_TO_FSB(mp, range.minlen);
 
-	max_blocks = mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks;
 	if (range.start >= XFS_FSB_TO_B(mp, max_blocks) ||
 	    range.minlen > XFS_FSB_TO_B(mp, mp->m_ag_max_usable) ||
 	    range.len < mp->m_sb.sb_blocksize)
@@ -729,12 +743,10 @@ xfs_ioc_trim(
 	start = BTOBB(range.start);
 	end = start + BTOBBT(range.len) - 1;
 
-	if (bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev)) {
-		error = xfs_trim_datadev_extents(mp, start, end, minlen,
-				&blocks_trimmed);
-		if (error)
-			last_error = error;
-	}
+	error = xfs_trim_datadev_extents(mp, start, end, minlen,
+			&blocks_trimmed);
+	if (error)
+		last_error = error;
 
 	if (rt_bdev && !xfs_trim_should_stop()) {
 		error = xfs_trim_rtdev_extents(mp, start, end, minlen,
-- 
2.43.0


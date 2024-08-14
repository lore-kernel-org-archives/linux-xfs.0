Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100D048CCD
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 04:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723609447; cv=none; b=VybRVVTqNUKfaHlgFT6n1YFwiFDn78KyOLGQZohMb6YeeX51KvGYiE35pqCwYAIudze1Xren+pgbJ5K5FFcJn6pK7WD831ChF5oh5aLG5WAB+GT3yFoymPtExCqkkw2v602MdiyxYrznWkL8J2JzGkN0/cQMkkM3iyVs02b5wjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723609447; c=relaxed/simple;
	bh=XmPwM97/+Qfx1SB5ZGieBBZaOb/KYb2UuU6kHTqrKjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E29/htj4oYU+RIWFVobXZg2S0h30y7pvFPmWW7aSjLlHX+VY62YrEayFcRRNrZhOG2pzK3n5JclWef93EBIOx8PjggGaoqvn44GnTKTZTlW8yjQ0R6UOqXPGbeBPSYhii8xqEumjWVbpDFq0c+Mq0tLpnTV0e6EndWyPtVOk0Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ES3QXski; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ES3QXski"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6O0gAu4hk2Epn1I6F9qYf/RPUp+ibB/of9uboSp47PE=; b=ES3QXskiCi0oxsKZqCTy+ggL52
	p0v0UvCB7+iyqyRdo4iWl4Fg5r6ISplvEjZbO+rsb60KubYWzZmSlk59hqZrzUP+qao2Ft+AodAUk
	uo5TS3JR9uC73Z1x9Ssa5atW5XRusLEA8LcG5dhvgNVmBSmdXZuoq7lpczE1PV7UzSNTd672W5Y5s
	coJ5/SlPVSipUxBL26WlJ9twPbm4wYWEIasM5sODlPZ515t7X7+WMxco4Ra0L4GdJzxWoAy7STVme
	bssMVC0QqPr1yAf07ZRy+06zEk2PqWy5M3fRc8L70cRAsq4E/1waEv2BXU9pdc4wcUi8LYrpaKf6w
	MwrskWfQ==;
Received: from 2a02-8389-2341-5b80-fd16-64b9-63e2-2d30.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fd16:64b9:63e2:2d30] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1se5YK-00000005giM-45tG;
	Wed, 14 Aug 2024 04:24:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: don't extend the FITRIM range if the rt device does not support discard
Date: Wed, 14 Aug 2024 06:23:58 +0200
Message-ID: <20240814042358.19297-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240814042358.19297-1-hch@lst.de>
References: <20240814042358.19297-1-hch@lst.de>
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
assignments together and to handle the case where only the RT device
supports discard as well.

Fixes: 3ba3ab1f6719 ("xfs: enable FITRIM on the realtime device")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_discard.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 6516afecce0979..46e28499a7d3ce 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -654,9 +654,9 @@ xfs_ioc_trim(
 	struct xfs_mount		*mp,
 	struct fstrim_range __user	*urange)
 {
-	unsigned int		granularity =
-		bdev_discard_granularity(mp->m_ddev_targp->bt_bdev);
+	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
 	struct block_device	*rt_bdev = NULL;
+	unsigned int		granularity = 0;
 	struct fstrim_range	range;
 	xfs_daddr_t		start, end;
 	xfs_extlen_t		minlen;
@@ -666,15 +666,6 @@ xfs_ioc_trim(
 
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
@@ -683,13 +674,33 @@ xfs_ioc_trim(
 	if (xfs_has_norecovery(mp))
 		return -EROFS;
 
+	if (bdev_max_discard_sectors(bdev)) {
+		max_blocks = mp->m_sb.sb_dblocks;
+		granularity = bdev_discard_granularity(bdev);
+	} else {
+		bdev = NULL;
+	}
+
+	if (mp->m_rtdev_targp) {
+		rt_bdev = mp->m_rtdev_targp->bt_bdev;
+		if (!bdev_max_discard_sectors(rt_bdev)) {
+			if (!bdev)
+				return -EOPNOTSUPP;
+			rt_bdev = NULL;
+		}
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
@@ -698,7 +709,7 @@ xfs_ioc_trim(
 	start = BTOBB(range.start);
 	end = start + BTOBBT(range.len) - 1;
 
-	if (bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev)) {
+	if (bdev) {
 		error = xfs_trim_datadev_extents(mp, start, end, minlen,
 				&blocks_trimmed);
 		if (error)
-- 
2.43.0


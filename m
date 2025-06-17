Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947A52192EA
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 10:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750157581; cv=none; b=p9r/CX8trdf3Pfn8eoeXejulIdAwWlNxWfsOnryhkyIyV2nkNsFbGMq91ynDQOeqLL0R7Yfi2UI6Leooq1IeIvVvJkxjkK5NWBTbJLJ3lmUCLl0EkzyRX/uLqK7a1smg0gK7PJTo1uauFN9VzS4C7tQJEalj3gAe3cih/R4695s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750157581; c=relaxed/simple;
	bh=vo+JpfJObUvGu1O2GNxomlWW2HUZMwTTL7AgjPmuMS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBR6qfb+gJS6W/P61DoU1Pq3omchlrsH392WMuMPPWMiDonp2CwO0lMRZfxuQ/hohzKF2l4bfRieHaAjLV+3qLWAPf7NuZCgNZDtgP225s/L4zk4Or0dS0U96YjSDDcTLEsdoA7FGr/XgL5a99MLf2PQmYN56ssjFPWL5PafF4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ymsJC8gO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ymsJC8gO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XHlxh9OwFWRZcj5plmgjUlSMInNPAO7sqqFFZPPh2mE=; b=ymsJC8gOcK/QlCzX+MadbsuDY1
	OMYGge790ZaWD8IIikH3pPgBfEwWI11KOgAptZIjQp8SGx/9iTj2cohJ8LiZyth8tqr7FzXPmeUMv
	XGBaqTW0O00fx8/n78LR8WODd9L5dI/I+zRxAiyBl1WGK49jqhi1Ut4w/DGwpxWcK3LbNZ6uZAgQ/
	ohuC1mxOdhjMmvzrkkTg35F9TXg/J/usGGmtijOK4MNQJv9hpol/EMKestzdrXF3kWN/TyxQKeE2Y
	HNLkIq6rHevRJC8EJmzIp/EPEpANFN6Sysz3DIABp8svvUpsLHBg+Uzn2qVt5ff5sMFX7nKhnVGP6
	+yhVHD+w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uRTw3-00000006yS2-2Y0P;
	Tue, 17 Jun 2025 10:53:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/7] xfs: remove the bt_bdev_file buftarg field
Date: Tue, 17 Jun 2025 12:52:04 +0200
Message-ID: <20250617105238.3393499-7-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250617105238.3393499-1-hch@lst.de>
References: <20250617105238.3393499-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

And use bt_file for both bdev and shmem backed buftargs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 4 ++--
 fs/xfs/xfs_buf.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index abd66665fb8c..c8f0f8fe433a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1683,7 +1683,7 @@ xfs_free_buftarg(
 	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
 	/* the main block device is closed by kill_block_super */
 	if (btp->bt_bdev != btp->bt_mount->m_super->s_bdev)
-		bdev_fput(btp->bt_bdev_file);
+		bdev_fput(btp->bt_file);
 	kfree(btp);
 }
 
@@ -1792,7 +1792,7 @@ xfs_alloc_buftarg(
 	btp = kzalloc(sizeof(*btp), GFP_KERNEL | __GFP_NOFAIL);
 
 	btp->bt_mount = mp;
-	btp->bt_bdev_file = bdev_file;
+	btp->bt_file = bdev_file;
 	btp->bt_bdev = file_bdev(bdev_file);
 	btp->bt_dev = btp->bt_bdev->bd_dev;
 	btp->bt_daxdev = fs_dax_get_by_bdev(btp->bt_bdev, &btp->bt_dax_part_off,
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 6a96780d841b..adc97351f12a 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -94,7 +94,6 @@ void xfs_buf_cache_destroy(struct xfs_buf_cache *bch);
  */
 struct xfs_buftarg {
 	dev_t			bt_dev;
-	struct file		*bt_bdev_file;
 	struct block_device	*bt_bdev;
 	struct dax_device	*bt_daxdev;
 	struct file		*bt_file;
-- 
2.47.2


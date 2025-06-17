Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88EC2D12EF
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 10:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750157568; cv=none; b=Shkn2RfB93J4OeUgvNnz+SOK5GKHg18BCdb5a7AxHOFPYMtYoxsWdpYotHriVQUWKfZdMUmQzElSEof0lqdel0jD7LJEJ3XxBs83gk7dFriKfB5GH+ziXAZVAp5cS+5A+HL9cbRQdXAhFuUbLsDl9Sc5qNDDTolmJigOHxtU6xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750157568; c=relaxed/simple;
	bh=n4b+wR5lJl7ecZH6KWUg4e6lU3/tGSyRMmj2nzM9ApY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXVm5hTJMcH6P9dlX+m+lzFmj1Hj4gRzaIfNLhyty3P+lWdAVttB/9ReA6LLliAEWlq3gk9f+qM5FOPGlooCRfi4mDyE3G13YlFclPw79JTc+y7A4qHos1NqY/4P/9Nj+h5S788gU+zH5U/3Ca72Nq8ZdhNQfQfl0xi9wvrVR70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e7IwC7nf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e7IwC7nf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4EX8nZfg+XroHCYktPrubkiPrMVBRVaUJFNKHwsVdS4=; b=e7IwC7nfA8WC+Od1anT3f7si5y
	JuetjCgwg4d6BQQUz125XXOGCC3o0zEx/cwM9GfH2yKNPsb38ojr2j8N9tETebFPx9qNTRZMdhxdr
	4WbKHKV+xaJ07u2HSUvyfec3KNTryDYt0q4Hy54CdvPRL/wyNhpmHBWmUNR2sSgYZtq4lt3iR9QCG
	l40bW3wWbfhi8p2RHj3lQiYSGckob7D9NYcvzt5wCRP93nbcq7dweZenJgsvjLg8i4mxBjtskfqIx
	T6j0sHLrZBi8Scbp885O+4XHs9VCtWDSU86JOU1qwNJCQtfriRaWiYXTg4K8S1w1hkOEIsB/h2eki
	OaVzaGuw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uRTvp-00000006yPb-38Hg;
	Tue, 17 Jun 2025 10:52:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/7] xfs: clean up the initial read logic in xfs_readsb
Date: Tue, 17 Jun 2025 12:51:59 +0200
Message-ID: <20250617105238.3393499-2-hch@lst.de>
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

The initial sb read is always for a device logical block size
buffer.  The device logical block size is provided in the
bt_logical_sectorsize in struct buftarg, so use that instead of the
confusingly named xfs_getsize_buftarg buffer that reads it from the bdev.

Update the comments surrounding the code to better describe what is going
on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.h   |  1 -
 fs/xfs/xfs_mount.c | 21 +++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 9d2ab567cf81..294dd9d61dbb 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -376,7 +376,6 @@ extern void xfs_buftarg_wait(struct xfs_buftarg *);
 extern void xfs_buftarg_drain(struct xfs_buftarg *);
 int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize);
 
-#define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 
 int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 29276fe60df9..047100b080aa 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -171,19 +171,16 @@ xfs_readsb(
 	ASSERT(mp->m_ddev_targp != NULL);
 
 	/*
-	 * For the initial read, we must guess at the sector
-	 * size based on the block device.  It's enough to
-	 * get the sb_sectsize out of the superblock and
-	 * then reread with the proper length.
-	 * We don't verify it yet, because it may not be complete.
+	 * In the first pass, use the device sector size to just read enough
+	 * of the superblock to extract the XFS sector size.
+	 *
+	 * The device sector size must be smaller than or equal to the XFS
+	 * sector size and thus we can always read the superblock.  Once we know
+	 * the XFS sector size, re-read it and run the buffer verifier.
 	 */
-	sector_size = xfs_getsize_buftarg(mp->m_ddev_targp);
+	sector_size = mp->m_ddev_targp->bt_logical_sectorsize;
 	buf_ops = NULL;
 
-	/*
-	 * Allocate a (locked) buffer to hold the superblock. This will be kept
-	 * around at all times to optimize access to the superblock.
-	 */
 reread:
 	error = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
 				      BTOBB(sector_size), &bp, buf_ops);
@@ -247,6 +244,10 @@ xfs_readsb(
 	/* no need to be quiet anymore, so reset the buf ops */
 	bp->b_ops = &xfs_sb_buf_ops;
 
+	/*
+	 * Keep a pointer of the sb buffer around instead of caching it in the
+	 * buffer cache because we access it frequently.
+	 */
 	mp->m_sb_bp = bp;
 	xfs_buf_unlock(bp);
 	return 0;
-- 
2.47.2


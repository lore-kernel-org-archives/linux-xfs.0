Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975132192EA
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 10:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750157586; cv=none; b=h2dZ/7yBzzj8fcEq7PO41EjXIIkdugcv4tA3xFIHEMXwr6hXgsp8BtuveNmQU8RblnVTKEinU+Yt2ZvJ2Z98Zs//D0q0Zy9fKfjVZgdtox0+/7Oj2PgI4bd0gQFlkq5bcoWrXzsRxRY7Rd3icfZlXPBdZhP9N4GHy0hVau8zAPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750157586; c=relaxed/simple;
	bh=vmkbMv5KQ2NBw1+XivzG0x8PnZIgPDEQRxOluvAXHOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R30cXBv2yJpReh7K3517oNWfX1w4He6o1l6eJZMU6ZxZP1TZVYoL1eX26N54V6DwBa8kXSg2m906sA8/8xOTnk43Q3pVu0Xuz43dq/SI8v4prESeAfFvaEJVMhc4Sfqc/YkAWi/v+UQwuvj0J+KMhcAFSTs1tItu+OGxC2l2OVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2bPMkAfw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2bPMkAfw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kbKQyzGwnPmTArOAYv7WaX9FFUVKSviP7D1A9ttbt04=; b=2bPMkAfwdpDeWtcar3BBKtFlPf
	aKLL0uJSK+GSf5j9t5Fyw+snC34bgd5MbofGUEKeum691Mhwoo4oKfTyl1EI9mAVsj1Bsge5VHkpg
	2U/otX2RrFACUOqewdvtetfCwNi8wJcv9eD/SnRuNZtCeNy1gKM+sZClHEZ+hdjEU2O9Q6evAf03Q
	G3fBBQuTJkUuho6jGM3A7z5JpTdUh0wUplNEdEUtz43Q04u1WCEnlgk3KBqEmGoZ02N4vwL/rmdVH
	wWrQj+uRReMvue534wx1GD+9jFdYwHhtrdwixxqeT+zVabRzKhsBf5YwwLS/Pqxkg1xmnSYQVaT7j
	9r/mR2yQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uRTw7-00000006ySr-2vva;
	Tue, 17 Jun 2025 10:53:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct buftarg
Date: Tue, 17 Jun 2025 12:52:05 +0200
Message-ID: <20250617105238.3393499-8-hch@lst.de>
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

The file system only has a single file system sector size.  Read that
from the in-core super block to avoid confusion about the two different
"sector sizes" stored in the buftarg.  Note that this loosens the
alignment asserts for memory backed buftargs that set the page size here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c     | 21 +++++----------------
 fs/xfs/xfs_buf.h     | 17 +----------------
 fs/xfs/xfs_buf_mem.c |  2 --
 fs/xfs/xfs_super.c   | 12 +++---------
 4 files changed, 9 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index c8f0f8fe433a..0acac5302c54 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -387,11 +387,12 @@ xfs_buf_map_verify(
 	struct xfs_buftarg	*btp,
 	struct xfs_buf_map	*map)
 {
+	unsigned int		sectsize = btp->bt_mount->m_sb.sb_sectsize;
 	xfs_daddr_t		eofs;
 
 	/* Check for IOs smaller than the sector size / not sector aligned */
-	ASSERT(!(BBTOB(map->bm_len) < btp->bt_meta_sectorsize));
-	ASSERT(!(BBTOB(map->bm_bn) & (xfs_off_t)btp->bt_meta_sectormask));
+	ASSERT(!(BBTOB(map->bm_len) < sectsize));
+	ASSERT(!(BBTOB(map->bm_bn) & (xfs_off_t)(sectsize - 1)));
 
 	/*
 	 * Corrupted block numbers can get through to here, unfortunately, so we
@@ -1719,15 +1720,10 @@ xfs_configure_buftarg_atomic_writes(
 /* Configure a buffer target that abstracts a block device. */
 int
 xfs_configure_buftarg(
-	struct xfs_buftarg	*btp,
-	unsigned int		sectorsize)
+	struct xfs_buftarg	*btp)
 {
 	ASSERT(btp->bt_bdev != NULL);
 
-	/* Set up metadata sector size info */
-	btp->bt_meta_sectorsize = sectorsize;
-	btp->bt_meta_sectormask = sectorsize - 1;
-
 	/*
 	 * Flush the block device pagecache so our bios see anything dirtied
 	 * before mount.
@@ -1806,14 +1802,7 @@ xfs_alloc_buftarg(
 	if (error)
 		goto error_free;
 
-	/*
-	 * When allocating the buftargs we have not yet read the super block and
-	 * thus don't know the file system sector size yet.
-	 */
-	btp->bt_meta_sectorsize = bdev_logical_block_size(btp->bt_bdev);
-	btp->bt_meta_sectormask = btp->bt_meta_sectorsize - 1;
-
-	error = xfs_init_buftarg(btp, btp->bt_meta_sectorsize,
+	error = xfs_init_buftarg(btp, bdev_logical_block_size(btp->bt_bdev),
 				mp->m_super->s_id);
 	if (error)
 		goto error_free;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index adc97351f12a..ec17baed2cbb 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -79,19 +79,6 @@ struct xfs_buf_cache {
 int xfs_buf_cache_init(struct xfs_buf_cache *bch);
 void xfs_buf_cache_destroy(struct xfs_buf_cache *bch);
 
-/*
- * The xfs_buftarg contains 2 notions of "sector size" -
- *
- * 1) The metadata sector size, which is the minimum unit and
- *    alignment of IO which will be performed by metadata operations.
- * 2) The device logical sector size
- *
- * The first is specified at mkfs time, and is stored on-disk in the
- * superblock's sb_sectsize.
- *
- * The latter is derived from the underlying device, and controls direct IO
- * alignment constraints.
- */
 struct xfs_buftarg {
 	dev_t			bt_dev;
 	struct block_device	*bt_bdev;
@@ -99,8 +86,6 @@ struct xfs_buftarg {
 	struct file		*bt_file;
 	u64			bt_dax_part_off;
 	struct xfs_mount	*bt_mount;
-	unsigned int		bt_meta_sectorsize;
-	size_t			bt_meta_sectormask;
 	size_t			bt_logical_sectorsize;
 	size_t			bt_logical_sectormask;
 
@@ -373,7 +358,7 @@ struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *mp,
 extern void xfs_free_buftarg(struct xfs_buftarg *);
 extern void xfs_buftarg_wait(struct xfs_buftarg *);
 extern void xfs_buftarg_drain(struct xfs_buftarg *);
-int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize);
+int xfs_configure_buftarg(struct xfs_buftarg *btp);
 
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index dcbfa274e06d..46f527750d34 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -90,8 +90,6 @@ xmbuf_alloc(
 	btp->bt_dev = (dev_t)-1U;
 	btp->bt_bdev = NULL; /* in-memory buftargs have no bdev */
 	btp->bt_file = file;
-	btp->bt_meta_sectorsize = XMBUF_BLOCKSIZE;
-	btp->bt_meta_sectormask = XMBUF_BLOCKSIZE - 1;
 
 	error = xfs_init_buftarg(btp, XMBUF_BLOCKSIZE, descr);
 	if (error)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bb0a82635a77..9067a6977627 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -541,17 +541,12 @@ xfs_setup_devices(
 {
 	int			error;
 
-	error = xfs_configure_buftarg(mp->m_ddev_targp, mp->m_sb.sb_sectsize);
+	error = xfs_configure_buftarg(mp->m_ddev_targp);
 	if (error)
 		return error;
 
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
-		unsigned int	log_sector_size = BBSIZE;
-
-		if (xfs_has_sector(mp))
-			log_sector_size = mp->m_sb.sb_logsectsize;
-		error = xfs_configure_buftarg(mp->m_logdev_targp,
-					    log_sector_size);
+		error = xfs_configure_buftarg(mp->m_logdev_targp);
 		if (error)
 			return error;
 	}
@@ -564,8 +559,7 @@ xfs_setup_devices(
 		}
 		mp->m_rtdev_targp = mp->m_ddev_targp;
 	} else if (mp->m_rtname) {
-		error = xfs_configure_buftarg(mp->m_rtdev_targp,
-					    mp->m_sb.sb_sectsize);
+		error = xfs_configure_buftarg(mp->m_rtdev_targp);
 		if (error)
 			return error;
 	}
-- 
2.47.2


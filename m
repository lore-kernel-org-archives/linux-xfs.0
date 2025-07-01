Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAB72701A3
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 10:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751366515; cv=none; b=t7LX/W5/sPVGi0evIza/gpeJWVitXtEpnZ3lRKhHmy1cMyhwb4XCPoeGtuensT5XmnFCstiLIevLIqOSBfoBX3Cy4nq+VKbxGuSZRVV3Pg7CtHm8pGnVLNFZx8W/jF/LmnOZNCGoxjVqLWGx8SJyWsFUAGgwP/vDrDGXS4KEjhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751366515; c=relaxed/simple;
	bh=Gc6kE5Nwfnk73qIG2ihRlj5t0ReGxs5+fptD3+ckyqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llXk0vDApuVM3gV9/7aNyB8EROCzfGjpwOIPhSy5US6Ru+TjoX2d5pq7K8d9m7b8BCpPRBFOIH6CWkQTkWRBLAqFbY3V7MJipt6bbxK9vxvwqN5yptzKTU8Hy/wwZtTT0HkZMYrEQL+DLPmz0+tSvl/mpmsBVvFkGMND1M2a3xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SIKSue5j; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SIKSue5j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2E4/eRbkcNbHeTqOxGBK817K7f+kubRp3vak/+DbOkU=; b=SIKSue5jm++iv4UTBh6WD5Afb8
	FgF9dcAszHrkPDtSplmsXIoCZy0WI3eqqfYMIwte4wysvamKyNTHUy9zICTzK1vD1RPl1wev/B3nC
	sdgCkL9A7Ajx4GnHcRJs8KJtrooDqZVGXzj03h6i1O1bK2jvv0ht47gBGAnFI/gE/CkjGmAdunOx5
	kaYQOscdLeIMjpHxgwMtsoz1gzzBpzI1RqVCgiF4yKezfzeloYkfb40d2MtsQgkx05XOzzyO0GNxZ
	QrxqLZ+MCvu+tGs90+ijd0yTrc/a3Hbte7h6hIlOc0PsV7NOiu0uqmD8RqD8tJf0oKzv/AXpYTmZg
	CidfFncA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uWYQz-00000004m2w-1vLZ;
	Tue, 01 Jul 2025 10:41:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct buftarg
Date: Tue,  1 Jul 2025 12:40:41 +0200
Message-ID: <20250701104125.1681798-8-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250701104125.1681798-1-hch@lst.de>
References: <20250701104125.1681798-1-hch@lst.de>
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
 fs/xfs/xfs_buf.c     | 20 +++++---------------
 fs/xfs/xfs_buf.h     | 15 ---------------
 fs/xfs/xfs_buf_mem.c |  2 --
 3 files changed, 5 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b73da43f489c..0f20d9514d0d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -387,17 +387,18 @@ xfs_buf_map_verify(
 	struct xfs_buftarg	*btp,
 	struct xfs_buf_map	*map)
 {
+	struct xfs_mount	*mp = btp->bt_mount;
 	xfs_daddr_t		eofs;
 
 	/* Check for IOs smaller than the sector size / not sector aligned */
-	ASSERT(!(BBTOB(map->bm_len) < btp->bt_meta_sectorsize));
-	ASSERT(!(BBTOB(map->bm_bn) & (xfs_off_t)btp->bt_meta_sectormask));
+	ASSERT(!(BBTOB(map->bm_len) < mp->m_sb.sb_sectsize));
+	ASSERT(!(BBTOB(map->bm_bn) & (xfs_off_t)(mp->m_sb.sb_sectsize - 1)));
 
 	/*
 	 * Corrupted block numbers can get through to here, unfortunately, so we
 	 * have to check that the buffer falls within the filesystem bounds.
 	 */
-	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	if (map->bm_bn < 0 || map->bm_bn >= eofs) {
 		xfs_alert(btp->bt_mount,
 			  "%s: daddr 0x%llx out of range, EOFS 0x%llx",
@@ -1726,10 +1727,6 @@ xfs_configure_buftarg(
 
 	ASSERT(btp->bt_bdev != NULL);
 
-	/* Set up metadata sector size info */
-	btp->bt_meta_sectorsize = sectorsize;
-	btp->bt_meta_sectormask = sectorsize - 1;
-
 	error = bdev_validate_blocksize(btp->bt_bdev, sectorsize);
 	if (error) {
 		xfs_warn(btp->bt_mount,
@@ -1816,14 +1813,7 @@ xfs_alloc_buftarg(
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
index b269e115d9ac..8edfd9ed799e 100644
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
-- 
2.47.2


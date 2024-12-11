Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCC21F2363
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907419; cv=none; b=LtINd3V9hCi3av8w4gSEPlyPe/rIC/GYoO+eaW1cOMn03kuYBRDObxMnz3yfLg2LHIiDQuULyTHnVnXTGvh6vBxmIUaEEH6kQaw1zTKN/Mqzi62jCiqLHHblir5+WQVy3P0iCv2Kx1oeOAGF+w39anHfVFd7ZLeVzkYoQ5mNky8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907419; c=relaxed/simple;
	bh=YsootP0t3EjfG/rewWACC9xRldcRhkN6zWJUgZ67l3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Um2Ps9MD4P5Fqzi0213nUHLI24wqc21oI7ICRxDkjVdNstE7FDJiRb8aGYLJd6WJVhaoOpZx0LRHMQq9CO0u7ljBAT64LeQ7kGIJbqZLkXshw7Pum5l0nMOkDN5IYbkWJj9/LLcFwhEx1PM0MSg0SLd4yTFFkhjFsbw1CNR5gGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pa7/HYUx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pa7/HYUx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0uw6qJ+dv5jt/RC5xMO4U6DJwh5hSraPmumtRV6pr0k=; b=Pa7/HYUxFULvSDIEBdfQw6hBRr
	4P5jBUHnw8gkWUyLm1VmY5DA2MF5bUG0vb5JR52Gl7imAl4/B7yobCDQvQX3zcLjPiXPxmp7c7ut2
	TQMHbwbdLsVbmvZ9hwPbzgs3mOspy9PzBifMGzEStZcMAnoFeUPPuMliSXgUAxfJrRLI0mA5BmtsX
	1lahZ0/Q+/uoFsg/rXBHUMzhtXGHKtKOHByp4lyshBh7skP9Gnew83WBXLOW5JRhaKGjTgDnMK6c5
	yuu0/ZIWOMeTj7f3Dybm3/AnqYDZyq+W7VIQrlrqJc4kC8MiVTkGjSLgBmHAhQLCv26+dBlN9/y0j
	I8BR+BKA==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIWe-0000000EJ3V-3ROi;
	Wed, 11 Dec 2024 08:56:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/43] xfs: cleanup xfs_vn_getattr
Date: Wed, 11 Dec 2024 09:54:32 +0100
Message-ID: <20241211085636.1380516-8-hch@lst.de>
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

Split the two bits of optional statx reporting into their own helpers
so that they are self-contained instead of deeply indented in the main
getattr handler.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c | 47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 207e0dadffc3..6b0228a21617 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -573,17 +573,28 @@ xfs_stat_blksize(
 }
 
 static void
-xfs_get_atomic_write_attr(
+xfs_report_dioalign(
 	struct xfs_inode	*ip,
-	unsigned int		*unit_min,
-	unsigned int		*unit_max)
+	struct kstat		*stat)
 {
-	if (!xfs_inode_can_atomicwrite(ip)) {
-		*unit_min = *unit_max = 0;
-		return;
-	}
+	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
+	struct block_device	*bdev = target->bt_bdev;
 
-	*unit_min = *unit_max = ip->i_mount->m_sb.sb_blocksize;
+	stat->result_mask |= STATX_DIOALIGN;
+	stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
+	stat->dio_offset_align = bdev_logical_block_size(bdev);
+}
+
+static void
+xfs_report_atomic_write(
+	struct xfs_inode	*ip,
+	struct kstat		*stat)
+{
+	unsigned int		unit_min = 0, unit_max = 0;
+
+	if (xfs_inode_can_atomicwrite(ip))
+		unit_min = unit_max = ip->i_mount->m_sb.sb_blocksize;
+	generic_fill_statx_atomic_writes(stat, unit_min, unit_max);
 }
 
 STATIC int
@@ -647,22 +658,10 @@ xfs_vn_getattr(
 		stat->rdev = inode->i_rdev;
 		break;
 	case S_IFREG:
-		if (request_mask & STATX_DIOALIGN) {
-			struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
-			struct block_device	*bdev = target->bt_bdev;
-
-			stat->result_mask |= STATX_DIOALIGN;
-			stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
-			stat->dio_offset_align = bdev_logical_block_size(bdev);
-		}
-		if (request_mask & STATX_WRITE_ATOMIC) {
-			unsigned int	unit_min, unit_max;
-
-			xfs_get_atomic_write_attr(ip, &unit_min,
-					&unit_max);
-			generic_fill_statx_atomic_writes(stat,
-					unit_min, unit_max);
-		}
+		if (request_mask & STATX_DIOALIGN)
+			xfs_report_dioalign(ip, stat);
+		if (request_mask & STATX_WRITE_ATOMIC)
+			xfs_report_atomic_write(ip, stat);
 		fallthrough;
 	default:
 		stat->blksize = xfs_stat_blksize(ip);
-- 
2.45.2


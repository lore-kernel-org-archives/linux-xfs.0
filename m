Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AAC45D5D2;
	Thu, 24 Sep 2026 10:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244119; cv=none; b=tZIM6HK006p+6/hSf4q3OLAAHEOANb6r9+8MPAESVHj4LFnT8lHH/ThwBLEStRmCwIdwGkqVT24WXPtTt9YofmGqReah3usaWnSlcgkOJd6cqd72ZIwaWqpnfalb6G8BvSMcuwLkD4w3/up6rjLvq3y7YBvqbqgjRprIPCexWqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244119; c=relaxed/simple;
	bh=ZQOEdtW6sf+tqG5rChWLSKCBh7BzbBSCDZSY433Pruk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFxvjfkPvx6oEmrbXsDJZLqY3XPinkToOd5zFESISlIjEVOzJOTzH/S3qQMPVCpMg4d4HW4V8zdqaIaiCDiA1m4atfMEbXTW0ranvNeTbjsngvlsPkvb+emLNF64jjXoz1N9mW5UHbDEBjsnSIRm8uL/G8wFohwA1IPXWrqQyEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lEPcoNqF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lEPcoNqF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mAMx3KjXBe83TyaYyW2qKAd4ZXrrw4qWbzmzPqlneAQ=; b=lEPcoNqFHuG07LU08iDvrySB67
	HooABkm2XSms/jx4iPcFsCFihOsHxYA48pdA0to6NBM5l6vDuw9Mq8ZsHGs9vcqukxdgo75Z/sAgG
	3YFnOO+R0yVyBSQGLidAHLRnddTIaIy8laGH3DWvDl2OK2l5e/YqzWLaeSESe2UfBSeUcbcGsK0HT
	zmuD92a7Of8Vun2Gz3NW0/zYew0QeqhX380McXeLSRCi7z1PeEPVQyAkgRXkDTHRHGHQxsJDX4Ax+
	iTpKICyrSzNYlIcWjheMUGsWOT5wpn4EmOQsx/lPqgaTR3o2ajcOE/FJbvV3s37Xi6hrmcL76b8Wf
	i7uKcejg==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gH0-0000000AecV-0L9G;
	Thu, 24 Sep 2026 10:01:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 13/21] xfs: require file system block size alignment when using data checksums
Date: Thu, 24 Sep 2026 11:59:45 +0200
Message-ID: <20260924100032.2733101-14-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The checksums cover a whole block, so we can't read or update parts of a
block.  Report the requirement and enforce it for direct I/O reads.
Direct I/O writes already require file system block size alignment when
using the zoned allocator, and buffered I/O never does sub-block I/O.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  | 14 +++++++++++++-
 fs/xfs/xfs_ioend.c | 13 +++++++++++--
 fs/xfs/xfs_iops.c  | 10 +++++++++-
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6f25879b6510..5b25f33527c0 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -29,6 +29,7 @@
 #include "xfs_zone_alloc.h"
 #include "xfs_error.h"
 #include "xfs_errortag.h"
+#include "xfs_rtcsum.h"
 
 #include <linux/dax.h>
 #include <linux/falloc.h>
@@ -270,9 +271,20 @@ xfs_file_dio_read(
 	if (ret)
 		return ret;
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
+		unsigned int		dio_flags = 0;
+
+		/*
+		 * Each checksums covers a whole file system block, and thus
+		 * sub-fsblock reads are not supported for file systems using
+		 * data checksums.
+		 */
+		if (xfs_is_rtcsum_inode(ip))
+			dio_flags |= IOMAP_DIO_FSBLOCK_ALIGNED;
 		ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops,
-				&xfs_dio_read_bounce_ops, 0, NULL, 0);
+				&xfs_dio_read_bounce_ops, dio_flags, NULL, 0);
 	} else {
+		ASSERT(!xfs_is_rtcsum_inode(ip));
+
 		ret = iomap_dio_read_simple(iocb, to, xfs_read_iomap_begin);
 		if (ret == -ENOTBLK)
 			ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL,
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index f0e01ac34de8..54bd0995ac29 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -44,6 +44,15 @@ xfs_bounce_submit_ioend(
 	submit_bio(&ioend->io_bio);
 }
 
+static unsigned int
+xfs_read_bounce_minsize(
+	struct iomap_ioend	*ioend)
+{
+	if (xfs_is_rtcsum_inode(XFS_I(ioend->io_inode)))
+		return i_blocksize(ioend->io_inode);
+	return bdev_logical_block_size(ioend->io_bio.bi_bdev);
+}
+
 static void
 xfs_end_bio_bounced(
 	struct bio		*bio)
@@ -86,7 +95,7 @@ xfs_read_bounce_and_resubmit(
 		.bi_offset	= ioend->io_bvec_offset,
 	};
 	bio->bi_end_io = xfs_end_bio_bounced;
-	iomap_bounce_read(ioend, bdev_logical_block_size(bio->bi_bdev),
+	iomap_bounce_read(ioend, xfs_read_bounce_minsize(ioend),
 			xfs_bounce_submit_ioend);
 	memalloc_nofs_restore(nofs_flag);
 }
@@ -134,7 +143,7 @@ xfs_ioend_submit_read(
 	ioend = iomap_init_ioend(inode, bio, file_offset, ioend_flags);
 	if ((ioend_flags & IOMAP_IOEND_DIRECT) &&
 	    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_ALWAYS) {
-		iomap_bounce_read(ioend, bdev_logical_block_size(bio->bi_bdev),
+		iomap_bounce_read(ioend, xfs_read_bounce_minsize(ioend),
 				xfs_bounce_submit_ioend);
 		return;
 	}
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d1306e723899..a5f01e2e3a67 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -581,6 +581,15 @@ xfs_report_dioalign(
 	stat->result_mask |= STATX_DIOALIGN | STATX_DIO_READ_ALIGN;
 	stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
 
+	/*
+	 * Each checksums covers a whole file system block, and thus sub-fsblock
+	 * reads are not supported for file systems using data checksums.
+	 */
+	if (xfs_is_rtcsum_inode(ip))
+		stat->dio_read_offset_align = xfs_inode_alloc_unitsize(ip);
+	else
+		stat->dio_read_offset_align = bdev_logical_block_size(bdev);
+
 	/*
 	 * For COW inodes, we can only perform out of place writes of entire
 	 * allocation units (blocks or RT extents).
@@ -591,7 +600,6 @@ xfs_report_dioalign(
 	 * alignment in dio_offset_align, and the smaller read alignment in
 	 * dio_read_offset_align.
 	 */
-	stat->dio_read_offset_align = bdev_logical_block_size(bdev);
 	if (xfs_is_cow_inode(ip))
 		stat->dio_offset_align = xfs_inode_alloc_unitsize(ip);
 	else
-- 
2.53.0


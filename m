Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782817;
	b=RmV4jqIpDc96M8aOY5pPsvsON66Rz72gGo4yB1VPVw4pINobyApvUWoP+8UJOk1mbXMI
	 w5h4AKG2lol3Y95T9JmaEDdjeaGj+WL58heYM6gmKSTjsbtBWbkHmGygyG9z6Y+HlXWUQ
	 gjxv1KfjYLqZGjARv5De3Yrbd+470jAoR6V18i6spQ12OOAJcZauMqm84nA9sCxs5v4Ie
	 BgHwU00Smn8NNW5A/5CMFFkHIxmk1ZdVUKh4NR60+Cjxhei2z5jNhUGSTL3Il7DF5w0uY
	 YZzyWWBKGaCcfHBSk5txBDzlNByI+2cmIMqO01thanUQgDwgerX2Y80pRlt6eV6L/kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782817;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=r41Es3AS9DaPE3yG17RR/Ag08Tot2aPltRjv3l3wgW8=;
	b=U6YwbFVWpAwo7ykCzzrgtOU5xa+0AoWPLJWwo/ECViFYsR2omLr/qUB+9af5Ag1BKl8w
	 pLLMelGOapR6oT7VMjAOgGVZLLz7040J/a3uKCKAxUFM+YcSSlKbecDKiEk672iNwZgad
	 5+EatCDUJn3ZDKE+B7vBxeBQx7GKMe/cLOuwtPnsIQ8aMcl92+/ayF9KmMIo4pRhoWw7d
	 01jhu65fDWXtA/2BAiXVFV/Gz55kcu0ex5eRqKFn/pT0vxmhuuRtPK7aUVWOOUkS+e6Nu
	 MYLi5kpHSA+JWUpWIlRQkwJkw8pl66Jz4dHxSzOPSMEaFH170nj59sMPzl5qT+nRiHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Y7CknrHL;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC53D606A326;
	Wed,  4 Nov 2026 09:00:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC53D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Y7CknrHL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=r41Es3AS9DaPE3yG17RR/Ag08Tot2aPltRjv3l3wgW8=; b=Y7CknrHLmvX50qd6PW/Ja7a1vS
	pd+xlzESjddCvoH1DNkeFCE6B92wIpJsnIV3HVhut6WzyJVip5Wt/nmeV+KmiO7PWfGtzc8aUR+mb
	nIhPvZ8dt/x/LowSqb0l0JJE1zOHQCA0sHIV0oZvdJBXDoBlb3aw270iApv55Rl94G+hg0xxnOsr4
	eO3JZYWr/Z3dPoa3JAMua4U2f2pCKN8kCzgsQgwnNj/MufUFIF8cowPAQVNxHR66/qyJUAv4K7vWF
	X52Yr/FVoj3jAPaRLmrp+wTgLJY1I8aU1+thJ4KHrxspvW9CnW7rxRt8aW5+K40ee4LGGn8VgG2jP
	Q9y2SrkQ==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqt-00000004oRB-1bsJ;
	Wed, 04 Nov 2026 09:00:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 15/25] xfs: require file system block size alignment when using data checksums
Date: Wed,  4 Nov 2026 09:57:19 +0100
Message-ID: <20261104085929.317544-16-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104085929.317544-1-hch@lst.de>
References: <20261104085929.317544-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
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
 fs/xfs/xfs_inode.h | 14 ++++++++++++++
 fs/xfs/xfs_ioend.c |  4 ++--
 fs/xfs/xfs_iops.c  |  8 +++++++-
 4 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 396aca8c66a9..97b0a976058a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -29,6 +29,7 @@
 #include "xfs_zone_alloc.h"
 #include "xfs_error.h"
 #include "xfs_errortag.h"
+#include "xfs_rtcsum.h"
 
 #include <linux/dax.h>
 #include <linux/falloc.h>
@@ -208,9 +209,20 @@ xfs_file_dio_read(
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
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 169208e1c7da..7b75483bb43d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -390,6 +390,20 @@ static inline bool xfs_is_rtcsum_inode(const struct xfs_inode *ip)
 	return xfs_has_rtcsum(ip->i_mount) && XFS_IS_REALTIME_INODE(ip);
 }
 
+/*
+ * Each checksums covers a whole file system block, and thus sub-fsblock
+ * reads are not supported for file systems using data checksums.
+ */
+static inline unsigned int
+xfs_min_diosize(
+	struct xfs_inode	*ip,
+	struct block_device	*bdev)
+{
+	if (xfs_is_rtcsum_inode(ip))
+		return i_blocksize(VFS_I(ip));
+	return bdev_logical_block_size(bdev);
+}
+
 /*
  * In-core inode flags.
  */
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index 7f4a4a95afe5..05ab91dd4343 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -86,7 +86,7 @@ xfs_read_bounce_and_resubmit(
 		.bi_offset	= ioend->io_bvec_offset,
 	};
 	bio->bi_end_io = xfs_end_bio_bounced;
-	iomap_bounce_read(ioend, bdev_logical_block_size(bio->bi_bdev),
+	iomap_bounce_read(ioend, xfs_min_diosize(ip, bio->bi_bdev),
 			xfs_bounce_submit_ioend);
 	memalloc_nofs_restore(nofs_flag);
 }
@@ -134,7 +134,7 @@ xfs_ioend_submit_read(
 	ioend = iomap_init_ioend(inode, bio, file_offset, ioend_flags);
 	if ((ioend_flags & IOMAP_IOEND_DIRECT) &&
 	    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_ALWAYS) {
-		iomap_bounce_read(ioend, bdev_logical_block_size(bio->bi_bdev),
+		iomap_bounce_read(ioend, xfs_min_diosize(ip, bio->bi_bdev),
 				xfs_bounce_submit_ioend);
 		return;
 	}
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d307ec97fac8..11952caad5e6 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -581,6 +581,13 @@ xfs_report_dioalign(
 	stat->result_mask |= STATX_DIOALIGN | STATX_DIO_READ_ALIGN;
 	stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
 
+	/*
+	 * The minimum read size is generally the sector size of the underlying
+	 * device, but when using checksums that whole FSB is needed to verify
+	 * the checksum.
+	 */
+	stat->dio_read_offset_align = xfs_min_diosize(ip, bdev);
+
 	/*
 	 * For COW inodes, we can only perform out of place writes of entire
 	 * allocation units (blocks or RT extents).
@@ -591,7 +598,6 @@ xfs_report_dioalign(
 	 * alignment in dio_offset_align, and the smaller read alignment in
 	 * dio_read_offset_align.
 	 */
-	stat->dio_read_offset_align = bdev_logical_block_size(bdev);
 	if (xfs_is_cow_inode(ip))
 		stat->dio_offset_align = xfs_inode_alloc_unitsize(ip);
 	else
-- 
2.53.0


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DDB446BFA;
	Thu, 24 Sep 2026 10:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244131; cv=none; b=DAWws3aVRUfixNF6E/qoJp99zTW72CUwoTQyohZJrk8BuH2Gs6wQ7/vTDQrpQZ+3CmnJjk245pxa+zdmEXl+20PtiFXtsRMmVV5KvzhB4PPOND+1OftK70sJ8fO6AICUcMUsivCcBUlB0or59r4kXwGyMVqy6z9v2lnZ2kenhtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244131; c=relaxed/simple;
	bh=QcmtjpALx9cT8XgDAM+vk5ZpKfgPeeOtOf4BFy68FyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgqjuiB4RA0EhJFOgjNvkD0B+0NN8f043gHlqTnMslcXA2twsUYVFjv6MUpysq+UFUdZeasMxR0hrarlCmEI/wH2riQBTiMzhlDcCblfW00GAi04Bf/VJABSQ8hJPAY6XCZQGoBXBEzZkfNFWoX0H0Egzk2bjnFD8yhyFoNxQLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j344hhIN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j344hhIN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=q+HUvMdov/cF5QuF/MfIz8oK+ITqeZzn/IrCNw+NIPE=; b=j344hhINE3v3Vquf/Rq5Zc3qA6
	JUmcFVD7Lunh9rS4ws7NhpNIQtRFodles63Wxkzmyi3B+AIl9sASYgeW8rdV/XLzIwPWPfo6vn7Lo
	NPyYv7z0jEWv4ZHt+FLWWNg1p1Acm5BQT2qpzZSDfVOylwW78cFNjMw0ds7bcJnsMPnfWpayd6/+k
	Ey8t05FoJJ8Hm6HgjcKd1E0eBNIVaH+CdyHA0O825P34knrsH7dGNUfEk4D5s40FtthaduE893JOw
	1i4CT8bfBc93O9tjSqI83gTYeMH/zmt5P2v1xp1/lHfGtNv/iYybnwyKsTzuTiz+lc4p163FoEpcD
	fsD8pxdA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gH5-0000000AedZ-13je;
	Thu, 24 Sep 2026 10:01:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 14/21] xfs: add support for reading with data checksums
Date: Thu, 24 Sep 2026 11:59:46 +0200
Message-ID: <20260924100032.2733101-15-hch@lst.de>
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

All reads from files with data checksums have the returned iomaps for
data blocks limited to be inside a single RT csum file block, so that
each data read only needs to deal with a single checksum buffer.

All reads on checksummed files need to use ioends so that the checksum
can be verified from process context.  The ioend submission path looks
up the checksum buffer and kicks of an asynchronous read of it.  The
completion path waits for the buffer if needed and verifies the checksum.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  |   4 +-
 fs/xfs/xfs_ioend.c | 108 +++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_iomap.c |  23 ++++++++--
 3 files changed, 114 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index c30e688cfc9f..931795316de4 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -599,9 +599,7 @@ static inline const struct iomap_read_ops *
 xfs_get_iomap_read_ops(
 	const struct address_space	*mapping)
 {
-	struct xfs_inode		*ip = XFS_I(mapping->host);
-
-	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
+	if (mapping_stable_writes(mapping))
 		return &xfs_iomap_read_ops;
 	return &iomap_bio_read_ops;
 }
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index 54bd0995ac29..7570a1b915c0 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -14,12 +14,72 @@
 #include "xfs_trace.h"
 #include "xfs_bmap_util.h"
 #include "xfs_reflink.h"
+#include "xfs_rtcsum.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_ioend.h"
 #include "xfs_error.h"
 #include "xfs_errortag.h"
 #include <linux/bio-integrity.h>
 
+static bool
+xfs_rtcsum_prepare_read(
+	struct iomap_ioend	*ioend)
+{
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buf		*bp;
+	int			error;
+
+	error = -EIO;
+	if (WARN_ON_ONCE(ioend->io_bio.bi_iter.bi_idx))
+		goto fail;
+
+	error = xfs_rtcsum_read_async(mp,
+			xfs_daddr_to_rtb(mp, ioend->io_sector), &bp);
+	if (error)
+		goto fail;
+	ioend->io_private = bp;
+	return true;
+
+fail:
+	ioend->io_bio.bi_status = errno_to_blk_status(error);
+	bio_endio(&ioend->io_bio);
+	return false;
+}
+
+static int
+xfs_rtcsum_verify_ioend(
+	struct iomap_ioend	*ioend,
+	int			error)
+{
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_rtblock_t		bno = xfs_daddr_to_rtb(mp, ioend->io_sector);
+	unsigned int		bsize = mp->m_sb.sb_blocksize;
+	struct xfs_buf		*bp = ioend->io_private;
+	struct bvec_iter	iter = {
+		.bi_size	= roundup(ioend->io_size, bsize),
+		.bi_offset	= ioend->io_bvec_offset,
+	};
+
+	/* No bp for early xfs_rtcsum_prepare_read failures. */
+	if (!bp)
+		return error;
+
+	if (error)
+		goto out_rele;
+	error = xfs_buf_read_async_wait(bp);
+	if (error)
+		goto out_rele;
+
+	error = xfs_csum_verify(mp, &ioend->io_bio, &iter,
+				bp->b_addr + xfs_rtb_to_rtcsumoff(mp, bno), bno,
+				true);
+out_rele:
+	xfs_buf_rele(bp);
+	return error;
+}
+
 static void
 xfs_dio_bounce_end_io(
 	struct bio		*bio)
@@ -30,6 +90,9 @@ xfs_dio_bounce_end_io(
 
 	if ((ioend->io_flags & IOMAP_IOEND_INTEGRITY) && !bio->bi_status)
 		error = iomap_ioend_integrity_verify(ioend);
+	if (xfs_is_rtcsum_inode(XFS_I(ioend->io_inode)))
+		error = xfs_rtcsum_verify_ioend(ioend, error);
+
 	iomap_bounce_read_end_io(ioend, orig_bio, error);
 }
 
@@ -39,6 +102,9 @@ xfs_bounce_submit_ioend(
 {
 	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
 		fs_bio_integrity_alloc(&ioend->io_bio);
+	if (xfs_is_rtcsum_inode(XFS_I(ioend->io_inode)) &&
+	    !xfs_rtcsum_prepare_read(ioend))
+		return;
 	ioend->io_bio.bi_end_io = xfs_dio_bounce_end_io;
 	bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
 	submit_bio(&ioend->io_bio);
@@ -108,25 +174,36 @@ xfs_end_io_read(
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error = blk_status_to_errno(bio->bi_status);
+	bool			is_csum_error = false;
 
 	if (!error && (ioend->io_flags & IOMAP_IOEND_INTEGRITY)) {
 		error = iomap_ioend_integrity_verify(ioend);
-		if ((ioend->io_flags & IOMAP_IOEND_DIRECT) &&
-		    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_LAZY) {
-			/*
-			 * We only really need to retry for guard tag errors,
-			 * but right now we can't distinguish them from other
-			 * (i.e, reftag) errors.
-			 */
-			if (error ||
-			    XFS_TEST_ERROR(mp, XFS_ERRTAG_BOUNCE_REREAD)) {
-				xfs_read_bounce_and_resubmit(ioend);
-				return;
-			}
-		}
+		/*
+		 * We only really need to retry for guard tag errors, but right
+		 * now we can't distinguish them from other (i.e, reftag) errors.
+		 */
+		if (error)
+			is_csum_error = true;
 	}
 
-	iomap_finish_ioends(ioend, error);
+	if (xfs_is_rtcsum_inode(ip)) {
+		error = xfs_rtcsum_verify_ioend(ioend, error);
+		if (error && !bio->bi_status)
+			is_csum_error = true;
+	}
+
+	/*
+	 * If we saw a checksum failure on a direct I/O read that uses lazy
+	 * bouncing, resubmit the read using a bounce buffer so that we can
+	 * guarantee this was not caused by the user corrupting the buffer.
+	 */
+	if ((ioend->io_flags & IOMAP_IOEND_DIRECT) &&
+	    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_LAZY &&
+	    (is_csum_error ||
+	     (!error && XFS_TEST_ERROR(mp, XFS_ERRTAG_BOUNCE_REREAD))))
+		xfs_read_bounce_and_resubmit(ioend);
+	else
+		iomap_finish_ioends(ioend, error);
 }
 
 void
@@ -148,6 +225,9 @@ xfs_ioend_submit_read(
 		return;
 	}
 
+	if (xfs_is_rtcsum_inode(ip) && !xfs_rtcsum_prepare_read(ioend))
+		return;
+
 	if (ioend_flags & IOMAP_IOEND_INTEGRITY)
 		fs_bio_integrity_alloc(bio);
 	bio->bi_end_io = xfs_end_io_read;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 6701be9325ef..0e4396e52809 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -32,6 +32,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_icache.h"
 #include "xfs_zone_alloc.h"
+#include "xfs_rtcsum.h"
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -166,6 +167,8 @@ xfs_bmbt_to_iomap(
 	}
 
 	iomap->validity_cookie = sequence_cookie;
+	if (xfs_is_rtcsum_inode(ip))
+		iomap->csum_shift = mp->m_rtcsum_shift;
 	return 0;
 }
 
@@ -2227,16 +2230,28 @@ xfs_read_iomap_begin(
 		return error;
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
 			       &nimaps, 0);
-	if (!error && ((flags & IOMAP_REPORT) || IS_DAX(inode)))
+	if (error)
+		goto out_unlock;
+
+	if ((flags & IOMAP_REPORT) || IS_DAX(inode)) {
 		error = xfs_reflink_trim_around_shared(ip, &imap, &shared);
+		if (error)
+			goto out_unlock;
+	} else if (!isnullstartblock(imap.br_startblock) &&
+		   xfs_is_rtcsum_inode(ip)) {
+		imap.br_blockcount = min(imap.br_blockcount,
+				xfs_rtcsum_max_len(mp, imap.br_startblock));
+	}
+
 	seq = xfs_iomap_inode_sequence(ip, shared ? IOMAP_F_SHARED : 0);
 	xfs_iunlock(ip, lockmode);
-
-	if (error)
-		return error;
 	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
 				 shared ? IOMAP_F_SHARED : 0, seq);
+
+out_unlock:
+	xfs_iunlock(ip, lockmode);
+	return error;
 }
 
 static DEFINE_IOMAP_ITER_NEXT(xfs_read_iomap_next, xfs_read_iomap_begin);
-- 
2.53.0


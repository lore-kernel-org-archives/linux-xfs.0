Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782820;
	b=jbMC1I8orkSao98z/atcU65sklAXNhFfZvTmhPKpXt6viMG/H1bu17ylLsKVECvxAHgP
	 vtL39540vp5W06ImRp44/+BdFTypWyexD7duZJSihxlUYK7n4+ag9ZU/+B59UvBMbe+xz
	 hx0+9B/HdpplURy2RoimXCW57zc9B2FItNXbc5iHN7+m1y6/nfeuOiN7UO8/9duD3ekgi
	 NIR3kclr05YWWwuF9A54eGgGpOLS4xnKxMQ5KQKH6Udbk8Wa/k8JDX9xfp4caCCl+a3ab
	 ERQRwAoO/od3VvgmXS6jTYhFzUJ64iAd/sjpY6wk/pDsdsX5mg12dKV5N7tfpO+liVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782820;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=c2GhWXdUsaD3nnOfzBYPKnqQvrgmfabGioFuSp/asbo=;
	b=H26bfsHMCqYpd/WYXC4jJ4obKJBIPMDh3KNflrtB7Kug5ukraMYBuzuU40If9pF3/qIi
	 kAb9zOOYq4z0YDoDFMGiNcc0/PGOjmjLv01FBf0xChHkUUbfJbNNbTXQ9GnegviwPR2Nb
	 JxoMKhXipdNp1aSP5mI0ukwsmXMqcEkP2tb+GXfJPzpHepwxAbdPZico6YE6G8b9wFLMR
	 ZbXZRXW1jNW7Fm9gdsd2juGOmA5XTKDlWyf1HohUIc8C5MIH/8TTSJe1BjVRykCjWVukb
	 Bl0EceXvlBTyCnmODwqX2Md178WTBZI+zAaz4Bh1ck++OV8M7ZXzUV88J2ngU10msDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Z7PRGTXd;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABA9606A329;
	Wed,  4 Nov 2026 09:00:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AABA9606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Z7PRGTXd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=c2GhWXdUsaD3nnOfzBYPKnqQvrgmfabGioFuSp/asbo=; b=Z7PRGTXdsFvONurlD4IjjzlPcb
	t1scWfn6al2d0R3TIXbV6Z+JINcsgxYT2JjgcMg7y3yYvA6sJObi5NO3JnqEY5axCLXEYX9FxckrO
	h9NIlFDiD+565UqDf2pN8KvVRDopXxvLyr+EgTP66Zx8r+iTC1zMNTQiK7TPll5ZszYb73JJ0h2Bc
	chTUNfo09S8zLSY4x1YOa0+bUadCbXPj/MwdcRDzR0uLaVA8ptJ0bWpOvISuN4EYDNjIk3yzJlOk/
	+x9ozfuTj1KVkFBayEElPmlu5VzrfPxn27ETnyuKA8DvqcwTHAweadU1J6huS0T+gp8oJamLgCBYj
	7WcH0H6w==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqw-00000004oSm-3oMM;
	Wed, 04 Nov 2026 09:00:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 16/25] xfs: add support for reading with data checksums
Date: Wed,  4 Nov 2026 09:57:20 +0100
Message-ID: <20261104085929.317544-17-hch@lst.de>
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

All reads from files with data checksums have the returned iomaps for
data blocks limited to be inside a single RT csum file block, so that
each data read only needs to deal with a single checksum buffer.

All reads on checksummed files need to use ioends so that the checksum
can be verified from process context.  The ioend submission path looks
up the checksum buffer and kicks of an asynchronous read of it.  The
completion path waits for the buffer if needed and verifies the checksum.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  |   3 +-
 fs/xfs/xfs_ioend.c | 120 +++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_iomap.c |  23 +++++++--
 3 files changed, 126 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index c30e688cfc9f..db834e5e60c1 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -601,7 +601,8 @@ xfs_get_iomap_read_ops(
 {
 	struct xfs_inode		*ip = XFS_I(mapping->host);
 
-	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
+	if (xfs_has_rtcsum(ip->i_mount) ||
+	    bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
 		return &xfs_iomap_read_ops;
 	return &iomap_bio_read_ops;
 }
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index 05ab91dd4343..1066f262ba98 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -14,12 +14,80 @@
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
+	/*
+	 * The main I/O end bio is either freshly build by iomap, and has both
+	 * bi_idx and bi_offset set to zero, or comes from a bvec iter for
+	 * direct I/O, in which case bi_offset can be non-zero, but bi_idx still
+	 * must be zero as the bio always points to the first actually used
+	 * bio_vec in the iov_iter.
+	 */
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
+	/* Early xfs_rtcsum_prepare_read failures do not have a bp yet. */
+	if (!bp) {
+		ASSERT(error);
+		return error;
+	}
+
+	if (error)
+		goto out_rele;
+	error = xfs_buf_read_async_wait(bp);
+	if (error)
+		goto out_rele;
+
+	error = xfs_csum_verify(mp, &ioend->io_bio, &iter,
+			bp->b_addr + xfs_rtb_to_rtcsumoff(mp, bno), bno, true);
+out_rele:
+	xfs_buf_rele(bp);
+	return error;
+}
+
 static void
 xfs_dio_bounce_end_io(
 	struct bio		*bio)
@@ -30,6 +98,9 @@ xfs_dio_bounce_end_io(
 
 	if ((ioend->io_flags & IOMAP_IOEND_INTEGRITY) && !bio->bi_status)
 		error = iomap_ioend_integrity_verify(ioend);
+	if (xfs_is_rtcsum_inode(XFS_I(ioend->io_inode)))
+		error = xfs_rtcsum_verify_ioend(ioend, error);
+
 	iomap_bounce_read_end_io(ioend, orig_bio, error);
 }
 
@@ -39,7 +110,12 @@ xfs_bounce_submit_ioend(
 {
 	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
 		fs_bio_integrity_alloc(&ioend->io_bio);
+
 	ioend->io_bio.bi_end_io = xfs_dio_bounce_end_io;
+	if (xfs_is_rtcsum_inode(XFS_I(ioend->io_inode)) &&
+	    !xfs_rtcsum_prepare_read(ioend))
+		return;
+
 	bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
 	submit_bio(&ioend->io_bio);
 }
@@ -99,25 +175,36 @@ xfs_end_io_read(
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
@@ -139,9 +226,12 @@ xfs_ioend_submit_read(
 		return;
 	}
 
+	bio->bi_end_io = xfs_end_io_read;
+	if (xfs_is_rtcsum_inode(ip) && !xfs_rtcsum_prepare_read(ioend))
+		return;
+
 	if (ioend_flags & IOMAP_IOEND_INTEGRITY)
 		fs_bio_integrity_alloc(bio);
-	bio->bi_end_io = xfs_end_io_read;
 	bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
 	submit_bio(bio);
 }
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c3465204b8d5..80b7c9df7c14 100644
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
 
@@ -2249,16 +2252,28 @@ xfs_read_iomap_begin(
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


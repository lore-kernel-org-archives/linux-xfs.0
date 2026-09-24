Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694054483BF
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 09:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790243899; cv=none; b=kkahkxWHWNf7WcagK5QRoGp/Oun1AhyYw999Qd8K1uA//ZQ4dAKegihhGea+aYkMNlyGoHyaoCUgCpanR19iV3u7JsEZO6TOEsB1UvM8JlcX3dSCsPFKbZs411kOqe8RxaV0JTNyjpb6ih6y+6qFK3RwlS6obV0LgkS4xvAsphI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790243899; c=relaxed/simple;
	bh=wIvJznwWdG0Vda8pnW/3MKV1JwYJ9eEfimjXNyPvh5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5Ly8Bndrcx82K+SwfTHyf/kevLIBG6x+UBBxFua1Y+YtULHGO0PLKAQo0BMj8i3W/VZPHtUVgWmysUdxFRPocVj2KW9gt6X88D9SRiPttcMq23SxxSAYKGPgWaOyJgsEYPEvONPB/3CcpQH7XECkyNhcC6lapZ7vErif5Sl19U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fXIT3CUF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fXIT3CUF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RxXDizziAascK0xvo0WO2laNq2Cu6D9VDMYZJtOk0xA=; b=fXIT3CUFFEDIes9AcZnRCPGQ8Z
	VeK3/XYn7Ihr3PpMrBbNghMNCIf47oTZnAyhDPj6BSIvEaKd1D+7KmQKRGMKTuqSG7W4UrjpCwuMO
	iBzvyK/EtJqO65yFydpQrJVu/Ao0Why/5I2MfHTN4BM8/QpRptZcRaZDnoBedlwcW0AaZPKseB8IR
	/JaMM6EwKuh5VVYfQK2dVq9V405TrjUh8TuNFvBwll157oFp3GL3zSp3NKT8c2/F0x+IX2ZTbRkse
	03MCkw4h5dn50myR5X8io+wT5g0bZR+j+G9DrmWFMoEmuYYwwApTOWgwtmaqSO3DWXprnV0LFvUh/
	jxGh8MwA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gDH-0000000AeNB-46hs;
	Thu, 24 Sep 2026 09:58:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/9] xfs: use bdev_rw_virt in xfs_verify_media
Date: Thu, 24 Sep 2026 11:57:06 +0200
Message-ID: <20260924095740.2732474-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924095740.2732474-1-hch@lst.de>
References: <20260924095740.2732474-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use bdev_rw_virt for reading data from disk.  This simply uses an
on-stack bio and bio_vec and removes the need to allocate an bio and
reset it for each iteration.  Because bdev_rw_virt returns a negative
errno, pass that on to xfs_verify_media_error to avoid a double
conversion.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_verify_media.c | 41 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
index 8ce3773aa875..71f4d6c832a9 100644
--- a/fs/xfs/xfs_verify_media.c
+++ b/fs/xfs/xfs_verify_media.c
@@ -229,8 +229,10 @@ xfs_verify_media_error(
 	struct xfs_buftarg	*btp,
 	xfs_daddr_t		daddr,
 	unsigned int		bio_bbcount,
-	blk_status_t		bio_status)
+	int			error)
 {
+	blk_status_t		bio_status = errno_to_blk_status(error);
+
 	trace_xfs_verify_media_error(mp, me, btp->bt_dev, daddr, bio_bbcount,
 			bio_status);
 
@@ -239,7 +241,7 @@ xfs_verify_media_error(
 	 * successfully verify any bytes at all.
 	 */
 	if (me->me_start_daddr == daddr)
-		me->me_ioerror = -blk_status_to_errno(bio_status);
+		me->me_ioerror = -error;
 
 	/*
 	 * PI validation failures, medium errors, or general IO errors are
@@ -266,7 +268,6 @@ xfs_verify_media(
 	struct xfs_verify_media	*me)
 {
 	struct xfs_buftarg	*btp = NULL;
-	struct bio		*bio;
 	struct folio		*folio;
 	xfs_daddr_t		daddr;
 	uint64_t		bbcount;
@@ -332,33 +333,16 @@ xfs_verify_media(
 
 	trace_xfs_verify_media(mp, me, btp->bt_dev, daddr, bbcount, folio);
 
-	bio = bio_alloc(btp->bt_bdev, 1, REQ_OP_READ, GFP_KERNEL);
-	if (!bio) {
-		error = -ENOMEM;
-		goto out_folio;
-	}
-
-	while (bbcount > 0) {
+	for (;;) {
 		unsigned int	bio_bbcount;
-		blk_status_t	bio_status;
-
-		bio_reset(bio, btp->bt_bdev, REQ_OP_READ);
-		bio->bi_iter.bi_sector = daddr;
-		bio_add_folio_nofail(bio, folio,
-				min(bbcount << SECTOR_SHIFT, folio_size(folio)),
-				0);
 
-		/*
-		 * Save the length of the bio before we submit it, because we
-		 * need the original daddr and length for reporting IO errors
-		 * if the bio fails.
-		 */
-		bio_bbcount = bio->bi_iter.bi_size >> SECTOR_SHIFT;
-		submit_bio_wait(bio);
-		bio_status = bio->bi_status;
-		if (bio_status != BLK_STS_OK) {
+		bio_bbcount = min(bbcount, folio_size(folio) >> SECTOR_SHIFT);
+		error = bdev_rw_virt(btp->bt_bdev, daddr, folio_address(folio),
+				bio_bbcount << SECTOR_SHIFT,
+				REQ_OP_READ);
+		if (error) {
 			xfs_verify_media_error(mp, me, btp, daddr, bio_bbcount,
-					bio_status);
+					error);
 			error = 0;
 			break;
 		}
@@ -386,10 +370,7 @@ xfs_verify_media(
 		cond_resched();
 	}
 
-	bio_put(bio);
-out_folio:
 	folio_put(folio);
-
 	if (error)
 		return error;
 
-- 
2.53.0


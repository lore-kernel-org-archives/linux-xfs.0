Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9073B892B;
	Tue,  7 Apr 2026 14:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775570768; cv=none; b=rsDQO3sSxRSQf1sA1CbL2MRsc8hWiJHSFUX5Z+SIYDIIWomxBiX0tGtc9RdNQ1XhZ0ojyQ+2fIuxEbzuJwbB+rdoZrkg8VZ8KXB8tljOIEU/nfMZwB6RUuJD8i4USJf9UBPuUlF0QuUiZxBYjQ/sv77BekWgabwVyeinJqFNM+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775570768; c=relaxed/simple;
	bh=beNL+OpQSveUr+zvLCoqjR/RUBHr2gsVYBzUJnwxOlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kg6zkIFfzbcgIPdRtE0QCO3xaeQtOeHRtNAxR3nlOMrAG73sMXj+SCwT0XmLmAwJpG6FjvfxRlYLW2gIVaJak4sD5yZvdis6fI9q65zniCMqFj9IBH7Za54ELIUKJ42cj/egjgP4KCYEPlUAw8EFILAW0VuYGKkc/kStiIzzRts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IBwDF9OS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IBwDF9OS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h5Fr/Lbu7+HBFLT6YRZ3beK2otaI/ShIhiGQh1kzoYw=; b=IBwDF9OShS3QsrK57nxpMeroBb
	MW3Ag9wGLM4r72CcLhBrVHwjpvP69qVzO0rbUGFT21TSY5ZZxuE7APf17pHeSCatg/KI0VuK7xmDl
	zJvKkF6brLzEvJr0lo9yAJA9uoJkWbJ3zPYk7BuXQxdiCCBDomFNMeRYswMC2FDu3B0LCJ0oSQpq3
	hDEb3FKSIMXLTJ9mwe15zCon5uCuFfCb0t65qtoDLrT+ARP7RXuYeSOiF6rCYz10zf4w+tcxUufLM
	GcQlMBj0ai1vDAc6Js3ugenqMAuCRcolT82ifrNHfx44Bp4P3PJtPjnMhUbXYJ91cjiDB68WtbH5i
	ARtXtOsA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA74A-00000006YyU-0AJK;
	Tue, 07 Apr 2026 14:06:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] xfs: use bio_await in xfs_zone_gc_reset_sync
Date: Tue,  7 Apr 2026 16:05:28 +0200
Message-ID: <20260407140538.633364-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407140538.633364-1-hch@lst.de>
References: <20260407140538.633364-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Replace the open-coded bio wait logic with the new bio_await helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/xfs_zone_gc.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index eebe6f4fee1f..b2626a482563 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -900,9 +900,10 @@ xfs_zone_gc_finish_reset(
 
 static void
 xfs_submit_zone_reset_bio(
-	struct xfs_rtgroup	*rtg,
-	struct bio		*bio)
+	struct bio		*bio,
+	void			*priv)
 {
+	struct xfs_rtgroup	*rtg = priv;
 	struct xfs_mount	*mp = rtg_mount(rtg);
 
 	trace_xfs_zone_reset(rtg);
@@ -934,26 +935,16 @@ xfs_submit_zone_reset_bio(
 	submit_bio(bio);
 }
 
-static void xfs_bio_wait_endio(struct bio *bio)
-{
-	complete(bio->bi_private);
-}
-
 int
 xfs_zone_gc_reset_sync(
 	struct xfs_rtgroup	*rtg)
 {
-	DECLARE_COMPLETION_ONSTACK(done);
 	struct bio		bio;
 	int			error;
 
 	bio_init(&bio, rtg_mount(rtg)->m_rtdev_targp->bt_bdev, NULL, 0,
 			REQ_OP_ZONE_RESET | REQ_SYNC);
-	bio.bi_private = &done;
-	bio.bi_end_io = xfs_bio_wait_endio;
-	xfs_submit_zone_reset_bio(rtg, &bio);
-	wait_for_completion_io(&done);
-
+	bio_await(&bio, rtg, xfs_submit_zone_reset_bio);
 	error = blk_status_to_errno(bio.bi_status);
 	bio_uninit(&bio);
 	return error;
@@ -990,7 +981,7 @@ xfs_zone_gc_reset_zones(
 		chunk->data = data;
 		WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
 		list_add_tail(&chunk->entry, &data->resetting);
-		xfs_submit_zone_reset_bio(rtg, bio);
+		xfs_submit_zone_reset_bio(bio, rtg);
 	} while (next);
 }
 
-- 
2.47.3


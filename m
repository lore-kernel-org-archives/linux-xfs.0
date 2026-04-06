Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDDA31B833;
	Mon,  6 Apr 2026 05:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775455068; cv=none; b=TWMfpHIqNesfV/Morl+ZtaeUB470dQv/EilGwfAS96KnmvTpQnhxSI8ISxZm+wQ0BSpw+z3hPvTnOmeBT3GOZl1GvK0IipGLW09qv9MUSRyp7ZeUKKHVGs7RH8D2TU2qXLWkz9FgdfXBKY0lRBqAIc/Yvy6tXlBSF8QMZi7qFz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775455068; c=relaxed/simple;
	bh=5RCkDzsxoob9+QDCxrpF3NUyE0/1oVchsLVVFYtyAP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rb4ojHCQ1E9jRtnIbwmiHgyH5YO0SOfm82HyYhrHfRS+V6U1iQEtHYk23cevpSuMcBVR7JW27bJyaayemV1lDVJHHFLS49iTwcTZo89c7MKR6+8GA9Hst+pMuFsDaA8pEbmW63+El3xnvwcjQQ+msxMMI4nUTidXBYwLuPPjF34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B6Yv7qU1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B6Yv7qU1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NeLzseTk8X1y6pPPVWXipKEd5An/y7cUypxk5FZQ04c=; b=B6Yv7qU1OKrFwTTKYFpF+yozav
	3UFpNj/1E+5WUFv/Sbbm3cCQcr7/jvkZOiCE2HhpoJEuT8te/gm0U46JjgeE6J0yFUE8SV9txL04g
	CKQ0N7LI55dPKwIFoMX9FwKSGSUG8nCFulREIrWcSMv2pzH2j8qDQzKpwaaq9G5mvGZlRqDf76iqT
	yFhfDnDj9EbVwMXcoagolevcO2UQrWAFAORjc7tTpazqmX77A/bPTjuGfwV90e4PEc7+HniWzBZuh
	t4jqZ2fwAauTQ8zZZqVb/uYF6mSqtBJax49vgqk7gsHR+psc8SXGbR0WBfwWYSIwyvuDDtsvS3HqY
	SoKa5sxA==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9cy2-00000004pVn-3PAk;
	Mon, 06 Apr 2026 05:57:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: use bio_await in xfs_zone_gc_reset_sync
Date: Mon,  6 Apr 2026 07:57:23 +0200
Message-ID: <20260406055728.472919-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260406055728.472919-1-hch@lst.de>
References: <20260406055728.472919-1-hch@lst.de>
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


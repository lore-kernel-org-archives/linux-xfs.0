Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1F2347505;
	Mon,  6 Apr 2026 05:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775455058; cv=none; b=dZdqCiaLV6+cee/gs2lNauZaDWC2OTfjRIoZHTCWGWWFtdWNF0LGNJON+iO4IxvaysMumGtxvA57mOFm3flwkk5F7KCx+ahnob1mvsX+Rov8HB1zmIZrBzL3qohFi8IjW6K2ALJoor9ywnXEheACMaFovfM8kN2unwJXJ2wFH+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775455058; c=relaxed/simple;
	bh=88AzU5iAUjsAgiiHMKMQLNRO0FXOMaeX07uM0xFS8wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFqBwPumoX8AOnlAdCOkhZXcFyO8FIbMTgiun6lJmp1QLSv9w/q4lnH2ulJsrQcPSk4vlfENJeMuNQiEDF182kd8kb/s6z5nPLASOeGzKL9cXwMO/a5xYh+exLqEv1Y4X7HIJh1wCAT+tPiljfGfSzRK2mTe4PNQmKiMiDXbNtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hWeP5gfe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hWeP5gfe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rvcMzTLd0Z1KVxo/x+Uo0gDeVgXR0zsvIUI7MIE/t9I=; b=hWeP5gfePQPZH/Y6QECGzcu/Jc
	4/DdhkJ0ek3ldq3PYoFAUie2DsUIwXR1E5yMqM5kpPpqq5oQafcQuWB4BFZnfZIHqilZw1kSbtgXo
	0zVDcHEKIC+YWYtUGfFL2htrihdc+WrsquiFczNxcSO7xAQwDygIYi0sAhI2vtaEL77RgP0j5YZyl
	DUtaL71WIE8DEjIJSdVMFpYd2cdWy5bVkrzKH5hbLASI6LM2aPGsgR0JtyTR6wQVUWquu8SZwoSJz
	SJI+60bufm+27NJ6Yrci9VF/0/oGKF9KizB2PPehN0vVVP3/D6fnxxu+unDKjfocNaXc3EyM9SvQ/
	HmzsaG4A==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9cxq-00000004pVO-3gmx;
	Mon, 06 Apr 2026 05:57:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] block: unify the synchronous bi_end_io callbacks
Date: Mon,  6 Apr 2026 07:57:20 +0200
Message-ID: <20260406055728.472919-2-hch@lst.de>
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

Put the bio in bio_await_chain after waiting for the completion, and
share the now identical callbacks between submit_bio_wait and
bio_await_chain.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 block/bio.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index c8234d347fc5..434e41182c05 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1462,7 +1462,7 @@ void bio_iov_iter_unbounce(struct bio *bio, bool is_error, bool mark_dirty)
 		bio_iov_iter_unbounce_read(bio, is_error, mark_dirty);
 }
 
-static void submit_bio_wait_endio(struct bio *bio)
+static void bio_wait_end_io(struct bio *bio)
 {
 	complete(bio->bi_private);
 }
@@ -1484,7 +1484,7 @@ int submit_bio_wait(struct bio *bio)
 			bio->bi_bdev->bd_disk->lockdep_map);
 
 	bio->bi_private = &done;
-	bio->bi_end_io = submit_bio_wait_endio;
+	bio->bi_end_io = bio_wait_end_io;
 	bio->bi_opf |= REQ_SYNC;
 	submit_bio(bio);
 	blk_wait_io(&done);
@@ -1523,12 +1523,6 @@ int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
 }
 EXPORT_SYMBOL_GPL(bdev_rw_virt);
 
-static void bio_wait_end_io(struct bio *bio)
-{
-	complete(bio->bi_private);
-	bio_put(bio);
-}
-
 /*
  * bio_await_chain - ends @bio and waits for every chained bio to complete
  */
@@ -1541,6 +1535,7 @@ void bio_await_chain(struct bio *bio)
 	bio->bi_end_io = bio_wait_end_io;
 	bio_endio(bio);
 	blk_wait_io(&done);
+	bio_put(bio);
 }
 
 void __bio_advance(struct bio *bio, unsigned bytes)
-- 
2.47.3


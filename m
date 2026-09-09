Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B8437B025;
	Wed,  9 Sep 2026 06:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934193; cv=none; b=aZ7KIcn0GH+gSyFEwJacSVbClG/fxYgWwgLZp5a9+jZwr5MbAUMUVZ+5u7OvGYw06kwvZb3E/wEUmNfLLLFzZn5O+KBpMTMQfvTv5ZXZPhr20nVn+NWosIsItDLN5vHOHmrJHbZKxl6x4eLDSlEhRUWFe13vObNvaKG93p4YP+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934193; c=relaxed/simple;
	bh=qfBcoAdfdCp3uZx9xyY+wvi0tntB2hNLxVPJPQZx1Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+faXYwzJ5/Rdt4H8abVz5+tCmYwqjSuZyx2dtSkatRpXcKgLfOm3Cecwiduxyl8XfNaR9UtSFMvUzhAqhgHd/L+snJgDl1sq0eVMMcYsfqPqJB4qzrggynJ54ilaDciqGy/qs+Qgd7O9owZmXecxtCfyltb3IE+BEZEbEO3cxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AB5X/SGg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AB5X/SGg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=E8Nhh9oj6vetyDRP7ZplKBiYQOJMHKsV1P1IQGdu3hY=; b=AB5X/SGgvajFHB2O2ac9jRXnp3
	J4BJEXuop9HwLIgdyO1L8IA310A4o19RXnT0DxGqL24k3mTRDYG1/nBzKx1hui/lGpzbJ1DfqHsmo
	WiUevXsdRRirS7SjNyP6jV7IUQAvPBLqBsewHkfL5YyxOCgZnKh6wtfQ8VEgQwR5yCX7xj07ObrCb
	qB41uccpaGyjoQ1ToDoLloqHsd9EQHbTj5Wwz0e/oeWJrxc/t8pcwDOSxksEKdSi0A8AHcy/qXU7J
	WvjC7Ren2iVIV1XgGT2RZTkvfLXtSUE0qWfAS212uQ226snaNHatFR+Gc7KLeSNxiFGwMTmmBpygk
	mFMB+iOw==;
Received: from [62.74.3.53] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4BVF-0000000Aqgd-3vfE;
	Wed, 09 Sep 2026 06:09:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 04/16] iomap: respect maximum I/O size in iomap_dio_bio_iter_one
Date: Wed,  9 Sep 2026 09:08:53 +0300
Message-ID: <20260909060924.1102037-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909060924.1102037-1-hch@lst.de>
References: <20260909060924.1102037-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Respect the maximum I/O size set for PI-enabled I/O in
iomap_dio_bio_iter_one, otherwise bio_integrity_alloc_buf could
under-allocate the integrity buffer when the initial kmalloc fails.

Currently this should not be triggered as file systems that limit the
size for PI always use bounce buffering, but this will change soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/direct-io.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index bc726d47b7dc..91f5b67718a5 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -336,6 +336,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 		struct iomap_dio *dio, loff_t pos, unsigned int alignment,
 		blk_opf_t op)
 {
+	unsigned int maxsize = iomap_max_bio_size(&iter->iomap);
 	unsigned int nr_vecs;
 	struct bio *bio;
 	ssize_t ret;
@@ -353,14 +354,12 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
-
 	if (dio->flags & IOMAP_DIO_BOUNCE)
-		ret = bio_iov_iter_bounce(bio, dio->submit.iter,
-				iomap_max_bio_size(&iter->iomap), alignment);
+		ret = bio_iov_iter_bounce(bio, dio->submit.iter, maxsize,
+				alignment);
 	else
-		ret = bio_iov_iter_get_pages(bio, dio->submit.iter,
-				BIO_MAX_SIZE, bdev_dma_alignment(bio->bi_bdev),
-				alignment - 1);
+		ret = bio_iov_iter_get_pages(bio, dio->submit.iter, maxsize,
+				bdev_dma_alignment(bio->bi_bdev), alignment - 1);
 	if (unlikely(ret))
 		goto out_put_bio;
 	ret = bio->bi_iter.bi_size;
-- 
2.53.0


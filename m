Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40B42DEA64;
	Wed,  1 Apr 2026 14:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775052281; cv=none; b=murDJhztEEkZAW/IGR49NF6EMZWyZkKwEIcMEjNYh2UKJZahvUNpCSfYfuSNAxfmcVTIYaglpCSMcENNvLlk0X56u1jt9AVH+Q02lmrS4OAXzEUIpiL0phaT51itG8NaYsKRYuLG0rX+6zip/VjSfcyWMaD+gElLai9LDhk4RhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775052281; c=relaxed/simple;
	bh=8XTRiX+Aaxk6dwqBzYGYWWP51cD5nMZS/ef6ml+WnF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XylCzlUUwNXcZcEQQANLjQE5fNZ/6FRef3XNUn/Kuzv4K3tAeoW9pMU2Q5e1ixX/vaZyO+Jtn44UKuSROn58IbQb7sTmV0aBGzmq4Dvs+d+CASs7RXMF3nyBYOGKc9Uatkh3VfE/vtOJgagJ0qkUGdYcViduZHTtiwuM81BDq/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SB/Gj3Eq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SB/Gj3Eq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=f5VQe/20ovDlz8LlIFL+mg11gzIaSXsSkiu6F38vzAA=; b=SB/Gj3Eq/krYIVRcbFFwXZrQdJ
	2mOy+7KrWmPZ1S4dv/8UP1AopQnjTHUkO6FRwJQLd2sJpXfaIZnjyWMzNkILuqt+/vm5740MdZvvM
	LsXg/MLr1jubwtHHVBkjG4yxHluYs7S9bKf+8surBP0/wczaoVYrHmTiRLp2Ux44dQlEkqcprQ0lv
	68TzMvsZJACmPO1PP/Ksqga974JXdc4KOWQXnqgSrQE96d/FkDbV9VHVLebUMSGTRDjMw0gPCnHhj
	w5qtvrltv5kkmwhecvTYKgrQuL9dt0eyviAb8SMZ9FvsCgm1l0sJO3LuGL2IZX9f8h2BnjxATT4EY
	Q5WpWrQg==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7wBT-0000000FNQ7-1C4m;
	Wed, 01 Apr 2026 14:04:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] block: unify the synchronous bi_end_io callbacks
Date: Wed,  1 Apr 2026 16:03:56 +0200
Message-ID: <20260401140433.125924-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401140433.125924-1-hch@lst.de>
References: <20260401140433.125924-1-hch@lst.de>
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
---
 block/bio.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 77067fa346d3..f5a058531cd9 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1448,7 +1448,7 @@ void bio_iov_iter_unbounce(struct bio *bio, bool is_error, bool mark_dirty)
 		bio_iov_iter_unbounce_read(bio, is_error, mark_dirty);
 }
 
-static void submit_bio_wait_endio(struct bio *bio)
+static void bio_wait_end_io(struct bio *bio)
 {
 	complete(bio->bi_private);
 }
@@ -1470,7 +1470,7 @@ int submit_bio_wait(struct bio *bio)
 			bio->bi_bdev->bd_disk->lockdep_map);
 
 	bio->bi_private = &done;
-	bio->bi_end_io = submit_bio_wait_endio;
+	bio->bi_end_io = bio_wait_end_io;
 	bio->bi_opf |= REQ_SYNC;
 	submit_bio(bio);
 	blk_wait_io(&done);
@@ -1509,12 +1509,6 @@ int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
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
@@ -1527,6 +1521,7 @@ void bio_await_chain(struct bio *bio)
 	bio->bi_end_io = bio_wait_end_io;
 	bio_endio(bio);
 	blk_wait_io(&done);
+	bio_put(bio);
 }
 
 void __bio_advance(struct bio *bio, unsigned bytes)
-- 
2.47.3


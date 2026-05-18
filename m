Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9812385529;
	Mon, 18 May 2026 06:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779085768; cv=none; b=AlY84lc6DSd8O3Sk8L1fDlX3VA7zwcrDw92/CK2DNkGSv1elOmApOE5afho9BCoIivKjJWzTH2bIc68Lf4hsDoIGA1tvcFa9J3RyY0kr196Gj7QMtheNC8J1O7/TqosQqBTjwKVMSlGwWTkok1OVbsolmI8WEEdIQLi8p2nCy/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779085768; c=relaxed/simple;
	bh=51LhxIleCTJqt4BiWQ4sLBmpM6PrdLa7O86sRMoBezY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O+AnMTcAPJhBqAgFtgW6k+sUwS6864pw9xmCY41XSMo9bRuYsZm3ZS6CwENdPd++F93spkWFALkjNkCB/zyydabZY1zcRvFpVBeoeAvcLSDoidGqFJ08X6fJ8UZbT8N8i9eItMbfsKsvYTrQqXOibZVOfSiKu5xrQmJrihcgw8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UzWb5A8g; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UzWb5A8g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=YIvcn5om5TwyAzJyMEQrEcddm3OGUNdocOTBQQR/JLQ=; b=UzWb5A8gyNlf/DWKRHYiq4krpz
	bjkxFuQuHdK2icIStHD6sZ8Oq+jo2BY/WZcEhNExesxVTEhCrPfV32vsizME6SmwPljhRSbonfmB1
	bRE5xUA7gLabulmCgpllUkIQ227R8KVm4zHI8/9PrBBRbfUWrXdCYrtt9mcRWY510Q6nudh65g25C
	kwWJUb0yMEx6mPwQLW4IHAxSmyzrhcqT86oVUfemWvaFsLyf6ixRum/9xq5zwbwCP8yPWhDjtSOZZ
	Td/2RdjxTUT/1a+d6Ym9pEcgj9yZNPiCRzfQxgZaflsulNBknpCQA8VRyPoq41WVM5sikYZPovje2
	ZZIYTxRQ==;
Received: from [2001:4bb8:2ee:fcf2:e6ad:a575:3e60:e254] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOrTd-0000000EQdI-3TZc;
	Mon, 18 May 2026 06:29:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: brauner@kernel.org
Cc: djwong@kernel.org,
	axboe@kernel.dk,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH] iomap: don't make REQ_POLLED imply REQ_NOWAIT
Date: Mon, 18 May 2026 08:29:13 +0200
Message-ID: <20260518062917.506483-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

As described in commit 2bc057692599 ("block: don't make REQ_POLLED imply
REQ_NOWAIT"), which fixed the same issue for the block device node, there
are valid cases to poll for I/O completion without REQ_NOWAIT.

Additionally, sing REQ_NOWAIT for file system writes is currently not
supported as file systems writes are not idempotent and would need a
retry of just the bio and not the entire operation to be fully supported.

Switch iomap to set REQ_POLLED and remove the now unused bio_set_polled
helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c |  2 +-
 include/linux/bio.h  | 14 --------------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b0a6549b3848..db16f21446f7 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -69,7 +69,7 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
 
 	/* Sync dio can't be polled reliably */
 	if ((iocb->ki_flags & IOCB_HIPRI) && !is_sync_kiocb(iocb)) {
-		bio_set_polled(bio, iocb);
+		bio->bi_opf |= REQ_POLLED;
 		WRITE_ONCE(iocb->private, bio);
 	}
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 85463981d0f5..6b0ad28387b8 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -695,20 +695,6 @@ static inline bool bioset_initialized(struct bio_set *bs)
 	return bs->bio_slab != NULL;
 }
 
-/*
- * Mark a bio as polled. Note that for async polled IO, the caller must
- * expect -EWOULDBLOCK if we cannot allocate a request (or other resources).
- * We cannot block waiting for requests on polled IO, as those completions
- * must be found by the caller. This is different than IRQ driven IO, where
- * it's safe to wait for IO to complete.
- */
-static inline void bio_set_polled(struct bio *bio, struct kiocb *kiocb)
-{
-	bio->bi_opf |= REQ_POLLED;
-	if (kiocb->ki_flags & IOCB_NOWAIT)
-		bio->bi_opf |= REQ_NOWAIT;
-}
-
 static inline void bio_clear_polled(struct bio *bio)
 {
 	bio->bi_opf &= ~REQ_POLLED;
-- 
2.53.0


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0B57BAEC;
	Tue, 12 Mar 2024 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254912; cv=none; b=CIz2NjoAQnKoPDDexQgBhm5PARc/HjPqq/zyQDI5GQ7rVUL5kkkqM8oiWf2Up0Ls57w3FURRv/Ajw+HDn7whRvEE5/Bx1RZU0iZcnlxhVjJEvFpMpty74Asiu4w0VxuJHa6+jxAOsf/jNsS7klOSE06VFEdAUSuWZqvtKx7R2So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254912; c=relaxed/simple;
	bh=MfrVblUDCrrLmiUNkfH67L683bKvRsnfpprjSZo/TI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tkBQnp8AYXN+q69FBv/BbYjFkA3BtvA1Zg4prrhaUpJ6BuNfAdiEzFHjeGnsW0acLz4HzztrZp32Iqu0pPtwIzTuU+qlzZXQPtyVuqhkvnUntiSv3GEbnSoUsUxubivoufcKS3+V+BAr+h5BqxjpnC7dUWr6jmphyR6wlXFo3B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Arxqcpws; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Arxqcpws"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hrCyrsnBfOo+yPYfkugdSsWlzoyaaYdrCNbfvGS6+ZU=; b=ArxqcpwshAy8cBVbnng99n/ghN
	HI4ES8qm24v8uGgkINbchiUmIHLfh5ct1JTFPTh9GiSfShr8WjZkNkPZX9PI/SGh6dSVMAjTtvIhj
	ZhgWywa21ZGGYh3Xz/ismG0Z8fJ+BUTdP5IqreC3IKSqqfPUHms3my1QsMhdmzeb1b+Wd7cUUTqOR
	tuD5DjaiTzJKXWN05cqCym2wch7hMRXLcd0XXMu3+5y82iCb5bF5Sci6lKqiAHs2EkekYsnCDyvfw
	Joh8uHXjdq0b467cOVgV6lLm+4u5CuV5zJN3OlJJcHrL3591AJT5FkkzEXWrLGhqKiYtu0WHhu0Y4
	6P3nlpFA==;
Received: from [50.226.187.238] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk3Qc-00000006D87-2mRe;
	Tue, 12 Mar 2024 14:48:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] block: move await_bio_chain to bio.c
Date: Tue, 12 Mar 2024 08:48:25 -0600
Message-Id: <20240312144826.1045212-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240312144826.1045212-1-hch@lst.de>
References: <20240312144826.1045212-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

we'll want to use it from more than blk-lib.c, so this seems like
the better place.  Also rename it so that the name starts with bio_.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c     | 20 ++++++++++++++++++++
 block/blk-lib.c | 28 ++++------------------------
 block/blk.h     |  1 +
 3 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 32ff538b29e564..33972deed87fb3 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1396,6 +1396,26 @@ int submit_bio_wait(struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio_wait);
 
+static void bio_wait_end_io(struct bio *bio)
+{
+	complete(bio->bi_private);
+	bio_put(bio);
+}
+
+/*
+ * bio_await_chain - ends @bio and waits for every chained bio to complete
+ */
+void bio_await_chain(struct bio *bio)
+{
+	DECLARE_COMPLETION_ONSTACK_MAP(done,
+			bio->bi_bdev->bd_disk->lockdep_map);
+
+	bio->bi_private = &done;
+	bio->bi_end_io = bio_wait_end_io;
+	bio_endio(bio);
+	blk_wait_io(&done);
+}
+
 void __bio_advance(struct bio *bio, unsigned bytes)
 {
 	if (bio_integrity(bio))
diff --git a/block/blk-lib.c b/block/blk-lib.c
index fd97f4dd34e7f4..8021bc3831d56a 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -35,26 +35,6 @@ static sector_t bio_discard_limit(struct block_device *bdev, sector_t sector)
 	return round_down(UINT_MAX, discard_granularity) >> SECTOR_SHIFT;
 }
 
-static void await_bio_endio(struct bio *bio)
-{
-	complete(bio->bi_private);
-	bio_put(bio);
-}
-
-/*
- * await_bio_chain - ends @bio and waits for every chained bio to complete
- */
-static void await_bio_chain(struct bio *bio)
-{
-	DECLARE_COMPLETION_ONSTACK_MAP(done,
-			bio->bi_bdev->bd_disk->lockdep_map);
-
-	bio->bi_private = &done;
-	bio->bi_end_io = await_bio_endio;
-	bio_endio(bio);
-	blk_wait_io(&done);
-}
-
 struct bio *blk_alloc_discard_bio(struct block_device *bdev,
 		sector_t *sector, sector_t *nr_sects, gfp_t gfp_mask)
 {
@@ -93,7 +73,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	}
 
 	if (*biop)
-		await_bio_chain(*biop);
+		bio_await_chain(*biop);
 	return -EINTR;
 }
 EXPORT_SYMBOL(__blkdev_issue_discard);
@@ -158,7 +138,7 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 		sector += len;
 		cond_resched();
 		if (fatal_signal_pending(current)) {
-			await_bio_chain(bio);
+			bio_await_chain(bio);
 			return -EINTR;
 		}
 	}
@@ -206,7 +186,7 @@ static int __blkdev_issue_zero_pages(struct block_device *bdev,
 		}
 		cond_resched();
 		if (fatal_signal_pending(current)) {
-			await_bio_chain(bio);
+			bio_await_chain(bio);
 			return -EINTR;
 		}
 	}
@@ -352,7 +332,7 @@ int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 		nr_sects -= len;
 		cond_resched();
 		if (fatal_signal_pending(current)) {
-			await_bio_chain(bio);
+			bio_await_chain(bio);
 			ret = -EINTR;
 			bio = NULL;
 			break;
diff --git a/block/blk.h b/block/blk.h
index a19b7b42e6503c..78528bfbd58c37 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -38,6 +38,7 @@ void __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic);
 void blk_queue_start_drain(struct request_queue *q);
 int __bio_queue_enter(struct request_queue *q, struct bio *bio);
 void submit_bio_noacct_nocheck(struct bio *bio);
+void bio_await_chain(struct bio *bio);
 
 static inline bool blk_try_enter_queue(struct request_queue *q, bool pm)
 {
-- 
2.39.2


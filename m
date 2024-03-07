Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EBA12F58A;
	Thu,  7 Mar 2024 15:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824331; cv=none; b=JclkBJde7bg12s3lIwAfJin9fxpejv2TX6akGP6Uir3jFUDUul/ysZnWiI3hDI19vvztHzGFqw3DuByz1thFY20XA5Gw9ucowl/7bWfar2Sxp/hHlzLAcGzI/llJiqX55ayas2tNUkxanXo3cw4rbEDdClIoGlXtQuOdDrSgBEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824331; c=relaxed/simple;
	bh=YW6FwHf1cZyuB8pvxeE9p+PHHGc++oMFrWPwA1CA6Jo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XUvemYwkl/ainLikswujTBkw0tw3QbBE3C2neX4nnQ0wBphLeJ37ZQEEB06dmsjSlhq+baFZz2v3h1OeebfnV0f3bnP452/OWuRAFqKjRuiERuRgNFooctZReOj9g+NQjUdG7tP96OOCkGWksc+i0qzEXmOj8bCp6lABxsrSTSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z6sNMhee; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z6sNMhee"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jU4QlnWtPYtUMHg2kw7ZYLYWKsDbWmqawf6KHDiM9lA=; b=Z6sNMheeJfjyD9glIjnyns+gty
	pAVADDD91BM4ta1R/ON8FEKfp9UXU9QfGMUtDXvPFar2iRKoKEQ17PikIDnrRXabHyGTnWawxHwK3
	E96odd8qAXRxRUdewCBcgQVlqRiO8vdq1cchhQkKExU5h0I6wAf6c+7IYSlj7O2Gt/61Wlnr4ROjq
	nErI2lTW2bwE3W139XgwYgFhxu+bY9pHELsNsv/XImw/T1dOirZBHbtAfb9LMjewlFq7JYV9/HG/J
	6AAz9JRq6hr4DzsELFrK7lGN2Levd8gQsRMcjvQsdSniIgqSMAXhxLtCNAhl1SqN1+vqru/nKCXoi
	yr5PtWbA==;
Received: from [66.60.99.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1riFPk-00000005DBr-3wFH;
	Thu, 07 Mar 2024 15:12:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/10] block: remove __blkdev_issue_discard
Date: Thu,  7 Mar 2024 08:11:57 -0700
Message-Id: <20240307151157.466013-11-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240307151157.466013-1-hch@lst.de>
References: <20240307151157.466013-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Fold what is left of __blkdev_issue_discard into blkdev_issue_discard and
simplify the error handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-lib.c        | 29 +++++++++--------------------
 include/linux/blkdev.h |  2 --
 2 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 4f2d52210b129c..39e6e21eb2982d 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -78,23 +78,6 @@ bool blk_next_discard_bio(struct block_device *bdev, struct bio **biop,
 }
 EXPORT_SYMBOL_GPL(blk_next_discard_bio);
 
-int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop)
-{
-	struct bio *bio = *biop;
-
-	while (blk_next_discard_bio(bdev, &bio, &sector, &nr_sects, gfp_mask)) {
-		if (fatal_signal_pending(current)) {
-			await_bio_chain(bio);
-			return -EINTR;
-		}
-	}
-
-	*biop = bio;
-	return 0;
-}
-EXPORT_SYMBOL(__blkdev_issue_discard);
-
 /**
  * blkdev_issue_discard - queue a discard
  * @bdev:	blockdev to issue discard for
@@ -113,16 +96,22 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	int ret;
 
 	blk_start_plug(&plug);
-	ret = __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
-	if (!ret && bio) {
+	while (blk_next_discard_bio(bdev, &bio, &sector, &nr_sects, gfp_mask))
+		if (fatal_signal_pending(current))
+			goto fatal_signal;
+	if (bio) {
 		ret = submit_bio_wait(bio);
 		if (ret == -EOPNOTSUPP)
 			ret = 0;
 		bio_put(bio);
 	}
 	blk_finish_plug(&plug);
-
 	return ret;
+
+fatal_signal:
+	blk_finish_plug(&plug);
+	await_bio_chain(bio);
+	return -EINTR;
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b87cd889008291..a1e638fb90fa77 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1057,8 +1057,6 @@ extern void blk_io_schedule(void);
 
 int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask);
-int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop);
 bool blk_next_discard_bio(struct block_device *bdev, struct bio **biop,
 		sector_t *sector, sector_t *nr_sects, gfp_t gfp_mask);
 int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
-- 
2.39.2


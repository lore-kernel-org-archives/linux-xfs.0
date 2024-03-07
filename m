Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA06512F36F;
	Thu,  7 Mar 2024 15:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824326; cv=none; b=BL7AdH6+TbdFudSsSsaX9gw4pl9D+lCVcABCMht0wXIBE0kt5FB1+u2pr5j6+FYnxLrJtp0PXBBDObqV1sFF96VSmlbteASV0sPuqVctU1j/8q68AUnFLAZT9ESj0SAf4rYfMA8BpqMGaM12areSKDQB2YIzxRcEYikt3Vfc5Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824326; c=relaxed/simple;
	bh=LFzZsApGcvCLdm6zVuiq8u52+VVD4nNTQaqWvlVOnp0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ukBHVWAQdsVyghemxublVixfkxq9u13EPV8nIxj/BGTzLT8uMFFG+Tr3urdmQkWRLahR56G7oXh+OWfEMj0XjFteG3d+B916XK/z4+oeMGQOKHYm992OmHikX8XZAR5OzLKMpg/OfbztdUDewS3bCniTC3Y3pZEXwY/ZH9TUOjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dZ8JOSgM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dZ8JOSgM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pIAa/RpvHRZ8f5i+wX7BbspmDNldfs7/UxcWBp02Rkc=; b=dZ8JOSgMcu7MN3cGccf5sTRPc/
	FUroHl04qi1ReLZrqfC7poA50rNdJg5vJ+HZEhLxPTktaOHXngwJ/GGiAs7LqZbPqRTC8LavDfRRh
	q3Q6NFhSdC/G7YEEvdIX/JOxeplMu6xcWabACsICAbVch3f2dl3i93aXZ+CiPMDyKt2VxX38FdzH2
	9utGSJ1QsuxFGWzcCgrZijX7YxSmCqOXolvRDfluhZhCxAnMuP5HaUOIKGF1DYaUzLFUfuBH5pGzF
	qs1JscatO/BjNJH7YNZPRRDtGIOorc3drqj7/CKzhOhlPHtq3edjS0dVjocRl3qZ5x0Nc5bcjB6ku
	dRwEBuzw==;
Received: from [66.60.99.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1riFPe-00000005D89-3Qh7;
	Thu, 07 Mar 2024 15:12:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/10] block: add a blk_next_discard_bio helper
Date: Thu,  7 Mar 2024 08:11:50 -0700
Message-Id: <20240307151157.466013-4-hch@lst.de>
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

This factors the guts of __blkdev_issue_discard into a helper that can
be used by callers avoid the fatal_signal_pending check and to generally
simplify the bio handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-lib.c        | 41 ++++++++++++++++++++++++-----------------
 include/linux/blkdev.h |  2 ++
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 50923508a32466..4f2d52210b129c 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -55,28 +55,35 @@ static void await_bio_chain(struct bio *bio)
 	blk_wait_io(&done);
 }
 
+bool blk_next_discard_bio(struct block_device *bdev, struct bio **biop,
+		sector_t *sector, sector_t *nr_sects, gfp_t gfp_mask)
+{
+	sector_t bio_sects = min(*nr_sects, bio_discard_limit(bdev, *sector));
+
+	if (!bio_sects)
+		return false;
+
+	*biop = blk_next_bio(*biop, bdev, 0, REQ_OP_DISCARD, gfp_mask);
+	(*biop)->bi_iter.bi_sector = *sector;
+	(*biop)->bi_iter.bi_size = bio_sects << SECTOR_SHIFT;
+	*sector += bio_sects;
+	*nr_sects -= bio_sects;
+	/*
+	 * We can loop for a long time in here if someone does full device
+	 * discards (like mkfs).  Be nice and allow us to schedule out to avoid
+	 * softlocking if preempt is disabled.
+	 */
+	cond_resched();
+	return true;
+}
+EXPORT_SYMBOL_GPL(blk_next_discard_bio);
+
 int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop)
 {
 	struct bio *bio = *biop;
 
-	while (nr_sects) {
-		sector_t req_sects =
-			min(nr_sects, bio_discard_limit(bdev, sector));
-
-		bio = blk_next_bio(bio, bdev, 0, REQ_OP_DISCARD, gfp_mask);
-		bio->bi_iter.bi_sector = sector;
-		bio->bi_iter.bi_size = req_sects << 9;
-		sector += req_sects;
-		nr_sects -= req_sects;
-
-		/*
-		 * We can loop for a long time in here, if someone does
-		 * full device discards (like mkfs). Be nice and allow
-		 * us to schedule out to avoid softlocking if preempt
-		 * is disabled.
-		 */
-		cond_resched();
+	while (blk_next_discard_bio(bdev, &bio, &sector, &nr_sects, gfp_mask)) {
 		if (fatal_signal_pending(current)) {
 			await_bio_chain(bio);
 			return -EINTR;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a9a0bd6cac4aff..b87cd889008291 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1059,6 +1059,8 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask);
 int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop);
+bool blk_next_discard_bio(struct block_device *bdev, struct bio **biop,
+		sector_t *sector, sector_t *nr_sects, gfp_t gfp_mask);
 int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp);
 
-- 
2.39.2


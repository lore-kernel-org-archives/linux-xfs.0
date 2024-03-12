Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31107B3F5;
	Tue, 12 Mar 2024 14:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254912; cv=none; b=cFc61k5IopPUy2YD5KrZSyin62KSOrieRX6zWj5SHQm+IuWnqLmV6aNYSediLsbZENw5wZmF+GTWGGnWQ+JuYAmAPye1YoQmKqafFRxePnmV17UlEHY7mJrEblIZc6B1c9XY8c6nYJ/OElEOaxldAGCNnFp1u9Gf1toOeiDj5KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254912; c=relaxed/simple;
	bh=/Zv+Ufy9VDvIabahDOh3hEnN/W+K4UKzQDGq9mpwqHI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aGyoD5gCiadZZ60ZvjYw/2XwaIzOZQeSFi75T1ySflXBxYobxVDxDL1aOFEG/DezBlOSnmcr8aIg/ZZdMdngwvZ4IH5P9Pz8swx0KJSnjMP1x9lvu2mEkabfP7zwcoul1Z08NyQ0oj2Lxr2pACfVDOEQr1I3J23SWRs34nrSlsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z5fgdPHX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z5fgdPHX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0Naseq0Wthv0thDdBSJ3JbI1Kt4lTFJ0xfpQrsvbeLw=; b=z5fgdPHXJtLzU7Ku1IoPHHBD5h
	OBQgWZcg9uWGdxOHR5QT3knjTF7kD1zr8+1h92m9fVQsOcuhXK1E/nNy6HKRHfnK+Sn4Eo074lLXe
	prhHK48T9iBfYQy1vwh0NTwHHH2d5AJSUlqCfG+r/cRvIeRq31txuKbwvQlOH9aN7K9vNmYQpJ50y
	Z0eZIBGewNUJQ8m3wg7ymEzEWy2OWpoEihaZa4dKueA+makTsCx3YzrowDsoz45jUURCDgauf2vkM
	ZvxFLT4LEcJWJ2bRBCvJQVrWF2vHOjcVolFIpmFuiiqPXOcj2DISDkJLlRSIBJrD9ctmE0Mm/2r0q
	LVkqPDjA==;
Received: from [50.226.187.238] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk3Qb-00000006D7b-2DRa;
	Tue, 12 Mar 2024 14:48:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] block: add a blk_alloc_discard_bio helper
Date: Tue, 12 Mar 2024 08:48:24 -0600
Message-Id: <20240312144826.1045212-4-hch@lst.de>
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

Factor out a helper from __blkdev_issue_discard that chews off as much as
possible from a discard range and allocates a bio for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-lib.c     | 58 ++++++++++++++++++++++++++-------------------
 include/linux/bio.h |  3 +++
 2 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 50923508a32466..fd97f4dd34e7f4 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -55,36 +55,46 @@ static void await_bio_chain(struct bio *bio)
 	blk_wait_io(&done);
 }
 
+struct bio *blk_alloc_discard_bio(struct block_device *bdev,
+		sector_t *sector, sector_t *nr_sects, gfp_t gfp_mask)
+{
+	sector_t bio_sects = min(*nr_sects, bio_discard_limit(bdev, *sector));
+	struct bio *bio;
+
+	if (WARN_ON_ONCE(!(gfp_mask & __GFP_RECLAIM)))
+		return NULL;
+	if (!bio_sects)
+		return NULL;
+
+	bio = bio_alloc(bdev, 0, REQ_OP_DISCARD, gfp_mask);
+	bio->bi_iter.bi_sector = *sector;
+	bio->bi_iter.bi_size = bio_sects << SECTOR_SHIFT;
+	*sector += bio_sects;
+	*nr_sects -= bio_sects;
+	/*
+	 * We can loop for a long time in here if someone does full device
+	 * discards (like mkfs).  Be nice and allow us to schedule out to avoid
+	 * softlocking if preempt is disabled.
+	 */
+	cond_resched();
+	return bio;
+}
+
 int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop)
 {
-	struct bio *bio = *biop;
-
-	while (nr_sects) {
-		sector_t req_sects =
-			min(nr_sects, bio_discard_limit(bdev, sector));
+	struct bio *bio;
 
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
-		if (fatal_signal_pending(current)) {
-			await_bio_chain(bio);
-			return -EINTR;
-		}
+	while (!fatal_signal_pending(current)) {
+		bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects, gfp_mask);
+		if (!bio)
+			return 0;
+		*biop = bio_chain_and_submit(*biop, bio);
 	}
 
-	*biop = bio;
-	return 0;
+	if (*biop)
+		await_bio_chain(*biop);
+	return -EINTR;
 }
 EXPORT_SYMBOL(__blkdev_issue_discard);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 643d61b7cb82f7..74138c815657fd 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -826,4 +826,7 @@ struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
 		unsigned int nr_pages, blk_opf_t opf, gfp_t gfp);
 struct bio *bio_chain_and_submit(struct bio *prev, struct bio *new);
 
+struct bio *blk_alloc_discard_bio(struct block_device *bdev,
+		sector_t *sector, sector_t *nr_sects, gfp_t gfp_mask);
+
 #endif /* __LINUX_BIO_H */
-- 
2.39.2


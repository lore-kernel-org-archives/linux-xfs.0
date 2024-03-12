Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778A17AE72;
	Tue, 12 Mar 2024 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254748; cv=none; b=q34JmhXj1fkCKDDbW10DLGVdU6KNePfhgnpgQwbhDi2OaWTYfz11Zz+s0m/GN9IX6Pb4B1o69Ws+mijgWp3rOwUb/vLKeWZge5dYprJKsvZvdTMj7oOFqZ0+s1u5lFN1Cm5HBaRYVGC1g/Te+7qItPvUvQ2Pm0/7msLLTuUApzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254748; c=relaxed/simple;
	bh=/Zv+Ufy9VDvIabahDOh3hEnN/W+K4UKzQDGq9mpwqHI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jZXR1aD1amKM/bpDbjPgJbY+j/QRyEOS7/e2pYDPUEvQnd82c1jfnoych/+gn2P4RAKPb4+WrfHZ3ghX4dcSn1IQgONKvP/+AQFz8BfoFGWvYdGB4cCA2PPUnW5K6uNpuooM2ka8jo5W2f7gclAFJGMaTHw1MX6zUqFbPkv5xUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n6DBj6cI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n6DBj6cI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0Naseq0Wthv0thDdBSJ3JbI1Kt4lTFJ0xfpQrsvbeLw=; b=n6DBj6cIvlaCzVs49C5D7MAdTw
	yPDIeDJ8locxWfJvQzocOq7NkXowJVZ5Eiuik6ppG9NLJI7YPgffh2EtLYrExz9L4bbCq6JCA7Jfm
	ZMgoQpZoqyL6ExOG7ZcIozTJGVE0MXsE/9SQO6LwGlVcPj46gRogBYp49QhmXgCwTaIOhkGZKCoE4
	xKo6R1Uy2/Gh09c246vl+E1bFO7awaYHJZbexMU8nH5LLWcEnlCv0oHiWGRXvxz2Aeh3oCk/k0w7c
	1GLx53cdqMtmq0HHAparu1oSsz11PIrbTl2HlifjnB0s1uYoACmekRSDeiIyIbFI7tRTk/E9bu7Vo
	gB/Bt0cQ==;
Received: from [50.226.187.238] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk3Ny-00000006C8z-1Shx;
	Tue, 12 Mar 2024 14:45:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] block: add a blk_alloc_discard_bio helper
Date: Tue, 12 Mar 2024 08:45:29 -0600
Message-Id: <20240312144532.1044427-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240312144532.1044427-1-hch@lst.de>
References: <20240312144532.1044427-1-hch@lst.de>
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


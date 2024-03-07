Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4568526A;
	Thu,  7 Mar 2024 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824331; cv=none; b=Pon+tArEzOPQNIVXGldgtbN1T4eJjK8qzEXGS3q+p+elJrD5cTmModTpPT3NTbZAjMnB07GsSpG9n34B6mb3n7nveaMYMvWUL4cPyUXFuhomxchko3VTFDZ9Nt7vtB7ETNQA4RzvZUrmxtbIkvkFt7aR9g2Y7utIo1Pkqk1Ul5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824331; c=relaxed/simple;
	bh=JwuYAmIi5UKapQAZKgFGSV9vl5tP9gtv8VjI9JvIHIM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ovwUJb+vqDpZN377AROy0ImhvVTisfLbnpVP9g6ZQsK9rM71066+NQStyTMGPlc6WTuN2lwI/TGs+GS9EPfYLUYkHHMHOc6vzQLGZUMP4RYow4o0fvpCqG5wR96qiXB6x3ZIpJ6x4noj6zJbJ6CTiIzUxo3mvNj2LT7nSP0E/+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S8lDtdj/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S8lDtdj/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ve/vSVtU1ouGfANFy/XRVyCgEc2TdovLRI20CqB7Pzs=; b=S8lDtdj/FBMkA6isjvZR/4WZ1q
	qNFJNJ+s7Fy4TU7PuB63SnfKSuJ0g8E6YOHMDtlFbnoXr5y7yrRr4jNJVqZq+erDxYwZTuzDygQ+/
	QCSWkJ+wA09w92Yvm//mfho01bXLLa6kIHr5fFKwQ/ZNQ3BPmeINI4ZjU4OYHXIxLccdlUYLX9HeH
	INYjSZTw35NkhH0eRIlUxrJ8IT3bHRHp9fcxXwXi634NDaw+GBqkAiud92TrT2hzQvHCZO/miJ0BO
	DwVrmmToCK5oir5n1XGEHtYL0nZskjuUfATpg1gfRWRelUWXbzs0ji+Yws9FVoc/IBecEjbKWS0rl
	T97FUTAA==;
Received: from [66.60.99.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1riFPk-00000005DB9-0889;
	Thu, 07 Mar 2024 15:12:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/10] dm-thin: switch to using blk_next_discard_bio directly
Date: Thu,  7 Mar 2024 08:11:56 -0700
Message-Id: <20240307151157.466013-10-hch@lst.de>
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

This fixes fatal signals getting into the way and corrupting the bio
chain and removes the need to handle synchronous errors.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-thin.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 07c7f9795b107b..becf1b66262d34 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -398,10 +398,13 @@ static void begin_discard(struct discard_op *op, struct thin_c *tc, struct bio *
 static int issue_discard(struct discard_op *op, dm_block_t data_b, dm_block_t data_e)
 {
 	struct thin_c *tc = op->tc;
+	struct block_device *bdev = tc->pool_dev->bdev;
 	sector_t s = block_to_sectors(tc->pool, data_b);
 	sector_t len = block_to_sectors(tc->pool, data_e - data_b);
 
-	return __blkdev_issue_discard(tc->pool_dev->bdev, s, len, GFP_NOIO, &op->bio);
+	while (blk_next_discard_bio(bdev, &op->bio, &s, &len, GFP_NOIO))
+		;
+	return 0;
 }
 
 static void end_discard(struct discard_op *op, int r)
-- 
2.39.2


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEDE7B3E2;
	Tue, 12 Mar 2024 14:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254911; cv=none; b=t6fdzH50q83fPcs+ZEk/iu3U8xzls7IcGveZC6LYomirN75Si2uWV5fEhGMRS7RlLDAfLekPc5QLGmYJ0oQDCWln83+GfS+pAoVPXb8gM+7qFAGzAR+1Q56z7g7AZSySG1x14D49Pj8k2v3/jb9+79M+qn03pOMjZ8fkZcE97hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254911; c=relaxed/simple;
	bh=FFZqfCHe8EOWrtjltKtUPNRMjR8dRujOCh/4VjaeESk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IgK7tK8/6aa37Q4ZY1eid1vxIQrUVNEA4xePl5xnzY59FVGmGzFqU5TZNmH9YwnFk9YHPjZebD3i0V46FSlFHPxacWPJkWAF/XEZaCVOdT/QSnSqS55oFwXcgApX8cOCZgNNjuu0n2fotoDdXJFqaUIz15wuROVAtudxeJGQl1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VUSpUFUR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VUSpUFUR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VjiNJMj6lv6xSOzWYTzvr2i2M7boMMC6hKAnN+ZZj6M=; b=VUSpUFURSltV0X1volJriQF9H8
	U/raCC77HN3UzHiSq63Pi1t7Kf+zm9Nf/kwOV5uZQpXU1foulod7T/dkNgVMrcaVcMrxeEXQSDn2p
	qO6ALRev224Q5FkIyxEqAZIFf9Azoc8yc5f+Q9aQVE4bddcTvgdQjvAVUnpzwWXMpQyBC5ExnUXWC
	agDIn4AW/lpmUHrVt4WPgAh/we1z8qGSeG/jWEo2w7t9tEk4wg0jrPuZFP4zHcB9/sv6iWs30vb/i
	ZnC2M6qrdty1RJXXAPYzjoULG6WpNaDzsJylJYOcgQqLbybgq14b+ZK2Nw2KaikIAPkud6j9YgZoL
	QxGJ80ow==;
Received: from [50.226.187.238] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk3Qa-00000006D70-3Udu;
	Tue, 12 Mar 2024 14:48:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] block: add a bio_chain_and_submit helper
Date: Tue, 12 Mar 2024 08:48:23 -0600
Message-Id: <20240312144826.1045212-3-hch@lst.de>
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

This is basically blk_next_bio just with the bio allocation moved
to the caller to allow for more flexible bio handling in the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         | 28 ++++++++++++++++++++--------
 include/linux/bio.h |  1 +
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index d24420ed1c4c6f..32ff538b29e564 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -345,18 +345,30 @@ void bio_chain(struct bio *bio, struct bio *parent)
 }
 EXPORT_SYMBOL(bio_chain);
 
-struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
-		unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
+/**
+ * bio_chain_and_submit - submit a bio after chaining it to another one
+ * @prev: bio to chain and submit
+ * @new: bio to chain to
+ *
+ * If @prev is non-NULL, chain it to @new and submit it.
+ *
+ * Return: @new.
+ */
+struct bio *bio_chain_and_submit(struct bio *prev, struct bio *new)
 {
-	struct bio *new = bio_alloc(bdev, nr_pages, opf, gfp);
-
-	if (bio) {
-		bio_chain(bio, new);
-		submit_bio(bio);
+	if (prev) {
+		bio_chain(prev, new);
+		submit_bio(prev);
 	}
-
 	return new;
 }
+EXPORT_SYMBOL_GPL(bio_chain_and_submit);
+
+struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
+		unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
+{
+	return bio_chain_and_submit(bio, bio_alloc(bdev, nr_pages, opf, gfp));
+}
 EXPORT_SYMBOL_GPL(blk_next_bio);
 
 static void bio_alloc_rescue(struct work_struct *work)
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 875d792bffff82..643d61b7cb82f7 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -824,5 +824,6 @@ static inline void bio_clear_polled(struct bio *bio)
 
 struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
 		unsigned int nr_pages, blk_opf_t opf, gfp_t gfp);
+struct bio *bio_chain_and_submit(struct bio *prev, struct bio *new);
 
 #endif /* __LINUX_BIO_H */
-- 
2.39.2


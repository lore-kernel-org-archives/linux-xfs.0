Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281001DFD8;
	Tue, 12 Mar 2024 14:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254747; cv=none; b=i0MbOwMsrBXbvz83b0ZxeVY59jvev4exyY9tj/NFq1Ghu8qTrjUo+Wp4yfQM4K8Zectj3WB2xhk3ss6hJi0Erj/RU/LZ2KRx+GevodOe1SF8yKIFWRMWnFZeCLYSo92dT/WnKknYpHu2MT5HZ9BM4GVRes4eYK2E9M9hgtk15oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254747; c=relaxed/simple;
	bh=FFZqfCHe8EOWrtjltKtUPNRMjR8dRujOCh/4VjaeESk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LS2aNVXEhi6b0B/BvfW6I9NErsHkPbegRPFeiAOMfiBcqSOR0JGM9shDmvRoq1PUcwxrhOV63fjTFJQB+MyExYF0iSeE2IF7O6Pc2z73Q5Fli6h4c0UrZ5e1of52MA6VtOASAQno+96U8ji5ZFDb6mkV+EYRTjnYdMh6n+Aa+NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pjnbnW0Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pjnbnW0Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VjiNJMj6lv6xSOzWYTzvr2i2M7boMMC6hKAnN+ZZj6M=; b=pjnbnW0Zm1NjkZEhNvJ75+bSnj
	kHwSVnXJYSqsHXDVuyJilRI9C4p9ctpX/wfgzud9a5M9T7girx5yZd51/u8sagijFQaA/hSr8fIme
	pvGQYomzRFqpeTUlhsMFsIksGyk0ooiZymFNcil1vwNRDL27pkI6UKdQBWduc+8xOXt0cpolVb81s
	da9ryqwoLpTFbG9ajwGbWNL82+B1av/T4GN0+0017gSUfW1gUpL3rB9KrZ9uhLW+pSVdFXnJzv9qx
	fy83P2bPZdzivNJLQOYkauU2acQgVTJXMd6Z28wWVGlI29rUar7ekxanfQYoBE+416fjHip3yKC0v
	ByW4HR2Q==;
Received: from [50.226.187.238] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk3Nw-00000006C7z-19Kq;
	Tue, 12 Mar 2024 14:45:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] block: add a bio_chain_and_submit helper
Date: Tue, 12 Mar 2024 08:45:28 -0600
Message-Id: <20240312144532.1044427-3-hch@lst.de>
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


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4982F376A06;
	Wed,  9 Sep 2026 06:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934188; cv=none; b=eiwp+/9WTK6IRjn+M6+c1ZhliBQVq/JNdd0JRBbuNofcJ/D2ZgwTj819XkwLgmzSKEqSA2/AD1T1AZc3IwhC9JnP/BLY1RNK4WNuHVbMpy3VFcP+eVZjpZnirt7WO0wdn7xqZ9fKdtn77PsenxADbl3FiwALabmFgTWGRwgu1EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934188; c=relaxed/simple;
	bh=K6EUJqI4HakNQzhtAf7xgFpojbFbfgyKOJ06n4KN+Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aN7US1kmEFDGTgltg/JozIBJZZnhq8PpB5+qM+z3aAqxFw68azkV1hTmd11TTKj/JhtUPK6n63AdFafxMjUAScllGKR7iG41wdeA/OB92f4xNUHmbA646tyFQC9HN7IdHuGc8KtbLpqz7q8/eTuCZyD8HVZC0pesagkZbJU6fRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3Mjb+5bW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3Mjb+5bW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uzMgpasgF9xhuhn6ksUstaU+qGA6Cuplu58SFJm/A5s=; b=3Mjb+5bWgpv0hcwxwEqtPbCTNV
	kO4m8iSMYb+dWg45+P9nFvD4C6Pi4rtJ/bg/QhNd0HdXVZr94f5zmXU0e0a/WzW+PxynyUtsAFCZJ
	eQTPI6oDnNQV4BREhL/PR1NLDX8sA6zNgWokP9gFjYc7CS46OfxklefPXF4FGhZambN17uvOwvkWj
	q5nYO0lNFDb82BIRXpZJpvRWt8H4Y2ryZPrJadGDCWj0CIqPzHSlb29Cjvjqt0cCY1ZkPNYYsdAuZ
	bsENJ1rxlaOcJZliA0bfEWyA5woMHhXjgNllQnKFkEgRRAGHt5ZQZSNJH760u5ttsnofhPIZbYGrb
	GWJoPOgg==;
Received: from [62.74.3.53] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4BVA-0000000AqgL-41tq;
	Wed, 09 Sep 2026 06:09:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 03/16] block: add a bio_prepare_reissue helper
Date: Wed,  9 Sep 2026 09:08:52 +0300
Message-ID: <20260909060924.1102037-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909060924.1102037-1-hch@lst.de>
References: <20260909060924.1102037-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper to a clear a bio for reissue without a lot of the
pointless clearing and reinitializing done by bio_reset and bio_reuse,
and keeping the page pinning flag intact.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         | 20 ++++++++++++++++++++
 include/linux/bio.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 5792a059ef2a..7f7654e60dd4 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -320,6 +320,26 @@ void bio_reuse(struct bio *bio, blk_opf_t opf)
 }
 EXPORT_SYMBOL_GPL(bio_reuse);
 
+/**
+ * bio_prepare_reissue - prepare a bio for reuissing the original I/O
+ * @bio:	bio to reuse
+ * @bdev:	block device to use the bio for
+ *
+ * Prepare @bio to be resubmitted to retry the original operation.
+ * The caller must reset bio->bi_iter to the original state.
+ */
+void bio_prepare_reissue(struct bio *bio, struct block_device *bdev)
+{
+	bio->bi_bdev = bdev;
+	bio_associate_blkg(bio);
+	bio->bi_flags &=
+		(BIO_PAGE_PINNED | BIO_CLONED | BIO_QUIET | BIO_REFFED);
+	bio->bi_status = BLK_STS_OK;
+	bio->bi_bvec_gap_bit = 0;
+	atomic_set(&bio->__bi_remaining, 1);
+}
+EXPORT_SYMBOL_GPL(bio_prepare_reissue);
+
 static struct bio *__bio_chain_endio(struct bio *bio)
 {
 	struct bio *parent = bio->bi_private;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 584b6abf6baf..bfa3c0e97b6f 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -479,6 +479,7 @@ static inline void bio_init_inline(struct bio *bio, struct block_device *bdev,
 extern void bio_uninit(struct bio *);
 void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf);
 void bio_reuse(struct bio *bio, blk_opf_t opf);
+void bio_prepare_reissue(struct bio *bio, struct block_device *bdev);
 void bio_chain(struct bio *, struct bio *);
 void bio_await(struct bio *bio, void *priv,
 	       void (*submit)(struct bio *bio, void *priv));
-- 
2.53.0


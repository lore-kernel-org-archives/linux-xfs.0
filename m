Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B348C32A3C8;
	Thu, 18 Dec 2025 06:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766039566; cv=none; b=hh4Yp5oV+2wEMwEbwynjFayeLQOndMsr8dkvk4x5nMhoV1JpnUTwtBMYAEh+/oBXzRhs1plDZV+qCL/iogFaUym1mfBVcvlWNrv0EtHfY00esXOUGTxt8H0DjIzd9T8ARZgtFFrrkBElk4/IOdA26psj/BiXGGcAZum7x03k5Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766039566; c=relaxed/simple;
	bh=gufQ4SJiRmv4WWEIWlHsyX40XxF03pc3kXYQgzfb3VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUQeP2+NzRalHvqJ4I3Dhdd341ItaXtuff2u3L8N9ez9zSEdyKuz5L94UnamDOcC6bHIl/LfWRzdKcqtyFAsCCjA1t9yXSGeYRHZxUhVxkPo9l2/rQ84QOCmxq88B4W5vNC9fVvIzGMSwd00S5pkMh9sYgkhgESvfvegHaJaqio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZpbBKA/r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZpbBKA/r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UF9d0S8SI56NT4ZQ85PTZK0zy7IMNjqWi9DS6i56AOI=; b=ZpbBKA/rfibBCRRMi9+5c+3WLb
	B5bX8kqInjWBwq5glO+pA0di5qDGo02eZqD6l0/WNf+7u7V8V2bFhjqKSza1z9mzE6ypJjBpH5b0k
	/NPMV1nEvuur6HaZUCuiKuFtRnGrxjteru8pJBaKZnxq6SuSEr6dGu1ZUjOlYinb1NM8Say5KbP8G
	LjdSTehMsEjxasUKzyttxcVLGeW0VWdN/B+8GLow9cdU+3VEhCfMh6bl8hPBPZ/gSXMBCYoJXmNnU
	C9xe3H1s3hmybrXnFS5kuBFuw98GuIg+WmxNqp7XybbkZ+CLk8irzev5LhLvGgWJg3T+kDb7KcYqP
	HKb/lbaw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vW7Z4-00000007tyT-3c2U;
	Thu, 18 Dec 2025 06:32:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] block: add a bio_reuse helper
Date: Thu, 18 Dec 2025 07:31:45 +0100
Message-ID: <20251218063234.1539374-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218063234.1539374-1-hch@lst.de>
References: <20251218063234.1539374-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper to allow an existing bio to be resubmitted withtout
having to re-add the payload.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         | 25 +++++++++++++++++++++++++
 include/linux/bio.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index e726c0e280a8..1b68ae877468 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -311,6 +311,31 @@ void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf)
 }
 EXPORT_SYMBOL(bio_reset);
 
+/**
+ * bio_reuse - reuse a bio with the payload left intact
+ * @bio bio to reuse
+ *
+ * Allow reusing an existing bio for another operation with all set up
+ * fields including the payload, device and end_io handler left intact.
+ *
+ * Typically used for bios first used to read data which is then written
+ * to another location without modification.
+ */
+void bio_reuse(struct bio *bio)
+{
+	unsigned short vcnt = bio->bi_vcnt, i;
+	bio_end_io_t *end_io = bio->bi_end_io;
+	void *private = bio->bi_private;
+
+	bio_reset(bio, bio->bi_bdev, bio->bi_opf);
+	for (i = 0; i < vcnt; i++)
+		bio->bi_iter.bi_size += bio->bi_io_vec[i].bv_len;
+	bio->bi_vcnt = vcnt;
+	bio->bi_private = private;
+	bio->bi_end_io = end_io;
+}
+EXPORT_SYMBOL_GPL(bio_reuse);
+
 static struct bio *__bio_chain_endio(struct bio *bio)
 {
 	struct bio *parent = bio->bi_private;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ad2d57908c1c..c0190f8badde 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -414,6 +414,7 @@ static inline void bio_init_inline(struct bio *bio, struct block_device *bdev,
 }
 extern void bio_uninit(struct bio *);
 void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf);
+void bio_reuse(struct bio *bio);
 void bio_chain(struct bio *, struct bio *);
 
 int __must_check bio_add_page(struct bio *bio, struct page *page, unsigned len,
-- 
2.47.3


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643E341C63;
	Tue,  6 Jan 2026 07:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767686368; cv=none; b=kZ8Ia+7GGFYZd29BmaMWLNYAL16ZEPa3KJjmAylJvPKVLdUJnwo6OBCabfO2FU3jad1nwLnXePeO8rtxS6JGXuXNvNnAI2sTSytXJDZ3kTIY9WLCMLOKLtUQuFqZWuhgL7wScAfovPKvkS4DYtODE7C9kt39Feo8RBh+ct8Er2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767686368; c=relaxed/simple;
	bh=0v9yWPs+yHWK4iiW8p9izCkKrvmns8085k+84jYaOk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzRG6909yAYXuQtU1NlQ7FqhMcsghXajNmxfo4maW8y5GPuCj/m5+kVKd/zstOwwXdh3+pvVQl5XjIuz3u1J44Ij9aOsW2r9uV3m/IJlf0ilhoJKvYgN5XaE7wUhia/hY4eKD/2pFj+m4zzvZkpt0wqydba9qrcPMuhZc3OIYyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RMSqNf/O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RMSqNf/O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FfK9Guwbm3HohVsqN5y5A24/KOcBOMTAkHCqPmYJ0BI=; b=RMSqNf/OZ1wIK7LO6LQXVhV9iQ
	ymtnCWsq3wictXs3HggtoFWAuPftGN4VB9+A0d5uGpt+JH6GV+uclZvU6AxY9tpuJhnUiZwochh+z
	B90+W3FrIp8bBHyeedETTIdVB8E7lMyRTN8pTRiWG7YHS8YVAtdK1cZvbmMHWA73YuV9hWWiwRTaB
	p3NaauUxcSu9X1t2SZUzppaKAiWxiCVrz4d4g1xDJsajHqfZnVjw6PxgEsxecZDEI3ODh8FNxEGzl
	Oa6avQNjeAaiv0/dVgeOUlWThyyhNTajNhp00u4eY1zVEMTNzrdaXh3HJEItwkfA38uYEj06oQkic
	mHZA54uw==;
Received: from [2001:4bb8:2af:87cb:5562:685f:c094:6513] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd1yQ-0000000Ca0M-1obF;
	Tue, 06 Jan 2026 07:59:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] block: add a bio_reuse helper
Date: Tue,  6 Jan 2026 08:58:52 +0100
Message-ID: <20260106075914.1614368-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260106075914.1614368-1-hch@lst.de>
References: <20260106075914.1614368-1-hch@lst.de>
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
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/bio.c         | 29 +++++++++++++++++++++++++++++
 include/linux/bio.h |  1 +
 2 files changed, 30 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index e726c0e280a8..ed99368c662f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -311,6 +311,35 @@ void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf)
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
+ * to another location without modification.  This must be used by the
+ * I/O submitter on an bio that is not in flight.  Can't be used for
+ * cloned bios.
+ */
+void bio_reuse(struct bio *bio)
+{
+	unsigned short vcnt = bio->bi_vcnt, i;
+	bio_end_io_t *end_io = bio->bi_end_io;
+	void *private = bio->bi_private;
+
+	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
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


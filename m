Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00602E11BC;
	Tue, 13 Jan 2026 07:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768288765; cv=none; b=GT0TidQFX2x1ZWENgPBt5i38hyhKfRyeBpgRKlhu5Az2OW3VEzYndzhWELs5ZF1YlRFlbGBUr0mxjwHBIFtOQnpcUi93yybuZq+i79dJUs6arVqiAW0J9isCuhBWniGs9woBDOpx/I8CHy41aBDZlE+dYCVkyg42MqZS65zvVHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768288765; c=relaxed/simple;
	bh=jCm/XKhgJ1wIfyX4rXkRVK8kn6Do9mqnAU68ZDIqXFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fsg6nTUimn5quW7neKP5KJIZo5O/hP9QWTt60tZ1ukky/Vekl5Gd776hpCCgLifVZRl/zAUE4Ypm3eAexPehtuXOC2t813n+4em+N8hyMrNllzwNPEAn1Typ2G5KUuZPzysQhfQ2G+x9mRdPpgdVqgQ2r0rbe4A0as7Te6xpMJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UyGTpbpq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UyGTpbpq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WCxJlehcWZYhbec3AQjs9uGM683DzS2OXgMULroIK7o=; b=UyGTpbpqyq14pCZlTx8cWpY0fL
	CX30B2GKN/6BC0gh2KNUWmm+zlseqKyK6kii2ZEnj8j0sqOhC28iV3ehKWhjSHsiHKxuNATBAxzlJ
	MPOJ9FfWfV57Dnk6aEKrtHiBFSIRUw/HLYc4OQ/z+IIlb3DbsqbDBi7lL0NVECx3kWylLt/u6euox
	k10goD3IqOWbISELKxdUS3r/h03+f+tAA3F1cRBQgEDqW53Er1aPsGYR10cr8AGBAVOWR+mMEwwed
	G8Bske82Y4Jg0Ezb+0aqdwPinnPxZ2CO1aIYyPox+dMw2BhczDcePDZUsnVeZ3ALyAAAfZXnZ9Wzg
	dkrpL7nA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfYgU-00000006dUg-22xJ;
	Tue, 13 Jan 2026 07:19:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 1/3] block: add a bio_reuse helper
Date: Tue, 13 Jan 2026 08:19:01 +0100
Message-ID: <20260113071912.3158268-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113071912.3158268-1-hch@lst.de>
References: <20260113071912.3158268-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper to allow an existing bio to be resubmitted without
having to re-add the payload.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 block/bio.c         | 33 +++++++++++++++++++++++++++++++++
 include/linux/bio.h |  1 +
 2 files changed, 34 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index e726c0e280a8..b22336905ce0 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -311,6 +311,39 @@ void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf)
 }
 EXPORT_SYMBOL(bio_reset);
 
+/**
+ * bio_reuse - reuse a bio with the payload left intact
+ * @bio: bio to reuse
+ *
+ * Allow reusing an existing bio for another operation with all set up
+ * fields including the payload, device and end_io handler left intact.
+ *
+ * Typically used when @bio is first used to read data which is then written
+ * to another location without modification.  @bio must not be in-flight and
+ * owned by the caller.  Can't be used for cloned bios.
+ *
+ * Note: Can't be used when @bio has integrity or blk-crypto contexts for now.
+ * Feel free to add that support when you need it, though.
+ */
+void bio_reuse(struct bio *bio)
+{
+	unsigned short vcnt = bio->bi_vcnt, i;
+	bio_end_io_t *end_io = bio->bi_end_io;
+	void *private = bio->bi_private;
+
+	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
+	WARN_ON_ONCE(bio_integrity(bio));
+	WARN_ON_ONCE(bio_has_crypt_ctx(bio));
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


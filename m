Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9890734DCE3;
	Mon, 31 Aug 2026 06:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158451; cv=none; b=TIN8GwyolGgDXDrGzslnw9Dkjq4TPnfUyNuJ8QpiSYeRT/3ro8zONIe9TVjELpeU003dtVRZypcks+6bdCqv8qLOIxMMdqC1oqj47DsoJzyzUv/vDz2S5Q5Bp9n8G4on7HaldiC2EyxnE3eCVhnTf71LPgEWH9ogFbNZ72cQ8DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158451; c=relaxed/simple;
	bh=Vs+4lvQl7Bpx+lr0EFyx243ach9si1sZii1LnwTT2eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/0uyR/zk2PVuAnvZtCCbYvnPmA8eEAQZ7Oaeost6QpIebx/cbMGeCsHB+l7C9CpK3wX4/VP4+du0ewiE5LGF4a8MJDEl6WalVJR8mJ3d5j7fLdEWP31f+TwLxdYhYPz5OrpyM4Tq3Vc/1GDH5CK4AKTR/oZtGJyjZc7BsLkki0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m8wrBBJq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m8wrBBJq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3lTJAx3gjqVKlFNAsS+KG9OsLKABWAQLgP99XoK3tAM=; b=m8wrBBJqGPlq8/cd/sfY7FQCQx
	2u5b67MvRKzSv6MJcjQiE8SvADyk1ol55Lkuhq8te3lHY7fs/nhayKuF+WifT9PdUSYrHNhwx8e2p
	KXsAIabMMfNV4ZAWNzV3pEWaPRSjhG/iEXEZ1rPsu2aBGjDcEgU4hX5RzYA+qNBLNzpEfs04dH0jQ
	UjnO/7Il15sPXMWq27SERHgYKmwPTWAp6EY9XLkt0WynxUcZoxJ9PF0yljeh07VUnJNMi1uKVsO90
	JSfM+T/ncuLHc1IQJx1Q6N0qnnVpRqE9kTFOGIQHWlLEgv5TcDZ/a/rcUqL1PYARK8pzMYmWuMaFQ
	IpiWjEYA==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vhH-00000008cut-2zNi;
	Mon, 31 Aug 2026 06:40:48 +0000
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
Subject: [PATCH 05/17] iomap: respect maximum I/O size in iomap_dio_bio_iter_one
Date: Mon, 31 Aug 2026 09:39:53 +0300
Message-ID: <20260831064010.2574896-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831064010.2574896-1-hch@lst.de>
References: <20260831064010.2574896-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Respect the maximum I/O size set for PI-enabled I/O in
iomap_dio_bio_iter_one, otherwise bio_integrity_alloc_buf could
under-allocate the integrity buffer when the initial kmalloc fails.

Currently this should not be triggered as file systems that limit the
size for PI always use bounce buffering, but this will change soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index bc726d47b7dc..91f5b67718a5 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -336,6 +336,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 		struct iomap_dio *dio, loff_t pos, unsigned int alignment,
 		blk_opf_t op)
 {
+	unsigned int maxsize = iomap_max_bio_size(&iter->iomap);
 	unsigned int nr_vecs;
 	struct bio *bio;
 	ssize_t ret;
@@ -353,14 +354,12 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
-
 	if (dio->flags & IOMAP_DIO_BOUNCE)
-		ret = bio_iov_iter_bounce(bio, dio->submit.iter,
-				iomap_max_bio_size(&iter->iomap), alignment);
+		ret = bio_iov_iter_bounce(bio, dio->submit.iter, maxsize,
+				alignment);
 	else
-		ret = bio_iov_iter_get_pages(bio, dio->submit.iter,
-				BIO_MAX_SIZE, bdev_dma_alignment(bio->bi_bdev),
-				alignment - 1);
+		ret = bio_iov_iter_get_pages(bio, dio->submit.iter, maxsize,
+				bdev_dma_alignment(bio->bi_bdev), alignment - 1);
 	if (unlikely(ret))
 		goto out_put_bio;
 	ret = bio->bi_iter.bi_size;
-- 
2.53.0


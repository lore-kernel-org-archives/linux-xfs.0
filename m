Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144CA39A05E;
	Tue,  7 Apr 2026 14:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775570755; cv=none; b=h8GVaE5vG5bq0PYy/L86av5eR9+wmqVZEtgDdtZlZ1ZBkTq6lzm6tUzThgSIVMuXePD08G8V8fbAGNyjVMYf3vHJMnUoKlmX9laTfVc5B5CSsRrv5h3y14jN+zU3cZHYJA8ulsVE7xCrRIdVhUq9r+R69kTMRRI5rW7r7toexV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775570755; c=relaxed/simple;
	bh=uehc576pwQCkAkWHG4wyXH/HEwdacsJ/1mS+cSotoGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNSzhz8DMe1+/UbiaKsNMFjMLhKEbKqDVPZJCXmGRKotVqmuy+i/JbIPl1Qtu74OXo50ELTCNK2zqn5MhyCQkJajSSbKcdaLZimC9Ci92HgB6aPb3im70D1OU3b+pNSpbmwUyydQTshIUS5zYmkUm+S0m7wlTrQ0WjPAlztWIfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vffx6AzD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vffx6AzD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YFG3EMFqVZw9sKkXA0HkKAuHKketyZH6p9fYKthPePM=; b=Vffx6AzDM3Fa4OoAoyCllL9CA0
	umcFhwYThQ5OFMPS9lET3wM1awlsSqGZokBx4CbpA8qRLsMbx1vKZCG8PtxHBfzw5pw642+tiAtnJ
	cysK3MhArhztrmx94jbnjJa6bTZlpHEPBzosGAhGL2lSv+yfzgVbg63HqGZWywvdXclW7m9Dtsy5a
	6CxyFlQjeVwl9bBrf1IOIqNmMNqAQeDIlD64VB0xyzAmY8xoB33HA7SjZXd/VyWJ4HWXYz6YnZ192
	LJJmpjW31Utw6tZKpWUVCWW9ZPXl3sq31nI/1Cvl82z06D1hF2vCFgqCWJV9YbkJBmPGRJrx+9aSh
	egjUzq4g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA73x-00000006Yti-21aO;
	Tue, 07 Apr 2026 14:05:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] block: unify the synchronous bi_end_io callbacks
Date: Tue,  7 Apr 2026 16:05:25 +0200
Message-ID: <20260407140538.633364-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407140538.633364-1-hch@lst.de>
References: <20260407140538.633364-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Put the bio in bio_await_chain after waiting for the completion, and
share the now identical callbacks between submit_bio_wait and
bio_await_chain.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/bio.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index c8234d347fc5..434e41182c05 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1462,7 +1462,7 @@ void bio_iov_iter_unbounce(struct bio *bio, bool is_error, bool mark_dirty)
 		bio_iov_iter_unbounce_read(bio, is_error, mark_dirty);
 }
 
-static void submit_bio_wait_endio(struct bio *bio)
+static void bio_wait_end_io(struct bio *bio)
 {
 	complete(bio->bi_private);
 }
@@ -1484,7 +1484,7 @@ int submit_bio_wait(struct bio *bio)
 			bio->bi_bdev->bd_disk->lockdep_map);
 
 	bio->bi_private = &done;
-	bio->bi_end_io = submit_bio_wait_endio;
+	bio->bi_end_io = bio_wait_end_io;
 	bio->bi_opf |= REQ_SYNC;
 	submit_bio(bio);
 	blk_wait_io(&done);
@@ -1523,12 +1523,6 @@ int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
 }
 EXPORT_SYMBOL_GPL(bdev_rw_virt);
 
-static void bio_wait_end_io(struct bio *bio)
-{
-	complete(bio->bi_private);
-	bio_put(bio);
-}
-
 /*
  * bio_await_chain - ends @bio and waits for every chained bio to complete
  */
@@ -1541,6 +1535,7 @@ void bio_await_chain(struct bio *bio)
 	bio->bi_end_io = bio_wait_end_io;
 	bio_endio(bio);
 	blk_wait_io(&done);
+	bio_put(bio);
 }
 
 void __bio_advance(struct bio *bio, unsigned bytes)
-- 
2.47.3


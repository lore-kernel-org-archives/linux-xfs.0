Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E85223336;
	Mon, 26 Jan 2026 05:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769406876; cv=none; b=BsUSfBNX/w5g245dtTOJAAhioVCPz4a1sagpon+Zxfu9fqZRebcTm9USlh8mVqHE/F+XoR8R2Ukz0HrHMA5UH4pfHBaC+CHyw3uRdz4VbWCT4TYNIfyllDiqauvt9WlYeEXTAn2TCmAytQLeCy2xChXDdwT7qMgd5BLxUNSM5b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769406876; c=relaxed/simple;
	bh=CtMFoZiktlXAy8yGfMNBOjqpQ9VFE7uOLIfg31y4UtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gscnjdBPwweTQX8hhZLJV0FUVOtgxqgku9I8lAV1Cu8ClSGCJB3A4vKf8elqYdpdBDxFBFlgzw2t+FiONxpLnNSgwx4F8hKxtiVn4I+YSrVhi0pYwT5+/l++FAGbdfE3mdsBZ8SZzdHgpB4yfLIb+3hF/KPwd4+2jCXSLiF9nJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f553tkZs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f553tkZs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=haHjw+VqL4MTERhra/NDGnEWjkbQwrMm0RD5iXcMftc=; b=f553tkZs/eaDO6jQuDakcKOVE3
	Zbiyb1qCLiKQDaKPN6NH2RBCi6QAvd6ZsKn/D3JdR5h4UvW/x2OFD5wS03khSgKghm1sAGwhFu9HR
	CXiBR+qIaQ4L54FaKGZilL4RpFVoKoy6ZMAuXLE09P70dasp9PRWcXKn6terEhHsNxmiW09zx06aY
	ih+uhRzw1obuE55ZHCy8I+GFYYroPwAZc3pbtVb2ekPmWaW4f371MlEt3nlCjQ14e0275D1PuY7vO
	mbeL4i65N/924Tx2D2nZAEKGPiw6dHYrct+LFhTwEVSMXq+gcyKNJewag3bD72ydYFsYm+vHqc6oc
	Dk+SAxEQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkFYX-0000000BxFO-2ja3;
	Mon, 26 Jan 2026 05:54:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Anuj Gupta <anuj20.g@samsung.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 05/15] block: remove bio_release_page
Date: Mon, 26 Jan 2026 06:53:36 +0100
Message-ID: <20260126055406.1421026-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260126055406.1421026-1-hch@lst.de>
References: <20260126055406.1421026-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Merge bio_release_page into the only remaining caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Tested-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/bio.c |  4 +++-
 block/blk.h | 11 -----------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 530082c8cf0c..285b573ae82f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1195,7 +1195,9 @@ static int bio_iov_iter_align_down(struct bio *bio, struct iov_iter *iter,
 			break;
 		}
 
-		bio_release_page(bio, bv->bv_page);
+		if (bio_flagged(bio, BIO_PAGE_PINNED))
+			unpin_user_page(bv->bv_page);
+
 		bio->bi_vcnt--;
 		nbytes -= bv->bv_len;
 	} while (nbytes);
diff --git a/block/blk.h b/block/blk.h
index 980eef1f5690..886238cae5f1 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -595,17 +595,6 @@ void bdev_set_nr_sectors(struct block_device *bdev, sector_t sectors);
 
 struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 		struct lock_class_key *lkclass);
-
-/*
- * Clean up a page appropriately, where the page may be pinned, may have a
- * ref taken on it or neither.
- */
-static inline void bio_release_page(struct bio *bio, struct page *page)
-{
-	if (bio_flagged(bio, BIO_PAGE_PINNED))
-		unpin_user_page(page);
-}
-
 struct request_queue *blk_alloc_queue(struct queue_limits *lim, int node_id);
 
 int disk_scan_partitions(struct gendisk *disk, blk_mode_t mode);
-- 
2.47.3


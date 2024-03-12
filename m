Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464807BAF7;
	Tue, 12 Mar 2024 14:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254913; cv=none; b=eXuVV7kMfBtx3oH7Z99BbN139OyXY2tY9xZTqYeIG83Ys/lhxRNIJ0ut29cbV5yYQ6/PV+0rO0GQBuk04PehGU7yCrzgiNlH07GHIffCYqCDA86WdM8aSX+QJqXhyhavdJp9GMcYDRjQuTs8CYOOhfzsc/mwE2S17ZYj86aa7bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254913; c=relaxed/simple;
	bh=MSww3kpy0EZ8nEuqmbXvVluyWuBKE2iKhaRsT3sJ7Jc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UuLGPgqkg+LlVlSBcT7LOk7/UOqKuwMvNWY4UMjCLLoMQW9W6Fba16b9dS4zz+c53UVAte60BHYwO0y24nd+ebZ7ZHWATwMvRav+lTw55hGewucVgC4rr+NFbXIoRVxeVq7HMWKrRWEoOtnhOWsO0cSfMAR3d1EOtnZMXmM0MN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x4VS3bdv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x4VS3bdv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YKaX8ERHDTkcm1Gf7rZWF74jjMOwqQulL6zhqTnYplQ=; b=x4VS3bdvDZlyCYWgoJS+r34lxK
	wVLpCzCbaWJ3gP70PWAfPpPZpfft0VD1IsWyyTuTVeLQgRX4QAfQFKQn1mWM6HAXChOSE5YToazMr
	ocPhtoJuK7ziZ55K0cdwjZhskVayKU1Kh7+ewq56u0GKxKkrwmjn+oXLS/dKRMjkCabcpRRGWwMNa
	FPfjOaq1jOaly01ofqXo89/3xOrdUxTmfms/3dbFy3mzLvu1/368KWbh6qIW3lENJrFlQ4eokpIJ5
	rL8RAjEdHX6Zhm3hb+hJqUlg68XayTzKW/dLukM8wwP/eUp8dE7X3FFG2vYOl3bfhbCNa7XZg3dYV
	7Hc64Z2A==;
Received: from [50.226.187.238] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk3Qd-00000006D8j-1sNb;
	Tue, 12 Mar 2024 14:48:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] block: don't allow fatal signals to interrupt (__)blkdev_issue_discard
Date: Tue, 12 Mar 2024 08:48:26 -0600
Message-Id: <20240312144826.1045212-6-hch@lst.de>
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

File system won't to handle fatal signals themselves and are generally
not prepared for EINTR errors from (__)blkdev_issue_discard.  Remove
the logic from the generic helpers and instead open code the discard
bio submission in the ioctl handler that wants it.

Fixes: 8a08c5fd89b4 ("blk-lib: check for kill signal")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-lib.c | 12 +++---------
 block/ioctl.c   | 24 ++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 8021bc3831d56a..90b75605299b9c 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -65,16 +65,10 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 {
 	struct bio *bio;
 
-	while (!fatal_signal_pending(current)) {
-		bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects, gfp_mask);
-		if (!bio)
-			return 0;
+	while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects,
+			gfp_mask)))
 		*biop = bio_chain_and_submit(*biop, bio);
-	}
-
-	if (*biop)
-		bio_await_chain(*biop);
-	return -EINTR;
+	return 0;
 }
 EXPORT_SYMBOL(__blkdev_issue_discard);
 
diff --git a/block/ioctl.c b/block/ioctl.c
index 57c8171fda93c5..32bbdba77d6941 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -96,10 +96,12 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 		unsigned long arg)
 {
 	sector_t bs_mask = (bdev_logical_block_size(bdev) >> SECTOR_SHIFT) - 1;
+	struct inode *inode = bdev->bd_inode;
 	sector_t sector, nr_sects;
+	struct bio *bio = NULL, *new;
+	struct blk_plug plug;
 	uint64_t range[2];
 	uint64_t start, len;
-	struct inode *inode = bdev->bd_inode;
 	int err;
 
 	if (!(mode & BLK_OPEN_WRITE))
@@ -129,7 +131,25 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 	err = truncate_bdev_range(bdev, mode, start, start + len - 1);
 	if (err)
 		goto fail;
-	err = blkdev_issue_discard(bdev, sector, nr_sects, GFP_KERNEL);
+	blk_start_plug(&plug);
+	while (!fatal_signal_pending(current)) {
+		new = blk_alloc_discard_bio(bdev, &sector, &nr_sects,
+				GFP_KERNEL);
+		if (!new)
+			break;
+		bio = bio_chain_and_submit(bio, new);
+	}
+	if (fatal_signal_pending(current)) {
+		if (bio)
+			bio_await_chain(bio);
+		err = -EINTR;
+	} else if (bio) {
+		err = submit_bio_wait(bio);
+		if (err == -EOPNOTSUPP)
+			err = 0;
+		bio_put(bio);
+	}
+	blk_finish_plug(&plug);
 fail:
 	filemap_invalidate_unlock(inode->i_mapping);
 	return err;
-- 
2.39.2


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9E312EBE8;
	Thu,  7 Mar 2024 15:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824327; cv=none; b=GdHElU/U5gom50BDa5XpqqxMYxFlwywvzziY9Cq90n00x/ilGNOkf+1zcxoLT9C7L86lWi8Wt7QdBdOb+MZASDsHH0U0AeQMZxAOCGDQDeauMp/if6gOGRbwdza4+YtVrCf9PjSbyt28HSkvj+O8I4OctLVP0IGR1Rqcj0RfES8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824327; c=relaxed/simple;
	bh=XAM+LwtEk0qr2GpYrr3g7759A/QwQZkYBngcPrPRzEM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mwNt2TX7lAWcx65N4PYSXJTGugpbLmFM45HlzdixvRGTAIQ636nnrIlGnu+4sBL/PIO88+TwGiCHlUeCosJndeAVGqUONDCezviHnidjqNZbPist3lfALl5uUQI/rwIx0sPSN2K7ZLmulfKWH5GMVDu5rUJzrLL4pCTRR2ynNqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mZnkzLeE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mZnkzLeE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pWLnUFlzUEJhnbTRDkaJ8/zvGbZPOXeOdQeHsZIHfXk=; b=mZnkzLeE+9tHuzricoH3AfKk/I
	JwjvFAY2rDlTMKWRjQqJijBwf3D9H5UKl1tJEH+OfBAwkmSgYlv3plwr+vrV3iylPri/kbon2ZlkH
	LjbhFbogqG0UBH4cbiEuNdVDA8PrZ7/WledrTqUs/PMCgRpaD2Dg8PsHgmtjYjwGOfbEPnaTDO+eK
	zVK0tcaUXjLjacol+JDOOOdEY/DigZBdek/N6p16dxhQERkEH63ibcA6Xg1LxcdAr/ghvHN3A0plt
	qhl/pwTrQPWvmBeYhyC5FcLNASBqxJ8MBg1RDnm0hLGQ73GkeU6Rezx3MXIHPL1HNxbi0LncDQfbh
	pReBxNZA==;
Received: from [66.60.99.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1riFPh-00000005D9c-2TVa;
	Thu, 07 Mar 2024 15:12:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/10] ext4: switch to using blk_next_discard_bio directly
Date: Thu,  7 Mar 2024 08:11:53 -0700
Message-Id: <20240307151157.466013-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240307151157.466013-1-hch@lst.de>
References: <20240307151157.466013-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This fixes fatal signals getting into the way and corrupting the bio
chain and removes the need to handle synchronous errors.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ext4/mballoc.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e4f7cf9d89c45a..73437510bde26c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3840,12 +3840,16 @@ static inline int ext4_issue_discard(struct super_block *sb,
 	trace_ext4_discard_blocks(sb,
 			(unsigned long long) discard_block, count);
 	if (biop) {
-		return __blkdev_issue_discard(sb->s_bdev,
-			(sector_t)discard_block << (sb->s_blocksize_bits - 9),
-			(sector_t)count << (sb->s_blocksize_bits - 9),
-			GFP_NOFS, biop);
-	} else
-		return sb_issue_discard(sb, discard_block, count, GFP_NOFS, 0);
+		unsigned int sshift = (sb->s_blocksize_bits - SECTOR_SHIFT);
+		sector_t sector = (sector_t)discard_block << sshift;
+		sector_t nr_sects = (sector_t)count << sshift;
+
+		while (blk_next_discard_bio(sb->s_bdev, biop, &sector,
+				&nr_sects, GFP_NOFS))
+			;
+		return 0;
+	}
+	return sb_issue_discard(sb, discard_block, count, GFP_NOFS, 0);
 }
 
 static void ext4_free_data_in_buddy(struct super_block *sb,
-- 
2.39.2


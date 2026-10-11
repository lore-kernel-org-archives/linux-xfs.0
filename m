Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F6C23ED6A;
	Sun, 11 Oct 2026 17:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791738651; cv=none; b=hScRG/dE4ZNNNggmTTkgjRA30l3hqHR0dl+MZVTsQBaYtJAo1AwBYc8cE5Ec0J8dlawGscvYHuAt/5ANY7Dx9vSENTWYsheeJpFtl0Gmu0c3D4mOGccH6HkO3QjSRn8EbSIoaLP3JqRzJ8rcg5JcSsWFGq84HUdaeiOh0ZQqAv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791738651; c=relaxed/simple;
	bh=CmHtzqHpJ/G+vywjHIX4oJlR+kjMPmeCCV3pEjGSrNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rb/ZkkNZpr2rfRQxezCcmZq4lqHkFtTGRi1fg30fLorWb21aJN7+hCxhO/Nfoma96/ZobRQahvAhIGRG+hvDWup3tBd38gcdaVsIauyKM/VR3ECDA7wzSPscy1hrjEHWW3P9qVYuHeT14Lm8c9TO/1zfk24bLXRLikbh5mZoUxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mr+uLZj0; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mr+uLZj0"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791738640; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=rWk0sRuAc4jP1qwUY4YXovDt1TGYXm/b0nVb2UKQGJ8=;
	b=mr+uLZj0nXQeXDWVasRuoYry0pww0SvAyKUT5KZg6tNT1H3asfzOlrZzwiGFEVsToOTnRK/WYywpPJrdsSUPU9nrkRnuCDh//FuOI2tTy239Y+HhInaPwQZtZobsk7c2cnxh0JW/MOCCF04o0QETjDXpC/g7AtlZXfNWZWsndeo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XCYQXXC_1791738637;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCYQXXC_1791738637 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 01:10:38 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ebiggers@kernel.org,
	jaegeuk@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	djwong@kernel.org,
	brauner@kernel.org,
	tytso@mit.edu,
	berto@igalia.com,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com
Subject: [PATCH 09/13] block: warn about bios that can't be split
Date: Mon, 12 Oct 2026 01:09:54 +0800
Message-ID: <20261011170958.1759230-10-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261011170958.1759230-1-libaokun@linux.alibaba.com>
References: <20261011170958.1759230-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bio_split_io_at() fails a bio that it can't split into a valid request
with -EINVAL: a bio may have too many discontiguous segments for the
queue, may have virtual boundary gaps that leave it without a block
sized split, and now that the split size is rounded down to the data
unit size of an encryption context, it may have a data unit that does
not fit in the room that the queue limits leave for the split.

Nothing else says which queue limit caused the failure, and a limit that
is smaller than the data unit size, e.g. a max_sectors_kb that was
lowered below it, is accepted by the block layer, so warn about it, with
the bytes that fit and the alignment involved.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 block/blk-merge.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index f92460c283e7..9bcc9c52eea1 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -349,6 +349,7 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 	struct bio_crypt_ctx *bc = bio_crypt_ctx(bio);
 	struct bio_vec bv, bvprv, *bvprvp = NULL;
 	unsigned nsegs = 0, bytes = 0, gaps = 0;
+	unsigned int align, split_bytes;
 	struct bvec_iter iter;
 	unsigned start_align_mask = lim->dma_alignment;
 
@@ -409,14 +410,20 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 	 * we do not use the full hardware limits.
 	 *
 	 * It is possible to submit a bio that can't be split into a valid io:
-	 * there may either be too many discontiguous vectors for the max
-	 * segments limit, or contain virtual boundary gaps without having a
-	 * valid block sized split. A zero byte result means one of those
-	 * conditions occured.
+	 * it may have too many discontiguous vectors for the max segments
+	 * limit, contain virtual boundary gaps without having a valid block
+	 * sized split, or have a crypto context whose data units are larger
+	 * than the number of bytes that fit. A zero byte result means one of
+	 * those conditions occurred.
 	 */
-	bytes = ALIGN_DOWN(bytes, bio_split_alignment(bio, lim));
-	if (!bytes)
+	align = bio_split_alignment(bio, lim);
+	split_bytes = ALIGN_DOWN(bytes, align);
+	if (!split_bytes) {
+		pr_warn_ratelimited("%pg: split needs %u align, %u bytes fit\n",
+				    bio->bi_bdev, align, bytes);
 		return -EINVAL;
+	}
+	bytes = split_bytes;
 
 	/*
 	 * Bio splitting may cause subtle trouble such as hang when doing sync
-- 
2.43.7


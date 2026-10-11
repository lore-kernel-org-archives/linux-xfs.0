Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39823164D8;
	Sun, 11 Oct 2026 17:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791738653; cv=none; b=lZTghIYaNiaNZt0/8K3soZun3xzSgRAeQJDjGdhphBWduYAFlpASD8w70pYTv4rm8930ecwpb5CDb5KMw5X7j5Dkfi1P16kxUVhe+tFKsxjsW/2h8iCjXZ0nIEMVSFZRUIGY6n7ZdhvyvVb3SSWDhILDXUBA+Eb3Wc2/WCF9GYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791738653; c=relaxed/simple;
	bh=Hxwpr6O7yWQFg2+FAyKpRZBzxXboPVzgVQZLKYx4Ejs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tkk0sGiugOw/yPjF5TbBUJCmiipl34AKEajoEUqkUzDp9QnWVSjtMlM+kuMVVvO+9P1l3XyJAXdUpkCrAKZ5CfD/7mgRyEOuedAXj4A+Rhh/PoDkz6/6q3JNuUJ4WHfw+ooHAQPry6Ck1g1BkvXQkkI18JgLvDF6o/BnUlQLtmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=iYImev23; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="iYImev23"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791738638; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=8D6vNHBJx0z0SwSxmvei23QITZ6qKM8C48rXwPbvD6I=;
	b=iYImev23FchwjrtfAR1Azy2CjoTwfec09/07T8lZDYOmOw36RYSWk2Pft2bSzpNBbdGy/i0kWFdmTcHsDs1yU7OFaDixBNnny0UZ/vMbVjEShriphQY5+e8Srgsa/m3bAZgnszezkMHaNzLIBe3f5a1HRhVdQx160Qz+OIuigQg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XCYQXWt_1791738636;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCYQXWt_1791738636 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 01:10:37 +0800
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
	ritesh.list@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH 08/13] block: split encrypted bios at data unit boundaries
Date: Mon, 12 Oct 2026 01:09:53 +0800
Message-ID: <20261011170958.1759230-9-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261011170958.1759230-1-libaokun@linux.alibaba.com>
References: <20261011170958.1759230-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Splitting a bio advances the remaining bio's data unit number by the
number of whole data units that were split off:

  bio_split()
   └─ bio_advance()
      └─ bio_crypt_advance()
         └─ bio_crypt_dun_increment(dun, bytes >> data_unit_size_bits)

The shift truncates, so splitting inside a data unit leaves the
remainder with the wrong data unit number and silently corrupts data.

The split size is already rounded down to the logical block size, so
this is only possible when the data unit size is larger than it, e.g.
a fscrypt filesystem with a 4K block size on a device with a 512-byte
logical block size.

Fix this by rounding the split size down to a data unit boundary.  The
split alignment becomes the maximum of the logical block size, the
data unit size, and the zone write granularity, so a zoned write still
meets all three requirements.

Split bios can be up to one data unit smaller than the queue limits
allow, so a bio can be split a little more often.  The number of
segments for the split bio is still counted up to the size before the
rounding, so it can be larger than needed; it is only used for
accounting.

Fixes: a892c8d52c02 ("block: Inline encryption support for blk-mq")
Cc: stable@vger.kernel.org
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 block/blk-merge.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 258a726071d1..f92460c283e7 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -308,9 +308,20 @@ static bool bvec_split_segs(const struct queue_limits *lim,
 static unsigned int bio_split_alignment(struct bio *bio,
 		const struct queue_limits *lim)
 {
+	const struct bio_crypt_ctx *bc = bio_crypt_ctx(bio);
+	unsigned int align = lim->logical_block_size;
+
+	/*
+	 * A split advances the remaining bio's data unit number by whole
+	 * data units only (see bio_crypt_advance()), so a split inside a
+	 * data unit would make it use the wrong data unit numbers.
+	 */
+	if (bc)
+		align = max(align, bc->bc_key->crypto_cfg.data_unit_size);
 	if (op_is_write(bio_op(bio)) && lim->zone_write_granularity)
-		return lim->zone_write_granularity;
-	return lim->logical_block_size;
+		align = max(align, lim->zone_write_granularity);
+
+	return align;
 }
 
 static inline unsigned int bvec_seg_gap(struct bio_vec *bvprv,
-- 
2.43.7


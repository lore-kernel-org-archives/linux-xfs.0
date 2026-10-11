Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FE03090D7;
	Sun, 11 Oct 2026 17:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791738653; cv=none; b=l0/MY7zXlpvPPp+H7IlCyW+qKIwdLucrkA2H5uijkAtxRELjAuP3H9bX+WqXYVPQYWFgVc4NtoEA0vOffU3VjCWkFgXrCKS9dtUQTGTFyyFEdF5pydl3fQtZP6CccBlzP2RSdJfWqdaxUYEU14XS0gegz9DvSc7/VWM6gTv5Gy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791738653; c=relaxed/simple;
	bh=vmp7lnOX2kBIlrBqvmi7YrLeM72FkKdcUcbmCK2nHCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rk4oXKgc+S7EpZZAxDbRP7BDeAuZ8VSbP72eDYPj0fIv1rzJd4E+rVIjCwuDUjBD/M760hlhdTLn+bWpJTT8niI+CGwwwiIkSYsVF3ALtZz+vAP1TjTbq5MuGu03Agu+nRbdKNJ8mutiOI4sXwPLo4d2mxSY7x03xbFmi1cN2PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ys3J+1/a; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ys3J+1/a"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791738641; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=KutoU9XVTdk5iv/Xws5091PS1Ju3oeC2KwLLjHP07Hw=;
	b=ys3J+1/a74DY5fEagsxz0GG+WcKVUfcQKwVUpXrrdqHCu0CpHD1jpmGIYxFdHXsgVykJvd8p3IyCp801BXeUMuGg5QxFuVqaWpLzRVafi7ETywdMoHMfb95iDd1zo03On/KeoPpgFrQ5j0Hkn2Ak71BfYfp1a1TmDcesdcg9utI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XCYQXXS_1791738639;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCYQXXS_1791738639 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 01:10:39 +0800
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
Subject: [PATCH 10/13] block: don't require data unit aligned bio_vecs for encrypted bios
Date: Mon, 12 Oct 2026 01:09:55 +0800
Message-ID: <20261011170958.1759230-11-libaokun@linux.alibaba.com>
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

bio_split_io_at() rejects an encrypted bio unless every bio_vec is data
unit aligned and a multiple of the data unit size, so that every split
lands on a data unit boundary.  That is stricter than needed:
bio_split_alignment() already rounds the split size down to the data
unit size, which is all a split needs.

The requirement can't be met by all submitters either: a direct I/O
read or write adds the pages of the user buffer as they are extracted,
and fscrypt_zeroout_range() always adds one page per bio_vec, so a data
unit larger than a page is described by bio_vecs that are smaller than
it.

Drop the requirement: the split size rounding keeps the data unit
numbers of the remainder correct.  A bio whose first data unit doesn't
fit in the split still fails with -EINVAL, as the rounded down size is
zero then.

The dropped requirement was only ever a proxy for the invariant that
the submitter has to keep: the bio must start at a data unit boundary
and cover a whole number of data units.  Document that in
bio_crypt_set_ctx() and in the block API documentation.

For safety, warn about a misaligned start in fscrypt_set_bio_crypt_ctx()
and reject bios whose size is not a whole number of data units in
blk_crypto_submit_bio().

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 Documentation/block/inline-encryption.rst | 13 ++++++++++++
 block/blk-crypto.c                        | 26 +++++++++++++++++++++++
 block/blk-merge.c                         | 14 ++++++------
 fs/crypto/block.c                         |  3 +++
 4 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/Documentation/block/inline-encryption.rst b/Documentation/block/inline-encryption.rst
index 0df964507f76..b2d6598ddfb6 100644
--- a/Documentation/block/inline-encryption.rst
+++ b/Documentation/block/inline-encryption.rst
@@ -198,6 +198,19 @@ it to a bio, given the blk_crypto_key and the data unit number that will be used
 for en/decryption.  Users don't need to worry about freeing the bio_crypt_ctx
 later, as that happens automatically when the bio is freed or reset.
 
+Users must keep such a bio aligned to the data unit size: the bio must start at
+a data unit boundary and be a whole number of data units long, since the data
+unit number of a bio describes its first data unit.  ``blk_crypto_submit_bio()``
+rejects a bio whose size is not a whole number of data units, and the block layer
+splits and merges encrypted bios only at data unit boundaries, but a layer that
+splits bios itself, e.g. device-mapper, must keep the alignment itself.
+
+Splitting a bio needs at least one whole data unit of room, so a queue limit
+that leaves less than a data unit for a split, e.g. when ``max_sectors_kb`` is
+lowered below the data unit size used on the device, fails the bio with
+``BLK_STS_INVAL``.  Devices that advertise a data unit size must therefore be
+able to issue requests of at least that size.
+
 To submit a bio that uses inline encryption, users must call
 ``blk_crypto_submit_bio()`` instead of the usual ``submit_bio()``.  This will
 submit the bio to the underlying driver if it supports inline crypto, or else
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 5c670c3e65c5..d79c9042ec52 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -98,6 +98,25 @@ static int __init bio_crypt_ctx_init(void)
 }
 subsys_initcall(bio_crypt_ctx_init);
 
+/**
+ * bio_crypt_set_ctx() - attach an encryption context to a bio
+ * @bio: the bio to attach the context to
+ * @key: the key that the bio will be en/decrypted with
+ * @dun: the data unit number of the bio's first data unit
+ * @gfp_mask: memory allocation flags
+ *
+ * The caller must keep the bio aligned to the data unit size of @key: it must
+ * start at a data unit boundary and be a whole number of data units long,
+ * since the data unit number of a bio describes its first data unit.
+ *
+ * blk_crypto_submit_bio() rejects a bio whose size is not a whole number
+ * of data units, and the block layer splits and merges encrypted bios
+ * only at data unit boundaries; a layer that splits bios itself, e.g.
+ * device-mapper, must keep the alignment itself.
+ *
+ * The bio must be submitted with blk_crypto_submit_bio(), after
+ * blk_crypto_start_using_key() was called for @key on the block device.
+ */
 void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
 		       const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE], gfp_t gfp_mask)
 {
@@ -260,6 +279,13 @@ bool __blk_crypto_submit_bio(struct bio *bio)
 		return false;
 	}
 
+	/* Error if the bio doesn't cover a whole number of data units. */
+	if (WARN_ON_ONCE(!IS_ALIGNED(bio->bi_iter.bi_size,
+				     bc_key->crypto_cfg.data_unit_size))) {
+		bio_endio_status(bio, BLK_STS_INVAL);
+		return false;
+	}
+
 	/*
 	 * If the device does not natively support the encryption context, try to use
 	 * the fallback if available.
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 9bcc9c52eea1..dd9be4c04041 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -346,20 +346,18 @@ static inline unsigned int bvec_seg_gap(struct bio_vec *bvprv,
 int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 		unsigned *segs, unsigned max_bytes, unsigned len_align_mask)
 {
-	struct bio_crypt_ctx *bc = bio_crypt_ctx(bio);
 	struct bio_vec bv, bvprv, *bvprvp = NULL;
 	unsigned nsegs = 0, bytes = 0, gaps = 0;
 	unsigned int align, split_bytes;
 	struct bvec_iter iter;
-	unsigned start_align_mask = lim->dma_alignment;
-
-	if (bc) {
-		start_align_mask |= (bc->bc_key->crypto_cfg.data_unit_size - 1);
-		len_align_mask |= (bc->bc_key->crypto_cfg.data_unit_size - 1);
-	}
 
 	bio_for_each_bvec(bv, bio, iter) {
-		if (bv.bv_offset & start_align_mask ||
+		/*
+		 * The bio_vecs of a bio with a crypto context don't have to
+		 * be data unit aligned, only the bio as a whole does; see
+		 * bio_crypt_set_ctx() and bio_split_alignment().
+		 */
+		if (bv.bv_offset & lim->dma_alignment ||
 		    bv.bv_len & len_align_mask)
 			return -EINVAL;
 
diff --git a/fs/crypto/block.c b/fs/crypto/block.c
index 5193f8ba3ee0..2040f63eb9a1 100644
--- a/fs/crypto/block.c
+++ b/fs/crypto/block.c
@@ -234,6 +234,9 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 		return;
 	ci = fscrypt_get_inode_info_raw(inode);
 
+	/* The data unit number of a bio describes its first data unit. */
+	WARN_ON_ONCE(!IS_ALIGNED(pos, 1U << ci->ci_data_unit_bits));
+
 	fscrypt_generate_dun(ci, pos, dun);
 	bio_crypt_set_ctx(bio, ci->ci_enc_key.blk_key, dun, gfp_mask);
 }
-- 
2.43.7


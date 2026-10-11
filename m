Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCD333688F;
	Sun, 11 Oct 2026 17:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791738645; cv=none; b=MNpGd5jHXaHhHTGBAwLTxdnoa24GiSBT4NErr7b/UH7DEkkKQaU5um2Lg3qnTF6CC6v39J3pNYZNI+6aVJTEIuVOVoiOqADIWOWMEwCFW+DGPnfQUEB2dcP/YL3vqMe4bfM824ORdYj2B6znui4s9T2DGH9hGYOHmEu5ctqP7ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791738645; c=relaxed/simple;
	bh=NrqZK7rqvAw56MQDdSJueOqwdJPJ/xxZ6bahGqeUuu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoLIIIwKINEbnkxSbQEu3WK0KeqaZVBJcAAOQGX4WZEOg+WiBnp0lOzdWCPTBjLO+5tr5X2QYnTFpwPjr546hHNgMURWUelAuvMyttojs8dFJU9cYaJ/5aRpl+Kv3BPj/gr8RjeX2eHJAQYSMQfpYxMH/thtTnc8qicTtUefUrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lK8/1QlG; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lK8/1QlG"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791738635; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=gqmSL4sWYoDT4Bqy2HkgacUL7Fkiqz8D3Y0xgLtRABs=;
	b=lK8/1QlGKfT74Uf2e04IP/O5Ysyt7+IfneEpgcMNirWHAgVM0AuKpdEIb+wpyPYpecEK/ekjtP2QCp0UwlTHWqSxzDWjZP3rI80ccMqM57CT+OXO7n4enhxVOsWM9a1++MKWno9uROPmbq9xCUzRRuvQ9h3r24hDYmS8ViYAlTY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XCYQXVO_1791738632;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCYQXVO_1791738632 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 01:10:33 +0800
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
Subject: [PATCH 05/13] blk-crypto: encrypt one data unit per crypto request
Date: Mon, 12 Oct 2026 01:09:50 +0800
Message-ID: <20261011170958.1759230-6-libaokun@linux.alibaba.com>
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

__blk_crypto_fallback_encrypt_bio() encrypts the source bio one bio_vec
at a time: it walks the bio with bio_iter_iovec(), which clamps each
bio_vec to a single page, encrypts all the data units of that bio_vec
into its bounce page with one crypto request per data unit, and starts a
new encrypted bio when all of its pages are in use.

That structure cannot express a data unit that spans more than a page.
In preparation for supporting such data units, restructure the loop
around the data unit, the same way as the decryption path: collect the
bio_vecs that make up one data unit in blk_crypto_du_bvecs(), encrypt it
with a single crypto request whose scatterlist covers exactly those
bio_vecs, and advance the source bio by one data unit.

Unlike the decryption path, which decrypts in place using one
scatterlist for both sides, the encryption path writes the ciphertext
to the bounce pages, so it fills the scatterlist for each side of the
crypto request, and calls the same blk_crypto_crypt_du() helper, with
the encryption direction and the bounce page scatterlist as the
destination.

A data unit is now encrypted as soon as it is complete instead of when
all the data units of its bio_vec are, and the first bio_vec of a data
unit is added to the encrypted bio with the whole length of the source
bio_vec it starts in, as the data units that follow it in that bio_vec
share its bounce page.

No functional change intended.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 block/blk-crypto-fallback.c | 131 +++++++++++++++++++++++-------------
 1 file changed, 85 insertions(+), 46 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index e383444686fc..12b3ca95db26 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -356,81 +356,66 @@ static void __blk_crypto_fallback_encrypt_bio(struct bio *src_bio,
 		struct crypto_sync_skcipher *tfm)
 {
 	struct bio_crypt_ctx *bc = src_bio->bi_crypt_context;
-	int data_unit_size = bc->bc_key->crypto_cfg.data_unit_size;
 	SYNC_SKCIPHER_REQUEST_ON_STACK(ciph_req, tfm);
-	u64 curr_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
-	struct scatterlist src, dst;
-	union blk_crypto_iv iv;
-	unsigned int nr_enc_pages, enc_idx;
+	struct blk_crypto_du_ctx du_ctx;
+	unsigned int nr_enc_pages, enc_idx, nr_new_pages;
 	struct page **enc_pages;
+	struct page *cur_enc_page = NULL;
 	struct bio *enc_bio;
-	unsigned int i;
+	bool reuse_enc_page;
+	unsigned int i, n;
 
 	skcipher_request_set_callback(ciph_req,
 			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 			NULL, NULL);
-
-	memcpy(curr_dun, bc->bc_dun, sizeof(curr_dun));
-	sg_init_table(&src, 1);
-	sg_init_table(&dst, 1);
-
-	skcipher_request_set_crypt(ciph_req, &src, &dst, data_unit_size,
-				   iv.bytes);
+	blk_crypto_du_ctx_init(&du_ctx, ciph_req, bc);
 
 	/*
-	 * Encrypt each page in the source bio.  Because the source bio could
-	 * have bio_vecs that span more than a single page, but the encrypted
-	 * bios are limited to a single page per bio_vec, this can generate
-	 * more than a single encrypted bio per source bio.
+	 * Encrypt each data unit in the source bio.  A data unit is described by
+	 * one bio_vec per page.  Because the encrypted bios are limited to a
+	 * single page per bio_vec, this can generate more than a single
+	 * encrypted bio per source bio.
 	 */
 new_bio:
 	nr_enc_pages = min(bio_segments(src_bio), BIO_MAX_VECS);
 	enc_bio = blk_crypto_alloc_enc_bio(src_bio, nr_enc_pages, &enc_pages);
 	enc_idx = 0;
+	reuse_enc_page = false;
 	for (;;) {
 		struct bio_vec src_bv =
 			bio_iter_iovec(src_bio, src_bio->bi_iter);
-		struct page *enc_page = enc_pages[enc_idx];
 
-		if (!IS_ALIGNED(src_bv.bv_len | src_bv.bv_offset,
-				data_unit_size)) {
+		n = blk_crypto_du_bvecs(src_bio, &src_bio->bi_iter, &du_ctx);
+		if (!n) {
 			enc_bio->bi_status = BLK_STS_INVAL;
 			goto out_free_enc_bio;
 		}
 
-		__bio_add_page(enc_bio, enc_page, src_bv.bv_len,
-				src_bv.bv_offset);
-
-		sg_set_page(&src, src_bv.bv_page, data_unit_size,
-			    src_bv.bv_offset);
-		sg_set_page(&dst, enc_page, data_unit_size, src_bv.bv_offset);
-
 		/*
-		 * Increment the index now that the encrypted page is added to
-		 * the bio.  This is important for the error unwind path.
+		 * The first bio_vec of the data unit reuses the bounce page
+		 * that the previous data unit added for the bio_vec it ended
+		 * in, if any; every other bio_vec needs a bounce page of its
+		 * own.
+		 *
+		 * reuse_enc_page implies nr_new_pages == 0: a data unit that
+		 * reuses a bounce page fits in a single bio_vec, as max_bvecs
+		 * is 1 for data units up to a page (see
+		 * blk_crypto_du_ctx_init()).  A submit therefore only happens
+		 * at a segment boundary and the encrypted bio never extends
+		 * past the encrypted data.
 		 */
-		enc_idx++;
+		nr_new_pages = n - reuse_enc_page;
+		WARN_ON_ONCE(reuse_enc_page && nr_new_pages);
 
 		/*
-		 * Encrypt each data unit in this page.
+		 * Is there room for this data unit in the current encrypted bio?
+		 * (There always is in a newly allocated one.)
 		 */
-		for (i = 0; i < src_bv.bv_len; i += data_unit_size) {
-			blk_crypto_dun_to_iv(curr_dun, &iv);
-			if (crypto_skcipher_encrypt(ciph_req)) {
-				enc_bio->bi_status = BLK_STS_IOERR;
+		if (enc_idx + nr_new_pages > nr_enc_pages) {
+			if (WARN_ON_ONCE(!enc_idx)) {
+				enc_bio->bi_status = BLK_STS_INVAL;
 				goto out_free_enc_bio;
 			}
-			bio_crypt_dun_increment(curr_dun, 1);
-			src.offset += data_unit_size;
-			dst.offset += data_unit_size;
-		}
-
-		bio_advance_iter_single(src_bio, &src_bio->bi_iter,
-				src_bv.bv_len);
-		if (!src_bio->bi_iter.bi_size)
-			break;
-
-		if (enc_idx == nr_enc_pages) {
 			/*
 			 * For each additional encrypted bio submitted,
 			 * increment the source bio's remaining count.  Each
@@ -442,6 +427,60 @@ static void __blk_crypto_fallback_encrypt_bio(struct bio *src_bio,
 			submit_bio(enc_bio);
 			goto new_bio;
 		}
+
+		/*
+		 * Encrypt the data unit, scattering the ciphertext into the
+		 * bounce pages.  The bounce pages mirror the data layout of the
+		 * source bio, so that the encrypted bio can be submitted for the
+		 * same disk location as the source bio.
+		 */
+		sg_init_table(du_ctx.src_sg, n);
+		sg_init_table(du_ctx.dst_sg, n);
+		for (i = 0; i < n; i++) {
+			struct page *enc_page;
+
+			if (!i && reuse_enc_page) {
+				/* Covered by the previous bounce page. */
+				enc_page = cur_enc_page;
+			} else {
+				/*
+				 * A bio_vec that holds more than one data unit
+				 * is added with its whole length; the data
+				 * units that follow it fill in the same bounce
+				 * page before the encrypted bio is submitted.
+				 */
+				enc_page = enc_pages[enc_idx++];
+				__bio_add_page(enc_bio, enc_page, src_bv.bv_len,
+					       src_bv.bv_offset);
+				cur_enc_page = enc_page;
+			}
+
+			sg_set_page(&du_ctx.src_sg[i], du_ctx.bvecs[i].bv_page,
+				    du_ctx.bvecs[i].bv_len,
+				    du_ctx.bvecs[i].bv_offset);
+			sg_set_page(&du_ctx.dst_sg[i], enc_page,
+				    du_ctx.bvecs[i].bv_len,
+				    du_ctx.bvecs[i].bv_offset);
+		}
+
+		/*
+		 * The next data unit starts in the same bio_vec, and thus
+		 * shares the bounce page added above, unless this data unit
+		 * reaches the end of the bio_vec it is in.  A page can be
+		 * covered by several bio_vecs, so the sharing is per bio_vec,
+		 * not per page.
+		 */
+		reuse_enc_page = n == 1 && src_bv.bv_len > du_ctx.du_size;
+
+		if (blk_crypto_crypt_du(&du_ctx, true)) {
+			enc_bio->bi_status = BLK_STS_IOERR;
+			goto out_free_enc_bio;
+		}
+
+		bio_advance_iter_single(src_bio, &src_bio->bi_iter,
+					du_ctx.du_size);
+		if (!src_bio->bi_iter.bi_size)
+			break;
 	}
 
 	submit_bio(enc_bio);
-- 
2.43.7


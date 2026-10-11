Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9643446A7;
	Sun, 11 Oct 2026 17:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791738652; cv=none; b=cAStKwdz4pnbLJDcYrcweVifQ/ETa01kWJuxt5jcxFvODVJb/Zeg+zR7fdanJoYN5bIWlL2neKtdtqkpyKf9E+J/mCMtABc9/ZsqmIt9/i1zUnWRKt0twN+QcggbugzXkDwiIv2a5GCO5SmigEhR52lm/wx+a9f1rJ7F/5xlD8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791738652; c=relaxed/simple;
	bh=scCPh8hzgmlUEUp0VM6MLiK+IRR9VLQ29h+XCDXbwtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaSeybmRl4Mq9l+OKegn8I1mLzVeiLkHTLx6Y4hUEUkWQfjgS87QPQdaIoUarNIp7hcS4Z+dsxS57ldgPe8HEvrYTuDrVB8ew1gi3D8HmrVsY6mSMiFyX9vDMHKswsNpUpzGu1IA09VwoSZlPHsiJs6zrR+PFQLj4Tdm+bDPDko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=K8i0atPF; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="K8i0atPF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791738636; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=FGZioYElgQwlF5wKU0pTD5IQle+ozZq8Jp7hzC7r9Sg=;
	b=K8i0atPFKnRoHbAqDPOtR6bzjMDc7yt2Jz5mYpOGE1SWZuIAayfz0u9hlTacykbcoNgVL/Jl5XHq3SXoh/NuRI/47xDdr72F68J2wQ3FNL2kriDRtyBopqYt0cPH3gKo02RxJxl41SoPyxUxRCOUq/bmtJ8gsyHnA5LTXD4+OUo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XCYQXVu_1791738633;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCYQXVu_1791738633 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 01:10:34 +0800
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
Subject: [PATCH 06/13] blk-crypto: support data units larger than a page
Date: Mon, 12 Oct 2026 01:09:51 +0800
Message-ID: <20261011170958.1759230-7-libaokun@linux.alibaba.com>
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

blk-crypto-fallback requires each data unit to be contained in a single
bio_vec, and fails a bio with a larger data unit with BLK_STS_INVAL.
fscrypt uses the filesystem block size as its data unit size, so
encrypted files are unusable on filesystems with a block size larger
than the page size; the write failure is silent and loses the data.

Since commit 5acc6f649a68 ("fscrypt: Always use blk-crypto for
contents on block-based filesystems") there is no fs-layer path left.
Fix this by describing a data unit by one bio_vec per page: data units
that fit keep using the bio_vec and the scatterlists in the data unit
context, and larger ones get arrays from the new blk_crypto_du_ctx_pool.

The pool is a mempool backed by a dedicated slab cache, as kmalloc()
would round the element size up to the next power of two.  It is set
up when a key with such a data unit size is first used, and one array
is reused for all data units of a bio.

A data unit must start at a data unit boundary (a page boundary for a
larger one), and the accepted data unit sizes grow to the number of
pages that fit in one encrypted bio, rounded down to a power of two.
An encrypted bio can run out of room before the source bio ends; free
its unused bounce pages with the new blk_crypto_free_enc_pages().

One crypto request per data unit is kept, so the ciphertext of data
units that fit in a page is unchanged, and larger data units produce
the same ciphertext as inline encryption hardware.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 block/blk-crypto-fallback.c | 171 +++++++++++++++++++++++++++++-------
 1 file changed, 140 insertions(+), 31 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 12b3ca95db26..b1b71d1938d1 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -81,10 +81,40 @@ static struct blk_crypto_fallback_keyslot {
 static struct blk_crypto_profile *blk_crypto_fallback_profile;
 static struct workqueue_struct *blk_crypto_wq;
 static mempool_t *blk_crypto_bounce_page_pool;
+static struct kmem_cache *blk_crypto_du_ctx_cache;
+static mempool_t *blk_crypto_du_ctx_pool;
 static struct bio_set enc_bio_set;
 
-/* Data unit sizes blk-crypto-fallback can en/decrypt. */
-#define BLK_CRYPTO_FALLBACK_DU_MASK	GENMASK(PAGE_SHIFT, SECTOR_SHIFT)
+/*
+ * The maximum number of pages a data unit may span: the largest power of
+ * two that fits in one encrypted bio.  An encrypted bio holds at most
+ * BIO_MAX_VECS bio_vecs, and a data unit can need one more bio_vec than
+ * the pages it spans when a bio_vec boundary splits it.
+ */
+#define BLK_CRYPTO_DU_MAX_PAGES		BIT(ilog2(BIO_MAX_VECS - 1))
+
+/*
+ * Data unit sizes that blk-crypto-fallback can en/decrypt: at least a
+ * sector, and small enough that the bio_vecs of a data unit fit in one
+ * encrypted bio.
+ */
+#define BLK_CRYPTO_FALLBACK_DU_MASK \
+	GENMASK(ilog2(BLK_CRYPTO_DU_MAX_PAGES * PAGE_SIZE), SECTOR_SHIFT)
+
+/*
+ * Number of scratch buffers to keep around: mempool_alloc() only uses them
+ * when the page allocator fails, so this is the number of bios that can
+ * still make progress when memory is short.
+ */
+#define BLK_CRYPTO_DU_CTX_POOL_SIZE	8
+
+/*
+ * Size of one blk_crypto_du_ctx_pool allocation: the bio_vecs of the largest
+ * data unit, and a scatterlist for each side of the crypto request.
+ */
+#define BLK_CRYPTO_DU_CTX_SIZE \
+	((BLK_CRYPTO_DU_MAX_PAGES + 1) * \
+	(sizeof(struct bio_vec) + 2 * sizeof(struct scatterlist)))
 
 /*
  * This is the key we set when evicting a keyslot. This *should* be the all 0's
@@ -144,6 +174,17 @@ static const struct blk_crypto_ll_ops blk_crypto_fallback_ll_ops = {
 	.keyslot_evict          = blk_crypto_fallback_keyslot_evict,
 };
 
+static void blk_crypto_free_enc_pages(struct page **pages, unsigned int nr)
+{
+	unsigned int i;
+
+	if (!nr)
+		return;
+	i = mempool_free_bulk(blk_crypto_bounce_page_pool, (void **)pages, nr);
+	if (i < nr)
+		release_pages(pages + i, nr - i);
+}
+
 static void blk_crypto_fallback_encrypt_endio(struct bio *enc_bio)
 {
 	struct bio *src_bio = enc_bio->bi_private;
@@ -158,10 +199,7 @@ static void blk_crypto_fallback_encrypt_endio(struct bio *enc_bio)
 	bio_for_each_bvec_all(bv, enc_bio, i)
 		pages[i] = bv->bv_page;
 
-	i = mempool_free_bulk(blk_crypto_bounce_page_pool, (void **)pages,
-			enc_bio->bi_vcnt);
-	if (i < enc_bio->bi_vcnt)
-		release_pages(pages + i, enc_bio->bi_vcnt - i);
+	blk_crypto_free_enc_pages(pages, enc_bio->bi_vcnt);
 
 	if (enc_bio->bi_status)
 		cmpxchg(&src_bio->bi_status, 0, enc_bio->bi_status);
@@ -251,6 +289,8 @@ struct blk_crypto_du_ctx {
 	struct bio_vec		stack_bvec;
 	/* Backing store for src_sg and dst_sg, one entry each. */
 	struct scatterlist	stack_sgs[2];
+	/* Backing store for bvecs and the scatterlists, if not on the stack. */
+	void			*pool_buf;
 
 	/* The data unit size in bytes. */
 	unsigned int		du_size;
@@ -269,6 +309,11 @@ struct blk_crypto_du_ctx {
 	u64			curr_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
 };
 
+/*
+ * Prepare @du_ctx for the data unit of @bc's key.  A data unit that needs
+ * more than one bio_vec gets its arrays from blk_crypto_du_ctx_pool instead
+ * of the ones in @du_ctx; that never fails, as the pool is a mempool.
+ */
 static void blk_crypto_du_ctx_init(struct blk_crypto_du_ctx *du_ctx,
 				   struct skcipher_request *ciph_req,
 				   const struct bio_crypt_ctx *bc)
@@ -277,10 +322,27 @@ static void blk_crypto_du_ctx_init(struct blk_crypto_du_ctx *du_ctx,
 	du_ctx->du_size = bc->bc_key->crypto_cfg.data_unit_size;
 	memcpy(du_ctx->curr_dun, bc->bc_dun, sizeof(bc->bc_dun));
 
-	du_ctx->max_bvecs = 1;
-	du_ctx->bvecs = &du_ctx->stack_bvec;
-	du_ctx->src_sg = &du_ctx->stack_sgs[0];
-	du_ctx->dst_sg = &du_ctx->stack_sgs[1];
+	if (du_ctx->du_size <= PAGE_SIZE) {
+		du_ctx->max_bvecs = 1;
+		du_ctx->bvecs = &du_ctx->stack_bvec;
+		du_ctx->src_sg = &du_ctx->stack_sgs[0];
+		du_ctx->dst_sg = &du_ctx->stack_sgs[1];
+		du_ctx->pool_buf = NULL;
+	} else {
+		/* blk_crypto_fallback_bio_prep() checks the pool is set up. */
+		du_ctx->max_bvecs = PFN_UP(du_ctx->du_size) + 1;
+		du_ctx->pool_buf = mempool_alloc(blk_crypto_du_ctx_pool,
+						 GFP_NOIO);
+		du_ctx->bvecs = du_ctx->pool_buf;
+		du_ctx->src_sg = du_ctx->pool_buf +
+				 du_ctx->max_bvecs * sizeof(*du_ctx->bvecs);
+		du_ctx->dst_sg = du_ctx->src_sg + du_ctx->max_bvecs;
+	}
+}
+
+static void blk_crypto_du_ctx_exit(struct blk_crypto_du_ctx *du_ctx)
+{
+	mempool_free(du_ctx->pool_buf, blk_crypto_du_ctx_pool);
 }
 
 /*
@@ -372,9 +434,9 @@ static void __blk_crypto_fallback_encrypt_bio(struct bio *src_bio,
 
 	/*
 	 * Encrypt each data unit in the source bio.  A data unit is described by
-	 * one bio_vec per page.  Because the encrypted bios are limited to a
-	 * single page per bio_vec, this can generate more than a single
-	 * encrypted bio per source bio.
+	 * one bio_vec per page, and may span more than a single page.  Because
+	 * the encrypted bios are limited to a single page per bio_vec, this can
+	 * generate more than a single encrypted bio per source bio.
 	 */
 new_bio:
 	nr_enc_pages = min(bio_segments(src_bio), BIO_MAX_VECS);
@@ -416,6 +478,8 @@ static void __blk_crypto_fallback_encrypt_bio(struct bio *src_bio,
 				enc_bio->bi_status = BLK_STS_INVAL;
 				goto out_free_enc_bio;
 			}
+			blk_crypto_free_enc_pages(enc_pages + enc_idx,
+						  nr_enc_pages - enc_idx);
 			/*
 			 * For each additional encrypted bio submitted,
 			 * increment the source bio's remaining count.  Each
@@ -444,14 +508,18 @@ static void __blk_crypto_fallback_encrypt_bio(struct bio *src_bio,
 				enc_page = cur_enc_page;
 			} else {
 				/*
-				 * A bio_vec that holds more than one data unit
-				 * is added with its whole length; the data
-				 * units that follow it fill in the same bounce
-				 * page before the encrypted bio is submitted.
+				 * The whole bio_vec is added for the first
+				 * bio_vec of a data unit; the data units that
+				 * follow it fill in the same bounce page
+				 * before the encrypted bio is submitted.
 				 */
+				unsigned int len = i ? du_ctx.bvecs[i].bv_len :
+						      src_bv.bv_len;
+				unsigned int off = i ? du_ctx.bvecs[i].bv_offset :
+						      src_bv.bv_offset;
+
 				enc_page = enc_pages[enc_idx++];
-				__bio_add_page(enc_bio, enc_page, src_bv.bv_len,
-					       src_bv.bv_offset);
+				__bio_add_page(enc_bio, enc_page, len, off);
 				cur_enc_page = enc_page;
 			}
 
@@ -477,24 +545,20 @@ static void __blk_crypto_fallback_encrypt_bio(struct bio *src_bio,
 			goto out_free_enc_bio;
 		}
 
-		bio_advance_iter_single(src_bio, &src_bio->bi_iter,
-					du_ctx.du_size);
+		/* A data unit can span several bio_vecs, e.g. for direct I/O. */
+		bio_advance_iter(src_bio, &src_bio->bi_iter, du_ctx.du_size);
 		if (!src_bio->bi_iter.bi_size)
 			break;
 	}
 
+	blk_crypto_du_ctx_exit(&du_ctx);
+	blk_crypto_free_enc_pages(enc_pages + enc_idx, nr_enc_pages - enc_idx);
 	submit_bio(enc_bio);
 	return;
 
 out_free_enc_bio:
-	/*
-	 * Add the remaining pages to the bio so that the normal completion path
-	 * in blk_crypto_fallback_encrypt_endio frees them.  The exact data
-	 * layout does not matter for that, so don't bother iterating the source
-	 * bio.
-	 */
-	for (; enc_idx < nr_enc_pages; enc_idx++)
-		__bio_add_page(enc_bio, enc_pages[enc_idx], PAGE_SIZE, 0);
+	blk_crypto_du_ctx_exit(&du_ctx);
+	blk_crypto_free_enc_pages(enc_pages + enc_idx, nr_enc_pages - enc_idx);
 	bio_endio(enc_bio);
 }
 
@@ -557,9 +621,11 @@ static blk_status_t __blk_crypto_fallback_decrypt_bio(struct bio *bio,
 			break;
 		}
 
-		bio_advance_iter_single(bio, &iter, du_ctx.du_size);
+		/* A data unit can span several bio_vecs, e.g. for direct I/O. */
+		bio_advance_iter(bio, &iter, du_ctx.du_size);
 	}
 
+	blk_crypto_du_ctx_exit(&du_ctx);
 	return status;
 }
 
@@ -650,6 +716,18 @@ bool blk_crypto_fallback_bio_prep(struct bio *bio)
 		bio_endio_status(bio, BLK_STS_NOTSUPP);
 		return false;
 	}
+	if (WARN_ON_ONCE(!(BLK_CRYPTO_FALLBACK_DU_MASK &
+			   bc->bc_key->crypto_cfg.data_unit_size))) {
+		/* The key was set up for a data unit the fallback can't handle. */
+		bio_endio_status(bio, BLK_STS_NOTSUPP);
+		return false;
+	}
+	if (WARN_ON_ONCE(bc->bc_key->crypto_cfg.data_unit_size > PAGE_SIZE &&
+			 !blk_crypto_du_ctx_pool)) {
+		/* The key was set up without the scratch space it needs. */
+		bio_io_error(bio);
+		return false;
+	}
 
 	if (bio_data_dir(bio) == WRITE) {
 		blk_crypto_fallback_encrypt_bio(bio);
@@ -765,7 +843,9 @@ static int blk_crypto_fallback_init(void)
 /*
  * Prepare blk-crypto-fallback for the specified crypto configuration.
  * Returns -EOPNOTSUPP if the fallback can't handle the data unit size of the
- * configuration, or -ENOPKG if the needed crypto API support is missing.
+ * configuration, -ENOPKG if the needed crypto API support is missing, or
+ * -ENOMEM if the scratch space for a data unit larger than a page can't be
+ * allocated.
  */
 int blk_crypto_fallback_start_using_key(const struct blk_crypto_config *cfg)
 {
@@ -781,6 +861,35 @@ int blk_crypto_fallback_start_using_key(const struct blk_crypto_config *cfg)
 		return -EOPNOTSUPP;
 	}
 
+	/*
+	 * A data unit that needs more than one bio_vec, e.g. a data unit that
+	 * is larger than a page, gets its data unit context from this pool.
+	 * Set the pool up before the fast path below, which can't create it.
+	 */
+	if (cfg->data_unit_size > PAGE_SIZE) {
+		mutex_lock(&tfms_init_lock);
+		if (!blk_crypto_du_ctx_pool) {
+			blk_crypto_du_ctx_cache =
+				kmem_cache_create("blk_crypto_du_ctx",
+						  BLK_CRYPTO_DU_CTX_SIZE,
+						  0, 0, NULL);
+			if (!blk_crypto_du_ctx_cache) {
+				mutex_unlock(&tfms_init_lock);
+				return -ENOMEM;
+			}
+			blk_crypto_du_ctx_pool =
+				mempool_create_slab_pool(BLK_CRYPTO_DU_CTX_POOL_SIZE,
+							 blk_crypto_du_ctx_cache);
+			if (!blk_crypto_du_ctx_pool) {
+				kmem_cache_destroy(blk_crypto_du_ctx_cache);
+				blk_crypto_du_ctx_cache = NULL;
+				mutex_unlock(&tfms_init_lock);
+				return -ENOMEM;
+			}
+		}
+		mutex_unlock(&tfms_init_lock);
+	}
+
 	/*
 	 * Fast path
 	 * Ensure that updates to blk_crypto_keyslots[i].tfms[mode_num]
-- 
2.43.7


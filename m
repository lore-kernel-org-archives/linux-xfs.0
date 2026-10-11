Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34E8367294;
	Sun, 11 Oct 2026 17:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791738644; cv=none; b=UYPYg0ATVwehRy+0F6exljFxQegr2I9w3amTfTVU5ahCwF8cPiqyAlmIwnsJfkN57ivteTFVIBwRdMdinvlwQvvegIO5z78lWu7yj7/HwE5LwFGYYblRvxcGXUZVL1Z/I7nW+fytuOeSKxf9uHpjji/mM+xRNuemOzGF3SAzAjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791738644; c=relaxed/simple;
	bh=x3Dgq4X0PM2YmnXfH0y8DwMX3irJOrJ9HYMIT6Ay8T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMy9DiHqOxDWCVyNwigV0f4A/GbrefybARtBwJ9dDMDNAxHwMqAWCSqOSP2+95E3bgZuQbkjXccihVlTDm+teHS8o0GsfO4jMYGJSOlqgQr5JlxxvNcZYPIGk7LQlk7F8XTtmwp1XQHIMa5yuN0hdjGGaWOm+E5UX6RYe19TnFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Wuz9ZXjm; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Wuz9ZXjm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791738632; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=nBhanbOxipeWhOLIUcLgBKRwVJqd42j4Hhe68hi0EXA=;
	b=Wuz9ZXjmv/Bwl/FpoMFYWAM561GrxvHvSzpciCzRl+vVi+ktUMnNn9sz6bYZGO/RPKMxJ9ZeZi72NBs8IjQh7BrnS4mDv6VyiHxOFZB7+U0D6JROkahzy6UTz9pjvdEqjVanKFysyTie0LrpJJqOgfFdM+EQupfkBgjBenSDi80=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XCYQXUq_1791738629;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCYQXUq_1791738629 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 01:10:30 +0800
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
Subject: [PATCH 03/13] blk-crypto: reject fallback data unit sizes it can't handle
Date: Mon, 12 Oct 2026 01:09:48 +0800
Message-ID: <20261011170958.1759230-4-libaokun@linux.alibaba.com>
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

blk-crypto-fallback en/decrypts a data unit that fits in one page:
the encryption and the decryption path both require the data unit
to be contained in a single page-clamped bio_vec.

However, the fallback advertises support for all data unit sizes
(modes_supported[] is 0xFFFFFFFF), and blk_crypto_start_using_key()
never checks the fallback's capabilities, so a key with a larger data
unit size is accepted, and fails with BLK_STS_INVAL on the first I/O:

  EXT4-fs warning (device vdc): ext4_end_bio:360:
	I/O error 19 writing to inode 15 starting block 70136)
  EXT4-fs (vdc): failed to convert unwritten extents to written extents
	-- potential data loss!  (inode 15, error -5)

where error 19 is BLK_STS_INVAL.  Such keys exist on filesystems whose
block size is larger than the page size, because fscrypt uses the block
size as its data unit size by default.

Fix this by advertising only the data unit sizes that the fallback
really supports, and by rejecting keys that the fallback can't handle in
blk_crypto_fallback_start_using_key(), so that the failure happens when
the key is set up instead of during I/O, and before any data is written.

Fixes: 488f6682c832 ("block: blk-crypto-fallback for Inline Encryption")
Cc: stable@vger.kernel.org
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 block/blk-crypto-fallback.c | 20 ++++++++++++++++----
 block/blk-crypto-internal.h |  4 ++--
 block/blk-crypto.c          | 14 +++++++-------
 3 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 2a8f40a65158..a75daadba4c8 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -83,6 +83,9 @@ static struct workqueue_struct *blk_crypto_wq;
 static mempool_t *blk_crypto_bounce_page_pool;
 static struct bio_set enc_bio_set;
 
+/* Data unit sizes blk-crypto-fallback can en/decrypt. */
+#define BLK_CRYPTO_FALLBACK_DU_MASK	GENMASK(PAGE_SHIFT, SECTOR_SHIFT)
+
 /*
  * This is the key we set when evicting a keyslot. This *should* be the all 0's
  * key, but AES-XTS rejects that key, so we use some random bytes instead.
@@ -561,7 +564,8 @@ static int blk_crypto_fallback_init(void)
 
 	/* All blk-crypto modes have a crypto API fallback. */
 	for (i = 0; i < BLK_ENCRYPTION_MODE_MAX; i++)
-		blk_crypto_fallback_profile->modes_supported[i] = 0xFFFFFFFF;
+		blk_crypto_fallback_profile->modes_supported[i] =
+			BLK_CRYPTO_FALLBACK_DU_MASK;
 	blk_crypto_fallback_profile->modes_supported[BLK_ENCRYPTION_MODE_INVALID] = 0;
 
 	blk_crypto_wq = alloc_workqueue("blk_crypto_wq",
@@ -612,16 +616,24 @@ static int blk_crypto_fallback_init(void)
 }
 
 /*
- * Prepare blk-crypto-fallback for the specified crypto mode.
- * Returns -ENOPKG if the needed crypto API support is missing.
+ * Prepare blk-crypto-fallback for the specified crypto configuration.
+ * Returns -EOPNOTSUPP if the fallback can't handle the data unit size of the
+ * configuration, or -ENOPKG if the needed crypto API support is missing.
  */
-int blk_crypto_fallback_start_using_mode(enum blk_crypto_mode_num mode_num)
+int blk_crypto_fallback_start_using_key(const struct blk_crypto_config *cfg)
 {
+	enum blk_crypto_mode_num mode_num = cfg->crypto_mode;
 	const char *cipher_str = blk_crypto_modes[mode_num].cipher_str;
 	struct blk_crypto_fallback_keyslot *slotp;
 	unsigned int i;
 	int err = 0;
 
+	if (!(BLK_CRYPTO_FALLBACK_DU_MASK & cfg->data_unit_size)) {
+		pr_warn_ratelimited("can't handle data unit size %u\n",
+				    cfg->data_unit_size);
+		return -EOPNOTSUPP;
+	}
+
 	/*
 	 * Fast path
 	 * Ensure that updates to blk_crypto_keyslots[i].tfms[mode_num]
diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index 2c7a0446572a..640527ed05eb 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -219,14 +219,14 @@ bool blk_crypto_fallback_bio_prep(struct bio *bio);
 
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK
 
-int blk_crypto_fallback_start_using_mode(enum blk_crypto_mode_num mode_num);
+int blk_crypto_fallback_start_using_key(const struct blk_crypto_config *cfg);
 
 int blk_crypto_fallback_evict_key(const struct blk_crypto_key *key);
 
 #else /* CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK */
 
 static inline int
-blk_crypto_fallback_start_using_mode(enum blk_crypto_mode_num mode_num)
+blk_crypto_fallback_start_using_key(const struct blk_crypto_config *cfg)
 {
 	pr_warn_once("crypto API fallback is disabled\n");
 	return -ENOPKG;
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index bc3a9f59574b..5c670c3e65c5 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -392,13 +392,13 @@ bool blk_crypto_config_supported_natively(struct block_device *bdev,
  * @key: A key to use on the device
  *
  * Upper layers must call this function to ensure that either the hardware
- * supports the key's crypto settings, or the crypto API fallback has transforms
- * for the needed mode allocated and ready to go. This function may allocate
- * an skcipher, and *should not* be called from the data path, since that might
- * cause a deadlock
+ * supports the key's crypto settings, or that the crypto API fallback is ready
+ * to handle them. This function may allocate an skcipher, and *should not* be
+ * called from the data path, since that might cause a deadlock
  *
- * Return: 0 on success; -EOPNOTSUPP if the key is wrapped but the hardware does
- *	   not support wrapped keys; -ENOPKG if the key is a raw key but the
+ * Return: 0 on success; -EOPNOTSUPP if the key can't be used on @bdev, e.g. a
+ *	   wrapped key without hardware support or a data unit size that the
+ *	   fallback can't handle; -ENOPKG if the key is a raw key but the
  *	   hardware does not support raw keys and blk-crypto-fallback is either
  *	   disabled or the needed algorithm is disabled in the crypto API; or
  *	   another -errno code if something else went wrong.
@@ -412,7 +412,7 @@ int blk_crypto_start_using_key(struct block_device *bdev,
 		pr_warn_ratelimited("%pg: no support for wrapped keys\n", bdev);
 		return -EOPNOTSUPP;
 	}
-	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
+	return blk_crypto_fallback_start_using_key(&key->crypto_cfg);
 }
 EXPORT_SYMBOL_GPL(blk_crypto_start_using_key);
 
-- 
2.43.7


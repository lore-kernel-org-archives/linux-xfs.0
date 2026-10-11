Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69E2331A65;
	Sun, 11 Oct 2026 17:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791738653; cv=none; b=eKL67uK5Pil0f2+wvgVC/zHfFd28q+yXU4fZ/7yM6kKZk8Bk7kUarGGQYWiGuxeJWixoRv6bsUj4Rrpr6esKJWQcZNrGW80dihlA/PXqdQKe8r18QgIJgz3odk3pRjc2owU25rrMywJdPvFG18jhqHbx/p1smN24zbGGlkjGdA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791738653; c=relaxed/simple;
	bh=FluD6Fm7v4QRIHYMNZUfOV5wqeao5V/7DkSkbX1EzJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrU8B4Go8SPFg+NJ9UBpz5HEbagI5bSSDYMgnp4D02phJAnsmolM66XE2uB286Z4dhu9s4tzCW0HySZ9XNO/7CW+uKzcH0f8p+BY4grQhnbQ1pFRFIJ4jInvKewqaR8NfvurNxTExBHANpneZEMSuIdKAGILUxGWt6l82UgNvkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=rJ4nUMe/; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="rJ4nUMe/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791738643; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=vmr7x+Zm7qZjzUGVGWQKrQf/gJyxLirdgMgUlTrZnug=;
	b=rJ4nUMe/xG95bHQFTvPbNeSG96hSBYV0Tv5tt0PQCTniIr0U8HBZaI5TYaOE66lMsUw9GyOPVs4bQURU+HIWh2fVPcUMljb6gt+vbTJ59PtR45co8jNDWbWTRkgapi18OpYuhZ2hNqj0MwgfE6wveEyEn2jo5qUBBLXj60tDTfc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XCYQXXn_1791738640;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCYQXXn_1791738640 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 01:10:41 +0800
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
Subject: [PATCH 11/13] ext4: allow encryption with a block size larger than the page size
Date: Mon, 12 Oct 2026 01:09:56 +0800
Message-ID: <20261011170958.1759230-12-libaokun@linux.alibaba.com>
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

ext4 refuses encryption when the block size is larger than the page
size, both at mount time and on a mounted filesystem, and refuses to
load an existing encrypted inode.  The checks exist because such a
block size needs folios that cover a whole block, while file contents
were encrypted page by page in the fs-layer path, which cannot handle a
folio that covers several data units.

Since commit 5acc6f649a68 ("fscrypt: Always use blk-crypto for contents
on block-based filesystems") file contents are always encrypted through
blk-crypto, and after the adaptations in the preceding patches, both
inline encryption hardware and blk-crypto-fallback support data units
larger than a page, so the checks can be removed.

Encrypted filesystems still keep their folio order at s_min_folio_order;
allowing large folios needs additional work and will be enabled later.

Performance:

Hardware: 96-core machine, 3.84T NVMe, 512G memory
Filesystem: ext4, encryption on the fallback path

Buffered sequential 1M writes and reads (1G, fsync) in MiB/s; medians
of 3 runs.

  job          4k plain      4k enc    32k plain    32k enc    4k->32k
  ---------    --------    --------    ---------    -------    -------
  seqwrite         1981        1044         2062       1399       +34%
  seqread          1139         931         1791       1793       +93%

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/crypto.c |  9 ---------
 fs/ext4/inode.c  |  6 ------
 fs/ext4/super.c  | 25 +++----------------------
 3 files changed, 3 insertions(+), 37 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 318b2eaea741..1a0fccb084ef 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -156,15 +156,6 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	if (ext4_test_inode_flag(inode, EXT4_INODE_DAX))
 		return -EOPNOTSUPP;
 
-	/*
-	 * Encryption is not supported when the block size is larger
-	 * than the page size.  This is rejected at mount time by
-	 * ext4_check_large_folio(), and this check here is for the case
-	 * when the 'encrypt' feature is enabled on a mounted filesystem.
-	 */
-	if (inode->i_sb->s_blocksize > PAGE_SIZE)
-		return -EOPNOTSUPP;
-
 	res = ext4_convert_inline_data(inode);
 	if (res)
 		return res;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 31248fef8bce..26f0f9714f03 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5671,12 +5671,6 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		ret = -EFSCORRUPTED;
 		goto bad_inode;
 	}
-	if (IS_ENCRYPTED(inode) && sb->s_blocksize > PAGE_SIZE) {
-		ext4_error_inode(inode, function, line, 0,
-				 "encrypted inode with block size larger than page size");
-		ret = -EFSCORRUPTED;
-		goto bad_inode;
-	}
 
 	ext4_set_inode_mapping_order(inode);
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bca0dc87d0b7..9cd5b7445a27 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5116,30 +5116,13 @@ static void ext4_set_max_mapping_order(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
-	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
+	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA ||
+	    ext4_has_feature_encrypt(sb))
 		sbi->s_max_folio_order = sbi->s_min_folio_order;
 	else
 		sbi->s_max_folio_order = EXT4_MAX_PAGECACHE_ORDER(sb);
 }
 
-static int ext4_check_large_folio(struct super_block *sb)
-{
-	const char *err_str = NULL;
-
-	if (ext4_has_feature_encrypt(sb))
-		err_str = "encrypt";
-
-	if (!err_str) {
-		ext4_set_max_mapping_order(sb);
-	} else if (sb->s_blocksize > PAGE_SIZE) {
-		ext4_msg(sb, KERN_ERR, "bs(%lu) > ps(%lu) unsupported for %s",
-			 sb->s_blocksize, PAGE_SIZE, err_str);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int ext4_load_super(struct super_block *sb, ext4_fsblk_t *lsb,
 			   int silent)
 {
@@ -5418,9 +5401,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 
 	ext4_apply_options(fc, sb);
 
-	err = ext4_check_large_folio(sb);
-	if (err < 0)
-		goto failed_mount;
+	ext4_set_max_mapping_order(sb);
 
 	err = ext4_encoding_init(sb, es);
 	if (err)
-- 
2.43.7


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138326;
	b=DBcGmDGKJD46mj7bOE5ReaCqw9dzak95lQX7+Aoy+If+BAR+5I31VF6p+3Wh7LRNrqG3
	 bss+IvWu4YoLFjfX5tOqA3gYoBjg6WjPSSI8wXetEQO7zGpwZgVz/0smfk5P/LiuGPt++
	 euXwxm/6f42yGNnKgBp3ra/FWOd9ijyV9C7Nliiym+MevPORjw93yRYq8GlG9TWfZz1dU
	 g6WfSZuQBU2TTwQthxPymqQsWnYzhAV6vHGaxEQ4usbfN3KP+fNA6ziKCsXQSuEBd+ehG
	 THxaZkhTXtqEHA28F1fIJf4AkQRp3EhGcsE7SkjmIC+8asoJg/LhHTTObYDHiA9utpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138326;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y7sCnlpRLrhOsR6HPXaL5m4FKnvW46aWOz+lEyc4mfA=;
	b=hJ1c8Wx00o7xEz5AY529StAOoQWeIijtcj3pjz0Uq8U2JFFAoWZ8gdDfCg9dxToJdJ/m
	 my/F2KL3t+D0Jh4h2wJg4rQW6EEitPbOFZTSh4AuA6RsZrN7lqS91MTxba2Zhs+CwNwsO
	 Y8CiEmw990qbBuKJp3uVcxkx2ZzIHLxvH2KDxWYgWvAhhHdm26aHmkr29OSNf1T5U/gWL
	 0xu5DrpuhnAuQIibmv2Fw2M4xJy1kcvK6ff6Np2wcyhlmNE7XZRkWA1/6TTxgDb4pPFtQ
	 FbRzdxDf20y9uJFfoubWvI16LBNOzI4KKuiimnrSGYPIAG+EmxcejjRmzXLgkalwNeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q+fdV74u;
	arc=none smtp.remote-ip=209.85.128.177
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAA5606A324
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 21:58:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBAA5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q+fdV74u
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b0f59a5fdeso3039877b3.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 14:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793138324; x=1793743124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y7sCnlpRLrhOsR6HPXaL5m4FKnvW46aWOz+lEyc4mfA=;
        b=q+fdV74u6Qi/OEzTm1dbwn+gfMQD8x4XlQQvuvsaOwV8ltkZpbjCFYRniCvQdpUgSL
         v38xoNldSre0s1FdjA//GwIhr8yQR73iputTRfGgIAurHZb//VqmY8DFQ2t0ci/TYoNL
         vxAwX5aREUUQLQ0xf0l3xoVXvmFCxHe7at1XrQF6FfZ5zwrz8wQJSdJpt6+ZaMJdN1Jd
         mSFUsS9dH+WTeVljGjbMDfOJf05KovQKGTVW9xagsdJraP7+x+/SJ1FAOwvTG5wXJhY8
         6bJZLcxBVnz7BXt/9tlzg0Ndz8P3SN+ihYfZQ16rSJcmSYO1pWbnTObcHrxP1SxMaLT4
         yX9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793138324; x=1793743124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y7sCnlpRLrhOsR6HPXaL5m4FKnvW46aWOz+lEyc4mfA=;
        b=q2A7ibvxnq0klczaHbCX3dhORC51hVNfKNngBpFIqDaORNPWgcvzzJTyTWVWOf1fiy
         dhuwM1TgwZCm+MjUmh4a2dxV4QhDoramdQCaAlBuiRW+HCl9L0u2dbBI2zEG0sr0XiKK
         pAglqeU9w3DC6XNJDYZIcldAMX4EQ5CMrWfIiOoHQ4udY+0JR69tSKitR6M29sh4l6qc
         +3orjgiCWpCZk7C2RbPkhUIXTrTSIDzC3m+mOkx2QnxxmHNUnpZqDNwiuyCAcVnqQJKw
         O/8i0wzQTHe+spBXduUT948XmBXROu/SrVptizQAY76/ndAv8isCoXHWpUhgYZDgOW/X
         h3kg==
X-Forwarded-Encrypted: i=1; AKwUvBwGDHBj4czxhrn9GMGBeKcuWSM/u+0J6X8PqqzLAOvsBlOLWjwJ6aQe6My6oEJUk2XCMxZFN9xa96U=@vger.kernel.org
X-Gm-Message-State: AFq9FYKDa7KYDKp/DYvs2Dp9DM9AEh1QASqYloKaQEpUqLrmcgqIvnY5
	B8Ec4NIE+ENrAse0BxEB8wBgou0LjiZ3NmWoLtQz2+kyDqSTC6DOst6/
X-Gm-Gg: AYBFou2t+mBhQQ6tAlbrCHA/BTnVRfo2NhnMyeQMcTPMPXUcCEdsb+HRIjiKEHa2Kyo
	hX7mSQmweA8e/sEB3R7Qtf6WhI9lFpjbw3S/RlwcvXxRLTvI5CsLtMvBpAo75PcjVpkC+mLKlvn
	/DnlgHpCEN5h0NBeGD3+55kygqKnL96iADp5qRAl6PEu31IqYtmRw8TnH4px81syIuj/Ep16IVl
	LsIyFPMQsPrkJY51BkVl6fjJXZIUMUpXWMVrDlcJXEoBhCKTdUFjyns7EkRF3MrstKKUfzKhjfx
	Hz4qi8ksbdj3wxFUzaJmTn8c59cp293dX3G4slKFSkGMCISbemF494ZQUHRWQGELvMxC4s0iwRY
	Wgn4Q+hMrfz5t4ltVJmg6p9cviQxls0m4fcJGUDAeMYyf1D6yXAT8ic8mhSLvA5rjYZtJnk8Ry0
	9Q//mGpeMF1CETxm20gZ5uirPjQAKJXAxrOYEUUio25J5EzZLLiJKn8BychdY1xlsVnstmB2KBQ
	Fb2UFYl2RY8PA0e7G/jKR7NZ1exsy/XF13/gQ8l2ViwxVtx87X7G3YpzC5IZJlvo7NIfv62atAN
	Endw1HC+nHWDCvYgRFkbeP7nMktx5j/EnxE/ZjwKDjGhqjI5ujbZ8A==
X-Received: by 2002:a05:690c:113:b0:89b:6e01:b805 with SMTP id 00721157ae682-8b1b5d4bfd3mr3166947b3.57.1793138323169;
        Tue, 27 Oct 2026 14:58:43 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:70::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e2bd279sm18904617b3.0.2026.10.27.14.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:58:42 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>
Subject: [PATCH 4/5] iomap: pass iomap_iter_next_fn directly instead of struct iomap_ops
Date: Tue, 27 Oct 2026 14:53:25 -0700
Message-ID: <20261027215326.2693300-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261027215326.2693300-1-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that all filesystems implement ->iomap_next() and the legacy
->iomap_begin()/->iomap_end() fallback is gone, struct iomap_ops only
wraps a single iomap_next function pointer. Drop the struct entirely and
pass the iomap_iter_next_fn directly to iomap_iter() and all the
iomap/dax entry points. Filesystems pass their iomap_iter_next_fn
callback directly instead of an ops struct. Several iomap_iter_next_fn
callbacks become non-static and gain header declarations since callers
now reference them directly.

The iomap_iter tracepoint's ops field is renamed to next to match. These
tracepoints are explicitly not stable ABI (see the note in iomap/trace.h).

No functional change intended other than the tracepoint field rename
noted above.

Acked-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 block/fops.c           | 10 ++-----
 fs/btrfs/direct-io.c   |  8 ++----
 fs/dax.c               | 48 ++++++++++++++++----------------
 fs/erofs/data.c        | 28 ++++++++-----------
 fs/erofs/internal.h    |  3 +-
 fs/erofs/zmap.c        |  7 +----
 fs/exfat/file.c        | 14 +++++-----
 fs/exfat/inode.c       |  6 ++--
 fs/exfat/iomap.c       | 22 ++++-----------
 fs/exfat/iomap.h       |  6 ++--
 fs/ext2/ext2.h         |  3 +-
 fs/ext2/file.c         |  4 +--
 fs/ext2/inode.c        |  9 ++----
 fs/ext4/ext4.h         | 10 ++++---
 fs/ext4/extents.c      |  8 ++----
 fs/ext4/file.c         | 22 +++++++--------
 fs/ext4/inode.c        | 58 ++++++++++++---------------------------
 fs/f2fs/data.c         |  6 +---
 fs/f2fs/f2fs.h         |  3 +-
 fs/f2fs/file.c         |  4 +--
 fs/fuse/dax.c          | 10 ++-----
 fs/fuse/ext_map.c      | 10 ++-----
 fs/fuse/file.c         | 10 ++-----
 fs/fuse/virtio_fs.c    |  3 +-
 fs/gfs2/aops.c         |  6 ++--
 fs/gfs2/bmap.c         |  9 ++----
 fs/gfs2/bmap.h         |  2 +-
 fs/gfs2/file.c         |  6 ++--
 fs/gfs2/inode.c        |  6 ++--
 fs/hpfs/file.c         |  6 +---
 fs/internal.h          |  1 -
 fs/iomap/buffered-io.c | 40 +++++++++++++--------------
 fs/iomap/direct-io.c   |  8 +++---
 fs/iomap/fiemap.c      |  8 +++---
 fs/iomap/iter.c        |  9 +++---
 fs/iomap/seek.c        |  8 +++---
 fs/iomap/swapfile.c    |  4 +--
 fs/iomap/trace.h       | 12 ++++----
 fs/nilfs2/file.c       |  2 +-
 fs/nilfs2/iomap.c      |  6 +---
 fs/nilfs2/iomap.h      |  4 ++-
 fs/ntfs/aops.c         |  6 ++--
 fs/ntfs/file.c         | 20 +++++++-------
 fs/ntfs/inode.c        |  2 +-
 fs/ntfs/iomap.c        | 42 ++++++----------------------
 fs/ntfs/iomap.h        | 10 +++----
 fs/ntfs3/file.c        | 16 +++++------
 fs/ntfs3/inode.c       | 13 +++------
 fs/ntfs3/ntfs_fs.h     |  3 +-
 fs/remap_range.c       |  6 ++--
 fs/xfs/xfs_aops.c      |  8 +++---
 fs/xfs/xfs_file.c      | 53 ++++++++++++++++++------------------
 fs/xfs/xfs_iomap.c     | 55 ++++++++-----------------------------
 fs/xfs/xfs_iomap.h     | 16 +++++------
 fs/xfs/xfs_iops.c      |  4 +--
 fs/xfs/xfs_reflink.c   |  6 ++--
 fs/zonefs/file.c       | 22 +++++----------
 include/linux/dax.h    | 18 ++++++------
 include/linux/fs.h     |  7 +++--
 include/linux/iomap.h  | 62 ++++++++++++++++++++++--------------------
 60 files changed, 338 insertions(+), 480 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 0dcb81fa2766..d88923d3dbf1 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -467,10 +467,6 @@ static int blkdev_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 static DEFINE_IOMAP_ITER_NEXT(blkdev_iomap_next, blkdev_iomap_begin);
 
-static const struct iomap_ops blkdev_iomap_ops = {
-	.iomap_next		= blkdev_iomap_next,
-};
-
 #ifdef CONFIG_BUFFER_HEAD
 static int blkdev_get_block(struct inode *inode, sector_t iblock,
 		struct buffer_head *bh, int create)
@@ -524,13 +520,13 @@ const struct address_space_operations def_blk_aops = {
 #else /* CONFIG_BUFFER_HEAD */
 static int blkdev_read_folio(struct file *file, struct folio *folio)
 {
-	iomap_bio_read_folio(folio, &blkdev_iomap_ops);
+	iomap_bio_read_folio(folio, blkdev_iomap_next);
 	return 0;
 }
 
 static void blkdev_readahead(struct readahead_control *rac)
 {
-	iomap_bio_readahead(rac, &blkdev_iomap_ops);
+	iomap_bio_readahead(rac, blkdev_iomap_next);
 }
 
 static ssize_t blkdev_writeback_range(struct iomap_writepage_ctx *wpc,
@@ -736,7 +732,7 @@ static ssize_t blkdev_buffered_write(struct kiocb *iocb, struct iov_iter *from)
 	 * i_blkbits/folio order and truncating the page cache.
 	 */
 	inode_lock_shared(inode);
-	ret = iomap_file_buffered_write(iocb, from, &blkdev_iomap_ops, NULL,
+	ret = iomap_file_buffered_write(iocb, from, blkdev_iomap_next, NULL,
 					NULL);
 	inode_unlock_shared(inode);
 	return ret;
diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index ed3914257d39..90919d79d069 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -807,10 +807,6 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 static DEFINE_IOMAP_ITER_NEXT_END(btrfs_dio_iomap_next, btrfs_dio_iomap_begin,
 				  btrfs_dio_iomap_end);
 
-static const struct iomap_ops btrfs_dio_iomap_ops = {
-	.iomap_next             = btrfs_dio_iomap_next,
-};
-
 static const struct iomap_dio_ops btrfs_dio_ops = {
 	.submit_io		= btrfs_dio_submit_io,
 	.bio_set		= &btrfs_dio_bioset,
@@ -821,7 +817,7 @@ static ssize_t btrfs_dio_read(struct kiocb *iocb, struct iov_iter *iter,
 {
 	struct btrfs_dio_data data = { 0 };
 
-	return iomap_dio_rw(iocb, iter, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
+	return iomap_dio_rw(iocb, iter, btrfs_dio_iomap_next, &btrfs_dio_ops,
 			    IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED, &data, done_before);
 }
 
@@ -858,7 +854,7 @@ static struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct iov_iter *it
 		dio_flags |= IOMAP_DIO_BOUNCE;
 	}
 
-	return __iomap_dio_rw(iocb, iter, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
+	return __iomap_dio_rw(iocb, iter, btrfs_dio_iomap_next, &btrfs_dio_ops,
 			      dio_flags, &data, done_before);
 }
 
diff --git a/fs/dax.c b/fs/dax.c
index 94ba41273347..9d161d7ef3ef 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1485,7 +1485,7 @@ static int dax_unshare_iter(struct iomap_iter *iter)
 }
 
 int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
-		const struct iomap_ops *ops)
+		iomap_iter_next_fn next)
 {
 	struct iomap_iter iter = {
 		.inode		= inode,
@@ -1499,7 +1499,7 @@ int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		return 0;
 
 	iter.len = min(len, size - pos);
-	while ((ret = iomap_iter(&iter, ops)) > 0)
+	while ((ret = iomap_iter(&iter, next)) > 0)
 		iter.status = dax_unshare_iter(&iter);
 	return ret;
 }
@@ -1577,7 +1577,7 @@ static int dax_zero_iter(struct iomap_iter *iter, bool *did_zero)
 }
 
 int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
-		const struct iomap_ops *ops)
+		iomap_iter_next_fn next)
 {
 	struct iomap_iter iter = {
 		.inode		= inode,
@@ -1587,14 +1587,14 @@ int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 	};
 	int ret;
 
-	while ((ret = iomap_iter(&iter, ops)) > 0)
+	while ((ret = iomap_iter(&iter, next)) > 0)
 		iter.status = dax_zero_iter(&iter, did_zero);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dax_zero_range);
 
 int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
-		const struct iomap_ops *ops)
+		iomap_iter_next_fn next)
 {
 	unsigned int blocksize = i_blocksize(inode);
 	unsigned int off = pos & (blocksize - 1);
@@ -1602,7 +1602,7 @@ int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 	/* Block boundary? Nothing to do */
 	if (!off)
 		return 0;
-	return dax_zero_range(inode, pos, blocksize - off, did_zero, ops);
+	return dax_zero_range(inode, pos, blocksize - off, did_zero, next);
 }
 EXPORT_SYMBOL_GPL(dax_truncate_page);
 
@@ -1727,7 +1727,8 @@ static int dax_iomap_iter(struct iomap_iter *iomi, struct iov_iter *iter)
  * dax_iomap_rw - Perform I/O to a DAX file
  * @iocb:	The control block for this I/O
  * @iter:	The addresses to do I/O from or to
- * @ops:	iomap ops passed from the file system
+ * @next:	Callback passed from the file system for advancing to next
+ *		iteration
  *
  * This function performs read and write operations to directly mapped
  * persistent memory.  The callers needs to take care of read/write exclusion
@@ -1735,7 +1736,7 @@ static int dax_iomap_iter(struct iomap_iter *iomi, struct iov_iter *iter)
  */
 ssize_t
 dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
-		const struct iomap_ops *ops)
+		iomap_iter_next_fn next)
 {
 	struct iomap_iter iomi = {
 		.inode		= iocb->ki_filp->f_mapping->host,
@@ -1762,7 +1763,7 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iomi.flags |= IOMAP_NOWAIT;
 
-	while ((ret = iomap_iter(&iomi, ops)) > 0)
+	while ((ret = iomap_iter(&iomi, next)) > 0)
 		iomi.status = dax_iomap_iter(&iomi, iter);
 
 	done = iomi.pos - iocb->ki_pos;
@@ -1890,7 +1891,7 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
 }
 
 static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, unsigned long *pfnp,
-			       int *iomap_errp, const struct iomap_ops *ops)
+			       int *iomap_errp, iomap_iter_next_fn next)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
@@ -1935,7 +1936,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, unsigned long *pfnp,
 		goto unlock_entry;
 	}
 
-	while ((error = iomap_iter(&iter, ops)) > 0) {
+	while ((error = iomap_iter(&iter, next)) > 0) {
 		if (WARN_ON_ONCE(iomap_length(&iter) < PAGE_SIZE)) {
 			iter.status = -EIO;	/* fs corruption? */
 			continue;
@@ -2000,7 +2001,7 @@ static bool dax_fault_check_fallback(struct vm_fault *vmf, struct xa_state *xas,
 }
 
 static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, unsigned long *pfnp,
-			       const struct iomap_ops *ops)
+			       iomap_iter_next_fn next)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	XA_STATE_ORDER(xas, &mapping->i_pages, vmf->pgoff, PMD_ORDER);
@@ -2057,7 +2058,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, unsigned long *pfnp,
 	}
 
 	iter.pos = (loff_t)xas.xa_index << PAGE_SHIFT;
-	while (iomap_iter(&iter, ops) > 0) {
+	while (iomap_iter(&iter, next) > 0) {
 		if (iomap_length(&iter) < PMD_SIZE)
 			continue; /* actually breaks out of the loop */
 
@@ -2079,7 +2080,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, unsigned long *pfnp,
 }
 #else
 static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, unsigned long *pfnp,
-			       const struct iomap_ops *ops)
+			       iomap_iter_next_fn next)
 {
 	return VM_FAULT_FALLBACK;
 }
@@ -2091,7 +2092,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, unsigned long *pfnp,
  * @order: Order of the page to fault in
  * @pfnp: PFN to insert for synchronous faults if fsync is required
  * @iomap_errp: Storage for detailed error code in case of error
- * @ops: Iomap ops passed from the file system
+ * @next: The iomap iteration function for the filesystem
  *
  * When a page fault occurs, filesystems may call this helper in
  * their fault handler for DAX files. dax_iomap_fault() assumes the caller
@@ -2100,12 +2101,12 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, unsigned long *pfnp,
  */
 vm_fault_t dax_iomap_fault(struct vm_fault *vmf, unsigned int order,
 			unsigned long *pfnp, int *iomap_errp,
-			const struct iomap_ops *ops)
+			iomap_iter_next_fn next)
 {
 	if (order == 0)
-		return dax_iomap_pte_fault(vmf, pfnp, iomap_errp, ops);
+		return dax_iomap_pte_fault(vmf, pfnp, iomap_errp, next);
 	else if (order == PMD_ORDER)
-		return dax_iomap_pmd_fault(vmf, pfnp, ops);
+		return dax_iomap_pmd_fault(vmf, pfnp, next);
 	else
 		return VM_FAULT_FALLBACK;
 }
@@ -2235,7 +2236,7 @@ static int dax_range_compare_iter(struct iomap_iter *it_src,
 
 int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		struct inode *dst, loff_t dstoff, loff_t len, bool *same,
-		const struct iomap_ops *ops)
+		iomap_iter_next_fn next)
 {
 	struct iomap_iter src_iter = {
 		.inode		= src,
@@ -2251,8 +2252,8 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 	};
 	int ret, status;
 
-	while ((ret = iomap_iter(&src_iter, ops)) > 0 &&
-	       (ret = iomap_iter(&dst_iter, ops)) > 0) {
+	while ((ret = iomap_iter(&src_iter, next)) > 0 &&
+	       (ret = iomap_iter(&dst_iter, next)) > 0) {
 		status = dax_range_compare_iter(&src_iter, &dst_iter,
 				min(src_iter.len, dst_iter.len), same);
 		if (status < 0)
@@ -2265,9 +2266,10 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 int dax_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 			      struct file *file_out, loff_t pos_out,
 			      loff_t *len, unsigned int remap_flags,
-			      const struct iomap_ops *ops)
+			      iomap_iter_next_fn next)
 {
 	return __generic_remap_file_range_prep(file_in, pos_in, file_out,
-					       pos_out, len, remap_flags, ops);
+					       pos_out, len, remap_flags,
+					       next);
 }
 EXPORT_SYMBOL_GPL(dax_remap_file_range_prep);
diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 968303afd620..1f3b06464880 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -374,10 +374,6 @@ static int erofs_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 static DEFINE_IOMAP_ITER_NEXT_END(erofs_iomap_next, erofs_iomap_begin,
 				  erofs_iomap_end);
 
-static const struct iomap_ops erofs_iomap_ops = {
-	.iomap_next = erofs_iomap_next,
-};
-
 int erofs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		 u64 start, u64 len)
 {
@@ -385,9 +381,9 @@ int erofs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		if (!IS_ENABLED(CONFIG_EROFS_FS_ZIP))
 			return -EOPNOTSUPP;
 		return iomap_fiemap(inode, fieinfo, start, len,
-				    &z_erofs_iomap_report_ops);
+				    z_erofs_iomap_next_report);
 	}
-	return iomap_fiemap(inode, fieinfo, start, len, &erofs_iomap_ops);
+	return iomap_fiemap(inode, fieinfo, start, len, erofs_iomap_next);
 }
 
 /*
@@ -408,7 +404,7 @@ static int erofs_read_folio(struct file *file, struct folio *folio)
 	};
 
 	trace_erofs_read_folio(iter_ctx.realinode, folio, true);
-	iomap_read_folio(&erofs_iomap_ops, &read_ctx, &iter_ctx);
+	iomap_read_folio(erofs_iomap_next, &read_ctx, &iter_ctx);
 	if (need_iput)
 		iput(iter_ctx.realinode);
 	return 0;
@@ -429,14 +425,14 @@ static void erofs_readahead(struct readahead_control *rac)
 
 	trace_erofs_readahead(iter_ctx.realinode, readahead_index(rac),
 			      readahead_count(rac), true);
-	iomap_readahead(&erofs_iomap_ops, &read_ctx, &iter_ctx);
+	iomap_readahead(erofs_iomap_next, &read_ctx, &iter_ctx);
 	if (need_iput)
 		iput(iter_ctx.realinode);
 }
 
 static sector_t erofs_bmap(struct address_space *mapping, sector_t block)
 {
-	return iomap_bmap(mapping, block, &erofs_iomap_ops);
+	return iomap_bmap(mapping, block, erofs_iomap_next);
 }
 
 static ssize_t erofs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
@@ -448,14 +444,14 @@ static ssize_t erofs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		return 0;
 
 	if (IS_ENABLED(CONFIG_FS_DAX) && IS_DAX(inode))
-		return dax_iomap_rw(iocb, to, &erofs_iomap_ops);
+		return dax_iomap_rw(iocb, to, erofs_iomap_next);
 
 	if ((iocb->ki_flags & IOCB_DIRECT) && inode->i_sb->s_bdev) {
 		struct erofs_iomap_iter_ctx iter_ctx = {
 			.realinode = inode,
 		};
 
-		return iomap_dio_rw(iocb, to, &erofs_iomap_ops,
+		return iomap_dio_rw(iocb, to, erofs_iomap_next,
 				    NULL, 0, &iter_ctx, 0);
 	}
 	return filemap_read(iocb, to, 0);
@@ -474,7 +470,7 @@ const struct address_space_operations erofs_aops = {
 static vm_fault_t erofs_dax_huge_fault(struct vm_fault *vmf,
 		unsigned int order)
 {
-	return dax_iomap_fault(vmf, order, NULL, NULL, &erofs_iomap_ops);
+	return dax_iomap_fault(vmf, order, NULL, NULL, erofs_iomap_next);
 }
 
 static vm_fault_t erofs_dax_fault(struct vm_fault *vmf)
@@ -506,18 +502,18 @@ static int erofs_file_mmap_prepare(struct vm_area_desc *desc)
 loff_t erofs_file_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct inode *inode = file->f_mapping->host;
-	const struct iomap_ops *ops = &erofs_iomap_ops;
+	iomap_iter_next_fn next = erofs_iomap_next;
 
 	if (erofs_inode_is_data_compressed(EROFS_I(inode)->datalayout)) {
 		if (!IS_ENABLED(CONFIG_EROFS_FS_ZIP))
 			return generic_file_llseek(file, offset, whence);
-		ops = &z_erofs_iomap_report_ops;
+		next = z_erofs_iomap_next_report;
 	}
 
 	if (whence == SEEK_HOLE)
-		offset = iomap_seek_hole(inode, offset, ops);
+		offset = iomap_seek_hole(inode, offset, next);
 	else if (whence == SEEK_DATA)
-		offset = iomap_seek_data(inode, offset, ops);
+		offset = iomap_seek_data(inode, offset, next);
 	else
 		return generic_file_llseek(file, offset, whence);
 
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 8363c0c051f6..c16dfa752cf9 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -397,9 +397,10 @@ struct erofs_iomap_iter_ctx {
 	struct inode *realinode;
 };
 
-extern const struct iomap_ops z_erofs_iomap_report_ops;
 extern const struct iomap_read_ops erofs_fileio_iomap_read_ops;
 
+DECLARE_IOMAP_ITER_NEXT(z_erofs_iomap_next_report);
+
 int erofs_setup_managed_cache(struct super_block *sb);
 #ifdef CONFIG_EROFS_FS_BACKED_BY_FILE
 int erofs_read_meta_folio(struct file *file, struct folio *folio);
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index f8981fc74246..e0d5987b742b 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -830,9 +830,4 @@ static int z_erofs_iomap_begin_report(struct inode *inode, loff_t offset,
 	return 0;
 }
 
-static DEFINE_IOMAP_ITER_NEXT(z_erofs_iomap_next_report,
-			      z_erofs_iomap_begin_report);
-
-const struct iomap_ops z_erofs_iomap_report_ops = {
-	.iomap_next = z_erofs_iomap_next_report,
-};
+DEFINE_IOMAP_ITER_NEXT(z_erofs_iomap_next_report, z_erofs_iomap_begin_report);
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 1386149916bb..435bbef288b8 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -828,7 +828,7 @@ static ssize_t exfat_fallback_buffered_write(struct kiocb *iocb,
 
 	inode_dio_wait(file_inode(iocb->ki_filp));
 
-	written = iomap_file_buffered_write(iocb, from, &exfat_write_iomap_ops,
+	written = iomap_file_buffered_write(iocb, from, exfat_write_iomap_next,
 			NULL, NULL);
 	if (written < 0)
 		return written;
@@ -850,7 +850,7 @@ static ssize_t exfat_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	ssize_t ret;
 
-	ret = iomap_dio_rw(iocb, from, &exfat_write_iomap_ops,
+	ret = iomap_dio_rw(iocb, from, exfat_write_iomap_next,
 			&exfat_write_dio_ops, 0, NULL, 0);
 	if (ret == -ENOTBLK)
 		ret = 0;
@@ -921,7 +921,7 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		 */
 		inode_dio_wait(inode);
 		ret = iomap_file_buffered_write(iocb, iter,
-				&exfat_write_iomap_ops, NULL, NULL);
+				exfat_write_iomap_next, NULL, NULL);
 	}
 	if (ret != -EIOCBQUEUED && end > i_size_read(inode))
 		exfat_write_failed(inode);
@@ -957,7 +957,7 @@ static ssize_t exfat_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		file_accessed(iocb->ki_filp);
-		ret = iomap_dio_rw(iocb, iter, &exfat_iomap_ops, NULL, 0,
+		ret = iomap_dio_rw(iocb, iter, exfat_iomap_next, NULL, 0,
 				NULL, 0);
 	} else {
 		ret = generic_file_read_iter(iocb, iter);
@@ -1016,7 +1016,7 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 	file_update_time(vmf->vma->vm_file);
 
 	filemap_invalidate_lock_shared(inode->i_mapping);
-	ret = iomap_page_mkwrite(vmf, &exfat_iomap_ops, NULL);
+	ret = iomap_page_mkwrite(vmf, exfat_iomap_next, NULL);
 	filemap_invalidate_unlock_shared(inode->i_mapping);
 	sb_end_pagefault(inode->i_sb);
 	inode_unlock(inode);
@@ -1073,12 +1073,12 @@ static loff_t exfat_file_llseek(struct file *file, loff_t offset, int whence)
 	switch (whence) {
 	case SEEK_HOLE:
 		inode_lock_shared(inode);
-		offset = iomap_seek_hole(inode, offset, &exfat_iomap_ops);
+		offset = iomap_seek_hole(inode, offset, exfat_iomap_next);
 		inode_unlock_shared(inode);
 		break;
 	case SEEK_DATA:
 		inode_lock_shared(inode);
-		offset = iomap_seek_data(inode, offset, &exfat_iomap_ops);
+		offset = iomap_seek_data(inode, offset, exfat_iomap_next);
 		inode_unlock_shared(inode);
 		break;
 	default:
diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 5129df1e79b4..c1d15d4fc5e7 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -249,7 +249,7 @@ static int exfat_read_folio(struct file *file, struct folio *folio)
 		.ops = &exfat_iomap_bio_read_ops,
 	};
 
-	iomap_read_folio(&exfat_iomap_ops, &ctx, NULL);
+	iomap_read_folio(exfat_iomap_next, &ctx, NULL);
 	return 0;
 }
 
@@ -271,7 +271,7 @@ static void exfat_readahead(struct readahead_control *rac)
 	    valid_size < pos + readahead_length(rac))
 		return;
 
-	iomap_readahead(&exfat_iomap_ops, &ctx, NULL);
+	iomap_readahead(exfat_iomap_next, &ctx, NULL);
 }
 
 static int exfat_writepages(struct address_space *mapping,
@@ -294,7 +294,7 @@ static sector_t exfat_aop_bmap(struct address_space *mapping, sector_t block)
 	sector_t blocknr;
 
 	inode_lock_shared(mapping->host);
-	blocknr = iomap_bmap(mapping, block, &exfat_iomap_ops);
+	blocknr = iomap_bmap(mapping, block, exfat_iomap_next);
 	inode_unlock_shared(mapping->host);
 	return blocknr;
 }
diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index e50ecbfbfbe0..4e6f3ed9dcc8 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -179,15 +179,11 @@ static int exfat_write_iomap_begin(struct inode *inode, loff_t offset, loff_t le
 	 * Zero the invalid bytes from valid_size to the end of the block
 	 * to prevent stale data from being exposed through the page cache.
 	 */
-	return iomap_truncate_page(inode, valid_size, NULL, &exfat_iomap_ops,
+	return iomap_truncate_page(inode, valid_size, NULL, exfat_iomap_next,
 				   NULL, NULL);
 }
 
-static DEFINE_IOMAP_ITER_NEXT(exfat_iomap_next, exfat_iomap_begin);
-
-const struct iomap_ops exfat_iomap_ops = {
-	.iomap_next = exfat_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT(exfat_iomap_next, exfat_iomap_begin);
 
 #ifdef CONFIG_SWAP
 static int exfat_swap_iomap_begin(struct inode *inode, loff_t offset,
@@ -204,10 +200,6 @@ static int exfat_swap_iomap_begin(struct inode *inode, loff_t offset,
 
 static DEFINE_IOMAP_ITER_NEXT(exfat_swap_iomap_next,
 		exfat_swap_iomap_begin);
-
-static const struct iomap_ops exfat_swap_iomap_ops = {
-	.iomap_next = exfat_swap_iomap_next,
-};
 #endif
 
 /*
@@ -245,12 +237,8 @@ static int exfat_write_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return written;
 }
 
-static DEFINE_IOMAP_ITER_NEXT_END(exfat_write_iomap_next,
-		exfat_write_iomap_begin, exfat_write_iomap_end);
-
-const struct iomap_ops exfat_write_iomap_ops = {
-	.iomap_next	= exfat_write_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT_END(exfat_write_iomap_next, exfat_write_iomap_begin,
+		exfat_write_iomap_end);
 
 /*
  * exfat_writeback_range - Map folio during writeback
@@ -327,7 +315,7 @@ int exfat_iomap_swap_activate(struct swap_info_struct *sis,
 {
 #ifdef CONFIG_SWAP
 	return iomap_swapfile_activate(sis, file, span,
-				       &exfat_swap_iomap_ops);
+				       exfat_swap_iomap_next);
 #else
 	return -EIO;
 #endif
diff --git a/fs/exfat/iomap.h b/fs/exfat/iomap.h
index fd8a913f7794..519132367b65 100644
--- a/fs/exfat/iomap.h
+++ b/fs/exfat/iomap.h
@@ -6,9 +6,11 @@
 #ifndef _LINUX_EXFAT_IOMAP_H
 #define _LINUX_EXFAT_IOMAP_H
 
+#include <linux/iomap.h>
+
 extern const struct iomap_dio_ops exfat_write_dio_ops;
-extern const struct iomap_ops exfat_iomap_ops;
-extern const struct iomap_ops exfat_write_iomap_ops;
+DECLARE_IOMAP_ITER_NEXT(exfat_iomap_next);
+DECLARE_IOMAP_ITER_NEXT(exfat_write_iomap_next);
 extern const struct iomap_writeback_ops exfat_writeback_ops;
 extern const struct iomap_read_ops exfat_iomap_bio_read_ops;
 
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 7bdada93dd06..b46649c510a5 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -18,6 +18,7 @@
 #include <linux/rbtree.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/iomap.h>
 
 /* XXX Here for now... not interested in restructing headers JUST now */
 
@@ -782,7 +783,7 @@ extern const struct file_operations ext2_file_operations;
 /* inode.c */
 extern void ext2_set_file_ops(struct inode *inode);
 extern const struct address_space_operations ext2_aops;
-extern const struct iomap_ops ext2_iomap_ops;
+DECLARE_IOMAP_ITER_NEXT(ext2_iomap_next);
 
 /* namei.c */
 extern const struct inode_operations ext2_dir_inode_operations;
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 67fe423c3828..168c8246add9 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -55,7 +55,7 @@ static ssize_t ext2_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 	trace_ext2_dio_read_begin(iocb, to, 0);
 	inode_lock_shared(inode);
-	ret = iomap_dio_rw(iocb, to, &ext2_iomap_ops, NULL, 0, NULL, 0);
+	ret = iomap_dio_rw(iocb, to, ext2_iomap_next, NULL, 0, NULL, 0);
 	inode_unlock_shared(inode);
 	trace_ext2_dio_read_end(iocb, to, ret);
 
@@ -119,7 +119,7 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	   (!IS_ALIGNED(iocb->ki_pos | iov_iter_alignment(from), blocksize)))
 		flags |= IOMAP_DIO_FORCE_WAIT;
 
-	ret = iomap_dio_rw(iocb, from, &ext2_iomap_ops, &ext2_dio_write_ops,
+	ret = iomap_dio_rw(iocb, from, ext2_iomap_next, &ext2_dio_write_ops,
 			   flags, NULL, 0);
 
 	/* ENOTBLK is magic return value for fallback to buffered-io */
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 12ac4cfe1500..0b8187c1fcd0 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -862,12 +862,7 @@ ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
-static DEFINE_IOMAP_ITER_NEXT_END(ext2_iomap_next, ext2_iomap_begin,
-				  ext2_iomap_end);
-
-const struct iomap_ops ext2_iomap_ops = {
-	.iomap_next		= ext2_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT_END(ext2_iomap_next, ext2_iomap_begin, ext2_iomap_end);
 
 int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		u64 start, u64 len)
@@ -886,7 +881,7 @@ int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	if (i_size == 0)
 		i_size = 1;
 	len = min_t(u64, len, i_size);
-	ret = iomap_fiemap(inode, fieinfo, start, len, &ext2_iomap_ops);
+	ret = iomap_fiemap(inode, fieinfo, start, len, ext2_iomap_next);
 	inode_unlock(inode);
 
 	return ret;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f38fec3167fb..bf0325ecbec7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -20,6 +20,7 @@
 #include <linux/refcount.h>
 #include <linux/types.h>
 #include <linux/blkdev.h>
+#include <linux/iomap.h>
 #include <linux/magic.h>
 #include <linux/jbd2.h>
 #include <linux/quota.h>
@@ -4105,10 +4106,11 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 		io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
 }
 
-extern const struct iomap_ops ext4_iomap_ops;
-extern const struct iomap_ops ext4_iomap_report_ops;
-extern const struct iomap_ops ext4_iomap_buffered_write_ops;
-extern const struct iomap_ops ext4_iomap_buffered_da_write_ops;
+DECLARE_IOMAP_ITER_NEXT(ext4_iomap_next);
+DECLARE_IOMAP_ITER_NEXT(ext4_iomap_next_report);
+DECLARE_IOMAP_ITER_NEXT(ext4_iomap_buffered_write_next);
+DECLARE_IOMAP_ITER_NEXT(ext4_iomap_buffered_da_write_next);
+
 extern const struct iomap_write_ops ext4_iomap_write_ops;
 
 int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad0d80e33f60..cd35e88bc372 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5315,10 +5315,6 @@ static int ext4_iomap_xattr_begin(struct inode *inode, loff_t offset,
 
 static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_xattr_next, ext4_iomap_xattr_begin);
 
-static const struct iomap_ops ext4_iomap_xattr_ops = {
-	.iomap_next		= ext4_iomap_xattr_next,
-};
-
 static int ext4_fiemap_check_ranges(struct inode *inode, u64 start, u64 *len)
 {
 	u64 maxbytes = ext4_get_maxbytes(inode);
@@ -5361,10 +5357,10 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
 		fieinfo->fi_flags &= ~FIEMAP_FLAG_XATTR;
 		error = iomap_fiemap(inode, fieinfo, start, len,
-				     &ext4_iomap_xattr_ops);
+				     ext4_iomap_xattr_next);
 	} else {
 		error = iomap_fiemap(inode, fieinfo, start, len,
-				     &ext4_iomap_report_ops);
+				     ext4_iomap_next_report);
 	}
 unlock:
 	inode_unlock_shared(inode);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 50d3c92709c8..ad8985c529c6 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -93,7 +93,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 	ret = iomap_dio_read_simple(iocb, to, ext4_iomap_begin);
 	if (ret == -ENOTBLK)
-		ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0, NULL, 0);
+		ret = iomap_dio_rw(iocb, to, ext4_iomap_next, NULL, 0, NULL, 0);
 	inode_unlock_shared(inode);
 
 	file_accessed(iocb->ki_filp);
@@ -121,7 +121,7 @@ static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		/* Fallback to buffered IO in case we cannot support DAX */
 		return generic_file_read_iter(iocb, to);
 	}
-	ret = dax_iomap_rw(iocb, to, &ext4_iomap_ops);
+	ret = dax_iomap_rw(iocb, to, ext4_iomap_next);
 	inode_unlock_shared(inode);
 
 	file_accessed(iocb->ki_filp);
@@ -334,14 +334,14 @@ static ssize_t ext4_iomap_buffered_write(struct kiocb *iocb,
 					 struct iov_iter *from)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
-	const struct iomap_ops *iomap_ops;
+	iomap_iter_next_fn next;
 
 	if (test_opt(inode->i_sb, DELALLOC) && !ext4_nonda_switch(inode->i_sb))
-		iomap_ops = &ext4_iomap_buffered_da_write_ops;
+		next = ext4_iomap_buffered_da_write_next;
 	else
-		iomap_ops = &ext4_iomap_buffered_write_ops;
+		next = ext4_iomap_buffered_write_next;
 
-	return iomap_file_buffered_write(iocb, from, iomap_ops,
+	return iomap_file_buffered_write(iocb, from, next,
 					 &ext4_iomap_write_ops, NULL);
 }
 
@@ -663,7 +663,7 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			goto out;
 	}
 
-	ret = iomap_dio_rw(iocb, from, &ext4_iomap_ops, &ext4_dio_write_ops,
+	ret = iomap_dio_rw(iocb, from, ext4_iomap_next, &ext4_dio_write_ops,
 			   dio_flags, NULL, 0);
 	if (ret == -ENOTBLK)
 		ret = 0;
@@ -767,7 +767,7 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		ext4_journal_stop(handle);
 	}
 
-	ret = dax_iomap_rw(iocb, from, &ext4_iomap_ops);
+	ret = dax_iomap_rw(iocb, from, ext4_iomap_next);
 
 	if (extend) {
 		ret = ext4_handle_inode_extension(inode, offset, ret, count);
@@ -855,7 +855,7 @@ static vm_fault_t ext4_dax_huge_fault(struct vm_fault *vmf, unsigned int order)
 	} else {
 		filemap_invalidate_lock_shared(mapping);
 	}
-	result = dax_iomap_fault(vmf, order, &pfn, &error, &ext4_iomap_ops);
+	result = dax_iomap_fault(vmf, order, &pfn, &error, ext4_iomap_next);
 	if (write) {
 		ext4_journal_stop(handle);
 
@@ -1034,13 +1034,13 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 	case SEEK_HOLE:
 		inode_lock_shared(inode);
 		offset = iomap_seek_hole(inode, offset,
-					 &ext4_iomap_report_ops);
+					 ext4_iomap_next_report);
 		inode_unlock_shared(inode);
 		break;
 	case SEEK_DATA:
 		inode_lock_shared(inode);
 		offset = iomap_seek_data(inode, offset,
-					 &ext4_iomap_report_ops);
+					 ext4_iomap_next_report);
 		inode_unlock_shared(inode);
 		break;
 	}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b4d581aa5ee1..68ebf29edad6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3519,7 +3519,7 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 		filemap_write_and_wait(mapping);
 	}
 
-	ret = iomap_bmap(mapping, block, &ext4_iomap_ops);
+	ret = iomap_bmap(mapping, block, ext4_iomap_next);
 
 out:
 	inode_unlock_shared(inode);
@@ -3994,11 +3994,7 @@ int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
-static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_next, ext4_iomap_begin);
-
-const struct iomap_ops ext4_iomap_ops = {
-	.iomap_next		= ext4_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT(ext4_iomap_next, ext4_iomap_begin);
 
 static int ext4_iomap_begin_report(struct inode *inode, loff_t offset,
 				   loff_t length, unsigned int flags,
@@ -4051,11 +4047,7 @@ static int ext4_iomap_begin_report(struct inode *inode, loff_t offset,
 	return 0;
 }
 
-static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_next_report, ext4_iomap_begin_report);
-
-const struct iomap_ops ext4_iomap_report_ops = {
-	.iomap_next = ext4_iomap_next_report,
-};
+DEFINE_IOMAP_ITER_NEXT(ext4_iomap_next_report, ext4_iomap_begin_report);
 
 static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
 				 loff_t length, struct ext4_map_blocks *map,
@@ -4260,45 +4252,29 @@ static int ext4_iomap_zero_begin(struct inode *inode,
 
 static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_zero_next, ext4_iomap_zero_begin);
 
-static const struct iomap_ops ext4_iomap_zero_ops = {
-	.iomap_next = ext4_iomap_zero_next,
-};
-
 /*
  * Since we always allocate unwritten extents, there is no need for
  * iomap_end to clean up allocated blocks on a short write.
  */
-static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_buffered_write_next,
-			      ext4_iomap_buffered_write_begin);
+DEFINE_IOMAP_ITER_NEXT(ext4_iomap_buffered_write_next,
+		       ext4_iomap_buffered_write_begin);
 
-const struct iomap_ops ext4_iomap_buffered_write_ops = {
-	.iomap_next = ext4_iomap_buffered_write_next,
-};
-
-static DEFINE_IOMAP_ITER_NEXT_END(ext4_iomap_buffered_da_write_next,
-				  ext4_iomap_buffered_da_write_begin,
-				  ext4_iomap_buffered_da_write_end);
-
-const struct iomap_ops ext4_iomap_buffered_da_write_ops = {
-	.iomap_next = ext4_iomap_buffered_da_write_next,
-};
+DEFINE_IOMAP_ITER_NEXT_END(ext4_iomap_buffered_da_write_next,
+			   ext4_iomap_buffered_da_write_begin,
+			   ext4_iomap_buffered_da_write_end);
 
 static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_buffered_read_next,
 			      ext4_iomap_buffered_read_begin);
 
-static const struct iomap_ops ext4_iomap_buffered_read_ops = {
-	.iomap_next = ext4_iomap_buffered_read_next,
-};
-
 static int ext4_iomap_read_folio(struct file *file, struct folio *folio)
 {
-	iomap_bio_read_folio(folio, &ext4_iomap_buffered_read_ops);
+	iomap_bio_read_folio(folio, ext4_iomap_buffered_read_next);
 	return 0;
 }
 
 static void ext4_iomap_readahead(struct readahead_control *rac)
 {
-	iomap_bio_readahead(rac, &ext4_iomap_buffered_read_ops);
+	iomap_bio_readahead(rac, ext4_iomap_buffered_read_next);
 }
 
 
@@ -4561,7 +4537,7 @@ static int ext4_iomap_swap_activate(struct swap_info_struct *sis,
 				    struct file *file, sector_t *span)
 {
 	return iomap_swapfile_activate(sis, file, span,
-				       &ext4_iomap_report_ops);
+				       ext4_iomap_next_report);
 }
 
 static const struct address_space_operations ext4_aops = {
@@ -4827,7 +4803,7 @@ static int ext4_block_iomap_zero_range(struct inode *inode, loff_t from,
 			!rwsem_is_locked(&inode->i_mapping->invalidate_lock));
 
 	ret = iomap_zero_range(inode, from, length, did_zero,
-			       &ext4_iomap_zero_ops, &ext4_iomap_write_ops,
+			       ext4_iomap_zero_next, &ext4_iomap_write_ops,
 			       NULL);
 	if (ret)
 		return ret;
@@ -4866,7 +4842,7 @@ static int ext4_block_zero_range(struct inode *inode,
 
 	if (IS_DAX(inode)) {
 		return dax_zero_range(inode, from, length, did_zero,
-				      &ext4_iomap_ops);
+				      ext4_iomap_next);
 	} else if (ext4_should_journal_data(inode)) {
 		return ext4_block_journalled_zero_range(inode, from, length,
 							did_zero);
@@ -7823,18 +7799,18 @@ static int ext4_block_page_mkwrite(struct inode *inode, struct folio *folio,
 static vm_fault_t ext4_iomap_page_mkwrite(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
-	const struct iomap_ops *iomap_ops;
+	iomap_iter_next_fn next;
 
 	/*
 	 * ext4_nonda_switch() could writeback this folio, so have to
 	 * call it before lock folio.
 	 */
 	if (test_opt(inode->i_sb, DELALLOC) && !ext4_nonda_switch(inode->i_sb))
-		iomap_ops = &ext4_iomap_buffered_da_write_ops;
+		next = ext4_iomap_buffered_da_write_next;
 	else
-		iomap_ops = &ext4_iomap_buffered_write_ops;
+		next = ext4_iomap_buffered_write_next;
 
-	return iomap_page_mkwrite(vmf, iomap_ops, NULL);
+	return iomap_page_mkwrite(vmf, next, NULL);
 }
 
 vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 28fd8afff5d4..7c5aa95b7da8 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -4853,8 +4853,4 @@ static int f2fs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
-static DEFINE_IOMAP_ITER_NEXT(f2fs_iomap_next, f2fs_iomap_begin);
-
-const struct iomap_ops f2fs_iomap_ops = {
-	.iomap_next	= f2fs_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT(f2fs_iomap_next, f2fs_iomap_begin);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f7423b3f6e4a..6941891d7cae 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -25,6 +25,7 @@
 #include <linux/quotaops.h>
 #include <linux/part_stat.h>
 #include <linux/rw_hint.h>
+#include <linux/iomap.h>
 
 #include <linux/fscrypt.h>
 #include <linux/fsverity.h>
@@ -4397,7 +4398,7 @@ int f2fs_init_post_read_processing(void);
 void f2fs_destroy_post_read_processing(void);
 int f2fs_init_wq(struct f2fs_sb_info *sbi);
 void f2fs_destroy_wq(struct f2fs_sb_info *sbi);
-extern const struct iomap_ops f2fs_iomap_ops;
+DECLARE_IOMAP_ITER_NEXT(f2fs_iomap_next);
 
 /*
  * gc.c
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index e2c0f5083313..cf095978fad4 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -5245,7 +5245,7 @@ static ssize_t f2fs_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	 * F2FS_DIO_READ counter will be decremented correctly in all cases.
 	 */
 	inc_cache_count(sbi, F2FS_DIO_READ);
-	dio = __iomap_dio_rw(iocb, to, &f2fs_iomap_ops,
+	dio = __iomap_dio_rw(iocb, to, f2fs_iomap_next,
 			     &f2fs_iomap_dio_read_ops, 0, NULL, 0);
 	if (IS_ERR_OR_NULL(dio)) {
 		ret = PTR_ERR_OR_ZERO(dio);
@@ -5584,7 +5584,7 @@ static ssize_t f2fs_dio_write_iter(struct kiocb *iocb, struct iov_iter *from,
 	dio_flags = 0;
 	if (pos + count > inode->i_size)
 		dio_flags |= IOMAP_DIO_FORCE_WAIT;
-	dio = __iomap_dio_rw(iocb, from, &f2fs_iomap_ops,
+	dio = __iomap_dio_rw(iocb, from, f2fs_iomap_next,
 			     &f2fs_iomap_dio_write_ops, dio_flags, iocb, 0);
 	if (IS_ERR_OR_NULL(dio)) {
 		ret = PTR_ERR_OR_ZERO(dio);
diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index b79fa26ce783..087a8cd88d96 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -656,10 +656,6 @@ static int fuse_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 static DEFINE_IOMAP_ITER_NEXT_END(fuse_iomap_next, fuse_iomap_begin,
 				  fuse_iomap_end);
 
-static const struct iomap_ops fuse_iomap_ops = {
-	.iomap_next = fuse_iomap_next,
-};
-
 static void fuse_wait_dax_page(struct inode *inode)
 {
 	filemap_invalidate_unlock(inode->i_mapping);
@@ -687,7 +683,7 @@ ssize_t fuse_vdax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		inode_lock_shared(inode);
 	}
 
-	ret = dax_iomap_rw(iocb, to, &fuse_iomap_ops);
+	ret = dax_iomap_rw(iocb, to, fuse_iomap_next);
 	inode_unlock_shared(inode);
 
 	/* TODO file_accessed(iocb->f_filp) */
@@ -742,7 +738,7 @@ ssize_t fuse_vdax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (file_extending_write(iocb, from))
 		ret = fuse_dax_direct_write(iocb, from);
 	else
-		ret = dax_iomap_rw(iocb, from, &fuse_iomap_ops);
+		ret = dax_iomap_rw(iocb, from, fuse_iomap_next);
 
 out:
 	inode_unlock(inode);
@@ -777,7 +773,7 @@ static vm_fault_t __fuse_dax_fault(struct vm_fault *vmf, unsigned int order,
 	 * to populate page cache or access memory we are trying to free.
 	 */
 	filemap_invalidate_lock_shared(inode->i_mapping);
-	ret = dax_iomap_fault(vmf, order, &pfn, &error, &fuse_iomap_ops);
+	ret = dax_iomap_fault(vmf, order, &pfn, &error, fuse_iomap_next);
 	if ((ret & VM_FAULT_ERROR) && error == -EAGAIN) {
 		error = 0;
 		retry = true;
diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
index edb19498d496..ce97377391ad 100644
--- a/fs/fuse/ext_map.c
+++ b/fs/fuse/ext_map.c
@@ -213,10 +213,6 @@ static int fuse_ext_map_iomap_begin(struct inode *inode, loff_t offset, loff_t l
 static DEFINE_IOMAP_ITER_NEXT(fuse_ext_map_iomap_next,
 			      fuse_ext_map_iomap_begin);
 
-static const struct iomap_ops fuse_ext_map_iomap_ops = {
-	.iomap_next		= fuse_ext_map_iomap_next,
-};
-
 static vm_fault_t fuse_ext_map_huge_fault(struct vm_fault *vmf, unsigned int order)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
@@ -237,7 +233,7 @@ static vm_fault_t fuse_ext_map_huge_fault(struct vm_fault *vmf, unsigned int ord
 
 	filemap_invalidate_lock_shared(inode->i_mapping);
 
-	ret = dax_iomap_fault(vmf, order, &pfn, NULL, &fuse_ext_map_iomap_ops);
+	ret = dax_iomap_fault(vmf, order, &pfn, NULL, fuse_ext_map_iomap_next);
 	if (ret & VM_FAULT_NEEDDSYNC)
 		ret = dax_finish_sync_fault(vmf, order, pfn);
 
@@ -286,7 +282,7 @@ ssize_t fuse_ext_map_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (!IS_ENABLED(CONFIG_FS_DAX))
 		return -EIO;
 
-	res = dax_iomap_rw(iocb, to, &fuse_ext_map_iomap_ops);
+	res = dax_iomap_rw(iocb, to, fuse_ext_map_iomap_next);
 
 	file_accessed(iocb->ki_filp);
 	return res;
@@ -312,7 +308,7 @@ ssize_t fuse_ext_map_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (!IS_ENABLED(CONFIG_FS_DAX))
 		return -EIO;
 
-	return dax_iomap_rw(iocb, from, &fuse_ext_map_iomap_ops);
+	return dax_iomap_rw(iocb, from, fuse_ext_map_iomap_next);
 }
 
 int fuse_ext_map_mmap(struct file *file, struct vm_area_struct *vma)
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index d5e1cb53d86a..6b279ff5ec05 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -923,10 +923,6 @@ static int fuse_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 static DEFINE_IOMAP_ITER_NEXT(fuse_iomap_next, fuse_iomap_begin);
 
-static const struct iomap_ops fuse_iomap_ops = {
-	.iomap_next	= fuse_iomap_next,
-};
-
 struct fuse_fill_read_data {
 	struct file *file;
 
@@ -1036,7 +1032,7 @@ static int fuse_read_folio(struct file *file, struct folio *folio)
 		return -EIO;
 	}
 
-	iomap_read_folio(&fuse_iomap_ops, &ctx, NULL);
+	iomap_read_folio(fuse_iomap_next, &ctx, NULL);
 	fuse_invalidate_atime(inode);
 	return 0;
 }
@@ -1146,7 +1142,7 @@ static void fuse_readahead(struct readahead_control *rac)
 	if (fuse_is_bad(inode))
 		return;
 
-	iomap_readahead(&fuse_iomap_ops, &ctx, NULL);
+	iomap_readahead(fuse_iomap_next, &ctx, NULL);
 	if (data.ia)
 		fuse_send_readpages(data.ia, data.file, data.nr_bytes,
 				    fc->async_read);
@@ -1570,7 +1566,7 @@ static ssize_t fuse_cache_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		 * and granular dirty tracking for large folios.
 		 */
 		written = iomap_file_buffered_write(iocb, from,
-						    &fuse_iomap_ops,
+						    fuse_iomap_next,
 						    &fuse_iomap_write_ops,
 						    file);
 	} else {
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index ba8d79c4bcac..df069b070bf3 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1053,7 +1053,8 @@ static void virtio_fs_cleanup_vqs(struct virtio_device *vdev)
 }
 
 /* Map a window offset to a page frame number.  The window offset will have
- * been produced by .iomap_next(), which maps a file offset to a window offset.
+ * been produced by fuse_iomap_next(), which maps a file offset to a window
+ * offset.
  */
 static long virtio_fs_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 				    long nr_pages, enum dax_access_mode mode,
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index ee11d494e47c..d31615f49754 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -425,7 +425,7 @@ static int gfs2_read_folio(struct file *file, struct folio *folio)
 
 	if (!gfs2_is_jdata(ip) ||
 	    (i_blocksize(inode) == PAGE_SIZE && !folio_buffers(folio))) {
-		iomap_bio_read_folio(folio, &gfs2_iomap_ops);
+		iomap_bio_read_folio(folio, gfs2_iomap_next);
 	} else if (gfs2_is_stuffed(ip)) {
 		error = stuffed_read_folio(ip, folio);
 	} else {
@@ -500,7 +500,7 @@ static void gfs2_readahead(struct readahead_control *rac)
 	else if (gfs2_is_jdata(ip))
 		mpage_readahead(rac, gfs2_block_map);
 	else
-		iomap_bio_readahead(rac, &gfs2_iomap_ops);
+		iomap_bio_readahead(rac, gfs2_iomap_next);
 }
 
 /**
@@ -572,7 +572,7 @@ static sector_t gfs2_bmap(struct address_space *mapping, sector_t lblock)
 		return 0;
 
 	if (!gfs2_is_stuffed(ip))
-		dblock = iomap_bmap(mapping, lblock, &gfs2_iomap_ops);
+		dblock = iomap_bmap(mapping, lblock, gfs2_iomap_next);
 
 	gfs2_glock_dq_uninit(&i_gh);
 
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 264170f91c5d..09884f698d91 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1205,12 +1205,7 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return 0;
 }
 
-static DEFINE_IOMAP_ITER_NEXT_END(gfs2_iomap_next, gfs2_iomap_begin,
-				  gfs2_iomap_end);
-
-const struct iomap_ops gfs2_iomap_ops = {
-	.iomap_next = gfs2_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT_END(gfs2_iomap_next, gfs2_iomap_begin, gfs2_iomap_end);
 
 /**
  * gfs2_block_map - Map one or more blocks of an inode to a disk block
@@ -1325,7 +1320,7 @@ static int gfs2_block_zero_range(struct inode *inode, loff_t from, loff_t length
 	if (from >= inode->i_size)
 		return 0;
 	length = min(length, inode->i_size - from);
-	return iomap_zero_range(inode, from, length, NULL, &gfs2_iomap_ops,
+	return iomap_zero_range(inode, from, length, NULL, gfs2_iomap_next,
 			&gfs2_iomap_write_ops, NULL);
 }
 
diff --git a/fs/gfs2/bmap.h b/fs/gfs2/bmap.h
index e3d6efdfd890..cceb47950b7b 100644
--- a/fs/gfs2/bmap.h
+++ b/fs/gfs2/bmap.h
@@ -43,7 +43,7 @@ static inline void gfs2_write_calc_reserv(const struct gfs2_inode *ip,
 	}
 }
 
-extern const struct iomap_ops gfs2_iomap_ops;
+DECLARE_IOMAP_ITER_NEXT(gfs2_iomap_next);
 extern const struct iomap_write_ops gfs2_iomap_write_ops;
 extern const struct iomap_writeback_ops gfs2_writeback_ops;
 
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 1efd0679badd..cea24d5de91c 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -851,7 +851,7 @@ static ssize_t gfs2_file_direct_read(struct kiocb *iocb, struct iov_iter *to,
 		goto out_uninit;
 	pagefault_disable();
 	to->nofault = true;
-	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL,
+	ret = iomap_dio_rw(iocb, to, gfs2_iomap_next, NULL,
 			   IOMAP_DIO_PARTIAL, NULL, read);
 	to->nofault = false;
 	pagefault_enable();
@@ -917,7 +917,7 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 		goto out_unlock;
 
 	from->nofault = true;
-	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL,
+	ret = iomap_dio_rw(iocb, from, gfs2_iomap_next, NULL,
 			   IOMAP_DIO_PARTIAL, NULL, written);
 	from->nofault = false;
 	if (ret <= 0) {
@@ -1069,7 +1069,7 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 		goto out_unlock;
 
 	pagefault_disable();
-	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops,
+	ret = iomap_file_buffered_write(iocb, from, gfs2_iomap_next,
 			&gfs2_iomap_write_ops, NULL);
 	pagefault_enable();
 	if (ret > 0)
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 2c2dc459c037..75fb1a0c9142 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -2229,7 +2229,7 @@ static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		goto out;
 
 	pagefault_disable();
-	ret = iomap_fiemap(inode, fieinfo, start, len, &gfs2_iomap_ops);
+	ret = iomap_fiemap(inode, fieinfo, start, len, gfs2_iomap_next);
 	pagefault_enable();
 
 	gfs2_glock_dq_uninit(&gh);
@@ -2254,7 +2254,7 @@ loff_t gfs2_seek_data(struct file *file, loff_t offset)
 	inode_lock_shared(inode);
 	ret = gfs2_glock_nq_init(gl, LM_ST_SHARED, 0, &gh);
 	if (!ret)
-		ret = iomap_seek_data(inode, offset, &gfs2_iomap_ops);
+		ret = iomap_seek_data(inode, offset, gfs2_iomap_next);
 	gfs2_glock_dq_uninit(&gh);
 	inode_unlock_shared(inode);
 
@@ -2273,7 +2273,7 @@ loff_t gfs2_seek_hole(struct file *file, loff_t offset)
 	inode_lock_shared(inode);
 	ret = gfs2_glock_nq_init(gl, LM_ST_SHARED, 0, &gh);
 	if (!ret)
-		ret = iomap_seek_hole(inode, offset, &gfs2_iomap_ops);
+		ret = iomap_seek_hole(inode, offset, gfs2_iomap_next);
 	gfs2_glock_dq_uninit(&gh);
 	inode_unlock_shared(inode);
 
diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 6a629ab956fc..ef7eb601be09 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -158,10 +158,6 @@ static int hpfs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 static DEFINE_IOMAP_ITER_NEXT(hpfs_iomap_next, hpfs_iomap_begin);
 
-static const struct iomap_ops hpfs_iomap_ops = {
-	.iomap_next		= hpfs_iomap_next,
-};
-
 static int hpfs_read_folio(struct file *file, struct folio *folio)
 {
 	return mpage_read_folio(folio, hpfs_get_block);
@@ -238,7 +234,7 @@ static int hpfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 	inode_lock(inode);
 	len = min_t(u64, len, i_size_read(inode));
-	ret = iomap_fiemap(inode, fieinfo, start, len, &hpfs_iomap_ops);
+	ret = iomap_fiemap(inode, fieinfo, start, len, hpfs_iomap_next);
 	inode_unlock(inode);
 
 	return ret;
diff --git a/fs/internal.h b/fs/internal.h
index e833c7e6e14f..0bd3e266472b 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -8,7 +8,6 @@
 struct super_block;
 struct file_system_type;
 struct iomap;
-struct iomap_ops;
 struct linux_binprm;
 struct path;
 struct mount;
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 907873073b03..231f5deca3ce 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -648,8 +648,8 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
 	return 0;
 }
 
-void iomap_read_folio(const struct iomap_ops *ops,
-		struct iomap_read_folio_ctx *ctx, void *private)
+void iomap_read_folio(iomap_iter_next_fn next, struct iomap_read_folio_ctx *ctx,
+		void *private)
 {
 	struct folio *folio = ctx->cur_folio;
 	struct iomap_iter iter = {
@@ -672,7 +672,7 @@ void iomap_read_folio(const struct iomap_ops *ops,
 		fsverity_readahead(ctx->vi, folio->index,
 				   folio_nr_pages(folio));
 
-	while ((ret = iomap_iter(&iter, ops)) > 0) {
+	while ((ret = iomap_iter(&iter, next)) > 0) {
 		iter.status = iomap_read_folio_iter(&iter, ctx,
 				&bytes_submitted);
 		if (ctx->read_ctx && ctx->ops->submit_read)
@@ -711,22 +711,22 @@ static int iomap_readahead_iter(struct iomap_iter *iter,
 
 /**
  * iomap_readahead - Attempt to read pages from a file.
- * @ops: The operations vector for the filesystem.
+ * @next: The iomap iteration function for the filesystem.
  * @ctx: The ctx used for issuing readahead.
  * @private: The filesystem-specific information for issuing iomap_iter.
  *
  * This function is for filesystems to call to implement their readahead
  * address_space operation.
  *
- * Context: The @ops callbacks may submit I/O (eg to read the addresses of
+ * Context: The @next callback may submit I/O (eg to read the addresses of
  * blocks from disc), and may wait for it.  The caller may be trying to
  * access a different page, and so sleeping excessively should be avoided.
  * It may allocate memory, but should avoid costly allocations.  This
  * function is called with memalloc_nofs set, so allocations will not cause
  * the filesystem to be reentered.
  */
-void iomap_readahead(const struct iomap_ops *ops,
-		struct iomap_read_folio_ctx *ctx, void *private)
+void iomap_readahead(iomap_iter_next_fn next, struct iomap_read_folio_ctx *ctx,
+		void *private)
 {
 	struct readahead_control *rac = ctx->rac;
 	struct iomap_iter iter = {
@@ -748,7 +748,7 @@ void iomap_readahead(const struct iomap_ops *ops,
 		fsverity_readahead(ctx->vi, readahead_index(rac),
 				readahead_count(rac));
 
-	while (iomap_iter(&iter, ops) > 0) {
+	while (iomap_iter(&iter, next) > 0) {
 		iter.status = iomap_readahead_iter(&iter, ctx,
 					&cur_bytes_submitted);
 		if (ctx->read_ctx && ctx->ops->submit_read)
@@ -1292,7 +1292,7 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 
 ssize_t
 iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
-		const struct iomap_ops *ops,
+		iomap_iter_next_fn next,
 		const struct iomap_write_ops *write_ops, void *private)
 {
 	struct iomap_iter iter = {
@@ -1313,7 +1313,7 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 	if (iocb->ki_flags & IOCB_DONTCACHE)
 		iter.flags |= IOMAP_DONTCACHE;
 
-	while ((ret = iomap_iter(&iter, ops)) > 0)
+	while ((ret = iomap_iter(&iter, next)) > 0)
 		iter.status = iomap_write_iter(&iter, i, write_ops);
 
 	if (unlikely(iter.pos == iocb->ki_pos))
@@ -1325,7 +1325,7 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
 
 int iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
-		const void *buf, const struct iomap_ops *ops,
+		const void *buf, iomap_iter_next_fn next,
 		const struct iomap_write_ops *write_ops)
 {
 	int			ret;
@@ -1342,7 +1342,7 @@ int iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
 
 	iov_iter_kvec(&iiter, WRITE, &kvec, 1, length);
 
-	ret = iomap_file_buffered_write(&iocb, &iiter, ops, write_ops, NULL);
+	ret = iomap_file_buffered_write(&iocb, &iiter, next, write_ops, NULL);
 	if (ret < 0)
 		return ret;
 	return ret == length ? 0 : -EIO;
@@ -1614,7 +1614,7 @@ static int iomap_unshare_iter(struct iomap_iter *iter,
 
 int
 iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
-		const struct iomap_ops *ops,
+		iomap_iter_next_fn next,
 		const struct iomap_write_ops *write_ops)
 {
 	struct iomap_iter iter = {
@@ -1629,7 +1629,7 @@ iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		return 0;
 
 	iter.len = min(len, size - pos);
-	while ((ret = iomap_iter(&iter, ops)) > 0)
+	while ((ret = iomap_iter(&iter, next)) > 0)
 		iter.status = iomap_unshare_iter(&iter, write_ops);
 	return ret;
 }
@@ -1742,7 +1742,7 @@ EXPORT_SYMBOL_GPL(iomap_fill_dirty_folios);
 
 int
 iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
-		const struct iomap_ops *ops,
+		iomap_iter_next_fn next,
 		const struct iomap_write_ops *write_ops, void *private)
 {
 	struct folio_batch fbatch;
@@ -1767,7 +1767,7 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 	 */
 	range_dirty = filemap_range_needs_writeback(mapping, iter.pos,
 					iter.pos + iter.len - 1);
-	while ((ret = iomap_iter(&iter, ops)) > 0) {
+	while ((ret = iomap_iter(&iter, next)) > 0) {
 		const struct iomap *srcmap = iomap_iter_srcmap(&iter);
 
 		if (!(iter.iomap.flags & IOMAP_F_FOLIO_BATCH) &&
@@ -1793,7 +1793,7 @@ EXPORT_SYMBOL_GPL(iomap_zero_range);
 
 int
 iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
-		const struct iomap_ops *ops,
+		iomap_iter_next_fn next,
 		const struct iomap_write_ops *write_ops, void *private)
 {
 	unsigned int blocksize = i_blocksize(inode);
@@ -1802,7 +1802,7 @@ iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 	/* Block boundary? Nothing to do */
 	if (!off)
 		return 0;
-	return iomap_zero_range(inode, pos, blocksize - off, did_zero, ops,
+	return iomap_zero_range(inode, pos, blocksize - off, did_zero, next,
 			write_ops, private);
 }
 EXPORT_SYMBOL_GPL(iomap_truncate_page);
@@ -1827,7 +1827,7 @@ static int iomap_folio_mkwrite_iter(struct iomap_iter *iter,
 	return iomap_iter_advance(iter, length);
 }
 
-vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops,
+vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, iomap_iter_next_fn next,
 		void *private)
 {
 	struct iomap_iter iter = {
@@ -1844,7 +1844,7 @@ vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops,
 		goto out_unlock;
 	iter.pos = folio_pos(folio);
 	iter.len = ret;
-	while ((ret = iomap_iter(&iter, ops)) > 0)
+	while ((ret = iomap_iter(&iter, next)) > 0)
 		iter.status = iomap_folio_mkwrite_iter(&iter, folio);
 
 	if (ret < 0)
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 45bb24934f3d..ffe67e1e651b 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -689,7 +689,7 @@ static int iomap_dio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
  */
 struct iomap_dio *
 __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
-		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
+		iomap_iter_next_fn next, const struct iomap_dio_ops *dops,
 		unsigned int dio_flags, void *private, size_t done_before)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
@@ -813,7 +813,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	inode_dio_begin(inode);
 
 	blk_start_plug(&plug);
-	while ((ret = iomap_iter(&iomi, ops)) > 0) {
+	while ((ret = iomap_iter(&iomi, next)) > 0) {
 		iomi.status = iomap_dio_iter(&iomi, dio);
 
 		/*
@@ -903,12 +903,12 @@ EXPORT_SYMBOL_GPL(__iomap_dio_rw);
 
 ssize_t
 iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
-		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
+		iomap_iter_next_fn next, const struct iomap_dio_ops *dops,
 		unsigned int dio_flags, void *private, size_t done_before)
 {
 	struct iomap_dio *dio;
 
-	dio = __iomap_dio_rw(iocb, iter, ops, dops, dio_flags, private,
+	dio = __iomap_dio_rw(iocb, iter, next, dops, dio_flags, private,
 			     done_before);
 	if (IS_ERR_OR_NULL(dio))
 		return PTR_ERR_OR_ZERO(dio);
diff --git a/fs/iomap/fiemap.c b/fs/iomap/fiemap.c
index 54b824b7edb5..a9e33c7af910 100644
--- a/fs/iomap/fiemap.c
+++ b/fs/iomap/fiemap.c
@@ -56,7 +56,7 @@ static int iomap_fiemap_iter(struct iomap_iter *iter,
 }
 
 int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
-		u64 start, u64 len, const struct iomap_ops *ops)
+		u64 start, u64 len, iomap_iter_next_fn next)
 {
 	struct iomap_iter iter = {
 		.inode		= inode,
@@ -73,7 +73,7 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 	if (ret)
 		return ret;
 
-	while ((ret = iomap_iter(&iter, ops)) > 0)
+	while ((ret = iomap_iter(&iter, next)) > 0)
 		iter.status = iomap_fiemap_iter(&iter, fi, &prev);
 
 	/* inode with no (attribute) mapping will give ENOENT */
@@ -92,7 +92,7 @@ EXPORT_SYMBOL_GPL(iomap_fiemap);
 /* legacy ->bmap interface.  0 is the error return (!) */
 sector_t
 iomap_bmap(struct address_space *mapping, sector_t bno,
-		const struct iomap_ops *ops)
+		iomap_iter_next_fn next)
 {
 	struct iomap_iter iter = {
 		.inode	= mapping->host,
@@ -107,7 +107,7 @@ iomap_bmap(struct address_space *mapping, sector_t bno,
 		return 0;
 
 	bno = 0;
-	while ((ret = iomap_iter(&iter, ops)) > 0) {
+	while ((ret = iomap_iter(&iter, next)) > 0) {
 		if (iter.iomap.type == IOMAP_MAPPED)
 			bno = iomap_sector(&iter.iomap, iter.pos) >> blkshift;
 		/* leave iter.status unset to abort loop */
diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index 8b6da9750a93..771b60fd1022 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -101,7 +101,7 @@ EXPORT_SYMBOL_GPL(iomap_iter_continue);
 /**
  * iomap_iter - iterate over ranges in a file
  * @iter: iteration structure
- * @ops: iomap ops provided by the filesystem
+ * @next: the iomap iteration function for the filesystem
  *
  * Iterate over filesystem-provided space mappings for the provided file range.
  *
@@ -113,14 +113,13 @@ EXPORT_SYMBOL_GPL(iomap_iter_continue);
  * of the loop body:  leave @iter.status unchanged, or set it to a negative
  * errno.
  */
-int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
+int iomap_iter(struct iomap_iter *iter, iomap_iter_next_fn next)
 {
 	int ret;
 
-	trace_iomap_iter(iter, ops, _RET_IP_);
-
-	ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
+	trace_iomap_iter(iter, next, _RET_IP_);
 
+	ret = next(iter, &iter->iomap, &iter->srcmap);
 	iter->status = 0;
 	if (ret > 0)
 		iomap_iter_done(iter);
diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
index 6cbc587c93da..6fd3173d25f5 100644
--- a/fs/iomap/seek.c
+++ b/fs/iomap/seek.c
@@ -27,7 +27,7 @@ static int iomap_seek_hole_iter(struct iomap_iter *iter,
 }
 
 loff_t
-iomap_seek_hole(struct inode *inode, loff_t pos, const struct iomap_ops *ops)
+iomap_seek_hole(struct inode *inode, loff_t pos, iomap_iter_next_fn next)
 {
 	loff_t size = i_size_read(inode);
 	struct iomap_iter iter = {
@@ -42,7 +42,7 @@ iomap_seek_hole(struct inode *inode, loff_t pos, const struct iomap_ops *ops)
 		return -ENXIO;
 
 	iter.len = size - pos;
-	while ((ret = iomap_iter(&iter, ops)) > 0)
+	while ((ret = iomap_iter(&iter, next)) > 0)
 		iter.status = iomap_seek_hole_iter(&iter, &pos);
 	if (ret < 0)
 		return ret;
@@ -73,7 +73,7 @@ static int iomap_seek_data_iter(struct iomap_iter *iter,
 }
 
 loff_t
-iomap_seek_data(struct inode *inode, loff_t pos, const struct iomap_ops *ops)
+iomap_seek_data(struct inode *inode, loff_t pos, iomap_iter_next_fn next)
 {
 	loff_t size = i_size_read(inode);
 	struct iomap_iter iter = {
@@ -88,7 +88,7 @@ iomap_seek_data(struct inode *inode, loff_t pos, const struct iomap_ops *ops)
 		return -ENXIO;
 
 	iter.len = size - pos;
-	while ((ret = iomap_iter(&iter, ops)) > 0)
+	while ((ret = iomap_iter(&iter, next)) > 0)
 		iter.status = iomap_seek_data_iter(&iter, &pos);
 	if (ret < 0)
 		return ret;
diff --git a/fs/iomap/swapfile.c b/fs/iomap/swapfile.c
index 0db77c449467..c59f67a7de09 100644
--- a/fs/iomap/swapfile.c
+++ b/fs/iomap/swapfile.c
@@ -139,7 +139,7 @@ static int iomap_swapfile_iter(struct iomap_iter *iter,
  */
 int iomap_swapfile_activate(struct swap_info_struct *sis,
 		struct file *swap_file, sector_t *pagespan,
-		const struct iomap_ops *ops)
+		iomap_iter_next_fn next)
 {
 	struct inode *inode = swap_file->f_mapping->host;
 	struct iomap_iter iter = {
@@ -163,7 +163,7 @@ int iomap_swapfile_activate(struct swap_info_struct *sis,
 	if (ret)
 		return ret;
 
-	while ((ret = iomap_iter(&iter, ops)) > 0)
+	while ((ret = iomap_iter(&iter, next)) > 0)
 		iter.status = iomap_swapfile_iter(&iter, &iter.iomap, &isi);
 	if (ret < 0)
 		return ret;
diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
index e1ea8392cf47..d36a77b854aa 100644
--- a/fs/iomap/trace.h
+++ b/fs/iomap/trace.h
@@ -218,9 +218,9 @@ TRACE_EVENT(iomap_add_to_ioend,
 );
 
 TRACE_EVENT(iomap_iter,
-	TP_PROTO(struct iomap_iter *iter, const void *ops,
+	TP_PROTO(struct iomap_iter *iter, const void *next,
 		 unsigned long caller),
-	TP_ARGS(iter, ops, caller),
+	TP_ARGS(iter, next, caller),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(u64, ino)
@@ -228,7 +228,7 @@ TRACE_EVENT(iomap_iter,
 		__field(u64, length)
 		__field(int, status)
 		__field(unsigned int, flags)
-		__field(const void *, ops)
+		__field(const void *, next)
 		__field(unsigned long, caller)
 	),
 	TP_fast_assign(
@@ -238,10 +238,10 @@ TRACE_EVENT(iomap_iter,
 		__entry->length = iomap_length(iter);
 		__entry->status = iter->status;
 		__entry->flags = iter->flags;
-		__entry->ops = ops;
+		__entry->next = next;
 		__entry->caller = caller;
 	),
-	TP_printk("dev %d:%d ino 0x%llx pos 0x%llx length 0x%llx status %d flags %s (0x%x) ops %ps caller %pS",
+	TP_printk("dev %d:%d ino 0x%llx pos 0x%llx length 0x%llx status %d flags %s (0x%x) next %ps caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		   __entry->ino,
 		   __entry->pos,
@@ -249,7 +249,7 @@ TRACE_EVENT(iomap_iter,
 		   __entry->status,
 		   __print_flags(__entry->flags, "|", IOMAP_FLAGS_STRINGS),
 		   __entry->flags,
-		   __entry->ops,
+		   __entry->next,
 		   (void *)__entry->caller)
 );
 
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 30dd8e5ebe5b..d1bf52b00349 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -149,7 +149,7 @@ static ssize_t nilfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		inode_lock_shared(inode);
-		ret = iomap_dio_rw(iocb, to, &nilfs_iomap_ops,
+		ret = iomap_dio_rw(iocb, to, nilfs_iomap_next,
 				   NULL, 0, NULL, 0);
 		inode_unlock_shared(inode);
 	} else
diff --git a/fs/nilfs2/iomap.c b/fs/nilfs2/iomap.c
index 359786c97f2b..c00189ade861 100644
--- a/fs/nilfs2/iomap.c
+++ b/fs/nilfs2/iomap.c
@@ -67,8 +67,4 @@ static int nilfs_iomap_begin(struct inode *inode, loff_t offset,
 	return 0;
 }
 
-static DEFINE_IOMAP_ITER_NEXT(nilfs_iomap_next, nilfs_iomap_begin);
-
-const struct iomap_ops nilfs_iomap_ops = {
-	.iomap_next = nilfs_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT(nilfs_iomap_next, nilfs_iomap_begin);
diff --git a/fs/nilfs2/iomap.h b/fs/nilfs2/iomap.h
index adef3e22346d..5f9c05bd1230 100644
--- a/fs/nilfs2/iomap.h
+++ b/fs/nilfs2/iomap.h
@@ -8,6 +8,8 @@
 #ifndef _NILFS_IOMAP_H
 #define _NILFS_IOMAP_H
 
-extern const struct iomap_ops nilfs_iomap_ops;
+#include <linux/iomap.h>
+
+DECLARE_IOMAP_ITER_NEXT(nilfs_iomap_next);
 
 #endif /* _NILFS_IOMAP_H */
diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index ad781674fef1..cb3d5443ee1d 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -103,7 +103,7 @@ static int ntfs_read_folio(struct file *file, struct folio *folio)
 			return ntfs_read_compressed_block(folio);
 	}
 
-	iomap_read_folio(&ntfs_read_iomap_ops, &ctx, NULL);
+	iomap_read_folio(ntfs_read_iomap_next, &ctx, NULL);
 	return 0;
 }
 
@@ -247,7 +247,7 @@ static void ntfs_readahead(struct readahead_control *rac)
 	if (!NInoNonResident(ni) || NInoEncrypted(ni) || NInoCompressed(ni) ||
 	    NInoWofCompressed(ni))
 		return;
-	iomap_readahead(&ntfs_read_iomap_ops, &ctx, NULL);
+	iomap_readahead(ntfs_read_iomap_next, &ctx, NULL);
 }
 
 static int ntfs_writepages(struct address_space *mapping,
@@ -301,7 +301,7 @@ static int ntfs_swap_activate(struct swap_info_struct *sis,
 		return -EOPNOTSUPP;
 
 	return iomap_swapfile_activate(sis, swap_file, span,
-			&ntfs_read_iomap_ops);
+			ntfs_read_iomap_next);
 }
 
 const struct address_space_operations ntfs_aops = {
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index b2f5882d9990..1861d0f07fef 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -686,12 +686,12 @@ loff_t ntfs_file_llseek(struct file *file, loff_t offset, int whence)
 	switch (whence) {
 	case SEEK_HOLE:
 		inode_lock_shared(inode);
-		offset = iomap_seek_hole(inode, offset, &ntfs_seek_iomap_ops);
+		offset = iomap_seek_hole(inode, offset, ntfs_seek_iomap_next);
 		inode_unlock_shared(inode);
 		break;
 	case SEEK_DATA:
 		inode_lock_shared(inode);
-		offset = iomap_seek_data(inode, offset, &ntfs_seek_iomap_ops);
+		offset = iomap_seek_data(inode, offset, ntfs_seek_iomap_next);
 		inode_unlock_shared(inode);
 		break;
 	default:
@@ -728,7 +728,7 @@ ssize_t ntfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		}
 
 		file_accessed(iocb->ki_filp);
-		ret = iomap_dio_rw(iocb, to, &ntfs_read_iomap_ops, NULL, 0,
+		ret = iomap_dio_rw(iocb, to, ntfs_read_iomap_next, NULL, 0,
 				NULL, 0);
 	} else {
 		ret = generic_file_read_iter(iocb, to);
@@ -770,7 +770,7 @@ static ssize_t ntfs_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	ssize_t ret;
 
-	ret = iomap_dio_rw(iocb, from, &ntfs_dio_iomap_ops,
+	ret = iomap_dio_rw(iocb, from, ntfs_dio_iomap_next,
 			&ntfs_write_dio_ops, 0, NULL, 0);
 	if (ret == -ENOTBLK)
 		ret = 0;
@@ -798,7 +798,7 @@ static ssize_t ntfs_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		inode_dio_wait(file_inode(iocb->ki_filp));
 
 		written = iomap_file_buffered_write(iocb, from,
-				&ntfs_write_iomap_ops, &ntfs_iomap_folio_ops,
+				ntfs_write_iomap_next, &ntfs_iomap_folio_ops,
 				NULL);
 		if (written < 0) {
 			ret = written;
@@ -930,7 +930,7 @@ ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (NInoNonResident(ni) && iocb->ki_flags & IOCB_DIRECT)
 		ret = ntfs_dio_write_iter(iocb, from);
 	else
-		ret = iomap_file_buffered_write(iocb, from, &ntfs_write_iomap_ops,
+		ret = iomap_file_buffered_write(iocb, from, ntfs_write_iomap_next,
 				&ntfs_iomap_folio_ops, NULL);
 out:
 	if (ret < 0 && ret != -EIOCBQUEUED) {
@@ -1017,7 +1017,7 @@ static vm_fault_t ntfs_filemap_page_mkwrite(struct vm_fault *vmf)
 	 * exclusively while invalidating pagecache and changing extents.
 	 */
 	filemap_invalidate_lock_shared(mapping);
-	ret = iomap_page_mkwrite(vmf, &ntfs_page_mkwrite_iomap_ops, NULL);
+	ret = iomap_page_mkwrite(vmf, ntfs_page_mkwrite_iomap_next, NULL);
 	filemap_invalidate_unlock_shared(mapping);
 	sb_end_pagefault(inode->i_sb);
 	return ret;
@@ -1072,7 +1072,7 @@ int ntfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	if (NInoWofCompressed(NTFS_I(inode)))
 		return -EOPNOTSUPP;
 
-	return iomap_fiemap(inode, fieinfo, start, len, &ntfs_read_iomap_ops);
+	return iomap_fiemap(inode, fieinfo, start, len, ntfs_read_iomap_next);
 }
 
 static const char *ntfs_get_link(struct dentry *dentry, struct inode *inode,
@@ -1322,7 +1322,7 @@ static int ntfs_punch_hole(struct ntfs_inode *ni, int mode, loff_t offset,
 				   ntfs_cluster_to_bytes(vol, start_vcn + 1),
 				   end_offset);
 			err = iomap_zero_range(vi, offset, to - offset,
-					       NULL, &ntfs_seek_iomap_ops,
+					       NULL, ntfs_seek_iomap_next,
 					       &ntfs_iomap_folio_ops, NULL);
 			if (err < 0)
 				goto out;
@@ -1338,7 +1338,7 @@ static int ntfs_punch_hole(struct ntfs_inode *ni, int mode, loff_t offset,
 		from = ntfs_cluster_to_bytes(vol, end_vcn - 1);
 		if (from < ni->initialized_size) {
 			err = iomap_zero_range(vi, from, end_offset - from,
-					       NULL, &ntfs_seek_iomap_ops,
+					       NULL, ntfs_seek_iomap_next,
 					       &ntfs_iomap_folio_ops, NULL);
 			if (err < 0)
 				goto out;
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 206db4e99ef1..a453d103445b 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2589,7 +2589,7 @@ int ntfs_extend_initialized_size(struct inode *vi, const loff_t offset,
 		if (old_init_size < offset) {
 			err = iomap_zero_range(vi, old_init_size,
 					       offset - old_init_size,
-					       NULL, &ntfs_seek_iomap_ops,
+					       NULL, ntfs_seek_iomap_next,
 					       &ntfs_iomap_folio_ops, NULL);
 			if (err)
 				goto out;
diff --git a/fs/ntfs/iomap.c b/fs/ntfs/iomap.c
index 6e51cce3aeba..72f85fc07b6e 100644
--- a/fs/ntfs/iomap.c
+++ b/fs/ntfs/iomap.c
@@ -293,12 +293,8 @@ static int ntfs_read_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return written;
 }
 
-static DEFINE_IOMAP_ITER_NEXT_END(ntfs_read_iomap_next,
-		ntfs_read_iomap_begin, ntfs_read_iomap_end);
-
-const struct iomap_ops ntfs_read_iomap_ops = {
-	.iomap_next = ntfs_read_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT_END(ntfs_read_iomap_next, ntfs_read_iomap_begin,
+		ntfs_read_iomap_end);
 
 /*
  * Check that the cached iomap still matches the NTFS runlist before
@@ -351,15 +347,7 @@ static int ntfs_zero_read_iomap_end(struct inode *inode, loff_t pos, loff_t leng
 static DEFINE_IOMAP_ITER_NEXT_END(ntfs_zero_read_iomap_next,
 		ntfs_seek_iomap_begin, ntfs_zero_read_iomap_end);
 
-static const struct iomap_ops ntfs_zero_read_iomap_ops = {
-	.iomap_next = ntfs_zero_read_iomap_next,
-};
-
-static DEFINE_IOMAP_ITER_NEXT(ntfs_seek_iomap_next, ntfs_seek_iomap_begin);
-
-const struct iomap_ops ntfs_seek_iomap_ops = {
-	.iomap_next = ntfs_seek_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT(ntfs_seek_iomap_next, ntfs_seek_iomap_begin);
 
 int ntfs_dio_zero_range(struct inode *inode, loff_t offset, loff_t length)
 {
@@ -378,7 +366,7 @@ static int ntfs_zero_range(struct inode *inode, loff_t offset, loff_t length)
 	return iomap_zero_range(inode,
 				offset, length,
 				NULL,
-				&ntfs_zero_read_iomap_ops,
+				ntfs_zero_read_iomap_next,
 				&ntfs_zero_iomap_folio_ops,
 				NULL);
 }
@@ -782,12 +770,8 @@ static int ntfs_write_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return written;
 }
 
-static DEFINE_IOMAP_ITER_NEXT_END(ntfs_write_iomap_next,
-		ntfs_write_iomap_begin, ntfs_write_iomap_end);
-
-const struct iomap_ops ntfs_write_iomap_ops = {
-	.iomap_next		= ntfs_write_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT_END(ntfs_write_iomap_next, ntfs_write_iomap_begin,
+		ntfs_write_iomap_end);
 
 static int ntfs_page_mkwrite_iomap_begin(struct inode *inode, loff_t offset,
 				  loff_t length, unsigned int flags,
@@ -797,13 +781,9 @@ static int ntfs_page_mkwrite_iomap_begin(struct inode *inode, loff_t offset,
 			NTFS_IOMAP_FLAGS_MKWRITE);
 }
 
-static DEFINE_IOMAP_ITER_NEXT_END(ntfs_page_mkwrite_iomap_next,
+DEFINE_IOMAP_ITER_NEXT_END(ntfs_page_mkwrite_iomap_next,
 		ntfs_page_mkwrite_iomap_begin, ntfs_write_iomap_end);
 
-const struct iomap_ops ntfs_page_mkwrite_iomap_ops = {
-	.iomap_next		= ntfs_page_mkwrite_iomap_next,
-};
-
 static int ntfs_dio_iomap_begin(struct inode *inode, loff_t offset,
 				  loff_t length, unsigned int flags,
 				  struct iomap *iomap, struct iomap *srcmap)
@@ -812,12 +792,8 @@ static int ntfs_dio_iomap_begin(struct inode *inode, loff_t offset,
 			NTFS_IOMAP_FLAGS_DIO);
 }
 
-static DEFINE_IOMAP_ITER_NEXT_END(ntfs_dio_iomap_next,
-		ntfs_dio_iomap_begin, ntfs_write_iomap_end);
-
-const struct iomap_ops ntfs_dio_iomap_ops = {
-	.iomap_next		= ntfs_dio_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT_END(ntfs_dio_iomap_next, ntfs_dio_iomap_begin,
+		ntfs_write_iomap_end);
 
 static ssize_t ntfs_writeback_range(struct iomap_writepage_ctx *wpc,
 		struct folio *folio, u64 offset, unsigned int len, u64 end_pos)
diff --git a/fs/ntfs/iomap.h b/fs/ntfs/iomap.h
index 3abc1d493e91..fec8b907c48f 100644
--- a/fs/ntfs/iomap.h
+++ b/fs/ntfs/iomap.h
@@ -12,11 +12,11 @@
 #include "volume.h"
 #include "inode.h"
 
-extern const struct iomap_ops ntfs_write_iomap_ops;
-extern const struct iomap_ops ntfs_read_iomap_ops;
-extern const struct iomap_ops ntfs_seek_iomap_ops;
-extern const struct iomap_ops ntfs_page_mkwrite_iomap_ops;
-extern const struct iomap_ops ntfs_dio_iomap_ops;
+DECLARE_IOMAP_ITER_NEXT(ntfs_write_iomap_next);
+DECLARE_IOMAP_ITER_NEXT(ntfs_read_iomap_next);
+DECLARE_IOMAP_ITER_NEXT(ntfs_seek_iomap_next);
+DECLARE_IOMAP_ITER_NEXT(ntfs_page_mkwrite_iomap_next);
+DECLARE_IOMAP_ITER_NEXT(ntfs_dio_iomap_next);
 extern const struct iomap_writeback_ops ntfs_writeback_ops;
 extern const struct iomap_write_ops ntfs_iomap_folio_ops;
 extern int ntfs_dio_zero_range(struct inode *inode, loff_t offset, loff_t length);
diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 52e1cd969e06..23ce51c608a6 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -315,7 +315,7 @@ static int ntfs_extend_initialized_size(struct file *file,
 	}
 
 	err = iomap_zero_range(inode, valid, new_valid - valid, NULL,
-			       &ntfs_iomap_ops, &ntfs_iomap_folio_ops, NULL);
+			       ntfs_iomap_next, &ntfs_iomap_folio_ops, NULL);
 	if (err) {
 		ni->i_valid = valid;
 		ntfs_inode_warn(inode,
@@ -554,7 +554,7 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 		/* Zero head of punch. */
 		if (tmp > from) {
 			err = iomap_zero_range(inode, from, tmp - from, NULL,
-					       &ntfs_iomap_ops,
+					       ntfs_iomap_next,
 					       &ntfs_iomap_folio_ops, NULL);
 			if (err)
 				goto out;
@@ -572,7 +572,7 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 		/* Zero tail of punch. */
 		if (vbo < end_a && end_a < end) {
 			err = iomap_zero_range(inode, end_a, end - end_a, NULL,
-					       &ntfs_iomap_ops,
+					       ntfs_iomap_next,
 					       &ntfs_iomap_folio_ops, NULL);
 			if (err)
 				goto out;
@@ -890,7 +890,7 @@ static ssize_t ntfs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 				goto out;
 		}
 
-		ret = iomap_dio_rw(iocb, iter, &ntfs_iomap_ops, NULL, dio_flags,
+		ret = iomap_dio_rw(iocb, iter, ntfs_iomap_next, NULL, dio_flags,
 				   NULL, 0);
 
 		if (ret <= 0)
@@ -1305,7 +1305,7 @@ static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	    !ntfs_should_use_dio(iocb, from)) {
 		iocb->ki_flags &= ~IOCB_DIRECT;
 
-		ret = iomap_file_buffered_write(iocb, from, &ntfs_iomap_ops,
+		ret = iomap_file_buffered_write(iocb, from, ntfs_iomap_next,
 						&ntfs_iomap_folio_ops, NULL);
 		inode_unlock(inode);
 
@@ -1322,7 +1322,7 @@ static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			goto out;
 	}
 
-	ret = iomap_dio_rw(iocb, from, &ntfs_iomap_ops, NULL,
+	ret = iomap_dio_rw(iocb, from, ntfs_iomap_next, NULL,
 			   IOMAP_DIO_FORCE_WAIT, NULL, 0);
 
 	if (ret == -ENOTBLK) {
@@ -1335,7 +1335,7 @@ static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		vbo = iocb->ki_pos;
 
 		iocb->ki_flags &= ~IOCB_DIRECT;
-		err = iomap_file_buffered_write(iocb, from, &ntfs_iomap_ops,
+		err = iomap_file_buffered_write(iocb, from, ntfs_iomap_next,
 						&ntfs_iomap_folio_ops, NULL);
 		if (err < 0) {
 			ret = err;
@@ -1485,7 +1485,7 @@ int ntfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 	inode_lock_shared(inode);
 
-	err = iomap_fiemap(inode, fieinfo, start, len, &ntfs_iomap_ops);
+	err = iomap_fiemap(inode, fieinfo, start, len, ntfs_iomap_next);
 
 	inode_unlock_shared(inode);
 	return err;
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 5a8d362155ac..99234b8d085f 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -781,7 +781,7 @@ static sector_t ntfs_bmap(struct address_space *mapping, sector_t block)
 		ni_allocate_da_blocks(ni);
 	}
 
-	return iomap_bmap(mapping, block, &ntfs_iomap_ops);
+	return iomap_bmap(mapping, block, ntfs_iomap_next);
 }
 
 static void ntfs_iomap_read_end_io(struct bio *bio)
@@ -853,7 +853,7 @@ static int ntfs_read_folio(struct file *file, struct folio *folio)
 		return err;
 	}
 
-	iomap_read_folio(&ntfs_iomap_ops, &ctx, NULL);
+	iomap_read_folio(ntfs_iomap_next, &ctx, NULL);
 	return 0;
 }
 
@@ -877,7 +877,7 @@ static void ntfs_readahead(struct readahead_control *rac)
 		return;
 	}
 
-	iomap_readahead(&ntfs_iomap_ops, &ctx, NULL);
+	iomap_readahead(ntfs_iomap_next, &ctx, NULL);
 }
 
 int ntfs_set_size(struct inode *inode, u64 new_size)
@@ -2313,12 +2313,7 @@ const struct address_space_operations ntfs_aops_cmpr = {
 	.invalidate_folio = iomap_invalidate_folio,
 };
 
-static DEFINE_IOMAP_ITER_NEXT_END(ntfs_iomap_next, ntfs_iomap_begin,
-				  ntfs_iomap_end);
-
-const struct iomap_ops ntfs_iomap_ops = {
-	.iomap_next	= ntfs_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT_END(ntfs_iomap_next, ntfs_iomap_begin, ntfs_iomap_end);
 
 const struct iomap_write_ops ntfs_iomap_folio_ops = {
 	.put_folio = ntfs_iomap_put_folio,
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 689151fcf993..f42389469256 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -12,6 +12,7 @@
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/highmem.h>
 #include <linux/kernel.h>
 #include <linux/hex.h>
@@ -813,7 +814,7 @@ int ntfs_create_inode(const struct mnt_idmap *idmap, struct inode *dir,
 int ntfs_link_inode(struct inode *inode, struct dentry *dentry);
 int ntfs_unlink_inode(struct inode *dir, const struct dentry *dentry);
 void ntfs_evict_inode(struct inode *inode);
-extern const struct iomap_ops ntfs_iomap_ops;
+DECLARE_IOMAP_ITER_NEXT(ntfs_iomap_next);
 extern const struct iomap_write_ops ntfs_iomap_folio_ops;
 extern const struct inode_operations ntfs_link_inode_operations;
 extern const struct address_space_operations ntfs_aops;
diff --git a/fs/remap_range.c b/fs/remap_range.c
index 6eb7d845de5d..7d269837f63f 100644
--- a/fs/remap_range.c
+++ b/fs/remap_range.c
@@ -277,7 +277,7 @@ int
 __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				struct file *file_out, loff_t pos_out,
 				loff_t *len, unsigned int remap_flags,
-				const struct iomap_ops *dax_read_ops)
+				iomap_iter_next_fn dax_read_next)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -340,10 +340,10 @@ __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 		if (!IS_DAX(inode_in))
 			ret = vfs_dedupe_file_range_compare(file_in, pos_in,
 					file_out, pos_out, *len, &is_same);
-		else if (dax_read_ops)
+		else if (dax_read_next)
 			ret = dax_dedupe_file_range_compare(inode_in, pos_in,
 					inode_out, pos_out, *len, &is_same,
-					dax_read_ops);
+					dax_read_next);
 		else
 			return -EINVAL;
 		if (ret)
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index c30e688cfc9f..1db6f3640c53 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -575,7 +575,7 @@ xfs_vm_bmap(
 	 */
 	if (xfs_is_cow_inode(ip) || XFS_IS_REALTIME_INODE(ip))
 		return 0;
-	return iomap_bmap(mapping, block, &xfs_read_iomap_ops);
+	return iomap_bmap(mapping, block, xfs_read_iomap_next);
 }
 
 static void
@@ -614,7 +614,7 @@ xfs_vm_read_folio(
 	struct iomap_read_folio_ctx	ctx = { .cur_folio = folio };
 
 	ctx.ops = xfs_get_iomap_read_ops(folio->mapping);
-	iomap_read_folio(&xfs_read_iomap_ops, &ctx, NULL);
+	iomap_read_folio(xfs_read_iomap_next, &ctx, NULL);
 	return 0;
 }
 
@@ -625,7 +625,7 @@ xfs_vm_readahead(
 	struct iomap_read_folio_ctx	ctx = { .rac = rac };
 
 	ctx.ops = xfs_get_iomap_read_ops(rac->mapping),
-	iomap_readahead(&xfs_read_iomap_ops, &ctx, NULL);
+	iomap_readahead(xfs_read_iomap_next, &ctx, NULL);
 }
 
 static int
@@ -671,7 +671,7 @@ xfs_vm_swap_activate(
 	sis->bdev = xfs_inode_buftarg(ip)->bt_bdev;
 
 	return iomap_swapfile_activate(sis, swap_file, span,
-			&xfs_read_iomap_ops);
+			xfs_read_iomap_next);
 }
 
 const struct address_space_operations xfs_address_space_operations = {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7d0c8a197575..e772347aff9a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -250,12 +250,12 @@ xfs_file_dio_read(
 	if (ret)
 		return ret;
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
-		ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops,
+		ret = iomap_dio_rw(iocb, to, xfs_read_iomap_next,
 				&xfs_dio_read_bounce_ops, 0, NULL, 0);
 	} else {
 		ret = iomap_dio_read_simple(iocb, to, xfs_read_iomap_begin);
 		if (ret == -ENOTBLK)
-			ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL,
+			ret = iomap_dio_rw(iocb, to, xfs_read_iomap_next, NULL,
 					0, NULL, 0);
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
@@ -279,7 +279,7 @@ xfs_file_dax_read(
 	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
 	if (ret)
 		return ret;
-	ret = dax_iomap_rw(iocb, to, &xfs_read_iomap_ops);
+	ret = dax_iomap_rw(iocb, to, xfs_read_iomap_next);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	file_accessed(iocb->ki_filp);
@@ -729,7 +729,7 @@ xfs_file_dio_write_aligned(
 	struct xfs_inode	*ip,
 	struct kiocb		*iocb,
 	struct iov_iter		*from,
-	const struct iomap_ops	*ops,
+	iomap_iter_next_fn	next,
 	const struct iomap_dio_ops *dops,
 	struct xfs_zone_alloc_ctx *ac)
 {
@@ -764,7 +764,7 @@ xfs_file_dio_write_aligned(
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping))
 		dio_flags |= IOMAP_DIO_BOUNCE;
 	trace_xfs_file_direct_write(iocb, from);
-	ret = iomap_dio_rw(iocb, from, ops, dops, dio_flags, ac, 0);
+	ret = iomap_dio_rw(iocb, from, next, dops, dio_flags, ac, 0);
 out_unlock:
 	xfs_iunlock(ip, iolock);
 	return ret;
@@ -786,7 +786,7 @@ xfs_file_dio_write_zoned(
 	if (ret < 0)
 		return ret;
 	ret = xfs_file_dio_write_aligned(ip, iocb, from,
-			&xfs_zoned_direct_write_iomap_ops,
+			xfs_zoned_direct_write_iomap_next,
 			&xfs_dio_zoned_write_ops, &ac);
 	xfs_zoned_space_unreserve(ip->i_mount, &ac);
 	return ret;
@@ -811,16 +811,16 @@ xfs_file_dio_write_atomic(
 	unsigned int		iolock = XFS_IOLOCK_SHARED;
 	ssize_t			ret, ocount = iov_iter_count(from);
 	unsigned int		dio_flags = 0;
-	const struct iomap_ops	*dops;
+	iomap_iter_next_fn	next;
 
 	/*
 	 * HW offload should be faster, so try that first if it is already
 	 * known that the write length is not too large.
 	 */
 	if (ocount > xfs_inode_buftarg(ip)->bt_awu_max)
-		dops = &xfs_atomic_write_cow_iomap_ops;
+		next = xfs_atomic_write_cow_iomap_next;
 	else
-		dops = &xfs_direct_write_iomap_ops;
+		next = xfs_direct_write_iomap_next;
 
 retry:
 	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
@@ -840,18 +840,19 @@ xfs_file_dio_write_atomic(
 	trace_xfs_file_direct_write(iocb, from);
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping))
 		dio_flags |= IOMAP_DIO_BOUNCE;
-	ret = iomap_dio_rw(iocb, from, dops, &xfs_dio_write_ops, dio_flags,
+	ret = iomap_dio_rw(iocb, from, next, &xfs_dio_write_ops, dio_flags,
 			NULL, 0);
 
 	/*
-	 * The retry mechanism is based on the ->iomap_next method returning
-	 * -ENOPROTOOPT, which would be when the REQ_ATOMIC-based write is not
-	 * possible. The REQ_ATOMIC-based method is typically not possible if
-	 * the write spans multiple extents or the disk blocks are misaligned.
+	 * The retry mechanism is based on the iomap_iter_next_fn callback
+	 * returning -ENOPROTOOPT, which would be when the REQ_ATOMIC-based
+	 * write is not possible. The REQ_ATOMIC-based method is typically not
+	 * possible if the write spans multiple extents or the disk blocks are
+	 * misaligned.
 	 */
-	if (ret == -ENOPROTOOPT && dops == &xfs_direct_write_iomap_ops) {
+	if (ret == -ENOPROTOOPT && next == xfs_direct_write_iomap_next) {
 		xfs_iunlock(ip, iolock);
-		dops = &xfs_atomic_write_cow_iomap_ops;
+		next = xfs_atomic_write_cow_iomap_next;
 		goto retry;
 	}
 
@@ -934,7 +935,7 @@ xfs_file_dio_write_unaligned(
 		flags |= IOMAP_DIO_BOUNCE;
 
 	trace_xfs_file_direct_write(iocb, from);
-	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
+	ret = iomap_dio_rw(iocb, from, xfs_direct_write_iomap_next,
 			   &xfs_dio_write_ops, flags, NULL, 0);
 
 	/*
@@ -974,7 +975,7 @@ xfs_file_dio_write(
 	if (iocb->ki_flags & IOCB_ATOMIC)
 		return xfs_file_dio_write_atomic(ip, iocb, from);
 	return xfs_file_dio_write_aligned(ip, iocb, from,
-			&xfs_direct_write_iomap_ops, &xfs_dio_write_ops, NULL);
+			xfs_direct_write_iomap_next, &xfs_dio_write_ops, NULL);
 }
 
 static noinline ssize_t
@@ -998,7 +999,7 @@ xfs_file_dax_write(
 	pos = iocb->ki_pos;
 
 	trace_xfs_file_dax_write(iocb, from);
-	ret = dax_iomap_rw(iocb, from, &xfs_dax_write_iomap_ops);
+	ret = dax_iomap_rw(iocb, from, xfs_dax_write_iomap_next);
 	if (ret > 0 && iocb->ki_pos > i_size_read(inode)) {
 		i_size_write(inode, iocb->ki_pos);
 		error = xfs_setfilesize(ip, pos, ret);
@@ -1041,7 +1042,7 @@ xfs_file_buffered_write(
 
 	trace_xfs_file_buffered_write(iocb, from);
 	ret = iomap_file_buffered_write(iocb, from,
-			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
+			xfs_buffered_write_iomap_next, &xfs_iomap_write_ops,
 			NULL);
 
 	/*
@@ -1122,7 +1123,7 @@ xfs_file_buffered_write_zoned(
 retry:
 	trace_xfs_file_buffered_write(iocb, from);
 	ret = iomap_file_buffered_write(iocb, from,
-			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
+			xfs_buffered_write_iomap_next, &xfs_iomap_write_ops,
 			&ac);
 	if (ret == -ENOSPC && !cleared_space) {
 		/*
@@ -1931,10 +1932,10 @@ xfs_file_llseek(
 	default:
 		return generic_file_llseek(file, offset, whence);
 	case SEEK_HOLE:
-		offset = iomap_seek_hole(inode, offset, &xfs_seek_iomap_ops);
+		offset = iomap_seek_hole(inode, offset, xfs_seek_iomap_next);
 		break;
 	case SEEK_DATA:
-		offset = iomap_seek_data(inode, offset, &xfs_seek_iomap_ops);
+		offset = iomap_seek_data(inode, offset, xfs_seek_iomap_next);
 		break;
 	}
 
@@ -1958,8 +1959,8 @@ xfs_dax_fault_locked(
 	}
 	ret = dax_iomap_fault(vmf, order, &pfn, NULL,
 			(write_fault && !vmf->cow_page) ?
-				&xfs_dax_write_iomap_ops :
-				&xfs_read_iomap_ops);
+				xfs_dax_write_iomap_next :
+				xfs_read_iomap_next);
 	if (ret & VM_FAULT_NEEDDSYNC)
 		ret = dax_finish_sync_fault(vmf, order, pfn);
 	return ret;
@@ -2023,7 +2024,7 @@ __xfs_write_fault(
 	if (IS_DAX(inode))
 		ret = xfs_dax_fault_locked(vmf, order, true);
 	else
-		ret = iomap_page_mkwrite(vmf, &xfs_buffered_write_iomap_ops,
+		ret = iomap_page_mkwrite(vmf, xfs_buffered_write_iomap_next,
 				ac);
 	xfs_iunlock(ip, lock_mode);
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 329c745e3120..c591fb07a62d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1037,13 +1037,9 @@ xfs_direct_write_iomap_begin(
 	return error;
 }
 
-static DEFINE_IOMAP_ITER_NEXT(xfs_direct_write_iomap_next,
+DEFINE_IOMAP_ITER_NEXT(xfs_direct_write_iomap_next,
 		xfs_direct_write_iomap_begin);
 
-const struct iomap_ops xfs_direct_write_iomap_ops = {
-	.iomap_next		= xfs_direct_write_iomap_next,
-};
-
 #ifdef CONFIG_XFS_RT
 /*
  * This is really simple.  The space has already been reserved before taking the
@@ -1087,12 +1083,9 @@ xfs_zoned_direct_write_iomap_begin(
 	return 0;
 }
 
-static DEFINE_IOMAP_ITER_NEXT(xfs_zoned_direct_write_iomap_next,
+DEFINE_IOMAP_ITER_NEXT(xfs_zoned_direct_write_iomap_next,
 		xfs_zoned_direct_write_iomap_begin);
 
-const struct iomap_ops xfs_zoned_direct_write_iomap_ops = {
-	.iomap_next		= xfs_zoned_direct_write_iomap_next,
-};
 #endif /* CONFIG_XFS_RT */
 
 #ifdef DEBUG
@@ -1275,13 +1268,9 @@ xfs_atomic_write_cow_iomap_begin(
 	return error;
 }
 
-static DEFINE_IOMAP_ITER_NEXT(xfs_atomic_write_cow_iomap_next,
+DEFINE_IOMAP_ITER_NEXT(xfs_atomic_write_cow_iomap_next,
 		xfs_atomic_write_cow_iomap_begin);
 
-const struct iomap_ops xfs_atomic_write_cow_iomap_ops = {
-	.iomap_next		= xfs_atomic_write_cow_iomap_next,
-};
-
 static int
 xfs_dax_write_iomap_end(
 	struct inode		*inode,
@@ -1302,13 +1291,9 @@ xfs_dax_write_iomap_end(
 	return xfs_reflink_end_cow(ip, pos, written);
 }
 
-static DEFINE_IOMAP_ITER_NEXT_END(xfs_dax_write_iomap_next,
+DEFINE_IOMAP_ITER_NEXT_END(xfs_dax_write_iomap_next,
 		xfs_direct_write_iomap_begin, xfs_dax_write_iomap_end);
 
-const struct iomap_ops xfs_dax_write_iomap_ops = {
-	.iomap_next	= xfs_dax_write_iomap_next,
-};
-
 /*
  * Convert a hole to a delayed allocation.
  */
@@ -2191,13 +2176,9 @@ xfs_buffered_write_iomap_end(
 	return 0;
 }
 
-static DEFINE_IOMAP_ITER_NEXT_END(xfs_buffered_write_iomap_next,
+DEFINE_IOMAP_ITER_NEXT_END(xfs_buffered_write_iomap_next,
 		xfs_buffered_write_iomap_begin, xfs_buffered_write_iomap_end);
 
-const struct iomap_ops xfs_buffered_write_iomap_ops = {
-	.iomap_next		= xfs_buffered_write_iomap_next,
-};
-
 int
 xfs_read_iomap_begin(
 	struct inode		*inode,
@@ -2239,11 +2220,7 @@ xfs_read_iomap_begin(
 				 shared ? IOMAP_F_SHARED : 0, seq);
 }
 
-static DEFINE_IOMAP_ITER_NEXT(xfs_read_iomap_next, xfs_read_iomap_begin);
-
-const struct iomap_ops xfs_read_iomap_ops = {
-	.iomap_next		= xfs_read_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT(xfs_read_iomap_next, xfs_read_iomap_begin);
 
 static int
 xfs_seek_iomap_begin(
@@ -2329,11 +2306,7 @@ xfs_seek_iomap_begin(
 	return error;
 }
 
-static DEFINE_IOMAP_ITER_NEXT(xfs_seek_iomap_next, xfs_seek_iomap_begin);
-
-const struct iomap_ops xfs_seek_iomap_ops = {
-	.iomap_next		= xfs_seek_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT(xfs_seek_iomap_next, xfs_seek_iomap_begin);
 
 static int
 xfs_xattr_iomap_begin(
@@ -2378,11 +2351,7 @@ xfs_xattr_iomap_begin(
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_XATTR, seq);
 }
 
-static DEFINE_IOMAP_ITER_NEXT(xfs_xattr_iomap_next, xfs_xattr_iomap_begin);
-
-const struct iomap_ops xfs_xattr_iomap_ops = {
-	.iomap_next		= xfs_xattr_iomap_next,
-};
+DEFINE_IOMAP_ITER_NEXT(xfs_xattr_iomap_next, xfs_xattr_iomap_begin);
 
 int
 xfs_zero_range(
@@ -2398,9 +2367,9 @@ xfs_zero_range(
 
 	if (IS_DAX(inode))
 		return dax_zero_range(inode, pos, len, did_zero,
-				      &xfs_dax_write_iomap_ops);
+				      xfs_dax_write_iomap_next);
 	return iomap_zero_range(inode, pos, len, did_zero,
-			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
+			xfs_buffered_write_iomap_next, &xfs_iomap_write_ops,
 			ac);
 }
 
@@ -2415,8 +2384,8 @@ xfs_truncate_page(
 
 	if (IS_DAX(inode))
 		return dax_truncate_page(inode, pos, did_zero,
-					&xfs_dax_write_iomap_ops);
+					xfs_dax_write_iomap_next);
 	return iomap_truncate_page(inode, pos, did_zero,
-			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
+			xfs_buffered_write_iomap_next, &xfs_iomap_write_ops,
 			ac);
 }
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index f2520a9b3a13..974e4ed34f1d 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -69,14 +69,14 @@ int xfs_read_iomap_begin(struct inode *inode, loff_t offset,
 		loff_t length, unsigned flags, struct iomap *iomap,
 		struct iomap *srcmap);
 
-extern const struct iomap_ops xfs_buffered_write_iomap_ops;
-extern const struct iomap_ops xfs_direct_write_iomap_ops;
-extern const struct iomap_ops xfs_zoned_direct_write_iomap_ops;
-extern const struct iomap_ops xfs_read_iomap_ops;
-extern const struct iomap_ops xfs_seek_iomap_ops;
-extern const struct iomap_ops xfs_xattr_iomap_ops;
-extern const struct iomap_ops xfs_dax_write_iomap_ops;
-extern const struct iomap_ops xfs_atomic_write_cow_iomap_ops;
+DECLARE_IOMAP_ITER_NEXT(xfs_buffered_write_iomap_next);
+DECLARE_IOMAP_ITER_NEXT(xfs_direct_write_iomap_next);
+DECLARE_IOMAP_ITER_NEXT(xfs_zoned_direct_write_iomap_next);
+DECLARE_IOMAP_ITER_NEXT(xfs_read_iomap_next);
+DECLARE_IOMAP_ITER_NEXT(xfs_seek_iomap_next);
+DECLARE_IOMAP_ITER_NEXT(xfs_xattr_iomap_next);
+DECLARE_IOMAP_ITER_NEXT(xfs_dax_write_iomap_next);
+DECLARE_IOMAP_ITER_NEXT(xfs_atomic_write_cow_iomap_next);
 extern const struct iomap_write_ops xfs_iomap_write_ops;
 
 #endif /* __XFS_IOMAP_H__*/
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d307ec97fac8..6c5633db30da 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1256,10 +1256,10 @@ xfs_vn_fiemap(
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
 		fieinfo->fi_flags &= ~FIEMAP_FLAG_XATTR;
 		error = iomap_fiemap(inode, fieinfo, start, length,
-				&xfs_xattr_iomap_ops);
+				xfs_xattr_iomap_next);
 	} else {
 		error = iomap_fiemap(inode, fieinfo, start, length,
-				&xfs_read_iomap_ops);
+				xfs_read_iomap_next);
 	}
 	xfs_iunlock(XFS_I(inode), XFS_IOLOCK_SHARED);
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 104542b10d9e..c5c796e2b83d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1724,7 +1724,7 @@ xfs_reflink_remap_prep(
 				pos_out, len, remap_flags);
 	else
 		ret = dax_remap_file_range_prep(file_in, pos_in, file_out,
-				pos_out, len, remap_flags, &xfs_read_iomap_ops);
+				pos_out, len, remap_flags, xfs_read_iomap_next);
 	if (ret || *len == 0)
 		goto out_unlock;
 
@@ -1919,10 +1919,10 @@ xfs_reflink_unshare(
 
 	if (IS_DAX(inode))
 		error = dax_file_unshare(inode, offset, len,
-				&xfs_dax_write_iomap_ops);
+				xfs_dax_write_iomap_next);
 	else
 		error = iomap_file_unshare(inode, offset, len,
-				&xfs_buffered_write_iomap_ops,
+				xfs_buffered_write_iomap_next,
 				&xfs_iomap_write_ops);
 	if (error)
 		goto out;
diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 5b34849be7a2..319d9502ba56 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -59,10 +59,6 @@ static int zonefs_read_iomap_begin(struct inode *inode, loff_t offset,
 
 static DEFINE_IOMAP_ITER_NEXT(zonefs_read_iomap_next, zonefs_read_iomap_begin);
 
-static const struct iomap_ops zonefs_read_iomap_ops = {
-	.iomap_next	= zonefs_read_iomap_next,
-};
-
 static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
 				    loff_t length, unsigned int flags,
 				    struct iomap *iomap, struct iomap *srcmap)
@@ -111,19 +107,15 @@ static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
 static DEFINE_IOMAP_ITER_NEXT(zonefs_write_iomap_next,
 			      zonefs_write_iomap_begin);
 
-static const struct iomap_ops zonefs_write_iomap_ops = {
-	.iomap_next	= zonefs_write_iomap_next,
-};
-
 static int zonefs_read_folio(struct file *unused, struct folio *folio)
 {
-	iomap_bio_read_folio(folio, &zonefs_read_iomap_ops);
+	iomap_bio_read_folio(folio, zonefs_read_iomap_next);
 	return 0;
 }
 
 static void zonefs_readahead(struct readahead_control *rac)
 {
-	iomap_bio_readahead(rac, &zonefs_read_iomap_ops);
+	iomap_bio_readahead(rac, zonefs_read_iomap_next);
 }
 
 /*
@@ -184,7 +176,7 @@ static int zonefs_swap_activate(struct swap_info_struct *sis,
 	}
 
 	return iomap_swapfile_activate(sis, swap_file, span,
-				       &zonefs_read_iomap_ops);
+				       zonefs_read_iomap_next);
 }
 
 const struct address_space_operations zonefs_file_aops = {
@@ -314,7 +306,7 @@ static vm_fault_t zonefs_filemap_page_mkwrite(struct vm_fault *vmf)
 
 	/* Serialize against truncates */
 	filemap_invalidate_lock_shared(inode->i_mapping);
-	ret = iomap_page_mkwrite(vmf, &zonefs_write_iomap_ops, NULL);
+	ret = iomap_page_mkwrite(vmf, zonefs_write_iomap_next, NULL);
 	filemap_invalidate_unlock_shared(inode->i_mapping);
 
 	sb_end_pagefault(inode->i_sb);
@@ -530,7 +522,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
 	 * page invalidation. Overwrite that error code with EBUSY so that
 	 * the user can make sense of the error.
 	 */
-	ret = iomap_dio_rw(iocb, from, &zonefs_write_iomap_ops,
+	ret = iomap_dio_rw(iocb, from, zonefs_write_iomap_next,
 			   &zonefs_write_dio_ops, 0, NULL, 0);
 	if (ret == -ENOTBLK)
 		ret = -EBUSY;
@@ -580,7 +572,7 @@ static ssize_t zonefs_file_buffered_write(struct kiocb *iocb,
 	if (ret <= 0)
 		goto inode_unlock;
 
-	ret = iomap_file_buffered_write(iocb, from, &zonefs_write_iomap_ops,
+	ret = iomap_file_buffered_write(iocb, from, zonefs_write_iomap_next,
 			NULL, NULL);
 	if (ret == -EIO)
 		zonefs_io_error(inode, true);
@@ -675,7 +667,7 @@ static ssize_t zonefs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			goto inode_unlock;
 		}
 		file_accessed(iocb->ki_filp);
-		ret = iomap_dio_rw(iocb, to, &zonefs_read_iomap_ops,
+		ret = iomap_dio_rw(iocb, to, zonefs_read_iomap_next,
 				   &zonefs_read_dio_ops, 0, NULL, 0);
 	} else {
 		ret = generic_file_read_iter(iocb, to);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index a3af0c63c61b..2e0797e4d408 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -3,6 +3,7 @@
 #define _LINUX_DAX_H
 
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/mm.h>
 #include <linux/radix-tree.h>
 
@@ -10,9 +11,6 @@ typedef unsigned long dax_entry_t;
 
 struct dax_device;
 struct gendisk;
-struct iomap_ops;
-struct iomap_iter;
-struct iomap;
 
 enum dax_access_mode {
 	DAX_ACCESS,
@@ -200,11 +198,11 @@ static inline void dax_unlock_mapping_entry(struct address_space *mapping,
 #endif
 
 int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
-		const struct iomap_ops *ops);
+		iomap_iter_next_fn next);
 int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
-		const struct iomap_ops *ops);
+		iomap_iter_next_fn next);
 int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
-		const struct iomap_ops *ops);
+		iomap_iter_next_fn next);
 
 static inline bool dax_page_is_idle(struct page *page)
 {
@@ -253,10 +251,10 @@ int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off, u64 len,
 void dax_flush(struct dax_device *dax_dev, void *addr, size_t size);
 
 ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
-		const struct iomap_ops *ops);
+		iomap_iter_next_fn next);
 vm_fault_t dax_iomap_fault(struct vm_fault *vmf, unsigned int order,
 			unsigned long *pfnp, int *errp,
-			const struct iomap_ops *ops);
+			iomap_iter_next_fn next);
 vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 		unsigned int order, unsigned long pfn);
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
@@ -275,11 +273,11 @@ void dax_break_layout_final(struct inode *inode);
 int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 				  struct inode *dest, loff_t destoff,
 				  loff_t len, bool *is_same,
-				  const struct iomap_ops *ops);
+				  iomap_iter_next_fn next);
 int dax_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 			      struct file *file_out, loff_t pos_out,
 			      loff_t *len, unsigned int remap_flags,
-			      const struct iomap_ops *ops);
+			      iomap_iter_next_fn next);
 static inline bool dax_mapping(struct address_space *mapping)
 {
 	return mapping->host && IS_DAX(mapping->host);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3e240579e2b5..2aa7b4644c73 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -70,7 +70,8 @@ struct fsnotify_mark_connector;
 struct fs_context;
 struct fs_parameter_spec;
 struct file_kattr;
-struct iomap_ops;
+struct iomap_iter;
+struct iomap;
 struct delegated_inode;
 
 extern void __init inode_init(void);
@@ -2081,7 +2082,9 @@ int remap_verify_area(struct file *file, loff_t pos, loff_t len, bool write);
 int __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				    struct file *file_out, loff_t pos_out,
 				    loff_t *len, unsigned int remap_flags,
-				    const struct iomap_ops *dax_read_ops);
+				    int (*dax_read_next)(const struct iomap_iter *iter,
+							 struct iomap *iomap,
+							 struct iomap *srcmap));
 int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
 				  loff_t *count, unsigned int remap_flags);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 95d4995a49ca..1daa4289656f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -239,10 +239,6 @@ typedef int (*iomap_iter_end_fn)(struct inode *inode, loff_t pos, loff_t length,
 typedef int (*iomap_iter_next_fn)(const struct iomap_iter *iter,
 		struct iomap *iomap, struct iomap *srcmap);
 
-struct iomap_ops {
-	iomap_iter_next_fn iomap_next;
-};
-
 /**
  * struct iomap_iter - Iterate through a range of a file
  * @inode: Set at the start of the iteration and should not change.
@@ -254,7 +250,7 @@ struct iomap_ops {
  *	incremental iter advance.
  * @status: Status of the most recent iteration. Zero on success or a negative
  *	errno on error.
- * @flags: Zero or more of the iomap_next flags above.
+ * @flags: Zero or more of the iomap_iter_next flags above.
  * @iomap: Map describing the I/O iteration
  * @srcmap: Source map for COW operations
  */
@@ -271,7 +267,7 @@ struct iomap_iter {
 	void *private;
 };
 
-int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops);
+int iomap_iter(struct iomap_iter *iter, iomap_iter_next_fn next);
 int iomap_iter_advance(struct iomap_iter *iter, u64 count);
 
 /**
@@ -339,7 +335,7 @@ int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
  * @begin: callback that produces a mapping for the current position
  * @end: optional callback that finishes the previous mapping, or NULL
  *
- * Inline helper that implements the common body of an ->iomap_next()
+ * Inline helper that implements the common body of an iomap_iter_next_fn
  * callback: it finishes the previous mapping via @end (if present), decides
  * via iomap_iter_continue() whether to keep going, and obtains the next
  * mapping via @begin.
@@ -393,6 +389,14 @@ int name(const struct iomap_iter *iter, struct iomap *iomap,		\
 #define DEFINE_IOMAP_ITER_NEXT(name, begin_fn)				\
 	DEFINE_IOMAP_ITER_NEXT_END(name, begin_fn, NULL)
 
+/*
+ * Forward-declare an iomap_iter_next_fn callback generated by
+ * DEFINE_IOMAP_ITER_NEXT().
+ */
+#define DECLARE_IOMAP_ITER_NEXT(name)					\
+int name(const struct iomap_iter *iter, struct iomap *iomap,		\
+		struct iomap *srcmap)
+
 /*
  * Return the file offset for the first unchanged block after a short write.
  *
@@ -427,15 +431,15 @@ static inline bool iomap_want_unshare_iter(const struct iomap_iter *iter)
 }
 
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
-		const struct iomap_ops *ops,
+		iomap_iter_next_fn next,
 		const struct iomap_write_ops *write_ops, void *private);
 int iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
-		const void *buf, const struct iomap_ops *ops,
+		const void *buf, iomap_iter_next_fn next,
 		const struct iomap_write_ops *write_ops);
-void iomap_read_folio(const struct iomap_ops *ops,
-		struct iomap_read_folio_ctx *ctx, void *private);
-void iomap_readahead(const struct iomap_ops *ops,
-		struct iomap_read_folio_ctx *ctx, void *private);
+void iomap_read_folio(iomap_iter_next_fn next, struct iomap_read_folio_ctx *ctx,
+		void *private);
+void iomap_readahead(iomap_iter_next_fn next, struct iomap_read_folio_ctx *ctx,
+		void *private);
 bool iomap_is_partially_uptodate(struct folio *, size_t from, size_t count);
 struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len);
 bool iomap_release_folio(struct folio *folio, gfp_t gfp_flags);
@@ -443,17 +447,17 @@ void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
 bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio);
 void iomap_folio_mark_uptodate(struct folio *folio);
 int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
-		const struct iomap_ops *ops,
+		iomap_iter_next_fn next,
 		const struct iomap_write_ops *write_ops);
 unsigned int iomap_fill_dirty_folios(struct iomap_iter *iter, loff_t *start,
 		loff_t end, unsigned int *iomap_flags);
 int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
-		bool *did_zero, const struct iomap_ops *ops,
+		bool *did_zero, iomap_iter_next_fn next,
 		const struct iomap_write_ops *write_ops, void *private);
 int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
-		const struct iomap_ops *ops,
+		iomap_iter_next_fn next,
 		const struct iomap_write_ops *write_ops, void *private);
-vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops,
+vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, iomap_iter_next_fn next,
 		void *private);
 typedef void (*iomap_punch_t)(struct inode *inode, loff_t offset, loff_t length,
 		struct iomap *iomap);
@@ -462,13 +466,13 @@ void iomap_write_delalloc_release(struct inode *inode, loff_t start_byte,
 		iomap_punch_t punch);
 
 int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
-		u64 start, u64 len, const struct iomap_ops *ops);
+		u64 start, u64 len, iomap_iter_next_fn next);
 loff_t iomap_seek_hole(struct inode *inode, loff_t offset,
-		const struct iomap_ops *ops);
+		iomap_iter_next_fn next);
 loff_t iomap_seek_data(struct inode *inode, loff_t offset,
-		const struct iomap_ops *ops);
+		iomap_iter_next_fn next);
 sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
-		const struct iomap_ops *ops);
+		iomap_iter_next_fn next);
 
 /*
  * Flags for iomap_ioend->io_flags.
@@ -708,10 +712,10 @@ struct iomap_dio_ops {
 #define IOMAP_DIO_BOUNCE		(1 << 4)
 
 ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
-		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
+		iomap_iter_next_fn next, const struct iomap_dio_ops *dops,
 		unsigned int dio_flags, void *private, size_t done_before);
 struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
-		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
+		iomap_iter_next_fn next, const struct iomap_dio_ops *dops,
 		unsigned int dio_flags, void *private, size_t done_before);
 ssize_t iomap_dio_complete(struct iomap_dio *dio);
 void iomap_dio_bio_end_io(struct bio *bio);
@@ -787,9 +791,9 @@ struct swap_info_struct;
 
 int iomap_swapfile_activate(struct swap_info_struct *sis,
 		struct file *swap_file, sector_t *pagespan,
-		const struct iomap_ops *ops);
+		iomap_iter_next_fn next);
 #else
-# define iomap_swapfile_activate(sis, swapfile, pagespan, ops)	(-EIO)
+# define iomap_swapfile_activate(sis, swapfile, pagespan, next) (-EIO)
 #endif /* CONFIG_SWAP */
 
 extern struct bio_set iomap_ioend_bioset;
@@ -803,25 +807,25 @@ void iomap_bio_submit_read_endio(const struct iomap_iter *iter,
 extern const struct iomap_read_ops iomap_bio_read_ops;
 
 static inline void iomap_bio_read_folio(struct folio *folio,
-		const struct iomap_ops *ops)
+		iomap_iter_next_fn next)
 {
 	struct iomap_read_folio_ctx ctx = {
 		.ops		= &iomap_bio_read_ops,
 		.cur_folio	= folio,
 	};
 
-	iomap_read_folio(ops, &ctx, NULL);
+	iomap_read_folio(next, &ctx, NULL);
 }
 
 static inline void iomap_bio_readahead(struct readahead_control *rac,
-		const struct iomap_ops *ops)
+		iomap_iter_next_fn next)
 {
 	struct iomap_read_folio_ctx ctx = {
 		.ops		= &iomap_bio_read_ops,
 		.rac		= rac,
 	};
 
-	iomap_readahead(ops, &ctx, NULL);
+	iomap_readahead(next, &ctx, NULL);
 }
 #endif /* CONFIG_BLOCK */
 
-- 
2.52.0


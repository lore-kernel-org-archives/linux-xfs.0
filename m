Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAB83B83F0
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 09:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792142422; cv=none; b=UZ4e9ICAv7uvjBHp86C1FgVCwAWhhR2BFSqvU8oQYBNWHLlQVeTu94F8ey5LVhrjNj123kpLirC2jpVAMrgf+Hou08Nmj8zbEIIpv7CW+UuO3iWsD3c4Ey/vx+Fqd1rsMnCIaZ89hb60bKJhrfWCHiovUNh3RotUD+/b7dBziO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792142422; c=relaxed/simple;
	bh=AVOJ+EQ6bdcOA3N1fq2h7//qSqcQ4PFktSFLO03pbOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiiQdbOPb9fferRKJMX0Ukhk0mBEGA2UJf6jyuRQJCHdJ1g4cuewQ15+O0eGDH9fdJUupxZxzvd+K5cvPBCPdy+DI0p8BlsJisEjbtJ6wG48zdnMvuEbyon2/g17sm67t02hlHPYSB3tdapszerbzSuETzkbEQSUci38sqkpO1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mtD/fxPp; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mtD/fxPp"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso2254498eec.0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 02:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792142420; x=1792747220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WK+I68bJLEgzgn46qvk2Ipo/r437fm1SJGOi6S0H1ew=;
        b=mtD/fxPp7+2Zpkrjh4P9ejoirvbZ5WMO69rA9jpKq+bHJ7qO0nsXV3a989k4QbjLp2
         nu4GwLQyopH12xSgzAkc8icuVenpUSxJpUtpdZItzOpUFZQaedq96cHdzLLWIiYVVNmC
         4MVoBSae31TBHuSus5x2vf+J0QA50PpWKCYizT0Wl4pNqueLmaEmE1DfjhAvVCQhczvq
         QxgpFhzLNuo/eG+3r1w7cKCA+xoxKBCfrZnfwetxqs9n8FYbbHnk3CuKc9AFb6xVR+lR
         XtsBeGLrtMDiS2BjcKIoqX6bm2yPIGN/oqjcd/aZ2cKOk35eb58OpbRAZyblAqJ5sdMt
         Xakg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792142420; x=1792747220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WK+I68bJLEgzgn46qvk2Ipo/r437fm1SJGOi6S0H1ew=;
        b=x+gw0knWrMEczTqPspypchqclXvZMPm+y3AERwGK/aRwmqkIGS3LnW2KcGUIIKSF/i
         zj+1CLELmn6daV/oHkmxiZI/r3CXPWvyiJOvldAr7WCJRTY+41WqNLf90luDR+dVstjL
         CP3p+YhNzh5DFbmXkZ+bpkBmkKIPrELrdHPouzZS1lvIqU8d/YPW3Et84csvbas2/5PI
         1PZ1Jfq6GDORqtVUDDtAMpqjKBS/hmkevEwy73tfcYG3NV39k5S9Bbv0ndY8VAbsZpSp
         onsHwH2b5OPdC6hZzmAqFsgtu9HzKSS/ElEvjz6/wiY/n9tEAV19/JPpCqF27Qphkmqr
         AxsQ==
X-Forwarded-Encrypted: i=1; AKwUvBxs3kb7jyYPJf75/V5qeY77R39PTZxYKuhbU1RkIjoHx8k3Ebh8THGkzJ3nXfKRcLRIVPw9gPHb5+s=@vger.kernel.org
X-Gm-Message-State: AFq9FYLX7UeNO9eXBAsBOoQAhq6pZ8pq2w/8bI10NUTCT7X2JeZckoT+
	wRDQzFOqpqARtSeW8f9S7a3QO6fubsb9GLwApUm7SP3IxaAfZZFsvqE=
X-Gm-Gg: AYBFou2TbTKyJf+78k8MqQGIJ4j4d3LjWPCiDWg/Iaz33+Dou8Jc0DVnS2IFqJ5BOZH
	2UusttsoM3zDwImMVL/Wv36j6BfTarYD/SwAPX2Wj8d1AXqvmtvtYUXCSmtVWWMGKUxhYUFcRFj
	VaVDY8/IItaj6Y3aLS1KTazaPhexZJYTzJASqCxbjxIoKJVsYQcUT5I5Snye4pUUzltdMCIg3xR
	O80+hCK5TY590DTzyrTEzrRuDC7LDWwrARKMO+NsbeWyknZMUclmPjpgCzmku+m4aG5b4YyYKbv
	dmqvdPv3gYUkHI/Leo/8wyl9RNk89JZXTOjorG8ucK9bhKJqPY5kJD2NBbag2GrkxDaoSLJDibf
	4WdLNTvJSkZUdOz4LHgGNJN06RW9B+DJbYEJ3o51KKeiXP1LXQ8SR+4h2HKujkOsjbeCJVB6XQv
	1WBy+drG/EYDDPelhwln41PQ+gHa0TrHw/Z99lriiyVdGEQ03wZOov5TNnleOXWyeabafEkJBrH
	prByS1tmEr/0SVq/2BUqg7KQexhFUA54/vfOD9N8betx/vy504=
X-Received: by 2002:a05:7301:7e17:b0:351:45a4:7dd8 with SMTP id 5a478bee46e88-3537e119234mr26835060eec.34.1792142420192;
        Fri, 16 Oct 2026 02:20:20 -0700 (PDT)
Received: from anuj-MacBookPro.. ([2406:7400:63:e55a:7bfc:fc3a:e718:89f6])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36082a7b33bsm9840943eec.24.2026.10.16.02.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 02:20:19 -0700 (PDT)
From: Anuj Gupta <anuj1072538@gmail.com>
To: asml.silence@gmail.com,
	hch@lst.de,
	djwong@kernel.org,
	cem@kernel.org,
	brauner@kernel.org,
	axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com,
	anuj20.g@samsung.com,
	nj.shetty@samsung.com
Subject: [RFC 2/4] block: refuse a dma-buf bio for a disk the buffer was not registered on
Date: Fri, 16 Oct 2026 14:49:12 +0530
Message-ID: <20261016091919.971295-3-anuj1072538@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016091919.971295-1-anuj1072538@gmail.com>
References: <20261016091919.971295-1-anuj1072538@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nitesh Shetty <nj.shetty@samsung.com>

A registered dma-buf map belongs to the device it was mapped for.
The device backing a file can change after registration. Record
the registered disk's dev_t at init and refuse a bio that targets
a different one.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 block/bio.c                | 15 +++++++++++++++
 block/fops.c               |  7 ++++++-
 include/linux/dma-buf-io.h |  2 ++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 795b88e4a994..b9e5c73cd3d1 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -19,6 +19,7 @@
 #include <linux/blk-crypto.h>
 #include <linux/xarray.h>
 #include <linux/kmemleak.h>
+#include <linux/dma-buf-io.h>
 
 #include <trace/events/block.h>
 #include "blk.h"
@@ -1269,6 +1270,17 @@ static inline bool bio_iov_bvec_aligned(const struct bio *bio,
 }
 #endif
 
+/*
+ * A dma-buf map is only valid for the disk it was registered on, but
+ * the device backing a file can change after the registration.
+ */
+static bool bio_dmabuf_map_valid(const struct bio *bio,
+				 const struct iov_iter *iter)
+{
+	return iter->dmabuf_map->ctx->registered_devt ==
+		disk_devt(bio->bi_bdev->bd_disk);
+}
+
 /**
  * bio_iov_iter_get_pages - add user or kernel pages to a bio
  * @bio: bio to add pages to
@@ -1300,6 +1312,9 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return -EIO;
 
+	if (iov_iter_is_dmabuf_map(iter) && !bio_dmabuf_map_valid(bio, iter))
+		return -EXDEV;
+
 	if (bio_iov_iter_set(bio, iter)) {
 		if (iov_iter_is_bvec(iter) &&
 		    !bio_iov_bvec_aligned(bio, mem_align_mask))
diff --git a/block/fops.c b/block/fops.c
index 18a755f6e0b0..b36dde10a4ac 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -19,6 +19,7 @@
 #include <linux/iomap.h>
 #include <linux/module.h>
 #include <linux/io_uring/cmd.h>
+#include <linux/dma-buf-io.h>
 #include "blk.h"
 
 static inline struct inode *bdev_file_inode(struct file *file)
@@ -938,6 +939,7 @@ int bdev_init_dma_buf_io_ctx(struct file *file, struct block_device *bdev,
 			     struct dma_buf_io_ctx *ctx)
 {
 	struct gendisk *disk = bdev->bd_disk;
+	int ret;
 
 	if (!(file->f_flags & O_DIRECT))
 		return -EINVAL;
@@ -945,7 +947,10 @@ int bdev_init_dma_buf_io_ctx(struct file *file, struct block_device *bdev,
 		return -EOPNOTSUPP;
 	if (bdev_has_integrity_csum(bdev))
 		return -EOPNOTSUPP;
-	return disk->fops->init_dma_buf_io_ctx(bdev, ctx);
+	ret = disk->fops->init_dma_buf_io_ctx(bdev, ctx);
+	if (!ret)
+		ctx->registered_devt = disk_devt(disk);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(bdev_init_dma_buf_io_ctx);
 
diff --git a/include/linux/dma-buf-io.h b/include/linux/dma-buf-io.h
index b9bbeca1744f..d42a79f2ac9b 100644
--- a/include/linux/dma-buf-io.h
+++ b/include/linux/dma-buf-io.h
@@ -50,6 +50,8 @@ struct dma_buf_io_ctx {
 
 	void					*dev_priv;
 	const struct dma_buf_io_ops		*dev_ops;
+
+	dev_t					registered_devt;
 };
 
 int dma_buf_io_ctx_create(struct file *file,
-- 
2.43.0


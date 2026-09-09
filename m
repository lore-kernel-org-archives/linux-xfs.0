Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD19637C903;
	Wed,  9 Sep 2026 06:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934219; cv=none; b=XaXlZ6aMD82bEwUqiZtsTRTrdWKei+fj3vWpklYr6LG12nBwB8znQhClZpyiIsTYBFiz6YVLWZDXekFSwatwhX/xsmDSabj3RyApKCjee2YaMTEGAY4vOSxzYSjAMGqNFm8CKjWcpmr45AU1lnFmdTE6sxoqdeBhurSy3lNTWbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934219; c=relaxed/simple;
	bh=1o1TwDI9SkCSIaeq4q4HTtpsGD7UQjFOF6I2O9eh2h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udQkJdMENXwZ7aMw6yu1xuYTgVuFJN2RjM3m0v9689xSTUOTBO+wn6sh37RSFgnGoSxhXqk35C+czZmwO8UxVLH4Wk9GepXbnU8u3o2/9UbGb+vyEIaXq8w2fxFZaI1utUakUGCVOt7TSVppnvtPc46Y+60325lA0PqTSmDx8k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=12BJgT9i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="12BJgT9i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QcWmC9DPeMj9s1rRCA1ffrVodvZMWO9qMRcMAEIw+f4=; b=12BJgT9ideo+Doq/fAdEKbVHbk
	3v14dXOgFhbNo7zG0zmUyD7l2hNDFEHHxwR/vRgzdqP3tcGUDIqatDfFnI67FziC5TwwAdfRsgtpj
	6KcJLdjc6cVioJmltH2NOz8d1oxw/NdmX61yuQg8EkpVo7snSpGwQK3UzdeHjr39LR569Rz4OeMNg
	/AS3fP01/AXOUoiEkVMVjccl9TxQ0AWZxGY7EfZ/4H58mWDPX8CtBmZ5KYrtF4hmhzmcBFJRWasYT
	xJ4KaNtEQDM3mb4izwbTAyS+sGGouQmSV95/IqYC1yzKsg5Hdvyd0YNjhmv1J7Pwt7IMK4HVaQxXS
	b1ebzKKQ==;
Received: from [62.74.3.53] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4BVe-0000000AqiM-3svH;
	Wed, 09 Sep 2026 06:10:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 07/16] iomap,xfs: move T10 PI handling for direct I/O into ->submit_io
Date: Wed,  9 Sep 2026 09:08:56 +0300
Message-ID: <20260909060924.1102037-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909060924.1102037-1-hch@lst.de>
References: <20260909060924.1102037-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the buffered I/O code defers PI handling into the submit
handlers, while direct I/O does it in common code.  Move the direct I/O
side into the file system callbacks or their generic implementations to
be consistent, and to allow file systems to shared helpers for submission
of buffered and direct bios.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/direct-io.c | 22 ++++++++++++----------
 fs/xfs/xfs_file.c    | 13 ++++++++++---
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 91f5b67718a5..4154717a09de 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -76,10 +76,19 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
 
 	if (dio->dops && dio->dops->submit_io) {
 		dio->dops->submit_io(iter, bio, pos);
-	} else {
-		WARN_ON_ONCE(iter->iomap.flags & IOMAP_F_ANON_WRITE);
-		blk_crypto_submit_bio(bio);
+		return;
+	}
+
+	WARN_ON_ONCE(iter->iomap.flags & IOMAP_F_ANON_WRITE);
+
+	if (iter->iomap.flags & IOMAP_F_INTEGRITY) {
+		if (dio->flags & IOMAP_DIO_WRITE)
+			fs_bio_integrity_generate(bio);
+		else
+			fs_bio_integrity_alloc(bio);
 	}
+
+	blk_crypto_submit_bio(bio);
 }
 
 static inline enum fserror_type iomap_dio_err_type(const struct iomap_dio *dio)
@@ -373,13 +382,6 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 		goto out_bio_release_pages;
 	}
 
-	if (iter->iomap.flags & IOMAP_F_INTEGRITY) {
-		if (dio->flags & IOMAP_DIO_WRITE)
-			fs_bio_integrity_generate(bio);
-		else
-			fs_bio_integrity_alloc(bio);
-	}
-
 	if (dio->flags & IOMAP_DIO_WRITE)
 		task_io_account_write(ret);
 	else if ((dio->flags & IOMAP_DIO_USER_BACKED) &&
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4d7a284fcff9..acbfd55f56a3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -37,6 +37,7 @@
 #include <linux/fadvise.h>
 #include <linux/mount.h>
 #include <linux/filelock.h>
+#include <linux/bio-integrity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -241,8 +242,12 @@ xfs_dio_read_bounce_submit_io(
 	struct bio		*bio,
 	loff_t			file_offset)
 {
-	iomap_init_ioend(iter->inode, bio, file_offset,
-		iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
+	struct iomap_ioend	*ioend;
+
+	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
+			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
+	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
+		fs_bio_integrity_alloc(bio);
 	bio->bi_end_io = xfs_end_bio;
 	submit_bio(bio);
 }
@@ -733,7 +738,9 @@ xfs_dio_zoned_submit_io(
 
 	bio->bi_end_io = xfs_end_bio;
 	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
-		iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
+			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
+	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
+		fs_bio_integrity_generate(bio);
 	xfs_zone_alloc_and_submit(ioend, &ac->open_zone);
 }
 
-- 
2.53.0


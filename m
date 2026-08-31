Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215323ADBA2;
	Mon, 31 Aug 2026 06:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158472; cv=none; b=baO4ID3ds+bcBsDXp9wWFNZHfMneciklJ5f5kacWLVk5KZzrOW7ICaGia+U6p4lp0K55mLW9JW/51aiJCHqTRv81kixbhsSKA9FGGZH4iocyxuVV1XOlwWOFq2o7hD0oO3T0i8q+hGxZTGdZYL9WDaC8H5S1ueusoS5WBGkRIfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158472; c=relaxed/simple;
	bh=1o1TwDI9SkCSIaeq4q4HTtpsGD7UQjFOF6I2O9eh2h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zl21QIXbgkMG9N+phal8TwOtDjQ1ksftskmeIelsHHSCjaYaP8LOwKlcEyWrOivov5HgUny6gfO6uabvdeu2+OU7T34dpyXPlCSkm9sVPbPAKU/QRHj1qzKKc5UTfEVyNw/e+tL9WsF+/mi7m2ONhzU/U+uqkO+qSjCIcF0xyds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m4lHTBLM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m4lHTBLM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QcWmC9DPeMj9s1rRCA1ffrVodvZMWO9qMRcMAEIw+f4=; b=m4lHTBLMVFgI2+ztxjw610pAIU
	ZEUqe3NaT9KIQxK/Xlr3Le/yzPh1S1jjKRo7mh31dM0WQuQDlvMa9AoR3QhBuGNQmedFcgpoJ9W47
	y28wD9nZySwNhD3zHLV8AR2wo4037E4XbTpV3rEb47WKVZO4SCzrO+x4bQ2gbueyp2DVmWvW9HqFH
	2jTDFIC+xjJmNerJXqT77XWiaP/dSOavTxy9uUeGQpQxH+JKoY6YWfsfZmlPmXa4Bm5LQiswdTuXP
	31EZFWby4urvEi1ELNXYNf9ZLt9vbnLWu9xPosgJnIQevdDw/LDOdhdKbA1EXnoI8Wg1EjbpzG9Mj
	SYumLU1A==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vhd-00000008cwt-3tpL;
	Mon, 31 Aug 2026 06:41:10 +0000
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
Subject: [PATCH 08/17] iomap,xfs: move T10 PI handling for direct I/O into ->submit_io
Date: Mon, 31 Aug 2026 09:39:56 +0300
Message-ID: <20260831064010.2574896-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831064010.2574896-1-hch@lst.de>
References: <20260831064010.2574896-1-hch@lst.de>
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


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F145545DF60;
	Thu, 23 Jul 2026 14:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818275; cv=none; b=RQSPvT1rR3/tl86G3unCqG8oWXVOfFKfgSUEzDg/QncWIyjIJX0+F/XidKk1AvR4bsPO4GXH4SX6ISnvuAEwqhz4fBceLZlWjU58Kf1EBMYERpIaZBsitJoK5rWKcEtJBP2I//soXH4ewFo8CfKgGju9iaTkEq59gqRxOdoY3GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818275; c=relaxed/simple;
	bh=eKQVVfsJwOZzF0fJSxINZZrlVJK6D+XSZawYZ18Jnj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMXsf8zSeqwDBFW3A5CXbqMfG3BVWJblYiUZR9hKMtl4ZBXj7Q+bnYBO/F/q+Tq3Oo27edNOB5VaSRhkJ1qZVD2m5gQITqylitXOHrHf/N6uFxOghz9Hrr3DKb+dzLmNj3/XZnocrrlk1E5JUrXpwPZQFGe0VqC78pjJPmaZaF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p5uNFtHO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p5uNFtHO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jJgnD0MjZMJbua1H/7Kf2te3u+hWM8uxZlnK1OWh/MA=; b=p5uNFtHOE33/yY7biORxnx47ru
	sFT4tLHB6nIQihG+C18Yg+uGL2A8o7HSZS+JuXXek7Ar80ek44TwP18wWD8Ly5LkuI0vwz17oxK6c
	Mgy1MCHx+VWcKQsJQuOhaNv52MfVcxYi/gTOH9nL1oq5hLlSd4yKbkaGPoY+uacRLeBxfSjxVNghT
	BbkMfBcLCFv8xEeIB48tScODKxThVvHTYp/Zxann0LVSaDdoPhLoBleT2YItJTQTjN43IS/OuvL5D
	qp30x+s+ncZs2RNpEd5GQjnree94CTjiSsx18byXWpDHO+/r0MuKp4Vecna9m5xq3aP70p3lkXEMA
	XHdZHo6Q==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmulT-0000000EXMH-2t4c;
	Thu, 23 Jul 2026 14:51:12 +0000
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
Subject: [PATCH 15/22] iomap,xfs: move T10 PI handling for direct I/O into ->submit_io
Date: Thu, 23 Jul 2026 16:49:40 +0200
Message-ID: <20260723145000.116419-16-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723145000.116419-1-hch@lst.de>
References: <20260723145000.116419-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the buffered I/O code defers PI handling into the submit
handlers, while direct I/O does it in common code.  Move it all
into the file system callbacks or their generic implementations
to be consistent, and to allow file systems to shared helpers
for submission of buffered and direct bios.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c | 22 ++++++++++++----------
 fs/xfs/xfs_file.c    | 13 ++++++++++---
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index e2cd5f92babe..8d476f40a3bb 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -75,10 +75,19 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
 
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
@@ -372,13 +381,6 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
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
index e94a26f32e65..80dd278e023f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -37,6 +37,7 @@
 #include <linux/fadvise.h>
 #include <linux/mount.h>
 #include <linux/filelock.h>
+#include <linux/bio-integrity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -235,8 +236,12 @@ xfs_dio_read_bounce_submit_io(
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
@@ -725,7 +730,9 @@ xfs_dio_zoned_submit_io(
 
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


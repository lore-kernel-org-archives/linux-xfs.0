Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21D14DBD8E;
	Thu, 23 Jul 2026 14:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818298; cv=none; b=ZlNR7TdEjcZ+zajL3HEj6fpCXOJhTie9JwfNIj750B7UfZ84QMySCGoPRz5plg8LTpmX+NV6PEDROQbEqnnrVOKMENjnuuRc4/JIon2qa8XVoO691ibrKi1dcXhjp9d7DD50BA/0i9U3LtLLmwm5eeBRL8nTiR0wXdArnE/sK+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818298; c=relaxed/simple;
	bh=c1ibVOS1DsYUB6MqDKzwSkOl+jg5N6SHLHK7oj69kA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebzKKVWBkVZDkdrtaHsJ4IqHoHSsQR+DQXKC/Qv5zFubSomONImdnZ/DVg3AJG7YdJDU2XVzoO85vaYuRzkwzc4HcIv8NmZTXS2dppLZy96FcfCCpCvQKDBdb5MFOMJDncHnFJ0Ow1/6tr2/H7L9fUtlO+Qfj9g6R1OG0ceAvQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jhXlJFTA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jhXlJFTA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8UKASy+4BrpoqMxvpTTznTomEoSsKzpnRjx+igUDQXI=; b=jhXlJFTA87F3sdc/H569lrWIHT
	5auiMyI23YA2MjNIpr4V8+y6wbCn5YeHclm/wG0WN3puSXeNz3xzk/v4huRwltvHM0mhpSEMlhFg5
	2Fd58JrlqK0Baa5XoGNtbUB6dZsmbtPrCPCSl/SBAWXUF2wy6shubK94EsYn6Zkpm1ZHZfhUUEAOi
	XsYiMJROwPoHRiQ8O6mkx++Fp08LjTVvIuDRezqFdRnoNe1F8ybec/j1xnvKBcSTMYqBr+dcW0EC2
	sSMUu3mJYOvjxMNqVUY7dqLkhWWZASEkCynhTNzyzjLZu4axFediBlpiQwbs9NVHAyY0C3HfIoqjG
	T6XUZ2oQ==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmulp-0000000EXO0-2Oce;
	Thu, 23 Jul 2026 14:51:33 +0000
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
Subject: [PATCH 19/22] iomap,xfs: move integrity verification to the file system
Date: Thu, 23 Jul 2026 16:49:44 +0200
Message-ID: <20260723145000.116419-20-hch@lst.de>
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

Integrity support in file systems already requires file system-specific
completion handling because it must be run in process context.

Move the actual verification to the file system so that it can better
handle errors in file system specific ways, and to support lazy bounce
buffering.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/ioend.c      | 8 ++------
 fs/xfs/xfs_ioend.c    | 3 +++
 include/linux/iomap.h | 1 +
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 438be92e131b..b1078f7c08c6 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -308,12 +308,13 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 }
 EXPORT_SYMBOL_GPL(iomap_add_to_ioend);
 
-static int iomap_ioend_integrity_verify(struct iomap_ioend *ioend)
+int iomap_ioend_integrity_verify(struct iomap_ioend *ioend)
 {
 	struct bvec_iter data_iter = BVEC_ITER_IOEND(ioend);
 
 	return fs_bio_integrity_verify(&ioend->io_bio, &data_iter);
 }
+EXPORT_SYMBOL_GPL(iomap_ioend_integrity_verify);
 
 static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
 {
@@ -330,11 +331,6 @@ static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
 	if (!atomic_dec_and_test(&ioend->io_remaining))
 		return 0;
 
-	if (!ioend->io_error &&
-	    bio_integrity(&ioend->io_bio) &&
-	    bio_op(&ioend->io_bio) == REQ_OP_READ)
-		ioend->io_error = iomap_ioend_integrity_verify(ioend);
-
 	if (ioend->io_flags & IOMAP_IOEND_DIRECT)
 		return iomap_finish_ioend_direct(ioend);
 	if (bio_op(&ioend->io_bio) == REQ_OP_READ)
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index 37a3ae8066e9..a095cf217863 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -25,6 +25,9 @@ xfs_end_io_read(
 	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
 	int			error = blk_status_to_errno(bio->bi_status);
 
+	if (!error && (ioend->io_flags & IOMAP_IOEND_INTEGRITY))
+		error = iomap_ioend_integrity_verify(ioend);
+
 	iomap_finish_ioends(ioend, error);
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 1916a4f28002..f9e2fce21be0 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -518,6 +518,7 @@ void iomap_finish_ioends(struct iomap_ioend *ioend, int error);
 void iomap_ioend_try_merge(struct iomap_ioend *ioend,
 		struct list_head *more_ioends);
 void iomap_sort_ioends(struct list_head *ioend_list);
+int iomap_ioend_integrity_verify(struct iomap_ioend *ioend);
 ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 		loff_t pos, loff_t end_pos, unsigned int dirty_len);
 int iomap_ioend_writeback_submit(struct iomap_writepage_ctx *wpc, int error);
-- 
2.53.0


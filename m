Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2DF34DCE3;
	Mon, 31 Aug 2026 06:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158500; cv=none; b=Cjs7JwZAmcYflmUK86UK5jhsMI/ncvTIm6OKde15ImGDWEyM1Y2GOnnHcJw01g8H0r94176EQhRsI8VeEEI9svuitkYf6Tlh2lfzvHpRxR+QXd+QyTyX0HKrGqd1yp8AVgiN7RfdV6GeUe/+g118oD9tip0PhWhnZUr4mLwUDvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158500; c=relaxed/simple;
	bh=MomcsIo7b57U3EjfiNSxocWsbt6AuqzdbsUbSOhaWWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtXBTfhMPxEKJjSRNGHeFvhpL3Pw9xeoySkP2WGMJSZG+UBiFabcNfjAyWzLICMB4iTsic7QQo4ianfTLUBWMnVfdNHlovkWwkMrjBpdt7ckTdTznekzZgAwlGvCjkyMSMacHrYWlaR+ri3WgVYMo+uS7GV6ocrhFb9AEpEwIgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x/Xpp+pu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x/Xpp+pu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6+a2GJ+VfCpfI2yFJUXZPKc3l/4RCImmipvddDt1fkw=; b=x/Xpp+puQnP2R8hBWFn0REx1dD
	nN9VMXknp+3/0CxC4+KUFCZxW9wvkwBblbb3mpxTG/6+R1Q184gd7Q1N57ddJ4+ix46G3O2LCDzkw
	Af9q1ErELDihEElPWkvD3tuuMyE2GPmJpYZA+uC3gQnTaSvEwkJQQatxmIsEp5ct3pYoEkEXt8+5n
	6JsFnBRGEOKm/VzHWNBrlNc+Ghf4DzScDeTzgsGuRkRq7vmCECI6lOTcq6NQZtFO/RtveQkPdXgmd
	JgHwZ08xsphAA7PNX9q4uNT/xQP0F/Jsxj/HC9KI5kNNAVhFBop+HwEEtz+lPneONfsHkIx1ccUgS
	gXVZHcgw==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vi5-00000008czA-3OtJ;
	Mon, 31 Aug 2026 06:41:38 +0000
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
Subject: [PATCH 13/17] iomap,xfs: move integrity verification to the file system
Date: Mon, 31 Aug 2026 09:40:01 +0300
Message-ID: <20260831064010.2574896-14-hch@lst.de>
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

Integrity support in file systems already requires file system-specific
completion handling because it must be run in process context.

Move the actual verification to the file system so that it can better
handle errors in file system specific ways, and to support lazy bounce
buffering.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/ioend.c      | 10 ++++------
 fs/xfs/xfs_ioend.c    |  3 +++
 include/linux/iomap.h |  1 +
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index ba97eec4ee2c..bbebecc31670 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -309,12 +309,15 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 }
 EXPORT_SYMBOL_GPL(iomap_add_to_ioend);
 
-static int iomap_ioend_integrity_verify(struct iomap_ioend *ioend)
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+int iomap_ioend_integrity_verify(struct iomap_ioend *ioend)
 {
 	struct bvec_iter data_iter = BVEC_ITER_IOEND(ioend);
 
 	return fs_bio_integrity_verify(&ioend->io_bio, &data_iter);
 }
+EXPORT_SYMBOL_GPL(iomap_ioend_integrity_verify);
+#endif /* CONFIG_BLK_DEV_INTEGRITY */
 
 static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
 {
@@ -331,11 +334,6 @@ static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
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
index fbe051f0b032..59718f73c15a 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -595,6 +595,7 @@ void iomap_finish_ioends(struct iomap_ioend *ioend, int error);
 void iomap_ioend_try_merge(struct iomap_ioend *ioend,
 		struct list_head *more_ioends);
 void iomap_sort_ioends(struct list_head *ioend_list);
+int iomap_ioend_integrity_verify(struct iomap_ioend *ioend);
 ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 		loff_t pos, loff_t end_pos, unsigned int dirty_len);
 int iomap_ioend_writeback_submit(struct iomap_writepage_ctx *wpc, int error);
-- 
2.53.0


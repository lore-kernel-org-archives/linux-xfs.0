Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499A24848A6;
	Mon, 28 Sep 2026 09:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790586681; cv=none; b=YumyyhYw6f+V3usdkY3UCdtreGqJBMoBw5RQRym0Pof6rcyrk3wD/1UMqD7XFQgpI+4HAR5cOQD3g/eM+6kLiNkAh2rXuA4mUxoPBwr+cMNQCItIvdf0WcQuLxLGzPeYRWlc53MvxnWziqI/umUBkfp7AroI91+UtS3Pf+YqVxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790586681; c=relaxed/simple;
	bh=A77R70aeUctyyKgpWU11MhSF5EHJNy4qr/ZzriFy1JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+wdfL3NhKjLQfHF//ikgjj/xPVtxHX0Llro87vaAENgmiMI5bTQTWoFTpkwoXYtMX+RTozo+gHXpOHzscDpxQVYEuHr9LEFZNFtRP0KbE9AfBGl78FMWcoxERuOBoVn/jjP8wNEg4PZ6LOuKPgPxzEEZBAK9X56CtpeWuqLPhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4JB+7lpT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4JB+7lpT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yNmieU9zGEZoFUI8fngW5CZUTmIa8fBhU0mtYBX3hIQ=; b=4JB+7lpTYoj5i2SIwMVvMVr8Ua
	/uz/O3nciLb7r+h0tksO+fPH/tQfRnQd9tAjBzmxfnANl106YoxCczZqgOoZgr6K2fpT4XAecq3nn
	TyAoydtrm8PGmA7b8tAvazmssSnUmXH7W7Nn6JcCL3nkTlw9dLP0Nb/04Gah1h0x/q4tQTVQH93aI
	/HC+Ll0/mzz+nTb3tEdcmsm7E91W6Pa7adm1V8R7oDYKGEEqlI5RV5AitlZ2UxVd/6UfeSW3GdtYW
	PtGfmYgsrTApzwypByt/pwcAzJD6TWWpUGS0pFEZgcYab053z5tEEAgpFyX1dQdGDbNQTdkdAEkqf
	XrfAzYBw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB7OH-00000000Bmo-3qxw;
	Mon, 28 Sep 2026 09:11:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/3] iomap: use bio_complete_in_task for buffered read failures
Date: Mon, 28 Sep 2026 11:11:07 +0200
Message-ID: <20260928091111.3986811-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928091111.3986811-1-hch@lst.de>
References: <20260928091111.3986811-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use bio_complete_in_task to defer the bio completion handler to task
context instead of the homegrown deferral.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/bio.c | 46 ++--------------------------------------------
 1 file changed, 2 insertions(+), 44 deletions(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 48100c614431..e83524c46838 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -9,9 +9,6 @@
 #include "internal.h"
 #include "trace.h"
 
-static DEFINE_SPINLOCK(failed_read_lock);
-static struct bio_list failed_read_list = BIO_EMPTY_LIST;
-
 static u32 __iomap_read_end_io(struct bio *bio, int error)
 {
 	struct folio_iter fi;
@@ -27,50 +24,11 @@ static u32 __iomap_read_end_io(struct bio *bio, int error)
 	return folio_count;
 }
 
-static void
-iomap_fail_reads(
-	struct work_struct	*work)
-{
-	struct bio		*bio;
-	struct bio_list		tmp = BIO_EMPTY_LIST;
-	unsigned long		flags;
-
-	spin_lock_irqsave(&failed_read_lock, flags);
-	bio_list_merge_init(&tmp, &failed_read_list);
-	spin_unlock_irqrestore(&failed_read_lock, flags);
-
-	while ((bio = bio_list_pop(&tmp)) != NULL) {
-		__iomap_read_end_io(bio, blk_status_to_errno(bio->bi_status));
-		cond_resched();
-	}
-}
-
-static DECLARE_WORK(failed_read_work, iomap_fail_reads);
-
-static void iomap_fail_buffered_read(struct bio *bio)
-{
-	unsigned long flags;
-
-	/*
-	 * Bounce I/O errors to a workqueue to avoid nested i_lock acquisitions
-	 * in the fserror code.  The caller no longer owns the bio reference
-	 * after the spinlock drops.
-	 */
-	spin_lock_irqsave(&failed_read_lock, flags);
-	if (bio_list_empty(&failed_read_list))
-		WARN_ON_ONCE(!schedule_work(&failed_read_work));
-	bio_list_add(&failed_read_list, bio);
-	spin_unlock_irqrestore(&failed_read_lock, flags);
-}
-
 static void iomap_read_end_io(struct bio *bio)
 {
-	if (bio->bi_status) {
-		iomap_fail_buffered_read(bio);
+	if (bio->bi_status && bio_complete_in_task(bio))
 		return;
-	}
-
-	__iomap_read_end_io(bio, 0);
+	__iomap_read_end_io(bio, blk_status_to_errno(bio->bi_status));
 }
 
 u32 iomap_finish_ioend_buffered_read(struct iomap_ioend *ioend)
-- 
2.53.0


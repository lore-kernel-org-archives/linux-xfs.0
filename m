Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47773DE455;
	Thu,  9 Apr 2026 16:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775750632; cv=none; b=Npd70jufROo+8nf3msvn2yp8udghvgCzKO97rdAUk2Sg7mxlSL2Ixoay76MZfvpHoxx81qf7w/OtmQ5v85VNslJlP7Y74iV8fIyAf2t0UN7HI8xJE+F25r+WePqabI/4rV2338jN95dM+v8cEsYbaSAaeo/6MVBXiVofiW6GsKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775750632; c=relaxed/simple;
	bh=CogHmbOJPiWFdE6zFaP+dJe3/mRuRv/plEySsPqWkpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0sf1iZspmuEUmafR6bOW2BqCgWsKgKeOkXtAQmKv4KppyRFSggJ77bliWjWWBA4wBNaXEWZAONGEgMmBCpxDMnSnqkZc8vWbbJBZLWeHt86qRDno74c6dvCf8cetAj4tasfQisj8imKR9AIHNxRHcdcUGjq94GfC729ibLyEaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kQoYS4HS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kQoYS4HS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eEKUbIuo9fZAdJk1FYFd6tgmjZsDZNLvgGz2ue3oLuo=; b=kQoYS4HSsLVIn50YskCEgjJ6Fq
	UptT2cEv16lB+JK6GOZtYAj5Ufg3eahSl0DZxC7yT1ImyJFBkgv9elt253UOegNBFx53xCBY2voCi
	HpGnEi5gn1QH/nOrPNt+4IzZzm4cYoUiCYhii8DsMGhSUt1mPxtBgUFmPSA2tsHaW6EtCNlFVndHO
	f6/mVlSPj7ztFSix2X/R/tNZbk786xJ6p1uztsQan47GDdqHouhWQ3JzSUWnvjRxSReax/sTl7mHn
	/kbfQ96fS+IeT6SL9cdrcbVEbwg89Jm/DmxSkqj1MhTB/XNCskKz6J+1VmGql6bth3QTiMgt+Hix3
	EXwSiS7Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArr9-0000000At7E-4A3r;
	Thu, 09 Apr 2026 16:03:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/8] iomap: use bio_complete_in_task for buffered read errors
Date: Thu,  9 Apr 2026 18:02:19 +0200
Message-ID: <20260409160243.1008358-7-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409160243.1008358-1-hch@lst.de>
References: <20260409160243.1008358-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Replace out own hand-crafted complete in task context scheme with the
generic block code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/bio.c | 44 +-------------------------------------------
 1 file changed, 1 insertion(+), 43 deletions(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 4504f4633f17..5b9b91198ec8 100644
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
@@ -27,49 +24,10 @@ static u32 __iomap_read_end_io(struct bio *bio, int error)
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
 	__iomap_read_end_io(bio, 0);
 }
 
-- 
2.47.3


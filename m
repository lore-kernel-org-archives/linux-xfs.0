Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17ED7367F58;
	Thu,  9 Apr 2026 16:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775750641; cv=none; b=p0Lt4DfYmCnQkyFzYV6xloQhqLFbjLM5DTnTRUnfvWibqqoeHwQVT9APCp31I3siUoMltyfVHtI+y+H47id/xgVXmHMnxREIDOf6AIWEZzjta17b2YQHmJb6MyP45PJ820ZS+aFOvvcTDY9UM4QFbt37kZupAiGLKBt1uI6MJkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775750641; c=relaxed/simple;
	bh=kR6O3GjIrOSqeQIMXQvVpVAlqfW4GnZjAJUO0OQboRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tq5e1wH4RmFZ6ej7+4F34vfJvkMpalipsc210cG5OLwrIwmR2Xfb/TUwxKBBy73lr+RS8dKwYJypiyJ8PVhkiukhQ2MFEXoVSIRdTdYWO3J4jzzY8CSejKSxN3xqZ5G4nZVJGJbf62Jdmm6kO+9lnLdfgaGS0bct/Knc77Zz3aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X1ZE0ZDD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X1ZE0ZDD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=t91yQKljfNS63wofUJw8789t2weIp40I1JaX9qzqq/I=; b=X1ZE0ZDD0CNHcWIVi7HvmYlnnl
	ql47n/PEo3jTxAimPcUqUooqEeMGZQ+kLPZnSxv0okP10ALtx3AS8kd4H7sMvE7aoJ9br8aCC6IlR
	7gLmL/RBYLKxVHGbZRA6DMgeCKEKSr0BeeaKYaNUN1zp4JYZjr+wyRTF3inwNkTIzP6mu9dwRON2/
	xY/9H6T/ITGNQ+KWlXCD/u995zv5eIfrqhE8y8PFBFrzraYbRZvEDYnRVJSGhVY731XojBzPWiA81
	WjOJeJQY+MoI1gSMmBlgbZB9GScIr68ONzwmI4rJxFiT1IQhEfyPoTS7kdoPyeGEw+aGEmV3wrx9m
	fCM17YVg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArrJ-0000000At8B-1JIj;
	Thu, 09 Apr 2026 16:03:57 +0000
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
Subject: [PATCH 7/8] iomap: use bio_complete_in_task for buffered write completions
Date: Thu,  9 Apr 2026 18:02:20 +0200
Message-ID: <20260409160243.1008358-8-hch@lst.de>
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
 fs/iomap/ioend.c | 53 +++++-------------------------------------------
 1 file changed, 5 insertions(+), 48 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index a32ece8a3ee3..160224007486 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -72,63 +72,20 @@ static u32 iomap_finish_ioend_buffered_write(struct iomap_ioend *ioend)
 	return folio_count;
 }
 
-static DEFINE_SPINLOCK(failed_ioend_lock);
-static LIST_HEAD(failed_ioend_list);
-
-static void
-iomap_fail_ioends(
-	struct work_struct	*work)
-{
-	struct iomap_ioend	*ioend;
-	struct list_head	tmp;
-	unsigned long		flags;
-
-	spin_lock_irqsave(&failed_ioend_lock, flags);
-	list_replace_init(&failed_ioend_list, &tmp);
-	spin_unlock_irqrestore(&failed_ioend_lock, flags);
-
-	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
-			io_list))) {
-		list_del_init(&ioend->io_list);
-		iomap_finish_ioend_buffered_write(ioend);
-		cond_resched();
-	}
-}
-
-static DECLARE_WORK(failed_ioend_work, iomap_fail_ioends);
-
-static void iomap_fail_ioend_buffered(struct iomap_ioend *ioend)
-{
-	unsigned long flags;
-
-	/*
-	 * Bounce I/O errors to a workqueue to avoid nested i_lock acquisitions
-	 * in the fserror code.  The caller no longer owns the ioend reference
-	 * after the spinlock drops.
-	 */
-	spin_lock_irqsave(&failed_ioend_lock, flags);
-	if (list_empty(&failed_ioend_list))
-		WARN_ON_ONCE(!schedule_work(&failed_ioend_work));
-	list_add_tail(&ioend->io_list, &failed_ioend_list);
-	spin_unlock_irqrestore(&failed_ioend_lock, flags);
-}
-
 static void ioend_writeback_end_bio(struct bio *bio)
 {
 	struct iomap_ioend *ioend = iomap_ioend_from_bio(bio);
 
-	/* Page cache invalidation cannot be done in irq context. */
-	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE) {
+	/*
+	 * Page cache invalidation and error reporting cannot be done in irq
+	 * context.
+	 */
+	if ((ioend->io_flags & IOMAP_IOEND_DONTCACHE) || bio->bi_status) {
 		if (bio_complete_in_task(bio))
 			return;
 	}
 
 	ioend->io_error = blk_status_to_errno(bio->bi_status);
-	if (ioend->io_error) {
-		iomap_fail_ioend_buffered(ioend);
-		return;
-	}
-
 	iomap_finish_ioend_buffered_write(ioend);
 }
 
-- 
2.47.3


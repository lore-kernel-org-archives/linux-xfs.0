Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C81A488757;
	Mon, 28 Sep 2026 09:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790586684; cv=none; b=BSeT/nite6mf0bVZobFRVLxSvnbL2ZoKyLowwpW2BLTza3PSr/6U9GWZ3sft5Vzocpl/9ilPgKS1dHAmzTQ8jM1QCY/NT8jBdEGkIIRVePVHHNVtM76k0YkfOo7HDc8+FG8mvFTvscdOZB/u6pP6UNBEO5BhtaqV9XF3+to4X8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790586684; c=relaxed/simple;
	bh=s+wOdn6GSfmraHu5DIUq25kzrjTR433UFbl4ltv5VjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0rdfvrsmfDhDi/SioRbepRVfJ+zQVCYD61+m9PG9XJoB9O0igf3H0IHSa72lmb4FPuh+xyV6sDYqlUozo05YswaBHubRKgNP24S+z9ckRwuqVsQLG/PFmCZ3qU5UeqG8jBoPdMByW9K7FNVz+b97E8G56mnTHcfhMbama/qvGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rgPyzZJm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rgPyzZJm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=k3l8jv+AlnX6fkju4yJTaUp6pd6MSIoKtD5BhnFuEMA=; b=rgPyzZJmnreRj9CRzvmaYl3YXc
	CmO/w7ztClvJRBD2iaHTgOOA+a4D3gXVR7btR3V7P4g4R82j1sVR4w6RdxnmsGI/yjjf2302w+EaH
	96t9Kk2vzdobmV3dnVeXSKrQX6Svl5ZthGgdZFvyt1SyZ/BYqYeJIyGhFrLsm3sQEZ3nFDywTPEmW
	xrT7tyCY9s2nMb42dbp/EQ/Gc9iVgM+ur0IYov4FDqZ0w/9trbtLfg+9wnGztnpFn24v2qC93+DOZ
	0J4Y+9fRS9gkFDO7cerD6qvvVs1XDsODW2WRkBEyScAny2o3Fe5PB/m9UKTXMS4+rIrN2Vw7CwFQg
	Ie+m8Fcg==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB7OL-00000000BnH-0qtR;
	Mon, 28 Sep 2026 09:11:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/3] iomap: use bio_complete_in_task for buffered write failures
Date: Mon, 28 Sep 2026 11:11:08 +0200
Message-ID: <20260928091111.3986811-3-hch@lst.de>
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
 fs/iomap/ioend.c | 48 ++----------------------------------------------
 1 file changed, 2 insertions(+), 46 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 7bbbb417f915..1c8840bde1ff 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -74,57 +74,13 @@ static u32 iomap_finish_ioend_buffered_write(struct iomap_ioend *ioend)
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
 
-	ioend->io_error = blk_status_to_errno(bio->bi_status);
-	if (ioend->io_error) {
-		iomap_fail_ioend_buffered(ioend);
+	if (bio->bi_status && bio_complete_in_task(bio))
 		return;
-	}
-
+	ioend->io_error = blk_status_to_errno(bio->bi_status);
 	iomap_finish_ioend_buffered_write(ioend);
 }
 
-- 
2.53.0


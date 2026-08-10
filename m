Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4023F39CB;
	Mon, 10 Aug 2026 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786373164; cv=none; b=BXWWdEps3bTd+v728REG23xhriwIQ3zzYItovtl9jOw4k6mEK62J2P06XfyGtMLtS6sSVK4wdIRoaNl3EHQJT8wQJfEy4tfphRZtHd1BpcZ9rA2wmU8uTuMY/mLdkzaVskOr1B7niLzAgKtAGAfeTZQ6ZdF4oRSp5NOBsa4wmrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786373164; c=relaxed/simple;
	bh=ubvtpYsrYWmH9jz19PeR1V+LHbnbiyhArbvyhk7FgDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ji5KCxvlfjVjq1AlBeXVOLm6F6RAKaT6gVPXXaY27HafDmGu8uU6Oh53emRzAvsFVuxiItWEaOrvHKLmTjsc9XqgBLEUFIKab2e/FRSnAl9ZcJNjYBWY7oS72eeW9Wm6KbXTMtLnVDC1vcCIhUySR4H/MmK2HvSFFBiQ7g627VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZjlpOaxc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZjlpOaxc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=1Lmb88p+cpryq5HXWLXRKXYmtZimwxaBhgeOhNY3PzE=; b=ZjlpOaxcjkG2f9OfkwELBNEzTf
	ggKbF5B/67GpDWQrfUEvvWOm6N35oevLeRO+6030iJHPj2PMWXpaVJNv2DIyP+hoYeHLmSGhctapb
	XIWAc93R4BkxMMeHs/qT7cJ04hcrL1srn8hMzvbpo27fVKLTPh9o17t71xQv1LzenM628CCqDIVCM
	0PPEM3Fzl2tBQIgkvF7VFgp+VT6O6s/c5dYBFz1uP5ISwD07DTcy8DmnF5TwTbrxwV4pvYGuhKH0v
	XX+DTw51mufx9Ucgtu6kXV8a8QyxeZIQAMXvdBM9tD4QHFcET45iUo8jbR02cL5G8JYBbwoWtRyNV
	sLfeSgLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtRFt-0000000C3l2-13Nj;
	Mon, 10 Aug 2026 14:45:35 +0000
Date: Mon, 10 Aug 2026 07:45:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Hillf Danton <hdanton@sina.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
	Christoph Hellwig <hch@lst.de>
Subject: RWF_DONTCACHE regression fix for xfs
Message-ID: <annkDbhXBEeMoNVT@infradead.org>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Below is Tal's suggested fixup for xfs with the whitespace damage fixeѕ.
It should probably be attributed to Tal instead.  Can you handled it
from here and send it to Jens with your signoff/authorship to avoid
the performance regression in XFS?

From: Christoph Hellwig <hch@lst.de>
Subject: xfs: avoid double deferrals for RWF_DONTCACHE writes

XFS already defers some writes to a workqueue when transactions are
needed to process the I/O completion.  Disable the block layer bio
task completion in this case to avoid a major performance drop.

Fixes: efbde6f9f449 ("iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback")
---
 fs/xfs/xfs_aops.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f73e26d9c9f9..059846a8d65c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -372,10 +372,14 @@ xfs_writeback_submit(
 	}
 
 	/*
-	 * Send ioends that might require a transaction to the completion wq.
+	 * Send ioends that might require a transaction to the completion wq,
+	 * and disable the block layer task completion for them as there is no
+	 * need to defer twice.
 	 */
-	if (xfs_ioend_needs_wq_completion(ioend))
+	if (xfs_ioend_needs_wq_completion(ioend)) {
 		ioend->io_bio.bi_end_io = xfs_end_bio;
+		bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+	}
 
 	return iomap_ioend_writeback_submit(wpc, error);
 }
@@ -481,7 +485,14 @@ xfs_zoned_writeback_submit(
 {
 	struct iomap_ioend		*ioend = wpc->wb_ctx;
 
+	/*
+	 * Defer all completions to our workqueue as all zoned writes require a
+	 * transaction to be persisted.  This also means we never need the block
+	 * layer in-task completion for a task context.
+	 */
 	ioend->io_bio.bi_end_io = xfs_end_bio;
+	bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+
 	if (error) {
 		ioend->io_bio.bi_status = errno_to_blk_status(error);
 		bio_endio(&ioend->io_bio);
-- 
2.53.0


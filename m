Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106454C6534
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349371; cv=none; b=l3EkdT8uNyDthD5eQ0WSpWb80va57kLwT6EawVsMi3I0wpHICEWTgwGR4q/agZZLPJn9R0HQHudAGx2QFA5bPyFXpPc6xhv0fROj85vufSQfSbxYFJ/rT3/qbo6UvgdZx2uu6umKPHbwlmBOuNzbTVT+EIaB7jjzJjiZX1lDZzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349371; c=relaxed/simple;
	bh=uIyoJcl7cfEg9Eu4bPNeAblt3qHi1BBcepGqYVVlfR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtVaBlG2tkzt/JYHwaiPiXjW9D1viwtxqYD8fRmIOgVK3MGwQ27nawEwIJl+xjGKAOyGiNbJIE1Kf6xSeesBDFTHB9LYq6j6Q84yVA3yHhDGlV1dDQtmgzCWPHLJxC17UhaGslOMBJDkgqXrH5cEgPrdjVeWSjWltDbu0/wLWQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=drMycP6u; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="drMycP6u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=y2Qya8G21TKqY24+P1MG7jQ8UuWxl9dr556/Gp4inJw=; b=drMycP6ukO2tXsjEnpEDNyxZ6V
	UZXuygJP9dqOrFl9KdlziDnvgfLN4JjEbipzWMywMay0lDV1ADpQ+JNMHKYALETb8HxJAuhBUR61L
	5yikvjdfnMskiYApJsZ33FNQtshy0MbE/8IUCIlsDU5bHOi9TWjWEId1ZWXfwtGF63bDl/RYicbsB
	uMpBToBADUTdvY9ZjdiF4/dxP7tsZVem1evsiTAuCa+7TljMOynse0EyFlIwSa6afzuHLxDc6NNNa
	imRqqkHQWPUM4anMNq3ZP9BDfRIyHiXVfXyZ7+FyLvlgvz7/XMnwsu3ANhmgOwz+BytNcwfpvrqLt
	hbe6vLow==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7eW-0000000Djgk-1naI;
	Fri, 25 Sep 2026 15:15:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: flush multiple device caches in parallel in xlog_write_iclog
Date: Fri, 25 Sep 2026 17:15:38 +0200
Message-ID: <20260925151543.3382123-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925151543.3382123-1-hch@lst.de>
References: <20260925151543.3382123-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When xlog_write_iclog needs to flush the cache for more than one devices,
the current implementations does this sequentially, which adds up the
flush latency for all devices.  Switch to kicking off all cache flushes
in parallel so that only the longest latency bounds the time of the log
I/O.  This removes the REQ_PREFLUSH optimization for the log device,
but as that flag is never passed on to the device and just very slightly
reduce the latency by queueing the following write from a lower-level
context it is trivially shadowed by the latency improvements of the
parallel flush commands.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log.c | 82 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 73 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 893ea899a0a8..74b324f915a1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1544,6 +1544,47 @@ xlog_bio_end_io(
 		   &iclog->ic_end_io_work);
 }
 
+struct xlog_flush_done {
+	atomic_t		pending;
+	blk_status_t		status;
+	struct completion	done;
+};
+
+static void
+xlog_flush_done(
+	struct xlog_flush_done	*done)
+{
+	if (atomic_dec_and_test(&done->pending))
+		complete(&done->done);
+}
+
+static void
+xlog_flush_end_io(
+	struct bio		*bio)
+{
+	struct xlog_flush_done	*done = bio->bi_private;
+
+	if (bio->bi_status)
+		cmpxchg(&done->status, 0, bio->bi_status);
+	xlog_flush_done(done);
+	bio_put(bio);
+}
+
+static void
+xlog_flush_async(
+	struct xlog_flush_done	*done,
+	struct block_device	*bdev)
+{
+	struct bio		*bio;
+
+	bio = bio_alloc(bdev, 0, REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC,
+			GFP_NOFS);
+	bio->bi_private = done;
+	bio->bi_end_io = xlog_flush_end_io;
+	atomic_inc(&done->pending);
+	submit_bio(bio);
+}
+
 /*
  * When using multiple devices, we also need to flush the data and RT device
  * caches first to ensure that all metadata writeback covered by the LSN in
@@ -1557,16 +1598,36 @@ xlog_bio_end_io(
  */
 static int
 xlog_flush_data_caches(
-	struct xlog		*log)
+	struct xfs_mount	*mp,
+	bool			*did_flush)
 {
-	struct xfs_mount	*mp = log->l_mp;
+	struct xlog_flush_done done = {
+		.pending	= ATOMIC_INIT(1),
+		.done		= COMPLETION_INITIALIZER_ONSTACK(done.done),
+	};
 
-	if (log->l_targ != mp->m_ddev_targp) {
-		if (blkdev_issue_flush(mp->m_ddev_targp->bt_bdev))
-			return -EIO;
+	*did_flush = false;
+	if (mp->m_ddev_targp != mp->m_logdev_targp &&
+	    bdev_write_cache(mp->m_ddev_targp->bt_bdev)) {
+		xlog_flush_async(&done, mp->m_ddev_targp->bt_bdev);
+		*did_flush = true;
+	}
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp &&
+	    bdev_write_cache(mp->m_rtdev_targp->bt_bdev)) {
+		xlog_flush_async(&done, mp->m_rtdev_targp->bt_bdev);
+		*did_flush = true;
 	}
-	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
-		if (blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev))
+
+	if (*did_flush) {
+		/*
+		 * If we flushed any other device, also use an async flush for
+		 * the log device so that all flushes happen in parallel.
+		 */
+		xlog_flush_async(&done, mp->m_logdev_targp->bt_bdev);
+
+		xlog_flush_done(&done);
+		wait_for_completion(&done.done);
+		if (done.status)
 			return -EIO;
 	}
 
@@ -1580,6 +1641,8 @@ xlog_write_iclog(
 	uint64_t		bno,
 	unsigned int		count)
 {
+	bool			did_flush = false;
+
 	ASSERT(bno < log->l_logBBsize);
 	trace_xlog_iclog_write(iclog, _RET_IP_);
 
@@ -1617,10 +1680,11 @@ xlog_write_iclog(
 	iclog->ic_bio.bi_private = iclog;
 
 	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
-		if (xlog_flush_data_caches(log))
+		if (xlog_flush_data_caches(log->l_mp, &did_flush))
 			goto shutdown;
 	}
-	if (iclog->ic_flags & (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG))
+	if (!did_flush &&
+	    (iclog->ic_flags & (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG)))
 		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
 	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
 		iclog->ic_bio.bi_opf |= REQ_FUA;
-- 
2.53.0


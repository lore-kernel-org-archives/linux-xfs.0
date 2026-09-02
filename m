Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A222430D407
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 05:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328206; cv=none; b=Vrp5Cq831eXkpBHCXbBK2V9DON/UaEuCEHcrk32AZD57lyPTQOQHNCeRTlDZXutMTY5dOCO8QDeyHSUokba7Smcwcp9WjD/trDrLQufF6GmPd/2nHuUI3ZRf/iXvJpaXABhgUjMBK0T3dd6sZmRyXrvNz8AKCVE/DJNA04hlM5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328206; c=relaxed/simple;
	bh=wTtBwz+DVFspzIjLxgC/uSBlbT9Y9XC2rqP9DyJzpQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbfmAQDDxhrGLtxf2dRWB74OjDhvit7BWOCzuxm3PJV1cpGuCAZlSRrxjLlSKReYGsOw8NZFs1flu/8sG7WNVc2VnMQzvclH7xxVh+R5+VG6ESr1YZqgrszmWWKolPIBWgcvHOIYe7wIyN7OjQdgaJdTmjBHdBnSrJ50Lig64Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fPYgS8n1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fPYgS8n1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PglEpwifSOGXzPcaFzUkNGZ9PMP38/y156VSjR1CoBE=; b=fPYgS8n1TkTCsL7s6lr7m2OZvx
	bPviwWoi9vQIoyOMLqAdd3l8zXwUTE6IuVMt9gsprc3z82HWWoG3AwTwZ1prpltABBePDoW94QTuU
	H6S02d0RszAMtPrLE2/+hjF2TWe9M9R/EHaHH2jogjuhq1osCNlNUIrf5W3/OMpRk1j7OGkjIFjxT
	jQNrlTexC9tOByQ9URIP+DOh4D8V+MmFtTp3eHsjt19B3RtBVfa81WFBXJcqzOoRnTQw3e0P35dNH
	nQuHRCMO2cNaF7cJ6CwAoFWlGGVmXDYxnY1h0aZicdPkuRqbU8Hvtyj7Rnb+LgTHgvzVlws9Nv2QB
	4fJQXCmQ==;
Received: from 87-119-185-211.ip.elisa.ee ([87.119.185.211] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1drI-0000000Dp6K-2jaR;
	Wed, 02 Sep 2026 05:50:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] xfs: flush multiple device caches in parallel in xlog_write_iclog
Date: Wed,  2 Sep 2026 08:49:20 +0300
Message-ID: <20260902054942.111988-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902054942.111988-1-hch@lst.de>
References: <20260902054942.111988-1-hch@lst.de>
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
---
 fs/xfs/xfs_log.c | 78 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 71 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a5870877baed..b392a45d38c6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1538,6 +1538,47 @@ xlog_bio_end_io(
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
@@ -1551,17 +1592,39 @@ xlog_bio_end_io(
  */
 static int
 xlog_flush_data_caches(
-	struct xlog		*log)
+	struct xlog		*log,
+	struct xlog_in_core	*iclog)
 {
 	struct xfs_mount	*mp = log->l_mp;
+	struct xlog_flush_done done = {
+		.pending	= ATOMIC_INIT(1),
+		.done		= COMPLETION_INITIALIZER_ONSTACK(done.done),
+	};
+	bool			did_flush = false;
 
-	if (log->l_targ != mp->m_ddev_targp) {
-		if (blkdev_issue_flush(mp->m_ddev_targp->bt_bdev))
-			return -EIO;
+	if (mp->m_ddev_targp != log->l_targ &&
+	    bdev_write_cache(mp->m_ddev_targp->bt_bdev)) {
+		xlog_flush_async(&done, mp->m_ddev_targp->bt_bdev);
+		did_flush = true;
+	}
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp &&
+	    bdev_write_cache(mp->m_rtdev_targp->bt_bdev)) {
+		xlog_flush_async(&done, mp->m_rtdev_targp->bt_bdev);
+		did_flush = true;
 	}
-	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
-		if (blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev))
+
+	if (did_flush) {
+		/*
+		 * If we flushed any other device, also use an async flush for
+		 * the log device so that all flushes happen in parallel.
+		 */
+		xlog_flush_async(&done, log->l_targ->bt_bdev);
+
+		xlog_flush_done(&done);
+		wait_for_completion(&done.done);
+		if (done.status)
 			return -EIO;
+		iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
 	}
 
 	return 0;
@@ -1611,8 +1674,9 @@ xlog_write_iclog(
 	iclog->ic_bio.bi_private = iclog;
 
 	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
-		if (xlog_flush_data_caches(log))
+		if (xlog_flush_data_caches(log, iclog))
 			goto shutdown;
+		/* xlog_flush_data_caches may clear XLOG_ICL_NEED_FLUSH */
 	}
 	if (iclog->ic_flags & (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG))
 		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
-- 
2.53.0


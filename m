Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571EB38D69D
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 05:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328193; cv=none; b=FHtYkckbB2cp8QfW40W8LlKNu4E8GVkplcL2Kl+12LRRLVxdwH88jS0DcF7GFPyfK+janiG/BBedinIMF80yxl8mZsLSzPepSrPh9C3Wi047W3g3S3QN0dveLfoqmq9AfgPaVndzki9WjwYD8oTcmKBq72tT5odnUEl7RdsSkwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328193; c=relaxed/simple;
	bh=pdUt9lNn+CdI7BhaD+XwPHNFomgUgpOmYFSsHYLx3vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnnVfmys369qZbJQk0BQz6NmK0wZNVWD2oRv7xMq+A7vA6QVlIY6j/EapXQq4+30zR51yMKT2WrZvvjKeokh9nR61VJ2ZUl5PwoIcltgMJVjqlb7l2Nj89WZjIw0CK8xn+GYRaxstx6Id1pegY8cqqb+LyeDrLrR4vIW+Z9ZZKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xvmjrqVF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xvmjrqVF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kAV4yC1y9LMCKneq2xPDjdQZp+SENXLUyWHPh8z+jWY=; b=xvmjrqVFnD30DZowKVY3GH4Pf8
	HHvJ3jlcmnXNhvYFTeDzmXpDehj/t04Yd20BadQ1pjbxgkBYle4JB0Y2BiRcu5XXAn1SFyKJ3jtrS
	R/5aa6bKr3ZDlvHc7HFqR2EnyrxRqcgwu94saGd0fBoTKYDLgwSLgHAlUgJn3WFNonMkQE6ZBc1wG
	VazNSz1mwbUAVqAwEqvn2yNVtwgsKX2tI3n2XyZFPQeE7g6pLLCXc3gqkLchYfniktddpHyTx5hiu
	jeieD6WymeMNGZKVrgmB+tN9iEaQAMHx8V4zyIFSVf5P5ns7afASsDod9ohhrKfGvkdT6XLjad2WU
	xsgi+JQA==;
Received: from 87-119-185-211.ip.elisa.ee ([87.119.185.211] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1dr3-0000000Dp4u-1gBa;
	Wed, 02 Sep 2026 05:49:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] xfs: also flush the RT device cache in xlog_write_iclog
Date: Wed,  2 Sep 2026 08:49:15 +0300
Message-ID: <20260902054942.111988-2-hch@lst.de>
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

The cache flush before writing the CIL start record no only needs to
ensure any metadata covered by the overwritten part of the log is on
stable storage, but also that any data pointed to by metadata logged
is on stable storage, as otherwise log recovery could created allocated
blocks that point to stale data.  Fortunately the code already
handles this right for the data device, but it also needs to flush
the RT device for this to work for data on the RT device.

Also update the comments to explicitly mention this case.

This omission goes back to the first days of cache control in XFS.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c     | 45 ++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_log_cil.c |  7 ++++---
 2 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f807f8f4f705..8079f2e003db 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1538,6 +1538,35 @@ xlog_bio_end_io(
 		   &iclog->ic_end_io_work);
 }
 
+/*
+ * When using multiple devices, we also need to flush the data and RT device
+ * caches first to ensure that all metadata writeback covered by the LSN in
+ * this iclog is on stable storage. This is slow, but it *must* complete
+ * before we issue the external log IO.
+ *
+ * If the flush fails, we cannot conclude that past metadata writeback from
+ * the log succeeded.  Repeating the flush is not possible, hence we must
+ * shut down with log IO error to avoid shutdown re-entering this path and
+ * erroring out again.
+ */
+static int
+xlog_flush_data_caches(
+	struct xlog		*log)
+{
+	struct xfs_mount	*mp = log->l_mp;
+
+	if (log->l_targ != mp->m_ddev_targp) {
+		if (blkdev_issue_flush(mp->m_ddev_targp->bt_bdev))
+			return -EIO;
+	}
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
+		if (blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev))
+			return -EIO;
+	}
+
+	return 0;
+}
+
 STATIC void
 xlog_write_iclog(
 	struct xlog		*log,
@@ -1582,21 +1611,9 @@ xlog_write_iclog(
 	iclog->ic_bio.bi_private = iclog;
 
 	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
-		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
-		/*
-		 * For external log devices, we also need to flush the data
-		 * device cache first to ensure all metadata writeback covered
-		 * by the LSN in this iclog is on stable storage. This is slow,
-		 * but it *must* complete before we issue the external log IO.
-		 *
-		 * If the flush fails, we cannot conclude that past metadata
-		 * writeback from the log succeeded.  Repeating the flush is
-		 * not possible, hence we must shut down with log IO error to
-		 * avoid shutdown re-entering this path and erroring out again.
-		 */
-		if (log->l_targ != log->l_mp->m_ddev_targp &&
-		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev))
+		if (xlog_flush_data_caches(log))
 			goto shutdown;
+		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
 	}
 	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
 		iclog->ic_bio.bi_opf |= REQ_FUA;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 639f875a8fb2..3d159b1350df 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1055,9 +1055,10 @@ xlog_cil_set_ctx_write_state(
 		spin_unlock(&cil->xc_push_lock);
 
 		/*
-		 * Make sure the metadata we are about to overwrite in the log
-		 * has been flushed to stable storage before this iclog is
-		 * issued.
+		 * Flush the write cache before writing the start record so that
+		 * the metadata we are about to overwrite in the log and the
+		 * data that new allocations in this context refer to are
+		 * persisted to stable storage before this iclog is written.
 		 */
 		spin_lock(&cil->xc_log->l_icloglock);
 		iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
-- 
2.53.0


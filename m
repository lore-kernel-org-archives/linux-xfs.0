Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D532153C7
	for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2025 09:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739784734; cv=none; b=u1x9p3VmW9+yJW/7afoiGsTBozLLogSYvtz+nHnoiBO6pfnAn1aclFDOjbCqrPmH42vmbzTfJ4tQptpHMclLfOqTmRNzeTWLTPXFxFjRxI0UUO/zj+W2EXParw1B5gkopFl6iRaQBYr7l5GpJmV3qXJ8DI7geaY5lUDAQtzKDzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739784734; c=relaxed/simple;
	bh=OCNTfNqAj/p3hCxriSJXudESRuydYxSXGV8bOZURJJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acr7HtLH/DbnOuC6suIxSSCw5qHPJckYZ2BLuforhkPLvikpPWuqDNhappiJc+T69XH275HnVBhEWF4J7HLiKWil7rRU4mGnFUHWDvby9BtEUtphqgcZJV3EI390nBGO1KJjkdWOB+2PgYoFdP50Ep+4iizga+ftgCdB1pHby08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d2OkWECo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d2OkWECo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JEsasq2f4ZAU/rckU/k8GBDUwJg22AmpwVOkzv15BAk=; b=d2OkWECoB6JBsgrjy/IA8H/bO8
	WbYzWqsEPS2g7wbVy1BrXo8lYY1r80+aEkRhKyIijyZmBjofKPW3+TuOZ4qzgzgFaeblWyosOLeqN
	YynBf/+mqvVGq4d46jl/7VVL9mVJoqUK4YDMHut0SIX5/3uB5OqD0pucxlD0bmCpal4HA5QeHXRco
	Do6vltXdtjQcSCpfdSquNicXH70duAuxc+CgUxkMnPbhYG2VsDH9jFkDwzcneFiIMPC8g8sO5J9P7
	eO+Lo0ohZrBbUSVvHs9s3/hAS9YkPaD1gkcSkP0g2a0VWHeJ0UMTxWdOS5+YqtAIfHRop6nCUHucD
	1BLm0J2Q==;
Received: from 2a02-8389-2341-5b80-a8df-74d2-0b85-4db2.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:a8df:74d2:b85:4db2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tjxU4-00000003wGl-1iwe;
	Mon, 17 Feb 2025 09:32:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: reduce context switches for synchronous buffered I/O
Date: Mon, 17 Feb 2025 10:31:26 +0100
Message-ID: <20250217093207.3769550-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250217093207.3769550-1-hch@lst.de>
References: <20250217093207.3769550-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently all metadata I/O completions happen in the m_buf_workqueue
workqueue.  But for synchronous I/O (i.e. all buffer reads) there is no
need for that, as there always is a called in process context that is
waiting for the I/O.  Factor out the guts of xfs_buf_ioend into a
separate helper and call it from xfs_buf_iowait to avoid a double
an extra context switch to the workqueue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 15bb790359f8..050f2c2f6a40 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1345,6 +1345,7 @@ xfs_buf_ioend_handle_error(
 resubmit:
 	xfs_buf_ioerror(bp, 0);
 	bp->b_flags |= (XBF_DONE | XBF_WRITE_FAIL);
+	reinit_completion(&bp->b_iowait);
 	xfs_buf_submit(bp);
 	return true;
 out_stale:
@@ -1355,8 +1356,8 @@ xfs_buf_ioend_handle_error(
 	return false;
 }
 
-static void
-xfs_buf_ioend(
+static bool
+__xfs_buf_ioend(
 	struct xfs_buf	*bp)
 {
 	trace_xfs_buf_iodone(bp, _RET_IP_);
@@ -1376,7 +1377,7 @@ xfs_buf_ioend(
 		}
 
 		if (unlikely(bp->b_error) && xfs_buf_ioend_handle_error(bp))
-			return;
+			return false;
 
 		/* clear the retry state */
 		bp->b_last_error = 0;
@@ -1397,7 +1398,15 @@ xfs_buf_ioend(
 
 	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD |
 			 _XBF_LOGRECOVERY);
+	return true;
+}
 
+static void
+xfs_buf_ioend(
+	struct xfs_buf	*bp)
+{
+	if (!__xfs_buf_ioend(bp))
+		return;
 	if (bp->b_flags & XBF_ASYNC)
 		xfs_buf_relse(bp);
 	else
@@ -1411,15 +1420,8 @@ xfs_buf_ioend_work(
 	struct xfs_buf		*bp =
 		container_of(work, struct xfs_buf, b_ioend_work);
 
-	xfs_buf_ioend(bp);
-}
-
-static void
-xfs_buf_ioend_async(
-	struct xfs_buf	*bp)
-{
-	INIT_WORK(&bp->b_ioend_work, xfs_buf_ioend_work);
-	queue_work(bp->b_mount->m_buf_workqueue, &bp->b_ioend_work);
+	if (__xfs_buf_ioend(bp))
+		xfs_buf_relse(bp);
 }
 
 void
@@ -1491,7 +1493,13 @@ xfs_buf_bio_end_io(
 		 XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
 		xfs_buf_ioerror(bp, -EIO);
 
-	xfs_buf_ioend_async(bp);
+	if (bp->b_flags & XBF_ASYNC) {
+		INIT_WORK(&bp->b_ioend_work, xfs_buf_ioend_work);
+		queue_work(bp->b_mount->m_buf_workqueue, &bp->b_ioend_work);
+	} else {
+		complete(&bp->b_iowait);
+	}
+
 	bio_put(bio);
 }
 
@@ -1568,9 +1576,11 @@ xfs_buf_iowait(
 {
 	ASSERT(!(bp->b_flags & XBF_ASYNC));
 
-	trace_xfs_buf_iowait(bp, _RET_IP_);
-	wait_for_completion(&bp->b_iowait);
-	trace_xfs_buf_iowait_done(bp, _RET_IP_);
+	do {
+		trace_xfs_buf_iowait(bp, _RET_IP_);
+		wait_for_completion(&bp->b_iowait);
+		trace_xfs_buf_iowait_done(bp, _RET_IP_);
+	} while (!__xfs_buf_ioend(bp));
 
 	return bp->b_error;
 }
-- 
2.45.2


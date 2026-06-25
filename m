Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A964B3033F5
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 13:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782395950; cv=none; b=p5k8Vooq6dTyF9nrDpWgeOzS8YfS3mfTm7oiwXUDAsvttDKhD8Ug6Az7hy85ks4NUQha1WhSWApb9VkkZ7/Iov/HeLojgZnly19D56G0TB1iW7HhpXKzfIrmefK5E52dhhxUGq6jwEyq0FOPABKPma6RnFUeNF5dQsRMaGbf9Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782395950; c=relaxed/simple;
	bh=DFTMwKFdVzGTSNm0ECe30LcMEh3xsG9pDo+3bVxQpNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYXbZgSy0rycz8ut42ZPi266gPF67dVLQogPTwNbvR7aC+I2rAnqyXkijSwjLg6svgcLZlYY/h+Olm5cph8kskRaJqd7fEsn72gMrHIR6hOQoev58gdoCQvY3Rg9pujmMdUPw3BR2K+1uBTO3Y7A0XYXv71t53ukWrp9E9m+G+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qL+kDU41; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qL+kDU41"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ocuA6EcxB5t0oy7sHfuNBKseJriEKv2GZeFtBobXTic=; b=qL+kDU41pg55bjbh+9WgZSQOhY
	hJhlqwvshdCgd9go4npLGMuayfoIQkxq9uZsnXOOAXOjMDOTxJWsHO+S8Vbre9WP2GIhSnC3h03zo
	Epz06kJQ00ce3Oz7r2+AB6DZb2WT5eHKHjxc0scY0lqDXuUqFqqArfZu+aZEVphmkac8UZeKP4l+v
	mhidnk/tiP3FbkAuMN+Z5RPVHpCThANDTFxz6DsR5HB0gT8GTIUqWWyYaljjNLN8Fh5iMT+aZ/Hz6
	RhDb7e5v0Og4yJXVu/TqbKPLEX3XlKk4anhs34qTbf9L63Doz5UvVedG4EE12y0tREKR1chVOr1p5
	JnRdKG9Q==;
Received: from 2a02-8389-2301-9f00-3397-c9eb-6d8a-9179.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:3397:c9eb:6d8a:9179] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wckbl-00000009Gsr-0Uvb;
	Thu, 25 Jun 2026 13:59:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 6/6] xfs: simplify __xfs_buf_ioend
Date: Thu, 25 Jun 2026 15:58:36 +0200
Message-ID: <20260625135849.2494779-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260625135849.2494779-1-hch@lst.de>
References: <20260625135849.2494779-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

__xfs_buf_ioend can only resubmit the buffer for asynchronous
writes, which means the retry handling xfs_buf_iowait is not needed.

Because of this can stop returning a value from __xfs_buf_ioend and
just release the buffer for async I/O that does not require retries.

Also drop the __-prefix now that the semantics are straight forward.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf.c | 51 ++++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 83549573e2cc..f8511c11e017 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1098,11 +1098,17 @@ xfs_buf_ioend_handle_error(
 	return false;
 }
 
-/* returns false if the caller needs to resubmit the I/O, else true */
-static bool
-__xfs_buf_ioend(
+/*
+ * Complete a buffer read or write.
+ *
+ * Releases the buffer if the I/O was asynchronous.
+ */
+static void
+xfs_buf_ioend(
 	struct xfs_buf	*bp)
 {
+	bool		async = bp->b_flags & XBF_ASYNC;
+
 	trace_xfs_buf_iodone(bp, _RET_IP_);
 
 	if (bp->b_flags & XBF_READ) {
@@ -1116,14 +1122,16 @@ __xfs_buf_ioend(
 		if (bp->b_flags & XBF_READ_AHEAD)
 			percpu_counter_dec(&bp->b_target->bt_readahead_count);
 	} else {
-		if (!bp->b_error) {
+		if (unlikely(bp->b_error)) {
+			if (xfs_buf_ioend_handle_error(bp)) {
+				ASSERT(async);
+				return;
+			}
+		} else {
 			bp->b_flags &= ~XBF_WRITE_FAIL;
 			bp->b_flags |= XBF_DONE;
 		}
 
-		if (unlikely(bp->b_error) && xfs_buf_ioend_handle_error(bp))
-			return false;
-
 		/* clear the retry state */
 		bp->b_last_error = 0;
 		bp->b_retries = 0;
@@ -1143,18 +1151,15 @@ __xfs_buf_ioend(
 
 	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD |
 			 _XBF_LOGRECOVERY);
-	return true;
+	if (async)
+		xfs_buf_relse(bp);
 }
 
 static void
 xfs_buf_ioend_work(
 	struct work_struct	*work)
 {
-	struct xfs_buf		*bp =
-		container_of(work, struct xfs_buf, b_ioend_work);
-
-	if (__xfs_buf_ioend(bp))
-		xfs_buf_relse(bp);
+	xfs_buf_ioend(container_of(work, struct xfs_buf, b_ioend_work));
 }
 
 void
@@ -1195,8 +1200,7 @@ xfs_buf_fail(
 	bp->b_flags &= ~XBF_DONE;
 	xfs_buf_stale(bp);
 	xfs_buf_ioerror(bp, -EIO);
-	if (__xfs_buf_ioend(bp))
-		xfs_buf_relse(bp);
+	xfs_buf_ioend(bp);
 }
 
 int
@@ -1305,12 +1309,11 @@ xfs_buf_iowait(
 {
 	ASSERT(!(bp->b_flags & XBF_ASYNC));
 
-	do {
-		trace_xfs_buf_iowait(bp, _RET_IP_);
-		wait_for_completion(&bp->b_iowait);
-		trace_xfs_buf_iowait_done(bp, _RET_IP_);
-	} while (!__xfs_buf_ioend(bp));
+	trace_xfs_buf_iowait(bp, _RET_IP_);
+	wait_for_completion(&bp->b_iowait);
+	trace_xfs_buf_iowait_done(bp, _RET_IP_);
 
+	xfs_buf_ioend(bp);
 	return bp->b_error;
 }
 
@@ -1403,12 +1406,10 @@ xfs_buf_submit(
 	bp->b_flags &= ~XBF_DONE;
 	xfs_buf_stale(bp);
 end_io:
-	if (bp->b_flags & XBF_ASYNC) {
-		if (__xfs_buf_ioend(bp))
-			xfs_buf_relse(bp);
-	} else {
+	if (bp->b_flags & XBF_ASYNC)
+		xfs_buf_ioend(bp);
+	else
 		complete(&bp->b_iowait);
-	}
 }
 
 /*
-- 
2.53.0


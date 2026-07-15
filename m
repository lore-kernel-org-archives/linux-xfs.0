Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54403955CF
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 14:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127143; cv=none; b=PQzmV4AXNQLq00cHJ8OTa1rEl2FWgZHpB2v1OSb7DDtXfU6prWSzqAzDAfd6AKGp5FGgRjCjjd0kHhNHzFnT45uQcNZF1XhZ2YoQ+IjABx4WgBHsBuRsBC3B4B2OKcOEaYcRi+by3QlSTPPo6xar+/p72Y/KVSpOpagZoPAq3nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127143; c=relaxed/simple;
	bh=2h8kkkn8ZPOfokquHwjttYYdIoAruG4gw+xsRVImCDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oy+uvO6W/ymmj+6KtHwvVCtAxM47j+fm9JEJ74YW2Aun6di3L2hYdsHcTCajDRWkYF/uvMpiipoe5g21f4GVJTLqSUxNb2JUR6GSLt51w/u6H5x8wtd1pnsoq0rJW+bfNHtDtu72qmVyXzp/7YLMvCxrfHxftdyrhY44Nwu7K/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LqZ6bz/6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LqZ6bz/6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8fT8pasRNrhLIwhoqmYODK9/mhejDC+I7fXBxjmWy+0=; b=LqZ6bz/6Jibw59cD2iqAQ8D1vQ
	akEhVpjvW3rU50HaynLB4veb9PgVWF3Tjohw2OuPTSTgMuSkqDGgfywOiEedpdubJHCV/YRye8v4R
	XSCEAsyORNQvm3Pj1bOQbjtwMgPIbytzw13yPVaW0O4K3kHGlQ3qXd+43EbHuFQEMiGsis9TvB3OJ
	qGwh1Q4Br9vuc7zYbwPmOCrVfZ8vzinIi1yYiiTWyjQ/MuHXQJuvLgUduBPWUvjsgmVgfVqGYRn0Z
	IAJw5VlVUE39jST+raCmHIEmwTT024J7xa0Pj64QOmmIbyCVmDS5Cuo17EH6HBd4rN6ax3bsQPKHg
	aoujZz0w==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0yD-0000000FDY8-0jRL;
	Wed, 15 Jul 2026 14:52:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/12] xfs: merge xfs_buf_reverify into xfs_buf_read_map
Date: Wed, 15 Jul 2026 16:51:03 +0200
Message-ID: <20260715145147.95654-11-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715145147.95654-1-hch@lst.de>
References: <20260715145147.95654-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_buf_read_map is the only caller of xfs_buf_reverify that is left.
Merge it into that so that the comments can be moved closer to the
logic, and redundant asserts can be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 79 ++++++++++++++++++++++--------------------------
 1 file changed, 36 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 21c21491d72e..be3b25ccbea6 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -626,41 +626,6 @@ _xfs_buf_read(
 	return xfs_buf_iowait(bp);
 }
 
-/*
- * Reverify a buffer found in cache without an attached ->b_ops.
- *
- * If the caller passed an ops structure and the buffer doesn't have ops
- * assigned, set the ops and use it to verify the contents. If verification
- * fails, clear XBF_DONE. We assume the buffer has no recorded errors and is
- * already in XBF_DONE state on entry.
- *
- * Under normal operations, every in-core buffer is verified on read I/O
- * completion. There are two scenarios that can lead to in-core buffers without
- * an assigned ->b_ops. The first is during log recovery of buffers on a V4
- * filesystem, though these buffers are purged at the end of recovery. The
- * other is online repair, which intentionally reads with a NULL buffer ops to
- * run several verifiers across an in-core buffer in order to establish buffer
- * type.  If repair can't establish that, the buffer will be left in memory
- * with NULL buffer ops.
- */
-static int
-xfs_buf_reverify(
-	struct xfs_buf		*bp,
-	const struct xfs_buf_ops *ops)
-{
-	ASSERT(bp->b_flags & XBF_DONE);
-	ASSERT(bp->b_error == 0);
-
-	if (!ops || bp->b_ops)
-		return 0;
-
-	bp->b_ops = ops;
-	bp->b_ops->verify_read(bp);
-	if (bp->b_error)
-		xfs_buf_clear_flags(bp, XBF_DONE);
-	return bp->b_error;
-}
-
 int
 xfs_buf_read_map(
 	struct xfs_buftarg	*target,
@@ -685,18 +650,46 @@ xfs_buf_read_map(
 
 	trace_xfs_buf_read(bp, flags, _RET_IP_);
 
-	if (!(bp->b_flags & XBF_DONE)) {
+	if (bp->b_flags & XBF_DONE) {
+		ASSERT(bp->b_error == 0);
+
+		/*
+		 * If the caller passed an ops structure and the buffer doesn't
+		 * have ops assigned yet, set the ops and use them to verify the
+		 * buffer contents.
+		 *
+		 * Under normal operations, every in-core buffer is verified on
+		 * read I/O completion, but there are two scenarios that can
+		 * lead to in-core buffers without an assigned ->b_ops:
+		 *
+		 *   1) During log recovery of buffers on a V4 filesystem.
+		 *	These buffers are purged at the end of recovery, though.
+		 *   2) Oonline repair intentionally reads with a NULL buffer
+		 *	ops to run several verifiers across an in-core buffer in
+		 *	order to establish buffer type.  If repair can't
+		 *	establish that, the buffer will be left in memory with
+		 *	NULL buffer ops.
+		 */
+		if (ops && !bp->b_ops) {
+			bp->b_ops = ops;
+			bp->b_ops->verify_read(bp);
+			/*
+			 * If verification failed, clear XBF_DONE as we assume
+			 * that buffers have no recorded errors when in XBF_DONE
+			 * state.
+			 */
+			error = bp->b_error;
+			if (error)
+				xfs_buf_clear_flags(bp, XBF_DONE);
+		}
+
+		/* We do not want read in the flags */
+		xfs_buf_clear_flags(bp, XBF_READ);
+	} else {
 		/* Initiate the buffer read and wait. */
 		XFS_STATS_INC(target->bt_mount, xb_get_read);
 		bp->b_ops = ops;
 		error = _xfs_buf_read(bp);
-	} else {
-		/* Buffer already read; all we need to do is check it. */
-		error = xfs_buf_reverify(bp, ops);
-
-		/* We do not want read in the flags */
-		xfs_buf_clear_flags(bp, XBF_READ);
-		ASSERT(bp->b_ops != NULL || ops == NULL);
 	}
 
 	if (error)
-- 
2.53.0


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753B445A29E;
	Thu, 24 Sep 2026 10:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244057; cv=none; b=ORC0mUeF73jxON03fSvMLWHz5M9XLe516LtU1L1gfbGGYXWodaLe+JkxyQXXuHmvKsGNtxVfnx3DiSSa7Ax6RWK/l5zWV6hvTDGL7zWYeNG73RueCtPrqhnLsg6ZcGC0pnbdQiqyavyu6Ze+pNjw61rBoepciIlWeKgfAs7PkpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244057; c=relaxed/simple;
	bh=DXCK4GHRKBIL63ZdSdKaB/0L7/XEP2WNIpII4mstGfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GA3tEam7U4QjTHV0OO4noizCgQ5wKXrX3YTJrTlxDZmDF1LXrcGAFTdWObxol/BOq4kYdNRSF/YSEQPG8x7T4qDglXwQ8ap3l1Sl5VGjL1wPX+KAA3Sp1H+pECbVUxR0HxVUId4gZakgYQDoEJEuwyNSUSt615DNurYmqx54LJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kearC0ry; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kearC0ry"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ex5BGQdh1u3MV2esRA0GgbdGJUcpTJOQKqa21KCRs64=; b=kearC0ryjz/Dq6ck2nZNefmfyh
	xj/HQrm+iHUHoB8EEOAgpIxf65QErCDAqkbS9cqt6Fc1dcGxiZckr9aa+3IlHrfB5RCqjud5okrIF
	LYqi6t9gqX+1cW6uR0IE6bNmDm4RYBeHUfkGS9uf9KSAonPRDTiqfo57Be9eoSjIH8aH2K4nLJ4e4
	jJhgTySb0gVvgaQYGZrkOcu0FtUYAmVcKPYxIPiv7hwEljNorK99RHB7F1BzBX34lC9JDQ9tEjjNT
	FavbmkDBtkVKwjkR8FKupnlBfRBFg0RgCtaxIbfDqqJbS3TXet4dcBjbBHOsGxQzG3FJsyVpSLLEe
	zw8cNE2g==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gG2-0000000AeT2-05KT;
	Thu, 24 Sep 2026 10:00:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 03/21] xfs: add a xfs_buf_read_async buffer cache API
Date: Thu, 24 Sep 2026 11:59:35 +0200
Message-ID: <20260924100032.2733101-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a new helper that reads a buffer asynchronously.  This is similar
to readahead, but doesn't become a no-op under memory or I/O congestion
and returns the buffer to be read.

The intended use is to kick off a read of data checksum buffers at
roughly the same time as the data read so that they are available
in the I/O completion handler.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c   | 130 ++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_buf.h   |   4 ++
 fs/xfs/xfs_trace.h |   3 ++
 3 files changed, 113 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index eee491c01d8c..966c06bffeff 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -627,6 +627,40 @@ _xfs_buf_read(
 	return xfs_buf_iowait(bp);
 }
 
+/*
+ * If we've had a read error, then the contents of the buffer are invalid and
+ * should not be used.  To ensure that a followup read tries to pull the buffer
+ * from disk again, we clear the XBF_DONE flag and mark the buffer stale.
+ * This ensures that anyone who has a current reference to the buffer will
+ * interpret it's contents correctly and future cache lookups will also treat it
+ * as an empty, uninitialised buffer.
+ */
+static int
+xfs_buf_read_error(
+	struct xfs_buf		*bp,
+	xfs_failaddr_t		fa,
+	int			error)
+{
+	/*
+	 * Check against log shutdown for error reporting because metadata
+	 * writeback may require a read first and we need to report errors in
+	 * metadata writeback until the log is shut down.
+	 * High level transaction read functions already check against mount
+	 * shutdown, anyway, so we only need to be concerned about low level IO
+	 * interactions here.
+	 */
+	if (!xlog_is_shutdown(bp->b_mount->m_log))
+		xfs_buf_ioerror_alert(bp, fa);
+	xfs_buf_clear_flags(bp, XBF_DONE);
+	xfs_buf_stale(bp);
+	xfs_buf_relse(bp);
+
+	/* bad CRC means corrupted metadata */
+	if (error == -EFSBADCRC)
+		return -EFSCORRUPTED;
+	return error;
+}
+
 int
 xfs_buf_read_map(
 	struct xfs_buftarg	*target,
@@ -699,39 +733,87 @@ xfs_buf_read_map(
 	}
 
 	if (error)
-		goto out_ioerror;
-
+		return xfs_buf_read_error(bp, fa, error);
 	*bpp = bp;
 	return 0;
+}
 
-out_ioerror:
+int
+xfs_buf_read_async_wait(
+	struct xfs_buf		*bp)
+{
 	/*
-	 * Check against log shutdown for error reporting because metadata
-	 * writeback may require a read first and we need to report errors in
-	 * metadata writeback until the log is shut down.  High level
-	 * transaction read functions already check against mount shutdown, so
-	 * we only need to be concerned about low level/ IO interactions here.
+	 * Protect against the case where the checksum read is slower than the
+	 * data read.
 	 */
-	if (!xlog_is_shutdown(target->bt_mount->m_log))
-		xfs_buf_ioerror_alert(bp, fa);
+	if ((READ_ONCE(bp->b_flags) & (XBF_DONE | XBF_STALE)) == XBF_DONE &&
+	    !bp->b_error) {
+		trace_xfs_buf_read_async_wait(bp, 0, _RET_IP_);
+		return 0;
+	}
+
+	/* xfs_buf_find_lock can't return an error with 0 flags */
+	xfs_buf_find_lock(bp, 0);
+	trace_xfs_buf_read_async_lock(bp, 0, _RET_IP_);
+	if (bp->b_error)
+		return xfs_buf_read_error(bp, __builtin_return_address(0),
+				bp->b_error);
+	ASSERT(bp->b_ops);
+	xfs_buf_clear_flags(bp, XBF_READ);
+	xfs_buf_unlock(bp);
+	return 0;
+}
+
+/*
+ * Kick off an asynchronous read.  Unlike readahead, this returns a reference
+ * to the buffer, and reliably reads the data instead of skipping the read on
+ * memory pressure.
+ *
+ * The buffer may be locked when I/O is kicked off, but the I/O completion
+ * handler will unlock it.  The caller needs to lock itself if need to prevent
+ * concurrent access or to synchronize with I/O completion.
+ */
+int
+xfs_buf_read_async(
+	struct xfs_buftarg	*btp,
+	xfs_daddr_t		daddr,
+	size_t			numblks,
+	const struct xfs_buf_ops *ops,
+	struct xfs_buf		**bpp)
+{
+	DEFINE_SINGLE_BUF_MAP(map, daddr, numblks);
+	struct xfs_buf		*bp;
+	int			error;
+
+	ASSERT(!xfs_buftarg_is_mem(btp));
+
+	error = xfs_find_get_buf(btp, &map, 1, XBF_READ, &bp);
+	if (error)
+		return error;
 
 	/*
-	 * If we've had a read error, then the contents of the buffer are
-	 * invalid and should not be used. To ensure that a followup read tries
-	 * to pull the buffer from disk again, we clear the XBF_DONE flag and
-	 * mark the buffer stale. This ensures that anyone who has a current
-	 * reference to the buffer will interpret it's contents correctly and
-	 * future cache lookups will also treat it as an empty, uninitialised
-	 * buffer.
+	 * Do a lockless fast path check for a valid uptodate buffer and avoid
+	 * locking entirely in this case.
 	 */
-	xfs_buf_clear_flags(bp, XBF_DONE);
-	xfs_buf_stale(bp);
-	xfs_buf_relse(bp);
+	if ((READ_ONCE(bp->b_flags) & (XBF_DONE | XBF_STALE)) == XBF_DONE)
+		goto done;
 
-	/* bad CRC means corrupted metadata */
-	if (error == -EFSBADCRC)
-		return -EFSCORRUPTED;
-	return error;
+	/* xfs_buf_find_lock can't return an error with 0 flags */
+	xfs_buf_find_lock(bp, 0);
+	if (bp->b_flags & XBF_DONE) {
+		xfs_buf_unlock(bp);
+		goto done;
+	}
+	trace_xfs_buf_read_async(bp, 0, _RET_IP_);
+	XFS_STATS_INC(btp->bt_mount, xb_get_read);
+	xfs_buf_hold(bp);
+	bp->b_ops = ops;
+	xfs_buf_clear_flags(bp, XBF_WRITE);
+	xfs_buf_set_flags(bp, XBF_READ | XBF_ASYNC);
+	xfs_buf_submit(bp);
+done:
+	*bpp = bp;
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index a4729253b56f..1b352ec91aa6 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -255,6 +255,10 @@ xfs_buf_readahead(
 	return xfs_buf_readahead_map(target, &map, 1, ops);
 }
 
+int xfs_buf_read_async(struct xfs_buftarg *btp, xfs_daddr_t daddr,
+		size_t numblks, const struct xfs_buf_ops *ops,
+		struct xfs_buf **bpp);
+int xfs_buf_read_async_wait(struct xfs_buf *bp);
 int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
 		struct xfs_buf **bpp);
 int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2af9a1429ae9..afaabd3adc73 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -840,6 +840,9 @@ DEFINE_EVENT(xfs_buf_flags_class, name, \
 	TP_ARGS(bp, flags, caller_ip))
 DEFINE_BUF_FLAGS_EVENT(xfs_buf_get);
 DEFINE_BUF_FLAGS_EVENT(xfs_buf_read);
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_read_async);
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_read_async_wait);
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_read_async_lock);
 DEFINE_BUF_FLAGS_EVENT(xfs_buf_readahead);
 
 TRACE_EVENT(xfs_buf_ioerror,
-- 
2.53.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782788;
	b=JsAp3NMahWJgjcEaS/MDdIIYMmJ8u8vAGjy/TZs9t4FQpgb9PvlZ0sz9HulP7ELZAkWN
	 y7WLNwtQDGdY9AAH/4CCEmsAcL8FwcH4Oi75YpsC6DNEG6VU4x2EV6z4Wq+P9pbprY19r
	 4KeFaD5RTJusTjDwEhM4cRRkIZy4cBhMQmtHaWw5sg/ZpJuCnzrDEL5BHNLVp6v6rMRH8
	 WwLVLDfHcMP7h/O9ras9vN4Xb2PURn0iCXQ88q01e6Khe2IawVik6B3aMc065zw2laMMb
	 Z4esBdssIcg8bWUH1BHwZI+DzxgC2dIv1ErXFlIIvZBKwXZ37tUbBQ/dum/Sf5159nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782788;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=D0VpBrT8bOKK2NgY921q/ZT4BssVSxBUzeG6uXndo5U=;
	b=ApVa7uCHvrKdFNVObfVQKv1QzzxEosBra7TYVTCUvUc2ElsOyOMGvY3ufpNWhGYRz5gS
	 cPHUl0646C4jt8ZP7fcf/TPXCJ2klMTcCacL2jXqc8TYtROl/mYfi3wt9cehyYwJh0H2o
	 Ncje5suY7Yyy7X2L3hnC3dCwmxO5Vpn0VoaVAC4RvGkGB9wzJFas0leiBTCzCJDOLV2Vp
	 cfhRl7B5x7kg66KSgow1UOlQlRinNbEK0BEy57FFN6BleCMW5HcfHW/y1Yl1XM82yiCB1
	 8PwO5t+RH7S8C4tavwwCrzRTXjsgO9UIaJtmDSBL9A8jAu/H+/JC9RzPLhIJwVDuTpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=WEMTL2ZK;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08046606A32D;
	Wed,  4 Nov 2026 08:59:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08046606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=WEMTL2ZK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=D0VpBrT8bOKK2NgY921q/ZT4BssVSxBUzeG6uXndo5U=; b=WEMTL2ZKlepe9fTWk/+AS9N139
	Jcd1CUyJhd+HQHbZSzUZH5kC6Y5v07X3lD18hN6+eclzXkpm5gHuGKJgkBjlly6tr4o4WRxYEYwCu
	3FZieTF8cviH6CuzpOetgbYUd280Bto8dpU/oC27GwnORrJGQt+pX2cM0PM8O4fOQYa8AC3cKWHJS
	TVeODQdnfByoPugwDBIq+ybL9mO7pyYHoatw0+f64rm9/r1KaQY/5SQ3ClnZQ5ZQMvjSxUnYi/8YP
	BZELeb+MTDGlgKDo5ue8j0nYcOsSwV/RbkxONpi7P5HKklWFa+E14za6yssx4KpBR12+nEG1IpmPG
	uwozMYOg==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqR-00000004oLm-1kdW;
	Wed, 04 Nov 2026 08:59:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 05/25] xfs: add a xfs_buf_read_async buffer cache API
Date: Wed,  4 Nov 2026 09:57:09 +0100
Message-ID: <20261104085929.317544-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104085929.317544-1-hch@lst.de>
References: <20261104085929.317544-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a new helper that reads a buffer asynchronously, and one that waits
for this read.  The xfs_buf_read_async call is somehwat similar to
readahead, but returns a buffered reference to the caller and does not
become a no-op under memory or I/O congestion.  This means the callers
can use xfs_buf_read_async_wait instead of doing another read call
and will never issue I/O.

The intended use is to kick off a read of data checksum buffers at
roughly the same time as the data read so that they are available
in the I/O completion handler.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c   | 96 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h   |  4 ++
 fs/xfs/xfs_trace.h |  3 ++
 3 files changed, 103 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6c93b4f5629c..39dd3650b425 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -734,6 +734,102 @@ xfs_buf_read_map(
 	return error;
 }
 
+static int
+xfs_buf_read_async_wait_lock(
+	struct xfs_buf		*bp)
+{
+	int			error = 0;
+
+	trace_xfs_buf_read_async_lock(bp, 0, _RET_IP_);
+
+	/* xfs_buf_find_lock can't return an error with 0 flags */
+	xfs_buf_find_lock(bp, 0);
+	if (bp->b_error) {
+		if (!xlog_is_shutdown(bp->b_mount->m_log))
+			xfs_buf_ioerror_alert(bp, __builtin_return_address(0));
+		xfs_buf_clear_flags(bp, XBF_DONE);
+		xfs_buf_stale(bp);
+		error = bp->b_error;
+		/* bad CRC means corrupted metadata */
+		if (error == -EFSBADCRC)
+			error = -EFSCORRUPTED;
+	} else {
+		ASSERT(bp->b_ops);
+		xfs_buf_clear_flags(bp, XBF_READ);
+	}
+	xfs_buf_unlock(bp);
+	return error;
+}
+
+/*
+ * Wait for a buffer read kicked off by xfs_buf_read_async().
+ *
+ * Do a full lock cycle to wait for unfinished I/O and for buffers with errors
+ * or which are stale.  For successfully read buffers nothing needs to be done.
+ */
+int
+xfs_buf_read_async_wait(
+	struct xfs_buf		*bp)
+{
+	trace_xfs_buf_read_async_wait(bp, 0, _RET_IP_);
+	if (bp->b_error ||
+	    (READ_ONCE(bp->b_flags) & (XBF_DONE | XBF_STALE)) != XBF_DONE)
+		return xfs_buf_read_async_wait_lock(bp);
+	return 0;
+}
+
+/*
+ * Kick off an asynchronous read.  Unlike xfs_buf_readahead, this returns a
+ * reference to the buffer, and reliably reads the data instead of skipping the
+ * read on memory pressure.
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
+
+	/*
+	 * Do a lockless fast path check for a valid uptodate buffer and avoid
+	 * locking entirely in this case.
+	 */
+	if ((READ_ONCE(bp->b_flags) & (XBF_DONE | XBF_STALE)) == XBF_DONE)
+		goto done;
+
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
+}
+
 /*
  *	If we are not low on memory then do the readahead in a deadlock
  *	safe manner.
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
index 28d49f158b22..aca4e7b03052 100644
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


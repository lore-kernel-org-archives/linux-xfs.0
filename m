Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BE92153C7
	for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2025 09:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739784738; cv=none; b=K4KyVnnhCFntdzewufl1Pumr6z1OjksYq/WwHEeT4sY1zEM6YPV7EEJOvkSosU/C6WEgoBPv8vnvdv4z/iUn3ElcTbiFrTbyZJ5G5dDgM+DGM4DtxtVjZ4swxGfrKaSYrZVIXPxJyikj0PXl9Yxa0nPeV5g3TxZKbelMssYig44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739784738; c=relaxed/simple;
	bh=xjq1sBu5c19n/PHoOT2H7qyoC+/YK37PwFOui1ORhOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pH11htDVLWPBn4zUejzqRF0bq5gHBjuLfS2wtsf0ug79/HFcDO3rIjsnGG8oRYek3L4F5skldqUV14N028bnEC2+G89HwLSyzC5kILtfKRyhcDR5cO+uCkVuYJ1Deax5AdkRmSLpFeBCS0uIIF4C0/+pknKEn2IUWmjs36fciuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U3xCdkl+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U3xCdkl+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SYne0Ble0UiMKhn+nlmhAepDbhS+7aWC4sz0ozAWIgg=; b=U3xCdkl+lhfpNOD6yqI4PNXihJ
	wfe9ooaX4o79qZYJN/0WkDKwECyz/XCLeGgub/J+xZgrG8vqJola0SnQ61+nioVBKWnaYr1/Y3L2G
	tT21kQ1R4vbfJ8u0W9NoOVsFhTFE0fpgr7oe8vzY9pN5PVtSZeq3odswaeHaRf8RLfoyX88ynBlYG
	JoUsoxzxog/ZjjCNwv0mTK1oA/QmPJHasC5rIjpAX7YxF41l+Uc03L8UGGUvm+ZmLtZwgb2+d0n0n
	eu3rn5EcQEXY03ytzCZrf7B4GQ6PB5otpeUvRMMRY++xKFPkv5PP9wS51E1/RHs/SScY1jRKY3MJm
	7cS2NkVQ==;
Received: from 2a02-8389-2341-5b80-a8df-74d2-0b85-4db2.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:a8df:74d2:b85:4db2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tjxU6-00000003wHS-3Mxz;
	Mon, 17 Feb 2025 09:32:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: decouple buffer readahead from the normal buffer read path
Date: Mon, 17 Feb 2025 10:31:27 +0100
Message-ID: <20250217093207.3769550-3-hch@lst.de>
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

xfs_buf_readahead_map is the only caller of xfs_buf_read_map and thus
_xfs_buf_read that is not synchronous.  Split it from xfs_buf_read_map
so that the asynchronous path is self-contained and the now purely
synchronous xfs_buf_read_map / _xfs_buf_read implementation can be
simplified.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c         | 41 ++++++++++++++++++++--------------------
 fs/xfs/xfs_buf.h         |  2 +-
 fs/xfs/xfs_log_recover.c |  2 +-
 fs/xfs/xfs_trace.h       |  1 +
 4 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 050f2c2f6a40..52fb85c42e94 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -794,18 +794,13 @@ xfs_buf_get_map(
 
 int
 _xfs_buf_read(
-	struct xfs_buf		*bp,
-	xfs_buf_flags_t		flags)
+	struct xfs_buf		*bp)
 {
-	ASSERT(!(flags & XBF_WRITE));
 	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
 
 	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
-	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
-
+	bp->b_flags |= XBF_READ;
 	xfs_buf_submit(bp);
-	if (flags & XBF_ASYNC)
-		return 0;
 	return xfs_buf_iowait(bp);
 }
 
@@ -857,6 +852,8 @@ xfs_buf_read_map(
 	struct xfs_buf		*bp;
 	int			error;
 
+	ASSERT(!(flags & (XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD)));
+
 	flags |= XBF_READ;
 	*bpp = NULL;
 
@@ -870,21 +867,11 @@ xfs_buf_read_map(
 		/* Initiate the buffer read and wait. */
 		XFS_STATS_INC(target->bt_mount, xb_get_read);
 		bp->b_ops = ops;
-		error = _xfs_buf_read(bp, flags);
-
-		/* Readahead iodone already dropped the buffer, so exit. */
-		if (flags & XBF_ASYNC)
-			return 0;
+		error = _xfs_buf_read(bp);
 	} else {
 		/* Buffer already read; all we need to do is check it. */
 		error = xfs_buf_reverify(bp, ops);
 
-		/* Readahead already finished; drop the buffer and exit. */
-		if (flags & XBF_ASYNC) {
-			xfs_buf_relse(bp);
-			return 0;
-		}
-
 		/* We do not want read in the flags */
 		bp->b_flags &= ~XBF_READ;
 		ASSERT(bp->b_ops != NULL || ops == NULL);
@@ -936,6 +923,7 @@ xfs_buf_readahead_map(
 	int			nmaps,
 	const struct xfs_buf_ops *ops)
 {
+	const xfs_buf_flags_t	flags = XBF_READ | XBF_ASYNC | XBF_READ_AHEAD;
 	struct xfs_buf		*bp;
 
 	/*
@@ -945,9 +933,20 @@ xfs_buf_readahead_map(
 	if (xfs_buftarg_is_mem(target))
 		return;
 
-	xfs_buf_read_map(target, map, nmaps,
-		     XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops,
-		     __this_address);
+	if (xfs_buf_get_map(target, map, nmaps, flags | XBF_TRYLOCK, &bp))
+		return;
+	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
+
+	if (bp->b_flags & XBF_DONE) {
+		xfs_buf_reverify(bp, ops);
+		xfs_buf_relse(bp);
+		return;
+	}
+	XFS_STATS_INC(target->bt_mount, xb_get_read);
+	bp->b_ops = ops;
+	bp->b_flags &= ~(XBF_WRITE | XBF_DONE);
+	bp->b_flags |= flags;
+	xfs_buf_submit(bp);
 }
 
 /*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 3b4ed42e11c0..2e747555ad3f 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -291,7 +291,7 @@ int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
 int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
 		size_t numblks, xfs_buf_flags_t flags, struct xfs_buf **bpp,
 		const struct xfs_buf_ops *ops);
-int _xfs_buf_read(struct xfs_buf *bp, xfs_buf_flags_t flags);
+int _xfs_buf_read(struct xfs_buf *bp);
 void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b3c27dbccce8..2f76531842f8 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3380,7 +3380,7 @@ xlog_do_recover(
 	 */
 	xfs_buf_lock(bp);
 	xfs_buf_hold(bp);
-	error = _xfs_buf_read(bp, XBF_READ);
+	error = _xfs_buf_read(bp);
 	if (error) {
 		if (!xlog_is_shutdown(log)) {
 			xfs_buf_ioerror_alert(bp, __this_address);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b29462363b81..bfc2f1249022 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -593,6 +593,7 @@ DEFINE_EVENT(xfs_buf_flags_class, name, \
 DEFINE_BUF_FLAGS_EVENT(xfs_buf_find);
 DEFINE_BUF_FLAGS_EVENT(xfs_buf_get);
 DEFINE_BUF_FLAGS_EVENT(xfs_buf_read);
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_readahead);
 
 TRACE_EVENT(xfs_buf_ioerror,
 	TP_PROTO(struct xfs_buf *bp, int error, xfs_failaddr_t caller_ip),
-- 
2.45.2


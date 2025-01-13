Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AAD23ED45
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777573; cv=none; b=QHfRIeMJ56Yph2dH1zhwaRQhbZS6O9IWQ1cYle9PM+f2bT6JyKalOn6C11ZuijTLPzOITP7aQrS1/LgVvArOUc8Opu2OwZN2D3vjyuQN1ibLqbiDqxD+37OPmh9AYo3b7TAgAonLcDJnKLj5dYmMeh0TqHgEKXXTtZUKo6kiaVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777573; c=relaxed/simple;
	bh=T/g4P4LQD1hqjpF/xuL67wR4X+4GeUOmHqEmuZTqqmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jX74obFsTqkfSfMDb86OSCYPw8ky1Q/jxtf+EvX7CD2LlISquvleVmFAswsaRlaiSyincOIWGa/3bOe5NFWXXus1JanlkLPoDsuplQYIbEAg0n+J2Ek/LhcAVpx6b8lYRhRgK/0mnA0Yr12KxD1HJv1/HJqrqt5ofRgPk/ftQHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SsxlOHop; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SsxlOHop"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ls0aoGOu14g9oNpKksvagzP4TTG7sHcnHpNNREWkc9w=; b=SsxlOHopJBei0h3pVVKnR55fDy
	LopOKmwrPax67whFZyfFW7rpSJrZArfaF/y2vvFK1w94ySAukLGDYqXEze1arbcbIDUu+LlrnCTGQ
	1MZjsuHkRIaMU9l0hGvio66CSwLXRZK8d6LXMod1babCBcI9A+wQJjVRPT+F9P7TdfSBuYocviLnh
	ua0aBgiApjWsNAynZIX97mWJGvZh0GdO0fCFrGhKeha7cYi2lTxqQD/pcQ93YTw3/mCsMiW0sBBD5
	oPDfqZYSuNlwN1b5bDd2uMwgQncPHBoCtIomxvIa6Cv+DqtxxMtlSU6Gk/yioWyvmrAhua2hSSRXh
	7jqNOp5Q==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBR-00000005MoN-2kcG;
	Mon, 13 Jan 2025 14:12:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/15] xfs: remove xfs_buf_delwri_submit_buffers
Date: Mon, 13 Jan 2025 15:12:10 +0100
Message-ID: <20250113141228.113714-7-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250113141228.113714-1-hch@lst.de>
References: <20250113141228.113714-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_buf_delwri_submit_buffers has two callers for synchronous and
asynchronous writes that share very little logic.  Split out a helper for
the shared per-buffer loop and otherwise open code the submission in the
two callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 121 +++++++++++++++++++++--------------------------
 1 file changed, 55 insertions(+), 66 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index fba494b9b9da..37318201db9a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2252,72 +2252,26 @@ xfs_buf_cmp(
 	return 0;
 }
 
-/*
- * Submit buffers for write. If wait_list is specified, the buffers are
- * submitted using sync I/O and placed on the wait list such that the caller can
- * iowait each buffer. Otherwise async I/O is used and the buffers are released
- * at I/O completion time. In either case, buffers remain locked until I/O
- * completes and the buffer is released from the queue.
- */
-static int
-xfs_buf_delwri_submit_buffers(
-	struct list_head	*buffer_list,
-	struct list_head	*wait_list)
+static bool
+xfs_buf_delwri_submit_prep(
+	struct xfs_buf		*bp)
 {
-	struct xfs_buf		*bp, *n;
-	int			pinned = 0;
-	struct blk_plug		plug;
-
-	list_sort(NULL, buffer_list, xfs_buf_cmp);
-
-	blk_start_plug(&plug);
-	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
-		if (!wait_list) {
-			if (!xfs_buf_trylock(bp))
-				continue;
-			if (xfs_buf_ispinned(bp)) {
-				xfs_buf_unlock(bp);
-				pinned++;
-				continue;
-			}
-		} else {
-			xfs_buf_lock(bp);
-		}
-
-		/*
-		 * Someone else might have written the buffer synchronously or
-		 * marked it stale in the meantime.  In that case only the
-		 * _XBF_DELWRI_Q flag got cleared, and we have to drop the
-		 * reference and remove it from the list here.
-		 */
-		if (!(bp->b_flags & _XBF_DELWRI_Q)) {
-			xfs_buf_list_del(bp);
-			xfs_buf_relse(bp);
-			continue;
-		}
-
-		trace_xfs_buf_delwri_split(bp, _RET_IP_);
-
-		/*
-		 * If we have a wait list, each buffer (and associated delwri
-		 * queue reference) transfers to it and is submitted
-		 * synchronously. Otherwise, drop the buffer from the delwri
-		 * queue and submit async.
-		 */
-		bp->b_flags &= ~_XBF_DELWRI_Q;
-		bp->b_flags |= XBF_WRITE;
-		if (wait_list) {
-			bp->b_flags &= ~XBF_ASYNC;
-			list_move_tail(&bp->b_list, wait_list);
-		} else {
-			bp->b_flags |= XBF_ASYNC;
-			xfs_buf_list_del(bp);
-		}
-		xfs_buf_submit(bp);
+	/*
+	 * Someone else might have written the buffer synchronously or marked it
+	 * stale in the meantime.  In that case only the _XBF_DELWRI_Q flag got
+	 * cleared, and we have to drop the reference and remove it from the
+	 * list here.
+	 */
+	if (!(bp->b_flags & _XBF_DELWRI_Q)) {
+		xfs_buf_list_del(bp);
+		xfs_buf_relse(bp);
+		return false;
 	}
-	blk_finish_plug(&plug);
 
-	return pinned;
+	trace_xfs_buf_delwri_split(bp, _RET_IP_);
+	bp->b_flags &= ~_XBF_DELWRI_Q;
+	bp->b_flags |= XBF_WRITE;
+	return true;
 }
 
 /*
@@ -2340,7 +2294,30 @@ int
 xfs_buf_delwri_submit_nowait(
 	struct list_head	*buffer_list)
 {
-	return xfs_buf_delwri_submit_buffers(buffer_list, NULL);
+	struct xfs_buf		*bp, *n;
+	int			pinned = 0;
+	struct blk_plug		plug;
+
+	list_sort(NULL, buffer_list, xfs_buf_cmp);
+
+	blk_start_plug(&plug);
+	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
+		if (!xfs_buf_trylock(bp))
+			continue;
+		if (xfs_buf_ispinned(bp)) {
+			xfs_buf_unlock(bp);
+			pinned++;
+			continue;
+		}
+		if (!xfs_buf_delwri_submit_prep(bp))
+			continue;
+		bp->b_flags |= XBF_ASYNC;
+		xfs_buf_list_del(bp);
+		xfs_buf_submit(bp);
+	}
+	blk_finish_plug(&plug);
+
+	return pinned;
 }
 
 /*
@@ -2357,9 +2334,21 @@ xfs_buf_delwri_submit(
 {
 	LIST_HEAD		(wait_list);
 	int			error = 0, error2;
-	struct xfs_buf		*bp;
+	struct xfs_buf		*bp, *n;
+	struct blk_plug		plug;
 
-	xfs_buf_delwri_submit_buffers(buffer_list, &wait_list);
+	list_sort(NULL, buffer_list, xfs_buf_cmp);
+
+	blk_start_plug(&plug);
+	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
+		xfs_buf_lock(bp);
+		if (!xfs_buf_delwri_submit_prep(bp))
+			continue;
+		bp->b_flags &= ~XBF_ASYNC;
+		list_move_tail(&bp->b_list, &wait_list);
+		xfs_buf_submit(bp);
+	}
+	blk_finish_plug(&plug);
 
 	/* Wait for IO to complete. */
 	while (!list_empty(&wait_list)) {
-- 
2.45.2


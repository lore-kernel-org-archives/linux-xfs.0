Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A6D1D9A76
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157387; cv=none; b=lkuAzg8i5bPj2E9FdAL79MEF/DIUkGSA9PGiVy3YTbLW5a68Z4pGG8Y1eW6U2ZUjkoJYcGoqOlPGPZfbsHwzDO1jytQ5DBk4cGV+wYGBIXGKDd8MPvolynb19h4pxYISkqgEbDJTs7PVW7Yl2JwOwG6Cj+CXGScobjfYuPm/vY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157387; c=relaxed/simple;
	bh=JrUBo9a6mBR+tKirfp5tcmayFMnc5u9f1E0w4bUFpyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1sBkMLnnuehYGYOktlIf3iAt/tFA7+JAaXqaSqwotxXF1tOjQsXJQxa/gurcfpyaKr9VuSL4wVpLyRKuOwcTG/VlxVDPz6ZZzUQ3BQa4yz9XEks9SGCVWiJvehmmTgOtLNeyfAKE0AoCxAN035ueogqCxKrqu4TpSSop54e8uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p3pAJ0kV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p3pAJ0kV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NxcOHm43DeJPslqKfTjnUgd1bI3ReiNefOYdj4l4oa8=; b=p3pAJ0kVloqZM8c7vfny/mILLt
	+cmybZzJZGIj+OpgfXXFZHZW2PRG4NDxlkDCE14mqyakO+/sJQUuTby/p221Nzg56j2f2CaqirxC+
	7g2gMvYvzxJHlBFVby4J4XGgF0XJKCZTlKzTY4SQ5WOSiLlXeTSCPK4myYreeDECgIQhjnlmMUslT
	hvakcGweMz/cmG2SMdzAK7QSQuMIdLml973szdmu15jXbT0LRlBB9xbe55FdAHbbu3zAPCLxzfpyB
	+IQ+qzt+EZQ7TYYqGHUIAnEoEIuCnaM6O8UGzBZfSeUXbkFaeX3bSmP7vACfYEWgLiA9FMJbePCmT
	0C69gjgg==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjqS-00000000lEj-2Yl0;
	Mon, 06 Jan 2025 09:56:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/15] xfs: move xfs_buf_iowait out of (__)xfs_buf_submit
Date: Mon,  6 Jan 2025 10:54:41 +0100
Message-ID: <20250106095613.847700-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106095613.847700-1-hch@lst.de>
References: <20250106095613.847700-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There is no good reason to pass a bool argument to wait for a buffer when
the callers that want that can easily just wait themselves.

This means the wait moves out of the extra hold of the buffer, but as the
callers of synchronous buffer I/O need to hold a reference anyway that is
perfectly fine.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1927655fed13..a3484421a6d8 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -52,14 +52,8 @@ struct kmem_cache *xfs_buf_cache;
  *	  b_lock (trylock due to inversion)
  */
 
-static int __xfs_buf_submit(struct xfs_buf *bp, bool wait);
-
-static inline int
-xfs_buf_submit(
-	struct xfs_buf		*bp)
-{
-	return __xfs_buf_submit(bp, !(bp->b_flags & XBF_ASYNC));
-}
+static int xfs_buf_submit(struct xfs_buf *bp);
+static int xfs_buf_iowait(struct xfs_buf *bp);
 
 static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
 {
@@ -797,13 +791,18 @@ _xfs_buf_read(
 	struct xfs_buf		*bp,
 	xfs_buf_flags_t		flags)
 {
+	int			error;
+
 	ASSERT(!(flags & XBF_WRITE));
 	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
 
 	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
 	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
 
-	return xfs_buf_submit(bp);
+	error = xfs_buf_submit(bp);
+	if (!error && !(flags & XBF_ASYNC))
+		error = xfs_buf_iowait(bp);
+	return error;
 }
 
 /*
@@ -978,9 +977,10 @@ xfs_buf_read_uncached(
 	bp->b_flags |= XBF_READ;
 	bp->b_ops = ops;
 
-	xfs_buf_submit(bp);
-	if (bp->b_error) {
-		error = bp->b_error;
+	error = xfs_buf_submit(bp);
+	if (!error)
+		error = xfs_buf_iowait(bp);
+	if (error) {
 		xfs_buf_relse(bp);
 		return error;
 	}
@@ -1483,6 +1483,8 @@ xfs_bwrite(
 			 XBF_DONE);
 
 	error = xfs_buf_submit(bp);
+	if (!error)
+		error = xfs_buf_iowait(bp);
 	if (error)
 		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
 	return error;
@@ -1698,9 +1700,8 @@ xfs_buf_iowait(
  * holds an additional reference itself.
  */
 static int
-__xfs_buf_submit(
-	struct xfs_buf	*bp,
-	bool		wait)
+xfs_buf_submit(
+	struct xfs_buf	*bp)
 {
 	int		error = 0;
 
@@ -1764,9 +1765,6 @@ __xfs_buf_submit(
 			xfs_buf_ioend_async(bp);
 	}
 
-	if (wait)
-		error = xfs_buf_iowait(bp);
-
 	/*
 	 * Release the hold that keeps the buffer referenced for the entire
 	 * I/O. Note that if the buffer is async, it is not safe to reference
@@ -2322,7 +2320,7 @@ xfs_buf_delwri_submit_buffers(
 			bp->b_flags |= XBF_ASYNC;
 			xfs_buf_list_del(bp);
 		}
-		__xfs_buf_submit(bp, false);
+		xfs_buf_submit(bp);
 	}
 	blk_finish_plug(&plug);
 
-- 
2.45.2


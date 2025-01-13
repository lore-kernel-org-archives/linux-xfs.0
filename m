Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7677623ED5F
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777564; cv=none; b=heKEZDVCISxLgr+e1sC7gP3k0NzsrZ12kFLVeJY1LDTSlpiu/rp1t3WbjeButZ58/I0ofJY8eDWv/dC7K5LecfSYolQa+adPRLYsWIWaqXP0Z+nkA0kuROyFvGiKiXlxEbKhKdXFFHdFSb9DqUMOxc2OkX+YQNORvaBdmyqSwMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777564; c=relaxed/simple;
	bh=pmLrDwM+oY5oRq7woXM0AAS5jH28kkGV2rYRAriwoSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nq6pEwpuColK0dVPnTX5gxL9qhmd15W/McBJoDvTV8ql3dPQSidIfnrRRDF7f3ogG9iq5ZtSG8ixbVZvKTWhCsL4ore1bH0wnAeeqSKv6qFIWIZUqlQ33YdX1/SgPj++58XHh9ORQMAhyqrmWUhUs/jhV9eJRjBT6jM0BI2tnpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ot59VUjW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ot59VUjW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=khXZpybwAdgoUQ0ZB92FiFipLGpdUZ0C6jzoM4Brgxs=; b=Ot59VUjW3TDRmFp4PfS/pKFxyK
	X2RSSEqUmwm0TuxiGZ3Dk3dlpUvZzfoKOaPnHG3MHm6mlTCqDy3WZWiNXeJMW4v7T5MnBQ46nt9q2
	f2GanpZTRzt8C6m/iqPYd6ohcY1S8OCZhgAbkQt044ASWqikbSzs4fM9d1tSGG/dKJY50psIxnNqe
	8Xi9yJnhmDjT8o8lN0ODJ9GCuWr9ciJg0rARboPGwv/q0tkFpNHqrUcxa1FqVK2fyMGSPsoSDhMpF
	0Zb/f+QcvpUXiPbn4ROqMID/+r0A2J2USh4dQaZGoxSrfvjaYjc/LEHmOd4hJ9FdccqiSNaPzooWm
	2R/mjf8Q==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBK-00000005Mmi-23Jd;
	Mon, 13 Jan 2025 14:12:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/15] xfs: move xfs_buf_iowait out of (__)xfs_buf_submit
Date: Mon, 13 Jan 2025 15:12:08 +0100
Message-ID: <20250113141228.113714-5-hch@lst.de>
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

There is no good reason to pass a bool argument to wait for a buffer when
the callers that want that can easily just wait themselves.

This means the wait moves out of the extra hold of the buffer, but as the
callers of synchronous buffer I/O need to hold a reference anyway that is
perfectly fine.

Because all async buffer submitters ignore the error return value, and
the synchronous ones catch the error condition through b_error and
xfs_buf_iowait this also means the new xfs_buf_submit doesn't have to
return an error code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 5702cad9ccc9..5abada2b4a4a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -53,14 +53,8 @@ struct kmem_cache *xfs_buf_cache;
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
+static void xfs_buf_submit(struct xfs_buf *bp);
+static int xfs_buf_iowait(struct xfs_buf *bp);
 
 static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
 {
@@ -804,7 +798,10 @@ _xfs_buf_read(
 	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
 	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
 
-	return xfs_buf_submit(bp);
+	xfs_buf_submit(bp);
+	if (flags & XBF_ASYNC)
+		return 0;
+	return xfs_buf_iowait(bp);
 }
 
 /*
@@ -980,8 +977,8 @@ xfs_buf_read_uncached(
 	bp->b_ops = ops;
 
 	xfs_buf_submit(bp);
-	if (bp->b_error) {
-		error = bp->b_error;
+	error = xfs_buf_iowait(bp);
+	if (error) {
 		xfs_buf_relse(bp);
 		return error;
 	}
@@ -1483,7 +1480,8 @@ xfs_bwrite(
 	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
 			 XBF_DONE);
 
-	error = xfs_buf_submit(bp);
+	xfs_buf_submit(bp);
+	error = xfs_buf_iowait(bp);
 	if (error)
 		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
 	return error;
@@ -1698,13 +1696,10 @@ xfs_buf_iowait(
  * safe to reference the buffer after a call to this function unless the caller
  * holds an additional reference itself.
  */
-static int
-__xfs_buf_submit(
-	struct xfs_buf	*bp,
-	bool		wait)
+static void
+xfs_buf_submit(
+	struct xfs_buf	*bp)
 {
-	int		error = 0;
-
 	trace_xfs_buf_submit(bp, _RET_IP_);
 
 	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
@@ -1724,10 +1719,9 @@ __xfs_buf_submit(
 	 * state here rather than mount state to avoid corrupting the log tail
 	 * on shutdown.
 	 */
-	if (bp->b_mount->m_log &&
-	    xlog_is_shutdown(bp->b_mount->m_log)) {
+	if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log)) {
 		xfs_buf_ioend_fail(bp);
-		return -EIO;
+		return;
 	}
 
 	/*
@@ -1765,16 +1759,12 @@ __xfs_buf_submit(
 			xfs_buf_ioend_async(bp);
 	}
 
-	if (wait)
-		error = xfs_buf_iowait(bp);
-
 	/*
 	 * Release the hold that keeps the buffer referenced for the entire
 	 * I/O. Note that if the buffer is async, it is not safe to reference
 	 * after this release.
 	 */
 	xfs_buf_rele(bp);
-	return error;
 }
 
 void *
@@ -2323,7 +2313,7 @@ xfs_buf_delwri_submit_buffers(
 			bp->b_flags |= XBF_ASYNC;
 			xfs_buf_list_del(bp);
 		}
-		__xfs_buf_submit(bp, false);
+		xfs_buf_submit(bp);
 	}
 	blk_finish_plug(&plug);
 
-- 
2.45.2


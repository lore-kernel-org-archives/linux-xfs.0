Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D5136F434
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 07:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782113451; cv=none; b=Ajo8gY9Vl67UP2pm81JWA30sgviv3KzCvufJdA35Zj3FijvfJVTkzZnEmX8fOYEA0bAM2Qq7XuXnu/h/4TrV9SjywIHYdjSZee5F+2ESwxrn1TeUuiZMDo+X4dXSDTOt6y/xWtMQq1b7avXz4pGxv3B96bgGY16akfXvySyptMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782113451; c=relaxed/simple;
	bh=pGoEwq6TqT8wPKK2Vwzd8jbw3q6q5h8cBOd38+KXWbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YV0KQnoB6BQ5/9zICWvvVHDRwu81BU+FL+tc2g4JKV9w6oM/0GYbXAflHBxGbf3J8gKRDd1B5xndpP+jcYZbqNpLK60vs0x3zwkQ6nl7i/AerTHWt9l5T+O5hdZ/+xLYmnMwuqci//SYer29BoDkCew+OHBh2540OWdfKArnGeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sBJlIPvW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sBJlIPvW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=reW4VhAPB9zTgSy982kuDBhepty3iTHy5QgJ6ZGhMAI=; b=sBJlIPvWaIH8OmTLgLr+As3zpK
	GO6WDwvxCSTrxJdrXod1YezmOKV4W3ej5vVx+7z0FrUgnHcG/JKf3MXS4QdBF/3k4RVcYchuFsOKV
	Mm7c5kJbMl/HlAbuAaVZabXLcQiglNBp8ThRVYrwur9Mw9NKvFfQ7fXHqV+4nMfd2s/vRTfd2Oki/
	gV7y1ygvHfwNLTJNkoeHyPOt6HIJS2N5JaxZzxXaSTcwUo/M+zp8khj9QwKZ85rldJJThclg1IJNT
	1ZBT/bVsa2u/YoP6AzE+tjyH5DDk1C/F1CFuD96BjKPXd93AqKWjyTq0m5mSi++9Yisi8k2EYvc3O
	L9Dk4DOw==;
Received: from 85-127-105-127.dsl.dynamic.surfer.at ([85.127.105.127] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wbZ7J-00000004XeX-0Qxo;
	Mon, 22 Jun 2026 07:30:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] xfs: improve the xfs_buf_ioend_fail calling convention
Date: Mon, 22 Jun 2026 09:30:02 +0200
Message-ID: <20260622073035.1370904-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260622073035.1370904-1-hch@lst.de>
References: <20260622073035.1370904-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move setting the ASYNC flag into xfs_buf_ioend_fail_async, assert that
the buffer is locked as expected, and drop the confusing _ioend in the
name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c      | 13 +++++++------
 fs/xfs/xfs_buf.h      |  2 +-
 fs/xfs/xfs_buf_item.c |  3 +--
 fs/xfs/xfs_inode.c    |  3 +--
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 60ef53acebd2..ef2ea15a97bb 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1192,17 +1192,18 @@ xfs_buf_ioerror_alert(
 }
 
 /*
- * To simulate an I/O failure, the buffer must be locked and held with at least
- * two references.
+ * Fail a locked and referenced buffer outside the I/O path.
  *
- * The buf item reference is dropped via ioend processing. The second reference
- * is owned by the caller and is dropped on I/O completion if the buffer is
- * XBF_ASYNC.
+ * The caller transfers a reference which will be released after processing the
+ * error.
  */
 void
-xfs_buf_ioend_fail(
+xfs_buf_fail(
 	struct xfs_buf	*bp)
 {
+	ASSERT(xfs_buf_islocked(bp));
+
+	bp->b_flags |= XBF_ASYNC;
 	bp->b_flags &= ~XBF_DONE;
 	xfs_buf_stale(bp);
 	xfs_buf_ioerror(bp, -EIO);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index bf39d89f0f6d..690002d3dd2b 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -290,7 +290,7 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
 		xfs_failaddr_t failaddr);
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
 extern void xfs_buf_ioerror_alert(struct xfs_buf *bp, xfs_failaddr_t fa);
-void xfs_buf_ioend_fail(struct xfs_buf *);
+void xfs_buf_fail(struct xfs_buf *bp);
 void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 8487635579e5..1f055cd6732e 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -549,8 +549,7 @@ xfs_buf_item_unpin(
 		 * wait for the lock and then run the IO failure completion.
 		 */
 		xfs_buf_lock(bp);
-		bp->b_flags |= XBF_ASYNC;
-		xfs_buf_ioend_fail(bp);
+		xfs_buf_fail(bp);
 		return;
 	}
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9978ac1422fc..15facb0631d1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2634,8 +2634,7 @@ xfs_iflush_cluster(
 		 * inode cluster buffers.
 		 */
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		bp->b_flags |= XBF_ASYNC;
-		xfs_buf_ioend_fail(bp);
+		xfs_buf_fail(bp);
 		return error;
 	}
 
-- 
2.53.0


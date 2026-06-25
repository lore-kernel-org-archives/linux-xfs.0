Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F85F34A794
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 13:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782395942; cv=none; b=GtaRJBoGeXD3fxVC5aTNxl8Yu4dMbMLVpMKoltnh2LrftANUdO1REYMQEIO5zVcJictwY37eTNh3y6o5Pn0paQvf2TzvG8POkPFaFmrzcX0KukV+cfoSBwPjn5HmfCqG/iUJJDXbnJe9RZaR2RbYKBryAYXet0NNNjiK/5cpQow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782395942; c=relaxed/simple;
	bh=DMwlVrl+tfM3WbbvDRLn+dJYp5HZqnfDhsQZi8A28mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqJaOC+PTFBXxb45GbQqnd8dNvDGKPh4qaoPPSljB/SNfsfdY/CMPdTUg3jmWdVFwwa4i4+mn7Zuo532+38fOfmGfmTw+hGtIPK8Aw+4XTcq+NsVsVfZ03m2wNqIAVC5/Sr7OOuGnstSWAPudBjaCMINoV/bVlbyk0zT/zjQtH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z4vRt7hP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z4vRt7hP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=I74Won7EjXMs+rYZK3O0O6923+eMWZeCBf9TlmY8qt0=; b=Z4vRt7hP1DazuomfsekdPv/ok4
	Tt7Pu3oxwwvig5OT/E6JNlSnuA1DbkxAsub6KFoZiKCNexO5ATckHkdik3ZK4fhJKtN7LGHNsAHoI
	x3WqNM+xla743hKquZqD4QKc7UnkhrhMuJaxPAs06QVgYRERc1HGZi1Tx71KHd/1n2k24Rxw6iDji
	d3ixxMEDkEBKlDUkiFV21G+4xS5nOmvDsLuxldyHerKHfgnIpUrfppmPOM6bS6DavngpT0dBF0667
	8LdtjJeyZBKpNQlkAwMQ0fPetStHDrgiHvhF/KP+VN1Lz7dwQxaUOGcitt7KQoQ3iAay3MFDNjgyG
	DtlxZE/Q==;
Received: from 2a02-8389-2301-9f00-3397-c9eb-6d8a-9179.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:3397:c9eb:6d8a:9179] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wckbc-00000009Gry-3RwW;
	Thu, 25 Jun 2026 13:59:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 3/6] xfs: improve the xfs_buf_ioend_fail calling convention
Date: Thu, 25 Jun 2026 15:58:33 +0200
Message-ID: <20260625135849.2494779-4-hch@lst.de>
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

Move setting the ASYNC flag into xfs_buf_ioend_fail, assert that the
buffer is locked as expected, and drop the confusing _ioend in the
name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf.c      | 13 +++++++------
 fs/xfs/xfs_buf.h      |  2 +-
 fs/xfs/xfs_buf_item.c |  3 +--
 fs/xfs/xfs_inode.c    |  3 +--
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 5ce48d8062fa..83c74b5b7e8e 100644
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
index b3cd1c7029f1..79cc9c3f0254 100644
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
index 317eb57f989f..15279d22a894 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2646,8 +2646,7 @@ xfs_iflush_cluster(
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


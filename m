Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE27C33C502
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 13:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782395940; cv=none; b=LqOCzpNMTaoH3K1BQg69Z2QAuOvqckI/bzfzpgCot+Oq3oPheZNjDNmQGh2cltpIG5+v7MFDMNfICJ2PxqUFOa9nCieImmyT2H0qTKEt7KWbIlgECYe2XATdmlb7zO8CbBhOS3ekjNNCSp5OMLHxfMk4tS2tbAbTuRzFjAi+0So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782395940; c=relaxed/simple;
	bh=Q0pKJsSgtvIrgSNh7hz0BuYNKnDhNxiWyo56GtEmcHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ht68h11iQbuMeUNxG5CxErVpeRKoZVuMdcGa0U783I03ojSqCVu2echhzPNCMwzwPmevhaOxI7nZ9bP/woLe7jhFVXaoK6Zu9tebEeU5fVP0WgSIovaodR5TU5YmAhLMFtxM44mo+qWzlcyNQBL9vHesvbxcu4UGDbB9BmpYyyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ro+TFY8U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ro+TFY8U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CkQRzuKvNhWP9xUFrj0H+BSltqluPNyUopf25Ps/xbQ=; b=ro+TFY8UsaIq0iX0FW+xYJaDmY
	L6mzZmnTBdVSzynvPIrM5m0CiiTCrtRbc4jj+W84czURkUz7YTNRXZ0RTcMYOkqgmRJbVBwWKsGi4
	zRH0reODcxkhDQiLL/xw56pDeDhiiEVzXVVxKT0KPxa9OJDxdJqH/fYU2JUWrztabPs2HBFO+wv86
	Y9Ip7rZLMDv59txr9F5CgZE0TVo64FYWuWzuIfeAuLrbhpWVisrr4leX4Gqjttqt9mJEvknpaJHUo
	ixaNmKxZ8Zbfpv0v8+7mrhog4i2fxbPiyL24httiwuhVAuRUr7hsNg1WcVGuG7gq3f5wcpKz5jx/j
	GHrABCDw==;
Received: from 2a02-8389-2301-9f00-3397-c9eb-6d8a-9179.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:3397:c9eb:6d8a:9179] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wckba-00000009GrT-0DtX;
	Thu, 25 Jun 2026 13:58:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/6] xfs: also mark the buffer stale on verifier failure in xfs_buf_submit
Date: Thu, 25 Jun 2026 15:58:32 +0200
Message-ID: <20260625135849.2494779-3-hch@lst.de>
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

We should treat the buffer that caused a shutdown the same as handling
buffers after a shutdown, so use the same stale && !DONE logic here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a108d31996f2..5ce48d8062fa 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1383,8 +1383,10 @@ xfs_buf_submit(
 	 * state here rather than mount state to avoid corrupting the log tail
 	 * on shutdown.
 	 */
-	if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log))
+	if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log)) {
+		xfs_buf_ioerror(bp, -EIO);
 		goto ioerror;
+	}
 
 	if (bp->b_flags & XBF_WRITE)
 		xfs_buf_wait_unpin(bp);
@@ -1397,7 +1399,7 @@ xfs_buf_submit(
 
 	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
 		xfs_force_shutdown(bp->b_mount, SHUTDOWN_CORRUPT_INCORE);
-		goto end_io;
+		goto ioerror;
 	}
 
 	/* In-memory targets are directly mapped, no I/O required. */
@@ -1410,7 +1412,6 @@ xfs_buf_submit(
 ioerror:
 	bp->b_flags &= ~XBF_DONE;
 	xfs_buf_stale(bp);
-	xfs_buf_ioerror(bp, -EIO);
 end_io:
 	xfs_buf_ioend(bp);
 }
-- 
2.53.0


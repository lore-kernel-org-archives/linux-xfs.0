Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2EE348477
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 13:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782395938; cv=none; b=PPmyfInbH7KRPToogeDxFdKYV8xPotjtGPTssWiVSQg2PCKv91kLluE7hE43PYhCa5wzY7Fv/sU1yvD7dvPn7CsvJ/In5QLcOQqmE3Poj6Et/lvtFOPvaiet6qsyFKpaCYpLFQ6fg/WKDGxlC7g7nXq0ARIWQB8UKcIMQyKCXYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782395938; c=relaxed/simple;
	bh=nOZrLYtndPM+Ny06LXeW6VGMoprF8BZ8Lx1NctrqIcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A828ka9gKt6kBFy++7MEL89o6qiwNzMRqq7ohV2yA+OT8ZihY0Jrquaa3DqHnZfnN9XXL9ywCCpPuL5VWOAIlWdXUgvU+ok1obXdevQZfpr29V55YQ31Zn2COuG+AMcPKDdenU7tuoB5S2NAd6amNw3TEl479Uv0PUp7LtiUIRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gK80/6kC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gK80/6kC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9L+ZqJE17ZFwEqqd7S3BaQMkEDokhhIARybxCLV6VsA=; b=gK80/6kCvJBcJCM8IX60+1KOYw
	8zGyaIzhls+PjTNDJIbSf7AGKTBeMJo6MFVOy7k51w8Ha5gKeHC6Z+suebVw4bvTsdTIfftDJp585
	Ls+gRsQvKH4DD+G8YK8AwQPc3AqFUWs3VAtW+gw8fNCtWMd9tBXTCdZMvWAmtQV7IboSwruF1fcrz
	7QjJipZHVmV4yNTRiNG7bgyiSoCxfjawIbBswtcqq/tfiNVaKeC0WHw8WGtIGnQ2khM9ygL68AUQ7
	bmstCtygHdoIN1PaM38keB0V6kLdn+pyysBipVqK4A0Y/ar3j81f4oOdZpXT4Jn2hrDNAO6tWzlU4
	6sVfMJew==;
Received: from 2a02-8389-2301-9f00-3397-c9eb-6d8a-9179.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:3397:c9eb:6d8a:9179] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wckbX-00000009Gqh-15ne;
	Thu, 25 Jun 2026 13:58:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/6] xfs: open code xfs_buf_ioend_fail in xfs_buf_submit
Date: Thu, 25 Jun 2026 15:58:31 +0200
Message-ID: <20260625135849.2494779-2-hch@lst.de>
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

This better integrates with the other failure handling in xfs_buf_submit,
and prepares for a better API in xfs_buf_ioend_fail.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2a7d696d394a..a108d31996f2 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1383,10 +1383,8 @@ xfs_buf_submit(
 	 * state here rather than mount state to avoid corrupting the log tail
 	 * on shutdown.
 	 */
-	if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log)) {
-		xfs_buf_ioend_fail(bp);
-		return;
-	}
+	if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log))
+		goto ioerror;
 
 	if (bp->b_flags & XBF_WRITE)
 		xfs_buf_wait_unpin(bp);
@@ -1399,17 +1397,22 @@ xfs_buf_submit(
 
 	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
 		xfs_force_shutdown(bp->b_mount, SHUTDOWN_CORRUPT_INCORE);
-		xfs_buf_ioend(bp);
-		return;
+		goto end_io;
 	}
 
 	/* In-memory targets are directly mapped, no I/O required. */
-	if (xfs_buftarg_is_mem(bp->b_target)) {
-		xfs_buf_ioend(bp);
-		return;
-	}
+	if (xfs_buftarg_is_mem(bp->b_target))
+		goto end_io;
 
 	xfs_buf_submit_bio(bp);
+	return;
+
+ioerror:
+	bp->b_flags &= ~XBF_DONE;
+	xfs_buf_stale(bp);
+	xfs_buf_ioerror(bp, -EIO);
+end_io:
+	xfs_buf_ioend(bp);
 }
 
 /*
-- 
2.53.0


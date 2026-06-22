Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8037A36F418
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 07:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782113452; cv=none; b=uFwgYtq8SLBpe4kWOdiaCxG6U2IdRbm1l6lyd1IVzZ8tbgk/ccpLvGTBAh2vntwWPaoBJvUuUzbBmAWmcj2E4SjF06YOVfueVdXMv0tDpFWcGEd/NEuZy/NLNJpDwN2sWWv4N5HXuzqd9qToj5dUUtgJRrEp6JqbKR8U7FEUf2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782113452; c=relaxed/simple;
	bh=0iaBu6GuIHNQFtoCZpgxzSQ9rALzwRzgnMoljxgpyUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fo5q+dE8D7BtTYfU/OVoLtPpYfy7pymB3EvfDPxKsLKyWO3Viqw/6LnPVqEKiTBimpm/xB1qd31Mm1d1FcNeRghAeR8Qap2ft2zHFHOjtI4WrsWbp93clcSbqQOdHTYgvVPGJ0jzSfOsHTDGxt+qIV3SW2Z/7fPI1cPJyjVuMdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=274Fpwaq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="274Fpwaq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sHvJJlyRi5wjXMDRF9oNiAPsHOE6FQEZjVcZHluuJu4=; b=274FpwaqDNTMK/mNdZJSyQndJI
	c389My/UxIM+XJrLcxLtIQwnYk12D+8NJWxwI6SotKhy5hIc5Fa24Cpk1xCWjEOEV9MgOd7aBN/6h
	0UkkYS0pUNH0Z4XLVzNAFR4FUQBy1VwFLxUjwiCS5+chFSAOivseUGu8tPcw+X+ZXety72Rs485VT
	cJzgnSOYtLQ/uKvDyT6zd35vOcnWeDRtCz/+5pnN62i7ToWd/2z80B3MWZPJDYV4M0nq1/RadZpSz
	e9iwk9Bvo9q0j1SdxUVIunS+u0L5tN2NX3zejT9YtAI/zmf0rh1yiYPSRWaoy4yDoS0iQYVTSL4Jd
	r9eGHqLg==;
Received: from 85-127-105-127.dsl.dynamic.surfer.at ([85.127.105.127] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wbZ7C-00000004XeM-3D6k;
	Mon, 22 Jun 2026 07:30:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] xfs: open code xfs_buf_ioend_fail in xfs_buf_submit
Date: Mon, 22 Jun 2026 09:30:00 +0200
Message-ID: <20260622073035.1370904-2-hch@lst.de>
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

This better integrates with the other failure handling in xfs_buf_submit,
and prepares for a better API in xfs_buf_ioend_fail.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1ed9f01b3275..9aaa8b87fc33 100644
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


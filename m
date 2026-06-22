Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEE936EA8B
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 07:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782113452; cv=none; b=cbd21SihRhP0kcTtvVkserTGVsQLAXSJgSMsVlmgdY2L7JHM92ww38rEpQHMev9C561Hq1gI8F9M9kkcvH3URsFbEB6Ss98JoDN+IjoHQa2xyorFas/TOGw6bzOVyT6yBTjFyg8g6sHUf56EQU1f5y0KB4jqESXn50lsrsZPeNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782113452; c=relaxed/simple;
	bh=JKCgRvpcLSIz8SvRzo4duXhzwNdp66eb+OkeiVR/PlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yl9qH8E+IMbEUv8l66RB9uzdWx+PqSV5G8hM/PI8Fe2Q7JVjU4aQ9RUBCyUsB/MjbgRCJZDKL4XirL9S9hBSfM05I49IozZ85w/R4RRIuA2w+F4XRSHhvJI/qF1Dw3uRPlDy6LhwQ4xus136LJxrKjL3NFRiAjWl9vJeFa4GUE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ccwDn9P+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ccwDn9P+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=19eLRY1J4qf8KOyZ7/VtPYgs81C8tZ3KOE2p2A57GJw=; b=ccwDn9P+BSYnWQIB4X4B4Js+2B
	LG+CMJTH6C3Plh3MraP6UXacjQAMX+mib6SL2DS4rRVCXGZ0FzM1z1BDxdra+Pvz/lfmtPZfsJSpv
	jAUYAp7XuyZ11sRRP5Lx9rbZR+BtQFxxRyvy89oBL01r+928DmvAW5bjb1kpxtr6g9eW1zLQUV7TE
	WKkwWWbUwkfDXDJNWgLxxKh04d1f8fyQtl+CUkV5s3SjagKYvM6OT7KFQbBtU7dAWhqWCvQNG1tUy
	iCQFvivGFm7UmrYnZtTXga/OHIYCcd+s5Tjlkdrr0Chy5Qs0h+xKejrrb3bbrvjX9b+tq7Nonobtv
	qWWw2qjA==;
Received: from 85-127-105-127.dsl.dynamic.surfer.at ([85.127.105.127] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wbZ7F-00000004XeR-2eDp;
	Mon, 22 Jun 2026 07:30:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] xfs: also mark the buffer stale on verifier failure in xfs_buf_submit
Date: Mon, 22 Jun 2026 09:30:01 +0200
Message-ID: <20260622073035.1370904-3-hch@lst.de>
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

We should treat the buffer that caused a shutdown the same as handling
buffers after a shutdown, so use the same stale && !DONE logic here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9aaa8b87fc33..60ef53acebd2 100644
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


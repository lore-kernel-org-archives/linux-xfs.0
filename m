Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BB823ED51
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777591; cv=none; b=sI0s4Ump80hZoePVKMi7cBcFUxnR1fJt1JSR2sneX+s6xdA8fhWsQIn3aaqzZfuzIzFHCkh88TC2xI2p5+LHAgHHklGbIYjspJLM99YNebu8MNOQIAA6esjbw9U1QClRtBW9/hoQofc8m9huc2WGsEIts6Qkc8Ki0sgN04xcRnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777591; c=relaxed/simple;
	bh=pIlhu2l4TZN0vMDEl/PLmNJD8vYnzJG1KOU33l+gY/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MR+SYiU/JaqRqjvJvHkaTa8ysPI067/CtESZRM5RRevsLol+F4Wvsdz4nASI24BrVHf7vko/LYgFoppASq/FdNX7WA4hdLJlThrDmUzSFbDng9Dnmd6oqQERW9V8yfOK3783yx6hBn8kokCycu+AfQeHgwVHbpoMvRj1K7xAooI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aWhhvQE1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aWhhvQE1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JeByo31mrMIclgJ/diyaH8CU9+TYy5QW3L40sVB+0D8=; b=aWhhvQE1iz36eLJzx/uCJM0TXv
	5coURuWkp2+/FOaX7o0QVtjvlg9QeqJWDfyYv+rgB+0WjXiGrXlVRJz0FDko9vjgnbaQevo1llxqz
	Ev4t68XhRwgGgp72ZX993U0yA14vbqBfyeN41aBPimhmiF53FHecuBy/k1mERBLykzfQwl3Zyh58T
	WiqfOtL0qAPk8+ijHGulsGUQvMwLLKaEy30JGCExFF6WWn4sxeMOkgcjD3rk4HoGpK75jMMTpFg1f
	J91j0c6lef+E6/vo6XIUCxx7dXN3OsZMH9nmI8ejLD9ABhbHB79k7FXBJamlYnSTGJ4RUF5hwxvYS
	A3eIiK5A==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBl-00000005Mt6-1lLw;
	Mon, 13 Jan 2025 14:13:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/15] xfs: always complete the buffer inline in xfs_buf_submit
Date: Mon, 13 Jan 2025 15:12:16 +0100
Message-ID: <20250113141228.113714-13-hch@lst.de>
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

xfs_buf_submit now only completes a buffer on error, or for in-memory
buftargs.  There is no point in using a workqueue for the latter as
the completion will just wake up the caller.  Optimize this case by
avoiding the workqueue roundtrip.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 49d087d9ba48..8e795ccd57d6 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1657,21 +1657,17 @@ xfs_buf_submit(
 
 	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
 		xfs_force_shutdown(bp->b_mount, SHUTDOWN_CORRUPT_INCORE);
-		goto done;
+		xfs_buf_ioend(bp);
+		return;
 	}
 
 	/* In-memory targets are directly mapped, no I/O required. */
-	if (xfs_buftarg_is_mem(bp->b_target))
-		goto done;
+	if (xfs_buftarg_is_mem(bp->b_target)) {
+		xfs_buf_ioend(bp);
+		return;
+	}
 
 	xfs_buf_submit_bio(bp);
-	return;
-
-done:
-	if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
-		xfs_buf_ioend(bp);
-	else
-		xfs_buf_ioend_async(bp);
 }
 
 void *
-- 
2.45.2


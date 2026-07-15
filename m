Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3029395DAA
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 14:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127140; cv=none; b=jgRkxHEKxTN87400CehA+yMrHfYrCeAH05mhRusC+NiEuY+OBJuNe/YFFtJM25Z6VvBYDlQAUBWCVU1LvAmGns1ehX0p/cEVA0Yp381gG+H1KdI32MvuJPwHRGQFogrzCPj7ysVLpeKMQ2BYsA/ufr9CBUCkEUjIejtCKw4IucY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127140; c=relaxed/simple;
	bh=7V8F8FYwjh9VjyrL2F2FkbniD1cAZqk1JDONdZQtSBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHHhG3YQevKELmMXjBxgKl1aNpgll6VOHk/0gREzXQLGNYFbJ4jcEzZkXfSQLznyfT0u/NLtKchjz8OHFmlGCPm1AGZlAomIccug21+Va3HyTKal13MO+X/532ECLaiEGUjJkqi5n7dP8JRVl3HO4ZV1PS/Wi0H1m040wJge2QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oBwRBo9W; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oBwRBo9W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8aRwm3a2jqVhF0Yfe3SqpKmX+LccPRRHIH53nAxeOpM=; b=oBwRBo9WxRVRdM+Bp/ZnwGtKxo
	/zBgtv31HR03PGGVbAvRPCYqwnVeCM+rwl8kYSN0aYiab89FxQpDdABkve6w/Y2iT+4ySYNauDIU1
	Ta3+aPGCejOuqdXEyhN3dhQFC2/7h6IHGePm9QVxud0hvQ7C1tUpm2xtv5u5rpTz4xz/GAnlziHhn
	wbU1Ga52oLWhmq8Oy75nu4eQueu0m8jj+YNZBlzbn3tftLLsvD5Vvils2aTCaXyCqR5jghYa/X9fA
	22FR22MVgSbiPcS3Etv19S+RPjSYZd4ocTjn1fc55gSpAK2nlyEP5ylDSLk8cs7IMe/nzfql1guXd
	4gf65PQg==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0yA-0000000FDXi-0YW7;
	Wed, 15 Jul 2026 14:52:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/12] xfs: use goto based error unwinding in xfs_buf_read_map
Date: Wed, 15 Jul 2026 16:51:02 +0200
Message-ID: <20260715145147.95654-10-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715145147.95654-1-hch@lst.de>
References: <20260715145147.95654-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This keeps the I/O error handling contained at the end of the function
and removes the indentation for it.  It also allows to reorder the
comments so that they are closer to the logic that they describe.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4430da3259f1..21c21491d72e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -699,6 +699,23 @@ xfs_buf_read_map(
 		ASSERT(bp->b_ops != NULL || ops == NULL);
 	}
 
+	if (error)
+		goto out_ioerror;
+
+	*bpp = bp;
+	return 0;
+
+out_ioerror:
+	/*
+	 * Check against log shutdown for error reporting because metadata
+	 * writeback may require a read first and we need to report errors in
+	 * metadata writeback until the log is shut down.  High level
+	 * transaction read functions already check against mount shutdown, so
+	 * we only need to be concerned about low level/ IO interactions here.
+	 */
+	if (!xlog_is_shutdown(target->bt_mount->m_log))
+		xfs_buf_ioerror_alert(bp, fa);
+
 	/*
 	 * If we've had a read error, then the contents of the buffer are
 	 * invalid and should not be used. To ensure that a followup read tries
@@ -708,30 +725,14 @@ xfs_buf_read_map(
 	 * future cache lookups will also treat it as an empty, uninitialised
 	 * buffer.
 	 */
-	if (error) {
-		/*
-		 * Check against log shutdown for error reporting because
-		 * metadata writeback may require a read first and we need to
-		 * report errors in metadata writeback until the log is shut
-		 * down. High level transaction read functions already check
-		 * against mount shutdown, anyway, so we only need to be
-		 * concerned about low level IO interactions here.
-		 */
-		if (!xlog_is_shutdown(target->bt_mount->m_log))
-			xfs_buf_ioerror_alert(bp, fa);
-
-		xfs_buf_clear_flags(bp, XBF_DONE);
-		xfs_buf_stale(bp);
-		xfs_buf_relse(bp);
-
-		/* bad CRC means corrupted metadata */
-		if (error == -EFSBADCRC)
-			error = -EFSCORRUPTED;
-		return error;
-	}
+	xfs_buf_clear_flags(bp, XBF_DONE);
+	xfs_buf_stale(bp);
+	xfs_buf_relse(bp);
 
-	*bpp = bp;
-	return 0;
+	/* bad CRC means corrupted metadata */
+	if (error == -EFSBADCRC)
+		return -EFSCORRUPTED;
+	return error;
 }
 
 /*
-- 
2.53.0


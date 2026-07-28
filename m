Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA0B3BB9F1
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785226349; cv=none; b=mGdCl/mOQOHoW7uxlS5Z9nE9E+gK476qHrrvvd71fxfXrYYaEtmLj/09HAERbS+GilW00H7+O/yCV2ynDUDkYm4BOam/VMumbfk/mBb5DjdoauC5Td6PqpZ+Y0QR72GvdjoIFQkXtcgSBsc2IfIqIgsozt4CORHq49rn4DTtstM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785226349; c=relaxed/simple;
	bh=Mv/LgmCnn1v4Ei0rnNB00wxK0/6h13is1aPH66bjQOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQPqHgVmeXPdyvm7jbMgxfBuaFAVuEcBuPoaMImSOCyGG13gXkSfIMT8w7Vnk9v/yapiWX02yv4f/mcrhc+zj2s+TdvoxxTj/yA5ImOlyYadHtqzsc9Jy1arCTa5duoOykwi5Nq1BTo/LRTC2soTKJ/k7QNTi0v2wRWuUfaeG5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3Cw1x6Ep; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3Cw1x6Ep"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3/tIT39SZw+BT2uUv6stqhEsMU7k4EqIw1047KuCAVM=; b=3Cw1x6EpFDExrzEdMRUmB3a4Wy
	5zdHmV46mUzMmZKUg908BgTjwtNhYseRS51St5pdlQ9rawBVQ6EvFYfhIRy2gvxtJ69AP+CM9JdJ1
	0J+V9MRaq5OY0GEfj0GM5HYN+JVjosPWICWXvR2FZwt/Ew0xmrwQBJ98sltIuhjSIbRTHvG8sdmRO
	yr1IJKqfTLvY6GyTr96Yf69ZjSRLP9AXUyXgRd97FSReC15LpZhZCedJnSWvV8RoUn4NEZQpfhTRv
	O75mbUcET45DvqOQlt49xvegJuQVQFeE9/sxJm2re56A2VJ1tm7IEdoarwCW+jmYJZQhZQaa8VsNh
	h5BSiGBg==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocvL-00000004hA3-12C6;
	Tue, 28 Jul 2026 08:12:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/12] xfs: use goto based error unwinding in xfs_buf_read_map
Date: Tue, 28 Jul 2026 10:11:17 +0200
Message-ID: <20260728081152.1778841-10-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728081152.1778841-1-hch@lst.de>
References: <20260728081152.1778841-1-hch@lst.de>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d0dbe85fa20e..3d5e764e3613 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -716,6 +716,23 @@ xfs_buf_read_map(
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
@@ -725,30 +742,14 @@ xfs_buf_read_map(
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


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4BB2BDC2B
	for <linux-xfs@vger.kernel.org>; Mon, 27 Oct 2025 07:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761548798; cv=none; b=RK1jalPD9v7xJ/5QltOPBO8xfx7/eVGqXX45ojzhtFIejSmKJFzeJvOCMc7VPZqtWBAm3hCo4m3cdyyuCfQRpgpSUsnWfsrYNKQOJJruVyH59yge3DXR/H+TjaDtkF5YySbJJZqx7DRacXk1QTJrY2As2NYG+Z0T5EYu8+gXleM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761548798; c=relaxed/simple;
	bh=6xpK2RqYQVk3Lim61IfUXOccrlWDnPgRtdGiWd32bhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9ylU+FpyuQjVkqvZ/5J0rB3ZXcB4ta1TgCkZTXXqpOEDXsxeizT7Y6+Vaa23DIy74k9Id+Lzo1/B66vKy4Lhj1hIrGg89lzKQTwT8pXkQNn67WpkfkRFvirLpLcGsnT2oMB0TiK2Pd6i6rTz1+XYS0UyvH9GspdDQ8MvmGlowM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FPyOilrO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FPyOilrO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tgGeWrvArAT1b3PCXaestjq7+IM0zXug9RAaGD5OhAY=; b=FPyOilrOdLh3yMK+aPthl/GyAs
	hD0gBzrXOkOpLVr0Wv8wKxW1JwvsVpn+aK9JlFl1N33lq9HT2iOpw0i3DKEvzcZF7rMkfWilAr5xx
	h28Dvb0bYjVHURyCgyR6WJg99iXZ6JU3hFnmPN2wN+r2KAsUZ8KKhlf/2BARP+pnMPaOtk/rzaziu
	3onyNPeIhAz7zQ+Mjszbipis2Dg+tkV3gsQLf2bNvni/4DEhYvXQwhwW9PdrCVjxB3BIOWD0CJbVf
	zhw2YQDnvebedaFRkK/t1XhDIki4lfQQu6Pm02hj8Bq57295cG6sKbYjbQyYHVEBMmpy9w+lqsokZ
	UCL8/Fuw==;
Received: from [62.218.44.66] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDHJM-0000000DFiO-0S3Z;
	Mon, 27 Oct 2025 07:06:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 8/9] xfs: remove l_iclog_heads
Date: Mon, 27 Oct 2025 08:05:55 +0100
Message-ID: <20251027070610.729960-9-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251027070610.729960-1-hch@lst.de>
References: <20251027070610.729960-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

l_iclog_heads is only used in one place and can be trivially derived
from l_iclog_hsize by a single shift operation.  Remove it, and switch
the initialization of l_iclog_hsize to use struct_size so that it is
directly derived from the on-disk format definition.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      | 11 ++++++-----
 fs/xfs/xfs_log_priv.h |  1 -
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8b3b79699596..47a8e74c8c5c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1279,11 +1279,12 @@ xlog_get_iclog_buffer_size(
 	log->l_iclog_size = mp->m_logbsize;
 
 	/*
-	 * # headers = size / 32k - one header holds cycles from 32k of data.
+	 * Combined size of the log record headers.  The first 32k cycles
+	 * are stored directly in the xlog_rec_header, the rest in the
+	 * variable number of xlog_rec_ext_headers at its end.
 	 */
-	log->l_iclog_heads =
-		DIV_ROUND_UP(mp->m_logbsize, XLOG_HEADER_CYCLE_SIZE);
-	log->l_iclog_hsize = log->l_iclog_heads << BBSHIFT;
+	log->l_iclog_hsize = struct_size(log->l_iclog->ic_header, h_ext,
+		DIV_ROUND_UP(mp->m_logbsize, XLOG_HEADER_CYCLE_SIZE) - 1);
 }
 
 void
@@ -1526,7 +1527,7 @@ xlog_pack_data(
 		dp += BBSIZE;
 	}
 
-	for (i = 0; i < log->l_iclog_heads - 1; i++)
+	for (i = 0; i < (log->l_iclog_hsize >> BBSHIFT) - 1; i++)
 		rhead->h_ext[i].xh_cycle = cycle_lsn;
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index ac98ac71152d..17733ba7f251 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -406,7 +406,6 @@ struct xlog {
 	struct list_head	*l_buf_cancel_table;
 	struct list_head	r_dfops;	/* recovered log intent items */
 	int			l_iclog_hsize;  /* size of iclog header */
-	int			l_iclog_heads;  /* # of iclog header sectors */
 	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
 	int			l_iclog_size;	/* size of log in bytes */
 	int			l_iclog_bufs;	/* number of iclog buffers */
-- 
2.47.3


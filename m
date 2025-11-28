Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A543E25A2A5
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311562; cv=none; b=nHhqRnw/rsO5TepgrPbGBVtnvT6m+EqDJUKN/3XCgplE7o4BhGaMqBl4WxgPJP3stVmHvL0oZNTR7Xv1CEqqBDgRtfDn79nguI9SWNdqXk8AxOD62jqIR1R4mmm3q4rddz041UKzK4izQCMFj5QHZzQK8UYg6LITU3JdHFXZo7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311562; c=relaxed/simple;
	bh=5JMx4uVr/3R0FmPLnOVWKStY9PM3WXzxiFIBi+kIRnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twELxwiXZ4t36RW+V1N3R9BqHdNrN2box1PH5d+jQoxySlGIVQyv0+UfIiaeXRGILjNOP7kieZ9TqYmCSG8QozEDrczocwj4ysDxxcNW8lZbFh67FwAEU8RjiDm4pXasyxD9lMZvx9rStksJTu8LwwcIE2MhD3Im5jEqGtpCR/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=49cY0aAs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="49cY0aAs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nPIuKAel0iVKaz9iFudFF3A/Q5RfVqouPV7wzaqCcr0=; b=49cY0aAsj+76Jni8YjCFjJtcwT
	YBeKeTKbkWt2zwqZ/+MnYL9jAERFlkysB4mOicKcgOx8/kj1WfG8cRECpN9bSBKbBuWxgDKM+6L+o
	kty2nO82rDwtHuJ6z1rt8PE5SGtPoWAJbrhor2+AY2uP63kQqu7VZWQyjTQlcJZZTJhXzfyFg3wHw
	o154+bf6gtaglGiHt3Yc1owG/G6n5aluaR5Okp0Ixaxrq9qcidTBamoEK7DeI+uJ7aRwRFycaCQ3/
	TX2SKaoZWbNp2XBlbb5ehyq1fsjOdrgPB8zwGfpPy1rfp+mY7P9qyy7V+0mxFQz4QcykRRWGUyN/8
	mLlDIVTA==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs24-000000002jS-3Do4;
	Fri, 28 Nov 2025 06:32:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 21/25] logprint: re-indent print_xlog_bad_*
Date: Fri, 28 Nov 2025 07:29:58 +0100
Message-ID: <20251128063007.1495036-22-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128063007.1495036-1-hch@lst.de>
References: <20251128063007.1495036-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 0570cc951f04..ba48c7a3190c 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1268,40 +1268,47 @@ xlog_print_rec_xhead(
 }
 
 static void
-print_xlog_bad_zeroed(xfs_daddr_t blkno)
+print_xlog_bad_zeroed(
+	xfs_daddr_t		blkno)
 {
 	print_stars();
 	printf(_("* ERROR: found data after zeroed blocks block=%-21lld  *\n"),
 		(long long)blkno);
 	print_stars();
 	if (print_exit)
-	    xlog_exit("Bad log - data after zeroed blocks");
-}	/* print_xlog_bad_zeroed */
+		xlog_exit("Bad log - data after zeroed blocks");
+}
 
 static void
-print_xlog_bad_header(xfs_daddr_t blkno, char *buf)
+print_xlog_bad_header(
+	xfs_daddr_t		blkno,
+	char			*buf)
 {
 	print_stars();
 	printf(_("* ERROR: header cycle=%-11d block=%-21lld        *\n"),
 		xlog_get_cycle(buf), (long long)blkno);
 	print_stars();
 	if (print_exit)
-	    xlog_exit("Bad log record header");
-}	/* print_xlog_bad_header */
+		xlog_exit("Bad log record header");
+}
 
 static void
-print_xlog_bad_data(xfs_daddr_t blkno)
+print_xlog_bad_data(
+	xfs_daddr_t		blkno)
 {
 	print_stars();
 	printf(_("* ERROR: data block=%-21lld                             *\n"),
 		(long long)blkno);
 	print_stars();
 	if (print_exit)
-	    xlog_exit("Bad data in log");
-}	/* print_xlog_bad_data */
+		xlog_exit("Bad data in log");
+}
 
 static void
-print_xlog_bad_reqd_hdrs(xfs_daddr_t blkno, int num_reqd, int num_hdrs)
+print_xlog_bad_reqd_hdrs(
+	xfs_daddr_t		blkno,
+	int			num_reqd,
+	int			num_hdrs)
 {
 	print_stars();
 	printf(_("* ERROR: for header block=%lld\n"
@@ -1310,8 +1317,8 @@ print_xlog_bad_reqd_hdrs(xfs_daddr_t blkno, int num_reqd, int num_hdrs)
 		(long long)blkno, num_reqd, num_hdrs);
 	print_stars();
 	if (print_exit)
-	    xlog_exit(_("Not enough headers for data length."));
-}	/* print_xlog_bad_reqd_hdrs */
+		xlog_exit(_("Not enough headers for data length."));
+}
 
 static void
 xlog_reallocate_xhdrs(int num_hdrs, xlog_rec_ext_header_t **ret_xhdrs)
-- 
2.47.3


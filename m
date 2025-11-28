Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5919626CE32
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311554; cv=none; b=DXi4FtRwWHGF+pueG7CoEX9NU04D6uLEaELSbca8jYSJ4XtWxNjBGxWvQcnsvMRbZNf4vDegGhD9XUyldtWD/4/ODppfv8LA/Q05V0F7T2saMhCN/SC5yxYiYrrZFUK9Oz28RbseTjamowRw3xaXBViFR9NOXDjT11bFEtRaixk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311554; c=relaxed/simple;
	bh=SOdNvnaf0rbk1wa8Z3YoAEKtkfuxMzrX6RKmWOkMLXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdj2jQL3dJHjiMZ8wGryBlYExTbr+jrF4Pq8lVjj8ptrl0DQpGDSr+akxLAhwvbhCExiU4IKxdAF1G2hOJI+MoU81ue1XiCevVkvO/gbxLAzZL1n3HcvKyMiiWZZMRq1UpZCyic415qZUU4OLVKHvEb9emVi2zinghPwLE/vEa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X7Q5+Y0w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X7Q5+Y0w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AE7bRLgbx2JKKqFHXqUnGj4gdUaT2oeQr/6pu7Zv0so=; b=X7Q5+Y0wDgmEPAzU78e4D8m3Pd
	fhhVh3/RdsBlNDFEjrbkh3KXJqhvWr36hxSSfhaiTBs03v8SmuBu3YXp6bLNsHvwrRmJrfSr9D9Z9
	QLHqpGlD7z6lMAXg5FnHb93ytIy3zQ7BCMfd0gBd2Ei13hNlsZ1rqmz2jg5fcaIm/8vCKkkbWjLNY
	otkAAJFrXMrtnA1XN+1+LWeUEr+EsnETJtjN2ecyLvgB+aZhxyjYRX6KL3owe1MQRAadioMhYR4gZ
	GG877974DVHCIpZBc1KM2K4rrQHq7gGAtd6lN0mdkdyV4nTfJ9yRHjCtni8akoHNHN061IVsaHwzI
	up9AeyoA==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs1w-000000002hx-2qUa;
	Fri, 28 Nov 2025 06:32:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 20/25] logprint: cleanup xlog_print_rec_xhead
Date: Fri, 28 Nov 2025 07:29:57 +0100
Message-ID: <20251128063007.1495036-21-hch@lst.de>
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

Re-indent and drop typedefs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 1ac45a926c40..0570cc951f04 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1248,22 +1248,24 @@ xlog_print_rec_head(
 }
 
 static void
-xlog_print_rec_xhead(xlog_rec_ext_header_t *head, int coverage)
+xlog_print_rec_xhead(
+	struct xlog_rec_ext_header	*head,
+	int				coverage)
 {
-    int i;
+	int				i;
 
-    print_xlog_xhdr_line();
-    printf(_("extended-header: cycle: %d\n"), be32_to_cpu(head->xh_cycle));
+	print_xlog_xhdr_line();
+	printf(_("extended-header: cycle: %d\n"),
+		be32_to_cpu(head->xh_cycle));
 
-    if (print_overwrite) {
-	printf(_("cycle num overwrites: "));
-	for (i = 0; i < coverage; i++)
-	    printf("%d - 0x%x  ",
-		    i,
-		    be32_to_cpu(head->xh_cycle_data[i]));
-	printf("\n");
-    }
-}	/* xlog_print_rec_xhead */
+	if (print_overwrite) {
+		printf(_("cycle num overwrites: "));
+		for (i = 0; i < coverage; i++)
+			printf("%d - 0x%x  ",
+				i, be32_to_cpu(head->xh_cycle_data[i]));
+		printf("\n");
+	}
+}
 
 static void
 print_xlog_bad_zeroed(xfs_daddr_t blkno)
-- 
2.47.3


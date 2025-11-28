Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE142244667
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311521; cv=none; b=A8/S5umJvMofFQ8FLv6X40uNW5e6bbyi7mHZi1ViuT8HD4plOEtCvlzOhA0rLUAvUep6m92E1ZauGJReKGPblr61zmy91a7IDC4xpDmFgbuHn4qysjk+gTlFpWQZwHEC9mpJeP0bJWpetZRG+4An9Lg97Pov72NlAVgzQ+a5Ebg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311521; c=relaxed/simple;
	bh=kVyzN8T/d47WliEjuWb9rtYdbhO0r6ZC6PDWCoyebyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ep/V2rJFY0PnWvl3z4N6bwKsW/+LN3q2o8M4PnO8f6ZQ/LZWRUlY6Cln5z6/Vu0raT4JHmB5ChKk2MNlEUWhKcF7OESDeVROwTLEH+D7ok3qSdeKbsCfwzrULhN21lZaBW3UbwYl57dLiZ06UO0C+77V9YCf1NrrpTW8bzIR4WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W0oQjb/R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W0oQjb/R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UwcxiYY+ewwkyr2MKy7k+ULOH7NOOLt1HBG7R/zIgJY=; b=W0oQjb/RzgEUuqRCojIjFtLhVc
	ttzgcWxaIFqGEwRyZwVfHAkYAe85m0zgS/JTqhKPQPaYAdUA4wOQF1cyy8JK7w1FKUwb8iulpbEze
	NPWXgSXGO469UdqibRTO/Sg88/NU2AnfIwj3VNg7UMJlG5Aj35U+RCbqa7JDrRlGVBzar6Rnn1guP
	4/OSSb8NukEwsgTHr5CTHNlC76Q/dcM6lPpulYpDfASZI0SV5RQMFl2AKcpoQnAOsJl603pUVdaZh
	ecW7FtDexBZ6I2RcG9CXKCwGHGPdaVjHu1LT8Qzn/rsQq5Mei5onhJ1y03/g9crHf/YejbayshUjY
	ODZFMFpQ==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs1P-000000002g1-0O6v;
	Fri, 28 Nov 2025 06:31:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 14/25] logprint: re-indent print_lseek / print_lsn
Date: Fri, 28 Nov 2025 07:29:51 +0100
Message-ID: <20251128063007.1495036-15-hch@lst.de>
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
 logprint/log_misc.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 73dd7ab46938..c4486e5f6a14 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -872,10 +872,14 @@ xlog_extract_dinode_ts(
 }
 
 void
-xlog_print_lseek(struct xlog *log, int fd, xfs_daddr_t blkno, int whence)
+xlog_print_lseek(
+	struct xlog		*log,
+	int			fd,
+	xfs_daddr_t		 blkno,
+	int			whence)
 {
 #define BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
-	xfs_off_t offset;
+	xfs_off_t		offset;
 
 	if (whence == SEEK_SET)
 		offset = BBTOOFF64(blkno+log->l_logBBstart);
@@ -886,15 +890,16 @@ xlog_print_lseek(struct xlog *log, int fd, xfs_daddr_t blkno, int whence)
 			progname, (long long)offset, strerror(errno));
 		exit(1);
 	}
-}	/* xlog_print_lseek */
-
+}
 
 static void
-print_lsn(char		*string,
-	  __be64	*lsn)
+print_lsn(
+	char			*string,
+	  __be64		*lsn)
 {
-    printf("%s: %u,%u", string,
-	    CYCLE_LSN(be64_to_cpu(*lsn)), BLOCK_LSN(be64_to_cpu(*lsn)));
+	printf("%s: %u,%u", string,
+		CYCLE_LSN(be64_to_cpu(*lsn)),
+		BLOCK_LSN(be64_to_cpu(*lsn)));
 }
 
 
-- 
2.47.3


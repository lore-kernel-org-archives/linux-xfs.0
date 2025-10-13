Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6711279355
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323373; cv=none; b=h3nSsDwjSyfCRGJ2Bk3jYGMHpx5DrlUBTbz+e65w5+wH1M03nRGYCpoOsc4tn6A4whEM7+KGieBw0tmX0ED2MWViMIcUhRrJmXoEW7FCSm8NPLpogMxFJlL0Z4i4J1Y2nx+0D81zs1nfRHkNKlY83Jy/pevdHxdvIQlabloJ9bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323373; c=relaxed/simple;
	bh=ZVrUClQXJGuy7CFwDvkNgQwiYb7mcrMOcGsbTa2ADMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYQAlalGcE2TLDC/gGKCzUSSTTEDXlbp5SbteGH9h03LGGVGBWtd3KiP0pO641xoYg+4Iata0zFdMPEh52tr3+PJKD2kYDuzSInv7agyMmwbrpt/iNDpXxAhJcxjFZ1v6SQtgSwQmWFvYPkhHL893veOXhjP9ID+LLsush1PjOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A4b+VYuQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A4b+VYuQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hnkimeyi12Cm072Xd0ibFU3Fqt27bLrUYUeiLT6YjPo=; b=A4b+VYuQ0ANB5iDRoMTY4qqwXA
	oifUo9BXEBtkJnG6A5m9LAiZn4TGtnQtatnkYS1f66CpJH2iwBOS2i+0PKR7FeNzSlJdT5YEK3aiS
	FpSVBLZaMZpULB7m2tnQHqLGBkxGWb5qrAVj0+9280ilCy0eK/H4QFfBRHUdphBh9IUFvY7zIf78n
	2DI493Ostds43hy2ILNMDtNzufhHbFCmqCwtC8tbiNc6wpic+R0caaJjD886/U04FjdEYh9xiBH4A
	xK9YzRE0MtpHDnPR+pqNu27BTzmnxZUXIR8HA77Bkqux9xZEJcXtWstOrhBLBZe9kDSKAhfY3CAjy
	N/F/2b/w==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88WQ-0000000C7GK-3Xh5;
	Mon, 13 Oct 2025 02:42:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/9] xfs: remove a very outdated comment from xlog_alloc_log
Date: Mon, 13 Oct 2025 11:42:09 +0900
Message-ID: <20251013024228.4109032-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013024228.4109032-1-hch@lst.de>
References: <20251013024228.4109032-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The xlog_iclog definition has been pretty standard for a while, so drop
this now rather misleading comment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3bd2f8787682..acddab467b77 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1435,13 +1435,6 @@ xlog_alloc_log(
 	init_waitqueue_head(&log->l_flush_wait);
 
 	iclogp = &log->l_iclog;
-	/*
-	 * The amount of memory to allocate for the iclog structure is
-	 * rather funky due to the way the structure is defined.  It is
-	 * done this way so that we can use different sizes for machines
-	 * with different amounts of memory.  See the definition of
-	 * xlog_in_core_t in xfs_log_priv.h for details.
-	 */
 	ASSERT(log->l_iclog_size >= 4096);
 	for (i = 0; i < log->l_iclog_bufs; i++) {
 		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE) *
-- 
2.47.3


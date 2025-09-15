Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B3B315D33
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942834; cv=none; b=Al9LcPxbyKsl6bUSa133Ka68ewXz+oT4eXkdEdXxwd6e8jtfJPgsycicNbBMJNqN4vOQbMRncxywwtRWSDuQWbV6f5CJFDL6blKVxl9T73v75bfrAg0Wi/Ea/TJ2SNLsYf+X3RsS9U+FGTSsAjL7JuvLl7v/i8YudegFUrH45Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942834; c=relaxed/simple;
	bh=395tu0Xg0zYA4/bMW0gFvXR1eLg4wdquNM19Xu0I1vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhAGS18KhPblw8BwX7Yfn9VV5adfxiTCWfexGBcTSDHDCzfgiSOmTrMXLHC0hWPodOlES6hhqDGF+77BiEtw2EA7otmaSLYKP8gZPT/xBN57Cnivmjdc7sew06ef2Hs3ygTMXoS+axfr800VlrUDg/7JxBC3j7qmU5l8Dknn8Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XXAtH1wF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XXAtH1wF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aH4e8+LXZ0koLjrINjApqFAzvTV89jX1xzb7pFSNzB4=; b=XXAtH1wF68gTkFLekaqLNs04Zz
	uYIhjC/hrj6rb2DPo3cmlC0pxB/Cz5+z6vGnmAG+6XhEbD/7vbrJyAHZfEjAvyviRpvEZo7Y+Rki5
	VU6hgpw1Oj2U81JOBd7QUNV7LrauGyUHZ6AsfKuHbENWzeWPp8xXZUNtItc3g4f6hfePeAttoZJYd
	G3i7keRBoC4RFOWQV/SZGAwp4Dn25Vt2JBZLmlKKHPYqM8QXfsZCBH+D0V2IXennEqinMvt/w8kyH
	1X/kwiCuL3Lr7I09FZJM+99ne9BpGe/YseM/p4oc9BpSm3cHqKYJpM5Eqm0bWVVDRxFYZ7jnWYz3D
	lpoxjBoA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ee-00000004Jbx-3bAL;
	Mon, 15 Sep 2025 13:27:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 15/15] xfs: remove the unused xfs_log_iovec_t typedef
Date: Mon, 15 Sep 2025 06:27:05 -0700
Message-ID: <20250915132709.160247-16-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915132709.160247-1-hch@lst.de>
References: <20250915132709.160247-1-hch@lst.de>
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
 fs/xfs/libxfs/xfs_log_format.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index c1076e4f55be..6c50cb2ece19 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -185,12 +185,11 @@ typedef union xlog_in_core2 {
 } xlog_in_core_2_t;
 
 /* not an on-disk structure, but needed by log recovery in userspace */
-typedef struct xfs_log_iovec {
+struct xfs_log_iovec {
 	void		*i_addr;	/* beginning address of region */
 	int		i_len;		/* length in bytes of region */
 	uint		i_type;		/* type of region */
-} xfs_log_iovec_t;
-
+};
 
 /*
  * Transaction Header definitions.
-- 
2.47.2


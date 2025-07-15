Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C3C219E8
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582713; cv=none; b=q+Kow3SfgT2ZYK47WbMqcdvBXHoDZe6pAvyUfrq+NykF4U5xPjY8/k/OhaLgly9O/Ri8OmwPe5vw2L2DQoB6lNa1YoZvGVhyDxAFMTCiM9v+aEtnZm6tZpcMheKgREfs9uf8eheuhy/wFTKu6WATbB7/Ujb5W2ktk72sGSafJIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582713; c=relaxed/simple;
	bh=2avEleje5Hv+iQn1gmXUR7Q+4X0KhNWJqQs0r3nm0r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9jmtKRH//sWeay3Akh3qKitzqEqW02JuSAhZVsHH5gK45hvvZ1Drk+NXeFodh+SrqnJfyVWliCrprGmgI0w/5Ciu0+aeiARmUPGxlBNuG+6n6eIrYcfA/WVQxLJqQqUGwONDKaPAv9zjH3cz2BckDVJcm7p/eGNdY7meB221E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g5hB39sg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g5hB39sg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rIfyabnooga6Wc5SDrHFtYyg9sbCaX44IYGg0dBOrq0=; b=g5hB39sgvGhg6NZQKxEC7F8oy9
	UanyYNBNkSPHl/VTrN2x9Vl5+Q63cYmxuPnEg7MpaBEHuYu+Hj6JyHvJwTt40miAQ1hREo+gVzANG
	bTviT14uf1KEDcqNjGy86F1mBXu5RdJa6jZH1J2pzzbH3TfFAKlJq69NPAvlR0zMnGHvumynXlfu2
	aXvRZJ32XRJTOfH/V//ftwu+3hOC/LypMX9J9k4YD4wIPPR1WNRTGGi4FL5v95CEqyj602rKLlPYe
	2l7CeOzIbPKsz7WcDIiZV2OQm9LrBpjZKzMt5pAn8d9JHKMRkaip4e9uKM1m5VaUJ/b3y16j/TwLz
	7UKpI29g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubep5-000000054qF-2ZZv;
	Tue, 15 Jul 2025 12:31:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 09/18] xfs: move struct xfs_log_iovec to xfs_log_priv.h
Date: Tue, 15 Jul 2025 14:30:14 +0200
Message-ID: <20250715123125.1945534-10-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715123125.1945534-1-hch@lst.de>
References: <20250715123125.1945534-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This structure is now only used by the core logging and CIL code.

Also remove the unused typedef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 8 --------
 fs/xfs/xfs_log_priv.h          | 6 ++++++
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 0d637c276db0..4f12664d1005 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -194,14 +194,6 @@ typedef union xlog_in_core2 {
 	char			hic_sector[XLOG_HEADER_SIZE];
 } xlog_in_core_2_t;
 
-/* not an on-disk structure, but needed by log recovery in userspace */
-typedef struct xfs_log_iovec {
-	void		*i_addr;	/* beginning address of region */
-	int		i_len;		/* length in bytes of region */
-	uint		i_type;		/* type of region */
-} xfs_log_iovec_t;
-
-
 /*
  * Transaction Header definitions.
  *
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 463daf51da15..fd6968ce7bd0 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -13,6 +13,12 @@ struct xlog;
 struct xlog_ticket;
 struct xfs_mount;
 
+struct xfs_log_iovec {
+	void		*i_addr;	/* beginning address of region */
+	int		i_len;		/* length in bytes of region */
+	uint		i_type;		/* type of region */
+};
+
 /*
  * get client id from packed copy.
  *
-- 
2.47.2


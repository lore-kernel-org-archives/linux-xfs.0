Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD72277CBF
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 14:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761835802; cv=none; b=AdKHqgYIHflnHc8bgWvnjh3/ULCTRaM+1VuD5Q1OQsp/RrQwnA2QW7HhezUeoyRpMIuVPNCHuUGC2h10g9fUnNXY6wdIYCEF5j81X1ltrq2Y6SETncZJcS6o0ttyHF8nR6Twnk0v+AWeiRULv/4m6Pw8pfeJKcLss5+NPVtf5Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761835802; c=relaxed/simple;
	bh=w6sCEB2Ul7sUC6NzkoDg5eN+lXUZ47lo9eAZN1Qu0hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdrZNjFnU6gQhU/P470NqOXkOM6F4+nus+dRVZPu345vC4hz1xqJLeiGvu8AFaaVaO7cKb9J9kKp/vvgeZqQCx3AfvtCu2z9o/WaC/SDP892kYkqt8mOU9xwGKGCqyfM320xAjpygLRMtrBp0jXWj1fAv7JkvtDS1kmK6mtdp5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uKLwUoPI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uKLwUoPI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=80joUNGBhUvlGKwu9zD3pSRA3re3h4ENcmwh+/kfMOE=; b=uKLwUoPIplWLv1IkikPnxn9H0z
	Z89QBQIyl2jvIa79Za1AVZzhMcd5twMn+QDSRxPwwQJfTElpR5vMPu8vLizvdNY7Jk2D59bye0s9o
	zaDWCgd6BGKjAvDFAf945UiDL1IMsj8oApeZfQNEYdD3F7KNmeXrKXtvW4WFHV+8KQwsRDlLjWaND
	NtJ5RuMjpO+P7BXvopWQ1sWbL6rKjPgWYnMJvqOSSMmUyQIQGlDOjfj6cW6buzZWQlrnx850+FRiF
	6CJ2RU3HbwykiW2CorTJzI9uHbPxoQWt3YZkb2MeN+Rc4L08GD3fgbO0G2leop0a+cU7gGtLMU09C
	BA72VKuQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vETyR-00000004KNm-1GiY;
	Thu, 30 Oct 2025 14:50:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 04/10] xfs: move struct xfs_log_iovec to xfs_log_priv.h
Date: Thu, 30 Oct 2025 15:49:14 +0100
Message-ID: <20251030144946.1372887-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251030144946.1372887-1-hch@lst.de>
References: <20251030144946.1372887-1-hch@lst.de>
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
 fs/xfs/libxfs/xfs_log_format.h | 7 -------
 fs/xfs/xfs_log_priv.h          | 6 ++++++
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 908e7060428c..3f5a24dda907 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -184,13 +184,6 @@ struct xlog_rec_header {
 #define XLOG_REC_SIZE_OTHER	offsetofend(struct xlog_rec_header, h_size)
 #endif /* __i386__ */
 
-/* not an on-disk structure, but needed by log recovery in userspace */
-struct xfs_log_iovec {
-	void		*i_addr;	/* beginning address of region */
-	int		i_len;		/* length in bytes of region */
-	uint		i_type;		/* type of region */
-};
-
 /*
  * Transaction Header definitions.
  *
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index d2410e78b7f5..b7b3f61aa2ae 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -13,6 +13,12 @@ struct xlog;
 struct xlog_ticket;
 struct xfs_mount;
 
+struct xfs_log_iovec {
+	void			*i_addr;/* beginning address of region */
+	int			i_len;	/* length in bytes of region */
+	uint			i_type;	/* type of region */
+};
+
 /*
  * get client id from packed copy.
  *
-- 
2.47.3


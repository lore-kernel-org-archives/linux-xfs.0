Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AD6321428
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 12:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762949720; cv=none; b=Jo8zSSQhTXA0Gl+jDnIB1W9+Dk+9eRMAQXGNm5qUj1lpeoUEfan63UR9URnJ9awf4YE5vBQHG8DX41vGADDtjyFboESUMcISDAa2+OZdTb7DNR2BNQoxKQbc2O1H459OHDG0e4qYeFXy03SIH9rZUKrzUUa0lH5OQlVwYy3CR1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762949720; c=relaxed/simple;
	bh=BKwhfHE7kouHetcrAbHRGu4vAyg70aS4I1zem4t9L00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnJipynAchlijAK4DflghRkoahcVvdWGOkotvArSFt2BMHNBsZT+lxAitBJAao8/ih8gefdpBTQSjqmtB3N/wQyfTqo2OoCrn1X6peGe3lDhMwsWx1wnSsX0RZp4qNuKO/Xrg5Du1amprBoyNBBijUJrIuE8ra2eJfO5v0YeePQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QGSs6tc8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QGSs6tc8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Urmo4ooA1mQBuQSw7GS37FV3Q8TAfJy35LWkJQry/Ck=; b=QGSs6tc857vct9fTcpOHCXirEJ
	cKRC948DBmU56LF7JHtMZjw6pUmx9UpygOerrnTibdDNGLimSxgGwpIZc8eTqc+VIgLsbi6vP+P2X
	bZMP7kOOioLN6r1a0P+OzQu7O/eOPGzHjj48owjTxWDandGJeSWOZOEkOZKXsvrk9v8lDXExbZrI3
	bXZKmh0bDY4l2yNB6RVqF5PkbaeX0uSVqVWHgxR1ZSowiIsryI3l3sPQOCbtnC5FAyhWa8qPfr7uy
	w6HR1OlkIHkNv/QQ7w/uBrdcBdoG5zQ0TRsJEgMTLcbfyKylNgLJ9W3Qm5Ee+V2xEVviqu5nvxXv4
	KzJbTFRA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ9ks-00000008lBj-0Ydv;
	Wed, 12 Nov 2025 12:15:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 04/10] xfs: move struct xfs_log_iovec to xfs_log_priv.h
Date: Wed, 12 Nov 2025 13:14:20 +0100
Message-ID: <20251112121458.915383-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112121458.915383-1-hch@lst.de>
References: <20251112121458.915383-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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


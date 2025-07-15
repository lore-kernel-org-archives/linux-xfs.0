Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3966D219E8
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582728; cv=none; b=pO2jNfi1ot2JprvoGv4JxXBCT05FMoVsUYqn/v5fkPf6w43dYKRw5gw0e7gA+OSYUVfGJlxEDy0+GGmRejTrA7ithc9TjE0ViviN9l3BHBRiMRvd7OnuhKpvh9LtDk5FRBqHBDHkWQlovapr1zeaR+XV9UUvvy8Nfjxi/MxR27o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582728; c=relaxed/simple;
	bh=zbX8yW7wsViKKXx3udw2a5IVaiR5yyTvOlQbf0iy6sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SL0Ug4RELheBZHnoNA6Ii6B8pY2Efb7TC66EapYCXzKykMyMgNVTQIBEMHs9ab6PwM0t2GEg4gHZfCPy51qOYmXJWY523e2YjDq5Ygkm3m5viCpAL0YQG7ISerufDPJP2kcEFidSu3Fj5zgE+CIXh3t8vlhASln66Dt9j0lsLIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tbN8R2Dg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tbN8R2Dg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=w8uF8zzQaKlMq6tAIEDYDhtQfyf3WHnPV2NGtTm+s3Q=; b=tbN8R2DgUvKyhFRwkkhP8VyHg1
	Dr1hw41g+fxFO5s0m7PvzeLu1KmGtIOJhrhOaYS8GXwRa0OKapQWzST6fymLBKLZ/7FWvRIdYC2Si
	YJGev1uay/HY9I4WjXr7E2+5mpp0FypKhwfGV+Wm2z/+Uz9HQhWqQK7cOUYfpeBQXnlMZDw6i2cXM
	WbZUzwADE+fNkLwYeOcmFZ0m6mU0pi20nCbmbD4dooTK5AB5AOVTYs7dzFNt0NwNDKZpiJvchO53G
	jNO9cdaPjLsHLqmJT34gv8IVirpNOqpdP7e7jQnWLDyyLHuGdbucHL1zRAvv43xO9M7j3+WASUoim
	MLfZdpBA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubepK-000000054uq-0o1G;
	Tue, 15 Jul 2025 12:32:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 13/18] xfs: move the XLOG_REG_ constants out of xfs_log_format.h
Date: Tue, 15 Jul 2025 14:30:18 +0200
Message-ID: <20250715123125.1945534-14-hch@lst.de>
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

These are purely in-memory values and not used at all in xfsprogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 37 ----------------------------------
 fs/xfs/xfs_log.h               | 37 ++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e5e6f8c0408f..da99ab4aea6c 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -86,43 +86,6 @@ struct xfs_unmount_log_format {
 	uint32_t	pad2;	/* may as well make it 64 bits */
 };
 
-/* Region types for iovec's i_type */
-#define XLOG_REG_TYPE_BFORMAT		1
-#define XLOG_REG_TYPE_BCHUNK		2
-#define XLOG_REG_TYPE_EFI_FORMAT	3
-#define XLOG_REG_TYPE_EFD_FORMAT	4
-#define XLOG_REG_TYPE_IFORMAT		5
-#define XLOG_REG_TYPE_ICORE		6
-#define XLOG_REG_TYPE_IEXT		7
-#define XLOG_REG_TYPE_IBROOT		8
-#define XLOG_REG_TYPE_ILOCAL		9
-#define XLOG_REG_TYPE_IATTR_EXT		10
-#define XLOG_REG_TYPE_IATTR_BROOT	11
-#define XLOG_REG_TYPE_IATTR_LOCAL	12
-#define XLOG_REG_TYPE_QFORMAT		13
-#define XLOG_REG_TYPE_DQUOT		14
-#define XLOG_REG_TYPE_QUOTAOFF		15
-#define XLOG_REG_TYPE_LRHEADER		16
-#define XLOG_REG_TYPE_UNMOUNT		17
-#define XLOG_REG_TYPE_COMMIT		18
-#define XLOG_REG_TYPE_TRANSHDR		19
-#define XLOG_REG_TYPE_ICREATE		20
-#define XLOG_REG_TYPE_RUI_FORMAT	21
-#define XLOG_REG_TYPE_RUD_FORMAT	22
-#define XLOG_REG_TYPE_CUI_FORMAT	23
-#define XLOG_REG_TYPE_CUD_FORMAT	24
-#define XLOG_REG_TYPE_BUI_FORMAT	25
-#define XLOG_REG_TYPE_BUD_FORMAT	26
-#define XLOG_REG_TYPE_ATTRI_FORMAT	27
-#define XLOG_REG_TYPE_ATTRD_FORMAT	28
-#define XLOG_REG_TYPE_ATTR_NAME		29
-#define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_XMI_FORMAT	31
-#define XLOG_REG_TYPE_XMD_FORMAT	32
-#define XLOG_REG_TYPE_ATTR_NEWNAME	33
-#define XLOG_REG_TYPE_ATTR_NEWVALUE	34
-#define XLOG_REG_TYPE_MAX		34
-
 /*
  * Flags to log operation header
  *
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 780155839df4..0f23812b0b31 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -9,6 +9,43 @@
 struct xlog_format_buf;
 struct xfs_cil_ctx;
 
+/* Region types for iovec's i_type */
+#define XLOG_REG_TYPE_BFORMAT		1
+#define XLOG_REG_TYPE_BCHUNK		2
+#define XLOG_REG_TYPE_EFI_FORMAT	3
+#define XLOG_REG_TYPE_EFD_FORMAT	4
+#define XLOG_REG_TYPE_IFORMAT		5
+#define XLOG_REG_TYPE_ICORE		6
+#define XLOG_REG_TYPE_IEXT		7
+#define XLOG_REG_TYPE_IBROOT		8
+#define XLOG_REG_TYPE_ILOCAL		9
+#define XLOG_REG_TYPE_IATTR_EXT		10
+#define XLOG_REG_TYPE_IATTR_BROOT	11
+#define XLOG_REG_TYPE_IATTR_LOCAL	12
+#define XLOG_REG_TYPE_QFORMAT		13
+#define XLOG_REG_TYPE_DQUOT		14
+#define XLOG_REG_TYPE_QUOTAOFF		15
+#define XLOG_REG_TYPE_LRHEADER		16
+#define XLOG_REG_TYPE_UNMOUNT		17
+#define XLOG_REG_TYPE_COMMIT		18
+#define XLOG_REG_TYPE_TRANSHDR		19
+#define XLOG_REG_TYPE_ICREATE		20
+#define XLOG_REG_TYPE_RUI_FORMAT	21
+#define XLOG_REG_TYPE_RUD_FORMAT	22
+#define XLOG_REG_TYPE_CUI_FORMAT	23
+#define XLOG_REG_TYPE_CUD_FORMAT	24
+#define XLOG_REG_TYPE_BUI_FORMAT	25
+#define XLOG_REG_TYPE_BUD_FORMAT	26
+#define XLOG_REG_TYPE_ATTRI_FORMAT	27
+#define XLOG_REG_TYPE_ATTRD_FORMAT	28
+#define XLOG_REG_TYPE_ATTR_NAME		29
+#define XLOG_REG_TYPE_ATTR_VALUE	30
+#define XLOG_REG_TYPE_XMI_FORMAT	31
+#define XLOG_REG_TYPE_XMD_FORMAT	32
+#define XLOG_REG_TYPE_ATTR_NEWNAME	33
+#define XLOG_REG_TYPE_ATTR_NEWVALUE	34
+#define XLOG_REG_TYPE_MAX		34
+
 #define XFS_LOG_VEC_ORDERED	(-1)
 
 /*
-- 
2.47.2


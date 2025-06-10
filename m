Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9303A7083C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 05:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749532660; cv=none; b=nv8zD43mytxCwxRSDeMj2dBl0dGVmMJ4B4QS6hZWwKyyLG3w/FDVA4MLNMvT1JNtZStkqtf61b+B0WwdLFPbHXs1hfE8MFUTnUassZFV0k/HmCmoQBDr7f/c4lXpv7azbZ6OejW/ayFXUBMiiRtoH0jp/2catDS6G2RW9Chskks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749532660; c=relaxed/simple;
	bh=4MX2dOlyKQm4duyO+EgQEf9i0oDy1hFzvBj7nS4M4H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pxcbj3tRge1FWNw9/2ygTt4UKdFGuvWpTOj8SRvrRQ5h1rRVBzSqfZ2VoVpSOXsDaB2qgVkTmMdeAF8ywqgXKFuMAzPzv8OjPqchKDR4DtaodU2xFuSvlF2OuJxFWAQl6b/yChsMxyq2N0t8KR2nDrEdGKZW7LiVMrdNVDFhOXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QrF9OMvH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QrF9OMvH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tdSwEzLx5yxDC1ER/EWSsEzOAavut3NOw/6vQjHejNs=; b=QrF9OMvHDDbSdKnEUnGNqZyXib
	/GNB9kW49zT6B3GPvgvdrgT1jeOQ0Dlrh9NgESMhZz9tzHr5o1hSPYKPUoztbHL5zxSf4Lts/Eo27
	93YalR7Al79u0t6xtUYtWT3jHsgOVlLSiwFjTazDlQVfHoRxt/fULVb0a+6GkqrH5IxEAxHdHbECi
	bjKUTbv07X85ImxgNE9K9RNGdJQ60U4FrmvZ4pgeWY08slmc7LZKVAF1th5nDkNJjh2zueH1/Y2vF
	lwciNpYDnlp91pK/oNyblpvjJzJ2VxfBhPpct2qqWk0TGUi/dAZ8Ta1irwowM5fq0WXN0Gi8eN7kc
	uXQk/k6g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOrMg-00000005pOo-32Tw;
	Tue, 10 Jun 2025 05:17:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 17/17] xfs: move struct xfs_log_vec to xfs_log_priv.h
Date: Tue, 10 Jun 2025 07:15:14 +0200
Message-ID: <20250610051644.2052814-18-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250610051644.2052814-1-hch@lst.de>
References: <20250610051644.2052814-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The log_vec is a private type for the log/CIL code and should not be
exposed to anything else.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.h      | 12 ------------
 fs/xfs/xfs_log_priv.h | 12 ++++++++++++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index c4930e925fed..0f23812b0b31 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -9,18 +9,6 @@
 struct xlog_format_buf;
 struct xfs_cil_ctx;
 
-struct xfs_log_vec {
-	struct list_head	lv_list;	/* CIL lv chain ptrs */
-	uint32_t		lv_order_id;	/* chain ordering info */
-	int			lv_niovecs;	/* number of iovecs in lv */
-	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
-	struct xfs_log_item	*lv_item;	/* owner */
-	char			*lv_buf;	/* formatted buffer */
-	int			lv_bytes;	/* accounted space in buffer */
-	int			lv_buf_used;	/* buffer space used so far */
-	int			lv_alloc_size;	/* size of allocated lv */
-};
-
 /* Region types for iovec's i_type */
 #define XLOG_REG_TYPE_BFORMAT		1
 #define XLOG_REG_TYPE_BCHUNK		2
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 17bbe69655a4..1c72ce78594c 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -28,6 +28,18 @@ struct xfs_log_iovec {
 	uint16_t		i_type;	/* type of region (debug only) */
 };
 
+struct xfs_log_vec {
+	struct list_head	lv_list;	/* CIL lv chain ptrs */
+	uint32_t		lv_order_id;	/* chain ordering info */
+	int			lv_niovecs;	/* number of iovecs in lv */
+	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
+	struct xfs_log_item	*lv_item;	/* owner */
+	char			*lv_buf;	/* formatted buffer */
+	int			lv_bytes;	/* accounted space in buffer */
+	int			lv_buf_used;	/* buffer space used so far */
+	int			lv_alloc_size;	/* size of allocated lv */
+};
+
 /*
  * get client id from packed copy.
  *
-- 
2.47.2


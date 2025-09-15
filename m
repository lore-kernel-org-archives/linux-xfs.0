Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04603313297
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942832; cv=none; b=W/O0kk8TGwj1dwZsakZs+iNF1dtehpwmWeg9snC8+suE6SwTx9a78iD7I03Z8y0sc4I6yP6f65UjNwcvC0Ei5zmqOEEYx+mCbFGLiV+kugMICLH4NXeItsMMnfeHkWsq5M8TJ9348ejnp/olMV6UAB/B9MA8zLEOnC5u5JimuNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942832; c=relaxed/simple;
	bh=hRdgndJDNAzTYtf6SQI0d1k4dPyZFvcNNG2OS4/f9BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bapiOdfVSZYjMvYOtVNMKmOYcPDxa8Z8X4ly8MdoCIvExpfOeS4bOExnYwoPKsHV/dHnnqjn8rDu4d7UzIvpArotUNEfwlLXhGZOzPsKg4IzPERiSDaWID5L3LzXW1+WBCgLSeMYDe92IsivzjmUTlboujTRs4Aect6KoYBYV7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jEXgs2IB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jEXgs2IB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=056jlf0bKqOLcLxLlQvLimo17wx/qgEm8Zb8nfB1S94=; b=jEXgs2IBPrak5f5QaxK8OfbJ3o
	46Nc9G3W2QkW8nZKZgG3XY2KzQ6wpdxdo5xUS+Sbu4qj/DPz3JKo/pc5R1Cc48+A3OLu8t/LO+Ng3
	kMgXj4gVv3kg12auwhw+jg7yoKi6yNQubVTltiUiKeBqVsvzqAF1S2WX9vpPd2SDcGaxsd4bEN5qI
	iFoGI5a33fLJra2F4WYv0faqAXj0ATYsHGZ5sR9UyqhP2ZBnNYIvdmmWcUKuNLwhg1oPoHWcEfrEa
	ersDp+4pmf9j97Wp/X8GIdTjZPn/eoR0waeXBFqBk6TxK7Q+PUWOnfmIhE/P+kwCxRc1YG8KbjZQM
	W+rzIEFQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ec-00000004JaI-2ge5;
	Mon, 15 Sep 2025 13:27:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 03/15] xfs: remove the xfs_extent_t typedef
Date: Mon, 15 Sep 2025 06:26:53 -0700
Message-ID: <20250915132709.160247-4-hch@lst.de>
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

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Also fix up the comment about the struct xfs_extent definition to be
correct and read more easily.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 8f208e93ec3b..2cfbadae3f53 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -596,16 +596,17 @@ xfs_blft_from_flags(struct xfs_buf_log_format *blf)
 /*
  * EFI/EFD log format definitions
  */
-typedef struct xfs_extent {
+struct xfs_extent {
 	xfs_fsblock_t	ext_start;
 	xfs_extlen_t	ext_len;
-} xfs_extent_t;
+};
 
 /*
- * Since an xfs_extent_t has types (start:64, len: 32)
- * there are different alignments on 32 bit and 64 bit kernels.
- * So we provide the different variants for use by a
- * conversion routine.
+ * Since the structures in struct xfs_extent add up to 96 bytes, it has
+ * different alignments on i386 vs all other architectures, because i386
+ * does not pad structures to their natural alignment.
+ *
+ * Provide the different variants for use by a conversion routine.
  */
 typedef struct xfs_extent_32 {
 	uint64_t	ext_start;
@@ -628,7 +629,7 @@ typedef struct xfs_efi_log_format {
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_t		efi_extents[];	/* array of extents to free */
+	struct xfs_extent	efi_extents[];	/* array of extents to free */
 } xfs_efi_log_format_t;
 
 static inline size_t
@@ -681,7 +682,7 @@ typedef struct xfs_efd_log_format {
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_t		efd_extents[];	/* array of extents freed */
+	struct xfs_extent	efd_extents[];	/* array of extents freed */
 } xfs_efd_log_format_t;
 
 static inline size_t
-- 
2.47.2


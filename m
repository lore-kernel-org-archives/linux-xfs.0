Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D8B235041
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323367; cv=none; b=JS0DDYI3I11BK8RUM1M9O0UVh+9rPe33vxIE8CFwnCtR2ggEVCJRhqRWZh+lufgs1p25sfUN042jn1AHwCZSG2OTSlF/PXmjGJffrOERxwjmYP+lG2GQwiLI3DG1122y5CwAD8Ni63AlmWxwW2H0hCwDA69X3TcLzFGV14NN3cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323367; c=relaxed/simple;
	bh=UAGHay3EyEb79+jDCtAzjbpFURIHPoHTct76jTN7Cb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbYCm1nrwkHDbB4aQpQ7PLXU9oPUAoT+irKwo9kXAw3/hzk0VBiQs7Kbek7ZqdTMHjsRmUvLxozVNs7OABjApXFgWQOuyKVdWi19yxVeYgu+ZVOzfDncqrGhqV/Nj6tld0cWSVD4Pm7rtK7TIVAKjaAGyTzOepmxeVdCxn2sbtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jPF741o0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jPF741o0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=r5tY5W4BRMS4mtcGD7/YQv3CEaiRpm1FyeqQtHDas/A=; b=jPF741o0/L3z9ilklpLyCu6n04
	erkT8WMGNQG8SgUa0aNsdtNGK1xkccMIWEEYSRi88t1p67z07gNkQpIBCO1vvY3E2eSTafy37rEYo
	eU2Hj0Z+bFeF1ZDifLzZc0FhjgLk+E9v17rtlkesGqNaNnHN9GRMcYd3QiIncdoKjrdOBFlVvzgjm
	3nd54caw4nxWpY1hJmLgF6CWyhZ4NH4NekMrzpaAnEFZmDaUHhI/R3k38EdKn4HYMURdjBP/uQyeS
	avGKe3+IvvEQ9VaznSaOAozxFzyz8bOVtQh9jy8qvgwBwI+YAfu45Xolaf0tenQtuJJWfw0P/xdmN
	HGYS6Q9w==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88WL-0000000C7Fq-0lCD;
	Mon, 13 Oct 2025 02:42:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: cleanup xlog_alloc_log a bit
Date: Mon, 13 Oct 2025 11:42:08 +0900
Message-ID: <20251013024228.4109032-5-hch@lst.de>
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

Remove the separate head variable, move the ic_datap initialization
up a bit where the context is more obvious and remove the duplicate
memset right after a zeroing memory allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d9476124def6..3bd2f8787682 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1367,7 +1367,6 @@ xlog_alloc_log(
 	int			num_bblks)
 {
 	struct xlog		*log;
-	xlog_rec_header_t	*head;
 	xlog_in_core_t		**iclogp;
 	xlog_in_core_t		*iclog, *prev_iclog=NULL;
 	int			i;
@@ -1461,22 +1460,21 @@ xlog_alloc_log(
 				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 		if (!iclog->ic_header)
 			goto out_free_iclog;
-		head = iclog->ic_header;
-		memset(head, 0, sizeof(xlog_rec_header_t));
-		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
-		head->h_version = cpu_to_be32(
+		iclog->ic_header->h_magicno =
+			cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
+		iclog->ic_header->h_version = cpu_to_be32(
 			xfs_has_logv2(log->l_mp) ? 2 : 1);
-		head->h_size = cpu_to_be32(log->l_iclog_size);
-		/* new fields */
-		head->h_fmt = cpu_to_be32(XLOG_FMT);
-		memcpy(&head->h_fs_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
+		iclog->ic_header->h_size = cpu_to_be32(log->l_iclog_size);
+		iclog->ic_header->h_fmt = cpu_to_be32(XLOG_FMT);
+		memcpy(&iclog->ic_header->h_fs_uuid, &mp->m_sb.sb_uuid,
+			sizeof(iclog->ic_header->h_fs_uuid));
 
+		iclog->ic_datap = (void *)iclog->ic_header + log->l_iclog_hsize;
 		iclog->ic_size = log->l_iclog_size - log->l_iclog_hsize;
 		iclog->ic_state = XLOG_STATE_ACTIVE;
 		iclog->ic_log = log;
 		atomic_set(&iclog->ic_refcnt, 0);
 		INIT_LIST_HEAD(&iclog->ic_callbacks);
-		iclog->ic_datap = (void *)iclog->ic_header + log->l_iclog_hsize;
 
 		init_waitqueue_head(&iclog->ic_force_wait);
 		init_waitqueue_head(&iclog->ic_write_wait);
-- 
2.47.3


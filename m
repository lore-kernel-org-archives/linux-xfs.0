Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1532E4C92
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 05:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724735033; cv=none; b=jUOuNuMR5CVeO3IZVG6DCXzFUEcjy8jWsYO2mAtOn/wz0I/IBJDyQ/MlseP1XthbQe1WUfuE3mK73FUqdpNo7evbBoAGMBH3NY2NKqDKkmg45Fgs+qyDqTJILuCwzYXGCwPh8Horpkzfy7pVaF4pzOhpbmIrVUUjCfXFgTBQjX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724735033; c=relaxed/simple;
	bh=X2VSgjGiVcNtm+aHYMt7fkAi0R/RDip9UQxklpq1YRg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hJq9guMQHNsjCDpLLyczglRPiXXWdDNmCXbu38TUrd0rUf0HrJKwWMnI17oVhx43KMYvngmPevMwxxFfSi+EBJGTa/4JSiIcZJlaXw+6mXeEJ5lIf9IwRsWqLn8tzCzKbwrZkm4llMa27GI51icW1B6K34w3RMu5EH04Hx1D9aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eEv+RAfJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eEv+RAfJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=RCEM1RaUT2jn8eG/V+Q6bA4fL12WI9+F5GOeS3dmbxY=; b=eEv+RAfJzkcS8JYu23voFn28+m
	1wRUWiUZB6WNn1H/BxmOhBL7aCGBvE5oWKmL+jLdXbkGSmw1toKXmIhYDxxivHeKzZHa2Fj9AM8Tc
	oDtcOhdgHizMCodu82sM0oL1xDvmZZEzc7tqITvVRHCOB/7nNtGbrvLs+tyBvA4B/2+FyhuJji0oA
	dgRaI7RGQHN2dzUQkU2MKHfzk3VjLlbHV6dAKSH5/qS2jOu99lwHACwtGICudRsTtdrfmTuUEIB3h
	WTauy+nzbKMXBPeBDXaKNAmHu3VeLHTPTCUUIOlVeem1R0PVBc4AVsi9d89k7XdkFaem/ls60JRN4
	1ynakmEA==;
Received: from 2a02-8389-2341-5b80-0483-5781-2c2b-8fb4.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:483:5781:2c2b:8fb4] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sioMw-00000009nul-3ZE2;
	Tue, 27 Aug 2024 05:03:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3] xfs: ensure st_blocks never goes to zero during COW writes
Date: Tue, 27 Aug 2024 07:03:21 +0200
Message-ID: <20240827050345.1750476-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

COW writes remove the amount overwritten either directly for delalloc
reservations, or in earlier deferred transactions than adding the new
amount back in the bmap map transaction.  This means st_blocks on an
inode where all data is overwritten using the COW path can temporarily
show a 0 st_blocks.  This can easily be reproduced with the pending
zoned device support where all writes use this path and trips the
check in generic/615, but could also happen on a reflink file without
that.

Fix this by temporarily add the pending blocks to be mapped to
i_delayed_blks while the item is queued.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---

Changes since v2:
 - even better comments!

Changes since v1:
 - slightly more and slightly improved comments

 fs/xfs/libxfs/xfs_bmap.c |  1 +
 fs/xfs/xfs_bmap_item.c   | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 88c62e1158ac73..685a3278878ada 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4895,6 +4895,7 @@ xfs_bmapi_remap(
 	}
 
 	ip->i_nblocks += len;
+	ip->i_delayed_blks -= len; /* see xfs_bmap_defer_add */
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (ifp->if_format == XFS_DINODE_FMT_BTREE)
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 9a7e97a922b6d3..43be8e04cf0ead 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -357,6 +357,17 @@ xfs_bmap_defer_add(
 	trace_xfs_bmap_defer(bi);
 
 	xfs_bmap_update_get_group(tp->t_mountp, bi);
+
+	/*
+	 * Ensure the deferred mapping is pre-recorded in i_delayed_blks.
+	 *
+	 * Otherwise stat can report zero blocks for an inode that actually has
+	 * data when the entire mapping is in the process of being overwritten
+	 * using the out of place write path. This is undone in xfs_bmapi_remap
+	 * after it has incremented di_nblocks for a successful operation.
+	 */
+	if (bi->bi_type == XFS_BMAP_MAP)
+		bi->bi_owner->i_delayed_blks += bi->bi_bmap.br_blockcount;
 	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
 }
 
@@ -381,6 +392,9 @@ xfs_bmap_update_cancel_item(
 {
 	struct xfs_bmap_intent		*bi = bi_entry(item);
 
+	if (bi->bi_type == XFS_BMAP_MAP)
+		bi->bi_owner->i_delayed_blks -= bi->bi_bmap.br_blockcount;
+
 	xfs_bmap_update_put_group(bi);
 	kmem_cache_free(xfs_bmap_intent_cache, bi);
 }
@@ -478,6 +492,9 @@ xfs_bui_recover_work(
 	bi->bi_owner = *ipp;
 	xfs_bmap_update_get_group(mp, bi);
 
+	/* see xfs_bmap_defer_add for details */
+	if (bi->bi_type == XFS_BMAP_MAP)
+		bi->bi_owner->i_delayed_blks += bi->bi_bmap.br_blockcount;
 	xfs_defer_add_item(dfp, &bi->bi_list);
 	return bi;
 }
-- 
2.43.0


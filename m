Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C23EEB1
	for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2024 03:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724470700; cv=none; b=JVW1pS6mVln4iBo64nrJurQtAH3fKEGVClbMxUYdjEKdxm2XkaFcjpPa/+KYIotVrYdCuoltwj3PZM5pyjOmt9e7dzICnbOkZRb+CE0GSqzTkOcx87Lz1BC8r8d0u1hQRNW+ccWkEEJbNWlGHPJ49WqmubEUOxVRNMNC7cVN7us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724470700; c=relaxed/simple;
	bh=dyLdYjkzfaTx8yMFSK9zFw7A/Kzzn1KzWINaRzitsJI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TkazDiiQQtNKlqYn2U8Z1CIS44sbrGFMvgDVu19uiZuE1qQeHpeW2pYHFpDPXe2sSndgM3y0046aXjwJaU6azw7dYFAibc27PMHXSKQ2/d/dF0ylJ9XS6GR9yt8SFpq4km22MWljhldxgyNMXFODiEAONdbOwe35JxQVKbLNqyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dMcTHJ7s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dMcTHJ7s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=GaC3l0JrbyxMPSHJVFxge44EH7mUGacgrtokh1cdkE0=; b=dMcTHJ7sFJwk6LxdAK1VbFZwYD
	v2+DUSLCUpezQJhiBoZK24r3foDO0XU/XqG+x5xICVm864YusALqsLbaSKVx2HQP/4nazCBva0X9H
	Tjbmx5I0bUPBpXfGrvqfq5SooBUB6VS5NY4xulI4jF2cjQIRa83h37/ZPNF9MPTZ+7ew2FAxfapmA
	ru+Gm/vgGKih1ZxY5wyREzrzjDjZHrSpOs9SyHuS1Q6F2QM/RY4O+wYvSrRLewZ4o9s0Amgp+3J/N
	Cuwr95R7VCKm9+Y0QcT83g088gV5dkA+Bs2HGepCKmBnZlaxsK6pFtfIcYzKAY4tES0R0xnt87Tkd
	EQ2ZSt4Q==;
Received: from 2a02-8389-2341-5b80-7457-864c-9b77-b751.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:7457:864c:9b77:b751] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shhbV-00000001Lv2-0YHx;
	Sat, 24 Aug 2024 03:38:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: ensure st_blocks never goes to zero during COW writes
Date: Sat, 24 Aug 2024 05:37:52 +0200
Message-ID: <20240824033814.1162964-1-hch@lst.de>
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
---

Changes since v1:
 - slightly more and slightly improved comments

 fs/xfs/libxfs/xfs_bmap.c |  1 +
 fs/xfs/xfs_bmap_item.c   | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7df74c35d9f900..177735c30d273a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4847,6 +4847,7 @@ xfs_bmapi_remap(
 	}
 
 	ip->i_nblocks += len;
+	ip->i_delayed_blks -= len; /* see xfs_bmap_defer_add */
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (ifp->if_format == XFS_DINODE_FMT_BTREE)
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e224b49b7cff6d..4b8838e5b5bebc 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -346,6 +346,18 @@ xfs_bmap_defer_add(
 	trace_xfs_bmap_defer(bi);
 
 	xfs_bmap_update_get_group(tp->t_mountp, bi);
+
+	/*
+	 * Ensure the deferred mapping is pre-recorded in i_delayed_blks.
+	 *
+	 * Otherwise stat can report zero blocks for an inode that actually has
+	 * data when the entire mapping is in the process of being overwritten
+	 * using the out of place write path. This is undone in after
+	 * xfs_bmapi_remap has incremented di_nblocks for a successful
+	 * operation.
+	 */
+	if (bi->bi_type == XFS_BMAP_MAP)
+		bi->bi_owner->i_delayed_blks += bi->bi_bmap.br_blockcount;
 	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
 }
 
@@ -367,6 +379,9 @@ xfs_bmap_update_cancel_item(
 {
 	struct xfs_bmap_intent		*bi = bi_entry(item);
 
+	if (bi->bi_type == XFS_BMAP_MAP)
+		bi->bi_owner->i_delayed_blks -= bi->bi_bmap.br_blockcount;
+
 	xfs_bmap_update_put_group(bi);
 	kmem_cache_free(xfs_bmap_intent_cache, bi);
 }
@@ -464,6 +479,9 @@ xfs_bui_recover_work(
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


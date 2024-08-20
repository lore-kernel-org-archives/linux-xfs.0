Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D696E1B3F33
	for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2024 16:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724171409; cv=none; b=lErIvIMh7jdBWcKIB6bj3gMW90Xcwxj7CdaAU5KEGnzOD5/zav32iqMYLja4L6C2ohp13qVfBv01eB41IgyINSyeArIh/3KTVp5sE4PNjzwA8qjUQTlDE7xGEkf4rqAqzoauwlbC3CVK9ZC24Rst72UqsFvkovOwCwIYTxdAdO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724171409; c=relaxed/simple;
	bh=i0IBfnKOqxfHeH/VPFLgBJZD/EoIuetWD+nsz3EJWro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QATxM2aOdrFIrGeTXmSY2W5peceIq3YUW+GwdfnLYqnkjPQTYXj0UYt80c5CxyCWDVG5tqTTx8oWF1l6aH222Zy9myagKkkzzvqMuPm0EQOW5vpVADEuWK1BkoB1pdscCfQWVdImX5JW7VxfHZPWsorkdDd/+r6y3BUpKYjg4YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I1a1xp0q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I1a1xp0q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=A766nnysYGfHmv/X8nVmQwznefM6ddjdSkJa1rXV9lk=; b=I1a1xp0qPaEwlV6eoQ/OgXRh1Q
	0OmGmpSxtc3+2Wf2dkx8j9SRNJtZLO/JEXXhUV1vIuV8iAhbDghbBXJYQB4sZSFnpWeyWXDzs/IUz
	OOunxwW44zM1PWuL+1vFCDZBpj532tFUUvbnrs1jumwkGDcbo52Zn87qXbVSJcnPqsnNfI9UGINm/
	jP7Ky/X3zSiqi4AJ6SIfTP/CVmZmFBaZyf39GTUuvTCBrCl8hTZtl12+qXCNsQZonCV4raSMVMWnp
	RzYOKOllWpCBGCntWrte4BKfAoPXoC91TpXb/I4syCc0tLEdr2j9DFDOvuRvVj4QAKfVVOADAsof3
	KlXA8IpQ==;
Received: from 2a02-8389-2341-5b80-6a7b-305c-cbe0-c9b8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:6a7b:305c:cbe0:c9b8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgRkC-000000060e6-0y0m;
	Tue, 20 Aug 2024 16:30:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: ensure st_blocks never goes to zero during COW writes
Date: Tue, 20 Aug 2024 18:29:59 +0200
Message-ID: <20240820163000.525121-1-hch@lst.de>
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
 fs/xfs/libxfs/xfs_bmap.c |  1 +
 fs/xfs/xfs_bmap_item.c   | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7df74c35d9f900..a63be14a9873e8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4847,6 +4847,7 @@ xfs_bmapi_remap(
 	}
 
 	ip->i_nblocks += len;
+	ip->i_delayed_blks -= len;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (ifp->if_format == XFS_DINODE_FMT_BTREE)
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e224b49b7cff6d..fc5da2dc7c1c66 100644
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
 
+	/* see __xfs_bmap_add for details */
+	if (bi->bi_type == XFS_BMAP_MAP)
+		bi->bi_owner->i_delayed_blks += bi->bi_bmap.br_blockcount;
 	xfs_defer_add_item(dfp, &bi->bi_list);
 	return bi;
 }
-- 
2.43.0


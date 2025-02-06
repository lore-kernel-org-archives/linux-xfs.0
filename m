Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293A922576D
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824352; cv=none; b=Z9DeEsSzw4Zmqc2gVEFArxDvHDNvjLWwEa3ge2AxypA2II6p3gTlncmZ6L3jCDucEjb6qr/Dj09k9LZaCJXKaLnDO/Hh/nrwIFlysxb+7g1VzT28F+GfCRgF86hErxk1rwMkPjWkWJeAc13YE1dGzcKOVQGWjOFcn3o0HhoY2Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824352; c=relaxed/simple;
	bh=CBiKvrlTDIyZpuh7vJZaMKl8HEOk2VJ5/voZoIQmH0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kICJG1uyva59FgP640pEQrC3LvZ7lpOM02PB+sEs9FfxUgVeHglkUIA74Ix4XcHWfmD3ZsycRJcQRS19RpAQQj+QDzU3tOCfC1BRlw9jM6IASx3PBgF6DVyHqA2xMPeyoVKLPNNAZhfM2J3NbE6/IhKkaPCtkh+5toHYgUK4cTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rKDZ7+1E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rKDZ7+1E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=irJ6u60SavdkNDrDJObnqvyZ6C2eUsa8TXIBxHY06JQ=; b=rKDZ7+1E7L9P9iOW4iuyAS80Vl
	FIPbRACyH6Q4a8ClxrW+PmiRYe9fxwx/CB/ZEQG46VfuFfD1Bs/hJb43CHmLuOVEQd1mzwV/dPuUZ
	Ao1sBVakigW83q+W0Ndy6CAph0oBidJfb0JS/sKKjY1SzPZw/EZAZD3JPYe3Xfl5QDysxxRXvbNlh
	xkh6CZTjeXVHOdBpWWy7RF1XS9s8M+G+SzjwgMAEsKfzgdN7sJTCouJN4NpM2A3HKLliXIgDy3lkr
	GyaGkMYE3S/mTrzrlmaRS/vAgZEZSF3bEqkTGe7Mny67GTmW4bLhGZvk1eyPXFS3g2eCVwjD9NnRL
	J4nb2Klg==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfve2-00000005QI3-2MeD;
	Thu, 06 Feb 2025 06:45:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/43] xfs: add a xfs_rtrmap_highest_rgbno helper
Date: Thu,  6 Feb 2025 07:44:29 +0100
Message-ID: <20250206064511.2323878-14-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper to find the last offset mapped in the rtrmap.  This will be
used by the zoned code to find out where to start writing again on
conventional devices without hardware zone support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c | 19 +++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index e4ec36943cb7..9bdc2cbfc113 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -1033,3 +1033,22 @@ xfs_rtrmapbt_init_rtsb(
 	xfs_btree_del_cursor(cur, error);
 	return error;
 }
+
+/*
+ * Return the highest rgbno currently tracked by the rmap for this rtg.
+ */
+xfs_rgblock_t
+xfs_rtrmap_highest_rgbno(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_btree_block	*block = rtg_rmap(rtg)->i_df.if_broot;
+	union xfs_btree_key	key = {};
+	struct xfs_btree_cur	*cur;
+
+	if (block->bb_numrecs == 0)
+		return NULLRGBLOCK;
+	cur = xfs_rtrmapbt_init_cursor(NULL, rtg);
+	xfs_btree_get_keys(cur, block, &key);
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return be32_to_cpu(key.__rmap_bigkey[1].rm_startblock);
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index 9d0915089891..e328fd62a149 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -207,4 +207,6 @@ struct xfs_btree_cur *xfs_rtrmapbt_mem_cursor(struct xfs_rtgroup *rtg,
 int xfs_rtrmapbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
 		struct xfs_buftarg *btp, xfs_rgnumber_t rgno);
 
+xfs_rgblock_t xfs_rtrmap_highest_rgbno(struct xfs_rtgroup *rtg);
+
 #endif /* __XFS_RTRMAP_BTREE_H__ */
-- 
2.45.2


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07F22376E4
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596250; cv=none; b=EXwK35SesATYwZkIF1EH+cti40Y8KzdAWdXjotnKnGzD1HCoUJu2aeC2r4rIwsiwaU2Jxz+WvU9wFZmSQPEbuDeOcDrVTelDMOGZH0uFZIk2BVDPfZj+UYGC4GOesKY3uAf+U/iRaUPLe01mhnX51uQETQq66dU77cn2QzM2DKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596250; c=relaxed/simple;
	bh=NIyqMY5iVnYLbLkRYaTsucMZEAbuyUHtwqK/F1GSJEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QB90Gfp7WlLCXCJLO6WorJ1Q86jc4YYalmGRmsvbIvw3cXOdASEaPH9fllH84QUjdWjmHtgNJK8+xaipLHo/IcaM01rC8Py88RaKYuhWNYO64DInDnjRh3ZXWdyFBw7KFOyx15zRY/QT9ILZRvPVXIs4OWeNmKm5pPe/NdKtsDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jSBQ8Boq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jSBQ8Boq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=e9mhtI+lYTrl3WN8yQlbPX5cBYoHK//jnbaHMD9Ba3M=; b=jSBQ8BoqEs8ll2l8gF4s2af1or
	tQIYhqjk1LOWgo3Ww9McwrB/sgtYe79lcIkz+WyKQoMLcLGGwfMm9+cO934Cq93fyi7YifRINQjyJ
	PinPsTIQBYGUdQdEgt80gJN8iCDt1mPXfaY7Z1w4iA8ek2HrS87wv2bloldIlnW+8vZBItuCBFLvx
	5zRfM/GpBBiI15RrZlvLcHaxdukgHziodZw0xv12UD7hEuKyzLEb9TlP9i+Ty2D3e9ayzfbCT77ii
	MYQOShkoo/KWIjzY1RE5s3bfdSludcEI3RnBdViB6K+1HO9DvMYEqEvkZOICAqwciW+ERB4NF9CDw
	JNC9FVNA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb2-000000053tL-2Hzm;
	Wed, 26 Feb 2025 18:57:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 14/44] xfs: add a xfs_rtrmap_highest_rgbno helper
Date: Wed, 26 Feb 2025 10:56:46 -0800
Message-ID: <20250226185723.518867-15-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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


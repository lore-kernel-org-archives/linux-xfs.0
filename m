Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220351E9B22
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907437; cv=none; b=R2lM6PgB5Y2is2VFOJlks0LmiZZ5LHCF7YLG/ikMk0MxkQ/g2HbAwcIyGbdXvU1womnA6Ygky9hL3ykt6GBdOCwmFPatiim/KO1eU31gwha/7x3QfoCRk4MbLsYX3A0tCe+pGiGpSsiCSAR1tr8aNo7sMGSCuhiqiONo8Gr2oxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907437; c=relaxed/simple;
	bh=lxyaYkNHQpoy/aQs1ynISSdnCyspvWfCM1QeB6lusWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJSNZfrszJIvqPTxDDzE3U3TZawIyzXZUVC4Ik590gTEC8PB5yw4IFV1W2jUn5P7AOuzGuJIzn6qMS0nzcVW7Yzh2YR4XQ9vQOnM/HVU9S1bLCIrXScioJCIyTJPmI+m7viED/ohfzicqdVwhh+tNo+W46Xkc3zFG75Goy5rx6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1z9HL5KL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1z9HL5KL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Lpo4cw9ZprDJhUXRHXttMjpTrRpHJvmr0NXUzAD3ZBQ=; b=1z9HL5KLPsU/85HVxu2HXYxOjQ
	6cSctTejL5CCkAVV2QGsjeOXTPMmOShmPplydrs9a4vPL+GtntKajBm21MatVTIbMXYRA0mfLIsow
	SsCz6m9Ju9wsf4qONjaaTNjLTRi9o6zGINP2AoB2Tf3SaiZ5P5UeB37qZ/g74qL48WubPOODmdBD1
	efl6hHTyxxV/a5sutwGdwjHzmq9KSoehhJjXWe7bNRuylDR1vscosGwUlzY8TX3D72UViDsVewkst
	ydItUnEAKHgnRMmXq4mk7byXC4AyGi5VX4XYXF9pnPAMHmHYmJhwas2Tz8V808Jdry20feXmomIgz
	uk6g0B0w==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIWx-0000000EJ8w-10Z3;
	Wed, 11 Dec 2024 08:57:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 14/43] xfs: add a xfs_rtrmap_first_unwritten_rgbno helper
Date: Wed, 11 Dec 2024 09:54:39 +0100
Message-ID: <20241211085636.1380516-15-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
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
 fs/xfs/libxfs/xfs_rtrmap_btree.c | 16 ++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 04b9c76380ad..b2bb0dd53b00 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -1033,3 +1033,19 @@ xfs_rtrmapbt_init_rtsb(
 	xfs_btree_del_cursor(cur, error);
 	return error;
 }
+
+xfs_rgblock_t
+xfs_rtrmap_first_unwritten_rgbno(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_btree_block	*block = rtg_rmap(rtg)->i_df.if_broot;
+	union xfs_btree_key	key = {};
+	struct xfs_btree_cur	*cur;
+
+	if (block->bb_numrecs == 0)
+		return 0;
+	cur = xfs_rtrmapbt_init_cursor(NULL, rtg);
+	xfs_btree_get_keys(cur, block, &key);
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return be32_to_cpu(key.__rmap_bigkey[1].rm_startblock) + 1;
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index 6a2d432b55ad..d5cca8fcf4a3 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -207,4 +207,6 @@ struct xfs_btree_cur *xfs_rtrmapbt_mem_cursor(struct xfs_rtgroup *rtg,
 int xfs_rtrmapbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
 		struct xfs_buftarg *btp, xfs_rgnumber_t rgno);
 
+xfs_rgblock_t xfs_rtrmap_first_unwritten_rgbno(struct xfs_rtgroup *rtg);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */
-- 
2.45.2


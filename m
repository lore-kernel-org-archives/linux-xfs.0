Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99A3259C
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185402; cv=none; b=hD4OshUIgzaZ6Zyv9lkK6JGmSdkXeFkPCgI122RFLY1IYNyB/tQl/oj1cr9eNf5TVQeM1GqX8FmERNLawhcgvennJ1ykjwHXbseCijCXOuc0t/QZbUI72x4YUamncWSLL1I1ooHwpxtHIke3DjaD+U8bLtY6s1APc3Xuc3JzDVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185402; c=relaxed/simple;
	bh=KgZ7o21jOf4KiZ2LhJ4a0o+WT9tkntsDKjqi9ELk5jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5B+JouHtgqjXfzee3/dKwvyD/dQU95npAmYAIFFZV+Mr/4zAmKIYqVOGnbwhhr65B6rxDg56p4/NrSmkxtGl6OTZT4+uZSfszupK18WG0YiGLpE48lqtSeOsJzg/hCWlUHwzQ9FRZdYGwds9GJlvRPprZLzEY3LyHUdT/90eeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f9HEGgtR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f9HEGgtR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=S5XbYM0w18boIVbHQHP9JdBVg3pwf0ctpK5x7B1XFZY=; b=f9HEGgtRdsHZuboThuASt/dquQ
	MPOhNpF3+ZOgOQa/wHw9WjSlQnUkdeZDkrcGV2sLkuQ4xlCLhZfAvnwLgHdevDFnXwNufQ15r+Dl1
	HMmAuhNTt0RUp7w1BY3n+g/mhmBH0rXwRr69/RjqnwtcsZNydnGdu1yZkpVkxRc7NBOw7CsPpVW6d
	u/Cw5cVJuf5uk23YOfIbLTsk788nMlpHkXi1yP8XJYO09vujXvh+NmVyKxQj+duDPCRn12MNO0F5g
	GmGUq5wetU5LNzQxTraOITIR+uYNWrwCNxg7PQpoW6egH0AhyVDaIjd3ODLljqdfOpmIZMcLKf63h
	TcpQM7uw==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QIZ-00000006UIZ-0FMW;
	Wed, 09 Apr 2025 07:56:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/45] xfs: add a xfs_rtrmap_highest_rgbno helper
Date: Wed,  9 Apr 2025 09:55:12 +0200
Message-ID: <20250409075557.3535745-10-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: aacde95a37160b1462e46e0fd0cc7fd70e3bf1cc

Add a helper to find the last offset mapped in the rtrmap.  This will be
used by the zoned code to find out where to start writing again on
conventional devices without hardware zone support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtrmap_btree.c | 19 +++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index d897d140efa7..d46fb67bb5d4 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -1032,3 +1032,22 @@ xfs_rtrmapbt_init_rtsb(
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
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index 9d0915089891..e328fd62a149 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -207,4 +207,6 @@ struct xfs_btree_cur *xfs_rtrmapbt_mem_cursor(struct xfs_rtgroup *rtg,
 int xfs_rtrmapbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
 		struct xfs_buftarg *btp, xfs_rgnumber_t rgno);
 
+xfs_rgblock_t xfs_rtrmap_highest_rgbno(struct xfs_rtgroup *rtg);
+
 #endif /* __XFS_RTRMAP_BTREE_H__ */
-- 
2.47.2


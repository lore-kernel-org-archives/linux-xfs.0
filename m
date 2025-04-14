Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0F32CCC1
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609023; cv=none; b=s1irXdIBrIqBNnGIC2AT643woJ06/hYbAa0kdVpr1Iw3paKVDMsx3mAvB+E5McToia9FAFXeEUlp5wLV64yrXXb4/XEEy6VTbVmFIbOl1ucyI3qCLKw0GbCahhXv8SE7Ld2ESNGfque+SY5C8vP8uwOrkpLRLMkF8vNU9GynWJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609023; c=relaxed/simple;
	bh=KgZ7o21jOf4KiZ2LhJ4a0o+WT9tkntsDKjqi9ELk5jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGw8XAzi2sUqQo4z4YXctjRyEKVJZI9QctKJ/Mk9idORM6qTQogIeE7hOCCBNMzCgxOS6UdD3TbAHJ4HLi4ZaAAvoH9bql2Ykf3wodY702mgAxsgRb8aUhaS/C+j4DuBzWzL+rZFA5gUg10Aa0j0VBk33W3qaRJczxnpi5CJoKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FD14RYY1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FD14RYY1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=S5XbYM0w18boIVbHQHP9JdBVg3pwf0ctpK5x7B1XFZY=; b=FD14RYY1zXrHyfnraj0WmXhg/Z
	JWt6F8iq24djoN4c5IF902+IkRsz0/541SispwwBpNYcw1E0vPtT369dg58omNzqHodL4pwRsCjqe
	pyKrRxWzKCAJJl5SdMQXGaxj9eaA5JIwc6tCFTAVEebvcJAlvAb6ES8XL3eXnmZ9nxlRs/Ajemdkn
	pl6GuURybV5D+QmGgmyAGWHwpyYO09+C3TVKRSutDfKu9BYlvZYW4smauyzX6VGr7+hwqxkqmjhbY
	Y3fMIUUI4NXomhccmWmhcztd/1EPECh11peAsKCZe+u46O9SLJab12JgA76oS2vZetqjkphvpfV1/
	Eq9jqZOQ==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVA-00000000iB0-3B3V;
	Mon, 14 Apr 2025 05:37:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/43] xfs: add a xfs_rtrmap_highest_rgbno helper
Date: Mon, 14 Apr 2025 07:35:52 +0200
Message-ID: <20250414053629.360672-10-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
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


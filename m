Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7195E45BF2
	for <linux-xfs@vger.kernel.org>; Sun, 17 Dec 2023 17:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wa0XmuUW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/PKTFjLAO4s0BreW/xg/xYX0Dm2saVh9g9jMjZZNh2M=; b=Wa0XmuUWs3XM1QBh8aGW9asnmC
	MoimO7wF6vda+xmDWAYNdtvnFFdn+rto7uKUIvBzV8eIPb73I9gW2KKRCvM6u6r4i5qqd8QR4DQJg
	Uxo5O4OvrVyMl/nHtKYQt0i42VNPaVj5dm0P+JPvdvKxRVpitpxw4AfYiWmfHfMZG26OEEJAjCodL
	0z+jhXyd9/IIn6t2JoYR4nAE/J/Ty9MX3Cy6pNmIlOnCGJn7/VexP2SLwWlj7rLjOaGuTFpLL1ssE
	/TLglt4Jut4vYXtZyPyaYHvY9sB5m3E9xLk4Ncmmzresd7OY7+HxNqkTEjiITrOOuqytL5pCJg6U1
	hQd/OJpw==;
Received: from [88.128.92.84] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rEuYp-008AJq-1u;
	Sun, 17 Dec 2023 17:04:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] xfs: remove xfs_attr_sf_hdr_t
Date: Sun, 17 Dec 2023 18:03:50 +0100
Message-Id: <20231217170350.605812-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231217170350.605812-1-hch@lst.de>
References: <20231217170350.605812-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Remove the last two users of the typedef and move the comment next to
its declaration to a more useful place.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 4 ++--
 fs/xfs/libxfs/xfs_attr_sf.h   | 8 --------
 fs/xfs/libxfs/xfs_da_format.h | 5 ++++-
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index e1281ab413c832..6374bf10724207 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -816,7 +816,7 @@ xfs_attr_sf_removename(
 	/*
 	 * Fix up the start offset of the attribute fork
 	 */
-	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
+	if (totsize == sizeof(struct xfs_attr_sf_hdr) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
 	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
 		xfs_attr_fork_remove(dp, args->trans);
@@ -824,7 +824,7 @@ xfs_attr_sf_removename(
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
 		dp->i_forkoff = xfs_attr_shortform_bytesfit(dp, totsize);
 		ASSERT(dp->i_forkoff);
-		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
+		ASSERT(totsize > sizeof(struct xfs_attr_sf_hdr) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!xfs_has_attr2(mp) ||
 				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
index a1d5ef88ca2673..0600b4e408fa36 100644
--- a/fs/xfs/libxfs/xfs_attr_sf.h
+++ b/fs/xfs/libxfs/xfs_attr_sf.h
@@ -6,14 +6,6 @@
 #ifndef __XFS_ATTR_SF_H__
 #define	__XFS_ATTR_SF_H__
 
-/*
- * Attribute storage when stored inside the inode.
- *
- * Small attribute lists are packed as tightly as possible so as
- * to fit into the literal area of the inode.
- */
-typedef struct xfs_attr_sf_hdr xfs_attr_sf_hdr_t;
-
 /*
  * We generate this then sort it, attr_list() must return things in hash-order.
  */
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 650fedce40449e..dcfe2fe9edc385 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -578,7 +578,10 @@ xfs_dir2_block_leaf_p(struct xfs_dir2_block_tail *btp)
 #define XFS_ATTR_LEAF_MAPSIZE	3	/* how many freespace slots */
 
 /*
- * Entries are packed toward the top as tight as possible.
+ * Attribute storage when stored inside the inode.
+ *
+ * Small attribute lists are packed as tightly as possible so as
+ * to fit into the literal area of the inode.
  */
 struct xfs_attr_sf_hdr {	/* constant-structure header block */
 	__be16	totsize;	/* total bytes in shortform list */
-- 
2.39.2


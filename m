Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B4E23C384
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881950; cv=none; b=bBRBikqxJVFoRnD5/JFJKr6Fl2nKUR2flFrNx3RVDvjErIwbzCSyi9PzspzO1x4c0zCzdn656Fam3FwXDkKBiWTxTpOvzu5wOOYRwFcNS67FMfj1ahiuhIv4z21+Im/kY9vRsuVSqueb3FGBZed5BdwcJsB6g6kgKwLAz2VJFvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881950; c=relaxed/simple;
	bh=W3CBrb0aAAfY/9fa2y55/y7A9S/yjftbiBZwAmgz+CQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g85zQXI4yUGU45VfEyVDy72FQiyktMFUBKDW+kzOcqNGrELlvr2Xel/9PYbFcEPkPmbC+TMkGd6Lx9q1vlKw/QsxgGK+FXKqpz0j1FGZwElkSVe95U9Qbf1pS61LOGsCJHLrVj1nPvqEWCVKhkRbXL0J2xw9uGr7OwOBmqC/v9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ht6WZwpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ht6WZwpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D214BC4CEDD;
	Thu,  6 Feb 2025 22:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881949;
	bh=W3CBrb0aAAfY/9fa2y55/y7A9S/yjftbiBZwAmgz+CQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ht6WZwpPccZuO6SIBkwcMR9RhsCnTyAgt0cFJO2tk8Gg8nV8SSFNTvB5GVOSBHbCL
	 JnQlNDkQJly1vj8kGDnRSs/RbG9F4ScjEL+Qzsmhzta80uYSQq2CN2mKpycGT2mLZU
	 NsAvMxoax2+pd6+uWyS9CfNccMLZRN/P7oFOfpeAo0POr1OgfsmiVQ0RXGWdrH9MqJ
	 WKI2XGe7ZHekJ7UF+muHZJtKv8owgwX7/D8W9KTCWCSBfZONCheED2UI3yPdEnf5wu
	 ZJgDQWDL0n95jnT6I7ygVuT1Gvq8jA9Q8Yi/hToZ53zNi0l8Gd+pdEP+YyWqEa9eMO
	 YYMe7VsAqZxhg==
Date: Thu, 06 Feb 2025 14:45:49 -0800
Subject: [PATCH 41/56] xfs: create routine to allocate and initialize a
 realtime refcount btree inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087419.2739176.1762271506514147391.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 4ee3113aaf3f6a3c24fcf952d8489363f56ab375

Create a library routine to allocate and initialize an empty realtime
refcountbt inode.  We'll use this for growfs, mkfs, and repair.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtgroup.c          |    2 ++
 libxfs/xfs_rtrefcount_btree.c |   28 ++++++++++++++++++++++++++++
 libxfs/xfs_rtrefcount_btree.h |    3 +++
 3 files changed, 33 insertions(+)


diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index e1f853dd2c5b3e..74701264265ce2 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -31,6 +31,7 @@
 #include "xfs_metafile.h"
 #include "xfs_metadir.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 /* Find the first usable fsblock in this rtgroup. */
 static inline uint32_t
@@ -379,6 +380,7 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 		.fmt_mask	= 1U << XFS_DINODE_FMT_META_BTREE,
 		/* same comment about growfs and rmap inodes applies here */
 		.enabled	= xfs_has_reflink,
+		.create		= xfs_rtrefcountbt_create,
 	},
 };
 
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index cf9f2ee5314dda..fa6c114d9cbc5a 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -719,3 +719,31 @@ xfs_iflush_rtrefcount(
 			ifp->if_broot_bytes, dfp,
 			XFS_DFORK_SIZE(dip, ip->i_mount, XFS_DATA_FORK));
 }
+
+/*
+ * Create a realtime refcount btree inode.
+ */
+int
+xfs_rtrefcountbt_create(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip,
+	struct xfs_trans	*tp,
+	bool			init)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_btree_block	*broot;
+
+	ifp->if_format = XFS_DINODE_FMT_META_BTREE;
+	ASSERT(ifp->if_broot_bytes == 0);
+	ASSERT(ifp->if_bytes == 0);
+
+	/* Initialize the empty incore btree root. */
+	broot = xfs_broot_realloc(ifp,
+			xfs_rtrefcount_broot_space_calc(mp, 0, 0));
+	if (broot)
+		xfs_btree_init_block(mp, broot, &xfs_rtrefcountbt_ops, 0, 0,
+				ip->i_ino);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE | XFS_ILOG_DBROOT);
+	return 0;
+}
diff --git a/libxfs/xfs_rtrefcount_btree.h b/libxfs/xfs_rtrefcount_btree.h
index e558a10c4744ad..a99b7a8aec8659 100644
--- a/libxfs/xfs_rtrefcount_btree.h
+++ b/libxfs/xfs_rtrefcount_btree.h
@@ -183,4 +183,7 @@ void xfs_rtrefcountbt_to_disk(struct xfs_mount *mp,
 		struct xfs_rtrefcount_root *dblock, int dblocklen);
 void xfs_iflush_rtrefcount(struct xfs_inode *ip, struct xfs_dinode *dip);
 
+int xfs_rtrefcountbt_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
+		struct xfs_trans *tp, bool init);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C10D7E76D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995412; cv=none; b=nOuj/C5JNajefrN9a+D4ZEVwakmGWBp333VGsDCwddX1xUTY901unLkE1LXcqDDgiaE6g+QE2TDQEDf/jef9KXj6SwjTPZMfEoQyBaMk7PCIZMwN0ZVZQWjf2IGE7qoMFADBGlJ2AHJcuNBU9Kz2vKgS+hWoHhXXtLD0bSWK/2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995412; c=relaxed/simple;
	bh=MWUsJf5LAwVnADKP8zAqai6EORpjE/kmaFcm+GMTHOw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CHGGnIYg1KHjfMVa0fM51YkosuBVtO8UC4gxQC46elRF4Nz+ZckgNBji/Kq45ehTeN5Tk+aJZdmT54cNHU3uBLslVwAdrEqEXnVoiKdHvHZLyNIMq3WD59BT/LvCeHg6a2Q6/CJunwcmhOfJEV7y+nI3G7X5AS8HERwMphEx3UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UIHP7klh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UIHP7klh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F42BC4CED3;
	Mon, 23 Dec 2024 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995412;
	bh=MWUsJf5LAwVnADKP8zAqai6EORpjE/kmaFcm+GMTHOw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UIHP7klhbDuOqg51wvRbvMSn6s96peFcfe49ahO6d+ur0o0Q93fyGPuPMEeq5yQqL
	 SKSxDmY7GLE776D0ROZ7RevLu0x2xNH4hGXcI+YGfxoFHRLlU00/zKFZwOvn56R2s3
	 koZ/zYg5t+IZwqwegQ4J1sxz3cTPktmSagSLxArJGaN6WwSPxLLSnPj1ABhBzOJ6ZT
	 4i98yI+F7sGLJm0LVaALrmsX8kUifwgKnbsJ6b/tEOk4h3HY19aBj71jVrrpixbIrA
	 RZs8gfNlOaSC2iG1kIqj5+ayYUVoVkYr3DoG2neDbpGAc4NdOVlxj/qbBJ3aEA0TI+
	 o+roH2JDALh1g==
Date: Mon, 23 Dec 2024 15:10:11 -0800
Subject: [PATCH 15/43] xfs: create routine to allocate and initialize a
 realtime refcount btree inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420197.2381378.14899771666219743645.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a library routine to allocate and initialize an empty realtime
refcountbt inode.  We'll use this for growfs, mkfs, and repair.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtgroup.c          |    2 ++
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   28 ++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |    3 +++
 3 files changed, 33 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index d5ecc2f6c5c202..eab655a4a9ef5c 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -34,6 +34,7 @@
 #include "xfs_metafile.h"
 #include "xfs_metadir.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 /* Find the first usable fsblock in this rtgroup. */
 static inline uint32_t
@@ -382,6 +383,7 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 		.fmt_mask	= 1U << XFS_DINODE_FMT_META_BTREE,
 		/* same comment about growfs and rmap inodes applies here */
 		.enabled	= xfs_has_reflink,
+		.create		= xfs_rtrefcountbt_create,
 	},
 };
 
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 6a5bc7ea42fbe6..151fb1ef7db126 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -721,3 +721,31 @@ xfs_iflush_rtrefcount(
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
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
index e558a10c4744ad..a99b7a8aec8659 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -183,4 +183,7 @@ void xfs_rtrefcountbt_to_disk(struct xfs_mount *mp,
 		struct xfs_rtrefcount_root *dblock, int dblocklen);
 void xfs_iflush_rtrefcount(struct xfs_inode *ip, struct xfs_dinode *dip);
 
+int xfs_rtrefcountbt_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
+		struct xfs_trans *tp, bool init);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */


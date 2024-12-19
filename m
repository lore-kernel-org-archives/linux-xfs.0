Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9441AAA0D
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636454; cv=none; b=fEvNfGYHwaSNV3AfF4PCNl/N5tBfLjzuDttatwpB8Yp6tCk2Z6QHKKZktsL8likROEUaO/gJ9TR8wBlwMpiGSo9VDwIpDxF7M7YD0zALmDnaLC3SL2AC9hXQMzB7ZEvsHegKP7oInhsMiH+IuwSNO2z1KIpqf6i95N3aS2oJoTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636454; c=relaxed/simple;
	bh=ZSPfxE2avR4ld1jRuhBWz4WdYQP0D+Vvn5kLrfSWbVs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=indlZZzPzdIHl1bVWESawxMswhkgLg5kLeAIyXj9R+HfUaQZNsEKg8OHbz0XryHiT6z5PhWQOrdhwEuuLqTIdKiD2GkjGkxLO/yRDhi7r56hDCN3BLNaht863OC8g7x+lpT3Q+2DNwllClJhZe8WbypRvOFEPgjeUEGXTaNwXyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bglOPpua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bglOPpua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0EFC4CECE;
	Thu, 19 Dec 2024 19:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636454;
	bh=ZSPfxE2avR4ld1jRuhBWz4WdYQP0D+Vvn5kLrfSWbVs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bglOPpua9f/gA55ddehVvc8AKa/debiX5Ysm2LBqU48P6G1KlM/eDDfthb0jAtUKu
	 hbP1JWXzqj8FQfaeoA67/QWTxQxRRVKNWoNPJUBmas36qKwbLeNRYmX6AalIME52NG
	 VFsz9Bs99vZHPCizxWEfvy0mC2aq393zyYELQ5Un3R03SVpXfQSKScmgejG//JwqnA
	 ET2gopQLOrrQae+SmM62IzI0niOB3hP1EP//MJxqpUyHNlHFctmXqYxsytJGDQcZr2
	 IubNpwVrcupecDAsxMZUZaRiDe8qgAHhMrs/SrnOtJbPFnjAGuYO5I4gu8Jx/6M6S8
	 OsRTxF+ZE/EJg==
Date: Thu, 19 Dec 2024 11:27:33 -0800
Subject: [PATCH 16/37] xfs: create routine to allocate and initialize a
 realtime rmap btree inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463580031.1571512.9792832900942195298.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
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
rmapbt inode.  We'll use this for mkfs and repair.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtgroup.c      |    2 +
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   54 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |    5 ++++
 fs/xfs/xfs_rtalloc.c             |   12 +++++++-
 4 files changed, 71 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index af1716ec0691a4..5f31b6e65d5d17 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -33,6 +33,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_metafile.h"
 #include "xfs_metadir.h"
+#include "xfs_rtrmap_btree.h"
 
 /* Find the first usable fsblock in this rtgroup. */
 static inline uint32_t
@@ -363,6 +364,7 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 		 * rtrmapbt predicate here.
 		 */
 		.enabled	= xfs_has_rmapbt,
+		.create		= xfs_rtrmapbt_create,
 	},
 };
 
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index d90189a1ef10b5..7654661f4f5823 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -832,3 +832,57 @@ xfs_iflush_rtrmap(
 	xfs_rtrmapbt_to_disk(ip->i_mount, ifp->if_broot, ifp->if_broot_bytes,
 			dfp, XFS_DFORK_SIZE(dip, ip->i_mount, XFS_DATA_FORK));
 }
+
+/*
+ * Create a realtime rmap btree inode.
+ */
+int
+xfs_rtrmapbt_create(
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
+	broot = xfs_broot_realloc(ifp, xfs_rtrmap_broot_space_calc(mp, 0, 0));
+	if (broot)
+		xfs_btree_init_block(mp, broot, &xfs_rtrmapbt_ops, 0, 0,
+				ip->i_ino);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE | XFS_ILOG_DBROOT);
+
+	return 0;
+}
+
+/*
+ * Initialize an rmap for a realtime superblock using the potentially updated
+ * rt geometry in the provided @mp.
+ */
+int
+xfs_rtrmapbt_init_rtsb(
+	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
+	struct xfs_trans	*tp)
+{
+	struct xfs_rmap_irec	rmap = {
+		.rm_blockcount	= mp->m_sb.sb_rextsize,
+		.rm_owner	= XFS_RMAP_OWN_FS,
+	};
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	ASSERT(xfs_has_rtsb(mp));
+	ASSERT(rtg_rgno(rtg) == 0);
+
+	cur = xfs_rtrmapbt_init_cursor(tp, rtg);
+	error = xfs_rmap_map_raw(cur, &rmap);
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index e97695066920ee..bf73460be274d1 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -193,4 +193,9 @@ void xfs_rtrmapbt_to_disk(struct xfs_mount *mp, struct xfs_btree_block *rblock,
 		unsigned int dblocklen);
 void xfs_iflush_rtrmap(struct xfs_inode *ip, struct xfs_dinode *dip);
 
+int xfs_rtrmapbt_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
+		struct xfs_trans *tp, bool init);
+int xfs_rtrmapbt_init_rtsb(struct xfs_mount *mp, struct xfs_rtgroup *rtg,
+		struct xfs_trans *tp);
+
 #endif /* __XFS_RTRMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 2245f9ecaa3398..c7efd926413981 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -846,6 +846,13 @@ xfs_growfs_rt_init_rtsb(
 	mp->m_rtsb_bp = rtsb_bp;
 	error = xfs_bwrite(rtsb_bp);
 	xfs_buf_unlock(rtsb_bp);
+	if (error)
+		return error;
+
+	/* Initialize the rtrmap to reflect the rtsb. */
+	if (rtg_rmap(args->rtg) != NULL)
+		error = xfs_rtrmapbt_init_rtsb(nargs->mp, args->rtg, args->tp);
+
 	return error;
 }
 
@@ -894,8 +901,9 @@ xfs_growfs_rt_bmblock(
 		goto out_free;
 	nargs.tp = args.tp;
 
-	xfs_rtgroup_lock(args.rtg, XFS_RTGLOCK_BITMAP);
-	xfs_rtgroup_trans_join(args.tp, args.rtg, XFS_RTGLOCK_BITMAP);
+	xfs_rtgroup_lock(args.rtg, XFS_RTGLOCK_BITMAP | XFS_RTGLOCK_RMAP);
+	xfs_rtgroup_trans_join(args.tp, args.rtg,
+			XFS_RTGLOCK_BITMAP | XFS_RTGLOCK_RMAP);
 
 	/*
 	 * Update the bitmap inode's size ondisk and incore.  We need to update


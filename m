Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EB323C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881682; cv=none; b=Cq1o+bHmIhN+Rt38xcwnYG6aSQAa7C91KcQU0WUHyHb7CoHOCZLBkSXoo3BNf8zeX8p7rlxRM2PiN8oFlv5LwaNkMq/edP3GdYMe9v/YJLf3bNpda768UX8f+2Ro2hQNfDyLrUxLG1LcwI9fIlMTSPaNZpPNxCIpGXOpKgucPEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881682; c=relaxed/simple;
	bh=QB5LDr33lpzrcBLYU1ECTWEwiPdhCEAnYORDelsY4pE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CNNNBl0bDmQbC8mqNpejEL2DM6nJHT76OmQ+nABcRu7q9hEShz5Ll34kyp90AzIecyGmlecH/GpHkL3v4J/wEZt92pYFGG13acVDmRD1fLAsVn0r7vueyWA0UcDrHNAMtvzVMxqeT7qAoxIqs3Pur5iicJsELI0x7aDsxQx6rRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nKh1G+Qi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nKh1G+Qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A289C4CEDD;
	Thu,  6 Feb 2025 22:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881682;
	bh=QB5LDr33lpzrcBLYU1ECTWEwiPdhCEAnYORDelsY4pE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nKh1G+QifLaxwMMOrWBJh01dkELDpHaNnHIi4d9PBq9C4qjh7Eqsk2Fh5lQf3btxJ
	 jKb1nI8PSWXVOjvTZuQZ0ggSWT5cAr74eFwqMdU7QBRJCP/a2URISuMcMfUlSrIv6P
	 gWmDJYsigLg/ZmzcX8YILRGhW/M2THuAeajGKv1OT75XAvifNKusoXAPOekyRkmvm6
	 ulGDuc+S7mFIRYOy3UaloHpZUmEEcXDi9vX1/VF9lr6Y8hm88bl/ULzPj/ji3iFT81
	 6yJsvO0jGCMABuyPE20Q1coy8e/T0yJdxL/8cxXIcXWLRdiu/XL4Ge/9pxS+jxNW6J
	 LG1eyFyZTNhdw==
Date: Thu, 06 Feb 2025 14:41:21 -0800
Subject: [PATCH 24/56] xfs: create routine to allocate and initialize a
 realtime rmap btree inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087158.2739176.1339461537459211023.stgit@frogsfrogsfrogs>
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

Source kernel commit: 71b8acb42be60e11810eb43a6f470589fcf7b7dd

Create a library routine to allocate and initialize an empty realtime
rmapbt inode.  We'll use this for mkfs and repair.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtgroup.c      |    2 ++
 libxfs/xfs_rtrmap_btree.c |   54 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |    5 ++++
 3 files changed, 61 insertions(+)


diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index f0c45e75e52c3e..c40b02be0f41b9 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -30,6 +30,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_metafile.h"
 #include "xfs_metadir.h"
+#include "xfs_rtrmap_btree.h"
 
 /* Find the first usable fsblock in this rtgroup. */
 static inline uint32_t
@@ -360,6 +361,7 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 		 * rtrmapbt predicate here.
 		 */
 		.enabled	= xfs_has_rmapbt,
+		.create		= xfs_rtrmapbt_create,
 	},
 };
 
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 39fd9a0ab986e6..a14f2bec8aaa52 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -830,3 +830,57 @@ xfs_iflush_rtrmap(
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
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index e97695066920ee..bf73460be274d1 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -193,4 +193,9 @@ void xfs_rtrmapbt_to_disk(struct xfs_mount *mp, struct xfs_btree_block *rblock,
 		unsigned int dblocklen);
 void xfs_iflush_rtrmap(struct xfs_inode *ip, struct xfs_dinode *dip);
 
+int xfs_rtrmapbt_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
+		struct xfs_trans *tp, bool init);
+int xfs_rtrmapbt_init_rtsb(struct xfs_mount *mp, struct xfs_rtgroup *rtg,
+		struct xfs_trans *tp);
+
 #endif /* __XFS_RTRMAP_BTREE_H__ */


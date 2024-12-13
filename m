Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3171317BA1
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051886; cv=none; b=EMvm1CA5zgSe+Jkz+zKXetR5YAoW0NS7vbxJu5W39NshJWTHPAB/c+YGSeSzBJhoeekRLLRXFsEaztGMJ4nNQrd2ID3yS+UhgS6GH/Z7aqe52esuDpOe0EjpROE+WOK+72vmyLHUY7QqkCclHHzMiRpMhTnsuWh87bRSM3hCwoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051886; c=relaxed/simple;
	bh=SF70s06Y8VArL+TkwKyj7RzaVDX7Iv2fjS0RGiBtY3g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WJjdVKtX/U67ViylIVSU7GerpJlrxORwbb7Uhr3TaTlgzJCsyURsTGt0df9Lew2nHz9uPqKGwp3Bx9N+1Byn6uFkRrdrP2FpNk+s4lXLUbiFEdBeEXyLEh4+TJuKuIbZaSZmsTOipyNe8dWi1lJp8JbStDBRhVakgCiv/m6uuJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r6nnwdnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r6nnwdnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8B0C4CECE;
	Fri, 13 Dec 2024 01:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051885;
	bh=SF70s06Y8VArL+TkwKyj7RzaVDX7Iv2fjS0RGiBtY3g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=r6nnwdnUj19GF739EjcH/Y0MhBC0I/LHTJ5BDNvyhARxcciLKEfk6p5LYAZxIqj+L
	 iJGk65JZXK+fXxLGOjeXezjsK98HvcxObX9tkrOLF0uPyUhPNwiO+vRcsLfzri/6Xu
	 jF+Qu56tG1tVf3qm7hlXKprIjfYyQ5hClaJCHhWVnPlv9w7BJw9vrl665uZRNtkmnX
	 n/wQxoQ9S5YK0xaYjBMFNOtnTloeA21bxYayIyeH0XI2maoki2LPi4li9oyAdlIdKd
	 873asP4vDXSMsgXgcXxZWXRvPHs6NmPA8vFrobtKUdYX4syo6vaL/D5gHpSj9utJ+s
	 4xkxpKyGEoVDg==
Date: Thu, 12 Dec 2024 17:04:45 -0800
Subject: [PATCH 16/37] xfs: create routine to allocate and initialize a
 realtime rmap btree inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123589.1181370.6617549529420695155.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
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
index ddae34cac10f1c..db313492b17eed 100644
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
 #endif	/* __XFS_RTRMAP_BTREE_H__ */
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F71BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7qv5jm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D37C433C8;
	Sun, 31 Dec 2023 21:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058573;
	bh=3tEBmX3FuuIzH6bkTOpyHSMQo3O90R06xMO4fzQuSYo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N7qv5jm+3WnFS7WIcPcg/6WOqdQvyBze4/f69crZE+nXbGz62T0UG7IQCWRP9nN6H
	 mR/uDhV5CNku+RmTEC3BL9m13Fj9lphJUvSrFplUZBFZWWU/7LgHSY+Yfnlfi/ppnA
	 dYVUrEM6EeJGYkENDtbrnW67P/7wkH9yvYLPZ7gY0wy8PNhsd6lxkQrdU/QuLYzmPR
	 yEJZSfddAv7ITWlBDh2uMuRhXq3lM+mwhK+3Tm3fjLh/mDXsHKDBqt83XckuHVVAEb
	 BPwItKJna2nCVt0pAdVZ5lwxII8Uuvecqwdstm/Ns8agZxogXMnv/ob8QQiG6Bjgbo
	 b65DK0tST0DXQ==
Date: Sun, 31 Dec 2023 13:36:13 -0800
Subject: [PATCH 17/39] xfs: create routine to allocate and initialize a
 realtime rmap btree inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850174.1764998.2153400423503289445.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   34 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |    4 ++++
 2 files changed, 38 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index e2ee2a500ca38..b824562bdc2ec 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -868,3 +868,37 @@ xfs_iflush_rtrmap(
 	xfs_rtrmapbt_to_disk(ip->i_mount, ifp->if_broot, ifp->if_broot_bytes,
 			dfp, XFS_DFORK_SIZE(dip, ip->i_mount, XFS_DATA_FORK));
 }
+
+/*
+ * Create a realtime rmap btree inode.
+ *
+ * Regardless of the return value, the caller must clean up @upd.  If a new
+ * inode is returned through @*ipp, the caller must finish setting up the incore
+ * inode and release it.
+ */
+int
+xfs_rtrmapbt_create(
+	struct xfs_imeta_update	*upd,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = upd->mp;
+	struct xfs_ifork	*ifp;
+	int			error;
+
+	error = xfs_imeta_create(upd, S_IFREG, ipp);
+	if (error)
+		return error;
+
+	ifp = xfs_ifork_ptr(upd->ip, XFS_DATA_FORK);
+	ifp->if_format = XFS_DINODE_FMT_RMAP;
+	ASSERT(ifp->if_broot_bytes == 0);
+	ASSERT(ifp->if_bytes == 0);
+
+	/* Initialize the empty incore btree root. */
+	xfs_iroot_alloc(upd->ip, XFS_DATA_FORK,
+			xfs_rtrmap_broot_space_calc(mp, 0, 0));
+	xfs_btree_init_block(mp, ifp->if_broot, &xfs_rtrmapbt_ops, 0, 0,
+			upd->ip->i_ino);
+	xfs_trans_log_inode(upd->tp, upd->ip, XFS_ILOG_CORE | XFS_ILOG_DBROOT);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index 2b26a05f90779..108ab8c0aea44 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -198,4 +198,8 @@ void xfs_rtrmapbt_to_disk(struct xfs_mount *mp, struct xfs_btree_block *rblock,
 		unsigned int dblocklen);
 void xfs_iflush_rtrmap(struct xfs_inode *ip, struct xfs_dinode *dip);
 
+struct xfs_imeta_update;
+
+int xfs_rtrmapbt_create(struct xfs_imeta_update *upd, struct xfs_inode **ipp);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */


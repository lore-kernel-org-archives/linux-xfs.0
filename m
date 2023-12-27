Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEE7384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tRI6MGsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87919C433C8;
	Mon,  1 Jan 2024 00:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068050;
	bh=21c3oXt8nlRElQlkech7ZSijOPYgarVfz5k15dRpUtE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tRI6MGsrjkldw1L53W6gk7XK0h76Sa2coREn1FDN5ILit1ahchgwlDDh++AIAlBlc
	 DPvG0m1psM3G9LocvTqR9C5FsSDe56OtJmudk06axGleXmN4l6ZmAotQoRxA1XM88L
	 0Qgmb3zJEM2DhTPXaNHContQhKnjdqQcZiaaIa8epm+5+mJ+s2YxzoqW8VVUb5L0Zp
	 QfMaqqgbUyGh43DdgLOpwBfCipxkZPIuHvQo/kzbLWnL1tDSW7btsmWX6mBa4HxnaJ
	 mSi3aq0AAPFHDY3TNwY8Fsk0fItPlctTDTZpsiibQ6pIvd5xvhYpREzj0H6e69mHNE
	 BW+VnvCSUnuKA==
Date: Sun, 31 Dec 2023 16:14:10 +9900
Subject: [PATCH 14/47] xfs: create routine to allocate and initialize a
 realtime rmap btree inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015500.1815505.14774124742666381819.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_rtrmap_btree.c |   34 ++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |    4 ++++
 2 files changed, 38 insertions(+)


diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 921bf7e1b11..832a58cfe13 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -866,3 +866,37 @@ xfs_iflush_rtrmap(
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
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index 2b26a05f907..108ab8c0aea 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -198,4 +198,8 @@ void xfs_rtrmapbt_to_disk(struct xfs_mount *mp, struct xfs_btree_block *rblock,
 		unsigned int dblocklen);
 void xfs_iflush_rtrmap(struct xfs_inode *ip, struct xfs_dinode *dip);
 
+struct xfs_imeta_update;
+
+int xfs_rtrmapbt_create(struct xfs_imeta_update *upd, struct xfs_inode **ipp);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */


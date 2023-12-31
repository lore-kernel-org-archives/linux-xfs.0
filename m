Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D0BBA43
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jF1va4DS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512F9C433C8;
	Sun, 31 Dec 2023 21:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059309;
	bh=1MHmQkZxX1hKvwPSr06Xi5JxzD8pn/gFw7k8Yd58yK4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jF1va4DSAmIg2CgE97DP3v0JrbT4BYelHs4r/l0GjTdk9WH2+l3vNpAziMojnCt9M
	 fshYm9w97d7k0NCukONWTBjYGmDoUqn7Kq7cyUAZfcKBgpf1BwB6PUsT7UEHfGeSOW
	 qXJGDmXrfrKnDqCTrG1j2ZLSiI/nacsU12G3HRcs/Qh0YGd5wJIAVL43/ydqMLzcMB
	 XJ0bK5fraLo/j5UX4Pt/MpUzw2Uwr4X+JLIfJVt0hJI38YLCXf+wq7cE6YTMDLpfo2
	 J1qKu7ow9NaXvhCk9fY8B5ps8v8Whf3qPCIdVdm6ZbZaZcyeFGpmeD9siZLICiM+qS
	 mLrFQL2pIAvTg==
Date: Sun, 31 Dec 2023 13:48:28 -0800
Subject: [PATCH 15/44] xfs: create routine to allocate and initialize a
 realtime refcount btree inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851825.1766284.164144626420718315.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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
refcountbt inode.  We'll use this for growfs, mkfs, and repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   34 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |    5 +++++
 2 files changed, 39 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index ae8dea035d29f..fb0e4abcd6f6a 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -766,3 +766,37 @@ xfs_iflush_rtrefcount(
 			ifp->if_broot_bytes, dfp,
 			XFS_DFORK_SIZE(dip, ip->i_mount, XFS_DATA_FORK));
 }
+
+/*
+ * Create a realtime refcount btree inode.
+ *
+ * Regardless of the return value, the caller must clean up @upd.  If a new
+ * inode is returned through *ipp, the caller must finish setting up the incore
+ * inode and release it.
+ */
+int
+xfs_rtrefcountbt_create(
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
+	ifp->if_format = XFS_DINODE_FMT_REFCOUNT;
+	ASSERT(ifp->if_broot_bytes == 0);
+	ASSERT(ifp->if_bytes == 0);
+
+	/* Initialize the empty incore btree root. */
+	xfs_iroot_alloc(upd->ip, XFS_DATA_FORK,
+			xfs_rtrefcount_broot_space_calc(mp, 0, 0));
+	xfs_btree_init_block(mp, ifp->if_broot, &xfs_rtrefcountbt_ops,
+			0, 0, upd->ip->i_ino);
+	xfs_trans_log_inode(upd->tp, upd->ip, XFS_ILOG_CORE | XFS_ILOG_DBROOT);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
index bd070e54781a1..749c6fd02f837 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -188,4 +188,9 @@ void xfs_rtrefcountbt_to_disk(struct xfs_mount *mp,
 		struct xfs_rtrefcount_root *dblock, int dblocklen);
 void xfs_iflush_rtrefcount(struct xfs_inode *ip, struct xfs_dinode *dip);
 
+struct xfs_imeta_update;
+
+int xfs_rtrefcountbt_create(struct xfs_imeta_update *upd,
+		struct xfs_inode **ipp);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890AB38B
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMLuDZw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2F7C433C8;
	Mon,  1 Jan 2024 00:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068957;
	bh=Q6WINqHcbw3oGP9A+Je7l+Sf8n6+psWgjFO7hJCB40w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MMLuDZw7yN5F/q5HmSUk3G8Xd0LdWB+WemFhWcP3Bty32At0YCsOzGySiZ/86r0G7
	 Q77k8yb3rJxOnsePkvm81U3yL/GnbUJimMgCv4Jb9ow8AQmCa8o/BKUVSxZPGsFPTM
	 ecBNyVBuIGXAIWh1kwAOf1HZXMMikbD+hedb+Kal5FoY0TNU6B80hH1OwNIn/9QpYO
	 5nqLbVDViXzw6CyUqwwxmnvMZ4CtFglg6W8u03K4Jl1jxnHbz4TNBDXbjUgMePswxW
	 wrQx1d3qBXjlfCPclaScAXWOD2LCXNEQ1E6+LKhrYLw6FXDB00AJwCxtXuNjDtnRaa
	 AJVm5OYT+6xkw==
Date: Sun, 31 Dec 2023 16:29:16 +9900
Subject: [PATCH 12/42] xfs: create routine to allocate and initialize a
 realtime refcount btree inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017286.1817107.17332850317251451184.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_rtrefcount_btree.c |   34 ++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrefcount_btree.h |    5 +++++
 2 files changed, 39 insertions(+)


diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 530bb9d361d..fa04395eed0 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -764,3 +764,37 @@ xfs_iflush_rtrefcount(
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
diff --git a/libxfs/xfs_rtrefcount_btree.h b/libxfs/xfs_rtrefcount_btree.h
index bd070e54781..749c6fd02f8 100644
--- a/libxfs/xfs_rtrefcount_btree.h
+++ b/libxfs/xfs_rtrefcount_btree.h
@@ -188,4 +188,9 @@ void xfs_rtrefcountbt_to_disk(struct xfs_mount *mp,
 		struct xfs_rtrefcount_root *dblock, int dblocklen);
 void xfs_iflush_rtrefcount(struct xfs_inode *ip, struct xfs_dinode *dip);
 
+struct xfs_imeta_update;
+
+int xfs_rtrefcountbt_create(struct xfs_imeta_update *upd,
+		struct xfs_inode **ipp);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */


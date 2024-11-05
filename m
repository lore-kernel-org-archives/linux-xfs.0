Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8406216443
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845638; cv=none; b=PHg27KoeyzL+F4xB5Cl9CCN864QdbjrwWr0xrd3CIuRCIlBewF9/wZuCxdCMCq+8MAFrNPv3eFbF/LnnP8K7xZMh7pBdFjFCRzjRFbJjM64M2h0jaRo2cD6BVLf6W3yFoQvWbcvBqKH2kW0f9SnteVTfSUwvLLTzwHm7iJGdMes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845638; c=relaxed/simple;
	bh=wjn3ZqSs4ppzr/TDIyf9FEOUVbZwOMh95CVbTnTfjTE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NfoyBe8mpy/qgHq12++4uwc5oX43BmfpFkAG1DBHoirIO6ZquY4XAbG5NPHey4hpGaRHD7UvrJsxi5HmKe0iJwzjgCVXqwPmSh3BKu228+falAx1PYdwDD6EzZqvND4TS19wwDrZ01Z62URiYEKg6aGWHDJCWyenRJEHpTyt+jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDpajgR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDpajgR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CDFC4CECF;
	Tue,  5 Nov 2024 22:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845638;
	bh=wjn3ZqSs4ppzr/TDIyf9FEOUVbZwOMh95CVbTnTfjTE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oDpajgR/Sg00XmcGXLLbpotf+hzECuTLoDAyfnlpE+G61uG2zLe0zGbbY6dounarD
	 ZHKUOBVvW62BeB2cUDDaDkL0NwldETOYd77Rfp6zK405JcAhx53CfwBdiYlAPgtEss
	 v/bO7kgwJ9JBBk4yBBSYbPj8bnqa9E8Ik/ken2gEyqghbtnB+3+T+Vko8yjqxUmoCU
	 dBdc3Q8s1/A94wTZORwPvHtepP4+P8RlnpmbbXFAajIKcwhB1jEjx/bNXsJS9upoq4
	 +V5C6ZVzeB0nHHj6ShXfFNojJCpE+CCEBgCqGxA0RbNG4mqvs2FH952XfVQ3rgosDV
	 +MMLRozg9rYCg==
Date: Tue, 05 Nov 2024 14:27:18 -0800
Subject: [PATCH 13/21] xfs: support creating per-RTG files in growfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084397162.1871025.13206282430772209039.stgit@frogsfrogsfrogs>
In-Reply-To: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

To support adding new RT groups in growfs, we need to be able to create
the per-RT group files.  Add a new xfs_rtginode_create helper to create
a given per-RTG file.  Most of the code for that is shared, but the
details of the actual file are abstracted out using a new create method
in struct xfs_rtginode_ops.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   32 +++++++++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h |    4 ++
 fs/xfs/libxfs/xfs_rtgroup.c  |   69 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h  |    2 +
 fs/xfs/xfs_rtalloc.c         |   30 ++++++++++++++++++
 5 files changed, 137 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index c54ac160b90994..6c3354c8efdafa 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1297,3 +1297,35 @@ xfs_rtfile_initialize_blocks(
 
 	return 0;
 }
+
+int
+xfs_rtbitmap_create(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip,
+	struct xfs_trans	*tp,
+	bool			init)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+
+	ip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
+	if (init && !xfs_has_rtgroups(mp)) {
+		ip->i_diflags |= XFS_DIFLAG_NEWRTBM;
+		inode_set_atime(VFS_I(ip), 0, 0);
+	}
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
+
+int
+xfs_rtsummary_create(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip,
+	struct xfs_trans	*tp,
+	bool			init)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+
+	ip->i_disk_size = mp->m_rsumblocks * mp->m_sb.sb_blocksize;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index b3cbc56aa255ed..e4994a3e461d33 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -315,6 +315,10 @@ xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 int xfs_rtfile_initialize_blocks(struct xfs_rtgroup *rtg,
 		enum xfs_rtg_inodes type, xfs_fileoff_t offset_fsb,
 		xfs_fileoff_t end_fsb, void *data);
+int xfs_rtbitmap_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
+		struct xfs_trans *tp, bool init);
+int xfs_rtsummary_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
+		struct xfs_trans *tp, bool init);
 
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 22901ecc2cbe22..da29f41e51f1e1 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -272,16 +272,24 @@ struct xfs_rtginode_ops {
 
 	/* Does the fs have this feature? */
 	bool			(*enabled)(struct xfs_mount *mp);
+
+	/* Create this rtgroup metadata inode and initialize it. */
+	int			(*create)(struct xfs_rtgroup *rtg,
+					  struct xfs_inode *ip,
+					  struct xfs_trans *tp,
+					  bool init);
 };
 
 static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 	[XFS_RTGI_BITMAP] = {
 		.name		= "bitmap",
 		.metafile_type	= XFS_METAFILE_RTBITMAP,
+		.create		= xfs_rtbitmap_create,
 	},
 	[XFS_RTGI_SUMMARY] = {
 		.name		= "summary",
 		.metafile_type	= XFS_METAFILE_RTSUMMARY,
+		.create		= xfs_rtsummary_create,
 	},
 };
 
@@ -389,6 +397,67 @@ xfs_rtginode_irele(
 	*ipp = NULL;
 }
 
+/* Add a metadata inode for a realtime rmap btree. */
+int
+xfs_rtginode_create(
+	struct xfs_rtgroup		*rtg,
+	enum xfs_rtg_inodes		type,
+	bool				init)
+{
+	const struct xfs_rtginode_ops	*ops = &xfs_rtginode_ops[type];
+	struct xfs_mount		*mp = rtg_mount(rtg);
+	struct xfs_metadir_update	upd = {
+		.dp			= mp->m_rtdirip,
+		.metafile_type		= ops->metafile_type,
+	};
+	int				error;
+
+	if (!xfs_rtginode_enabled(rtg, type))
+		return 0;
+
+	if (!mp->m_rtdirip)
+		return -EFSCORRUPTED;
+
+	upd.path = xfs_rtginode_path(rtg_rgno(rtg), type);
+	if (!upd.path)
+		return -ENOMEM;
+
+	error = xfs_metadir_start_create(&upd);
+	if (error)
+		goto out_path;
+
+	error = xfs_metadir_create(&upd, S_IFREG);
+	if (error)
+		return error;
+
+	xfs_rtginode_lockdep_setup(upd.ip, rtg_rgno(rtg), type);
+
+	upd.ip->i_projid = rtg_rgno(rtg);
+	error = ops->create(rtg, upd.ip, upd.tp, init);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_metadir_commit(&upd);
+	if (error)
+		goto out_path;
+
+	kfree(upd.path);
+	xfs_finish_inode_setup(upd.ip);
+	rtg->rtg_inodes[type] = upd.ip;
+	return 0;
+
+out_cancel:
+	xfs_metadir_cancel(&upd, error);
+	/* Have to finish setting up the inode to ensure it's deleted. */
+	if (upd.ip) {
+		xfs_finish_inode_setup(upd.ip);
+		xfs_irele(upd.ip);
+	}
+out_path:
+	kfree(upd.path);
+	return error;
+}
+
 /* Create the parent directory for all rtgroup inodes and load it. */
 int
 xfs_rtginode_mkdir_parent(
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 3732f65ba8a1f6..6ccf31bb6bc7a7 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -242,6 +242,8 @@ enum xfs_metafile_type xfs_rtginode_metafile_type(enum xfs_rtg_inodes type);
 bool xfs_rtginode_enabled(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type);
 int xfs_rtginode_load(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
 		struct xfs_trans *tp);
+int xfs_rtginode_create(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
+		bool init);
 void xfs_rtginode_irele(struct xfs_inode **ipp);
 
 static inline const char *xfs_rtginode_path(xfs_rgnumber_t rgno,
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3b3ce971a19758..5c1df67b63d6d1 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -711,6 +711,29 @@ xfs_growfs_rt_fixup_extsize(
 	return error;
 }
 
+/* Ensure that the rtgroup metadata inode is loaded, creating it if neeeded. */
+static int
+xfs_rtginode_ensure(
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	if (rtg->rtg_inodes[type])
+		return 0;
+
+	error = xfs_trans_alloc_empty(rtg_mount(rtg), &tp);
+	if (error)
+		return error;
+	error = xfs_rtginode_load(rtg, type, tp);
+	xfs_trans_cancel(tp);
+
+	if (error != -ENOENT)
+		return 0;
+	return xfs_rtginode_create(rtg, type, true);
+}
+
 static int
 xfs_growfs_rt_bmblock(
 	struct xfs_rtgroup	*rtg,
@@ -927,12 +950,19 @@ xfs_growfs_rtg(
 	xfs_extlen_t		bmblocks;
 	xfs_fileoff_t		bmbno;
 	struct xfs_rtgroup	*rtg;
+	unsigned int		i;
 	int			error;
 
 	rtg = xfs_rtgroup_grab(mp, 0);
 	if (!rtg)
 		return -EINVAL;
 
+	for (i = 0; i < XFS_RTGI_MAX; i++) {
+		error = xfs_rtginode_ensure(rtg, i);
+		if (error)
+			goto out_rele;
+	}
+
 	error = xfs_growfs_rt_alloc_blocks(rtg, nrblocks, rextsize, &bmblocks);
 	if (error)
 		goto out_rele;


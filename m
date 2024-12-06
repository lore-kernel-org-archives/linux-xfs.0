Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401FD148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529192; cv=none; b=sQDsByc9JSVq/bLeUkqjUUd2YxDcI3+0RL16VhHdE6dgwPBYtURBob90DK09yGb+nrhHyyv6wQ50+P96tdzJXtj/Je4ODchaL9dSsVWpQOlb3RPIPCKd0vySAA5Xo7t4UqWy64yVSxZLTOaW9B3g0QvAGMKlDy1+8QIQ6yXTlgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529192; c=relaxed/simple;
	bh=95uQVxgH+6dE4fKjFcfaR+02F128DjwHmFSY+3lOtdk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kUt/jRBNlO47aZ14D5MRIwc5kVvskBI7hd0wvnp8DyNv8f/T6SXcRsfNQJcdL8JqWwTAZG/IOrVcQy8jVi9UMleKcVVwZuHBoK/0rSlOweNdnbG/1ITgIMpjzHLUwLPCJq35UoAhBnG/jUkcBYov+N+4Ro5ljSyzYogve6Na6WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rpfpnLWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rpfpnLWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15563C4CED1;
	Fri,  6 Dec 2024 23:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529192;
	bh=95uQVxgH+6dE4fKjFcfaR+02F128DjwHmFSY+3lOtdk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rpfpnLWJptINtL3E4p9dBEeGMGk6eit4XfLeb7b9OyeFhWL+kmmUwGQarievgbdlI
	 RWzL3yD7vx9ZcsoQLg4cNCZR18UGREkQj8z2f5CISg8JZsFKTjwEq5Q0N1OGSvXzDJ
	 0/Xrh0Idq7J6rIm41w+Cssq9DTV6bYbFYzbngcK0qcBHfidYlqwmgvdJlNKK5WYxM5
	 VwxkjZ5dCxop+ofW2zlqiZn5BDzAfeSymPAsObG2byCsKuxZsHZ1rIQJZOwzR/cJVT
	 WM9lRAEHlhzDL9yz8kYTyI1f59ZR5EykIw1bdHu7GYP02kdS2ZeKlr1KzcpV+WnVfc
	 UHHffeWwpIP4w==
Date: Fri, 06 Dec 2024 15:53:11 -0800
Subject: [PATCH 07/46] xfs: support creating per-RTG files in growfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750102.124560.11124750018781803247.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: ae897e0bed0f5461a6b1c3259c7d899759ba2a62

To support adding new RT groups in growfs, we need to be able to create
the per-RT group files.  Add a new xfs_rtginode_create helper to create
a given per-RTG file.  Most of the code for that is shared, but the
details of the actual file are abstracted out using a new create method
in struct xfs_rtginode_ops.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtbitmap.c |   32 +++++++++++++++++++++++
 libxfs/xfs_rtbitmap.h |    4 +++
 libxfs/xfs_rtgroup.c  |   69 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.h  |    2 +
 4 files changed, 107 insertions(+)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index e4d0646ba19bfd..c686cd5309e87c 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1295,3 +1295,35 @@ xfs_rtfile_initialize_blocks(
 
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
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index b3cbc56aa255ed..e4994a3e461d33 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 41c794718e06c9..4f2e6be2ae48cc 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -270,16 +270,24 @@ struct xfs_rtginode_ops {
 
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
 
@@ -387,6 +395,67 @@ xfs_rtginode_irele(
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
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 3732f65ba8a1f6..6ccf31bb6bc7a7 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -242,6 +242,8 @@ enum xfs_metafile_type xfs_rtginode_metafile_type(enum xfs_rtg_inodes type);
 bool xfs_rtginode_enabled(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type);
 int xfs_rtginode_load(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
 		struct xfs_trans *tp);
+int xfs_rtginode_create(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
+		bool init);
 void xfs_rtginode_irele(struct xfs_inode **ipp);
 
 static inline const char *xfs_rtginode_path(xfs_rgnumber_t rgno,


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C704A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608219; cv=none; b=Oj5XwlC0sq6MHoolO+E5xFH1DUjt2bGvWOPJvMamE2J4H3ZtbW8dAvgZsf2auG3sfA2/ZHsyjnVDjWJcf7iCQllATTn015aj6vKo89MGpDz7qesxyZsMdiKfjpvKsKdAx3KvxqTpz417sfKmJkXxSkBBSKN29QRsr7z9GGulcgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608219; c=relaxed/simple;
	bh=CH1N3tfS8C0vFg7n5SA8d4EARCMomSWma9+gyRZ0cAA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DpjlPucfdY9Eh52UJS1OPKDZJEgNIOMhkohK+RVA5/UX4+dwnmFZN2K+fdOFGDFcmmyoin5b0g8FCCIYW4zwlq2ZZHepBZbLDTIdeCkup2mqrvrvMM7yF24FJUkrU6AEec7lkxJMzSaQoxDmU7Q9gj23UA/qd5kn7ue/hb+EpA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VSFxCflI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VSFxCflI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE29AC4CEC5;
	Fri, 11 Oct 2024 00:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608219;
	bh=CH1N3tfS8C0vFg7n5SA8d4EARCMomSWma9+gyRZ0cAA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VSFxCflIlbtpBV2tl4R/I5Ysu9uziRlAunM7G5Yq5eMnI6xo9vh+n+L1iFlfVWsZC
	 HO325ykoR6kq4EIY6wrlNgZV0usFub9aMnHSORwip9G/TX3y6sWzW7OZTBVWl9W2bX
	 EYT8TKI9TMhgUOrOp4MsQ1trOGH4Fi0UyppetrIfWSqsSsh6EnteLsxGbnmpjDfD7E
	 ufJeblJomYJ9DKQl6TkZgTZGFBk36CyE5unncfwczzhhAOgIpUrW5DIjjTCvnNK8te
	 PUtkiHNzY4wyqaCQYuwcP4FOhq9IULQgao9gXZy65Ngdsr0aF4x9LZSEN7NafAD+4D
	 8SICkvtGEYFDw==
Date: Thu, 10 Oct 2024 17:56:59 -0700
Subject: [PATCH 05/21] xfs: support caching rtgroup metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860643032.4177836.6620713800192997454.stgit@frogsfrogsfrogs>
In-Reply-To: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
References: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
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

Create the necessary per-rtgroup infrastructure that we need to load
metadata inodes into memory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtgroup.c |  123 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |   27 +++++++++
 fs/xfs/xfs_mount.h          |    1 
 fs/xfs/xfs_rtalloc.c        |   69 +++++++++++++++++++++++-
 4 files changed, 217 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 7d7608c38e0e37..dac5d5b51aed05 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -30,6 +30,8 @@
 #include "xfs_icache.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_metafile.h"
+#include "xfs_metadir.h"
 
 int
 xfs_rtgroup_alloc(
@@ -228,3 +230,124 @@ xfs_rtginode_lockdep_setup(
 #else
 #define xfs_rtginode_lockdep_setup(ip, rgno, type)	do { } while (0)
 #endif /* CONFIG_PROVE_LOCKING */
+
+struct xfs_rtginode_ops {
+	const char		*name;	/* short name */
+
+	enum xfs_metafile_type	metafile_type;
+
+	/* Does the fs have this feature? */
+	bool			(*enabled)(struct xfs_mount *mp);
+};
+
+static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
+};
+
+/* Return the shortname of this rtgroup inode. */
+const char *
+xfs_rtginode_name(
+	enum xfs_rtg_inodes	type)
+{
+	return xfs_rtginode_ops[type].name;
+}
+
+/* Return the metafile type of this rtgroup inode. */
+enum xfs_metafile_type
+xfs_rtginode_metafile_type(
+	enum xfs_rtg_inodes	type)
+{
+	return xfs_rtginode_ops[type].metafile_type;
+}
+
+/* Should this rtgroup inode be present? */
+bool
+xfs_rtginode_enabled(
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type)
+{
+	const struct xfs_rtginode_ops *ops = &xfs_rtginode_ops[type];
+
+	if (!ops->enabled)
+		return true;
+	return ops->enabled(rtg_mount(rtg));
+}
+
+/* Load and existing rtgroup inode into the rtgroup structure. */
+int
+xfs_rtginode_load(
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type,
+	struct xfs_trans	*tp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	const char		*path;
+	struct xfs_inode	*ip;
+	const struct xfs_rtginode_ops *ops = &xfs_rtginode_ops[type];
+	int			error;
+
+	if (!xfs_rtginode_enabled(rtg, type))
+		return 0;
+
+	if (!mp->m_rtdirip)
+		return -EFSCORRUPTED;
+
+	path = xfs_rtginode_path(rtg_rgno(rtg), type);
+	if (!path)
+		return -ENOMEM;
+	error = xfs_metadir_load(tp, mp->m_rtdirip, path, ops->metafile_type,
+			&ip);
+	kfree(path);
+
+	if (error)
+		return error;
+
+	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
+			       ip->i_df.if_format != XFS_DINODE_FMT_BTREE)) {
+		xfs_irele(ip);
+		return -EFSCORRUPTED;
+	}
+
+	if (XFS_IS_CORRUPT(mp, ip->i_projid != rtg_rgno(rtg))) {
+		xfs_irele(ip);
+		return -EFSCORRUPTED;
+	}
+
+	xfs_rtginode_lockdep_setup(ip, rtg_rgno(rtg), type);
+	rtg->rtg_inodes[type] = ip;
+	return 0;
+}
+
+/* Release an rtgroup metadata inode. */
+void
+xfs_rtginode_irele(
+	struct xfs_inode	**ipp)
+{
+	if (*ipp)
+		xfs_irele(*ipp);
+	*ipp = NULL;
+}
+
+/* Create the parent directory for all rtgroup inodes and load it. */
+int
+xfs_rtginode_mkdir_parent(
+	struct xfs_mount	*mp)
+{
+	if (!mp->m_metadirip)
+		return -EFSCORRUPTED;
+
+	return xfs_metadir_mkdir(mp->m_metadirip, "rtgroups", &mp->m_rtdirip);
+}
+
+/* Load the parent directory of all rtgroup inodes. */
+int
+xfs_rtginode_load_parent(
+	struct xfs_trans	*tp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+
+	if (!mp->m_metadirip)
+		return -EFSCORRUPTED;
+
+	return xfs_metadir_load(tp, mp->m_metadirip, "rtgroups",
+			XFS_METAFILE_DIR, &mp->m_rtdirip);
+}
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 87932fce81fcfe..2ef028c88f102f 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -11,12 +11,23 @@
 struct xfs_mount;
 struct xfs_trans;
 
+enum xfs_rtg_inodes {
+	XFS_RTGI_MAX,
+};
+
+#ifdef MAX_LOCKDEP_SUBCLASSES
+static_assert(XFS_RTGI_MAX <= MAX_LOCKDEP_SUBCLASSES);
+#endif
+
 /*
  * Realtime group incore structure, similar to the per-AG structure.
  */
 struct xfs_rtgroup {
 	struct xfs_group	rtg_group;
 
+	/* per-rtgroup metadata inodes */
+	struct xfs_inode	*rtg_inodes[1 /* hack */];
+
 	/* Number of blocks in this group */
 	xfs_rtxnum_t		rtg_extents;
 };
@@ -202,6 +213,22 @@ void xfs_rtgroup_lock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
 void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
 void xfs_rtgroup_trans_join(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		unsigned int rtglock_flags);
+
+int xfs_rtginode_mkdir_parent(struct xfs_mount *mp);
+int xfs_rtginode_load_parent(struct xfs_trans *tp);
+
+const char *xfs_rtginode_name(enum xfs_rtg_inodes type);
+enum xfs_metafile_type xfs_rtginode_metafile_type(enum xfs_rtg_inodes type);
+bool xfs_rtginode_enabled(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type);
+int xfs_rtginode_load(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
+		struct xfs_trans *tp);
+void xfs_rtginode_irele(struct xfs_inode **ipp);
+
+static inline const char *xfs_rtginode_path(xfs_rgnumber_t rgno,
+		enum xfs_rtg_inodes type)
+{
+	return kasprintf(GFP_KERNEL, "%u.%s", rgno, xfs_rtginode_name(type));
+}
 #else
 static inline void xfs_free_rtgroups(struct xfs_mount *mp,
 		xfs_rgnumber_t first_rgno, xfs_rgnumber_t end_rgno)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 02e5eab959d015..b5424a5fb48524 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -98,6 +98,7 @@ typedef struct xfs_mount {
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
 	struct xfs_inode	*m_metadirip;	/* ptr to metadata directory */
+	struct xfs_inode	*m_rtdirip;	/* ptr to realtime metadir */
 	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
 	struct xfs_buftarg	*m_ddev_targp;	/* data device */
 	struct xfs_buftarg	*m_logdev_targp;/* log device */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 917c1a5e8f3180..96225313686414 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -28,6 +28,7 @@
 #include "xfs_da_format.h"
 #include "xfs_metafile.h"
 #include "xfs_rtgroup.h"
+#include "xfs_error.h"
 
 /*
  * Return whether there are any free extents in the size range given
@@ -652,6 +653,16 @@ xfs_rtallocate_extent_size(
 	return -ENOSPC;
 }
 
+static void
+xfs_rtunmount_rtg(
+	struct xfs_rtgroup	*rtg)
+{
+	int			i;
+
+	for (i = 0; i < XFS_RTGI_MAX; i++)
+		xfs_rtginode_irele(&rtg->rtg_inodes[i]);
+}
+
 static int
 xfs_alloc_rsum_cache(
 	struct xfs_mount	*mp,
@@ -1127,6 +1138,43 @@ xfs_rtmount_iread_extents(
 	return error;
 }
 
+static void
+xfs_rtgroup_unmount_inodes(
+	struct xfs_mount	*mp)
+{
+	struct xfs_rtgroup	*rtg = NULL;
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		xfs_rtunmount_rtg(rtg);
+	xfs_rtginode_irele(&mp->m_rtdirip);
+}
+
+static int
+xfs_rtmount_rtg(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_rtgroup	*rtg)
+{
+	int			error, i;
+
+	rtg->rtg_extents = xfs_rtgroup_extents(mp, rtg_rgno(rtg));
+
+	for (i = 0; i < XFS_RTGI_MAX; i++) {
+		error = xfs_rtginode_load(rtg, i, tp);
+		if (error)
+			return error;
+
+		if (rtg->rtg_inodes[i]) {
+			error = xfs_rtmount_iread_extents(tp,
+					rtg->rtg_inodes[i], 0);
+			if (error)
+				return error;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Get the bitmap and summary inodes and the summary cache into the mount
  * structure at mount time.
@@ -1168,15 +1216,28 @@ xfs_rtmount_inodes(
 	if (error)
 		goto out_rele_summary;
 
-	while ((rtg = xfs_rtgroup_next(mp, rtg)))
-		rtg->rtg_extents = xfs_rtgroup_extents(mp, rtg_rgno(rtg));
+	if (xfs_has_rtgroups(mp) && mp->m_sb.sb_rgcount > 0) {
+		error = xfs_rtginode_load_parent(tp);
+		if (error)
+			goto out_rele_summary;
+	}
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		error = xfs_rtmount_rtg(mp, tp, rtg);
+		if (error) {
+			xfs_rtgroup_rele(rtg);
+			goto out_rele_inodes;
+		}
+	}
 
 	error = xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
 	if (error)
-		goto out_rele_summary;
+		goto out_rele_inodes;
 	xfs_trans_cancel(tp);
 	return 0;
 
+out_rele_inodes:
+	xfs_rtgroup_unmount_inodes(mp);
 out_rele_summary:
 	xfs_irele(mp->m_rsumip);
 out_rele_bitmap:
@@ -1191,6 +1252,8 @@ xfs_rtunmount_inodes(
 	struct xfs_mount	*mp)
 {
 	kvfree(mp->m_rsum_cache);
+
+	xfs_rtgroup_unmount_inodes(mp);
 	if (mp->m_rbmip)
 		xfs_irele(mp->m_rbmip);
 	if (mp->m_rsumip)


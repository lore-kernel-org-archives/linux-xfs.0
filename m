Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4B01E5022
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845514; cv=none; b=Cp1b0dDdiuisQDZJqzwzVb4Jz712TXxCI16yraZwA1Cq/ZUtBkP6OEz7bRWedmisJ0OEMLvFpSkF1nnnRLhaKsAOGP8OBFbQSdquq7U4tQAYcOSQZ2710FxUaaNEHcRfASRZqP593zHaJv8OG14gKtXYiurpQIueiu2/aC3DiY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845514; c=relaxed/simple;
	bh=l3ssnzBtvScILLB53w7//R5zN9mIbT55Jo4qqBtPKA0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MWSSgrCugCE12PWXltf2tPBcaQAjF9S+11XH2KwhHDBR//3SNQPDb4Qa+8SFDzOdyVsN1w716/P9UKDTDFwFwg29pZgKXgRwQ0Uh0dup4kCqi5ifzi+muAdlIGko1a2Xu+WM6K/mcd8migTj6Kex2JGiL14g7tCbL+veA17ofTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+XlQfr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+XlQfr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12B1C4CECF;
	Tue,  5 Nov 2024 22:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845513;
	bh=l3ssnzBtvScILLB53w7//R5zN9mIbT55Jo4qqBtPKA0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C+XlQfr88fE6H+yP8ahqMZ0Mu5g2r0cNMLmqrlfB6y6erh9A8AfAns4Sr0iEz4g1r
	 NSCbqVMDdEz9FCoGDbzmHfgnF/OXQ36FhK3I7PTOZE+J2HZK8gqLQ8eYwkmfXBvJlN
	 Z9kH6bpwSjEMHcbGId0jwxhBbpBkeEHA3a7X99rxIKXk+MgEQGmYuLFx9E6n8+UevA
	 wOkfuM1gP3mnMxBFJuILXyz9p91dj4JIbMKtQd5HEEVfpirzuSGX6gfqK3YK6qkl0T
	 XSI2Nr60Kegh9DJJ7K9eqHm3+TRO+y6c5XsQevcKoihNFZhamWMbpv3kxwKzdS8uxM
	 fP4XEWkGJk+kw==
Date: Tue, 05 Nov 2024 14:25:13 -0800
Subject: [PATCH 05/21] xfs: support caching rtgroup metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084397025.1871025.5477335800274925334.stgit@frogsfrogsfrogs>
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
index 39e07e98eda1e5..9aa8f5e5525d3d 100644
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
@@ -250,3 +252,124 @@ xfs_rtginode_lockdep_setup(
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
index 7d82eb753fd097..2c894df723a786 100644
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
@@ -210,6 +221,22 @@ void xfs_rtgroup_lock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
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
index d491e31d33aac3..0c90625374a8ee 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -128,6 +128,7 @@ typedef struct xfs_mount {
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


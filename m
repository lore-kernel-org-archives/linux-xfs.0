Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D1A1CD06
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372299; cv=none; b=h0ZKFB2hjNu0NA7BRp4PwRxDpO7Hz81w2YLjDyyMv7K2Murnz1ha6DkQfcNK+/FnsUDglqUIb6PJdlYeeBVmDsYCqZVyTOqYf28920WhP36d3vMS45FHdDRzlbVAC83huovTmuOr4wiCXFyJYhhU1uwNDfA1T4Bl4qcigm0Et04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372299; c=relaxed/simple;
	bh=inSqoDNQ8qIQIOISPh5/dpX9rtVpCDBqs9VM4Eh+pNM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=anIYkWLNXX+tICmUJdlr7jVmZENsJ9BRH1I7lIbBkhI5HiphD0sDWHLbhkpjaZKR/QPXlTCQavrzbB8x3xmndiC7zFeoGQk10vRNa0tYIl737M9g7YZc4DU+tAa2phFbpAfajDrVSwKX9R8PxlxYAH2XV+TUtIrneT+MC+wPrXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oMOt/by8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oMOt/by8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01A7C4AF11;
	Fri, 23 Aug 2024 00:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372298;
	bh=inSqoDNQ8qIQIOISPh5/dpX9rtVpCDBqs9VM4Eh+pNM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oMOt/by8KrcOxSTSsILafGJl4A9O3B+2teluA0q+1QI3YT/4mhcxT3DM24Zrypmb3
	 3Jk6vbzWFGa1z9yd2twzIOsW7HTqOXEQMZ8SSuna2dhguoquaaxad1Us1jrpTCNlNB
	 HJ5QwWtC45uEMs8O5u5FgM1hRjMdCp1diUVQzIjGQd7/SyTCKG4k7UwCl9Xn+UyotI
	 BEO0b+KFRc+trV6Cxv0NQ6hI+aTiaixR4rZeA7YoyQEwZqT5ENDNhEoYyC9cegTE4n
	 LVcpziQd8ddMNbXmYXUHNkQTf8kJV7Fs1noUUGUyXbmA7Ayp8bVErjJDyBYPkkF3Mj
	 sQartB2ruUhYw==
Date: Thu, 22 Aug 2024 17:18:18 -0700
Subject: [PATCH 14/24] xfs: support caching rtgroup metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087487.59588.6672080001636292983.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_rtgroup.c |  182 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |   28 +++++++
 fs/xfs/xfs_mount.h          |    1 
 fs/xfs/xfs_rtalloc.c        |   48 +++++++++++
 4 files changed, 258 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index ae6d67c673b1a..50e4a56d749f0 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -30,6 +30,8 @@
 #include "xfs_icache.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_metafile.h"
+#include "xfs_metadir.h"
 
 /*
  * Passive reference counting access wrappers to the rtgroup structures.  If
@@ -295,3 +297,183 @@ xfs_rtginode_lockdep_setup(
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
+
+	/* Create this rtgroup metadata inode and initialize it. */
+	int			(*create)(struct xfs_rtgroup *rtg,
+					  struct xfs_inode *ip,
+					  struct xfs_trans *tp,
+					  bool init);
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
+	return ops->enabled(rtg->rtg_mount);
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
+	path = xfs_rtginode_path(rtg->rtg_rgno, type);
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
+	if (XFS_IS_CORRUPT(mp, ip->i_projid != rtg->rtg_rgno)) {
+		xfs_irele(ip);
+		return -EFSCORRUPTED;
+	}
+
+	xfs_rtginode_lockdep_setup(ip, rtg->rtg_rgno, type);
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
+/* Add a metadata inode for a realtime rmap btree. */
+int
+xfs_rtginode_create(
+	struct xfs_rtgroup		*rtg,
+	enum xfs_rtg_inodes		type,
+	bool				init)
+{
+	const struct xfs_rtginode_ops	*ops = &xfs_rtginode_ops[type];
+	struct xfs_mount		*mp = rtg->rtg_mount;
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
+	upd.path = xfs_rtginode_path(rtg->rtg_rgno, type);
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
+	xfs_rtginode_lockdep_setup(upd.ip, rtg->rtg_rgno, type);
+
+	upd.ip->i_projid = rtg->rtg_rgno;
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
index d2eb2cd5775dd..b5c769211b4bb 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -9,6 +9,14 @@
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
@@ -19,6 +27,9 @@ struct xfs_rtgroup {
 	atomic_t		rtg_active_ref;	/* active reference count */
 	wait_queue_head_t	rtg_active_wq;/* woken active_ref falls to zero */
 
+	/* per-rtgroup metadata inodes */
+	struct xfs_inode	*rtg_inodes[1 /* hack */];
+
 	/* Number of blocks in this group */
 	xfs_rtxnum_t		rtg_extents;
 
@@ -218,6 +229,23 @@ void xfs_rtgroup_lock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
 void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
 void xfs_rtgroup_trans_join(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		unsigned int rtglock_flags);
+
+int xfs_rtginode_mkdir_parent(struct xfs_mount *mp);
+int xfs_rtginode_load_parent(struct xfs_trans *tp);
+
+const char *xfs_rtginode_name(enum xfs_rtg_inodes type);
+bool xfs_rtginode_enabled(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type);
+int xfs_rtginode_load(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
+		struct xfs_trans *tp);
+int xfs_rtginode_create(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
+		bool init);
+void xfs_rtginode_irele(struct xfs_inode **ipp);
+
+static inline const char *xfs_rtginode_path(xfs_rgnumber_t rgno,
+		enum xfs_rtg_inodes type)
+{
+	return kasprintf(GFP_KERNEL, "%u.%s", rgno, xfs_rtginode_name(type));
+}
 #else
 # define xfs_rtgroup_extents(mp, rgno)		(0)
 # define xfs_rtgroup_lock(rtg, gf)		((void)0)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f69da6802e8c1..73959c26075a5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -94,6 +94,7 @@ typedef struct xfs_mount {
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
 	struct xfs_inode	*m_metadirip;	/* ptr to metadata directory */
+	struct xfs_inode	*m_rtdirip;	/* ptr to realtime metadir */
 	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
 	struct xfs_buftarg	*m_ddev_targp;	/* data device */
 	struct xfs_buftarg	*m_logdev_targp;/* log device */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 59898117f817d..dcdb726ebe4a0 100644
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
@@ -1127,6 +1138,18 @@ xfs_rtmount_iread_extents(
 	return error;
 }
 
+static void
+xfs_rtgroup_unmount_inodes(
+	struct xfs_mount	*mp)
+{
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+
+	for_each_rtgroup(mp, rgno, rtg)
+		xfs_rtunmount_rtg(rtg);
+	xfs_rtginode_irele(&mp->m_rtdirip);
+}
+
 /*
  * Get the bitmap and summary inodes and the summary cache into the mount
  * structure at mount time.
@@ -1139,6 +1162,7 @@ xfs_rtmount_inodes(
 	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_rtgroup	*rtg;
 	xfs_rgnumber_t		rgno;
+	unsigned int		i;
 	int			error;
 
 	error = xfs_trans_alloc_empty(mp, &tp);
@@ -1169,15 +1193,34 @@ xfs_rtmount_inodes(
 	if (error)
 		goto out_rele_summary;
 
-	for_each_rtgroup(mp, rgno, rtg)
+	if (xfs_has_rtgroups(mp) && mp->m_sb.sb_rgcount > 0) {
+		error = xfs_rtginode_load_parent(tp);
+		if (error)
+			goto out_rele_rtdir;
+	}
+
+	for_each_rtgroup(mp, rgno, rtg) {
 		rtg->rtg_extents = xfs_rtgroup_extents(mp, rtg->rtg_rgno);
 
+		for (i = 0; i < XFS_RTGI_MAX; i++) {
+			error = xfs_rtginode_load(rtg, i, tp);
+			if (error) {
+				xfs_rtgroup_rele(rtg);
+				goto out_rele_inodes;
+			}
+		}
+	}
+
 	error = xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
 	if (error)
 		goto out_rele_summary;
 	xfs_trans_cancel(tp);
 	return 0;
 
+out_rele_inodes:
+	xfs_rtgroup_unmount_inodes(mp);
+out_rele_rtdir:
+	xfs_rtginode_irele(&mp->m_rtdirip);
 out_rele_summary:
 	xfs_irele(mp->m_rsumip);
 out_rele_bitmap:
@@ -1192,6 +1235,9 @@ xfs_rtunmount_inodes(
 	struct xfs_mount	*mp)
 {
 	kvfree(mp->m_rsum_cache);
+
+	xfs_rtgroup_unmount_inodes(mp);
+	xfs_rtginode_irele(&mp->m_rtdirip);
 	if (mp->m_rbmip)
 		xfs_irele(mp->m_rbmip);
 	if (mp->m_rsumip)


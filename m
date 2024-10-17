Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2692621BB11
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191639; cv=none; b=Ra3liZZnWwK6MN3JmZcnw/mnXIQo1F81ink2OAnPTnxuGYsXrmQ+04AcVm+XWGgD2QsjmXK//mzOL87tM3uF11j1CBszwcfzwU+8Tl/94yANbBFR+6E9Dhi68DI3rqwU2uz8dkinezuiPCnOhGbzmPWNedbxZYGe99EKKAy/eCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191639; c=relaxed/simple;
	bh=mOAmHgQeidq4p4ADT7AaUTj/jnz5rnZ7VtP6tCDopmI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MG2oR2KuunHON0ncdsdyTdNza3voNTBm1p85uoKqdeC0zG/8gqcuh2IYxxnBTlSu5RIJrOxaEu+dXxNVSMcbW0kxHKCU1U/9lz65/20g4QXzmqilxS1AshiizeD6I/rLPKESiUMPNUXKtyujLeeWZBQafpEiGS1Hsyq21uEh+k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vEJQMFF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vEJQMFF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF2AC4CED2;
	Thu, 17 Oct 2024 19:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191639;
	bh=mOAmHgQeidq4p4ADT7AaUTj/jnz5rnZ7VtP6tCDopmI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vEJQMFF4vsGDh61QUY2T7jS5d7EO/7o/Uk58yLpsiB+dK1JbXnmib//KRN095ipdA
	 MqDLP/7uvg/iZMbBZhkthK+v6GB3aWCHaOyNrHLenKInjwdUZgIMJ0T8wEOuEUkvn1
	 6RsPKP6++l5u/3NLiyshRbJ3yPLH7tKtfM6rn//hDWdAic0BwpW/LVE7uM/ih9C1Lo
	 3NsjQbHCvfbglERevhVe2DSBmHwyFClaKu5kLxhZVJXo/bzHAFSFV+fedNliFKLaQa
	 /NkPzRJ9MdQeiMaVDt6UVCTrp8Usr//HKjl7IrZ5ZToJUv3tC0XFMigtXI1SMZtcxU
	 4FYJBW0xbfTbQ==
Date: Thu, 17 Oct 2024 12:00:38 -0700
Subject: [PATCH 05/21] xfs: support caching rtgroup metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070482.3452315.6340934330583658510.stgit@frogsfrogsfrogs>
In-Reply-To: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
References: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
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
index abc7c303f69e5f..6a61e73389d2b4 100644
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


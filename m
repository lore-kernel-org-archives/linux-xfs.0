Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741631422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991156; cv=none; b=rNJL6qqQsIw+3rSyCGmmpedPzqWZxmgW6Ml5lffN31ViD6azfX+egbyYqixH/sUp5jAiYiwbWBE09i5fV0BIYcrDul1bYrT8f/iNxXbH2LYpwV831Ag1onTnySPtm5kjU7urqSY+qomJMTYVNpskLYNARbKaVlBTRjLhZTnZNyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991156; c=relaxed/simple;
	bh=AOCvA8QnFgIdGL+SlTXM6vfW3DvQPlmL0JPIhUB7kO0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YnB8mfTPgCw4Hcwktl1W1orDnoUzu5g7AD5tIIksOkyKVzPaS5d2ayQB639fh7LYnwy5BYHXLf8+cXSKscxZmpF+fA/dcc0w3sOa5g4rQ/2PAzXlj4nzb4Fj2eiMsovFDr8BQvoBoJohmfgAbnBSBF8jP3hsVF4ZEl7CQfF8w78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VyexPzWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VyexPzWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B8EC4CED3;
	Mon, 23 Dec 2024 21:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991156;
	bh=AOCvA8QnFgIdGL+SlTXM6vfW3DvQPlmL0JPIhUB7kO0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VyexPzWylmwwj3lBWF+IvUJk4J/47gQBXNuhrk4NrPQJl1NoBF9+a5Xv4o7IX82sZ
	 /lKGfqlRTf/nFJd/lh/qWgzwOKY+Jls8/ldqJbGYvDkwq1RToXD1klpuU1Iq8aFQjw
	 fDEDaWV+6t+zA3zro9uLNtVLONQq1M5ZgMW4RpeXRABXODciAdT7x5vsnknRS4lwT5
	 LukbXQom4W8jVvj57u8mf2y5JFbsvh7dS14QeTP2f+t9i+Ay+HNsTnmgk58JwniB0h
	 cvPN/46s42/BjQT/xj3iLei87zWEOCNkZiKNLSWGHNJec9US8dofxmhcvyOCyWmSXb
	 URu1ro0UMn1fw==
Date: Mon, 23 Dec 2024 13:59:15 -0800
Subject: [PATCH 04/52] xfs: support caching rtgroup metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942556.2295836.3753738543395675133.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 65b1231b8cea7fbe7362dceecfda76026d335536

Create the necessary per-rtgroup infrastructure that we need to load
metadata inodes into memory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_mount.h      |    1 
 libxfs/init.c            |   11 ++++
 libxfs/libxfs_api_defs.h |    1 
 libxfs/xfs_rtgroup.c     |  123 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.h     |   27 ++++++++++
 5 files changed, 162 insertions(+), 1 deletion(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 987ffea19d1586..14d640b1511cab 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -93,6 +93,7 @@ typedef struct xfs_mount {
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_metadirip;	/* ptr to metadata directory */
+	struct xfs_inode	*m_rtdirip;	/* ptr to realtime metadir */
 	struct xfs_buftarg	*m_ddev_targp;
 	struct xfs_buftarg	*m_logdev_targp;
 	struct xfs_buftarg	*m_rtdev_targp;
diff --git a/libxfs/init.c b/libxfs/init.c
index b47d8eaf4f468c..1a8084108f0778 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -846,8 +846,17 @@ libxfs_mount(
 }
 
 void
-libxfs_rtmount_destroy(xfs_mount_t *mp)
+libxfs_rtmount_destroy(
+	struct xfs_mount	*mp)
 {
+	struct xfs_rtgroup	*rtg = NULL;
+	unsigned int		i;
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		for (i = 0; i < XFS_RTGI_MAX; i++)
+			libxfs_rtginode_irele(&rtg->rtg_inodes[i]);
+	}
+	libxfs_rtginode_irele(&mp->m_rtdirip);
 	if (mp->m_rsumip)
 		libxfs_irele(mp->m_rsumip);
 	if (mp->m_rbmip)
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index c4f42754c311fc..83e31a507aca6f 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -277,6 +277,7 @@
 #define xfs_rtbitmap_getword		libxfs_rtbitmap_getword
 #define xfs_rtbitmap_setword		libxfs_rtbitmap_setword
 #define xfs_rtbitmap_wordcount		libxfs_rtbitmap_wordcount
+#define xfs_rtginode_irele		libxfs_rtginode_irele
 
 #define xfs_rtgroup_alloc		libxfs_rtgroup_alloc
 
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index ece52626584200..09dd0c2ed8769c 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -28,6 +28,8 @@
 #include "xfs_inode.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_metafile.h"
+#include "xfs_metadir.h"
 
 int
 xfs_rtgroup_alloc(
@@ -248,3 +250,124 @@ xfs_rtginode_lockdep_setup(
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
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 7d82eb753fd097..2c894df723a786 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
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


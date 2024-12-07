Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76ECD17E0
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529678; cv=none; b=bs8zYQBVX+Q9DV4nKSnzHbcIrHdkobBKCesLO5gvoZvqHZugG/PUJPbPkLfrrGYBEa2FNq7FkDI1bfDAcJZlIbGjeC75WtLWVnc47VzNwq33nR+jR2cblvMIVnLhbcy6ZhHIY+bHvfpOIecefspeZXhJMFY6t1f7wS0TTysDgM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529678; c=relaxed/simple;
	bh=TUd9iMf4oeLxMRbopGP7i3ZOfMbtSolunyWfMMVj2pk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M1EJDHPeNNamKQeFFxJfKlPZ0XnwE9A4XlCGpgxz2yMPrqbravb7nPKviGKrDsevCCL4v5EQeIZKowm04hvEk1/REWWJ4FE3w7EqYtdKX1zscbIrXtFjy8FLSQTByuw7UIndZ141I9/unXAl5eqxxEfTg9fT5qqQExzrocUr+GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pEDe0xwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pEDe0xwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17310C4CED1;
	Sat,  7 Dec 2024 00:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529677;
	bh=TUd9iMf4oeLxMRbopGP7i3ZOfMbtSolunyWfMMVj2pk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pEDe0xwgnZayOOMptA9o6kf3mf1ab5xocOaSAxw/d1EA5FOIgPZpUeIzltiZCNFeS
	 gNbKpyvaczCWjzOl/93QMA2tcM/awEN47Sg4ZSkjsguWK2Eh8kIdR2vpgcCC0NoaaP
	 RZFw9kbdFzpHMPc2YMaeQgMt6BPCtwlMMi14Ksn2sSf+yx8BTHC2fbCeh0Z37tKr+6
	 FCboN80pab5MTXqC1S/nP11RNF5lCNIJEg1KB5KFbxBC4gyHwprZvU1VhRd4bjfk3A
	 LrUQVwFdc6mAkDLbG8boKVOnOGXBmojHLWN4CjwPArr9vEJ9bGaBAa02qqquJEFOA0
	 ti3eIkzEvlmew==
Date: Fri, 06 Dec 2024 16:01:16 -0800
Subject: [PATCH 38/46] xfs: use metadir for quota inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750576.124560.12081152688951207593.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: e80fbe1ad8eff7d7d1363e14f1e493d84dd37c84

Store the quota inodes in the /quota metadata directory if metadir is
enabled.  This enables us to stop using the sb_[ugp]uotino fields in the
superblock.  From this point on, all metadata files will be children of
the metadata directory tree root.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_dquot_buf.c  |  190 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_quota_defs.h |   43 +++++++++++
 libxfs/xfs_sb.c         |    1 
 3 files changed, 234 insertions(+)


diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index db603cab92138f..599d03ac960b7b 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -14,6 +14,9 @@
 #include "xfs_quota_defs.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_health.h"
+#include "xfs_metadir.h"
+#include "xfs_metafile.h"
 
 int
 xfs_calc_dquots_per_chunk(
@@ -321,3 +324,190 @@ xfs_dquot_to_disk_ts(
 
 	return cpu_to_be32(t);
 }
+
+inline unsigned int
+xfs_dqinode_sick_mask(xfs_dqtype_t type)
+{
+	switch (type) {
+	case XFS_DQTYPE_USER:
+		return XFS_SICK_FS_UQUOTA;
+	case XFS_DQTYPE_GROUP:
+		return XFS_SICK_FS_GQUOTA;
+	case XFS_DQTYPE_PROJ:
+		return XFS_SICK_FS_PQUOTA;
+	}
+
+	ASSERT(0);
+	return 0;
+}
+
+/*
+ * Load the inode for a given type of quota, assuming that the sb fields have
+ * been sorted out.  This is not true when switching quota types on a V4
+ * filesystem, so do not use this function for that.  If metadir is enabled,
+ * @dp must be the /quota metadir.
+ *
+ * Returns -ENOENT if the quota inode field is NULLFSINO; 0 and an inode on
+ * success; or a negative errno.
+ */
+int
+xfs_dqinode_load(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dqtype_t		type,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*ip;
+	enum xfs_metafile_type	metafile_type = xfs_dqinode_metafile_type(type);
+	int			error;
+
+	if (!xfs_has_metadir(mp)) {
+		xfs_ino_t	ino;
+
+		switch (type) {
+		case XFS_DQTYPE_USER:
+			ino = mp->m_sb.sb_uquotino;
+			break;
+		case XFS_DQTYPE_GROUP:
+			ino = mp->m_sb.sb_gquotino;
+			break;
+		case XFS_DQTYPE_PROJ:
+			ino = mp->m_sb.sb_pquotino;
+			break;
+		default:
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+
+		/* Should have set 0 to NULLFSINO when loading superblock */
+		if (ino == NULLFSINO)
+			return -ENOENT;
+
+		error = xfs_trans_metafile_iget(tp, ino, metafile_type, &ip);
+	} else {
+		error = xfs_metadir_load(tp, dp, xfs_dqinode_path(type),
+				metafile_type, &ip);
+		if (error == -ENOENT)
+			return error;
+	}
+	if (error) {
+		if (xfs_metadata_is_sick(error))
+			xfs_fs_mark_sick(mp, xfs_dqinode_sick_mask(type));
+		return error;
+	}
+
+	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
+			       ip->i_df.if_format != XFS_DINODE_FMT_BTREE)) {
+		xfs_irele(ip);
+		xfs_fs_mark_sick(mp, xfs_dqinode_sick_mask(type));
+		return -EFSCORRUPTED;
+	}
+
+	if (XFS_IS_CORRUPT(mp, ip->i_projid != 0)) {
+		xfs_irele(ip);
+		xfs_fs_mark_sick(mp, xfs_dqinode_sick_mask(type));
+		return -EFSCORRUPTED;
+	}
+
+	*ipp = ip;
+	return 0;
+}
+
+/* Create a metadata directory quota inode. */
+int
+xfs_dqinode_metadir_create(
+	struct xfs_inode		*dp,
+	xfs_dqtype_t			type,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_metadir_update	upd = {
+		.dp			= dp,
+		.metafile_type		= xfs_dqinode_metafile_type(type),
+		.path			= xfs_dqinode_path(type),
+	};
+	int				error;
+
+	error = xfs_metadir_start_create(&upd);
+	if (error)
+		return error;
+
+	error = xfs_metadir_create(&upd, S_IFREG);
+	if (error)
+		return error;
+
+	xfs_trans_log_inode(upd.tp, upd.ip, XFS_ILOG_CORE);
+
+	error = xfs_metadir_commit(&upd);
+	if (error)
+		return error;
+
+	xfs_finish_inode_setup(upd.ip);
+	*ipp = upd.ip;
+	return 0;
+}
+
+#ifndef __KERNEL__
+/* Link a metadata directory quota inode. */
+int
+xfs_dqinode_metadir_link(
+	struct xfs_inode		*dp,
+	xfs_dqtype_t			type,
+	struct xfs_inode		*ip)
+{
+	struct xfs_metadir_update	upd = {
+		.dp			= dp,
+		.metafile_type		= xfs_dqinode_metafile_type(type),
+		.path			= xfs_dqinode_path(type),
+		.ip			= ip,
+	};
+	int				error;
+
+	error = xfs_metadir_start_link(&upd);
+	if (error)
+		return error;
+
+	error = xfs_metadir_link(&upd);
+	if (error)
+		return error;
+
+	xfs_trans_log_inode(upd.tp, upd.ip, XFS_ILOG_CORE);
+
+	return xfs_metadir_commit(&upd);
+}
+#endif /* __KERNEL__ */
+
+/* Create the parent directory for all quota inodes and load it. */
+int
+xfs_dqinode_mkdir_parent(
+	struct xfs_mount	*mp,
+	struct xfs_inode	**dpp)
+{
+	if (!mp->m_metadirip) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
+		return -EFSCORRUPTED;
+	}
+
+	return xfs_metadir_mkdir(mp->m_metadirip, "quota", dpp);
+}
+
+/*
+ * Load the parent directory of all quota inodes.  Pass the inode to the caller
+ * because quota functions (e.g. QUOTARM) can be called on the quota files even
+ * if quotas are not enabled.
+ */
+int
+xfs_dqinode_load_parent(
+	struct xfs_trans	*tp,
+	struct xfs_inode	**dpp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+
+	if (!mp->m_metadirip) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
+		return -EFSCORRUPTED;
+	}
+
+	return xfs_metadir_load(tp, mp->m_metadirip, "quota", XFS_METAFILE_DIR,
+			dpp);
+}
diff --git a/libxfs/xfs_quota_defs.h b/libxfs/xfs_quota_defs.h
index fb05f44f6c754a..763d941a8420c5 100644
--- a/libxfs/xfs_quota_defs.h
+++ b/libxfs/xfs_quota_defs.h
@@ -143,4 +143,47 @@ time64_t xfs_dquot_from_disk_ts(struct xfs_disk_dquot *ddq,
 		__be32 dtimer);
 __be32 xfs_dquot_to_disk_ts(struct xfs_dquot *ddq, time64_t timer);
 
+static inline const char *
+xfs_dqinode_path(xfs_dqtype_t type)
+{
+	switch (type) {
+	case XFS_DQTYPE_USER:
+		return "user";
+	case XFS_DQTYPE_GROUP:
+		return "group";
+	case XFS_DQTYPE_PROJ:
+		return "project";
+	}
+
+	ASSERT(0);
+	return NULL;
+}
+
+static inline enum xfs_metafile_type
+xfs_dqinode_metafile_type(xfs_dqtype_t type)
+{
+	switch (type) {
+	case XFS_DQTYPE_USER:
+		return XFS_METAFILE_USRQUOTA;
+	case XFS_DQTYPE_GROUP:
+		return XFS_METAFILE_GRPQUOTA;
+	case XFS_DQTYPE_PROJ:
+		return XFS_METAFILE_PRJQUOTA;
+	}
+
+	ASSERT(0);
+	return XFS_METAFILE_UNKNOWN;
+}
+
+unsigned int xfs_dqinode_sick_mask(xfs_dqtype_t type);
+
+int xfs_dqinode_load(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_dqtype_t type, struct xfs_inode **ipp);
+int xfs_dqinode_metadir_create(struct xfs_inode *dp, xfs_dqtype_t type,
+		struct xfs_inode **ipp);
+int xfs_dqinode_metadir_link(struct xfs_inode *dp, xfs_dqtype_t type,
+		struct xfs_inode *ip);
+int xfs_dqinode_mkdir_parent(struct xfs_mount *mp, struct xfs_inode **dpp);
+int xfs_dqinode_load_parent(struct xfs_trans *tp, struct xfs_inode **dpp);
+
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 2ab234f1dfce70..375324b99261af 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -855,6 +855,7 @@ xfs_sb_quota_to_disk(
 
 	if (xfs_sb_is_v5(from) &&
 	    (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)) {
+		to->sb_qflags = cpu_to_be16(from->sb_qflags);
 		to->sb_uquotino = cpu_to_be64(0);
 		to->sb_gquotino = cpu_to_be64(0);
 		to->sb_pquotino = cpu_to_be64(0);


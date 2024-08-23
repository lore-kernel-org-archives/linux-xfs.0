Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124D41C36
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371377; cv=none; b=ASlQJWF/BA7oRcH2r+IbZ7XGuRcHG+ufS3ORteaY2FxnCTfJhXwvpvdXvzJBflUMEScTQd/mKcUZDrOPpmUz0DBL/8/dqZ9qjCEGD91DRSQbJY9LKB/H0uOTMj4KGiOgJ+2Y5wySY86gPDWSvPLAWAZNXdOx3I4GdX/WD+shTbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371377; c=relaxed/simple;
	bh=cZaxc3KSPB08DyKcHVN4pN9tQSsfium6j56HkC2sX+k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ham4H8lmEK88M3Zj+HYRLP5PfNus3G4Kk/K2T+knIVYcqzgjMVhcUZ8pO1BOJUvG+E6SO5bQe6GBWrqrKLqQ/VTPrHATu4kndvir1fpVDrWzQ9r71XM6hR6wlzse0DT1ngcKrWrs/L2ll/vic/E97LbDkGpzjQQAYoEc1RaWXsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=itF5tTzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="itF5tTzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF70C32782;
	Fri, 23 Aug 2024 00:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371376;
	bh=cZaxc3KSPB08DyKcHVN4pN9tQSsfium6j56HkC2sX+k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=itF5tTzfmwDIcGiThzJ3E4qHmgLBvBmERIsPFkWpMH9f+SWM474B+UtbJPvPQEHG6
	 tvXXYvJ/8mkIRFHfy/BiInoOpbc9IZCrx/05C0ZaT5PxLW72IrIS9ANrs4xCvaAIiY
	 bqooJwNRnV7BnG4z0OFE12y35C0ik2xFFHp29y7vB/W4vfZM/JQMBQr7FCJh0f9dcQ
	 17bV+scz7+L/Ch8n2WbfKWK4pOJ2wBkw0c1/5TAkhzsOxlAw0YsiAhb4+lEokUTu9r
	 qcO/dSTSjwmV9Th1mESfMVW9xnOxmh17zBecbEUX/NwxrRw+qe1edK/5lKkkI21U7m
	 UK4kuLKCbxTFA==
Date: Thu, 22 Aug 2024 17:02:56 -0700
Subject: [PATCH 03/26] xfs: iget for metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085223.57482.4228252253880312328.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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

Create a xfs_metafile_iget function for metadata inodes to ensure that
when we try to iget a metadata file, the inobt thinks a metadata inode
is in use and that the metadata type matches what we are expecting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_metafile.h |   16 ++++++++++
 fs/xfs/xfs_icache.c          |   65 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c           |    1 +
 fs/xfs/xfs_qm.c              |   23 ++++++++++++++-
 fs/xfs/xfs_rtalloc.c         |   38 ++++++++++++++-----------
 5 files changed, 125 insertions(+), 18 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_metafile.h


diff --git a/fs/xfs/libxfs/xfs_metafile.h b/fs/xfs/libxfs/xfs_metafile.h
new file mode 100644
index 0000000000000..60fe189061127
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_metafile.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_METAFILE_H__
+#define __XFS_METAFILE_H__
+
+/* Code specific to kernel/userspace; must be provided externally. */
+
+int xfs_trans_metafile_iget(struct xfs_trans *tp, xfs_ino_t ino,
+		enum xfs_metafile_type metafile_type, struct xfs_inode **ipp);
+int xfs_metafile_iget(struct xfs_mount *mp, xfs_ino_t ino,
+		enum xfs_metafile_type metafile_type, struct xfs_inode **ipp);
+
+#endif /* __XFS_METAFILE_H__ */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 887d2a01161e4..a3d4334d4151b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -25,6 +25,9 @@
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
+#include "xfs_da_format.h"
+#include "xfs_dir2.h"
+#include "xfs_metafile.h"
 
 #include <linux/iversion.h>
 
@@ -809,6 +812,68 @@ xfs_iget(
 	return error;
 }
 
+/*
+ * Get a metadata inode.  The metafile @type must match the inode exactly.
+ * Caller must supply a transaction (even if empty) to avoid livelocking if the
+ * inobt has a cycle.
+ */
+int
+xfs_trans_metafile_iget(
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	enum xfs_metafile_type	metafile_type,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*ip;
+	umode_t			mode;
+	int			error;
+
+	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &ip);
+	if (error == -EFSCORRUPTED)
+		goto whine;
+	if (error)
+		return error;
+
+	if (VFS_I(ip)->i_nlink == 0)
+		goto bad_rele;
+
+	if (metafile_type == XFS_METAFILE_DIR)
+		mode = S_IFDIR;
+	else
+		mode = S_IFREG;
+	if (inode_wrong_type(VFS_I(ip), mode))
+		goto bad_rele;
+
+	*ipp = ip;
+	return 0;
+bad_rele:
+	xfs_irele(ip);
+whine:
+	xfs_err(mp, "metadata inode 0x%llx is corrupt", ino);
+	return -EFSCORRUPTED;
+}
+
+/* Grab a metadata file if the caller doesn't already have a transaction. */
+int
+xfs_metafile_iget(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	enum xfs_metafile_type	metafile_type,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	error = xfs_trans_metafile_iget(tp, ino, metafile_type, ipp);
+	xfs_trans_cancel(tp);
+	return error;
+}
+
 /*
  * Grab the inode for reclaim exclusively.
  *
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9ea7a18f5da14..e1c65507479cd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -43,6 +43,7 @@
 #include "xfs_parent.h"
 #include "xfs_xattr.h"
 #include "xfs_inode_util.h"
+#include "xfs_metafile.h"
 
 struct kmem_cache *xfs_inode_cache;
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 7e2307921deb2..d0674d84af3ec 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -27,6 +27,8 @@
 #include "xfs_ialloc.h"
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
+#include "xfs_da_format.h"
+#include "xfs_metafile.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -733,6 +735,17 @@ xfs_qm_destroy_quotainfo(
 	mp->m_quotainfo = NULL;
 }
 
+static inline enum xfs_metafile_type
+xfs_qm_metafile_type(
+	unsigned int		flags)
+{
+	if (flags & XFS_QMOPT_UQUOTA)
+		return XFS_METAFILE_USRQUOTA;
+	else if (flags & XFS_QMOPT_GQUOTA)
+		return XFS_METAFILE_GRPQUOTA;
+	return XFS_METAFILE_PRJQUOTA;
+}
+
 /*
  * Create an inode and return with a reference already taken, but unlocked
  * This is how we create quota inodes
@@ -744,6 +757,7 @@ xfs_qm_qino_alloc(
 	unsigned int		flags)
 {
 	struct xfs_trans	*tp;
+	enum xfs_metafile_type	metafile_type = xfs_qm_metafile_type(flags);
 	int			error;
 	bool			need_alloc = true;
 
@@ -777,9 +791,10 @@ xfs_qm_qino_alloc(
 			}
 		}
 		if (ino != NULLFSINO) {
-			error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
+			error = xfs_metafile_iget(mp, ino, metafile_type, ipp);
 			if (error)
 				return error;
+
 			mp->m_sb.sb_gquotino = NULLFSINO;
 			mp->m_sb.sb_pquotino = NULLFSINO;
 			need_alloc = false;
@@ -1553,16 +1568,20 @@ xfs_qm_qino_load(
 	struct xfs_inode	**ipp)
 {
 	xfs_ino_t		ino = NULLFSINO;
+	enum xfs_metafile_type	metafile_type = XFS_METAFILE_UNKNOWN;
 
 	switch (type) {
 	case XFS_DQTYPE_USER:
 		ino = mp->m_sb.sb_uquotino;
+		metafile_type = XFS_METAFILE_USRQUOTA;
 		break;
 	case XFS_DQTYPE_GROUP:
 		ino = mp->m_sb.sb_gquotino;
+		metafile_type = XFS_METAFILE_GRPQUOTA;
 		break;
 	case XFS_DQTYPE_PROJ:
 		ino = mp->m_sb.sb_pquotino;
+		metafile_type = XFS_METAFILE_PRJQUOTA;
 		break;
 	default:
 		ASSERT(0);
@@ -1572,7 +1591,7 @@ xfs_qm_qino_load(
 	if (ino == NULLFSINO)
 		return -ENOENT;
 
-	return xfs_iget(mp, NULL, ino, 0, 0, ipp);
+	return xfs_metafile_iget(mp, ino, metafile_type, ipp);
 }
 
 /*
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ebeab8e4dab10..b4c3c5a3171bf 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -25,6 +25,8 @@
 #include "xfs_quota.h"
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
+#include "xfs_da_format.h"
+#include "xfs_metafile.h"
 
 /*
  * Return whether there are any free extents in the size range given
@@ -1206,16 +1208,12 @@ xfs_rtalloc_reinit_frextents(
  */
 static inline int
 xfs_rtmount_iread_extents(
+	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	unsigned int		lock_class)
 {
-	struct xfs_trans	*tp;
 	int			error;
 
-	error = xfs_trans_alloc_empty(ip->i_mount, &tp);
-	if (error)
-		return error;
-
 	xfs_ilock(ip, XFS_ILOCK_EXCL | lock_class);
 
 	error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
@@ -1230,7 +1228,6 @@ xfs_rtmount_iread_extents(
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL | lock_class);
-	xfs_trans_cancel(tp);
 	return error;
 }
 
@@ -1238,43 +1235,52 @@ xfs_rtmount_iread_extents(
  * Get the bitmap and summary inodes and the summary cache into the mount
  * structure at mount time.
  */
-int					/* error */
+int
 xfs_rtmount_inodes(
-	xfs_mount_t	*mp)		/* file system mount structure */
+	struct xfs_mount	*mp)
 {
-	int		error;		/* error return value */
-	xfs_sb_t	*sbp;
+	struct xfs_trans	*tp;
+	struct xfs_sb		*sbp = &mp->m_sb;
+	int			error;
 
-	sbp = &mp->m_sb;
-	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	error = xfs_trans_metafile_iget(tp, mp->m_sb.sb_rbmino,
+			XFS_METAFILE_RTBITMAP, &mp->m_rbmip);
 	if (xfs_metadata_is_sick(error))
 		xfs_rt_mark_sick(mp, XFS_SICK_RT_BITMAP);
 	if (error)
-		return error;
+		goto out_trans;
 	ASSERT(mp->m_rbmip != NULL);
 
-	error = xfs_rtmount_iread_extents(mp->m_rbmip, XFS_ILOCK_RTBITMAP);
+	error = xfs_rtmount_iread_extents(tp, mp->m_rbmip, XFS_ILOCK_RTBITMAP);
 	if (error)
 		goto out_rele_bitmap;
 
-	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
+	error = xfs_trans_metafile_iget(tp, mp->m_sb.sb_rsumino,
+			XFS_METAFILE_RTSUMMARY, &mp->m_rsumip);
 	if (xfs_metadata_is_sick(error))
 		xfs_rt_mark_sick(mp, XFS_SICK_RT_SUMMARY);
 	if (error)
 		goto out_rele_bitmap;
 	ASSERT(mp->m_rsumip != NULL);
 
-	error = xfs_rtmount_iread_extents(mp->m_rsumip, XFS_ILOCK_RTSUM);
+	error = xfs_rtmount_iread_extents(tp, mp->m_rsumip, XFS_ILOCK_RTSUM);
 	if (error)
 		goto out_rele_summary;
 
 	xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
+	xfs_trans_cancel(tp);
 	return 0;
 
 out_rele_summary:
 	xfs_irele(mp->m_rsumip);
 out_rele_bitmap:
 	xfs_irele(mp->m_rbmip);
+out_trans:
+	xfs_trans_cancel(tp);
 	return error;
 }
 


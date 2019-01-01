Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45306 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfAACXi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:23:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012Ehmu019070
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:37 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2pp0btp7bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:23:36 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012NaBN031226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:36 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012NaQd027728
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:36 GMT
Subject: [PATCH 11/13] xfs: ensure metadata directory paths exist before
 creating files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:23:35 -0800
Message-ID: <154630941488.21716.5321601013179303914.stgit@magnolia>
In-Reply-To: <154630934595.21716.17416691804044507782.stgit@magnolia>
References: <154630934595.21716.17416691804044507782.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since xfs_imeta_create can create new metadata files arbitrarily deep in
the metadata directory tree, we must supply a function that can ensure
that all directories in a path exist, and call it before the quota
functions create the quota inodes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_imeta.h |    2 +
 fs/xfs/xfs_inode.c        |  102 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_qm.c           |   13 ++++++
 3 files changed, 117 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index ecd2db0a4c92..33024889fc71 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -62,5 +62,7 @@ unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
 int xfs_imeta_iget(struct xfs_mount *mp, xfs_ino_t ino, unsigned char ftype,
 		  struct xfs_inode **ipp);
 void xfs_imeta_irele(struct xfs_inode *ip);
+int xfs_imeta_ensure_dirpath(struct xfs_mount *mp,
+			     const struct xfs_imeta_path *path);
 
 #endif /* __XFS_IMETA_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6a3a8137af4d..abd332a13d95 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -43,6 +43,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
+#include "xfs_imeta.h"
 
 kmem_zone_t *xfs_inode_zone;
 
@@ -927,6 +928,107 @@ xfs_create_tmpfile(
 	return error;
 }
 
+/* Create a metadata for the last component of the path. */
+STATIC int
+xfs_imeta_mkdir(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path)
+{
+	struct xfs_imeta_end		ic;
+	struct xfs_inode		*ip = NULL;
+	struct xfs_trans		*tp = NULL;
+	struct xfs_dquot		*udqp = NULL;
+	struct xfs_dquot		*gdqp = NULL;
+	struct xfs_dquot		*pdqp = NULL;
+	uint				resblks;
+	int				error;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	/* Grab the dquots from the metadata directory root. */
+	error = xfs_qm_vop_dqalloc(mp->m_metadirip, 0, 0, 0,
+			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
+			&udqp, &gdqp, &pdqp);
+	if (error)
+		return error;
+
+	/* Allocate a transaction to create the last directory. */
+	resblks = xfs_imeta_create_space_res(mp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create, resblks,
+			0, 0, &tp);
+	if (error)
+		goto out_dqrele;
+
+	/* Reserve quota for the new directory. */
+	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, pdqp,
+			resblks, 1, 0);
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out_dqrele;
+	}
+
+	/* Create the subdirectory. */
+	error = xfs_imeta_create(&tp, path, S_IFDIR, &ip, &ic);
+	if (error) {
+		xfs_trans_cancel(tp);
+		xfs_imeta_end_update(mp, &ic, error);
+		goto out_irele;
+	}
+
+	/*
+	 * Attach the dquot(s) to the inodes and modify them incore.
+	 * These ids of the inode couldn't have changed since the new
+	 * inode has been locked ever since it was created.
+	 */
+	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
+
+	error = xfs_trans_commit(tp);
+	xfs_imeta_end_update(mp, &ic, error);
+
+out_irele:
+	/* Have to finish setting up the inode to ensure it's deleted. */
+	if (ip) {
+		xfs_finish_inode_setup(ip);
+		xfs_irele(ip);
+	}
+
+out_dqrele:
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
+	return error;
+}
+
+/*
+ * Make sure that every metadata directory path component exists and is a
+ * directory.
+ */
+int
+xfs_imeta_ensure_dirpath(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path)
+{
+	struct xfs_imeta_path temp_path = {
+		.im_path		= path->im_path,
+		.im_depth		= 1,
+	};
+	unsigned int			i;
+	int				error = 0;
+
+	if (!xfs_sb_version_hasmetadir(&mp->m_sb))
+		return 0;
+
+	for (i = 0; i < path->im_depth - 1; i++) {
+		temp_path.im_depth = i + 1;
+		error = xfs_imeta_mkdir(mp, &temp_path);
+		if (error && error != -EEXIST)
+			break;
+	}
+
+	return error == -EEXIST ? 0 : error;
+}
+
 int
 xfs_link(
 	xfs_inode_t		*tdp,
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c6ab9fe531d5..00d39e98af3f 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -827,6 +827,7 @@ xfs_qm_qino_alloc(
 	struct xfs_imeta_end		ic;
 	struct xfs_trans		*tp;
 	const struct xfs_imeta_path	*path = xfs_qflags_to_imeta(flags);
+	uint				old_qflags;
 	int				error;
 	bool				need_alloc = true;
 
@@ -835,6 +836,18 @@ xfs_qm_qino_alloc(
 	if (error)
 		return error;
 
+	/*
+	 * Ensure the quota directory exists, being careful to disable quotas
+	 * while we do this.  We'll have to quotacheck anyway, so the loss
+	 * of one inode shouldn't affect the quota count.
+	 */
+	old_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
+	mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
+	error = xfs_imeta_ensure_dirpath(mp, xfs_qflags_to_imeta(flags));
+	mp->m_qflags |= old_qflags;
+	if (error)
+		return error;
+
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
 			xfs_imeta_create_space_res(mp), 0, 0, &tp);
 	if (error)

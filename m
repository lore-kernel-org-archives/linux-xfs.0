Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417C6C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00898206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:16:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HhnnBtnO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgAABQB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:16:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55560 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABQB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:16:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011FwBx093151
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=1kBrMlLS598cSr9No4P2gGYlEY04zsDQzDkzw6QV4b0=;
 b=HhnnBtnO6siYtJLxXjZdGCq3fLbCuB5bmiXxVQRtrFdRDM/6Jn3Lw2uimVyVeY//rk0O
 BwjFy7TM63UA2aZFOBjUJ4w4JgLl0ti2UlME16gH9hAx7cRGdpdtbPw37GdpYqXOz8EP
 weEqXRB76tPj7yhPOFUn8+W5ZmJsxYpgeAWbUZrQH7oUUa2IL5h132qvXw9xUXwFdPx/
 N96qioDsU1+C1q8uKShGfK0kk7O7MzK7BRL9t/KE+pGOLE2s9m+1Dk3taIjopxPLb9v1
 ctJo6v3/HoTGafQvhSS5umJxFN+dn8Q5iujmhdJzRNLg+WTYnbcGa8hzOuBpZART8w9u 5A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118uOu190233
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2x8bsrg48h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:57 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011Fuum008040
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:56 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:15:55 -0800
Subject: [PATCH 10/13] xfs: read and write metadata inode directory
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:15:53 -0800
Message-ID: <157784135341.1366873.7919534563842634069.stgit@magnolia>
In-Reply-To: <157784129036.1366873.17175097590750371047.stgit@magnolia>
References: <157784129036.1366873.17175097590750371047.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Plumb in the bits we need to look up metadata inode numbers from the
metadata inode directory and save them back.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_imeta.c      |  516 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h      |    4 
 fs/xfs/libxfs/xfs_inode_util.c |    2 
 fs/xfs/libxfs/xfs_trans_resv.c |    8 +
 fs/xfs/xfs_trace.h             |    5 
 5 files changed, 529 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index ca62ef6255eb..59193eb834ee 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -21,6 +21,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_trans_space.h"
+#include "xfs_dir2.h"
 
 /*
  * Metadata Inode Number Management
@@ -41,9 +42,16 @@
  * this structure must be passed to xfs_imeta_end_update to free resources that
  * cannot be freed during the transaction.
  *
- * Right now we only support callers passing in the predefined metadata inode
- * paths; the goal is that callers will some day locate metadata inodes based
- * on a metadata inode directory structure.
+ * When the metadata inode directory (metadir) feature is enabled, we can
+ * create a complex directory tree in which to store metadata inodes.  Inodes
+ * within the metadata directory tree should have the "metadata" inode flag set
+ * to prevent them from being exposed to the outside world.
+ *
+ * Within the metadata directory tree, we avoid taking the directory IOLOCK
+ * (like the VFS does for user directories) because we assume that the higher
+ * level XFS code already controls against concurrent updates of the
+ * corresponding part of the directory tree.  We do take metadata inodes' ILOCK
+ * during updates due to the locking requirements of the bmap code.
  */
 
 /* Static metadata inode paths */
@@ -59,6 +67,10 @@ XFS_IMETA_DEFINE_PATH(XFS_IMETA_USRQUOTA,	usrquota_path);
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_GRPQUOTA,	grpquota_path);
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_PRJQUOTA,	prjquota_path);
 
+const struct xfs_imeta_path XFS_IMETA_METADIR = {
+	.im_depth = 0,
+};
+
 /* Are these two paths equal? */
 STATIC bool
 xfs_imeta_path_compare(
@@ -116,6 +128,10 @@ static const struct xfs_imeta_sbmap {
 		.path	= &XFS_IMETA_PRJQUOTA,
 		.offset	= offsetof(struct xfs_sb, sb_pquotino),
 	},
+	{
+		.path	= &XFS_IMETA_METADIR,
+		.offset	= offsetof(struct xfs_sb, sb_metadirino),
+	},
 	{ NULL, 0 },
 };
 
@@ -246,6 +262,459 @@ xfs_imeta_sb_zap(
 	return 0;
 }
 
+/* Functions for storing and retrieving metadata directory inode values. */
+
+/*
+ * Given a parent directory @dp, a metadata inode @path and component
+ * @path_idx, and the expected file type @ftype of the path component, fill out
+ * the @xname and look up the inode number in the directory, returning it in
+ * @ino.
+ */
+static inline int
+xfs_imeta_dir_lookup_component(
+	struct xfs_inode		*dp,
+	const struct xfs_imeta_path	*path,
+	unsigned int			path_idx,
+	unsigned char			ftype,
+	struct xfs_name			*xname,
+	xfs_ino_t			*ino)
+{
+	int				error;
+
+	xname->name = (const unsigned char *)path->im_path[path_idx];
+	xname->len = strlen(path->im_path[path_idx]);
+	xname->type = ftype;
+
+	trace_xfs_imeta_dir_lookup_component(dp, xname);
+
+	error = xfs_dir_lookup(NULL, dp, xname, ino, NULL);
+	if (error)
+		return error;
+	if (!xfs_verify_ino(dp->i_mount, *ino))
+		return -EFSCORRUPTED;
+	return 0;
+}
+
+/*
+ * Traverse a metadata directory tree path, returning the inode corresponding
+ * to the parent of the last path component.  If any of the path components do
+ * not exist, return -ENOENT.
+ */
+STATIC int
+xfs_imeta_dir_parent(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		**dpp)
+{
+	struct xfs_name			xname;
+	struct xfs_inode		*dp;
+	xfs_ino_t			ino;
+	unsigned int			i;
+	int				error;
+
+	if (mp->m_metadirip == NULL)
+		return -ENOENT;
+
+	/* Grab the metadir root. */
+	error = xfs_imeta_iget(mp, mp->m_metadirip->i_ino, XFS_DIR3_FT_DIR,
+			&dp);
+	if (error)
+		return error;
+
+	/* Caller wanted the root, we're done! */
+	if (path->im_depth == 0) {
+		*dpp = dp;
+		return 0;
+	}
+
+	for (i = 0; i < path->im_depth - 1; i++) {
+		/* Look up the name in the current directory. */
+		error = xfs_imeta_dir_lookup_component(dp, path, i,
+				XFS_DIR3_FT_DIR, &xname, &ino);
+		if (error)
+			goto out_rele;
+
+		/* Drop the existing dp and pick up the new one. */
+		xfs_imeta_irele(dp);
+		error = xfs_imeta_iget(mp, ino, XFS_DIR3_FT_DIR, &dp);
+		if (error)
+			goto out_rele;
+	}
+
+	*dpp = dp;
+	return 0;
+
+out_rele:
+	xfs_imeta_irele(dp);
+	return error;
+}
+
+/*
+ * Look up a metadata inode from the metadata inode directory.  If the last
+ * path component doesn't exist, return NULLFSINO.  If any other part of the
+ * path does not exist, return -ENOENT so we can distinguish the two.
+ */
+STATIC int
+xfs_imeta_dir_lookup_int(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	xfs_ino_t			*inop)
+{
+	struct xfs_name			xname;
+	struct xfs_inode		*dp = NULL;
+	xfs_ino_t			ino;
+	int				error;
+
+	/* metadir ino is recorded in superblock */
+	if (xfs_imeta_path_compare(path, &XFS_IMETA_METADIR))
+		return xfs_imeta_sb_lookup(mp, path, inop);
+
+	ASSERT(path->im_depth > 0);
+
+	/* Find the parent of the last path component. */
+	error = xfs_imeta_dir_parent(mp, path, &dp);
+	if (error)
+		return error;
+
+	/* Look up the name in the current directory. */
+	error = xfs_imeta_dir_lookup_component(dp, path, path->im_depth - 1,
+			XFS_DIR3_FT_UNKNOWN, &xname, &ino);
+	switch (error) {
+	case 0:
+		*inop = ino;
+		break;
+	case -ENOENT:
+		*inop = NULLFSINO;
+		error = 0;
+		break;
+	}
+
+	xfs_imeta_irele(dp);
+	return error;
+}
+
+/*
+ * Look up a metadata inode from the metadata inode directory.  If any of the
+ * middle path components do not exist, we consider this corruption because
+ * only the last component is allowed to not exist.
+ */
+STATIC int
+xfs_imeta_dir_lookup(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	xfs_ino_t			*inop)
+{
+	int				error;
+
+	error = xfs_imeta_dir_lookup_int(mp, path, inop);
+	if (error == -ENOENT)
+		return -EFSCORRUPTED;
+	return error;
+}
+
+/*
+ * Load all the metadata inode pointers that are cached in the in-core
+ * superblock but live somewhere in the metadata directory tree.
+ */
+STATIC int
+xfs_imeta_dir_mount(
+	struct xfs_mount		*mp)
+{
+	const struct xfs_imeta_sbmap	*p;
+	xfs_ino_t			*sb_inop;
+	int				err2;
+	int				error = 0;
+
+	for (p = xfs_imeta_sbmaps; p->path && p->path->im_depth > 0; p++) {
+		if (p->path == &XFS_IMETA_METADIR)
+			continue;
+		sb_inop = xfs_imeta_sbmap_to_inop(mp, p);
+		err2 = xfs_imeta_dir_lookup_int(mp, p->path, sb_inop);
+		if (err2 == -ENOENT) {
+			*sb_inop = NULLFSINO;
+			continue;
+		}
+		if (!error && err2)
+			error = err2;
+	}
+
+	return error;
+}
+
+/*
+ * Create a new metadata inode and a metadata directory entry to this new
+ * inode.  There must not already be a directory entry.
+ */
+STATIC int
+xfs_imeta_dir_create(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	umode_t				mode,
+	struct xfs_inode		**ipp,
+	struct xfs_imeta_end		*cleanup)
+{
+	struct xfs_ialloc_args args = {
+		.nlink			= S_ISDIR(mode) ? 2 : 1,
+		.mode			= mode,
+	};
+	struct xfs_name			xname;
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	struct xfs_inode		*dp = NULL;
+	xfs_ino_t			*sb_inop;
+	xfs_ino_t			ino;
+	unsigned int			resblks;
+	int				error;
+
+	/* metadir ino is recorded in superblock */
+	if (xfs_imeta_path_compare(path, &XFS_IMETA_METADIR)) {
+		error = xfs_imeta_sb_create(tpp, path, mode, ipp);
+		if (error)
+			return error;
+
+		/* Set the metadata iflag, initialize directory. */
+		(*ipp)->i_d.di_flags2 |= XFS_DIFLAG2_METADATA;
+		return xfs_dir_init(*tpp, *ipp, *ipp);
+	}
+
+	ASSERT(path->im_depth > 0);
+
+	/*
+	 * Find the parent of the last path component.  If the parent path does
+	 * not exist, we consider this corruption because paths are supposed
+	 * to exist.
+	 */
+	error = xfs_imeta_dir_parent(mp, path, &dp);
+	if (error == -ENOENT)
+		return -EFSCORRUPTED;
+	if (error)
+		return error;
+
+	/* Check that the name does not already exist in the directory. */
+	error = xfs_imeta_dir_lookup_component(dp, path, path->im_depth - 1,
+			XFS_DIR3_FT_UNKNOWN, &xname, &ino);
+	switch (error) {
+	case 0:
+		error = -EEXIST;
+		break;
+	case -ENOENT:
+		error = 0;
+		break;
+	}
+	if (error)
+		goto out_rele;
+
+	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
+
+	/*
+	 * A newly created regular or special file just has one directory
+	 * entry pointing to them, but a directory also the "." entry
+	 * pointing to itself.
+	 */
+	args.pip = dp;
+	error = xfs_dir_ialloc(tpp, &args, ipp);
+	if (error)
+		goto out_ilock;
+
+	/* Set the metadata iflag */
+	(*ipp)->i_d.di_flags2 |= XFS_DIFLAG2_METADATA;
+	xfs_trans_log_inode(*tpp, *ipp, XFS_ILOG_CORE);
+
+	/*
+	 * Once we join the parent directory to the transaction we can't
+	 * release it until after the transaction commits or cancels, so we
+	 * must defer releasing it to end_update.  This is different from
+	 * regular file creation, where the vfs holds the parent dir reference
+	 * and will free it.  The caller is always responsible for releasing
+	 * ipp, even if we failed.
+	 */
+	xfs_trans_ijoin(*tpp, dp, XFS_ILOCK_EXCL);
+	cleanup->dp = dp;
+
+	/* Create the entry. */
+	if (S_ISDIR(args.mode))
+		resblks = XFS_MKDIR_SPACE_RES(mp, xname.len);
+	else
+		resblks = XFS_CREATE_SPACE_RES(mp, xname.len);
+	xname.type = xfs_mode_to_ftype(args.mode);
+	trace_xfs_imeta_dir_try_create(dp, &xname);
+	error = xfs_dir_create_new_child(*tpp, resblks, dp, &xname, *ipp);
+	if (error)
+		return error;
+	trace_xfs_imeta_dir_created(*ipp, &xname);
+
+	/* Update the in-core superblock value if there is one. */
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (sb_inop)
+		*sb_inop = (*ipp)->i_ino;
+	return 0;
+
+out_ilock:
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+out_rele:
+	xfs_imeta_irele(dp);
+	return error;
+}
+
+/*
+ * Remove the given entry from the metadata directory and drop the link count
+ * of the metadata inode.
+ */
+STATIC int
+xfs_imeta_dir_unlink(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		*ip,
+	struct xfs_imeta_end		*cleanup)
+{
+	struct xfs_name			xname;
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	struct xfs_inode		*dp = NULL;
+	xfs_ino_t			*sb_inop;
+	xfs_ino_t			ino;
+	unsigned int			resblks;
+	int				error;
+
+	/* metadir ino is recorded in superblock */
+	if (xfs_imeta_path_compare(path, &XFS_IMETA_METADIR))
+		return xfs_imeta_sb_unlink(tpp, path, ip);
+
+	ASSERT(path->im_depth > 0);
+
+	/*
+	 * Find the parent of the last path component.  If the parent path does
+	 * not exist, we consider this corruption because paths are supposed
+	 * to exist.
+	 */
+	error = xfs_imeta_dir_parent(mp, path, &dp);
+	if (error == -ENOENT)
+		return -EFSCORRUPTED;
+	if (error)
+		return error;
+
+	/* Look up the name in the current directory. */
+	error = xfs_imeta_dir_lookup_component(dp, path, path->im_depth - 1,
+			xfs_mode_to_ftype(VFS_I(ip)->i_mode), &xname, &ino);
+	switch (error) {
+	case 0:
+		if (ino != ip->i_ino)
+			error = -ENOENT;
+		break;
+	case -ENOENT:
+		error = -EFSCORRUPTED;
+		break;
+	}
+	if (error)
+		goto out_rele;
+
+	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
+
+	/*
+	 * Once we join the parent directory to the transaction we can't
+	 * release it until after the transaction commits or cancels, so we
+	 * must defer releasing it to end_update.  This is different from
+	 * regular file removal, where the vfs holds the parent dir reference
+	 * and will free it.  The unlink caller is always responsible for
+	 * releasing ip, so we don't need to take care of that.
+	 */
+	xfs_trans_ijoin(*tpp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(*tpp, ip, XFS_ILOCK_EXCL);
+	cleanup->dp = dp;
+
+	resblks = XFS_REMOVE_SPACE_RES(mp);
+	error = xfs_dir_remove_child(*tpp, resblks, dp, &xname, ip);
+	if (error)
+		return error;
+	trace_xfs_imeta_dir_unlinked(dp, &xname);
+
+	/* Update the in-core superblock value if there is one. */
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (sb_inop)
+		*sb_inop = NULLFSINO;
+	return 0;
+
+out_rele:
+	xfs_imeta_irele(dp);
+	return error;
+}
+
+/*
+ * Remove the given entry from the metadata directory, which effectively sets
+ * it to NULL.
+ */
+STATIC int
+xfs_imeta_dir_zap(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_imeta_end		*cleanup)
+{
+	struct xfs_name			xname;
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	struct xfs_inode		*dp = NULL;
+	xfs_ino_t			*sb_inop;
+	xfs_ino_t			ino;
+	unsigned int			resblks;
+	int				error;
+
+	/* metadir ino is recorded in superblock */
+	if (xfs_imeta_path_compare(path, &XFS_IMETA_METADIR))
+		return xfs_imeta_sb_zap(tpp, path);
+
+	ASSERT(path->im_depth > 0);
+
+	/*
+	 * Find the parent of the last path component.  If the parent path does
+	 * not exist, we consider this corruption because paths are supposed
+	 * to exist.
+	 */
+	error = xfs_imeta_dir_parent(mp, path, &dp);
+	if (error == -ENOENT)
+		return -EFSCORRUPTED;
+	if (error)
+		return error;
+
+	/* Look up the name in the current directory. */
+	error = xfs_imeta_dir_lookup_component(dp, path, path->im_depth - 1,
+			XFS_DIR3_FT_UNKNOWN, &xname, &ino);
+	switch (error) {
+	case 0:
+		break;
+	case -ENOENT:
+		error = 0;
+		/* fall through */
+	default:
+		goto out_rele;
+	}
+
+	xfs_ilock(dp, XFS_ILOCK_EXCL);
+
+	/*
+	 * Once we join the parent directory to the transaction we can't
+	 * release it until after the transaction commits or cancels, so we
+	 * must defer releasing it to end_update.  This is different from
+	 * regular file removal, where the vfs holds the parent dir reference
+	 * and will free it.  The unlink caller is always responsible for
+	 * releasing ip, so we don't need to take care of that.
+	 */
+	xfs_trans_ijoin(*tpp, dp, XFS_ILOCK_EXCL);
+	cleanup->dp = dp;
+
+	resblks = XFS_REMOVE_SPACE_RES(mp);
+	error = xfs_dir_removename(*tpp, dp, &xname, ino, resblks);
+	if (error)
+		return error;
+	trace_xfs_imeta_dir_zap(dp, &xname);
+
+	/* Update the in-core superblock value if there is one. */
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (sb_inop)
+		*sb_inop = NULLFSINO;
+	return 0;
+
+out_rele:
+	xfs_imeta_irele(dp);
+	return error;
+}
+
 /* General functions for managing metadata inode pointers */
 
 /*
@@ -275,7 +744,10 @@ xfs_imeta_lookup(
 
 	ASSERT(xfs_imeta_path_check(path));
 
-	error = xfs_imeta_sb_lookup(mp, path, &ino);
+	if (xfs_sb_version_hasmetadir(&mp->m_sb))
+		error = xfs_imeta_dir_lookup(mp, path, &ino);
+	else
+		error = xfs_imeta_sb_lookup(mp, path, &ino);
 	if (error)
 		return error;
 
@@ -305,9 +777,14 @@ xfs_imeta_create(
 	struct xfs_inode		**ipp,
 	struct xfs_imeta_end		*cleanup)
 {
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+
 	ASSERT(xfs_imeta_path_check(path));
 	*ipp = NULL;
+	cleanup->dp = NULL;
 
+	if (xfs_sb_version_hasmetadir(&mp->m_sb))
+		return xfs_imeta_dir_create(tpp, path, mode, ipp, cleanup);
 	return xfs_imeta_sb_create(tpp, path, mode, ipp);
 }
 
@@ -324,9 +801,14 @@ xfs_imeta_unlink(
 	struct xfs_inode		*ip,
 	struct xfs_imeta_end		*cleanup)
 {
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	cleanup->dp = NULL;
+
 	ASSERT(xfs_imeta_path_check(path));
 	ASSERT(xfs_imeta_verify((*tpp)->t_mountp, ip->i_ino));
 
+	if (xfs_sb_version_hasmetadir(&mp->m_sb))
+		return xfs_imeta_dir_unlink(tpp, path, ip, cleanup);
 	return xfs_imeta_sb_unlink(tpp, path, ip);
 }
 
@@ -343,8 +825,13 @@ xfs_imeta_zap(
 	const struct xfs_imeta_path	*path,
 	struct xfs_imeta_end		*cleanup)
 {
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	cleanup->dp = NULL;
+
 	ASSERT(xfs_imeta_path_check(path));
 
+	if (xfs_sb_version_hasmetadir(&mp->m_sb))
+		return xfs_imeta_dir_zap(tpp, path, cleanup);
 	return xfs_imeta_sb_zap(tpp, path);
 }
 
@@ -359,6 +846,10 @@ xfs_imeta_end_update(
 	int				error)
 {
 	trace_xfs_imeta_end_update(mp, 0, error, _RET_IP_);
+
+	if (cleanup->dp)
+		xfs_imeta_irele(cleanup->dp);
+	cleanup->dp = NULL;
 }
 
 /* Does this inode number refer to a static metadata inode? */
@@ -384,6 +875,9 @@ int
 xfs_imeta_mount(
 	struct xfs_mount	*mp)
 {
+	if (xfs_sb_version_hasmetadir(&mp->m_sb))
+		return xfs_imeta_dir_mount(mp);
+
 	return 0;
 }
 
@@ -392,6 +886,9 @@ unsigned int
 xfs_imeta_create_space_res(
 	struct xfs_mount	*mp)
 {
+	if (xfs_sb_version_hasmetadir(&mp->m_sb))
+		return max(XFS_MKDIR_SPACE_RES(mp, NAME_MAX),
+			   XFS_CREATE_SPACE_RES(mp, NAME_MAX));
 	return XFS_IALLOC_SPACE_RES(mp);
 }
 
@@ -402,3 +899,14 @@ xfs_imeta_unlink_space_res(
 {
 	return XFS_REMOVE_SPACE_RES(mp);
 }
+
+/* Clear the metadata iflag if we're unlinking this inode. */
+void
+xfs_imeta_droplink(
+	struct xfs_inode	*ip)
+{
+	if (VFS_I(ip)->i_nlink == 0 &&
+	    xfs_sb_version_hasmetadir(&ip->i_mount->m_sb) &&
+	    xfs_is_metadata_inode(ip))
+		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_METADATA;
+}
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index 6caf5b16f8d7..ecd2db0a4c92 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -27,7 +27,7 @@ struct xfs_imeta_path {
 
 /* Cleanup widget for metadata inode creation and deletion. */
 struct xfs_imeta_end {
-	/* empty for now */
+	struct xfs_inode	*dp;
 };
 
 /* Lookup keys for static metadata inodes. */
@@ -36,6 +36,7 @@ extern const struct xfs_imeta_path XFS_IMETA_RTSUMMARY;
 extern const struct xfs_imeta_path XFS_IMETA_USRQUOTA;
 extern const struct xfs_imeta_path XFS_IMETA_GRPQUOTA;
 extern const struct xfs_imeta_path XFS_IMETA_PRJQUOTA;
+extern const struct xfs_imeta_path XFS_IMETA_METADIR;
 
 int xfs_imeta_lookup(struct xfs_mount *mp, const struct xfs_imeta_path *path,
 		     xfs_ino_t *ino);
@@ -52,6 +53,7 @@ void xfs_imeta_end_update(struct xfs_mount *mp, struct xfs_imeta_end *cleanup,
 
 bool xfs_is_static_meta_ino(struct xfs_mount *mp, xfs_ino_t ino);
 int xfs_imeta_mount(struct xfs_mount *mp);
+void xfs_imeta_droplink(struct xfs_inode *ip);
 
 unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
 unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 52a12a665ca2..3bdbe7694499 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -20,6 +20,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_inode_item.h"
+#include "xfs_imeta.h"
 
 uint16_t
 xfs_flags2diflags(
@@ -929,6 +930,7 @@ xfs_droplink(
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
 	drop_nlink(VFS_I(ip));
+	xfs_imeta_droplink(ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (VFS_I(ip)->i_nlink)
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 8dc7aa72cf8f..dad9bf11ad20 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -844,7 +844,10 @@ xfs_calc_imeta_create_resv(
 	unsigned int		ret;
 
 	ret = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
-	ret += resp->tr_create.tr_logres;
+	if (xfs_sb_version_hasmetadir(&mp->m_sb))
+		ret += max(resp->tr_create.tr_logres, resp->tr_mkdir.tr_logres);
+	else
+		ret += resp->tr_create.tr_logres;
 	return ret;
 }
 
@@ -854,6 +857,9 @@ xfs_calc_imeta_create_count(
 	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resp)
 {
+	if (xfs_sb_version_hasmetadir(&mp->m_sb))
+		return max(resp->tr_create.tr_logcount,
+			   resp->tr_mkdir.tr_logcount);
 	return resp->tr_create.tr_logcount;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 850d2aa2b189..6ed9139b1463 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3820,6 +3820,11 @@ DEFINE_IMETA_SB_EVENT(xfs_imeta_sb_create);
 DEFINE_IMETA_SB_EVENT(xfs_imeta_sb_unlink);
 DEFINE_IMETA_SB_EVENT(xfs_imeta_sb_zap);
 DEFINE_AG_ERROR_EVENT(xfs_imeta_end_update);
+DEFINE_NAMESPACE_EVENT(xfs_imeta_dir_lookup_component);
+DEFINE_NAMESPACE_EVENT(xfs_imeta_dir_try_create);
+DEFINE_NAMESPACE_EVENT(xfs_imeta_dir_created);
+DEFINE_NAMESPACE_EVENT(xfs_imeta_dir_unlinked);
+DEFINE_NAMESPACE_EVENT(xfs_imeta_dir_zap);
 
 #endif /* _TRACE_XFS_H */
 


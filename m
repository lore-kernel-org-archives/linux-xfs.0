Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1AFC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74171206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VSzF6mpU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgAABPG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:15:06 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51958 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABPF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:15:05 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EPOP094431
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=65H2q7YH9D62Koy1fbvORrq+V565F55ed7TTLA+5CWE=;
 b=VSzF6mpUzznbUtqgplL8+cdnlqDljvbgAaJeqaEktbYIohHIgDlzY/p9twMpAtdwZYtl
 RHyQq/OfeYYuI2Rv110bzN/R5DUyEYXjg3RthZOD5YgIgfh6WV4UwIk17hL3vAq+WrJY
 Ta+g568mqSxs6Jy2f1fRS9DPS9Vx/VXIx6Lh94oL+LfYHktLaHTvMHGY+E1UXZGFfj1C
 5w98jL8OHwHTxV9enJy+syXm/JC7f5vSOQrpGfzEEOe0oLr6rD9VPOH4cwpeFqHYk2NZ
 TZj98EqEHiVJkm3egILavrCB00/yV2jEMbxf4eV8SMlMxBpkJy/ECc5ZBLQHreG6ga4V Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118wVu172138
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2x8gj919pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:01 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011F0Ij001039
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:00 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:14:59 -0800
Subject: [PATCH 01/13] xfs: create imeta abstractions to get and set
 metadata inodes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:14:57 -0800
Message-ID: <157784129700.1366873.18240180756114563769.stgit@magnolia>
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

Create some helper routines to get and set metadata inode numbers
instead of open-coding them throughout xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile           |    1 
 fs/xfs/libxfs/xfs_imeta.c |  380 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h |   43 +++++
 fs/xfs/libxfs/xfs_types.c |    5 -
 fs/xfs/xfs_mount.c        |   21 ++
 fs/xfs/xfs_trace.h        |   29 +++
 6 files changed, 476 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_imeta.c
 create mode 100644 fs/xfs/libxfs/xfs_imeta.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a260400f19a3..0460f96d282b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -38,6 +38,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_ialloc.o \
 				   xfs_ialloc_btree.o \
 				   xfs_iext_tree.o \
+				   xfs_imeta.o \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_inode_util.o \
diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
new file mode 100644
index 000000000000..9994b867aeab
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -0,0 +1,380 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_trans.h"
+#include "xfs_imeta.h"
+#include "xfs_trace.h"
+#include "xfs_inode.h"
+
+/*
+ * Metadata Inode Number Management
+ * ================================
+ *
+ * These functions provide an abstraction layer for looking up, creating, and
+ * deleting metadata inodes.  These pointers live in the in-core superblock,
+ * so the functions moderate access to those fields and take care of logging.
+ *
+ * For the five existing metadata inodes (real time bitmap & summary; and the
+ * user, group, and quotas) we'll continue to maintain the in-core superblock
+ * inodes for reads and only require xfs_imeta_create and xfs_imeta_unlink to
+ * persist changes.  New metadata inode types must only use the xfs_imeta_*
+ * functions.
+ *
+ * Callers wishing to create or unlink a metadata inode must pass in a
+ * xfs_imeta_end structure.  After committing or cancelling the transaction,
+ * this structure must be passed to xfs_imeta_end_update to free resources that
+ * cannot be freed during the transaction.
+ *
+ * Right now we only support callers passing in the predefined metadata inode
+ * paths; the goal is that callers will some day locate metadata inodes based
+ * on a metadata inode directory structure.
+ */
+
+/* Static metadata inode paths */
+
+const struct xfs_imeta_path XFS_IMETA_RTBITMAP = {
+	.bogus = 0,
+};
+
+const struct xfs_imeta_path XFS_IMETA_RTSUMMARY = {
+	.bogus = 1,
+};
+
+const struct xfs_imeta_path XFS_IMETA_USRQUOTA = {
+	.bogus = 2,
+};
+
+const struct xfs_imeta_path XFS_IMETA_GRPQUOTA = {
+	.bogus = 3,
+};
+
+const struct xfs_imeta_path XFS_IMETA_PRJQUOTA = {
+	.bogus = 4,
+};
+
+/* Are these two paths equal? */
+STATIC bool
+xfs_imeta_path_compare(
+	const struct xfs_imeta_path	*a,
+	const struct xfs_imeta_path	*b)
+{
+	return a == b;
+}
+
+/* Is this path ok? */
+static inline bool
+xfs_imeta_path_check(
+	const struct xfs_imeta_path	*path)
+{
+	return true;
+}
+
+/* Functions for storing and retrieving superblock inode values. */
+
+/* Mapping of metadata inode paths to in-core superblock values. */
+static const struct xfs_imeta_sbmap {
+	const struct xfs_imeta_path	*path;
+	unsigned int			offset;
+} xfs_imeta_sbmaps[] = {
+	{
+		.path	= &XFS_IMETA_RTBITMAP,
+		.offset	= offsetof(struct xfs_sb, sb_rbmino),
+	},
+	{
+		.path	= &XFS_IMETA_RTSUMMARY,
+		.offset	= offsetof(struct xfs_sb, sb_rsumino),
+	},
+	{
+		.path	= &XFS_IMETA_USRQUOTA,
+		.offset	= offsetof(struct xfs_sb, sb_uquotino),
+	},
+	{
+		.path	= &XFS_IMETA_GRPQUOTA,
+		.offset	= offsetof(struct xfs_sb, sb_gquotino),
+	},
+	{
+		.path	= &XFS_IMETA_PRJQUOTA,
+		.offset	= offsetof(struct xfs_sb, sb_pquotino),
+	},
+	{ NULL, 0 },
+};
+
+/* Return a pointer to the in-core superblock inode value. */
+static inline xfs_ino_t *
+xfs_imeta_sbmap_to_inop(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_sbmap	*map)
+{
+	return (xfs_ino_t *)(((char *)&mp->m_sb) + map->offset);
+}
+
+/* Compute location of metadata inode pointer in the in-core superblock */
+static inline xfs_ino_t *
+xfs_imeta_path_to_sb_inop(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path)
+{
+	const struct xfs_imeta_sbmap	*p;
+
+	for (p = xfs_imeta_sbmaps; p->path; p++)
+		if (xfs_imeta_path_compare(p->path, path))
+			return xfs_imeta_sbmap_to_inop(mp, p);
+
+	return NULL;
+}
+
+/* Look up a superblock metadata inode by its path. */
+STATIC int
+xfs_imeta_sb_lookup(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	xfs_ino_t			*inop)
+{
+	xfs_ino_t			*sb_inop;
+
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (!sb_inop)
+		return -EINVAL;
+
+	trace_xfs_imeta_sb_lookup(mp, sb_inop);
+	*inop = *sb_inop;
+	return 0;
+}
+
+/*
+ * Create a new metadata inode and set a superblock pointer to this new inode.
+ * The superblock field must not already be pointing to an inode.
+ */
+STATIC int
+xfs_imeta_sb_create(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	umode_t				mode,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_ialloc_args args = {
+		.nlink			= S_ISDIR(mode) ? 2 : 1,
+		.mode			= mode,
+	};
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	xfs_ino_t			*sb_inop;
+	int				error;
+
+	/* Reject if the sb already points to some inode. */
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (!sb_inop)
+		return -EINVAL;
+
+	if (*sb_inop != NULLFSINO)
+		return -EEXIST;
+
+	/* Otherwise, create the inode and set the sb pointer. */
+	error = xfs_dir_ialloc(tpp, &args, ipp);
+	if (error)
+		return error;
+
+
+	*sb_inop = (*ipp)->i_ino;
+	trace_xfs_imeta_sb_create(mp, sb_inop);
+	xfs_log_sb(*tpp);
+	return 0;
+}
+
+/*
+ * Clear the given inode pointer from the superblock and drop the link count
+ * of the metadata inode.
+ */
+STATIC int
+xfs_imeta_sb_unlink(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		*ip)
+{
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	xfs_ino_t			*sb_inop;
+
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (!sb_inop)
+		return -EINVAL;
+
+	/* Reject if the sb doesn't point to the inode that was passed in. */
+	if (*sb_inop != ip->i_ino)
+		return -ENOENT;
+
+	*sb_inop = NULLFSINO;
+	trace_xfs_imeta_sb_unlink(mp, sb_inop);
+	xfs_log_sb(*tpp);
+	return xfs_droplink(*tpp, ip);
+}
+
+/* Set the given inode pointer to NULL in the superblock. */
+STATIC int
+xfs_imeta_sb_zap(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path)
+{
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	xfs_ino_t			*sb_inop;
+
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, path);
+	if (!sb_inop)
+		return -EINVAL;
+
+	*sb_inop = NULLFSINO;
+	trace_xfs_imeta_sb_zap(mp, sb_inop);
+	xfs_log_sb(*tpp);
+	return 0;
+}
+
+/* General functions for managing metadata inode pointers */
+
+/*
+ * Is this metadata inode pointer ok?  We allow the fields to be set to
+ * NULLFSINO if the metadata structure isn't present, and we don't allow
+ * obviously incorrect inode pointers.
+ */
+static inline bool
+xfs_imeta_verify(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	if (ino == NULLFSINO)
+		return true;
+	return xfs_verify_ino(mp, ino);
+}
+
+/* Look up a metadata inode by its path. */
+int
+xfs_imeta_lookup(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	xfs_ino_t			*inop)
+{
+	xfs_ino_t			ino;
+	int				error;
+
+	ASSERT(xfs_imeta_path_check(path));
+
+	error = xfs_imeta_sb_lookup(mp, path, &ino);
+	if (error)
+		return error;
+
+	if (!xfs_imeta_verify(mp, ino))
+		return -EFSCORRUPTED;
+
+	*inop = ino;
+	return 0;
+}
+
+/*
+ * Create a metadata inode with the given @mode, and insert it into the
+ * metadata directory tree at the given @path.  The path (up to the final
+ * component) must already exist.  The new metadata inode @ipp will be ijoined
+ * and logged to @tpp, with the ILOCK held until the next transaction commit.
+ * The caller must provide a @cleanup structure.
+ *
+ * NOTE: This function may pass a child inode @ipp back to the caller along
+ * with an error status code.  The caller must always check for a non-null
+ * child inode and release it.
+ */
+int
+xfs_imeta_create(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	umode_t				mode,
+	struct xfs_inode		**ipp,
+	struct xfs_imeta_end		*cleanup)
+{
+	ASSERT(xfs_imeta_path_check(path));
+	*ipp = NULL;
+
+	return xfs_imeta_sb_create(tpp, path, mode, ipp);
+}
+
+/*
+ * Unlink a metadata inode @ip from the metadata directory given by @path.  The
+ * metadata inode must not be ILOCKed.  Upon return, the inode will be ijoined
+ * and logged to @tpp, and returned with reduced link count, ready to be
+ * released.  The caller must provide a @cleanup structure.
+ */
+int
+xfs_imeta_unlink(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		*ip,
+	struct xfs_imeta_end		*cleanup)
+{
+	ASSERT(xfs_imeta_path_check(path));
+	ASSERT(xfs_imeta_verify((*tpp)->t_mountp, ip->i_ino));
+
+	return xfs_imeta_sb_unlink(tpp, path, ip);
+}
+
+/*
+ * Forcibly clear the metadata pointer noted by @path so that a subsequent
+ * lookup will return NULLFSINO.  If the pointer was not already NULLFSINO, the
+ * caller is responsible for cleaning up those resources; in other words, this
+ * function is only to be used when blowing out a totally destroyed metadata
+ * inode.  The caller must provide a @cleanup structure.
+ */
+int
+xfs_imeta_zap(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_imeta_end		*cleanup)
+{
+	ASSERT(xfs_imeta_path_check(path));
+
+	return xfs_imeta_sb_zap(tpp, path);
+}
+
+/*
+ * Clean up after committing (or cancelling) a metadata inode creation or
+ * removal.
+ */
+void
+xfs_imeta_end_update(
+	struct xfs_mount		*mp,
+	struct xfs_imeta_end		*cleanup,
+	int				error)
+{
+	trace_xfs_imeta_end_update(mp, 0, error, _RET_IP_);
+}
+
+/* Does this inode number refer to a static metadata inode? */
+bool
+xfs_is_static_meta_ino(
+	struct xfs_mount		*mp,
+	xfs_ino_t			ino)
+{
+	const struct xfs_imeta_sbmap	*p;
+
+	if (ino == NULLFSINO)
+		return false;
+
+	for (p = xfs_imeta_sbmaps; p->path; p++)
+		if (ino == *xfs_imeta_sbmap_to_inop(mp, p))
+			return true;
+
+	return false;
+}
+
+/* Ensure that the in-core superblock has all the values that it should. */
+int
+xfs_imeta_mount(
+	struct xfs_mount	*mp)
+{
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
new file mode 100644
index 000000000000..373d40703dec
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_IMETA_H__
+#define __XFS_IMETA_H__
+
+/* Key for looking up metadata inodes. */
+struct xfs_imeta_path {
+	/* Temporary: integer to keep the static imeta definitions unique */
+	int		bogus;
+};
+
+/* Cleanup widget for metadata inode creation and deletion. */
+struct xfs_imeta_end {
+	/* empty for now */
+};
+
+/* Lookup keys for static metadata inodes. */
+extern const struct xfs_imeta_path XFS_IMETA_RTBITMAP;
+extern const struct xfs_imeta_path XFS_IMETA_RTSUMMARY;
+extern const struct xfs_imeta_path XFS_IMETA_USRQUOTA;
+extern const struct xfs_imeta_path XFS_IMETA_GRPQUOTA;
+extern const struct xfs_imeta_path XFS_IMETA_PRJQUOTA;
+
+int xfs_imeta_lookup(struct xfs_mount *mp, const struct xfs_imeta_path *path,
+		     xfs_ino_t *ino);
+
+int xfs_imeta_create(struct xfs_trans **tpp, const struct xfs_imeta_path *path,
+		     umode_t mode, struct xfs_inode **ipp,
+		     struct xfs_imeta_end *cleanup);
+int xfs_imeta_unlink(struct xfs_trans **tpp, const struct xfs_imeta_path *path,
+		     struct xfs_inode *ip, struct xfs_imeta_end *cleanup);
+int xfs_imeta_zap(struct xfs_trans **tpp, const struct xfs_imeta_path *path,
+		  struct xfs_imeta_end *cleanup);
+void xfs_imeta_end_update(struct xfs_mount *mp, struct xfs_imeta_end *cleanup,
+			  int error);
+
+bool xfs_is_static_meta_ino(struct xfs_mount *mp, xfs_ino_t ino);
+int xfs_imeta_mount(struct xfs_mount *mp);
+
+#endif /* __XFS_IMETA_H__ */
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 4f595546a639..94ae0002a5e1 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -11,6 +11,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_imeta.h"
 
 /* Find the size of the AG, in blocks. */
 xfs_agblock_t
@@ -144,9 +145,7 @@ xfs_internal_inum(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
 {
-	return ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
-		(xfs_sb_version_hasquota(&mp->m_sb) &&
-		 xfs_is_quota_inode(&mp->m_sb, ino));
+	return xfs_is_static_meta_ino(mp, ino);
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5e2ce91f4ab8..5d4196780e79 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -32,6 +32,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_health.h"
 #include "xfs_trace.h"
+#include "xfs_imeta.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
@@ -638,6 +639,22 @@ xfs_check_summary_counts(
 	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
 }
 
+STATIC int
+xfs_mountfs_imeta(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	error = xfs_imeta_mount(mp);
+	if (error) {
+		xfs_warn(mp, "Failed to load metadata inode info, error %d",
+				error);
+		return error;
+	}
+
+	return 0;
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -857,6 +874,10 @@ xfs_mountfs(
 	if (error)
 		goto out_log_dealloc;
 
+	error = xfs_mountfs_imeta(mp);
+	if (error)
+		goto out_log_dealloc;
+
 	/*
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 30341606285a..850d2aa2b189 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3792,6 +3792,35 @@ DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
 DEFINE_EOFBLOCKS_EVENT(xfs_inode_free_quota_blocks);
 DEFINE_EOFBLOCKS_EVENT(xfs_inode_free_blocks);
 
+DECLARE_EVENT_CLASS(xfs_imeta_sb_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_ino_t *sb_inop),
+	TP_ARGS(mp, sb_inop),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, sb_offset)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->sb_offset = (char *)sb_inop - (char *)&mp->m_sb;
+		__entry->ino = *sb_inop;
+	),
+	TP_printk("dev %d:%d sb_offset 0x%x ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->sb_offset,
+		  __entry->ino)
+)
+
+#define DEFINE_IMETA_SB_EVENT(name) \
+DEFINE_EVENT(xfs_imeta_sb_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_ino_t *sb_inop), \
+	TP_ARGS(mp, sb_inop))
+DEFINE_IMETA_SB_EVENT(xfs_imeta_sb_lookup);
+DEFINE_IMETA_SB_EVENT(xfs_imeta_sb_create);
+DEFINE_IMETA_SB_EVENT(xfs_imeta_sb_unlink);
+DEFINE_IMETA_SB_EVENT(xfs_imeta_sb_zap);
+DEFINE_AG_ERROR_EVENT(xfs_imeta_end_update);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH


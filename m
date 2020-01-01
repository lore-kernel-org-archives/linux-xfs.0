Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF04C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ACA0206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hpvIEhJf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgAABNl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:13:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55504 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABNl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:13:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011CbN9111691
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=JJAjPsgVfGARTIHjMFVLUxxHtbKNGQOg6YVGLr4QkgM=;
 b=hpvIEhJfmVZEDT8pFlnk+5WxzW2QOAw/9QpsZoLbmpRJPGx38AQ7jASU228dxy16wr3u
 w8zNLZi7yGXoEKH9YC1yAf8wIjx674iaFfsxqMqQ7PiiwLqS7bFTRLR1y36OdfEHHamM
 iAXUotlmPMBO4XIB+24xhw+rduLw0v3s+OBwTIOvuP65IO7R2aNTUSQC/nps0Tdper+k
 uziII6aTjemg22OAYKDGaSRuTqGSpV7K2WJt4sfcE+4yq8l32Y9Wu3bY9WpdjO12i9Eu
 fqPF7sxClHOuCiBKJeIKlGXUetTryp9tRTXyUshSAoW0mBzmDJc0OIj97yCJuVsXM58j zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk2j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xfE012445
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2x8guef3pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:36 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011DYh9000618
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:35 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:13:34 -0800
Subject: [PATCH 09/21] xfs: hoist inode allocation function
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:13:31 -0800
Message-ID: <157784121185.1365473.15162105803170028827.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
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
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the inode allocation function into libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c |  248 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |   18 +++
 fs/xfs/libxfs/xfs_shared.h     |    9 -
 fs/xfs/xfs_inode.c             |  246 ----------------------------------------
 fs/xfs/xfs_inode.h             |    1 
 fs/xfs/xfs_trans.h             |    1 
 6 files changed, 267 insertions(+), 256 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 6931871b109d..30c6e4c5aae9 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
+#include <linux/iversion.h>
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
@@ -13,6 +14,9 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_inode_util.h"
+#include "xfs_trans.h"
+#include "xfs_ialloc.h"
+#include "xfs_health.h"
 
 uint16_t
 xfs_flags2diflags(
@@ -136,3 +140,247 @@ xfs_get_initial_prid(
 
 	return XFS_PROJID_DEFAULT;
 }
+
+/*
+ * Initialize a newly allocated inode with the given arguments.  Heritable
+ * inode properties will be copied from the parent if one is supplied and the
+ * appropriate inode flags are set on the parent.
+ */
+void
+xfs_inode_init(
+	struct xfs_trans		*tp,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_inode		*ip)
+{
+	struct xfs_inode		*pip = args->pip;
+	struct inode			*inode = VFS_I(ip);
+	int				times;
+	uint				flags;
+
+	/*
+	 * We always convert v1 inodes to v2 now - we only support filesystems
+	 * with >= v2 inode capability, so there is no reason for ever leaving
+	 * an inode in v1 format.
+	 */
+	if (ip->i_d.di_version == 1)
+		ip->i_d.di_version = 2;
+
+	inode->i_mode = args->mode;
+	set_nlink(inode, args->nlink);
+	ip->i_d.di_uid = args->uid;
+	ip->i_d.di_gid = args->gid;
+	inode->i_rdev = args->rdev;
+	ip->i_d.di_projid = args->prid;
+
+	if (pip && XFS_INHERIT_GID(pip)) {
+		ip->i_d.di_gid = pip->i_d.di_gid;
+		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(args->mode))
+			inode->i_mode |= S_ISGID;
+	}
+
+	/*
+	 * If the group ID of the new file does not match the effective group
+	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
+	 * (and only if the irix_sgid_inherit compatibility variable is set).
+	 */
+	if ((irix_sgid_inherit) &&
+	    (inode->i_mode & S_ISGID) &&
+	    (!in_group_p(xfs_gid_to_kgid(ip->i_d.di_gid))))
+		inode->i_mode &= ~S_ISGID;
+
+	ip->i_d.di_size = 0;
+	ip->i_d.di_nextents = 0;
+	ASSERT(ip->i_d.di_nblocks == 0);
+
+	times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG | XFS_ICHGTIME_ACCESS;
+	ip->i_d.di_extsize = 0;
+	ip->i_d.di_dmevmask = 0;
+	ip->i_d.di_dmstate = 0;
+	ip->i_d.di_flags = 0;
+
+	if (ip->i_d.di_version == 3) {
+		inode_set_iversion(inode, 1);
+		ip->i_d.di_flags2 = 0;
+		if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb))
+			ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
+		ip->i_d.di_cowextsize = 0;
+		times |= XFS_ICHGTIME_CREATE;
+	}
+
+	xfs_trans_ichgtime(tp, ip, times);
+
+	flags = XFS_ILOG_CORE;
+	switch (args->mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		ip->i_d.di_format = XFS_DINODE_FMT_DEV;
+		ip->i_df.if_flags = 0;
+		flags |= XFS_ILOG_DEV;
+		break;
+	case S_IFREG:
+	case S_IFDIR:
+		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
+			uint		di_flags = 0;
+
+			if (S_ISDIR(args->mode)) {
+				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+					di_flags |= XFS_DIFLAG_RTINHERIT;
+				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
+					ip->i_d.di_extsize = pip->i_d.di_extsize;
+				}
+				if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+					di_flags |= XFS_DIFLAG_PROJINHERIT;
+			} else if (S_ISREG(args->mode)) {
+				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+					di_flags |= XFS_DIFLAG_REALTIME;
+				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+					di_flags |= XFS_DIFLAG_EXTSIZE;
+					ip->i_d.di_extsize = pip->i_d.di_extsize;
+				}
+			}
+			if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
+			    xfs_inherit_noatime)
+				di_flags |= XFS_DIFLAG_NOATIME;
+			if ((pip->i_d.di_flags & XFS_DIFLAG_NODUMP) &&
+			    xfs_inherit_nodump)
+				di_flags |= XFS_DIFLAG_NODUMP;
+			if ((pip->i_d.di_flags & XFS_DIFLAG_SYNC) &&
+			    xfs_inherit_sync)
+				di_flags |= XFS_DIFLAG_SYNC;
+			if ((pip->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) &&
+			    xfs_inherit_nosymlinks)
+				di_flags |= XFS_DIFLAG_NOSYMLINKS;
+			if ((pip->i_d.di_flags & XFS_DIFLAG_NODEFRAG) &&
+			    xfs_inherit_nodefrag)
+				di_flags |= XFS_DIFLAG_NODEFRAG;
+			if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
+				di_flags |= XFS_DIFLAG_FILESTREAM;
+
+			ip->i_d.di_flags |= di_flags;
+		}
+		if (pip &&
+		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
+		    pip->i_d.di_version == 3 &&
+		    ip->i_d.di_version == 3) {
+			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
+				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
+			}
+			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
+				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
+		}
+		/* FALLTHROUGH */
+	case S_IFLNK:
+		ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
+		ip->i_df.if_flags = XFS_IFEXTENTS;
+		ip->i_df.if_bytes = 0;
+		ip->i_df.if_u1.if_root = NULL;
+		break;
+	default:
+		ASSERT(0);
+	}
+	/*
+	 * Attribute fork settings for new inode.
+	 */
+	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
+	ip->i_d.di_anextents = 0;
+
+	/*
+	 * Log the new values stuffed into the inode.
+	 */
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_log_inode(tp, ip, flags);
+
+	/* now that we have an i_mode we can setup the inode structure */
+	xfs_setup_inode(ip);
+}
+
+/*
+ * Allocate an inode on disk and return a copy of its in-core version.
+ * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
+ * appropriately within the inode.  The uid and gid for the inode are
+ * set according to the contents of the given cred structure.
+ *
+ * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
+ * has a free inode available, call xfs_iget() to obtain the in-core
+ * version of the allocated inode.  Finally, fill in the inode and
+ * log its initial contents.  In this case, ialloc_context would be
+ * set to NULL.
+ *
+ * If xfs_dialloc() does not have an available inode, it will replenish
+ * its supply by doing an allocation. Since we can only do one
+ * allocation within a transaction without deadlocks, we must commit
+ * the current transaction before returning the inode itself.
+ * In this case, therefore, we will set ialloc_context and return.
+ * The caller should then commit the current transaction, start a new
+ * transaction, and call xfs_ialloc() again to actually get the inode.
+ *
+ * To ensure that some other process does not grab the inode that
+ * was allocated during the first call to xfs_ialloc(), this routine
+ * also returns the [locked] bp pointing to the head of the freelist
+ * as ialloc_context.  The caller should hold this buffer across
+ * the commit and pass it back into this routine on the second call.
+ *
+ * If we are allocating quota inodes, we do not have a parent inode
+ * to attach to or associate with (i.e. pip == NULL) because they
+ * are not linked into the directory structure - they are attached
+ * directly to the superblock - and so have no parent.
+ */
+int
+xfs_ialloc(
+	struct xfs_trans		*tp,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_buf			**ialloc_context,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_inode		*pip = args->pip;
+	struct xfs_inode		*ip;
+	xfs_ino_t			ino;
+	int				error;
+
+	/*
+	 * Call the space management code to pick
+	 * the on-disk inode to be allocated.
+	 */
+	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, args->mode,
+			    ialloc_context, &ino);
+	if (error)
+		return error;
+	if (*ialloc_context || ino == NULLFSINO) {
+		*ipp = NULL;
+		return 0;
+	}
+	ASSERT(*ialloc_context == NULL);
+
+	/*
+	 * Protect against obviously corrupt allocation btree records. Later
+	 * xfs_iget checks will catch re-allocation of other active in-memory
+	 * and on-disk inodes. If we don't catch reallocating the parent inode
+	 * here we will deadlock in xfs_iget() so we have to do these checks
+	 * first.
+	 */
+	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
+		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
+		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
+				XFS_SICK_AG_INOBT);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Get the in-core inode with the lock held exclusively.
+	 * This is because we're setting fields here we need
+	 * to prevent others from looking at until we're done.
+	 */
+	error = xfs_ialloc_iget(tp, ino, &ip);
+	if (error)
+		return error;
+	ASSERT(ip != NULL);
+
+	xfs_inode_init(tp, args, ip);
+	*ipp = ip;
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 932ddcc2c618..b54495182932 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -27,4 +27,22 @@ struct xfs_ialloc_args {
 	umode_t				mode;
 };
 
+/* The libxfs client must provide this group of helper functions. */
+void xfs_setup_inode(struct xfs_inode *ip);
+/*
+ * Flags for xfs_trans_ichgtime().
+ */
+#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
+#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
+#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
+#define	XFS_ICHGTIME_ACCESS	0x8	/* last access timestamp */
+void xfs_trans_ichgtime(struct xfs_trans *tp, struct xfs_inode *ip, int flags);
+int xfs_ialloc_iget(struct xfs_trans *tp, xfs_ino_t ino,
+		    struct xfs_inode **ipp);
+
+int xfs_ialloc(struct xfs_trans *tp, const struct xfs_ialloc_args *args,
+	       struct xfs_buf **ialloc_context, struct xfs_inode **ipp);
+void xfs_inode_init(struct xfs_trans *tp, const struct xfs_ialloc_args *args,
+		    struct xfs_inode *ip);
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 41022c55289d..cd6a0d68a75f 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -115,15 +115,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_REFC_BTREE_REF	1
 #define	XFS_SSB_REF		0
 
-/*
- * Flags for xfs_trans_ichgtime().
- */
-#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
-#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
-#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
-#define	XFS_ICHGTIME_ACCESS	0x8	/* last access timestamp */
-
-
 /*
  * Symlink decoding/encoding functions
  */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7832ee9550e5..00547fdf7c15 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -622,7 +622,7 @@ xfs_lookup(
  * inode with the lock held exclusively because we're setting fields here and
  * need to prevent others from looking at the inode until we're done.
  */
-static int
+int
 xfs_ialloc_iget(
 	struct xfs_trans	*tp,
 	xfs_ino_t		ino,
@@ -632,250 +632,6 @@ xfs_ialloc_iget(
 			ipp);
 }
 
-/*
- * Initialize a newly allocated inode with the given arguments.  Heritable
- * inode properties will be copied from the parent if one is supplied and the
- * appropriate inode flags are set on the parent.
- */
-STATIC void
-xfs_inode_init(
-	struct xfs_trans		*tp,
-	const struct xfs_ialloc_args	*args,
-	struct xfs_inode		*ip)
-{
-	struct xfs_inode		*pip = args->pip;
-	struct inode			*inode = VFS_I(ip);
-	int				times;
-	uint				flags;
-
-	/*
-	 * We always convert v1 inodes to v2 now - we only support filesystems
-	 * with >= v2 inode capability, so there is no reason for ever leaving
-	 * an inode in v1 format.
-	 */
-	if (ip->i_d.di_version == 1)
-		ip->i_d.di_version = 2;
-
-	inode->i_mode = args->mode;
-	set_nlink(inode, args->nlink);
-	ip->i_d.di_uid = args->uid;
-	ip->i_d.di_gid = args->gid;
-	inode->i_rdev = args->rdev;
-	ip->i_d.di_projid = args->prid;
-
-	if (pip && XFS_INHERIT_GID(pip)) {
-		ip->i_d.di_gid = pip->i_d.di_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(args->mode))
-			inode->i_mode |= S_ISGID;
-	}
-
-	/*
-	 * If the group ID of the new file does not match the effective group
-	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
-	 * (and only if the irix_sgid_inherit compatibility variable is set).
-	 */
-	if ((irix_sgid_inherit) &&
-	    (inode->i_mode & S_ISGID) &&
-	    (!in_group_p(xfs_gid_to_kgid(ip->i_d.di_gid))))
-		inode->i_mode &= ~S_ISGID;
-
-	ip->i_d.di_size = 0;
-	ip->i_d.di_nextents = 0;
-	ASSERT(ip->i_d.di_nblocks == 0);
-
-	times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG | XFS_ICHGTIME_ACCESS;
-	ip->i_d.di_extsize = 0;
-	ip->i_d.di_dmevmask = 0;
-	ip->i_d.di_dmstate = 0;
-	ip->i_d.di_flags = 0;
-
-	if (ip->i_d.di_version == 3) {
-		inode_set_iversion(inode, 1);
-		ip->i_d.di_flags2 = 0;
-		if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb))
-			ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
-		ip->i_d.di_cowextsize = 0;
-		times |= XFS_ICHGTIME_CREATE;
-	}
-
-	xfs_trans_ichgtime(tp, ip, times);
-
-	flags = XFS_ILOG_CORE;
-	switch (args->mode & S_IFMT) {
-	case S_IFIFO:
-	case S_IFCHR:
-	case S_IFBLK:
-	case S_IFSOCK:
-		ip->i_d.di_format = XFS_DINODE_FMT_DEV;
-		ip->i_df.if_flags = 0;
-		flags |= XFS_ILOG_DEV;
-		break;
-	case S_IFREG:
-	case S_IFDIR:
-		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
-			uint		di_flags = 0;
-
-			if (S_ISDIR(args->mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
-					di_flags |= XFS_DIFLAG_RTINHERIT;
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
-					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-					ip->i_d.di_extsize = pip->i_d.di_extsize;
-				}
-				if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-					di_flags |= XFS_DIFLAG_PROJINHERIT;
-			} else if (S_ISREG(args->mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
-					di_flags |= XFS_DIFLAG_REALTIME;
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
-					di_flags |= XFS_DIFLAG_EXTSIZE;
-					ip->i_d.di_extsize = pip->i_d.di_extsize;
-				}
-			}
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
-			    xfs_inherit_noatime)
-				di_flags |= XFS_DIFLAG_NOATIME;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NODUMP) &&
-			    xfs_inherit_nodump)
-				di_flags |= XFS_DIFLAG_NODUMP;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_SYNC) &&
-			    xfs_inherit_sync)
-				di_flags |= XFS_DIFLAG_SYNC;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) &&
-			    xfs_inherit_nosymlinks)
-				di_flags |= XFS_DIFLAG_NOSYMLINKS;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NODEFRAG) &&
-			    xfs_inherit_nodefrag)
-				di_flags |= XFS_DIFLAG_NODEFRAG;
-			if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
-				di_flags |= XFS_DIFLAG_FILESTREAM;
-
-			ip->i_d.di_flags |= di_flags;
-		}
-		if (pip &&
-		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
-		    pip->i_d.di_version == 3 &&
-		    ip->i_d.di_version == 3) {
-			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
-				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
-				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
-			}
-			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
-				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
-		}
-		/* FALLTHROUGH */
-	case S_IFLNK:
-		ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
-		ip->i_df.if_flags = XFS_IFEXTENTS;
-		ip->i_df.if_bytes = 0;
-		ip->i_df.if_u1.if_root = NULL;
-		break;
-	default:
-		ASSERT(0);
-	}
-	/*
-	 * Attribute fork settings for new inode.
-	 */
-	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
-	ip->i_d.di_anextents = 0;
-
-	/*
-	 * Log the new values stuffed into the inode.
-	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, flags);
-
-	/* now that we have an i_mode we can setup the inode structure */
-	xfs_setup_inode(ip);
-}
-
-/*
- * Allocate an inode on disk and return a copy of its in-core version.
- * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
- * appropriately within the inode.  The uid and gid for the inode are
- * set according to the contents of the given cred structure.
- *
- * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
- * has a free inode available, call xfs_iget() to obtain the in-core
- * version of the allocated inode.  Finally, fill in the inode and
- * log its initial contents.  In this case, ialloc_context would be
- * set to NULL.
- *
- * If xfs_dialloc() does not have an available inode, it will replenish
- * its supply by doing an allocation. Since we can only do one
- * allocation within a transaction without deadlocks, we must commit
- * the current transaction before returning the inode itself.
- * In this case, therefore, we will set ialloc_context and return.
- * The caller should then commit the current transaction, start a new
- * transaction, and call xfs_ialloc() again to actually get the inode.
- *
- * To ensure that some other process does not grab the inode that
- * was allocated during the first call to xfs_ialloc(), this routine
- * also returns the [locked] bp pointing to the head of the freelist
- * as ialloc_context.  The caller should hold this buffer across
- * the commit and pass it back into this routine on the second call.
- *
- * If we are allocating quota inodes, we do not have a parent inode
- * to attach to or associate with (i.e. pip == NULL) because they
- * are not linked into the directory structure - they are attached
- * directly to the superblock - and so have no parent.
- */
-static int
-xfs_ialloc(
-	struct xfs_trans		*tp,
-	const struct xfs_ialloc_args	*args,
-	struct xfs_buf			**ialloc_context,
-	struct xfs_inode		**ipp)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_inode		*pip = args->pip;
-	struct xfs_inode		*ip;
-	xfs_ino_t			ino;
-	int				error;
-
-	/*
-	 * Call the space management code to pick
-	 * the on-disk inode to be allocated.
-	 */
-	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, args->mode,
-			    ialloc_context, &ino);
-	if (error)
-		return error;
-	if (*ialloc_context || ino == NULLFSINO) {
-		*ipp = NULL;
-		return 0;
-	}
-	ASSERT(*ialloc_context == NULL);
-
-	/*
-	 * Protect against obviously corrupt allocation btree records. Later
-	 * xfs_iget checks will catch re-allocation of other active in-memory
-	 * and on-disk inodes. If we don't catch reallocating the parent inode
-	 * here we will deadlock in xfs_iget() so we have to do these checks
-	 * first.
-	 */
-	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
-		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
-		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
-				XFS_SICK_AG_INOBT);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * Get the in-core inode with the lock held exclusively.
-	 * This is because we're setting fields here we need
-	 * to prevent others from looking at until we're done.
-	 */
-	error = xfs_ialloc_iget(tp, ino, &ip);
-	if (error)
-		return error;
-	ASSERT(ip != NULL);
-
-	xfs_inode_init(tp, args, ip);
-	*ipp = ip;
-	return 0;
-}
-
 /*
  * Allocates a new inode from disk and return a pointer to the
  * incore copy. This routine will internally commit the current
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 6cc1cddd6bfa..336f2642336a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -466,7 +466,6 @@ int	xfs_break_layouts(struct inode *inode, uint *iolock,
 		enum layout_break_reason reason);
 
 /* from xfs_iops.c */
-extern void xfs_setup_inode(struct xfs_inode *ip);
 extern void xfs_setup_iops(struct xfs_inode *ip);
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 982d53eb2853..7908f925074b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -224,7 +224,6 @@ void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
 bool		xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
-void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void		xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *, uint,
 				  uint);


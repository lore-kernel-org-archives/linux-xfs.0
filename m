Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49250 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752785AbdIBWmC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Sep 2017 18:42:02 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.21/8.16.0.21) with SMTP id v82McQo5027287
        for <linux-xfs@vger.kernel.org>; Sat, 2 Sep 2017 15:42:01 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2cqrafs9yr-4
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sat, 02 Sep 2017 15:42:01 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v2 1/3] fs/xfs: Add rtdisable option
Date: Sat, 2 Sep 2017 15:41:43 -0700
Message-ID: <20170902224145.1291030-2-rwareing@fb.com>
In-Reply-To: <20170902224145.1291030-1-rwareing@fb.com>
References: <20170902224145.1291030-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Richard Wareing <rwareing@fb.com>, david@fromorbit.com, darrick.wong@oracle.com

- Adds rtdisable mount option to ignore any real-time inheritance flag
  set on directories.  Designed to be used as a "kill-switch" for
  this behavior, negating the need to walk/kill flags on FS.

Signed-off-by: Richard Wareing <rwareing@fb.com>
---
 fs/xfs/xfs_inode.c |  6 ++++--
 fs/xfs/xfs_ioctl.c |  7 +++++--
 fs/xfs/xfs_mount.h |  1 +
 fs/xfs/xfs_super.c | 14 +++++++++++++-
 4 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ec9826c..dc53731 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -878,7 +878,8 @@ xfs_ialloc(
 			uint		di_flags = 0;
 
 			if (S_ISDIR(mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+				if (!(mp->m_flags & XFS_MOUNT_RTDISABLE) &&
+					pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
 					di_flags |= XFS_DIFLAG_RTINHERIT;
 				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
 					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
@@ -887,7 +888,8 @@ xfs_ialloc(
 				if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 					di_flags |= XFS_DIFLAG_PROJINHERIT;
 			} else if (S_ISREG(mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+				if (!(mp->m_flags & XFS_MOUNT_RTDISABLE) &&
+					pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
 					di_flags |= XFS_DIFLAG_REALTIME;
 				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
 					di_flags |= XFS_DIFLAG_EXTSIZE;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6190697..5a6d45d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -937,6 +937,7 @@ xfs_set_diflags(
 	struct xfs_inode	*ip,
 	unsigned int		xflags)
 {
+	struct xfs_mount        *mp = ip->i_mount;
 	unsigned int		di_flags;
 	uint64_t		di_flags2;
 
@@ -957,7 +958,8 @@ xfs_set_diflags(
 	if (xflags & FS_XFLAG_FILESTREAM)
 		di_flags |= XFS_DIFLAG_FILESTREAM;
 	if (S_ISDIR(VFS_I(ip)->i_mode)) {
-		if (xflags & FS_XFLAG_RTINHERIT)
+		if (!(mp->m_flags & XFS_MOUNT_RTDISABLE) &&
+			xflags & FS_XFLAG_RTINHERIT)
 			di_flags |= XFS_DIFLAG_RTINHERIT;
 		if (xflags & FS_XFLAG_NOSYMLINKS)
 			di_flags |= XFS_DIFLAG_NOSYMLINKS;
@@ -966,7 +968,8 @@ xfs_set_diflags(
 		if (xflags & FS_XFLAG_PROJINHERIT)
 			di_flags |= XFS_DIFLAG_PROJINHERIT;
 	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
-		if (xflags & FS_XFLAG_REALTIME)
+		if (!(mp->m_flags & XFS_MOUNT_RTDISABLE) &&
+			xflags & FS_XFLAG_REALTIME)
 			di_flags |= XFS_DIFLAG_REALTIME;
 		if (xflags & FS_XFLAG_EXTSIZE)
 			di_flags |= XFS_DIFLAG_EXTSIZE;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 9fa312a..8016ddb 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -243,6 +243,7 @@ typedef struct xfs_mount {
 						   allocator */
 #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
 
+#define XFS_MOUNT_RTDISABLE    (1ULL << 61)    /* Ignore RT flags */
 #define XFS_MOUNT_DAX		(1ULL << 62)	/* TEST ONLY! */
 
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 455a575..4dbf95c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -83,7 +83,7 @@ enum {
 	Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota, Opt_prjquota,
 	Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
+	Opt_discard, Opt_nodiscard, Opt_dax, Opt_rtdisable, Opt_err,
 };
 
 static const match_table_t tokens = {
@@ -133,6 +133,9 @@ static const match_table_t tokens = {
 
 	{Opt_dax,	"dax"},		/* Enable direct access to bdev pages */
 
+#ifdef CONFIG_XFS_RT
+	{Opt_rtdisable, "rtdisable"},   /* Ignore real-time flags */
+#endif
 	/* Deprecated mount options scheduled for removal */
 	{Opt_barrier,	"barrier"},	/* use writer barriers for log write and
 					 * unwritten extent conversion */
@@ -367,6 +370,11 @@ xfs_parseargs(
 		case Opt_nodiscard:
 			mp->m_flags &= ~XFS_MOUNT_DISCARD;
 			break;
+#ifdef CONFIG_XFS_RT
+		case Opt_rtdisable:
+			mp->m_flags |= XFS_MOUNT_RTDISABLE;
+			break;
+#endif
 #ifdef CONFIG_FS_DAX
 		case Opt_dax:
 			mp->m_flags |= XFS_MOUNT_DAX;
@@ -492,6 +500,10 @@ xfs_showargs(
 		{ XFS_MOUNT_DISCARD,		",discard" },
 		{ XFS_MOUNT_SMALL_INUMS,	",inode32" },
 		{ XFS_MOUNT_DAX,		",dax" },
+#ifdef CONFIG_XFS_RT
+		{ XFS_MOUNT_RTDISABLE,          ",rtdisable" },
+#endif
+
 		{ 0, NULL }
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {
-- 
2.9.3


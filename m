Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16837 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760363AbdKQSYP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 13:24:15 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 16/17] Add the parent pointer support to the superblock version 5.
Date: Fri, 17 Nov 2017 11:21:44 -0700
Message-Id: <1510942905-12897-17-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>, Mark Tinguely <tinguely@sgi.com>, Dave Chinner <dchinner@redhat.com>

[dchinner: forward ported and cleaned up]
[achender: rebased and added parent pointer attribute to
           compatible attributes mask]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
v2: remove unrelated type clean up in xfs_format.h

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 7 +++++--
 fs/xfs/libxfs/xfs_fs.h     | 1 +
 fs/xfs/xfs_fsops.c         | 4 +++-
 fs/xfs/xfs_super.c         | 4 ++++
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 121862a..f3e3132 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -459,10 +459,12 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
+#define XFS_SB_FEAT_RO_COMPAT_PARENT	(1 << 3)	/* parent inode ptr */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
-		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
+		 XFS_SB_FEAT_RO_COMPAT_PARENT)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
@@ -558,7 +560,8 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 
 static inline bool xfs_sb_version_hasparent(struct xfs_sb *sbp)
 {
-	return false; /* We'll enable this at the end of the set */
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_PARENT));
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 8c61f21..b8108f8 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -222,6 +222,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
 #define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* reverse mapping btree */
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	0x100000 /* files can share blocks */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	0x200000 /* parent pointers */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 8f22fc5..9a0ce52 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -111,7 +111,9 @@ xfs_fs_geometry(
 			(xfs_sb_version_hasrmapbt(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_RMAPBT : 0) |
 			(xfs_sb_version_hasreflink(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_REFLINK : 0);
+				XFS_FSOP_GEOM_FLAGS_REFLINK : 0) |
+			(xfs_sb_version_hasparent(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_PARENT : 0);
 		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ee68459..066266f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1675,6 +1675,10 @@ xfs_fs_fill_super(
 	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
 	}
 
+	if (xfs_sb_version_hasparent(&mp->m_sb))
+		xfs_alert(mp,
+	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
+
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
 		xfs_alert(mp,
 	"EXPERIMENTAL reflink feature enabled. Use at your own risk!");
-- 
2.7.4


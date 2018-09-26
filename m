Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48540 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727187AbeIZQ3o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:29:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QADwcm079561
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:28 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2mndpphg6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:28 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAHSuC026485
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:28 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAHRw9014214
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:27 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v9 24/28] xfs: Add the parent pointer support to the superblock version 5.
Date: Wed, 26 Sep 2018 03:15:03 -0700
Message-Id: <1537956907-10244-25-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
References: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

[dchinner: forward ported and cleaned up]
[achender: rebased and added parent pointer attribute to
           compatible attributes mask]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 7 +++++--
 fs/xfs/libxfs/xfs_fs.h     | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 2 ++
 fs/xfs/xfs_super.c         | 4 ++++
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 386d734..d77683e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -453,10 +453,12 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
+#define XFS_SB_FEAT_RO_COMPAT_PARENT	(1 << 3)		/* parent inode ptr */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
-		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
+		 XFS_SB_FEAT_RO_COMPAT_PARENT)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
@@ -552,7 +554,8 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 
 static inline bool xfs_sb_version_hasparent(struct xfs_sb *sbp)
 {
-	return false; /* We'll enable this at the end of the set */
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_PARENT));
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index f3aa593..9c58a78 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -210,6 +210,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
 #define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* reverse mapping btree */
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	0x100000 /* files can share blocks */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	0x200000 /* parent pointers */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 081f46e..05dd226 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1148,6 +1148,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_RMAPBT;
 	if (xfs_sb_version_hasreflink(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
+	if(xfs_sb_version_hasparent(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_sb_version_hassector(sbp))
 		geo->logsectsize = sbp->sb_logsectsize;
 	else
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 41f53d7..0d6432b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1710,6 +1710,10 @@ xfs_fs_fill_super(
 		goto out_filestream_unmount;
 	}
 
+	if (xfs_sb_version_hasparent(&mp->m_sb))
+		xfs_alert(mp,
+	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
-- 
2.7.4

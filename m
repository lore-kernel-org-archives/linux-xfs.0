Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49300 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753713AbeFJFKQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:10:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A56RCQ141617
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:15 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2jgecx94pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:15 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5AFFB004632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:15 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5A5AFjV001515
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:15 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v2 16/27] xfsprogs: Add the parent pointer support to the superblock version 5.
Date: Sat,  9 Jun 2018 22:07:41 -0700
Message-Id: <1528607272-11122-17-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
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
---
 libxfs/xfs_format.h | 7 +++++--
 libxfs/xfs_fs.h     | 1 +
 libxfs/xfs_sb.c     | 2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index de8b14a..05431b0 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -462,10 +462,12 @@ xfs_sb_has_compat_feature(
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
@@ -561,7 +563,8 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 
 static inline bool xfs_sb_version_hasparent(struct xfs_sb *sbp)
 {
-	return false; /* We'll enable this at the end of the set */
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_PARENT));
 }
 
 /*
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 86a379f..0c6f9fa 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -243,6 +243,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
 #define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* reverse mapping btree */
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	0x100000 /* files can share blocks */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	0x200000 /* parent pointers */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index e8dd463..1c5b6e7 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -940,6 +940,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_RMAPBT;
 	if (xfs_sb_version_hasreflink(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
+	if(xfs_sb_version_hasparent(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_sb_version_hassector(sbp))
 		geo->logsectsize = sbp->sb_logsectsize;
 	else
-- 
2.7.4


Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BBAEF7F99
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 22:56:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB8AF8F8035
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 20:56:10 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	PaAOLRV5NLA4BJHb for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 20:56:09 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WhWU5-0002Uw-Hp
	for xfs@oss.sgi.com; Tue, 06 May 2014 13:56:01 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WhWU5-0005Iq-H4
	for xfs@oss.sgi.com; Tue, 06 May 2014 13:56:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] xfs: don't need dirv2 checks anymore
Date: Tue,  6 May 2014 13:55:58 +1000
Message-Id: <1399348559-19889-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1399348559-19889-1-git-send-email-david@fromorbit.com>
References: <1399348559-19889-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

If the the V2 directory feature bit is not set in the superblock
feature mask the filesystem will fail the good version check.
Hence we don't need any other version checking on the dir2 feature
bit in the code as the filesystem will not mount without it set.
Remove the checking code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2.c  | 2 +-
 fs/xfs/xfs_fsops.c | 3 +--
 fs/xfs/xfs_sb.c    | 9 ---------
 fs/xfs/xfs_sb.h    | 6 ------
 4 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index e365c98..93fcebd 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -92,7 +92,7 @@ xfs_dir_mount(
 	int	nodehdr_size;
 
 
-	ASSERT(xfs_sb_version_hasdirv2(&mp->m_sb));
+	ASSERT(mp->m_sb.sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
 	ASSERT((1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog)) <=
 	       XFS_MAX_BLOCKSIZE);
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 2a03f2d..b099799 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -75,6 +75,7 @@ xfs_fs_geometry(
 	if (new_version >= 3) {
 		geo->version = XFS_FSOP_GEOM_VERSION;
 		geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
+			     XFS_FSOP_GEOM_FLAGS_DIRV2 |
 			(xfs_sb_version_hasattr(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_ATTR : 0) |
 			(xfs_sb_version_hasquota(&mp->m_sb) ?
@@ -87,8 +88,6 @@ xfs_fs_geometry(
 				XFS_FSOP_GEOM_FLAGS_SHARED : 0) |
 			(xfs_sb_version_hasextflgbit(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_EXTFLG : 0) |
-			(xfs_sb_version_hasdirv2(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_DIRV2 : 0) |
 			(xfs_sb_version_hassector(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_SECTOR : 0) |
 			(xfs_sb_version_hasasciici(&mp->m_sb) ?
diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index 8baf61a..de16dd5 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -333,15 +333,6 @@ xfs_mount_validate_sb(
 		xfs_warn(mp, "Offline file system operation in progress!");
 		return XFS_ERROR(EFSCORRUPTED);
 	}
-
-	/*
-	 * Version 1 directory format has never worked on Linux.
-	 */
-	if (unlikely(!xfs_sb_version_hasdirv2(sbp))) {
-		xfs_warn(mp, "file system using version 1 directory format");
-		return XFS_ERROR(ENOSYS);
-	}
-
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index b238a0e..9aa5caa 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -403,12 +403,6 @@ static inline bool xfs_sb_version_hasshared(struct xfs_sb *sbp)
 		(sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT);
 }
 
-static inline bool xfs_sb_version_hasdirv2(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
-	       (sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
-}
-
 static inline bool xfs_sb_version_haslogv2(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

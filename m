Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3271D7FA1
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 16:01:25 -0500 (CDT)
Received: from eagdhcp-232-155.americas.sgi.com
	(eagdhcp-232-155.americas.sgi.com [128.162.232.155])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5380AC002
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 14:01:21 -0700 (PDT)
Received: from eagdhcp-232-155.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-155.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r92L1KNZ004369
	for <xfs@oss.sgi.com>; Wed, 2 Oct 2013 16:01:20 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-155.americas.sgi.com)
Message-Id: <20131002210035.940755811@sgi.com>
Date: Wed, 02 Oct 2013 16:00:06 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs: add the inode directory type support to XFS_IOC_FSGEOM
Content-Disposition: inline;
	filename=v2-xfs-add-the-inode-directory-type-support-to-XFS_IOC_FSGEOM.patch
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

Add the inode type directory type support to XFS_IOC_FSGEOM
so that xfs_repair/xfs_info knows if the superblock v4 filesystem
enabled the feature.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 v2 remove the extra 0 in the XFS_FSOP_GEOM_FLAGS_xxx entries.

fs/xfs/xfs_fs.h    |   32 ++++++++++++++++----------------
 fs/xfs/xfs_fs.h    |    4 ++--
 fs/xfs/xfs_fsops.c |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

Index: b/fs/xfs/xfs_fs.h
===================================================================
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -233,11 +233,11 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
 #define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
 #define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
-#define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800  /* 32-bit project IDs	*/
+#define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800	/* 32-bit project IDs	*/
 #define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names	*/
 #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
 #define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
-
+#define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
 
 /*
  * Minimum and maximum sizes need for growth checks.
Index: b/fs/xfs/xfs_fsops.c
===================================================================
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -101,7 +101,9 @@ xfs_fs_geometry(
 			(xfs_sb_version_hasprojid32bit(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_PROJID32 : 0) |
 			(xfs_sb_version_hascrc(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_V5SB : 0);
+				XFS_FSOP_GEOM_FLAGS_V5SB : 0) |
+			(xfs_sb_version_hasftype(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_FTYPE : 0);
 		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2DEA07F52
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 09:48:36 -0500 (CDT)
Received: from eagdhcp-232-140.americas.sgi.com
	(eagdhcp-232-140.americas.sgi.com [128.162.232.140])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0ED6D8F8065
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 07:48:35 -0700 (PDT)
Received: from eagdhcp-232-140.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-140.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r8HEmZmM002782
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 09:48:35 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-140.americas.sgi.com)
Message-Id: <20130917144733.819109222@sgi.com>
Date: Tue, 17 Sep 2013 09:47:22 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs: add the inode directory type support to XFS_IOC_FSGEOM
References: <20130917144721.917667018@sgi.com>
Content-Disposition: inline; filename=xfs-add-ftype-geo.patch
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

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_fs.h    |   32 ++++++++++++++++----------------
 fs/xfs/xfs_fsops.c |    4 +++-
 2 files changed, 19 insertions(+), 17 deletions(-)

Index: b/fs/xfs/xfs_fs.h
===================================================================
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -222,22 +222,22 @@ typedef struct xfs_fsop_resblks {
 
 #define XFS_FSOP_GEOM_VERSION	0
 
-#define XFS_FSOP_GEOM_FLAGS_ATTR	0x0001	/* attributes in use	*/
-#define XFS_FSOP_GEOM_FLAGS_NLINK	0x0002	/* 32-bit nlink values	*/
-#define XFS_FSOP_GEOM_FLAGS_QUOTA	0x0004	/* quotas enabled	*/
-#define XFS_FSOP_GEOM_FLAGS_IALIGN	0x0008	/* inode alignment	*/
-#define XFS_FSOP_GEOM_FLAGS_DALIGN	0x0010	/* large data alignment */
-#define XFS_FSOP_GEOM_FLAGS_SHARED	0x0020	/* read-only shared	*/
-#define XFS_FSOP_GEOM_FLAGS_EXTFLG	0x0040	/* special extent flag	*/
-#define XFS_FSOP_GEOM_FLAGS_DIRV2	0x0080	/* directory version 2	*/
-#define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
-#define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
-#define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
-#define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800  /* 32-bit project IDs	*/
-#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names	*/
-#define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
-#define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
-
+#define XFS_FSOP_GEOM_FLAGS_ATTR	0x00001	/* attributes in use	*/
+#define XFS_FSOP_GEOM_FLAGS_NLINK	0x00002	/* 32-bit nlink values	*/
+#define XFS_FSOP_GEOM_FLAGS_QUOTA	0x00004	/* quotas enabled	*/
+#define XFS_FSOP_GEOM_FLAGS_IALIGN	0x00008	/* inode alignment	*/
+#define XFS_FSOP_GEOM_FLAGS_DALIGN	0x00010	/* large data alignment */
+#define XFS_FSOP_GEOM_FLAGS_SHARED	0x00020	/* read-only shared	*/
+#define XFS_FSOP_GEOM_FLAGS_EXTFLG	0x00040	/* special extent flag	*/
+#define XFS_FSOP_GEOM_FLAGS_DIRV2	0x00080	/* directory version 2	*/
+#define XFS_FSOP_GEOM_FLAGS_LOGV2	0x00100	/* log format version 2	*/
+#define XFS_FSOP_GEOM_FLAGS_SECTOR	0x00200	/* sector sizes >1BB	*/
+#define XFS_FSOP_GEOM_FLAGS_ATTR2	0x00400	/* inline attributes rework */
+#define XFS_FSOP_GEOM_FLAGS_PROJID32	0x00800 /* 32-bit project IDs	*/
+#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x01000	/* ASCII only CI names	*/
+#define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x04000	/* lazy superblock counters */
+#define XFS_FSOP_GEOM_FLAGS_V5SB	0x08000	/* version 5 superblock */
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

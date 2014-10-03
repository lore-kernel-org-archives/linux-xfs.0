Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A5BF7F37
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 17:05:09 -0500 (CDT)
Date: Fri, 3 Oct 2014 17:05:09 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 15/16] xfs: xfs_fs_geometry returns a number of bytes to copy
Message-ID: <20141003220508.GO1865@sgi.com>
References: <20141003214758.GY1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003214758.GY1865@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: olaf@sgi.com, xfs@oss.sgi.com

From: Ben Myers <bpm@sgi.com>

The versioned xfs_fsop_geom_t will be of variable size.  Make
xfs_fs_geometry return the number of bytes to copy out to userspace for
a given version of the structure.

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_fsops.c   | 6 ++----
 fs/xfs/xfs_fsops.h   | 2 +-
 fs/xfs/xfs_ioctl.c   | 6 ++++--
 fs/xfs/xfs_ioctl32.c | 3 ++-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b69468e..cf87e16 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -51,11 +51,9 @@ int
 xfs_fs_geometry(
 	xfs_mount_t		*mp,
 	xfs_fsop_geom_v2_t	*geo,
-	int			new_version)
+	int			new_version,
+	size_t			*bytes)
 {
-
-	memset(geo, 0, sizeof(*geo));
-
 	geo->blocksize = mp->m_sb.sb_blocksize;
 	geo->rtextsize = mp->m_sb.sb_rextsize;
 	geo->agblocks = mp->m_sb.sb_agblocks;
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 26e7343..74e1fee 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -19,7 +19,7 @@
 #define	__XFS_FSOPS_H__
 
 extern int xfs_fs_geometry(xfs_mount_t *mp, xfs_fsop_geom_v2_t *geo,
-		int nversion);
+		int new_version, size_t *bytes);
 extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
 extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
 extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4393405..1657ce5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -826,7 +826,8 @@ xfs_ioc_fsgeometry_v1(
 	xfs_fsop_geom_v2_t	fsgeo;
 	int			error;
 
-	error = xfs_fs_geometry(mp, &fsgeo, 3);
+	memset(&fsgeo, 0, sizeof(fsgeo));
+	error = xfs_fs_geometry(mp, &fsgeo, 3, NULL);
 	if (error)
 		return error;
 
@@ -848,7 +849,8 @@ xfs_ioc_fsgeometry_v2(
 	xfs_fsop_geom_v2_t	fsgeo;
 	int			error;
 
-	error = xfs_fs_geometry(mp, &fsgeo, 4);
+	memset(&fsgeo, 0, sizeof(fsgeo));
+	error = xfs_fs_geometry(mp, &fsgeo, 4, NULL);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 207b224..aca988a 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -67,7 +67,8 @@ xfs_compat_ioc_fsgeometry_v1(
 	xfs_fsop_geom_v2_t	  fsgeo;
 	int			  error;
 
-	error = xfs_fs_geometry(mp, &fsgeo, 3);
+	memset(&fsgeo, 0, sizeof(fsgeo));
+	error = xfs_fs_geometry(mp, &fsgeo, 3, NULL);
 	if (error)
 		return error;
 	/* The 32-bit variant simply has some padding at the end */
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

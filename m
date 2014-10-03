Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F41837F37
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 17:04:38 -0500 (CDT)
Date: Fri, 3 Oct 2014 17:04:35 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 14/16] xfs: rename XFS_IOC_FSGEOM to XFS_IOC_FSGEOM_V2
Message-ID: <20141003220435.GN1865@sgi.com>
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

We'll be creating a new versioned XFS_IOC_FSGEOMETRY ioctl and structure
so rename the current revision to _V2.

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_fs.h      |  8 ++++----
 fs/xfs/xfs_fsops.c   |  2 +-
 fs/xfs/xfs_fsops.h   |  3 ++-
 fs/xfs/xfs_ioctl.c   | 12 ++++++------
 fs/xfs/xfs_ioctl32.c |  4 ++--
 5 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index e845d75..fd45cbe 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -180,9 +180,9 @@ typedef struct xfs_fsop_geom_v1 {
 } xfs_fsop_geom_v1_t;
 
 /*
- * Output for XFS_IOC_FSGEOMETRY
+ * Output for XFS_IOC_FSGEOMETRY_V2
  */
-typedef struct xfs_fsop_geom {
+typedef struct xfs_fsop_geom_v2 {
 	__u32		blocksize;	/* filesystem (data) block size */
 	__u32		rtextsize;	/* realtime extent size		*/
 	__u32		agblocks;	/* fsblocks in an AG		*/
@@ -204,7 +204,7 @@ typedef struct xfs_fsop_geom {
 	__u32		rtsectsize;	/* realtime sector size, bytes	*/
 	__u32		dirblocksize;	/* directory block size, bytes	*/
 	__u32		logsunit;	/* log stripe unit, bytes */
-} xfs_fsop_geom_t;
+} xfs_fsop_geom_v2_t;
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
@@ -555,7 +555,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
-#define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
+#define XFS_IOC_FSGEOMETRY_V2	     _IOR ('X', 124, struct xfs_fsop_geom_v2)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 1a83eef..b69468e 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -50,7 +50,7 @@
 int
 xfs_fs_geometry(
 	xfs_mount_t		*mp,
-	xfs_fsop_geom_t		*geo,
+	xfs_fsop_geom_v2_t	*geo,
 	int			new_version)
 {
 
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 1b6a98b..26e7343 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -18,7 +18,8 @@
 #ifndef __XFS_FSOPS_H__
 #define	__XFS_FSOPS_H__
 
-extern int xfs_fs_geometry(xfs_mount_t *mp, xfs_fsop_geom_t *geo, int nversion);
+extern int xfs_fs_geometry(xfs_mount_t *mp, xfs_fsop_geom_v2_t *geo,
+		int nversion);
 extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
 extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
 extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3799695..4393405 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -823,7 +823,7 @@ xfs_ioc_fsgeometry_v1(
 	xfs_mount_t		*mp,
 	void			__user *arg)
 {
-	xfs_fsop_geom_t         fsgeo;
+	xfs_fsop_geom_v2_t	fsgeo;
 	int			error;
 
 	error = xfs_fs_geometry(mp, &fsgeo, 3);
@@ -841,18 +841,18 @@ xfs_ioc_fsgeometry_v1(
 }
 
 STATIC int
-xfs_ioc_fsgeometry(
+xfs_ioc_fsgeometry_v2(
 	xfs_mount_t		*mp,
 	void			__user *arg)
 {
-	xfs_fsop_geom_t		fsgeo;
+	xfs_fsop_geom_v2_t	fsgeo;
 	int			error;
 
 	error = xfs_fs_geometry(mp, &fsgeo, 4);
 	if (error)
 		return error;
 
-	if (copy_to_user(arg, &fsgeo, sizeof(fsgeo)))
+	if (copy_to_user(arg, &fsgeo, sizeof(xfs_fsop_geom_v2_t)))
 		return -EFAULT;
 	return 0;
 }
@@ -1564,8 +1564,8 @@ xfs_file_ioctl(
 	case XFS_IOC_FSGEOMETRY_V1:
 		return xfs_ioc_fsgeometry_v1(mp, arg);
 
-	case XFS_IOC_FSGEOMETRY:
-		return xfs_ioc_fsgeometry(mp, arg);
+	case XFS_IOC_FSGEOMETRY_V2:
+		return xfs_ioc_fsgeometry_v2(mp, arg);
 
 	case XFS_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *)arg);
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index a554646..207b224 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -64,7 +64,7 @@ xfs_compat_ioc_fsgeometry_v1(
 	struct xfs_mount	  *mp,
 	compat_xfs_fsop_geom_v1_t __user *arg32)
 {
-	xfs_fsop_geom_t		  fsgeo;
+	xfs_fsop_geom_v2_t	  fsgeo;
 	int			  error;
 
 	error = xfs_fs_geometry(mp, &fsgeo, 3);
@@ -543,7 +543,7 @@ xfs_file_compat_ioctl(
 	switch (cmd) {
 	/* No size or alignment issues on any arch */
 	case XFS_IOC_DIOINFO:
-	case XFS_IOC_FSGEOMETRY:
+	case XFS_IOC_FSGEOMETRY_V2:
 	case XFS_IOC_FSGETXATTR:
 	case XFS_IOC_FSSETXATTR:
 	case XFS_IOC_FSGETXATTRA:
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

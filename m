Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0C8D47F37
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 17:05:47 -0500 (CDT)
Date: Fri, 3 Oct 2014 17:05:46 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 16/16] xfs: add versioned fsgeom ioctl with utf8version field
Message-ID: <20141003220546.GP1865@sgi.com>
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

This adds a utf8version field to the xfs_fs_geom structure.  An
important characteristic of this version of the ioctl is that
fsgeo.version needs to be set by the caller to specify which version of
the structure to return.

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_fs.h    | 31 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsops.c | 13 ++++++++++++-
 fs/xfs/xfs_fsops.h |  2 +-
 fs/xfs/xfs_ioctl.c | 31 +++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index fd45cbe..2f4d430 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -206,6 +206,34 @@ typedef struct xfs_fsop_geom_v2 {
 	__u32		logsunit;	/* log stripe unit, bytes */
 } xfs_fsop_geom_v2_t;
 
+/*
+ * Output for XFS_IOC_FSGEOMETRY
+ */
+typedef struct xfs_fsop_geom {
+	__u32		blocksize;	/* filesystem (data) block size */
+	__u32		rtextsize;	/* realtime extent size		*/
+	__u32		agblocks;	/* fsblocks in an AG		*/
+	__u32		agcount;	/* number of allocation groups	*/
+	__u32		logblocks;	/* fsblocks in the log		*/
+	__u32		sectsize;	/* (data) sector size, bytes	*/
+	__u32		inodesize;	/* inode size in bytes		*/
+	__u32		imaxpct;	/* max allowed inode space(%)	*/
+	__u64		datablocks;	/* fsblocks in data subvolume	*/
+	__u64		rtblocks;	/* fsblocks in realtime subvol	*/
+	__u64		rtextents;	/* rt extents in realtime subvol*/
+	__u64		logstart;	/* starting fsblock of the log	*/
+	unsigned char	uuid[16];	/* unique id of the filesystem	*/
+	__u32		sunit;		/* stripe unit, fsblocks	*/
+	__u32		swidth;		/* stripe width, fsblocks	*/
+	__s32		version;	/* structure version		*/
+	__u32		flags;		/* superblock version flags	*/
+	__u32		logsectsize;	/* log sector size, bytes	*/
+	__u32		rtsectsize;	/* realtime sector size, bytes	*/
+	__u32		dirblocksize;	/* directory block size, bytes	*/
+	__u32		logsunit;	/* log stripe unit, bytes */
+	__u32		utf8version;	/* Unicode version		*/
+} xfs_fsop_geom_t;
+
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
 	__u64	freedata;	/* free data section blocks */
@@ -221,6 +249,8 @@ typedef struct xfs_fsop_resblks {
 } xfs_fsop_resblks_t;
 
 #define XFS_FSOP_GEOM_VERSION	0
+/* skipped 1-4 to match existing new_version xfs_fs_geometry argument */
+#define XFS_FSOP_GEOM_VERSION5	5
 
 #define XFS_FSOP_GEOM_FLAGS_ATTR	0x0001	/* attributes in use	*/
 #define XFS_FSOP_GEOM_FLAGS_NLINK	0x0002	/* 32-bit nlink values	*/
@@ -557,6 +587,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY_V2	     _IOR ('X', 124, struct xfs_fsop_geom_v2)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index cf87e16..d70acf8 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -50,10 +50,12 @@
 int
 xfs_fs_geometry(
 	xfs_mount_t		*mp,
-	xfs_fsop_geom_v2_t	*geo,
+	void			*buffer,
 	int			new_version,
 	size_t			*bytes)
 {
+	xfs_fsop_geom_t		*geo = (xfs_fsop_geom_t *)buffer;
+
 	geo->blocksize = mp->m_sb.sb_blocksize;
 	geo->rtextsize = mp->m_sb.sb_rextsize;
 	geo->agblocks = mp->m_sb.sb_agblocks;
@@ -115,6 +117,15 @@ xfs_fs_geometry(
 				XFS_FSOP_GEOM_FLAGS_LOGV2 : 0);
 		geo->logsunit = mp->m_sb.sb_logsunit;
 	}
+	if (new_version >= XFS_FSOP_GEOM_VERSION5) {
+		geo->version = XFS_FSOP_GEOM_VERSION5;
+		geo->flags |= (xfs_sb_version_hasutf8(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_UTF8 : 0);
+		geo->utf8version = mp->m_sb.sb_utf8version;
+		if (bytes)
+			*bytes = sizeof(xfs_fsop_geom_v2_t) +
+				 sizeof(geo->utf8version);
+	}
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 74e1fee..b723f36 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -18,7 +18,7 @@
 #ifndef __XFS_FSOPS_H__
 #define	__XFS_FSOPS_H__
 
-extern int xfs_fs_geometry(xfs_mount_t *mp, xfs_fsop_geom_v2_t *geo,
+extern int xfs_fs_geometry(xfs_mount_t *mp, void *buffer,
 		int new_version, size_t *bytes);
 extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
 extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1657ce5..6308680 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -859,6 +859,34 @@ xfs_ioc_fsgeometry_v2(
 	return 0;
 }
 
+STATIC int
+xfs_ioc_fsgeometry(
+	struct xfs_mount	*mp,
+	void			__user *arg)
+{
+	xfs_fsop_geom_t		fsgeo;
+	int			version, error;
+	size_t			bytes;
+
+	/* offsetof(version)? XXX just get 32 bits? */
+	if (copy_from_user(&fsgeo, arg, sizeof(xfs_fsop_geom_v1_t)))
+		return -EFAULT;
+
+	version = fsgeo.version;
+
+	if (version < XFS_FSOP_GEOM_VERSION5)
+		return -EINVAL;
+
+	memset(&fsgeo, 0, sizeof(fsgeo));
+	error = xfs_fs_geometry(mp, &fsgeo, version, &bytes);
+	if (error)
+		return error;
+
+	if (copy_to_user(arg, &fsgeo, bytes))
+		return -EFAULT;
+	return 0;
+}
+
 /*
  * Linux extended inode flags interface.
  */
@@ -1569,6 +1597,9 @@ xfs_file_ioctl(
 	case XFS_IOC_FSGEOMETRY_V2:
 		return xfs_ioc_fsgeometry_v2(mp, arg);
 
+	case XFS_IOC_FSGEOMETRY:
+		return xfs_ioc_fsgeometry(mp, arg);
+
 	case XFS_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *)arg);
 
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

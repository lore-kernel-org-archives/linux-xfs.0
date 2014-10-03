Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A57917F53
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 17:14:44 -0500 (CDT)
Date: Fri, 3 Oct 2014 17:14:43 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 30/35] libxfs: add versioned fsgeom ioctl with utf8version
	field
Message-ID: <20141003221443.GD1865@sgi.com>
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
 include/xfs_fs.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/include/xfs_fs.h b/include/xfs_fs.h
index 38faf5d..f920498 100644
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
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
@@ -555,6 +585,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY_V2	     _IOR ('X', 124, struct xfs_fsop_geom_v2)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60190 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730016AbfDARKn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 13:10:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x31H9GxF131404
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:42 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2rhyvt0cu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 01 Apr 2019 17:10:41 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x31HAZXc012092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:36 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x31HAZfW017582
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:35 GMT
Subject: [PATCH 04/10] xfs: expand xfs_fsop_geom
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Apr 2019 10:10:34 -0700
Message-ID: <155413863414.4966.13609556795695536711.stgit@magnolia>
In-Reply-To: <155413860964.4966.6087725033542837255.stgit@magnolia>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rename the current (v2-v4) geometry ioctl XFS_IOC_FSGEOMETRY_V2 and
expand the existing xfs_fsop_geom to reserve empty space for more
fields.  This means that newly built binaries will pick up the new
format and existing programs will simply end up in the V2 handler.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   32 +++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_sb.c |    5 +++++
 fs/xfs/xfs_ioctl.c     |   22 ++++++++++++++++++++--
 fs/xfs/xfs_ioctl32.c   |    1 +
 4 files changed, 57 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index f3aa59302fef..1dba751cde60 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -148,7 +148,34 @@ typedef struct xfs_fsop_geom_v1 {
 } xfs_fsop_geom_v1_t;
 
 /*
- * Output for XFS_IOC_FSGEOMETRY
+ * Output for XFS_IOC_FSGEOMETRY_V2
+ */
+typedef struct xfs_fsop_geom_v2 {
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
+} xfs_fsop_geom_v2_t;
+
+/*
+ * Output for XFS_IOC_FSGEOMETRY (v5)
  */
 typedef struct xfs_fsop_geom {
 	__u32		blocksize;	/* filesystem (data) block size */
@@ -172,6 +199,7 @@ typedef struct xfs_fsop_geom {
 	__u32		rtsectsize;	/* realtime sector size, bytes	*/
 	__u32		dirblocksize;	/* directory block size, bytes	*/
 	__u32		logsunit;	/* log stripe unit, bytes */
+	__u64		reserved[18];	/* reserved space */
 } xfs_fsop_geom_t;
 
 /* Output for XFS_FS_COUNTS */
@@ -189,6 +217,7 @@ typedef struct xfs_fsop_resblks {
 } xfs_fsop_resblks_t;
 
 #define XFS_FSOP_GEOM_VERSION	0
+#define XFS_FSOP_GEOM_V5	5
 
 #define XFS_FSOP_GEOM_FLAGS_ATTR	0x0001	/* attributes in use	*/
 #define XFS_FSOP_GEOM_FLAGS_NLINK	0x0002	/* 32-bit nlink values	*/
@@ -620,6 +649,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
+#define XFS_IOC_FSGEOMETRY_V2	     _IOR ('X', 124, struct xfs_fsop_geom_v2)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f0309b74e377..c2ca3a816c41 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1168,6 +1168,11 @@ xfs_fs_geometry(
 
 	geo->logsunit = sbp->sb_logsunit;
 
+	if (struct_version < 5)
+		return 0;
+
+	geo->version = XFS_FSOP_GEOM_V5;
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6ecdbb3af7de..7fd8815633dc 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -801,7 +801,7 @@ xfs_ioc_fsgeometry_v1(
 }
 
 STATIC int
-xfs_ioc_fsgeometry(
+xfs_ioc_fsgeometry_v2(
 	xfs_mount_t		*mp,
 	void			__user *arg)
 {
@@ -812,6 +812,23 @@ xfs_ioc_fsgeometry(
 	if (error)
 		return error;
 
+	if (copy_to_user(arg, &fsgeo, sizeof(struct xfs_fsop_geom_v2)))
+		return -EFAULT;
+	return 0;
+}
+
+STATIC int
+xfs_ioc_fsgeometry(
+	struct xfs_mount	*mp,
+	void			__user *arg)
+{
+	struct xfs_fsop_geom	fsgeo;
+	int			error;
+
+	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 5);
+	if (error)
+		return error;
+
 	if (copy_to_user(arg, &fsgeo, sizeof(fsgeo)))
 		return -EFAULT;
 	return 0;
@@ -1938,7 +1955,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_FSGEOMETRY_V1:
 		return xfs_ioc_fsgeometry_v1(mp, arg);
-
+	case XFS_IOC_FSGEOMETRY_V2:
+		return xfs_ioc_fsgeometry_v2(mp, arg);
 	case XFS_IOC_FSGEOMETRY:
 		return xfs_ioc_fsgeometry(mp, arg);
 
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 5001dca361e9..323cfd4b15dc 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -561,6 +561,7 @@ xfs_file_compat_ioctl(
 	switch (cmd) {
 	/* No size or alignment issues on any arch */
 	case XFS_IOC_DIOINFO:
+	case XFS_IOC_FSGEOMETRY_V2:
 	case XFS_IOC_FSGEOMETRY:
 	case XFS_IOC_FSGETXATTR:
 	case XFS_IOC_FSSETXATTR:

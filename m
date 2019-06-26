Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50796 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZUpn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:45:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKi4o9018479
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:45:42 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t9cyqmh1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:45:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKil2o011931
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:45:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2t9p6uyyeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:45:41 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5QKje0E003609
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:45:40 GMT
Subject: [PATCH 1/9] xfs: remove various bulk request typedef usage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 26 Jun 2019 13:45:39 -0700
Message-ID: <156158193938.495715.10350265724462670403.stgit@magnolia>
In-Reply-To: <156158193320.495715.6675123051075804739.stgit@magnolia>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, allison.henderson@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove xfs_bstat_t, xfs_fsop_bulkreq_t, xfs_inogrp_t, and similarly
named compat typedefs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   16 ++++++++--------
 fs/xfs/xfs_ioctl.c     |    2 +-
 fs/xfs/xfs_ioctl32.c   |   11 +++++++----
 fs/xfs/xfs_ioctl32.h   |   14 +++++++-------
 4 files changed, 23 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index e7382c780ed7..ef0dce229fa4 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -97,7 +97,7 @@ struct getbmapx {
  * For use by backup and restore programs to set the XFS on-disk inode
  * fields di_dmevmask and di_dmstate.  These must be set to exactly and
  * only values previously obtained via xfs_bulkstat!  (Specifically the
- * xfs_bstat_t fields bs_dmevmask and bs_dmstate.)
+ * struct xfs_bstat fields bs_dmevmask and bs_dmstate.)
  */
 #ifndef HAVE_FSDMIDATA
 struct fsdmidata {
@@ -328,7 +328,7 @@ typedef struct xfs_bstime {
 	__s32		tv_nsec;	/* and nanoseconds	*/
 } xfs_bstime_t;
 
-typedef struct xfs_bstat {
+struct xfs_bstat {
 	__u64		bs_ino;		/* inode number			*/
 	__u16		bs_mode;	/* type and mode		*/
 	__u16		bs_nlink;	/* number of links		*/
@@ -356,7 +356,7 @@ typedef struct xfs_bstat {
 	__u32		bs_dmevmask;	/* DMIG event mask		*/
 	__u16		bs_dmstate;	/* DMIG state info		*/
 	__u16		bs_aextents;	/* attribute number of extents	*/
-} xfs_bstat_t;
+};
 
 /* bs_sick flags */
 #define XFS_BS_SICK_INODE	(1 << 0)  /* inode core */
@@ -382,22 +382,22 @@ bstat_get_projid(struct xfs_bstat *bs)
 /*
  * The user-level BulkStat Request interface structure.
  */
-typedef struct xfs_fsop_bulkreq {
+struct xfs_fsop_bulkreq {
 	__u64		__user *lastip;	/* last inode # pointer		*/
 	__s32		icount;		/* count of entries in buffer	*/
 	void		__user *ubuffer;/* user buffer for inode desc.	*/
 	__s32		__user *ocount;	/* output count pointer		*/
-} xfs_fsop_bulkreq_t;
+};
 
 
 /*
  * Structures returned from xfs_inumbers routine (XFS_IOC_FSINUMBERS).
  */
-typedef struct xfs_inogrp {
+struct xfs_inogrp {
 	__u64		xi_startino;	/* starting inode number	*/
 	__s32		xi_alloccount;	/* # bits set in allocmask	*/
 	__u64		xi_allocmask;	/* mask of allocated inodes	*/
-} xfs_inogrp_t;
+};
 
 
 /*
@@ -529,7 +529,7 @@ typedef struct xfs_swapext
 	xfs_off_t	sx_offset;	/* offset into file */
 	xfs_off_t	sx_length;	/* leng from offset */
 	char		sx_pad[16];	/* pad space, unused */
-	xfs_bstat_t	sx_stat;	/* stat of target b4 copy */
+	struct xfs_bstat sx_stat;	/* stat of target b4 copy */
 } xfs_swapext_t;
 
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 04b661ff0799..34b38d8e8dc9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -766,7 +766,7 @@ xfs_ioc_bulkstat(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if (copy_from_user(&bulkreq, arg, sizeof(xfs_fsop_bulkreq_t)))
+	if (copy_from_user(&bulkreq, arg, sizeof(struct xfs_fsop_bulkreq)))
 		return -EFAULT;
 
 	if (copy_from_user(&lastino, bulkreq.lastip, sizeof(__s64)))
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index f3949684c49c..d7c5153e1b61 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -118,11 +118,14 @@ xfs_ioctl32_bstime_copyin(
 	return 0;
 }
 
-/* xfs_bstat_t has differing alignment on intel, & bstime_t sizes everywhere */
+/*
+ * struct xfs_bstat has differing alignment on intel, & bstime_t sizes
+ * everywhere
+ */
 STATIC int
 xfs_ioctl32_bstat_copyin(
-	xfs_bstat_t		*bstat,
-	compat_xfs_bstat_t	__user *bstat32)
+	struct xfs_bstat		*bstat,
+	struct compat_xfs_bstat	__user	*bstat32)
 {
 	if (get_user(bstat->bs_ino,	&bstat32->bs_ino)	||
 	    get_user(bstat->bs_mode,	&bstat32->bs_mode)	||
@@ -206,7 +209,7 @@ STATIC int
 xfs_compat_ioc_bulkstat(
 	xfs_mount_t		  *mp,
 	unsigned int		  cmd,
-	compat_xfs_fsop_bulkreq_t __user *p32)
+	struct compat_xfs_fsop_bulkreq __user *p32)
 {
 	u32			addr;
 	struct xfs_fsop_bulkreq	bulkreq;
diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
index d28fa824284a..7985344d3aa6 100644
--- a/fs/xfs/xfs_ioctl32.h
+++ b/fs/xfs/xfs_ioctl32.h
@@ -36,7 +36,7 @@ typedef struct compat_xfs_bstime {
 	__s32		tv_nsec;	/* and nanoseconds	*/
 } compat_xfs_bstime_t;
 
-typedef struct compat_xfs_bstat {
+struct compat_xfs_bstat {
 	__u64		bs_ino;		/* inode number			*/
 	__u16		bs_mode;	/* type and mode		*/
 	__u16		bs_nlink;	/* number of links		*/
@@ -61,14 +61,14 @@ typedef struct compat_xfs_bstat {
 	__u32		bs_dmevmask;	/* DMIG event mask		*/
 	__u16		bs_dmstate;	/* DMIG state info		*/
 	__u16		bs_aextents;	/* attribute number of extents	*/
-} __compat_packed compat_xfs_bstat_t;
+} __compat_packed;
 
-typedef struct compat_xfs_fsop_bulkreq {
+struct compat_xfs_fsop_bulkreq {
 	compat_uptr_t	lastip;		/* last inode # pointer		*/
 	__s32		icount;		/* count of entries in buffer	*/
 	compat_uptr_t	ubuffer;	/* user buffer for inode desc.	*/
 	compat_uptr_t	ocount;		/* output count pointer		*/
-} compat_xfs_fsop_bulkreq_t;
+};
 
 #define XFS_IOC_FSBULKSTAT_32 \
 	_IOWR('X', 101, struct compat_xfs_fsop_bulkreq)
@@ -106,7 +106,7 @@ typedef struct compat_xfs_swapext {
 	xfs_off_t		sx_offset;	/* offset into file */
 	xfs_off_t		sx_length;	/* leng from offset */
 	char			sx_pad[16];	/* pad space, unused */
-	compat_xfs_bstat_t	sx_stat;	/* stat of target b4 copy */
+	struct compat_xfs_bstat	sx_stat;	/* stat of target b4 copy */
 } __compat_packed compat_xfs_swapext_t;
 
 #define XFS_IOC_SWAPEXT_32	_IOWR('X', 109, struct compat_xfs_swapext)
@@ -201,11 +201,11 @@ typedef struct compat_xfs_fsop_geom_v1 {
 #define XFS_IOC_FSGEOMETRY_V1_32  \
 	_IOR('X', 100, struct compat_xfs_fsop_geom_v1)
 
-typedef struct compat_xfs_inogrp {
+struct compat_xfs_inogrp {
 	__u64		xi_startino;	/* starting inode number	*/
 	__s32		xi_alloccount;	/* # bits set in allocmask	*/
 	__u64		xi_allocmask;	/* mask of allocated inodes	*/
-} __attribute__((packed)) compat_xfs_inogrp_t;
+} __attribute__((packed));
 
 /* These growfs input structures have padding on the end, so must translate */
 typedef struct compat_xfs_growfs_data {

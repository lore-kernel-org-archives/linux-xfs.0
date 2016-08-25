Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F1E0882F4
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:55:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84DE1AC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:55:30 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id S84b1x9495FjRE1v (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:55:28 -0700 (PDT)
Subject: [PATCH 01/24] xfs: introduce the XFS_IOC_GETFSMAP ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:55:25 -0700
Message-ID: <147216932511.6398.11162170353495454793.stgit@birch.djwong.org>
In-Reply-To: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
References: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Introduce a new ioctl that uses the reverse mapping btree to return
information about the physical layout of the filesystem.

v2: shorten the device field to u32 since that's all we need for
dev_t.  Support reporting reverse mapping information for all the
devices that XFS supports (data, log).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_fs.h |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index df58c1c..11149fa 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -117,6 +117,70 @@ struct getbmapx {
 #define BMV_OF_SHARED		0x8	/* segment shared with another file */
 
 /*
+ *	Structure for XFS_IOC_GETFSMAP.
+ *
+ *	Similar to XFS_IOC_GETBMAPX, the first two elements in the array are
+ *	used to constrain the output.  The first element in the array should
+ *	represent the lowest disk address that the user wants to learn about.
+ *	The second element in the array should represent the highest disk
+ *	address to query.  Subsequent array elements will be filled out by the
+ *	command.
+ *
+ *	The fmv_iflags field is only used in the first structure.  The
+ *	fmv_oflags field is filled in for each returned structure after the
+ *	second structure.  The fmv_unused1 fields in the first two array
+ *	elements must be zero.
+ *
+ *	The fmv_count, fmv_entries, and fmv_iflags fields in the second array
+ *	element must be zero.
+ *
+ *	fmv_block, fmv_offset, and fmv_length are expressed in units of 512
+ *	byte sectors.
+ */
+#ifndef HAVE_GETFSMAP
+struct getfsmap {
+	__u32		fmv_device;	/* device id */
+	__u32		fmv_unused1;	/* future use, must be zero */
+	__u64		fmv_block;	/* starting block */
+	__u64		fmv_owner;	/* owner id */
+	__u64		fmv_offset;	/* file offset of segment */
+	__u64		fmv_length;	/* length of segment, blocks */
+	__u32		fmv_oflags;	/* mapping flags */
+	__u32		fmv_iflags;	/* control flags (1st structure) */
+	__u32		fmv_count;	/* # of entries in array incl. input */
+	__u32		fmv_entries;	/* # of entries filled in (output). */
+	__u64		fmv_unused2;	/* future use, must be zero */
+};
+#endif
+
+/*	fmv_iflags values - set by XFS_IOC_GETFSMAP caller in the header. */
+/* no flags defined yet */
+#define FMV_HIF_VALID		0
+
+/*	fmv_oflags values - returned in the header segment only. */
+#define FMV_HOF_DEV_T		0x1	/* fmv_device values will be dev_t */
+
+/*	fmv_flags values - returned for each non-header segment */
+#define FMV_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
+#define FMV_OF_ATTR_FORK	0x2	/* segment = attribute fork */
+#define FMV_OF_EXTENT_MAP	0x4	/* segment = extent map */
+#define FMV_OF_SHARED		0x8	/* segment = shared with another file */
+#define FMV_OF_SPECIAL_OWNER	0x10	/* owner is a special value */
+#define FMV_OF_LAST		0x20	/* segment is the last in the FS */
+
+/*	fmv_owner special values */
+#define FMV_OWN_FREE		(-1ULL)	/* free space */
+#define FMV_OWN_UNKNOWN		(-2ULL)	/* unknown owner */
+#define FMV_OWN_FS		(-3ULL)	/* static fs metadata */
+#define FMV_OWN_LOG		(-4ULL)	/* journalling log */
+#define FMV_OWN_AG		(-5ULL)	/* per-AG metadata */
+#define FMV_OWN_INOBT		(-6ULL)	/* inode btree blocks */
+#define FMV_OWN_INODES		(-7ULL)	/* inodes */
+#define FMV_OWN_REFC		(-8ULL) /* refcount tree */
+#define FMV_OWN_COW		(-9ULL) /* cow staging */
+#define FMV_OWN_DEFECTIVE	(-10ULL) /* bad blocks */
+
+/*
  * Structure for XFS_IOC_FSSETDM.
  * For use by backup and restore programs to set the XFS on-disk inode
  * fields di_dmevmask and di_dmstate.  These must be set to exactly and
@@ -523,6 +587,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
+#define XFS_IOC_GETFSMAP	_IOWR('X', 59, struct getfsmap)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

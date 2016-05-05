Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E133C7CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 14:52:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 99C718F8037
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 12:52:08 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id EHUp6N4KdInBZ3OU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 12:52:06 -0700 (PDT)
Date: Thu, 5 May 2016 12:51:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/3] xfs: introduce the XFS_IOC_GETFSMAPX ioctl
Message-ID: <20160505195149.GB2905@birch.djwong.org>
References: <20160505194754.GA2785@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160505194754.GA2785@birch.djwong.org>
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
To: Mark Fasheh <mfasheh@suse.de>, Josef Bacik <jbacik@fb.com>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs <xfs@oss.sgi.com>

Introduce a new ioctl that uses the reverse mapping btree to return
information about the physical layout of the filesystem.  This is
the xfsprogs side of things for userspace support.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_fs.h       |   65 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+), 14 deletions(-)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index d5ed090..6573fcc 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -117,6 +117,70 @@ struct getbmapx {
 #define BMV_OF_SHARED		0x8	/* segment shared with another file */
 
 /*
+ *	Structure for XFS_IOC_GETFSMAPX.
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
+#ifndef HAVE_GETFSMAPX
+struct getfsmapx {
+	__s64		fmv_device;	/* device id */
+	__s64		fmv_block;	/* starting block */
+	__s64		fmv_owner;	/* owner id */
+	__s64		fmv_offset;	/* file offset of segment */
+	__s64		fmv_length;	/* length of segment, blocks */
+	__s32		fmv_oflags;	/* mapping flags */
+	__s32		fmv_iflags;	/* control flags (1st structure) */
+	__s32		fmv_count;	/* # of entries in array incl. input */
+	__s32		fmv_entries;	/* # of entries filled in (output). */
+	__s64		fmv_unused1;	/* future use, must be zero */
+};
+#endif
+
+/*	fmv_device values - set by XFS_IOC_GETFSMAPX caller.	*/
+/* use this value if the filesystem doesn't support multiple devices. */
+#define FMV_DEV_DEFAULT	0
+
+/*	fmv_flags values - set by XFS_IOC_GETFSMAPX caller.	*/
+/* no flags defined yet */
+#define FMV_IF_VALID	0
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
+#define	FMV_OWN_FREE		(-1ULL)	/* free space */
+#define FMV_OWN_UNKNOWN		(-2ULL)	/* unknown owner */
+#define FMV_OWN_FS		(-3ULL)	/* static fs metadata */
+#define FMV_OWN_LOG		(-4ULL)	/* journalling log */
+#define FMV_OWN_AG		(-5ULL)	/* per-AG metadata */
+#define FMV_OWN_INOBT		(-6ULL)	/* inode btree blocks */
+#define FMV_OWN_INODES		(-7ULL)	/* inodes */
+#define FMV_OWN_REFC		(-8ULL) /* refcount tree */
+#define FMV_OWN_COW		(-9ULL) /* cow allocations */
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
+#define XFS_IOC_GETFSMAPX	_IOWR('X', 59, struct getfsmapx)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

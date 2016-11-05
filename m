Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39473 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754109AbcKEAZc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:25:32 -0400
Subject: [PATCH 04/39] xfs: introduce the XFS_IOC_GETFSMAP ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:24:57 -0700
Message-ID: <147830549775.4165.9686887818420463480.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Introduce a new ioctl that uses the reverse mapping btree to return
information about the physical layout of the filesystem.

v2: shorten the device field to u32 since that's all we need for
dev_t.  Support reporting reverse mapping information for all the
devices that XFS supports (data, log).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_fs.h |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index df58c1c..6857355 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -117,6 +117,100 @@ struct getbmapx {
 #define BMV_OF_SHARED		0x8	/* segment shared with another file */
 
 /*
+ *	Structure for XFS_IOC_GETFSMAP.
+ *
+ *	The memory layout for this call are the scalar values defined in
+ *	struct fsmap_head, followed by two struct fsmap that describe
+ *	the lower and upper bound of mappings to return, followed by an
+ *	array of struct fsmap mappings.
+ *
+ *	fmh_iflags control the output of the call, whereas fmh_oflags report
+ *	on the overall record output.  fmh_count should be set to the
+ *	length of the fmh_recs array, and fmh_entries will be set to the
+ *	number of entries filled out during each call.  If fmh_count is
+ *	zero, the number of reverse mappings will be returned in
+ *	fmh_entries, though no mappings will be returned.  fmh_reserved
+ *	must be set to zero.
+ *
+ *	The two elements in the fmh_keys array are used to constrain the
+ *	output.  The first element in the array should represent the
+ *	lowest disk mapping ("low key") that the user wants to learn
+ *	about.  If this value is all zeroes, the filesystem will return
+ *	the first entry it knows about.  For a subsequent call, the
+ *	contents of fsmap_head.fmh_recs[fsmap_head.fmh_count - 1] should be
+ *	copied into fmh_keys[0] to have the kernel start where it left off.
+ *
+ *	The second element in the fmh_keys array should represent the
+ *	highest disk mapping ("high key") that the user wants to learn
+ *	about.  If this value is all ones, the filesystem will not stop
+ *	until it runs out of mapping to return or runs out of space in
+ *	fmh_recs.
+ *
+ *	fmr_device can be either a 32-bit cookie representing a device, or
+ *	a 32-bit dev_t if the FMH_OF_DEV_T flag is set.  fmr_physical,
+ *	fmr_offset, and fmr_length are expressed in units of bytes.
+ *	fmr_owner is either an inode number, or a special value if
+ *	FMR_OF_SPECIAL_OWNER is set in fmr_flags.
+ */
+#ifndef HAVE_GETFSMAP
+struct fsmap {
+	__u32		fmr_device;	/* device id */
+	__u32		fmr_flags;	/* mapping flags */
+	__u64		fmr_physical;	/* device offset of segment */
+	__u64		fmr_owner;	/* owner id */
+	__u64		fmr_offset;	/* file offset of segment */
+	__u64		fmr_length;	/* length of segment */
+	__u64		fmr_reserved[3];	/* must be zero */
+};
+
+struct fsmap_head {
+	__u32		fmh_iflags;	/* control flags */
+	__u32		fmh_oflags;	/* output flags */
+	__u32		fmh_count;	/* # of entries in array incl. input */
+	__u32		fmh_entries;	/* # of entries filled in (output). */
+	__u64		fmh_reserved[6];	/* must be zero */
+
+	struct fsmap	fmh_keys[2];	/* low and high keys for the mapping search */
+	struct fsmap	fmh_recs[];	/* returned records */
+};
+
+/* Size of an fsmap_head with room for nr records. */
+static inline size_t
+fsmap_sizeof(
+	unsigned int	nr)
+{
+	return sizeof(struct fsmap_head) + nr * sizeof(struct fsmap);
+}
+#endif
+
+/*	fmh_iflags values - set by XFS_IOC_GETFSMAP caller in the header. */
+/* no flags defined yet */
+#define FMH_IF_VALID		0
+
+/*	fmh_oflags values - returned in the header segment only. */
+#define FMH_OF_DEV_T		0x1	/* fmr_device values will be dev_t */
+
+/*	fmr_flags values - returned for each non-header segment */
+#define FMR_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
+#define FMR_OF_ATTR_FORK	0x2	/* segment = attribute fork */
+#define FMR_OF_EXTENT_MAP	0x4	/* segment = extent map */
+#define FMR_OF_SHARED		0x8	/* segment = shared with another file */
+#define FMR_OF_SPECIAL_OWNER	0x10	/* owner is a special value */
+#define FMR_OF_LAST		0x20	/* segment is the last in the FS */
+
+/*	fmr_owner special values */
+#define FMR_OWN_FREE		(-1ULL)	/* free space */
+#define FMR_OWN_UNKNOWN		(-2ULL)	/* unknown owner */
+#define FMR_OWN_FS		(-3ULL)	/* static fs metadata */
+#define FMR_OWN_LOG		(-4ULL)	/* journalling log */
+#define FMR_OWN_AG		(-5ULL)	/* per-AG metadata */
+#define FMR_OWN_INOBT		(-6ULL)	/* inode btree blocks */
+#define FMR_OWN_INODES		(-7ULL)	/* inodes */
+#define FMR_OWN_REFC		(-8ULL) /* refcount tree */
+#define FMR_OWN_COW		(-9ULL) /* cow staging */
+#define FMR_OWN_DEFECTIVE	(-10ULL) /* bad blocks */
+
+/*
  * Structure for XFS_IOC_FSSETDM.
  * For use by backup and restore programs to set the XFS on-disk inode
  * fields di_dmevmask and di_dmstate.  These must be set to exactly and
@@ -523,6 +617,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
+#define XFS_IOC_GETFSMAP	_IOWR('X', 59, struct fsmap_head)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s


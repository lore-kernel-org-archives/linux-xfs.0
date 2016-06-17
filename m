Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C41A38457
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:45:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8CB688F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:45:09 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id sWJjWambzLTy4JaK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:45:07 -0700 (PDT)
Subject: [PATCH 136/145] xfs: introduce the XFS_IOC_GETFSMAPX ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:45:03 -0700
Message-ID: <146612790296.16048.8214179908320601737.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Introduce a new ioctl that uses the reverse mapping btree to return
information about the physical layout of the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_fs.h       |   62 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_refcount.c |   51 +++++++++++++++++++++++++++++-----------
 libxfs/xfs_refcount.h |    4 +++
 3 files changed, 103 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index df58c1c..236a5a7 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -117,6 +117,67 @@ struct getbmapx {
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
@@ -523,6 +584,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
+#define XFS_IOC_GETFSMAPX	_IOWR('X', 59, struct getfsmapx)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 855ab54..a19cb45 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1171,8 +1171,9 @@ xfs_refcount_decrease_extent(
  * extent we find.  If no shared blocks are found, flen will be set to zero.
  */
 int
-xfs_refcount_find_shared(
+__xfs_refcount_find_shared(
 	struct xfs_mount	*mp,
+	struct xfs_buf		*agbp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen,
@@ -1181,23 +1182,13 @@ xfs_refcount_find_shared(
 	bool			find_maximal)
 {
 	struct xfs_btree_cur	*cur;
-	struct xfs_buf		*agbp;
 	struct xfs_refcount_irec	tmp;
-	int			error;
 	int			i, have;
 	int			bt_error = XFS_BTREE_ERROR;
+	int			error;
 
 	trace_xfs_refcount_find_shared(mp, agno, agbno, aglen);
 
-	if (xfs_always_cow) {
-		*fbno = agbno;
-		*flen = aglen;
-		return 0;
-	}
-
-	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
-	if (error)
-		goto out;
 	cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
 
 	/* By default, skip the whole range */
@@ -1272,14 +1263,46 @@ done:
 
 out_error:
 	xfs_btree_del_cursor(cur, bt_error);
-	xfs_buf_relse(agbp);
-out:
 	if (error)
 		trace_xfs_refcount_find_shared_error(mp, agno, error, _RET_IP_);
 	return error;
 }
 
 /*
+ * Given an AG extent, find the lowest-numbered run of shared blocks within
+ * that range and return the range in fbno/flen.
+ */
+int
+xfs_refcount_find_shared(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	xfs_agblock_t		*fbno,
+	xfs_extlen_t		*flen,
+	bool			find_maximal)
+{
+	struct xfs_buf		*agbp;
+	int			error;
+
+	if (xfs_always_cow) {
+		*fbno = agbno;
+		*flen = aglen;
+		return 0;
+	}
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		return error;
+
+	error = __xfs_refcount_find_shared(mp, agbp, agno, agbno, aglen,
+			fbno, flen, find_maximal);
+
+	xfs_buf_relse(agbp);
+	return error;
+}
+
+/*
  * Recovering CoW Blocks After a Crash
  *
  * Due to the way that the copy on write mechanism works, there's a window of
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 6665eeb..44b0346 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -53,6 +53,10 @@ extern int xfs_refcount_finish_one(struct xfs_trans *tp,
 		xfs_fsblock_t startblock, xfs_extlen_t blockcount,
 		xfs_extlen_t *adjusted, struct xfs_btree_cur **pcur);
 
+extern int __xfs_refcount_find_shared(struct xfs_mount *mp,
+		struct xfs_buf *agbp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		xfs_extlen_t aglen, xfs_agblock_t *fbno, xfs_extlen_t *flen,
+		bool find_maximal);
 extern int xfs_refcount_find_shared(struct xfs_mount *mp, xfs_agnumber_t agno,
 		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
 		xfs_extlen_t *flen, bool find_maximal);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

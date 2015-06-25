Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C7B87F81
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:40:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 123BB8F8039
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:40:23 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id TrMahjaWumCa870x (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:40:20 -0700 (PDT)
Subject: [PATCH 10/14] xfs: minimize impact to non-reflink files via reflink
	per-inode flag
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:40:16 -0700
Message-ID: <20150625234016.4992.52406.stgit@birch.djwong.org>
In-Reply-To: <20150625233909.4992.68314.stgit@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
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

Gate all the reflink functions (which generally involve an expensive
trip to the reflink btree) on an inode flag which is applied to both
inodes at reflink time.  This minimizes reflink's impact on non-CoW
files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c          |    2 +
 fs/xfs/libxfs/xfs_format.h        |    5 ++-
 fs/xfs/libxfs/xfs_reflink_btree.c |   24 ++++++++++++++-
 fs/xfs/libxfs/xfs_reflink_btree.h |    5 ++-
 fs/xfs/xfs_bmap_util.c            |    9 ++++++
 fs/xfs/xfs_inode.c                |    7 ++++
 fs/xfs/xfs_iops.c                 |    3 +-
 fs/xfs/xfs_reflink.c              |   60 ++++++++++++++++++++++++++++++++++---
 8 files changed, 105 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 05e8346..737c03a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5004,7 +5004,7 @@ xfs_bmap_del_extent(
 	 * If we need to, add to list of extents to delete.
 	 */
 	if (do_fx)
-		xfs_reflink_bmap_add_free(mp, flist, del->br_startblock,
+		xfs_reflink_bmap_add_free(mp, flist, ip, del->br_startblock,
 					  del->br_blockcount, ip->i_ino, tp);
 	/*
 	 * Adjust inode # blocks in the file.
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e4954ab..44e408a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -995,6 +995,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG_EXTSZINHERIT_BIT 12	/* inherit inode extent size */
 #define XFS_DIFLAG_NODEFRAG_BIT     13	/* do not reorganize/defragment */
 #define XFS_DIFLAG_FILESTREAM_BIT   14  /* use filestream allocator */
+#define XFS_DIFLAG_REFLINK_BIT      15  /* check reflink btree for CoW */
 #define XFS_DIFLAG_REALTIME      (1 << XFS_DIFLAG_REALTIME_BIT)
 #define XFS_DIFLAG_PREALLOC      (1 << XFS_DIFLAG_PREALLOC_BIT)
 #define XFS_DIFLAG_NEWRTBM       (1 << XFS_DIFLAG_NEWRTBM_BIT)
@@ -1010,13 +1011,15 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG_EXTSZINHERIT  (1 << XFS_DIFLAG_EXTSZINHERIT_BIT)
 #define XFS_DIFLAG_NODEFRAG      (1 << XFS_DIFLAG_NODEFRAG_BIT)
 #define XFS_DIFLAG_FILESTREAM    (1 << XFS_DIFLAG_FILESTREAM_BIT)
+#define XFS_DIFLAG_REFLINK       (1 << XFS_DIFLAG_REFLINK_BIT)
 
 #define XFS_DIFLAG_ANY \
 	(XFS_DIFLAG_REALTIME | XFS_DIFLAG_PREALLOC | XFS_DIFLAG_NEWRTBM | \
 	 XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_APPEND | XFS_DIFLAG_SYNC | \
 	 XFS_DIFLAG_NOATIME | XFS_DIFLAG_NODUMP | XFS_DIFLAG_RTINHERIT | \
 	 XFS_DIFLAG_PROJINHERIT | XFS_DIFLAG_NOSYMLINKS | XFS_DIFLAG_EXTSIZE | \
-	 XFS_DIFLAG_EXTSZINHERIT | XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM)
+	 XFS_DIFLAG_EXTSZINHERIT | XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM | \
+	 XFS_DIFLAG_REFLINK)
 
 /*
  * Inode number format:
diff --git a/fs/xfs/libxfs/xfs_reflink_btree.c b/fs/xfs/libxfs/xfs_reflink_btree.c
index f40ba1f..7daba37 100644
--- a/fs/xfs/libxfs/xfs_reflink_btree.c
+++ b/fs/xfs/libxfs/xfs_reflink_btree.c
@@ -25,6 +25,7 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
+#include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_reflink_btree.h"
 #include "xfs_alloc.h"
@@ -936,6 +937,26 @@ error0:
 	return error;
 }
 
+/*
+ * xfs_is_reflink_inode() -- Decide if an inode needs to be checked for CoW.
+ *
+ * @ip: XFS inode
+ */
+bool
+xfs_is_reflink_inode(
+	struct xfs_inode	*ip)		/* XFS inode */
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return false;
+	if (!(ip->i_d.di_flags & XFS_DIFLAG_REFLINK))
+		return false;
+
+	ASSERT(!XFS_IS_REALTIME_INODE(ip));
+	return true;
+}
+
 /**
  * xfs_reflink_bmap_add_free() - release a range of blocks
  *
@@ -950,6 +971,7 @@ int
 xfs_reflink_bmap_add_free(
 	struct xfs_mount	*mp,		/* mount point structure */
 	xfs_bmap_free_t		*flist,		/* list of extents */
+	struct xfs_inode	*ip,		/* xfs inode */
 	xfs_fsblock_t		fsbno,		/* fs block number of extent */
 	xfs_filblks_t		fslen,		/* length of extent */
 	uint64_t		owner,		/* extent owner */
@@ -971,7 +993,7 @@ xfs_reflink_bmap_add_free(
 	unsigned long long	blocks_freed;
 	xfs_fsblock_t		range_fsb;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (!xfs_is_reflink_inode(ip)) {
 		xfs_bmap_add_free(mp, flist, fsbno, fslen, owner);
 		return 0;
 	}
diff --git a/fs/xfs/libxfs/xfs_reflink_btree.h b/fs/xfs/libxfs/xfs_reflink_btree.h
index 4ea0ac4..46dd0f2 100644
--- a/fs/xfs/libxfs/xfs_reflink_btree.h
+++ b/fs/xfs/libxfs/xfs_reflink_btree.h
@@ -72,7 +72,10 @@ extern int xfs_reflinkbt_adjust_refcount(struct xfs_mount *, struct xfs_trans *,
 		int);
 
 extern int xfs_reflink_bmap_add_free(struct xfs_mount *mp,
-		xfs_bmap_free_t *flist, xfs_fsblock_t fsbno, xfs_filblks_t len,
+		xfs_bmap_free_t *flist, struct xfs_inode *ip,
+		xfs_fsblock_t fsbno, xfs_filblks_t len,
 		uint64_t owner, struct xfs_trans *tp);
 
+extern bool xfs_is_reflink_inode(struct xfs_inode *ip);
+
 #endif	/* __XFS_REFLINK_BTREE_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 9c931a7..be010c9 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -41,6 +41,7 @@
 #include "xfs_icache.h"
 #include "xfs_log.h"
 #include "xfs_reflink.h"
+#include "xfs_reflink_btree.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -1320,6 +1321,14 @@ xfs_free_file_space(
 		}
 
 		/*
+		 * Clear the reflink flag if we freed everything.
+		 */
+		if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
+			ip->i_d.di_flags &= ~XFS_DIFLAG_REFLINK;
+			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		}
+
+		/*
 		 * complete the transaction
 		 */
 		error = xfs_bmap_finish(&tp, &free_list, &committed);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a37a101..e688732 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -48,6 +48,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_reflink_btree.h"
 
 kmem_zone_t *xfs_inode_zone;
 
@@ -1566,6 +1567,12 @@ xfs_itruncate_extents(
 	}
 
 	/*
+	 * Clear the reflink flag if we truncated everything.
+	 */
+	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip))
+		ip->i_d.di_flags &= ~XFS_DIFLAG_REFLINK;
+
+	/*
 	 * Always re-log the inode so that our permanent transaction can keep
 	 * on rolling it forward in the log.
 	 */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0336fed..be17eef 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -40,6 +40,7 @@
 #include "xfs_pnfs.h"
 #include "xfs_bit.h"
 #include "xfs_reflink.h"
+#include "xfs_reflink_btree.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -1058,7 +1059,7 @@ xfs_fiemap_format(
 			physical = 0;
 			len = loop_len;
 			nr = 1;
-		} else if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		} else if (xfs_is_reflink_inode(ip)) {
 			fsbno = XFS_DADDR_TO_FSB(mp, BTOBB(physical));
 			agno = XFS_FSB_TO_AGNO(mp, fsbno);
 			agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d796280..4f027d3 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -127,6 +127,54 @@ xfs_reflink(
 	}
 
 	/*
+	 * Ensure the reflink bit is set in both inodes.
+	 */
+	if (!(src->i_d.di_flags & XFS_DIFLAG_REFLINK) ||
+	    !(dest->i_d.di_flags & XFS_DIFLAG_REFLINK)) {
+		tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
+
+		/*
+		 * check for running out of space
+		 */
+		if (error) {
+			/*
+			 * Free the transaction structure.
+			 */
+			ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+			goto error0;
+		}
+
+		/* Lock both files against IO */
+		if (src->i_ino == dest->i_ino)
+			xfs_ilock(src, XFS_ILOCK_EXCL);
+		else
+			xfs_lock_two_inodes(src, dest, XFS_ILOCK_EXCL);
+
+		if (!(src->i_d.di_flags & XFS_DIFLAG_REFLINK)) {
+			xfs_trans_ijoin(tp, src, XFS_ILOCK_EXCL);
+			src->i_d.di_flags |= XFS_DIFLAG_REFLINK;
+			xfs_trans_log_inode(tp, src, XFS_ILOG_CORE);
+		} else
+			xfs_iunlock(src, XFS_ILOCK_EXCL);
+
+		if (src->i_ino == dest->i_ino)
+			goto commit_flags;
+
+		if (!(dest->i_d.di_flags & XFS_DIFLAG_REFLINK)) {
+			xfs_trans_ijoin(tp, dest, XFS_ILOCK_EXCL);
+			dest->i_d.di_flags |= XFS_DIFLAG_REFLINK;
+			xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
+		} else
+			xfs_iunlock(dest, XFS_ILOCK_EXCL);
+
+commit_flags:
+		error = xfs_trans_commit(tp);
+		if (error)
+			goto out_unlock_io;
+	}
+
+	/*
 	 * Try to read extents from the first block indicated
 	 * by fsbno to the end block of the file.
 	 */
@@ -436,7 +484,7 @@ xfs_reflink_fork_block(
 	xfs_reflink_end_io_t	*eio;
 	struct xfs_mount	*mp = ip->i_mount;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_is_reflink_inode(ip))
 		return 0;
 	if (*type == XFS_IO_DELALLOC || *type == XFS_IO_UNWRITTEN)
 		return 0;
@@ -548,7 +596,7 @@ xfs_reflink_remap_after_io(
 	CHECK_AG_NUMBER(mp, agno);
 	CHECK_AG_EXTENT(mp, agbno, 1);
 	ASSERT(imap->br_state == XFS_EXT_NORM);
-
+	ASSERT(xfs_is_reflink_inode(ip));
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
 
 	/*
@@ -623,6 +671,7 @@ xfs_reflink_end_io(
 	struct list_head	*pos, *n;
 	xfs_reflink_end_io_t	*eio;
 
+	ASSERT(xfs_is_reflink_inode(ip));
 	error = 0;
 	list_for_each_safe(pos, n, &ioend->io_reflink_endio_list) {
 		eio = list_entry(pos, xfs_reflink_end_io_t, rlei_list);
@@ -659,7 +708,7 @@ xfs_reflink_should_fork_block(
 	int			error;
 	struct xfs_mount	*mp = ip->i_mount;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (!xfs_is_reflink_inode(ip)) {
 		*type = false;
 		return 0;
 	}
@@ -708,8 +757,7 @@ xfs_reflink_fork_buf(
 	/*
 	 * Do we need to fork this block?
 	 */
-	if (!xfs_sb_version_hasreflink(&mp->m_sb) ||
-	    XFS_IS_REALTIME_INODE(ip)) {
+	if (!xfs_is_reflink_inode(ip)) {
 		*ptp = NULL;
 		return 0;
 	}
@@ -812,6 +860,8 @@ xfs_reflink_finish_fork_buf(
 	if (tp == NULL)
 		return 0;
 
+	ASSERT(xfs_is_reflink_inode(ip));
+
 	fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 	if (write_error != 0) {
 		error = xfs_free_extent(tp, fsbno, 1, ip->i_ino);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

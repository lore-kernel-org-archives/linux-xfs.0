Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 74A257F3F
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 18:52:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 237258F8035
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 16:52:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dip2eftDA6TC41II for <xfs@oss.sgi.com>;
	Tue, 22 Oct 2013 16:51:54 -0700 (PDT)
Date: Wed, 23 Oct 2013 10:51:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/19, V3] xfs: decouple inode and bmap btree header files
Message-ID: <20131022235150.GO2797@dastard>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-10-git-send-email-david@fromorbit.com>
	<20131022182932.GP1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131022182932.GP1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Currently the xfs_inode.h header has a dependency on the definition
of the BMAP btree records as the inode fork includes an array of
xfs_bmbt_rec_host_t objects in it's definition.

Move all the btree format definitions from xfs_btree.h,
xfs_bmap_btree.h, xfs_alloc_btree.h and xfs_ialloc_btree.h to
xfs_format.h to continue the process of centralising the on-disk
format definitions. With this done, the xfs inode definitions are no
longer dependent on btree header files.

The enables a massive culling of unnecessary includes, with close to
200 #include directives removed from the XFS kernel code base.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Ben Myers <bpm@sgi.com>
---
V3: rebase due to changed fs/xfs/xfs_file.c include files as a
result of the fallocate rework.

(Wrong patch sent as v2, ignore it)

 fs/xfs/xfs_acl.c           |   8 +-
 fs/xfs/xfs_alloc.c         |   5 +-
 fs/xfs/xfs_alloc_btree.c   |   7 +-
 fs/xfs/xfs_alloc_btree.h   |  33 ------
 fs/xfs/xfs_aops.c          |   4 +-
 fs/xfs/xfs_attr.c          |   4 +-
 fs/xfs/xfs_attr_inactive.c |   8 +-
 fs/xfs/xfs_attr_leaf.c     |  13 +--
 fs/xfs/xfs_attr_list.c     |  12 +--
 fs/xfs/xfs_attr_remote.c   |   5 +-
 fs/xfs/xfs_bmap.c          |  12 +--
 fs/xfs/xfs_bmap_btree.c    |   7 +-
 fs/xfs/xfs_bmap_btree.h    | 103 ------------------
 fs/xfs/xfs_bmap_util.c     |   6 +-
 fs/xfs/xfs_btree.c         |   5 +-
 fs/xfs/xfs_btree.h         |  79 +++-----------
 fs/xfs/xfs_buf_item.h      |   4 -
 fs/xfs/xfs_da_btree.c      |   2 -
 fs/xfs/xfs_dir2.c          |   5 +-
 fs/xfs/xfs_dir2_block.c    |   4 +-
 fs/xfs/xfs_dir2_data.c     |   3 +-
 fs/xfs/xfs_dir2_leaf.c     |   4 +-
 fs/xfs/xfs_dir2_node.c     |   3 +-
 fs/xfs/xfs_dir2_readdir.c  |   4 +-
 fs/xfs/xfs_dir2_sf.c       |   4 +-
 fs/xfs/xfs_discard.c       |   6 +-
 fs/xfs/xfs_dquot.c         |   5 +-
 fs/xfs/xfs_dquot_buf.c     |   2 -
 fs/xfs/xfs_dquot_item.c    |   8 +-
 fs/xfs/xfs_error.c         |   4 +-
 fs/xfs/xfs_export.c        |   2 +-
 fs/xfs/xfs_extent_busy.c   |   2 -
 fs/xfs/xfs_extent_busy.h   |   4 +
 fs/xfs/xfs_file.c          |   5 +-
 fs/xfs/xfs_filestream.c    |   4 +-
 fs/xfs/xfs_format.h        | 255 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsops.c         |  12 +--
 fs/xfs/xfs_ialloc.c        |   6 +-
 fs/xfs/xfs_ialloc.h        |   3 +-
 fs/xfs/xfs_ialloc_btree.c  |   6 +-
 fs/xfs/xfs_ialloc_btree.h  |  49 ---------
 fs/xfs/xfs_icache.c        |   4 -
 fs/xfs/xfs_inode.c         |  10 +-
 fs/xfs/xfs_inode.h         |   1 -
 fs/xfs/xfs_inode_buf.c     |   6 +-
 fs/xfs/xfs_inode_fork.c    |  16 +--
 fs/xfs/xfs_inode_fork.h    |   1 +
 fs/xfs/xfs_inode_item.c    |   4 +-
 fs/xfs/xfs_ioctl.c         |   9 +-
 fs/xfs/xfs_ioctl32.c       |   3 +-
 fs/xfs/xfs_iomap.c         |  16 +--
 fs/xfs/xfs_iops.c          |   8 +-
 fs/xfs/xfs_itable.c        |   9 +-
 fs/xfs/xfs_log.c           |   6 +-
 fs/xfs/xfs_log_recover.c   |  18 ++--
 fs/xfs/xfs_log_rlimit.c    |   3 +-
 fs/xfs/xfs_mount.c         |  15 +--
 fs/xfs/xfs_qm.c            |  11 +-
 fs/xfs/xfs_qm_bhv.c        |   7 --
 fs/xfs/xfs_qm_syscalls.c   |  10 +-
 fs/xfs/xfs_quotaops.c      |   3 +-
 fs/xfs/xfs_rtalloc.c       |   9 +-
 fs/xfs/xfs_sb.c            |  18 +---
 fs/xfs/xfs_super.c         |  16 +--
 fs/xfs/xfs_symlink.c       |   6 +-
 fs/xfs/xfs_trace.c         |   5 +-
 fs/xfs/xfs_trans.c         |  16 +--
 fs/xfs/xfs_trans.h         |   5 +
 fs/xfs/xfs_trans_buf.c     |   5 +-
 fs/xfs/xfs_trans_dquot.c   |   9 +-
 fs/xfs/xfs_trans_inode.c   |   6 +-
 fs/xfs/xfs_trans_resv.c    |  12 +--
 fs/xfs/xfs_xattr.c         |   2 +-
 73 files changed, 403 insertions(+), 583 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 0e2f37e..370eb3e 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -16,15 +16,15 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_acl.h"
-#include "xfs_attr.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_inode.h"
 #include "xfs_ag.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_acl.h"
+#include "xfs_attr.h"
 #include "xfs_trace.h"
 #include <linux/slab.h>
 #include <linux/xattr.h>
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 999db7a..bcf1652 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -25,12 +25,9 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_extent_busy.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index 0bd33bf..698587f 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -17,17 +17,14 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_extent_busy.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_alloc_btree.h b/fs/xfs/xfs_alloc_btree.h
index 72676c3..45e189e 100644
--- a/fs/xfs/xfs_alloc_btree.h
+++ b/fs/xfs/xfs_alloc_btree.h
@@ -27,39 +27,6 @@ struct xfs_btree_cur;
 struct xfs_mount;
 
 /*
- * There are two on-disk btrees, one sorted by blockno and one sorted
- * by blockcount and blockno.  All blocks look the same to make the code
- * simpler; if we have time later, we'll make the optimizations.
- */
-#define	XFS_ABTB_MAGIC		0x41425442	/* 'ABTB' for bno tree */
-#define	XFS_ABTB_CRC_MAGIC	0x41423342	/* 'AB3B' */
-#define	XFS_ABTC_MAGIC		0x41425443	/* 'ABTC' for cnt tree */
-#define	XFS_ABTC_CRC_MAGIC	0x41423343	/* 'AB3C' */
-
-/*
- * Data record/key structure
- */
-typedef struct xfs_alloc_rec {
-	__be32		ar_startblock;	/* starting block number */
-	__be32		ar_blockcount;	/* count of free blocks */
-} xfs_alloc_rec_t, xfs_alloc_key_t;
-
-typedef struct xfs_alloc_rec_incore {
-	xfs_agblock_t	ar_startblock;	/* starting block number */
-	xfs_extlen_t	ar_blockcount;	/* count of free blocks */
-} xfs_alloc_rec_incore_t;
-
-/* btree pointer type */
-typedef __be32 xfs_alloc_ptr_t;
-
-/*
- * Block numbers in the AG:
- * SB is sector 0, AGF is sector 1, AGI is sector 2, AGFL is sector 3.
- */
-#define	XFS_BNO_BLOCK(mp)	((xfs_agblock_t)(XFS_AGFL_BLOCK(mp) + 1))
-#define	XFS_CNT_BLOCK(mp)	((xfs_agblock_t)(XFS_BNO_BLOCK(mp) + 1))
-
-/*
  * Btree block header size depends on a superblock flag.
  */
 #define XFS_ALLOC_BLOCK_LEN(mp) \
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index caa63cb3..eb310ca 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -23,8 +23,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
@@ -34,6 +32,8 @@
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_dinode.h"
 #include <linux/aio.h>
 #include <linux/gfp.h>
 #include <linux/mpage.h>
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index ce6f9e0..b861270 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -27,15 +27,14 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_attr_sf.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_remote.h"
@@ -43,6 +42,7 @@
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_dinode.h"
 
 /*
  * xfs_attr.c
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 45480f5..f33fb62 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -28,14 +28,9 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
+#include "xfs_inode.h"
 #include "xfs_alloc.h"
-#include "xfs_btree.h"
 #include "xfs_attr_remote.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
@@ -44,6 +39,7 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_trace.h"
+#include "xfs_dinode.h"
 
 /*
  * Look at all the extents for this logical region,
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index c10c70c..a0f9019 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -18,6 +18,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
@@ -26,24 +27,20 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_alloc.h"
-#include "xfs_btree.h"
-#include "xfs_attr_sf.h"
-#include "xfs_attr_remote.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
+#include "xfs_attr_sf.h"
+#include "xfs_attr_remote.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_cksum.h"
+#include "xfs_dinode.h"
 
 
 /*
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index a319eb4..46c4ce1 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -18,6 +18,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
@@ -26,24 +27,19 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_alloc.h"
-#include "xfs_btree.h"
-#include "xfs_attr_sf.h"
-#include "xfs_attr_remote.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
+#include "xfs_attr_sf.h"
+#include "xfs_attr_remote.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_cksum.h"
+#include "xfs_dinode.h"
 
 STATIC int
 xfs_attr_shortform_compare(const void *a, const void *b)
diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index 1407191..2e55304 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -18,6 +18,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
@@ -25,10 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
-#include "xfs_error.h"
 #include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
 #include "xfs_trans.h"
@@ -42,6 +40,7 @@
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_buf_item.h"
+#include "xfs_error.h"
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index c3756ac0..1c02da8 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -29,29 +29,25 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
-#include "xfs_mount.h"
-#include "xfs_itable.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_extfree_item.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
-#include "xfs_attr_leaf.h"
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_buf_item.h"
-#include "xfs_filestream.h"
 #include "xfs_trace.h"
 #include "xfs_symlink.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_dinode.h"
+#include "xfs_filestream.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index 89ef4e6..2fb4a22 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -24,21 +24,18 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
-#include "xfs_itable.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
+#include "xfs_dinode.h"
 
 /*
  * Determine the extent state.
diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
index e2b0768..6e42e1e 100644
--- a/fs/xfs/xfs_bmap_btree.h
+++ b/fs/xfs/xfs_bmap_btree.h
@@ -18,9 +18,6 @@
 #ifndef __XFS_BMAP_BTREE_H__
 #define __XFS_BMAP_BTREE_H__
 
-#define XFS_BMAP_MAGIC		0x424d4150	/* 'BMAP' */
-#define XFS_BMAP_CRC_MAGIC	0x424d4133	/* 'BMA3' */
-
 struct xfs_btree_cur;
 struct xfs_btree_block;
 struct xfs_mount;
@@ -28,85 +25,6 @@ struct xfs_inode;
 struct xfs_trans;
 
 /*
- * Bmap root header, on-disk form only.
- */
-typedef struct xfs_bmdr_block {
-	__be16		bb_level;	/* 0 is a leaf */
-	__be16		bb_numrecs;	/* current # of data records */
-} xfs_bmdr_block_t;
-
-/*
- * Bmap btree record and extent descriptor.
- *  l0:63 is an extent flag (value 1 indicates non-normal).
- *  l0:9-62 are startoff.
- *  l0:0-8 and l1:21-63 are startblock.
- *  l1:0-20 are blockcount.
- */
-#define BMBT_EXNTFLAG_BITLEN	1
-#define BMBT_STARTOFF_BITLEN	54
-#define BMBT_STARTBLOCK_BITLEN	52
-#define BMBT_BLOCKCOUNT_BITLEN	21
-
-typedef struct xfs_bmbt_rec {
-	__be64			l0, l1;
-} xfs_bmbt_rec_t;
-
-typedef __uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
-typedef xfs_bmbt_rec_t xfs_bmdr_rec_t;
-
-typedef struct xfs_bmbt_rec_host {
-	__uint64_t		l0, l1;
-} xfs_bmbt_rec_host_t;
-
-/*
- * Values and macros for delayed-allocation startblock fields.
- */
-#define STARTBLOCKVALBITS	17
-#define STARTBLOCKMASKBITS	(15 + XFS_BIG_BLKNOS * 20)
-#define DSTARTBLOCKMASKBITS	(15 + 20)
-#define STARTBLOCKMASK		\
-	(((((xfs_fsblock_t)1) << STARTBLOCKMASKBITS) - 1) << STARTBLOCKVALBITS)
-#define DSTARTBLOCKMASK		\
-	(((((xfs_dfsbno_t)1) << DSTARTBLOCKMASKBITS) - 1) << STARTBLOCKVALBITS)
-
-static inline int isnullstartblock(xfs_fsblock_t x)
-{
-	return ((x) & STARTBLOCKMASK) == STARTBLOCKMASK;
-}
-
-static inline int isnulldstartblock(xfs_dfsbno_t x)
-{
-	return ((x) & DSTARTBLOCKMASK) == DSTARTBLOCKMASK;
-}
-
-static inline xfs_fsblock_t nullstartblock(int k)
-{
-	ASSERT(k < (1 << STARTBLOCKVALBITS));
-	return STARTBLOCKMASK | (k);
-}
-
-static inline xfs_filblks_t startblockval(xfs_fsblock_t x)
-{
-	return (xfs_filblks_t)((x) & ~STARTBLOCKMASK);
-}
-
-/*
- * Possible extent formats.
- */
-typedef enum {
-	XFS_EXTFMT_NOSTATE = 0,
-	XFS_EXTFMT_HASSTATE
-} xfs_exntfmt_t;
-
-/*
- * Possible extent states.
- */
-typedef enum {
-	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
-	XFS_EXT_DMAPI_OFFLINE, XFS_EXT_INVALID
-} xfs_exntst_t;
-
-/*
  * Extent state and extent format macros.
  */
 #define XFS_EXTFMT_INODE(x)	\
@@ -115,27 +33,6 @@ typedef enum {
 #define ISUNWRITTEN(x)	((x)->br_state == XFS_EXT_UNWRITTEN)
 
 /*
- * Incore version of above.
- */
-typedef struct xfs_bmbt_irec
-{
-	xfs_fileoff_t	br_startoff;	/* starting file offset */
-	xfs_fsblock_t	br_startblock;	/* starting block number */
-	xfs_filblks_t	br_blockcount;	/* number of blocks */
-	xfs_exntst_t	br_state;	/* extent state */
-} xfs_bmbt_irec_t;
-
-/*
- * Key structure for non-leaf levels of the tree.
- */
-typedef struct xfs_bmbt_key {
-	__be64		br_startoff;	/* starting file offset */
-} xfs_bmbt_key_t, xfs_bmdr_key_t;
-
-/* btree pointer type */
-typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_ptr_t;
-
-/*
  * Btree block header size depends on a superblock flag.
  */
 #define XFS_BMBT_BLOCK_LEN(mp) \
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 271c0d6..5887e41 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -27,10 +27,6 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_trans.h"
@@ -38,6 +34,7 @@
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
@@ -45,6 +42,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_log.h"
+#include "xfs_dinode.h"
 
 /* Kernel only BMAP related definitions and functions */
 
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 0836511..9adaae4 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -18,16 +18,13 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index 06729b6..91e34f2 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
@@ -27,73 +27,6 @@ struct xfs_trans;
 extern kmem_zone_t	*xfs_btree_cur_zone;
 
 /*
- * This nonsense is to make -wlint happy.
- */
-#define	XFS_LOOKUP_EQ	((xfs_lookup_t)XFS_LOOKUP_EQi)
-#define	XFS_LOOKUP_LE	((xfs_lookup_t)XFS_LOOKUP_LEi)
-#define	XFS_LOOKUP_GE	((xfs_lookup_t)XFS_LOOKUP_GEi)
-
-#define	XFS_BTNUM_BNO	((xfs_btnum_t)XFS_BTNUM_BNOi)
-#define	XFS_BTNUM_CNT	((xfs_btnum_t)XFS_BTNUM_CNTi)
-#define	XFS_BTNUM_BMAP	((xfs_btnum_t)XFS_BTNUM_BMAPi)
-#define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
-
-/*
- * Generic btree header.
- *
- * This is a combination of the actual format used on disk for short and long
- * format btrees.  The first three fields are shared by both format, but the
- * pointers are different and should be used with care.
- *
- * To get the size of the actual short or long form headers please use the size
- * macros below.  Never use sizeof(xfs_btree_block).
- *
- * The blkno, crc, lsn, owner and uuid fields are only available in filesystems
- * with the crc feature bit, and all accesses to them must be conditional on
- * that flag.
- */
-struct xfs_btree_block {
-	__be32		bb_magic;	/* magic number for block type */
-	__be16		bb_level;	/* 0 is a leaf */
-	__be16		bb_numrecs;	/* current # of data records */
-	union {
-		struct {
-			__be32		bb_leftsib;
-			__be32		bb_rightsib;
-
-			__be64		bb_blkno;
-			__be64		bb_lsn;
-			uuid_t		bb_uuid;
-			__be32		bb_owner;
-			__le32		bb_crc;
-		} s;			/* short form pointers */
-		struct	{
-			__be64		bb_leftsib;
-			__be64		bb_rightsib;
-
-			__be64		bb_blkno;
-			__be64		bb_lsn;
-			uuid_t		bb_uuid;
-			__be64		bb_owner;
-			__le32		bb_crc;
-			__be32		bb_pad; /* padding for alignment */
-		} l;			/* long form pointers */
-	} bb_u;				/* rest */
-};
-
-#define XFS_BTREE_SBLOCK_LEN	16	/* size of a short form block */
-#define XFS_BTREE_LBLOCK_LEN	24	/* size of a long form block */
-
-/* sizes of CRC enabled btree blocks */
-#define XFS_BTREE_SBLOCK_CRC_LEN	(XFS_BTREE_SBLOCK_LEN + 40)
-#define XFS_BTREE_LBLOCK_CRC_LEN	(XFS_BTREE_LBLOCK_LEN + 48)
-
-#define XFS_BTREE_SBLOCK_CRC_OFF \
-	offsetof(struct xfs_btree_block, bb_u.s.bb_crc)
-#define XFS_BTREE_LBLOCK_CRC_OFF \
-	offsetof(struct xfs_btree_block, bb_u.l.bb_crc)
-
-/*
  * Generic key, ptr and record wrapper structures.
  *
  * These are disk format structures, and are converted where necessary
@@ -119,6 +52,18 @@ union xfs_btree_rec {
 };
 
 /*
+ * This nonsense is to make -wlint happy.
+ */
+#define	XFS_LOOKUP_EQ	((xfs_lookup_t)XFS_LOOKUP_EQi)
+#define	XFS_LOOKUP_LE	((xfs_lookup_t)XFS_LOOKUP_LEi)
+#define	XFS_LOOKUP_GE	((xfs_lookup_t)XFS_LOOKUP_GEi)
+
+#define	XFS_BTNUM_BNO	((xfs_btnum_t)XFS_BTNUM_BNOi)
+#define	XFS_BTNUM_CNT	((xfs_btnum_t)XFS_BTNUM_CNTi)
+#define	XFS_BTNUM_BMAP	((xfs_btnum_t)XFS_BTNUM_BMAPi)
+#define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
+
+/*
  * For logging record fields.
  */
 #define	XFS_BB_MAGIC		(1 << 0)
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index db63710..3f3455a 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -71,10 +71,6 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
 void	xfs_buf_iodone_callbacks(struct xfs_buf *);
 void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
 
-void	xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
-			       enum xfs_blft);
-void	xfs_trans_buf_copy_type(struct xfs_buf *dst_bp, struct xfs_buf *src_bp);
-
 extern kmem_zone_t	*xfs_buf_item_zone;
 
 #endif	/* __XFS_BUF_ITEM_H__ */
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 3770111..eb65c54 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -28,10 +28,8 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index cef1661..38bf932 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -17,6 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_inum.h"
@@ -25,9 +26,6 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
@@ -36,6 +34,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_dinode.h"
 
 struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
 
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 6c7cd3c..9f3f83a 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -18,6 +18,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
@@ -25,8 +26,6 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
@@ -37,6 +36,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
+#include "xfs_dinode.h"
 
 /*
  * Local function prototypes.
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 3f7eddd..ccfeb4d 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -18,6 +18,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
@@ -25,8 +26,6 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 44fe4b8..51fdc11 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -18,16 +18,14 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_dir2.h"
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 7836f04..b838164 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -18,6 +18,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
@@ -25,8 +26,6 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_dir2.h"
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 048d582..45c9ce8 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -18,6 +18,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
@@ -26,8 +27,6 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
@@ -35,6 +34,7 @@
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
+#include "xfs_dinode.h"
 
 /*
  * Directory file type support functions
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index ac3bb58..8811ee5 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -17,6 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
@@ -24,8 +25,6 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
@@ -33,6 +32,7 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
+#include "xfs_dinode.h"
 
 /*
  * Prototypes for internal functions.
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index d38f34c..8367d6d 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -23,11 +23,9 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_quota.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_btree.h"
 #include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 47a815d..6b1e695 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -25,16 +25,12 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_alloc.h"
 #include "xfs_quota.h"
-#include "xfs_rtalloc.h"
 #include "xfs_error.h"
-#include "xfs_itable.h"
-#include "xfs_attr.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
@@ -43,6 +39,7 @@
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_bmap_btree.h"
 
 /*
  * Lock order:
diff --git a/fs/xfs/xfs_dquot_buf.c b/fs/xfs/xfs_dquot_buf.c
index 3e84b3a..aaaf41b 100644
--- a/fs/xfs/xfs_dquot_buf.c
+++ b/fs/xfs/xfs_dquot_buf.c
@@ -21,11 +21,9 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_quota.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index f8a47f7..92e5f62 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -22,16 +22,10 @@
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_alloc.h"
-#include "xfs_quota.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
-#include "xfs_bmap.h"
-#include "xfs_rtalloc.h"
+#include "xfs_quota.h"
 #include "xfs_error.h"
-#include "xfs_itable.h"
-#include "xfs_attr.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index d6c188c..9995b80 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -16,15 +16,13 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
+#include "xfs_format.h"
 #include "xfs_fs.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
 #include "xfs_error.h"
 
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 8502aee..1399e18 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
@@ -24,7 +25,6 @@
 #include "xfs_da_format.h"
 #include "xfs_dir2.h"
 #include "xfs_export.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index de46264..fd22f69 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -26,9 +26,7 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_alloc.h"
-#include "xfs_inode.h"
 #include "xfs_extent_busy.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 985412d..bfff284 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -20,6 +20,10 @@
 #ifndef __XFS_EXTENT_BUSY_H__
 #define	__XFS_EXTENT_BUSY_H__
 
+struct xfs_mount;
+struct xfs_trans;
+struct xfs_alloc_arg;
+
 /*
  * Busy block/extent entry.  Indexed by a rbtree in perag to mark blocks that
  * have been freed but whose transactions aren't committed to disk yet.
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8b43bfa..52c91e1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
@@ -25,9 +26,6 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
@@ -39,6 +37,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_dinode.h"
 
 #include <linux/aio.h>
 #include <linux/dcache.h>
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 7f2c3c1..12b6e77 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -16,19 +16,19 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_ag.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_inum.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_alloc.h"
 #include "xfs_mru_cache.h"
+#include "xfs_dinode.h"
 #include "xfs_filestream.h"
 #include "xfs_trace.h"
 
diff --git a/fs/xfs/xfs_format.h b/fs/xfs/xfs_format.h
index a790428..b6ab5a3 100644
--- a/fs/xfs/xfs_format.h
+++ b/fs/xfs/xfs_format.h
@@ -156,4 +156,259 @@ struct xfs_dsymlink_hdr {
 	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
 			sizeof(struct xfs_dsymlink_hdr) : 0))
 
+
+/*
+ * Allocation Btree format definitions
+ *
+ * There are two on-disk btrees, one sorted by blockno and one sorted
+ * by blockcount and blockno.  All blocks look the same to make the code
+ * simpler; if we have time later, we'll make the optimizations.
+ */
+#define	XFS_ABTB_MAGIC		0x41425442	/* 'ABTB' for bno tree */
+#define	XFS_ABTB_CRC_MAGIC	0x41423342	/* 'AB3B' */
+#define	XFS_ABTC_MAGIC		0x41425443	/* 'ABTC' for cnt tree */
+#define	XFS_ABTC_CRC_MAGIC	0x41423343	/* 'AB3C' */
+
+/*
+ * Data record/key structure
+ */
+typedef struct xfs_alloc_rec {
+	__be32		ar_startblock;	/* starting block number */
+	__be32		ar_blockcount;	/* count of free blocks */
+} xfs_alloc_rec_t, xfs_alloc_key_t;
+
+typedef struct xfs_alloc_rec_incore {
+	xfs_agblock_t	ar_startblock;	/* starting block number */
+	xfs_extlen_t	ar_blockcount;	/* count of free blocks */
+} xfs_alloc_rec_incore_t;
+
+/* btree pointer type */
+typedef __be32 xfs_alloc_ptr_t;
+
+/*
+ * Block numbers in the AG:
+ * SB is sector 0, AGF is sector 1, AGI is sector 2, AGFL is sector 3.
+ */
+#define	XFS_BNO_BLOCK(mp)	((xfs_agblock_t)(XFS_AGFL_BLOCK(mp) + 1))
+#define	XFS_CNT_BLOCK(mp)	((xfs_agblock_t)(XFS_BNO_BLOCK(mp) + 1))
+
+
+/*
+ * Inode Allocation Btree format definitions
+ *
+ * There is a btree for the inode map per allocation group.
+ */
+#define	XFS_IBT_MAGIC		0x49414254	/* 'IABT' */
+#define	XFS_IBT_CRC_MAGIC	0x49414233	/* 'IAB3' */
+
+typedef	__uint64_t	xfs_inofree_t;
+#define	XFS_INODES_PER_CHUNK		(NBBY * sizeof(xfs_inofree_t))
+#define	XFS_INODES_PER_CHUNK_LOG	(XFS_NBBYLOG + 3)
+#define	XFS_INOBT_ALL_FREE		((xfs_inofree_t)-1)
+#define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
+
+static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
+{
+	return ((n >= XFS_INODES_PER_CHUNK ? 0 : XFS_INOBT_MASK(n)) - 1) << i;
+}
+
+/*
+ * Data record structure
+ */
+typedef struct xfs_inobt_rec {
+	__be32		ir_startino;	/* starting inode number */
+	__be32		ir_freecount;	/* count of free inodes (set bits) */
+	__be64		ir_free;	/* free inode mask */
+} xfs_inobt_rec_t;
+
+typedef struct xfs_inobt_rec_incore {
+	xfs_agino_t	ir_startino;	/* starting inode number */
+	__int32_t	ir_freecount;	/* count of free inodes (set bits) */
+	xfs_inofree_t	ir_free;	/* free inode mask */
+} xfs_inobt_rec_incore_t;
+
+
+/*
+ * Key structure
+ */
+typedef struct xfs_inobt_key {
+	__be32		ir_startino;	/* starting inode number */
+} xfs_inobt_key_t;
+
+/* btree pointer type */
+typedef __be32 xfs_inobt_ptr_t;
+
+/*
+ * block numbers in the AG.
+ */
+#define	XFS_IBT_BLOCK(mp)		((xfs_agblock_t)(XFS_CNT_BLOCK(mp) + 1))
+#define	XFS_PREALLOC_BLOCKS(mp)		((xfs_agblock_t)(XFS_IBT_BLOCK(mp) + 1))
+
+
+
+/*
+ * BMAP Btree format definitions
+ *
+ * This includes both the root block definition that sits inside an inode fork
+ * and the record/pointer formats for the leaf/node in the blocks.
+ */
+#define XFS_BMAP_MAGIC		0x424d4150	/* 'BMAP' */
+#define XFS_BMAP_CRC_MAGIC	0x424d4133	/* 'BMA3' */
+
+/*
+ * Bmap root header, on-disk form only.
+ */
+typedef struct xfs_bmdr_block {
+	__be16		bb_level;	/* 0 is a leaf */
+	__be16		bb_numrecs;	/* current # of data records */
+} xfs_bmdr_block_t;
+
+/*
+ * Bmap btree record and extent descriptor.
+ *  l0:63 is an extent flag (value 1 indicates non-normal).
+ *  l0:9-62 are startoff.
+ *  l0:0-8 and l1:21-63 are startblock.
+ *  l1:0-20 are blockcount.
+ */
+#define BMBT_EXNTFLAG_BITLEN	1
+#define BMBT_STARTOFF_BITLEN	54
+#define BMBT_STARTBLOCK_BITLEN	52
+#define BMBT_BLOCKCOUNT_BITLEN	21
+
+typedef struct xfs_bmbt_rec {
+	__be64			l0, l1;
+} xfs_bmbt_rec_t;
+
+typedef __uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
+typedef xfs_bmbt_rec_t xfs_bmdr_rec_t;
+
+typedef struct xfs_bmbt_rec_host {
+	__uint64_t		l0, l1;
+} xfs_bmbt_rec_host_t;
+
+/*
+ * Values and macros for delayed-allocation startblock fields.
+ */
+#define STARTBLOCKVALBITS	17
+#define STARTBLOCKMASKBITS	(15 + XFS_BIG_BLKNOS * 20)
+#define DSTARTBLOCKMASKBITS	(15 + 20)
+#define STARTBLOCKMASK		\
+	(((((xfs_fsblock_t)1) << STARTBLOCKMASKBITS) - 1) << STARTBLOCKVALBITS)
+#define DSTARTBLOCKMASK		\
+	(((((xfs_dfsbno_t)1) << DSTARTBLOCKMASKBITS) - 1) << STARTBLOCKVALBITS)
+
+static inline int isnullstartblock(xfs_fsblock_t x)
+{
+	return ((x) & STARTBLOCKMASK) == STARTBLOCKMASK;
+}
+
+static inline int isnulldstartblock(xfs_dfsbno_t x)
+{
+	return ((x) & DSTARTBLOCKMASK) == DSTARTBLOCKMASK;
+}
+
+static inline xfs_fsblock_t nullstartblock(int k)
+{
+	ASSERT(k < (1 << STARTBLOCKVALBITS));
+	return STARTBLOCKMASK | (k);
+}
+
+static inline xfs_filblks_t startblockval(xfs_fsblock_t x)
+{
+	return (xfs_filblks_t)((x) & ~STARTBLOCKMASK);
+}
+
+/*
+ * Possible extent formats.
+ */
+typedef enum {
+	XFS_EXTFMT_NOSTATE = 0,
+	XFS_EXTFMT_HASSTATE
+} xfs_exntfmt_t;
+
+/*
+ * Possible extent states.
+ */
+typedef enum {
+	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
+	XFS_EXT_DMAPI_OFFLINE, XFS_EXT_INVALID
+} xfs_exntst_t;
+
+/*
+ * Incore version of above.
+ */
+typedef struct xfs_bmbt_irec
+{
+	xfs_fileoff_t	br_startoff;	/* starting file offset */
+	xfs_fsblock_t	br_startblock;	/* starting block number */
+	xfs_filblks_t	br_blockcount;	/* number of blocks */
+	xfs_exntst_t	br_state;	/* extent state */
+} xfs_bmbt_irec_t;
+
+/*
+ * Key structure for non-leaf levels of the tree.
+ */
+typedef struct xfs_bmbt_key {
+	__be64		br_startoff;	/* starting file offset */
+} xfs_bmbt_key_t, xfs_bmdr_key_t;
+
+/* btree pointer type */
+typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_ptr_t;
+
+
+/*
+ * Generic Btree block format definitions
+ *
+ * This is a combination of the actual format used on disk for short and long
+ * format btrees.  The first three fields are shared by both format, but the
+ * pointers are different and should be used with care.
+ *
+ * To get the size of the actual short or long form headers please use the size
+ * macros below.  Never use sizeof(xfs_btree_block).
+ *
+ * The blkno, crc, lsn, owner and uuid fields are only available in filesystems
+ * with the crc feature bit, and all accesses to them must be conditional on
+ * that flag.
+ */
+struct xfs_btree_block {
+	__be32		bb_magic;	/* magic number for block type */
+	__be16		bb_level;	/* 0 is a leaf */
+	__be16		bb_numrecs;	/* current # of data records */
+	union {
+		struct {
+			__be32		bb_leftsib;
+			__be32		bb_rightsib;
+
+			__be64		bb_blkno;
+			__be64		bb_lsn;
+			uuid_t		bb_uuid;
+			__be32		bb_owner;
+			__le32		bb_crc;
+		} s;			/* short form pointers */
+		struct	{
+			__be64		bb_leftsib;
+			__be64		bb_rightsib;
+
+			__be64		bb_blkno;
+			__be64		bb_lsn;
+			uuid_t		bb_uuid;
+			__be64		bb_owner;
+			__le32		bb_crc;
+			__be32		bb_pad; /* padding for alignment */
+		} l;			/* long form pointers */
+	} bb_u;				/* rest */
+};
+
+#define XFS_BTREE_SBLOCK_LEN	16	/* size of a short form block */
+#define XFS_BTREE_LBLOCK_LEN	24	/* size of a long form block */
+
+/* sizes of CRC enabled btree blocks */
+#define XFS_BTREE_SBLOCK_CRC_LEN	(XFS_BTREE_SBLOCK_LEN + 40)
+#define XFS_BTREE_LBLOCK_CRC_LEN	(XFS_BTREE_LBLOCK_LEN + 48)
+
+#define XFS_BTREE_SBLOCK_CRC_OFF \
+	offsetof(struct xfs_btree_block, bb_u.s.bb_crc)
+#define XFS_BTREE_LBLOCK_CRC_OFF \
+	offsetof(struct xfs_btree_block, bb_u.l.bb_crc)
+
 #endif /* __XFS_FORMAT_H__ */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ceaec31..a6e54b3 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -18,30 +18,28 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
-#include "xfs_log_format.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
-#include "xfs_btree.h"
 #include "xfs_error.h"
+#include "xfs_btree.h"
+#include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_fsops.h"
 #include "xfs_itable.h"
 #include "xfs_trans_space.h"
 #include "xfs_rtalloc.h"
-#include "xfs_filestream.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_dinode.h"
+#include "xfs_filestream.h"
 
 /*
  * File system operations
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index c973ff8..14d732f 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -26,13 +26,10 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
@@ -42,6 +39,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_icreate_item.h"
 #include "xfs_icache.h"
+#include "xfs_dinode.h"
 
 
 /*
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index 1557798..a8f76a5 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -23,6 +23,7 @@ struct xfs_dinode;
 struct xfs_imap;
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_btree_cur;
 
 /*
  * Allocation parameters for inode allocation.
@@ -42,7 +43,7 @@ struct xfs_trans;
 static inline struct xfs_dinode *
 xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 {
-	return (xfs_dinode_t *)
+	return (struct xfs_dinode *)
 		(xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog));
 }
 
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index 2a0b615..1fa142d 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -17,19 +17,17 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_ialloc_btree.h b/fs/xfs/xfs_ialloc_btree.h
index cfbfe46..f38b220 100644
--- a/fs/xfs/xfs_ialloc_btree.h
+++ b/fs/xfs/xfs_ialloc_btree.h
@@ -27,55 +27,6 @@ struct xfs_btree_cur;
 struct xfs_mount;
 
 /*
- * There is a btree for the inode map per allocation group.
- */
-#define	XFS_IBT_MAGIC		0x49414254	/* 'IABT' */
-#define	XFS_IBT_CRC_MAGIC	0x49414233	/* 'IAB3' */
-
-typedef	__uint64_t	xfs_inofree_t;
-#define	XFS_INODES_PER_CHUNK		(NBBY * sizeof(xfs_inofree_t))
-#define	XFS_INODES_PER_CHUNK_LOG	(XFS_NBBYLOG + 3)
-#define	XFS_INOBT_ALL_FREE		((xfs_inofree_t)-1)
-#define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
-
-static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
-{
-	return ((n >= XFS_INODES_PER_CHUNK ? 0 : XFS_INOBT_MASK(n)) - 1) << i;
-}
-
-/*
- * Data record structure
- */
-typedef struct xfs_inobt_rec {
-	__be32		ir_startino;	/* starting inode number */
-	__be32		ir_freecount;	/* count of free inodes (set bits) */
-	__be64		ir_free;	/* free inode mask */
-} xfs_inobt_rec_t;
-
-typedef struct xfs_inobt_rec_incore {
-	xfs_agino_t	ir_startino;	/* starting inode number */
-	__int32_t	ir_freecount;	/* count of free inodes (set bits) */
-	xfs_inofree_t	ir_free;	/* free inode mask */
-} xfs_inobt_rec_incore_t;
-
-
-/*
- * Key structure
- */
-typedef struct xfs_inobt_key {
-	__be32		ir_startino;	/* starting inode number */
-} xfs_inobt_key_t;
-
-/* btree pointer type */
-typedef __be32 xfs_inobt_ptr_t;
-
-/*
- * block numbers in the AG.
- */
-#define	XFS_IBT_BLOCK(mp)		((xfs_agblock_t)(XFS_CNT_BLOCK(mp) + 1))
-#define	XFS_PREALLOC_BLOCKS(mp)		((xfs_agblock_t)(XFS_IBT_BLOCK(mp) + 1))
-
-/*
  * Btree block header size depends on a superblock flag.
  */
 #define XFS_INOBT_BLOCK_LEN(mp) \
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6db1155..98d3524 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -24,17 +24,13 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
-#include "xfs_dinode.h"
 #include "xfs_error.h"
-#include "xfs_filestream.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
 #include "xfs_quota.h"
 #include "xfs_trace.h"
-#include "xfs_fsops.h"
 #include "xfs_icache.h"
 #include "xfs_bmap_util.h"
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 40a5ae3..001aa89 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -27,27 +27,22 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
+#include "xfs_inode.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
 #include "xfs_attr_sf.h"
 #include "xfs_attr.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
 #include "xfs_trans_space.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_inode_item.h"
-#include "xfs_btree.h"
-#include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
+#include "xfs_dinode.h"
 #include "xfs_filestream.h"
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
@@ -55,6 +50,7 @@
 #include "xfs_symlink.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
+#include "xfs_bmap_btree.h"
 
 kmem_zone_t *xfs_inode_zone;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index cce62ce..6667587 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -24,7 +24,6 @@
 /*
  * Kernel only inode definitions
  */
-
 struct xfs_dinode;
 struct xfs_inode;
 struct xfs_buf;
diff --git a/fs/xfs/xfs_inode_buf.c b/fs/xfs/xfs_inode_buf.c
index c0f974b..4fc9f39 100644
--- a/fs/xfs/xfs_inode_buf.c
+++ b/fs/xfs/xfs_inode_buf.c
@@ -24,15 +24,13 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_error.h"
 #include "xfs_cksum.h"
 #include "xfs_icache.h"
-#include "xfs_ialloc.h"
 #include "xfs_trans.h"
+#include "xfs_ialloc.h"
+#include "xfs_dinode.h"
 
 /*
  * Check that none of the inode's in the buffer have a next
diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index b89b58a..22c9837 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -26,25 +26,15 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "xfs_buf_item.h"
 #include "xfs_inode_item.h"
-#include "xfs_btree.h"
-#include "xfs_alloc.h"
-#include "xfs_ialloc.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
-#include "xfs_quota.h"
-#include "xfs_filestream.h"
-#include "xfs_cksum.h"
 #include "xfs_trace.h"
-#include "xfs_icache.h"
+#include "xfs_attr_sf.h"
+#include "xfs_dinode.h"
 
 kmem_zone_t *xfs_ifork_zone;
 
diff --git a/fs/xfs/xfs_inode_fork.h b/fs/xfs/xfs_inode_fork.h
index 28661a0..eb329a1 100644
--- a/fs/xfs/xfs_inode_fork.h
+++ b/fs/xfs/xfs_inode_fork.h
@@ -19,6 +19,7 @@
 #define	__XFS_INODE_FORK_H__
 
 struct xfs_inode_log_item;
+struct xfs_dinode;
 
 /*
  * The following xfs_ext_irec_t struct introduces a second (top) level
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 9f8e85e..7c0d391f 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -17,19 +17,19 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_trans_priv.h"
+#include "xfs_dinode.h"
 
 
 kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ea65a73..4d61340 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -23,28 +23,25 @@
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_alloc.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_ioctl.h"
+#include "xfs_alloc.h"
 #include "xfs_rtalloc.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
-#include "xfs_trans.h"
-#include "xfs_buf_item.h"
 #include "xfs_fsops.h"
 #include "xfs_discard.h"
 #include "xfs_quota.h"
-#include "xfs_inode_item.h"
 #include "xfs_export.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_symlink.h"
+#include "xfs_dinode.h"
+#include "xfs_trans.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 1be3333..e8fb123 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -22,14 +22,13 @@
 #include <asm/uaccess.h>
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_vnode.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index adadf80..22d1cbe 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -24,29 +24,21 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_trans.h"
-#include "xfs_inode_item.h"
-#include "xfs_alloc.h"
-#include "xfs_quota.h"
 #include "xfs_btree.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
-#include "xfs_rtalloc.h"
 #include "xfs_error.h"
-#include "xfs_itable.h"
-#include "xfs_attr.h"
-#include "xfs_buf_item.h"
+#include "xfs_trans.h"
 #include "xfs_trans_space.h"
 #include "xfs_iomap.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_quota.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
+#include "xfs_dinode.h"
 
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 3f2ae19..718b62b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -25,26 +25,20 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_acl.h"
-#include "xfs_alloc.h"
 #include "xfs_quota.h"
-#include "xfs_rtalloc.h"
 #include "xfs_error.h"
-#include "xfs_itable.h"
 #include "xfs_attr.h"
 #include "xfs_trans.h"
-#include "xfs_buf_item.h"
-#include "xfs_inode_item.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_symlink.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_dinode.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 964b1ca..c237ad1 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -18,23 +18,22 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_inum.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_btree.h"
 #include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
-#include "xfs_btree.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_dinode.h"
 
 STATIC int
 xfs_internal_inum(
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5275ad8..e523396 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
@@ -28,12 +29,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
-#include "xfs_buf_item.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
 #include "xfs_log_recover.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trace.h"
 #include "xfs_fsops.h"
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 832ba5d..b6b669d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -27,29 +27,23 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
-#include "xfs_error.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "xfs_inode_item.h"
-#include "xfs_alloc.h"
-#include "xfs_ialloc.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_inode_item.h"
 #include "xfs_extfree_item.h"
 #include "xfs_trans_priv.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
 #include "xfs_quota.h"
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
-
-/* Need all the magic numbers and buffer ops structures from these headers */
-#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_dinode.h"
+#include "xfs_error.h"
 #include "xfs_dir2.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
diff --git a/fs/xfs/xfs_log_rlimit.c b/fs/xfs/xfs_log_rlimit.c
index 3749bc1..2af1a0a 100644
--- a/fs/xfs/xfs_log_rlimit.c
+++ b/fs/xfs/xfs_log_rlimit.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_ag.h"
@@ -25,10 +26,10 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_trans_space.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr_leaf.h"
+#include "xfs_bmap_btree.h"
 
 /*
  * Calculate the maximum length in bytes that would be required for a local
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 83f7810..da88f16 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -27,27 +27,20 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
-#include "xfs_trans.h"
-#include "xfs_trans_priv.h"
-#include "xfs_log.h"
-#include "xfs_dir2.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_btree.h"
+#include "xfs_dir2.h"
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_rtalloc.h"
 #include "xfs_bmap.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_log.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_fsops.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
-#include "xfs_cksum.h"
-#include "xfs_buf_item.h"
 
 
 #ifdef HAVE_PERCPU_SB
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e2f6756..14a4996 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -17,33 +17,28 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
-#include "xfs_shared.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
 #include "xfs_itable.h"
-#include "xfs_alloc.h"
-#include "xfs_rtalloc.h"
 #include "xfs_quota.h"
 #include "xfs_error.h"
 #include "xfs_bmap.h"
-#include "xfs_attr.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_trans.h"
-#include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_cksum.h"
+#include "xfs_dinode.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 7046289..e9be63a 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -22,18 +22,11 @@
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_alloc.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
-#include "xfs_itable.h"
-#include "xfs_bmap.h"
-#include "xfs_rtalloc.h"
 #include "xfs_error.h"
-#include "xfs_attr.h"
 #include "xfs_trans.h"
-#include "xfs_buf_item.h"
 #include "xfs_qm.h"
 
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index ab2326a..437c919 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -27,19 +27,11 @@
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_alloc.h"
-#include "xfs_quota.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "xfs_inode_item.h"
-#include "xfs_itable.h"
-#include "xfs_bmap.h"
-#include "xfs_rtalloc.h"
 #include "xfs_error.h"
-#include "xfs_attr.h"
-#include "xfs_buf_item.h"
+#include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 2dd467b..af33caf 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -22,10 +22,9 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
+#include "xfs_inode.h"
 #include "xfs_quota.h"
 #include "xfs_trans.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_inode.h"
 #include "xfs_qm.h"
 #include <linux/quota.h>
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 23c5ca2..d5da155 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -25,21 +25,18 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
-#include "xfs_rtalloc.h"
-#include "xfs_fsops.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc.h"
 #include "xfs_error.h"
 #include "xfs_trans.h"
-#include "xfs_inode_item.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_buf.h"
 #include "xfs_icache.h"
+#include "xfs_dinode.h"
 
 
 /*
diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index 1b0a642..05b5493 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -21,31 +21,21 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_inum.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
-#include "xfs_dir2.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_btree.h"
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
-#include "xfs_rtalloc.h"
-#include "xfs_bmap.h"
 #include "xfs_error.h"
-#include "xfs_quota.h"
-#include "xfs_fsops.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_trans.h"
-#include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
+#include "xfs_dinode.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ece7cf4..5ee4ceb 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -24,29 +24,18 @@
 #include "xfs_inum.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_alloc.h"
-#include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
-#include "xfs_ialloc.h"
 #include "xfs_bmap.h"
-#include "xfs_rtalloc.h"
+#include "xfs_alloc.h"
 #include "xfs_error.h"
-#include "xfs_itable.h"
 #include "xfs_fsops.h"
-#include "xfs_attr.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
-#include "xfs_trans_priv.h"
-#include "xfs_filestream.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_extfree_item.h"
@@ -55,6 +44,9 @@
 #include "xfs_icache.h"
 #include "xfs_trace.h"
 #include "xfs_icreate_item.h"
+#include "xfs_dinode.h"
+#include "xfs_filestream.h"
+#include "xfs_quota.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 93fc72c..14e58f2 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -28,13 +28,11 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_dir2.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_bmap_util.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
@@ -42,8 +40,8 @@
 #include "xfs_trace.h"
 #include "xfs_symlink.h"
 #include "xfs_trans.h"
-#include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_dinode.h"
 
 /* ----- Kernel only functions below ----- */
 STATIC int
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 889bb42..dee3279 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -25,10 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_da_btree.h"
@@ -49,6 +45,7 @@
 #include "xfs_dquot.h"
 #include "xfs_log_recover.h"
 #include "xfs_inode_item.h"
+#include "xfs_bmap_btree.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8d1595f..c812c5c 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -25,28 +25,14 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_error.h"
-#include "xfs_da_format.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_btree.h"
-#include "xfs_ialloc.h"
-#include "xfs_alloc.h"
 #include "xfs_extent_busy.h"
-#include "xfs_bmap.h"
 #include "xfs_quota.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
-#include "xfs_trans_space.h"
-#include "xfs_qm.h"
-#include "xfs_inode_item.h"
 #include "xfs_log.h"
-#include "xfs_log_priv.h"
-#include "xfs_buf_item.h"
 #include "xfs_trace.h"
+#include "xfs_error.h"
 
 kmem_zone_t	*xfs_trans_zone;
 kmem_zone_t	*xfs_log_item_desc_zone;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9cc5fbe..9b96d35 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -234,6 +234,11 @@ void		xfs_trans_cancel(xfs_trans_t *, int);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
 
+void		xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
+				       enum xfs_blft);
+void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
+					struct xfs_buf *src_bp);
+
 extern kmem_zone_t	*xfs_trans_zone;
 extern kmem_zone_t	*xfs_log_item_desc_zone;
 
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 6b1b993..c035d11 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -18,15 +18,12 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 2025f6e..cd2a10e 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -23,19 +23,12 @@
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_alloc.h"
-#include "xfs_quota.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
-#include "xfs_itable.h"
-#include "xfs_bmap.h"
-#include "xfs_rtalloc.h"
 #include "xfs_error.h"
-#include "xfs_attr.h"
 #include "xfs_trans.h"
-#include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
+#include "xfs_quota.h"
 #include "xfs_qm.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 5d70778..50c3f56 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -18,17 +18,13 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_btree.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index 89de046..d53d9f0 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -26,19 +26,9 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
-#include "xfs_error.h"
-#include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_btree.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_ialloc.h"
-#include "xfs_alloc.h"
-#include "xfs_extent_busy.h"
-#include "xfs_bmap.h"
-#include "xfs_bmap_util.h"
 #include "xfs_quota.h"
 #include "xfs_trans.h"
 #include "xfs_qm.h"
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 2305299..9d47907 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -17,13 +17,13 @@
  */
 
 #include "xfs.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

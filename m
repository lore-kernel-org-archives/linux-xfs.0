Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C49027F4E
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:07:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B504E304032
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:07:30 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0EC5IeibmrxCXfAB for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:07:26 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTpO-0006LR-Ir
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTpO-0002BX-I4
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/16] xfs: create a shared header file for format-related
	information
Date: Mon, 30 Sep 2013 13:06:58 +1000
Message-Id: <1380510433-8353-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510433-8353-1-git-send-email-david@fromorbit.com>
References: <1380510433-8353-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

All of the buffer operations structures are needed to be exported
for xfs_db, so move them all to a common location rather than
spreading them all over the place. They are verifying the on-disk
format, so while xfs_format.h might be a good place, it is not part
of the on disk format.

Hence we need to create a new header file that we centralise these
related definitions. Start by moving the bffer operations
structures, and then also move all the other definitions that have
crept into xfs_log_format.h and xfs_format.h as there was no other
shared header file to put them in.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ag.h             |   4 -
 fs/xfs/xfs_alloc.c          |   3 +-
 fs/xfs/xfs_alloc.h          |   3 -
 fs/xfs/xfs_alloc_btree.h    |   2 -
 fs/xfs/xfs_aops.c           |   4 +-
 fs/xfs/xfs_attr.c           |   1 +
 fs/xfs/xfs_attr_inactive.c  |   1 +
 fs/xfs/xfs_attr_leaf.h      |   2 -
 fs/xfs/xfs_attr_remote.h    |   2 -
 fs/xfs/xfs_bmap.c           |   1 +
 fs/xfs/xfs_bmap_btree.h     |   2 -
 fs/xfs/xfs_bmap_util.c      |   1 +
 fs/xfs/xfs_btree.c          |   2 +-
 fs/xfs/xfs_da_btree.c       |   3 +-
 fs/xfs/xfs_da_btree.h       |   2 -
 fs/xfs/xfs_dquot.c          |   1 +
 fs/xfs/xfs_dquot.h          |   2 -
 fs/xfs/xfs_extent_busy.c    |   3 +-
 fs/xfs/xfs_format.h         |  10 --
 fs/xfs/xfs_fsops.c          |   2 +
 fs/xfs/xfs_ialloc.c         |   3 +-
 fs/xfs/xfs_ialloc.h         |   2 -
 fs/xfs/xfs_ialloc_btree.h   |   2 -
 fs/xfs/xfs_icreate_item.c   |   2 +-
 fs/xfs/xfs_inode.c          |   1 +
 fs/xfs/xfs_inode_buf.c      |   1 +
 fs/xfs/xfs_inode_buf.h      |   3 -
 fs/xfs/xfs_ioctl.c          |   1 +
 fs/xfs/xfs_iomap.c          |   1 +
 fs/xfs/xfs_iops.c           |   1 +
 fs/xfs/xfs_itable.c         |   2 +-
 fs/xfs/xfs_log.c            |   2 +-
 fs/xfs/xfs_log_cil.c        |   2 +-
 fs/xfs/xfs_log_format.h     | 177 --------------------------------
 fs/xfs/xfs_log_recover.c    |   1 +
 fs/xfs/xfs_log_rlimit.c     |   1 +
 fs/xfs/xfs_mount.c          |   1 +
 fs/xfs/xfs_qm.c             |   1 +
 fs/xfs/xfs_qm_syscalls.c    |   1 +
 fs/xfs/xfs_quota.h          |   2 -
 fs/xfs/xfs_rtalloc.c        |   1 +
 fs/xfs/xfs_sb.h             |   3 -
 fs/xfs/xfs_shared.h         | 244 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.c          |   1 +
 fs/xfs/xfs_symlink.c        |   1 +
 fs/xfs/xfs_symlink_remote.c |   1 +
 fs/xfs/xfs_trace.c          |   2 +-
 fs/xfs/xfs_trans.c          |   1 +
 fs/xfs/xfs_trans_buf.c      |   2 +-
 fs/xfs/xfs_trans_dquot.c    |   1 +
 fs/xfs/xfs_trans_extfree.c  |   2 +-
 fs/xfs/xfs_trans_inode.c    |   2 +-
 fs/xfs/xfs_trans_resv.c     |   1 +
 53 files changed, 288 insertions(+), 232 deletions(-)
 create mode 100644 fs/xfs/xfs_shared.h

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 1cb740a..3fc1098 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -128,8 +128,6 @@ typedef struct xfs_agf {
 extern int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
 
-extern const struct xfs_buf_ops xfs_agf_buf_ops;
-
 /*
  * Size of the unlinked inode hash table in the agi.
  */
@@ -191,8 +189,6 @@ typedef struct xfs_agi {
 extern int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 				xfs_agnumber_t agno, struct xfs_buf **bpp);
 
-extern const struct xfs_buf_ops xfs_agi_buf_ops;
-
 /*
  * The third a.g. block contains the a.g. freelist, an array
  * of block pointers to blocks owned by the allocation btree code.
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 5a1393f..2bfca06 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -17,7 +17,8 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index 99d0a61..feacb06 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -231,7 +231,4 @@ xfs_alloc_get_rec(
 	xfs_extlen_t		*len,	/* output: length of extent */
 	int			*stat);	/* output: success/failure */
 
-extern const struct xfs_buf_ops xfs_agf_buf_ops;
-extern const struct xfs_buf_ops xfs_agfl_buf_ops;
-
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/xfs_alloc_btree.h b/fs/xfs/xfs_alloc_btree.h
index e3a3f74..72676c3 100644
--- a/fs/xfs/xfs_alloc_btree.h
+++ b/fs/xfs/xfs_alloc_btree.h
@@ -95,6 +95,4 @@ extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		xfs_agnumber_t, xfs_btnum_t);
 extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
 
-extern const struct xfs_buf_ops xfs_allocbt_buf_ops;
-
 #endif	/* __XFS_ALLOC_BTREE_H__ */
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e51e581..b5db88a 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -16,9 +16,11 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
-#include "xfs_log.h"
+#include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
+#include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index ddcf226..21af043 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index bb24b07..e90a876 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -19,6 +19,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_attr_leaf.h b/fs/xfs/xfs_attr_leaf.h
index c102213..da34e64 100644
--- a/fs/xfs/xfs_attr_leaf.h
+++ b/fs/xfs/xfs_attr_leaf.h
@@ -336,6 +336,4 @@ void	xfs_attr3_leaf_hdr_from_disk(struct xfs_attr3_icleaf_hdr *to,
 void	xfs_attr3_leaf_hdr_to_disk(struct xfs_attr_leafblock *to,
 				   struct xfs_attr3_icleaf_hdr *from);
 
-extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
-
 #endif	/* __XFS_ATTR_LEAF_H__ */
diff --git a/fs/xfs/xfs_attr_remote.h b/fs/xfs/xfs_attr_remote.h
index 92a8fd7..b3e1e1b 100644
--- a/fs/xfs/xfs_attr_remote.h
+++ b/fs/xfs/xfs_attr_remote.h
@@ -45,8 +45,6 @@ struct xfs_attr3_rmt_hdr {
 	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
 			sizeof(struct xfs_attr3_rmt_hdr) : 0))
 
-extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
-
 int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index f47e65c..aee6a00 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
index e367461..e2b0768 100644
--- a/fs/xfs/xfs_bmap_btree.h
+++ b/fs/xfs/xfs_bmap_btree.h
@@ -243,6 +243,4 @@ extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
 
-extern const struct xfs_buf_ops xfs_bmbt_buf_ops;
-
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 97f952c..a6b1c08 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -19,6 +19,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 5690e10..1a297e2 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -17,7 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 20bf8e8..ac51abe 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -18,7 +18,8 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index b1f2679..a762cfa 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -309,8 +309,6 @@ int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			 xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			 struct xfs_buf **bpp, int which_fork);
 
-extern const struct xfs_buf_ops xfs_da3_node_buf_ops;
-
 /*
  * Utility routines.
  */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 1ee776d..8b1d2c0 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 55abbca..d22ed00 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -172,6 +172,4 @@ static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 	return dqp;
 }
 
-extern const struct xfs_buf_ops xfs_dquot_buf_ops;
-
 #endif /* __XFS_DQUOT_H__ */
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index e43708e..74828a7 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -19,7 +19,8 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_format.h b/fs/xfs/xfs_format.h
index 35c08ff..a790428 100644
--- a/fs/xfs/xfs_format.h
+++ b/fs/xfs/xfs_format.h
@@ -156,14 +156,4 @@ struct xfs_dsymlink_hdr {
 	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
 			sizeof(struct xfs_dsymlink_hdr) : 0))
 
-int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
-int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
-			uint32_t size, struct xfs_buf *bp);
-bool xfs_symlink_hdr_ok(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
-			uint32_t size, struct xfs_buf *bp);
-void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
-				 struct xfs_inode *ip, struct xfs_ifork *ifp);
-
-extern const struct xfs_buf_ops xfs_symlink_buf_ops;
-
 #endif /* __XFS_FORMAT_H__ */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index e64ee52..d9cfe55 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -18,6 +18,8 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
+#include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index ccf2fb1..8530cab 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -17,7 +17,8 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index 68c0732..1557798 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -158,6 +158,4 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
 			  xfs_agnumber_t agno, xfs_agblock_t agbno,
 			  xfs_agblock_t length, unsigned int gen);
 
-extern const struct xfs_buf_ops xfs_agi_buf_ops;
-
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_ialloc_btree.h b/fs/xfs/xfs_ialloc_btree.h
index 3ac36b76..cfbfe46 100644
--- a/fs/xfs/xfs_ialloc_btree.h
+++ b/fs/xfs/xfs_ialloc_btree.h
@@ -110,6 +110,4 @@ extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
-extern const struct xfs_buf_ops xfs_inobt_buf_ops;
-
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 5a5a593..df8baf3 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -17,7 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7a460d8..38db1578 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -20,6 +20,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_inode_buf.c b/fs/xfs/xfs_inode_buf.c
index 63382d3..65fa56e 100644
--- a/fs/xfs/xfs_inode_buf.c
+++ b/fs/xfs/xfs_inode_buf.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_inode_buf.h b/fs/xfs/xfs_inode_buf.h
index abba0ae..9308c47 100644
--- a/fs/xfs/xfs_inode_buf.h
+++ b/fs/xfs/xfs_inode_buf.h
@@ -47,7 +47,4 @@ void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #define	xfs_inobp_check(mp, bp)
 #endif /* DEBUG */
 
-extern const struct xfs_buf_ops xfs_inode_buf_ops;
-extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
-
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 668e8f4..bde3847 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 8d4d49b..41ef15e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 6f6d270..ff54ea9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_acl.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 084b3e1..4f50e63 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -17,7 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a2dea108..7506e6d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -17,7 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index cfe9797..3a9c70a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -17,7 +17,7 @@
 
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
index ca7e28a..f0969c7 100644
--- a/fs/xfs/xfs_log_format.h
+++ b/fs/xfs/xfs_log_format.h
@@ -234,178 +234,6 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_ICREATE,	"XFS_LI_ICREATE" }
 
 /*
- * Transaction types.  Used to distinguish types of buffers.
- */
-#define XFS_TRANS_SETATTR_NOT_SIZE	1
-#define XFS_TRANS_SETATTR_SIZE		2
-#define XFS_TRANS_INACTIVE		3
-#define XFS_TRANS_CREATE		4
-#define XFS_TRANS_CREATE_TRUNC		5
-#define XFS_TRANS_TRUNCATE_FILE		6
-#define XFS_TRANS_REMOVE		7
-#define XFS_TRANS_LINK			8
-#define XFS_TRANS_RENAME		9
-#define XFS_TRANS_MKDIR			10
-#define XFS_TRANS_RMDIR			11
-#define XFS_TRANS_SYMLINK		12
-#define XFS_TRANS_SET_DMATTRS		13
-#define XFS_TRANS_GROWFS		14
-#define XFS_TRANS_STRAT_WRITE		15
-#define XFS_TRANS_DIOSTRAT		16
-/* 17 was XFS_TRANS_WRITE_SYNC */
-#define	XFS_TRANS_WRITEID		18
-#define	XFS_TRANS_ADDAFORK		19
-#define	XFS_TRANS_ATTRINVAL		20
-#define	XFS_TRANS_ATRUNCATE		21
-#define	XFS_TRANS_ATTR_SET		22
-#define	XFS_TRANS_ATTR_RM		23
-#define	XFS_TRANS_ATTR_FLAG		24
-#define	XFS_TRANS_CLEAR_AGI_BUCKET	25
-#define XFS_TRANS_QM_SBCHANGE		26
-/*
- * Dummy entries since we use the transaction type to index into the
- * trans_type[] in xlog_recover_print_trans_head()
- */
-#define XFS_TRANS_DUMMY1		27
-#define XFS_TRANS_DUMMY2		28
-#define XFS_TRANS_QM_QUOTAOFF		29
-#define XFS_TRANS_QM_DQALLOC		30
-#define XFS_TRANS_QM_SETQLIM		31
-#define XFS_TRANS_QM_DQCLUSTER		32
-#define XFS_TRANS_QM_QINOCREATE		33
-#define XFS_TRANS_QM_QUOTAOFF_END	34
-#define XFS_TRANS_SB_UNIT		35
-#define XFS_TRANS_FSYNC_TS		36
-#define	XFS_TRANS_GROWFSRT_ALLOC	37
-#define	XFS_TRANS_GROWFSRT_ZERO		38
-#define	XFS_TRANS_GROWFSRT_FREE		39
-#define	XFS_TRANS_SWAPEXT		40
-#define	XFS_TRANS_SB_COUNT		41
-#define	XFS_TRANS_CHECKPOINT		42
-#define	XFS_TRANS_ICREATE		43
-#define	XFS_TRANS_TYPE_MAX		43
-/* new transaction types need to be reflected in xfs_logprint(8) */
-
-#define XFS_TRANS_TYPES \
-	{ XFS_TRANS_SETATTR_NOT_SIZE,	"SETATTR_NOT_SIZE" }, \
-	{ XFS_TRANS_SETATTR_SIZE,	"SETATTR_SIZE" }, \
-	{ XFS_TRANS_INACTIVE,		"INACTIVE" }, \
-	{ XFS_TRANS_CREATE,		"CREATE" }, \
-	{ XFS_TRANS_CREATE_TRUNC,	"CREATE_TRUNC" }, \
-	{ XFS_TRANS_TRUNCATE_FILE,	"TRUNCATE_FILE" }, \
-	{ XFS_TRANS_REMOVE,		"REMOVE" }, \
-	{ XFS_TRANS_LINK,		"LINK" }, \
-	{ XFS_TRANS_RENAME,		"RENAME" }, \
-	{ XFS_TRANS_MKDIR,		"MKDIR" }, \
-	{ XFS_TRANS_RMDIR,		"RMDIR" }, \
-	{ XFS_TRANS_SYMLINK,		"SYMLINK" }, \
-	{ XFS_TRANS_SET_DMATTRS,	"SET_DMATTRS" }, \
-	{ XFS_TRANS_GROWFS,		"GROWFS" }, \
-	{ XFS_TRANS_STRAT_WRITE,	"STRAT_WRITE" }, \
-	{ XFS_TRANS_DIOSTRAT,		"DIOSTRAT" }, \
-	{ XFS_TRANS_WRITEID,		"WRITEID" }, \
-	{ XFS_TRANS_ADDAFORK,		"ADDAFORK" }, \
-	{ XFS_TRANS_ATTRINVAL,		"ATTRINVAL" }, \
-	{ XFS_TRANS_ATRUNCATE,		"ATRUNCATE" }, \
-	{ XFS_TRANS_ATTR_SET,		"ATTR_SET" }, \
-	{ XFS_TRANS_ATTR_RM,		"ATTR_RM" }, \
-	{ XFS_TRANS_ATTR_FLAG,		"ATTR_FLAG" }, \
-	{ XFS_TRANS_CLEAR_AGI_BUCKET,	"CLEAR_AGI_BUCKET" }, \
-	{ XFS_TRANS_QM_SBCHANGE,	"QM_SBCHANGE" }, \
-	{ XFS_TRANS_QM_QUOTAOFF,	"QM_QUOTAOFF" }, \
-	{ XFS_TRANS_QM_DQALLOC,		"QM_DQALLOC" }, \
-	{ XFS_TRANS_QM_SETQLIM,		"QM_SETQLIM" }, \
-	{ XFS_TRANS_QM_DQCLUSTER,	"QM_DQCLUSTER" }, \
-	{ XFS_TRANS_QM_QINOCREATE,	"QM_QINOCREATE" }, \
-	{ XFS_TRANS_QM_QUOTAOFF_END,	"QM_QOFF_END" }, \
-	{ XFS_TRANS_SB_UNIT,		"SB_UNIT" }, \
-	{ XFS_TRANS_FSYNC_TS,		"FSYNC_TS" }, \
-	{ XFS_TRANS_GROWFSRT_ALLOC,	"GROWFSRT_ALLOC" }, \
-	{ XFS_TRANS_GROWFSRT_ZERO,	"GROWFSRT_ZERO" }, \
-	{ XFS_TRANS_GROWFSRT_FREE,	"GROWFSRT_FREE" }, \
-	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
-	{ XFS_TRANS_SB_COUNT,		"SB_COUNT" }, \
-	{ XFS_TRANS_CHECKPOINT,		"CHECKPOINT" }, \
-	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
-	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
-	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
-
-/*
- * This structure is used to track log items associated with
- * a transaction.  It points to the log item and keeps some
- * flags to track the state of the log item.  It also tracks
- * the amount of space needed to log the item it describes
- * once we get to commit processing (see xfs_trans_commit()).
- */
-struct xfs_log_item_desc {
-	struct xfs_log_item	*lid_item;
-	struct list_head	lid_trans;
-	unsigned char		lid_flags;
-};
-
-#define XFS_LID_DIRTY		0x1
-
-/*
- * Values for t_flags.
- */
-#define	XFS_TRANS_DIRTY		0x01	/* something needs to be logged */
-#define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
-#define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
-#define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
-#define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
-#define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
-#define XFS_TRANS_FREEZE_PROT	0x40	/* Transaction has elevated writer
-					   count in superblock */
-
-/*
- * Values for call flags parameter.
- */
-#define	XFS_TRANS_RELEASE_LOG_RES	0x4
-#define	XFS_TRANS_ABORT			0x8
-
-/*
- * Field values for xfs_trans_mod_sb.
- */
-#define	XFS_TRANS_SB_ICOUNT		0x00000001
-#define	XFS_TRANS_SB_IFREE		0x00000002
-#define	XFS_TRANS_SB_FDBLOCKS		0x00000004
-#define	XFS_TRANS_SB_RES_FDBLOCKS	0x00000008
-#define	XFS_TRANS_SB_FREXTENTS		0x00000010
-#define	XFS_TRANS_SB_RES_FREXTENTS	0x00000020
-#define	XFS_TRANS_SB_DBLOCKS		0x00000040
-#define	XFS_TRANS_SB_AGCOUNT		0x00000080
-#define	XFS_TRANS_SB_IMAXPCT		0x00000100
-#define	XFS_TRANS_SB_REXTSIZE		0x00000200
-#define	XFS_TRANS_SB_RBMBLOCKS		0x00000400
-#define	XFS_TRANS_SB_RBLOCKS		0x00000800
-#define	XFS_TRANS_SB_REXTENTS		0x00001000
-#define	XFS_TRANS_SB_REXTSLOG		0x00002000
-
-/*
- * Here we centralize the specification of XFS meta-data buffer
- * reference count values.  This determine how hard the buffer
- * cache tries to hold onto the buffer.
- */
-#define	XFS_AGF_REF		4
-#define	XFS_AGI_REF		4
-#define	XFS_AGFL_REF		3
-#define	XFS_INO_BTREE_REF	3
-#define	XFS_ALLOC_BTREE_REF	2
-#define	XFS_BMAP_BTREE_REF	2
-#define	XFS_DIR_BTREE_REF	2
-#define	XFS_INO_REF		2
-#define	XFS_ATTR_BTREE_REF	1
-#define	XFS_DQUOT_REF		1
-
-/*
- * Flags for xfs_trans_ichgtime().
- */
-#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
-#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
-#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
-
-
-/*
  * Inode Log Item Format definitions.
  *
  * This is the structure used to lay out an inode log item in the
@@ -797,7 +625,6 @@ typedef struct xfs_qoff_logformat {
 	char			qf_pad[12];	/* padding for future */
 } xfs_qoff_logformat_t;
 
-
 /*
  * Disk quotas status in m_qflags, and also sb_qflags. 16 bits.
  */
@@ -849,8 +676,4 @@ struct xfs_icreate_log {
 	__be32		icl_gen;	/* inode generation number to use */
 };
 
-int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
-int	xfs_log_calc_minimum_size(struct xfs_mount *);
-
-
 #endif /* __XFS_LOG_FORMAT_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index cc17987..908478b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
diff --git a/fs/xfs/xfs_log_rlimit.c b/fs/xfs/xfs_log_rlimit.c
index bbcec0b..0961310 100644
--- a/fs/xfs/xfs_log_rlimit.c
+++ b/fs/xfs/xfs_log_rlimit.c
@@ -17,6 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5dcc680..9515f96 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3e6c2e6..dc2d4f7 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 8174aad..dcf345a 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -21,6 +21,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index e7d84d2..84661d4 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -154,6 +154,4 @@ extern int xfs_qm_dqcheck(struct xfs_mount *, xfs_disk_dquot_t *,
 				xfs_dqid_t, uint, uint, char *);
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
 
-extern const struct xfs_buf_ops xfs_dquot_buf_ops;
-
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6f9e63c..6f63de3 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 6835b44..35061d4 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -699,7 +699,4 @@ extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
 extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
 
-extern const struct xfs_buf_ops xfs_sb_buf_ops;
-extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
-
 #endif	/* __XFS_SB_H__ */
diff --git a/fs/xfs/xfs_shared.h b/fs/xfs/xfs_shared.h
new file mode 100644
index 0000000..63c94b1
--- /dev/null
+++ b/fs/xfs/xfs_shared.h
@@ -0,0 +1,244 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2013 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_SHARED_H__
+#define __XFS_SHARED_H__
+
+/*
+ * Definitions shared between kernel and userspace that don't fit into any other
+ * header file that is shared with userspace.
+ */
+struct xfs_ifork;
+struct xfs_buf;
+struct xfs_buf_ops;
+struct xfs_mount;
+struct xfs_trans;
+struct xfs_inode;
+
+/*
+ * Buffer verifier operations are widely used, including userspace tools
+ */
+extern const struct xfs_buf_ops xfs_agf_buf_ops;
+extern const struct xfs_buf_ops xfs_agi_buf_ops;
+extern const struct xfs_buf_ops xfs_agf_buf_ops;
+extern const struct xfs_buf_ops xfs_agfl_buf_ops;
+extern const struct xfs_buf_ops xfs_allocbt_buf_ops;
+extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
+extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
+extern const struct xfs_buf_ops xfs_bmbt_buf_ops;
+extern const struct xfs_buf_ops xfs_da3_node_buf_ops;
+extern const struct xfs_buf_ops xfs_dquot_buf_ops;
+extern const struct xfs_buf_ops xfs_symlink_buf_ops;
+extern const struct xfs_buf_ops xfs_agi_buf_ops;
+extern const struct xfs_buf_ops xfs_inobt_buf_ops;
+extern const struct xfs_buf_ops xfs_inode_buf_ops;
+extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
+extern const struct xfs_buf_ops xfs_dquot_buf_ops;
+extern const struct xfs_buf_ops xfs_sb_buf_ops;
+extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
+extern const struct xfs_buf_ops xfs_symlink_buf_ops;
+
+/*
+ * Transaction types.  Used to distinguish types of buffers. These never reach
+ * the log.
+ */
+#define XFS_TRANS_SETATTR_NOT_SIZE	1
+#define XFS_TRANS_SETATTR_SIZE		2
+#define XFS_TRANS_INACTIVE		3
+#define XFS_TRANS_CREATE		4
+#define XFS_TRANS_CREATE_TRUNC		5
+#define XFS_TRANS_TRUNCATE_FILE		6
+#define XFS_TRANS_REMOVE		7
+#define XFS_TRANS_LINK			8
+#define XFS_TRANS_RENAME		9
+#define XFS_TRANS_MKDIR			10
+#define XFS_TRANS_RMDIR			11
+#define XFS_TRANS_SYMLINK		12
+#define XFS_TRANS_SET_DMATTRS		13
+#define XFS_TRANS_GROWFS		14
+#define XFS_TRANS_STRAT_WRITE		15
+#define XFS_TRANS_DIOSTRAT		16
+/* 17 was XFS_TRANS_WRITE_SYNC */
+#define	XFS_TRANS_WRITEID		18
+#define	XFS_TRANS_ADDAFORK		19
+#define	XFS_TRANS_ATTRINVAL		20
+#define	XFS_TRANS_ATRUNCATE		21
+#define	XFS_TRANS_ATTR_SET		22
+#define	XFS_TRANS_ATTR_RM		23
+#define	XFS_TRANS_ATTR_FLAG		24
+#define	XFS_TRANS_CLEAR_AGI_BUCKET	25
+#define XFS_TRANS_QM_SBCHANGE		26
+/*
+ * Dummy entries since we use the transaction type to index into the
+ * trans_type[] in xlog_recover_print_trans_head()
+ */
+#define XFS_TRANS_DUMMY1		27
+#define XFS_TRANS_DUMMY2		28
+#define XFS_TRANS_QM_QUOTAOFF		29
+#define XFS_TRANS_QM_DQALLOC		30
+#define XFS_TRANS_QM_SETQLIM		31
+#define XFS_TRANS_QM_DQCLUSTER		32
+#define XFS_TRANS_QM_QINOCREATE		33
+#define XFS_TRANS_QM_QUOTAOFF_END	34
+#define XFS_TRANS_SB_UNIT		35
+#define XFS_TRANS_FSYNC_TS		36
+#define	XFS_TRANS_GROWFSRT_ALLOC	37
+#define	XFS_TRANS_GROWFSRT_ZERO		38
+#define	XFS_TRANS_GROWFSRT_FREE		39
+#define	XFS_TRANS_SWAPEXT		40
+#define	XFS_TRANS_SB_COUNT		41
+#define	XFS_TRANS_CHECKPOINT		42
+#define	XFS_TRANS_ICREATE		43
+#define	XFS_TRANS_TYPE_MAX		43
+/* new transaction types need to be reflected in xfs_logprint(8) */
+
+#define XFS_TRANS_TYPES \
+	{ XFS_TRANS_SETATTR_NOT_SIZE,	"SETATTR_NOT_SIZE" }, \
+	{ XFS_TRANS_SETATTR_SIZE,	"SETATTR_SIZE" }, \
+	{ XFS_TRANS_INACTIVE,		"INACTIVE" }, \
+	{ XFS_TRANS_CREATE,		"CREATE" }, \
+	{ XFS_TRANS_CREATE_TRUNC,	"CREATE_TRUNC" }, \
+	{ XFS_TRANS_TRUNCATE_FILE,	"TRUNCATE_FILE" }, \
+	{ XFS_TRANS_REMOVE,		"REMOVE" }, \
+	{ XFS_TRANS_LINK,		"LINK" }, \
+	{ XFS_TRANS_RENAME,		"RENAME" }, \
+	{ XFS_TRANS_MKDIR,		"MKDIR" }, \
+	{ XFS_TRANS_RMDIR,		"RMDIR" }, \
+	{ XFS_TRANS_SYMLINK,		"SYMLINK" }, \
+	{ XFS_TRANS_SET_DMATTRS,	"SET_DMATTRS" }, \
+	{ XFS_TRANS_GROWFS,		"GROWFS" }, \
+	{ XFS_TRANS_STRAT_WRITE,	"STRAT_WRITE" }, \
+	{ XFS_TRANS_DIOSTRAT,		"DIOSTRAT" }, \
+	{ XFS_TRANS_WRITEID,		"WRITEID" }, \
+	{ XFS_TRANS_ADDAFORK,		"ADDAFORK" }, \
+	{ XFS_TRANS_ATTRINVAL,		"ATTRINVAL" }, \
+	{ XFS_TRANS_ATRUNCATE,		"ATRUNCATE" }, \
+	{ XFS_TRANS_ATTR_SET,		"ATTR_SET" }, \
+	{ XFS_TRANS_ATTR_RM,		"ATTR_RM" }, \
+	{ XFS_TRANS_ATTR_FLAG,		"ATTR_FLAG" }, \
+	{ XFS_TRANS_CLEAR_AGI_BUCKET,	"CLEAR_AGI_BUCKET" }, \
+	{ XFS_TRANS_QM_SBCHANGE,	"QM_SBCHANGE" }, \
+	{ XFS_TRANS_QM_QUOTAOFF,	"QM_QUOTAOFF" }, \
+	{ XFS_TRANS_QM_DQALLOC,		"QM_DQALLOC" }, \
+	{ XFS_TRANS_QM_SETQLIM,		"QM_SETQLIM" }, \
+	{ XFS_TRANS_QM_DQCLUSTER,	"QM_DQCLUSTER" }, \
+	{ XFS_TRANS_QM_QINOCREATE,	"QM_QINOCREATE" }, \
+	{ XFS_TRANS_QM_QUOTAOFF_END,	"QM_QOFF_END" }, \
+	{ XFS_TRANS_SB_UNIT,		"SB_UNIT" }, \
+	{ XFS_TRANS_FSYNC_TS,		"FSYNC_TS" }, \
+	{ XFS_TRANS_GROWFSRT_ALLOC,	"GROWFSRT_ALLOC" }, \
+	{ XFS_TRANS_GROWFSRT_ZERO,	"GROWFSRT_ZERO" }, \
+	{ XFS_TRANS_GROWFSRT_FREE,	"GROWFSRT_FREE" }, \
+	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
+	{ XFS_TRANS_SB_COUNT,		"SB_COUNT" }, \
+	{ XFS_TRANS_CHECKPOINT,		"CHECKPOINT" }, \
+	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
+	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
+	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
+
+/*
+ * This structure is used to track log items associated with
+ * a transaction.  It points to the log item and keeps some
+ * flags to track the state of the log item.  It also tracks
+ * the amount of space needed to log the item it describes
+ * once we get to commit processing (see xfs_trans_commit()).
+ */
+struct xfs_log_item_desc {
+	struct xfs_log_item	*lid_item;
+	struct list_head	lid_trans;
+	unsigned char		lid_flags;
+};
+
+#define XFS_LID_DIRTY		0x1
+
+/* log size calculation functions */
+int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
+int	xfs_log_calc_minimum_size(struct xfs_mount *);
+
+
+/*
+ * Values for t_flags.
+ */
+#define	XFS_TRANS_DIRTY		0x01	/* something needs to be logged */
+#define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
+#define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
+#define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
+#define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
+#define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
+#define XFS_TRANS_FREEZE_PROT	0x40	/* Transaction has elevated writer
+					   count in superblock */
+/*
+ * Values for call flags parameter.
+ */
+#define	XFS_TRANS_RELEASE_LOG_RES	0x4
+#define	XFS_TRANS_ABORT			0x8
+
+/*
+ * Field values for xfs_trans_mod_sb.
+ */
+#define	XFS_TRANS_SB_ICOUNT		0x00000001
+#define	XFS_TRANS_SB_IFREE		0x00000002
+#define	XFS_TRANS_SB_FDBLOCKS		0x00000004
+#define	XFS_TRANS_SB_RES_FDBLOCKS	0x00000008
+#define	XFS_TRANS_SB_FREXTENTS		0x00000010
+#define	XFS_TRANS_SB_RES_FREXTENTS	0x00000020
+#define	XFS_TRANS_SB_DBLOCKS		0x00000040
+#define	XFS_TRANS_SB_AGCOUNT		0x00000080
+#define	XFS_TRANS_SB_IMAXPCT		0x00000100
+#define	XFS_TRANS_SB_REXTSIZE		0x00000200
+#define	XFS_TRANS_SB_RBMBLOCKS		0x00000400
+#define	XFS_TRANS_SB_RBLOCKS		0x00000800
+#define	XFS_TRANS_SB_REXTENTS		0x00001000
+#define	XFS_TRANS_SB_REXTSLOG		0x00002000
+
+/*
+ * Here we centralize the specification of XFS meta-data buffer reference count
+ * values.  This determine how hard the buffer cache tries to hold onto the
+ * buffer.
+ */
+#define	XFS_AGF_REF		4
+#define	XFS_AGI_REF		4
+#define	XFS_AGFL_REF		3
+#define	XFS_INO_BTREE_REF	3
+#define	XFS_ALLOC_BTREE_REF	2
+#define	XFS_BMAP_BTREE_REF	2
+#define	XFS_DIR_BTREE_REF	2
+#define	XFS_INO_REF		2
+#define	XFS_ATTR_BTREE_REF	1
+#define	XFS_DQUOT_REF		1
+
+/*
+ * Flags for xfs_trans_ichgtime().
+ */
+#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
+#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
+#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
+
+
+/*
+ * Symlink decoding/encoding functions
+ */
+int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
+int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
+			uint32_t size, struct xfs_buf *bp);
+bool xfs_symlink_hdr_ok(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
+			uint32_t size, struct xfs_buf *bp);
+void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
+				 struct xfs_inode *ip, struct xfs_ifork *ifp);
+
+#endif /* __XFS_SHARED_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1b1e4df..45befbe 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -18,6 +18,7 @@
 
 #include "xfs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index f622a97..8df7144 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -19,6 +19,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_symlink_remote.c b/fs/xfs/xfs_symlink_remote.c
index 01c85e3..4251cd8 100644
--- a/fs/xfs/xfs_symlink_remote.c
+++ b/fs/xfs/xfs_symlink_remote.c
@@ -19,6 +19,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 5d7b3e4..2970539 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -17,8 +17,8 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 5411e01..3693ce2 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -19,6 +19,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 8c75b8f..0167a65 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -17,7 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 54ee3c5..4d630d2 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index 8d71b16..3bfb98b 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -17,7 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index e6601c1..9ffa83f 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -17,7 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index a65a3cc..b5d952d 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -19,6 +19,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_log.h"
 #include "xfs_trans_resv.h"
 #include "xfs_trans.h"
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

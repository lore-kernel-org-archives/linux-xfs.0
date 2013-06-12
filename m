Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EFCFD7F90
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:23:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C7D288F8065
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:23:35 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Oxo8A6HUbueQd0NW for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:23:33 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiDD-00017Q-SU
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:23:31 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiD3-00066n-OV
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:23:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 23/27] xfs: sync minor header differences needed by userspace.
Date: Wed, 12 Jun 2013 20:22:43 +1000
Message-Id: <1371032567-21772-24-git-send-email-david@fromorbit.com>
In-Reply-To: <1371032567-21772-1-git-send-email-david@fromorbit.com>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Little things like exported functions, __KERNEL__ protections, and
so on that ensure user and kernel shared headers are identical.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr.c          |    1 +
 fs/xfs/xfs_attr_inactive.c |    1 +
 fs/xfs/xfs_attr_leaf.c     |    1 +
 fs/xfs/xfs_attr_leaf.h     |    2 ++
 fs/xfs/xfs_attr_remote.c   |    1 +
 fs/xfs/xfs_bmap.h          |    2 ++
 fs/xfs/xfs_btree.h         |    2 --
 fs/xfs/xfs_dir2_format.h   |    3 +++
 fs/xfs/xfs_fs.h            |   17 +++++++++++++++++
 fs/xfs/xfs_icreate_item.h  |    4 ++++
 fs/xfs/xfs_sb.h            |    7 +++++++
 fs/xfs/xfs_symlink.h       |    3 ++-
 fs/xfs/xfs_trans.h         |    8 +++-----
 fs/xfs/xfs_trans_priv.h    |    3 +++
 fs/xfs/xfs_types.h         |    3 ++-
 15 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 0c9bb2e..f61d2bb 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -21,6 +21,7 @@
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 0d344ed..a19439b 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -22,6 +22,7 @@
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 791ade2..a7fdd0d 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -22,6 +22,7 @@
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_attr_leaf.h b/fs/xfs/xfs_attr_leaf.h
index 444a770..c102213 100644
--- a/fs/xfs/xfs_attr_leaf.h
+++ b/fs/xfs/xfs_attr_leaf.h
@@ -333,6 +333,8 @@ int	xfs_attr3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			struct xfs_buf **bpp);
 void	xfs_attr3_leaf_hdr_from_disk(struct xfs_attr3_icleaf_hdr *to,
 				     struct xfs_attr_leafblock *from);
+void	xfs_attr3_leaf_hdr_to_disk(struct xfs_attr_leafblock *to,
+				   struct xfs_attr3_icleaf_hdr *from);
 
 extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
 
diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index ef6b0c1..39a59ea 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -22,6 +22,7 @@
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index cbcaf00..31b7c0e 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -136,9 +136,11 @@ typedef struct xfs_bmalloca {
 	char			conv;	/* overwriting unwritten extents */
 	char			stack_switch;
 	int			flags;
+#ifdef __KERNEL__
 	struct completion	*done;
 	struct work_struct	work;
 	int			result;
+#endif /* __KERNEL__ */
 } xfs_bmalloca_t;
 
 /*
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index 55e3c7c..c8473c7 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
@@ -88,13 +88,11 @@ struct xfs_btree_block {
 #define XFS_BTREE_SBLOCK_CRC_LEN	(XFS_BTREE_SBLOCK_LEN + 40)
 #define XFS_BTREE_LBLOCK_CRC_LEN	(XFS_BTREE_LBLOCK_LEN + 48)
 
-
 #define XFS_BTREE_SBLOCK_CRC_OFF \
 	offsetof(struct xfs_btree_block, bb_u.s.bb_crc)
 #define XFS_BTREE_LBLOCK_CRC_OFF \
 	offsetof(struct xfs_btree_block, bb_u.l.bb_crc)
 
-
 /*
  * Generic key, ptr and record wrapper structures.
  *
diff --git a/fs/xfs/xfs_dir2_format.h b/fs/xfs/xfs_dir2_format.h
index b125a8b..d771219 100644
--- a/fs/xfs/xfs_dir2_format.h
+++ b/fs/xfs/xfs_dir2_format.h
@@ -495,6 +495,9 @@ struct xfs_dir3_leaf {
 
 #define XFS_DIR3_LEAF_CRC_OFF  offsetof(struct xfs_dir3_leaf_hdr, info.crc)
 
+extern void xfs_dir3_leaf_hdr_from_disk(struct xfs_dir3_icleaf_hdr *to,
+					struct xfs_dir2_leaf *from);
+
 static inline int
 xfs_dir3_leaf_hdr_size(struct xfs_dir2_leaf *lp)
 {
diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index d046955..68c2e18 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -311,6 +311,17 @@ typedef struct xfs_bstat {
 } xfs_bstat_t;
 
 /*
+ * Project quota id helpers (previously projid was 16bit only
+ * and using two 16bit values to hold new 32bit projid was choosen
+ * to retain compatibility with "old" filesystems).
+ */
+static inline __uint32_t
+bstat_get_projid(struct xfs_bstat *bs)
+{
+	return (__uint32_t)bs->bs_projid_hi << 16 | bs->bs_projid_lo;
+}
+
+/*
  * The user-level BulkStat Request interface structure.
  */
 typedef struct xfs_fsop_bulkreq {
@@ -511,8 +522,14 @@ typedef struct xfs_handle {
 #define XFS_IOC_ERROR_INJECTION	     _IOW ('X', 116, struct xfs_error_injection)
 #define XFS_IOC_ERROR_CLEARALL	     _IOW ('X', 117, struct xfs_error_injection)
 /*	XFS_IOC_ATTRCTL_BY_HANDLE -- deprecated 118	 */
+
 /*	XFS_IOC_FREEZE		  -- FIFREEZE   119	 */
 /*	XFS_IOC_THAW		  -- FITHAW     120	 */
+#ifndef FIFREEZE
+#define XFS_IOC_FREEZE		     _IOWR('X', 119, int)
+#define XFS_IOC_THAW		     _IOWR('X', 120, int)
+#endif
+
 #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
diff --git a/fs/xfs/xfs_icreate_item.h b/fs/xfs/xfs_icreate_item.h
index 88ba8aa..79df981 100644
--- a/fs/xfs/xfs_icreate_item.h
+++ b/fs/xfs/xfs_icreate_item.h
@@ -36,6 +36,8 @@ struct xfs_icreate_log {
 	__be32		icl_gen;	/* inode generation number to use */
 };
 
+#ifdef __KERNEL__
+
 /* in memory log item structure */
 struct xfs_icreate_item {
 	struct xfs_log_item	ic_item;
@@ -49,4 +51,6 @@ void xfs_icreate_log(struct xfs_trans *tp, xfs_agnumber_t agno,
 			unsigned int inode_size, xfs_agblock_t length,
 			unsigned int generation);
 
+#endif /* __KERNEL__ */
+
 #endif	/* XFS_ICREATE_ITEM_H */
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 25d19d0..8f78df1 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -555,6 +555,13 @@ static inline int xfs_sb_version_hasprojid32bit(xfs_sb_t *sbp)
 		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT));
 }
 
+static inline void xfs_sb_version_addprojid32bit(xfs_sb_t *sbp)
+{
+	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
+	sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
+	sbp->sb_bad_features2 |= XFS_SB_VERSION2_PROJID32BIT;
+}
+
 static inline int xfs_sb_version_hascrc(xfs_sb_t *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
index b39398d..4818edf 100644
--- a/fs/xfs/xfs_symlink.h
+++ b/fs/xfs/xfs_symlink.h
@@ -49,7 +49,8 @@ struct xfs_dsymlink_hdr {
 			sizeof(struct xfs_dsymlink_hdr) : 0))
 
 int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
-
+bool xfs_symlink_hdr_ok(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
+			uint32_t size, struct xfs_buf *bp);
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 60427aa..2d6b5e8 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -57,7 +57,8 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_INODE,		"XFS_LI_INODE" }, \
 	{ XFS_LI_BUF,		"XFS_LI_BUF" }, \
 	{ XFS_LI_DQUOT,		"XFS_LI_DQUOT" }, \
-	{ XFS_LI_QUOTAOFF,	"XFS_LI_QUOTAOFF" }
+	{ XFS_LI_QUOTAOFF,	"XFS_LI_QUOTAOFF" }, \
+	{ XFS_LI_ICREATE,	"XFS_LI_ICREATE" }
 
 /*
  * Transaction types.  Used to distinguish types of buffers.
@@ -291,7 +292,7 @@ struct xfs_trans_reservations {
 #define	XFS_ADDAFORK_LOG_RES(mp)	((mp)->m_reservations.tr_addafork)
 #define	XFS_ATTRINVAL_LOG_RES(mp)	((mp)->m_reservations.tr_attrinval)
 #define	XFS_ATTRSETM_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetm)
-#define XFS_ATTRSETRT_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetrt)
+#define	XFS_ATTRSETRT_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetrt)
 #define	XFS_ATTRRM_LOG_RES(mp)		((mp)->m_reservations.tr_attrrm)
 #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
 #define XFS_QM_SBCHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_qm_sbchange)
@@ -568,7 +569,4 @@ extern kmem_zone_t	*xfs_log_item_desc_zone;
 
 #endif	/* __KERNEL__ */
 
-void		xfs_trans_init(struct xfs_mount *);
-int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
-
 #endif	/* __XFS_TRANS_H__ */
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 53b7c9b..d43b130 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -25,6 +25,9 @@ struct xfs_trans;
 struct xfs_ail;
 struct xfs_log_vec;
 
+
+void	xfs_trans_init(struct xfs_mount *);
+int	xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
 void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
 void	xfs_trans_free_items(struct xfs_trans *tp, xfs_lsn_t commit_lsn,
diff --git a/fs/xfs/xfs_types.h b/fs/xfs/xfs_types.h
index 61ba1cf..dd6bf71 100644
--- a/fs/xfs/xfs_types.h
+++ b/fs/xfs/xfs_types.h
@@ -32,7 +32,6 @@ typedef unsigned int		__uint32_t;
 typedef signed long long int	__int64_t;
 typedef unsigned long long int	__uint64_t;
 
-typedef __uint32_t		prid_t;		/* project ID */
 typedef __uint32_t		inst_t;		/* an instruction */
 
 typedef __s64			xfs_off_t;	/* <file offset> type */
@@ -55,6 +54,8 @@ typedef __uint64_t __psunsigned_t;
 
 #endif	/* __KERNEL__ */
 
+typedef __uint32_t	prid_t;		/* project ID */
+
 typedef __uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef	__uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef	__uint32_t	xfs_extlen_t;	/* extent length in blocks */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

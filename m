Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D25497F52
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 07:13:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C1506304053
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 05:13:44 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0iTPcBloVZ5HKKMT for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 05:13:42 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHYRM-0001GP-Le
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 22:13:36 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHYRM-0004ES-KZ
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 22:13:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 05/12] xfs: move buf_ops externs to a xfs_format.h
Date: Thu,  5 Sep 2013 22:13:26 +1000
Message-Id: <1378383213-16155-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1378383213-16155-1-git-send-email-david@fromorbit.com>
References: <1378383213-16155-1-git-send-email-david@fromorbit.com>
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

All of the buffer operations structures are needed to be exported
for xfs_db, so move them all to a common location rather than
spreading them all over the place. They are verifying the on-disk
format, so xfs_format.h is as good a place as any.

Don't move the dir2 buffer verifiers - they are already shared in a
"central" place for all the dir2 and moving them just requires
adding more include files...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_ag.h           |  4 ----
 include/xfs_alloc.h        |  3 ---
 include/xfs_alloc_btree.h  |  2 --
 include/xfs_attr_leaf.h    |  2 --
 include/xfs_attr_remote.h  |  2 --
 include/xfs_bmap_btree.h   |  2 --
 include/xfs_da_btree.h     |  2 --
 include/xfs_format.h       | 22 ++++++++++++++++++++++
 include/xfs_ialloc.h       |  2 --
 include/xfs_ialloc_btree.h |  2 --
 include/xfs_inode_buf.h    |  2 --
 include/xfs_sb.h           |  3 ---
 12 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/include/xfs_ag.h b/include/xfs_ag.h
index 1cb740a..3fc1098 100644
--- a/include/xfs_ag.h
+++ b/include/xfs_ag.h
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
diff --git a/include/xfs_alloc.h b/include/xfs_alloc.h
index 99d0a61..feacb06 100644
--- a/include/xfs_alloc.h
+++ b/include/xfs_alloc.h
@@ -231,7 +231,4 @@ xfs_alloc_get_rec(
 	xfs_extlen_t		*len,	/* output: length of extent */
 	int			*stat);	/* output: success/failure */
 
-extern const struct xfs_buf_ops xfs_agf_buf_ops;
-extern const struct xfs_buf_ops xfs_agfl_buf_ops;
-
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/include/xfs_alloc_btree.h b/include/xfs_alloc_btree.h
index e3a3f74..72676c3 100644
--- a/include/xfs_alloc_btree.h
+++ b/include/xfs_alloc_btree.h
@@ -95,6 +95,4 @@ extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		xfs_agnumber_t, xfs_btnum_t);
 extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
 
-extern const struct xfs_buf_ops xfs_allocbt_buf_ops;
-
 #endif	/* __XFS_ALLOC_BTREE_H__ */
diff --git a/include/xfs_attr_leaf.h b/include/xfs_attr_leaf.h
index c102213..da34e64 100644
--- a/include/xfs_attr_leaf.h
+++ b/include/xfs_attr_leaf.h
@@ -336,6 +336,4 @@ void	xfs_attr3_leaf_hdr_from_disk(struct xfs_attr3_icleaf_hdr *to,
 void	xfs_attr3_leaf_hdr_to_disk(struct xfs_attr_leafblock *to,
 				   struct xfs_attr3_icleaf_hdr *from);
 
-extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
-
 #endif	/* __XFS_ATTR_LEAF_H__ */
diff --git a/include/xfs_attr_remote.h b/include/xfs_attr_remote.h
index 92a8fd7..b3e1e1b 100644
--- a/include/xfs_attr_remote.h
+++ b/include/xfs_attr_remote.h
@@ -45,8 +45,6 @@ struct xfs_attr3_rmt_hdr {
 	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
 			sizeof(struct xfs_attr3_rmt_hdr) : 0))
 
-extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
-
 int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
diff --git a/include/xfs_bmap_btree.h b/include/xfs_bmap_btree.h
index 1b726d6..e307978 100644
--- a/include/xfs_bmap_btree.h
+++ b/include/xfs_bmap_btree.h
@@ -239,6 +239,4 @@ extern int xfs_bmbt_maxrecs(struct xfs_mount *, int blocklen, int leaf);
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
 
-extern const struct xfs_buf_ops xfs_bmbt_buf_ops;
-
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/include/xfs_da_btree.h b/include/xfs_da_btree.h
index b1f2679..a762cfa 100644
--- a/include/xfs_da_btree.h
+++ b/include/xfs_da_btree.h
@@ -309,8 +309,6 @@ int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			 xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			 struct xfs_buf **bpp, int which_fork);
 
-extern const struct xfs_buf_ops xfs_da3_node_buf_ops;
-
 /*
  * Utility routines.
  */
diff --git a/include/xfs_format.h b/include/xfs_format.h
index 35c08ff..c1ea4b3 100644
--- a/include/xfs_format.h
+++ b/include/xfs_format.h
@@ -34,6 +34,28 @@ struct xfs_buf;
 struct xfs_ifork;
 
 /*
+ * Central location for exporting buffer verifier operations as they are
+ * widely used, including userspace tools
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
+extern const struct xfs_buf_ops xfs_symlink_buf_ops;
+extern const struct xfs_buf_ops xfs_agi_buf_ops;
+extern const struct xfs_buf_ops xfs_inobt_buf_ops;
+extern const struct xfs_buf_ops xfs_inode_buf_ops;
+extern const struct xfs_buf_ops xfs_inode_ra_buf_ops;
+extern const struct xfs_buf_ops xfs_dquot_buf_ops;
+extern const struct xfs_buf_ops xfs_sb_buf_ops;
+extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
+
+/*
  * RealTime Device format definitions
  */
 
diff --git a/include/xfs_ialloc.h b/include/xfs_ialloc.h
index 68c0732..1557798 100644
--- a/include/xfs_ialloc.h
+++ b/include/xfs_ialloc.h
@@ -158,6 +158,4 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
 			  xfs_agnumber_t agno, xfs_agblock_t agbno,
 			  xfs_agblock_t length, unsigned int gen);
 
-extern const struct xfs_buf_ops xfs_agi_buf_ops;
-
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/include/xfs_ialloc_btree.h b/include/xfs_ialloc_btree.h
index 3ac36b7..cfbfe46 100644
--- a/include/xfs_ialloc_btree.h
+++ b/include/xfs_ialloc_btree.h
@@ -110,6 +110,4 @@ extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
-extern const struct xfs_buf_ops xfs_inobt_buf_ops;
-
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/include/xfs_inode_buf.h b/include/xfs_inode_buf.h
index aae9fc4..e8fd3bd 100644
--- a/include/xfs_inode_buf.h
+++ b/include/xfs_inode_buf.h
@@ -47,6 +47,4 @@ void		xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #define	xfs_inobp_check(mp, bp)
 #endif /* DEBUG */
 
-extern const struct xfs_buf_ops xfs_inode_buf_ops;
-
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index 1d0839a..bc62812 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -693,7 +693,4 @@ extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
 extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
 
-extern const struct xfs_buf_ops xfs_sb_buf_ops;
-extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
-
 #endif	/* __XFS_SB_H__ */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

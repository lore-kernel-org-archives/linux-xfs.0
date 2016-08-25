Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2C18383E5
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:59:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E654E8F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:13 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3TezpKWpXZFF3VDx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:12 -0700 (PDT)
Subject: [PATCH 05/29] xfs: introduce realtime rmap btree definitions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:59:07 -0700
Message-ID: <147216954775.7022.2077331517114167698.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
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

Add new realtime rmap btree definitions. The realtime rmap btree will
be rooted from a hidden inode, but has its own shape and therefore
needs to have most of its own separate types.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_btree.c  |    4 ++--
 libxfs/xfs_btree.h  |    3 +++
 libxfs/xfs_format.h |    7 +++++++
 libxfs/xfs_types.h  |    3 ++-
 4 files changed, 14 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 26b8e62..53f6192 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -41,10 +41,10 @@ kmem_zone_t	*xfs_btree_cur_zone;
  */
 static const __uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
 	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, 0, XFS_BMAP_MAGIC, XFS_IBT_MAGIC,
-	  XFS_FIBT_MAGIC, 0 },
+	  XFS_FIBT_MAGIC, 0, 0 },
 	{ XFS_ABTB_CRC_MAGIC, XFS_ABTC_CRC_MAGIC, XFS_RMAP_CRC_MAGIC,
 	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC,
-	  XFS_REFC_CRC_MAGIC }
+	  XFS_REFC_CRC_MAGIC, XFS_RTRMAP_CRC_MAGIC }
 };
 #define xfs_btree_magic(cur) \
 	xfs_magics[!!((cur)->bc_flags & XFS_BTREE_CRC_BLOCKS)][cur->bc_btnum]
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 8918b81..8913ffa 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -75,6 +75,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
 #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
+#define	XFS_BTNUM_RTRMAP	((xfs_btnum_t)XFS_BTNUM_RTRMAPi)
 
 /*
  * For logging record fields.
@@ -107,6 +108,7 @@ do {    \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(__mp, bmbt, stat); break; \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(__mp, ibt, stat); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(__mp, fibt, stat); break; \
+	case XFS_BTNUM_RTRMAP: /* pass-through */ \
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(__mp, rmap, stat); break; \
 	case XFS_BTNUM_REFC: __XFS_BTREE_STATS_INC(__mp, refcbt, stat); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); __mp = __mp /* fucking gcc */ ; break; \
@@ -129,6 +131,7 @@ do {    \
 		__XFS_BTREE_STATS_ADD(__mp, ibt, stat, val); break; \
 	case XFS_BTNUM_FINO:	\
 		__XFS_BTREE_STATS_ADD(__mp, fibt, stat, val); break; \
+	case XFS_BTNUM_RTRMAP: /* pass-through */	\
 	case XFS_BTNUM_RMAP:	\
 		__XFS_BTREE_STATS_ADD(__mp, rmap, stat, val); break; \
 	case XFS_BTNUM_REFC:	\
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index c336f7a..ae2d958 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1463,6 +1463,13 @@ typedef __be32 xfs_rmap_ptr_t;
 	 XFS_IBT_BLOCK(mp) + 1)
 
 /*
+ * Realtime Reverse mapping btree format definitions
+ *
+ * There is a btree for the reverse map per allocation group
+ */
+#define	XFS_RTRMAP_CRC_MAGIC	0x4d415052	/* 'MAPR' */
+
+/*
  * Reference Count Btree format definitions
  *
  */
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index cf044c0..749aa83 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -113,7 +113,8 @@ typedef enum {
 
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
-	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
+	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_RTRMAPi,
+	XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 struct xfs_name {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

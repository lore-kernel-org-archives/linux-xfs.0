Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E9E977F61
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:56:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7C78FAC004
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:52 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 7ulBGjJPbAK5VX3Q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:50 -0800 (PST)
Subject: [PATCH 03/76] libxfs: refactor the btree size calculator code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:56:42 -0800
Message-ID: <20151219085642.12713.80467.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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

Create a macro to generate btree height calculator functions.
This will be used (much) later when we get to the refcount
btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |   18 +-----------------
 fs/xfs/libxfs/xfs_bmap_btree.c |    2 ++
 fs/xfs/libxfs/xfs_bmap_btree.h |    2 ++
 fs/xfs/libxfs/xfs_inode_fork.c |    1 +
 fs/xfs/libxfs/xfs_shared.h     |   29 +++++++++++++++++++++++++++++
 5 files changed, 35 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 119c242..2386377 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -180,25 +180,9 @@ xfs_bmap_worst_indlen(
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_filblks_t	len)		/* delayed extent length */
 {
-	int		level;		/* btree level number */
-	int		maxrecs;	/* maximum record count at this level */
-	xfs_mount_t	*mp;		/* mount structure */
 	xfs_filblks_t	rval;		/* return value */
 
-	mp = ip->i_mount;
-	maxrecs = mp->m_bmap_dmxr[0];
-	for (level = 0, rval = 0;
-	     level < XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK);
-	     level++) {
-		len += maxrecs - 1;
-		do_div(len, maxrecs);
-		rval += len;
-		if (len == 1)
-			return rval + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) -
-				level - 1;
-		if (level == 0)
-			maxrecs = mp->m_bmap_dmxr[1];
-	}
+	rval = xfs_bmbt_calc_btree_size(ip->i_mount, len);
 	return rval;
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 6b0cf65..3d947d6 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -882,3 +882,5 @@ xfs_bmbt_change_owner(
 	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	return error;
 }
+
+DEFINE_BTREE_SIZE_FN(bmbt, m_bmap_dmxr, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 819a8a4..7165a1b0 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -140,4 +140,6 @@ extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
 
+DECLARE_BTREE_SIZE_FN(bmbt);
+
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 0defbd0..46ea657 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -19,6 +19,7 @@
 
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 5be5297..544d0e9 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -234,4 +234,33 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
 
+/* btree size calculator templates */
+#define DECLARE_BTREE_SIZE_FN(btree) \
+xfs_filblks_t xfs_##btree##_calc_btree_size(struct xfs_mount *mp, \
+		unsigned long len);
+
+#define DEFINE_BTREE_SIZE_FN(btree, limitfield, maxlevels) \
+xfs_filblks_t \
+xfs_##btree##_calc_btree_size( \
+	struct xfs_mount	*mp, \
+	unsigned long		len) \
+{ \
+	int			level; \
+	int			maxrecs; \
+	xfs_filblks_t		rval; \
+\
+	maxrecs = mp->limitfield[0]; \
+	for (level = 0, rval = 0; level < maxlevels; level++) { \
+		len += maxrecs - 1; \
+		do_div(len, maxrecs); \
+		rval += len; \
+		if (len == 1) \
+			return rval + maxlevels - \
+				level - 1; \
+		if (level == 0) \
+			maxrecs = mp->limitfield[1]; \
+	} \
+	return rval; \
+}
+
 #endif /* __XFS_SHARED_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

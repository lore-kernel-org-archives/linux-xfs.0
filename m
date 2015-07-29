Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 01B957FCB
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:34:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C0FC0304043
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 15:34:11 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Qr4ih0QpXDbT7by9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 15:34:09 -0700 (PDT)
Subject: [PATCH 09/24] libxfs: adjust refcount when unmapping file blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 Jul 2015 15:33:56 -0700
Message-ID: <20150729223356.17414.64261.stgit@birch.djwong.org>
In-Reply-To: <20150729223258.17414.91354.stgit@birch.djwong.org>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
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

When we're unmapping blocks from a reflinked file, decrease the
refcount of the affected blocks and free the extents that are no
longer in use.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c     |   16 +++++++++++++---
 fs/xfs/libxfs/xfs_refcount.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount.h |    4 ++++
 3 files changed, 59 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 057fa9a..dfdd9e6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -45,6 +45,7 @@
 #include "xfs_symlink.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_filestream.h"
+#include "xfs_refcount.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -4983,9 +4984,18 @@ xfs_bmap_del_extent(
 	/*
 	 * If we need to, add to list of extents to delete.
 	 */
-	if (do_fx)
-		xfs_bmap_add_free(mp, flist, del->br_startblock,
-				  del->br_blockcount, ip->i_ino);
+	if (do_fx) {
+		if (xfs_is_reflink_inode(ip)) {
+			error = xfs_refcount_put_extent(mp, tp, flist,
+						del->br_startblock,
+						del->br_blockcount, ip->i_ino);
+			if (error)
+				goto done;
+		} else
+			xfs_bmap_add_free(mp, flist, del->br_startblock,
+					  del->br_blockcount, ip->i_ino);
+	}
+
 	/*
 	 * Adjust inode # blocks in the file.
 	 */
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 83d5677..ef69375 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -939,3 +939,45 @@ xfs_refcount_decrease(
 	return xfs_refcountbt_adjust_refcount(mp, tp, agbp, agno, agbno,
 			aglen, -1, flist, owner);
 }
+
+/**
+ * xfs_refcount_put_extent() - release a range of blocks
+ *
+ * @mp: XFS mount object
+ * @tp: transaction that goes with the free operation
+ * @flist: List of blocks to be freed at the end of the transaction
+ * @fsbno: First fs block of the range to release
+ * @len: Length of range
+ * @owner: owner of the extent
+ */
+int
+xfs_refcount_put_extent(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_bmap_free	*flist,
+	xfs_fsblock_t		fsbno,
+	xfs_filblks_t		fslen,
+	uint64_t		owner)
+{
+	int			error;
+	struct xfs_buf		*agbp;
+	xfs_agnumber_t		agno;		/* allocation group number */
+	xfs_agblock_t		agbno;		/* ag start of range to free */
+	xfs_extlen_t		aglen;		/* ag length of range to free */
+
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	aglen = fslen;
+
+	/*
+	 * Drop reference counts in the refcount tree.
+	 */
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	if (error)
+		return error;
+
+	error = xfs_refcount_decrease(mp, tp, agbp, agno, agbno, aglen, flist,
+			owner);
+	xfs_trans_brelse(tp, agbp);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 11d773bb..649d679 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -34,4 +34,8 @@ extern int xfs_refcount_decrease(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_extlen_t aglen, struct xfs_bmap_free *flist,
 		uint64_t owner);
 
+extern int xfs_refcount_put_extent(struct xfs_mount *mp, struct xfs_trans *tp,
+		struct xfs_bmap_free *flist, xfs_fsblock_t fsbno,
+		xfs_filblks_t len, uint64_t owner);
+
 #endif	/* __XFS_REFCOUNT_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

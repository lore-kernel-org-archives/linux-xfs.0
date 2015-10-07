Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A5BD7FB3
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 23:59:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2B59E304032
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 21:59:49 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id lGiyfyrdd5SdpTJN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 21:59:47 -0700 (PDT)
Subject: [PATCH 41/58] libxfs: adjust refcount when unmapping file blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 21:59:40 -0700
Message-ID: <20151007045940.30457.7139.stgit@birch.djwong.org>
In-Reply-To: <20151007045443.30457.47038.stgit@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

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
index 81f0ae0..f6812ba 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -46,6 +46,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_filestream.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_refcount.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -5182,9 +5183,18 @@ xfs_bmap_del_extent(
 	/*
 	 * If we need to, add to list of extents to delete.
 	 */
-	if (do_fx)
-		xfs_bmap_add_free(mp, flist, del->br_startblock,
-				  del->br_blockcount, NULL);
+	if (do_fx) {
+		if (xfs_is_reflink_inode(ip)) {
+			error = xfs_refcount_put_extent(mp, tp, flist,
+						del->br_startblock,
+						del->br_blockcount, NULL);
+			if (error)
+				goto done;
+		} else
+			xfs_bmap_add_free(mp, flist, del->br_startblock,
+					  del->br_blockcount, NULL);
+	}
+
 	/*
 	 * Adjust inode # blocks in the file.
 	 */
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 02892bc..bd611d3 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -938,3 +938,45 @@ xfs_refcount_decrease(
 	return xfs_refcountbt_adjust_refcount(mp, tp, agbp, agno, agbno,
 			aglen, -1, flist, oinfo);
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
+	struct xfs_owner_info	*oinfo)
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
+			oinfo);
+	xfs_trans_brelse(tp, agbp);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 6640e3d..074d620 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -34,4 +34,8 @@ extern int xfs_refcount_decrease(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_extlen_t aglen, struct xfs_bmap_free *flist,
 		struct xfs_owner_info *oinfo);
 
+extern int xfs_refcount_put_extent(struct xfs_mount *mp, struct xfs_trans *tp,
+		struct xfs_bmap_free *flist, xfs_fsblock_t fsbno,
+		xfs_filblks_t len, struct xfs_owner_info *oinfo);
+
 #endif	/* __XFS_REFCOUNT_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

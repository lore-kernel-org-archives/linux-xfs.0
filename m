Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 44CAA7F87
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:39:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B53EBAC003
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:39:39 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id tIXt85A5LHpQuWBa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:39:37 -0700 (PDT)
Subject: [PATCH 03/14] libxfs: support unmapping reflink blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:39:30 -0700
Message-ID: <20150625233930.4992.88802.stgit@birch.djwong.org>
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

When we're unmapping blocks from a file, we need to decrease refcounts
in the btree and only free blocks if they refcount is 1.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c          |    5 +
 fs/xfs/libxfs/xfs_reflink_btree.c |  140 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_reflink_btree.h |    4 +
 3 files changed, 147 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 057fa9a..3f5e8da 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -45,6 +45,7 @@
 #include "xfs_symlink.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_filestream.h"
+#include "xfs_reflink_btree.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -4984,8 +4985,8 @@ xfs_bmap_del_extent(
 	 * If we need to, add to list of extents to delete.
 	 */
 	if (do_fx)
-		xfs_bmap_add_free(mp, flist, del->br_startblock,
-				  del->br_blockcount, ip->i_ino);
+		xfs_reflink_bmap_add_free(mp, flist, del->br_startblock,
+					  del->br_blockcount, ip->i_ino, tp);
 	/*
 	 * Adjust inode # blocks in the file.
 	 */
diff --git a/fs/xfs/libxfs/xfs_reflink_btree.c b/fs/xfs/libxfs/xfs_reflink_btree.c
index 380ed72..f40ba1f 100644
--- a/fs/xfs/libxfs/xfs_reflink_btree.c
+++ b/fs/xfs/libxfs/xfs_reflink_btree.c
@@ -935,3 +935,143 @@ error0:
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 	return error;
 }
+
+/**
+ * xfs_reflink_bmap_add_free() - release a range of blocks
+ *
+ * @mp: XFS mount object
+ * @flist: List of blocks to be freed at the end of the transaction
+ * @fsbno: First fs block of the range to release
+ * @len: Length of range
+ * @owner: owner of the extent
+ * @tp: transaction that goes with the free operation
+ */
+int
+xfs_reflink_bmap_add_free(
+	struct xfs_mount	*mp,		/* mount point structure */
+	xfs_bmap_free_t		*flist,		/* list of extents */
+	xfs_fsblock_t		fsbno,		/* fs block number of extent */
+	xfs_filblks_t		fslen,		/* length of extent */
+	uint64_t		owner,		/* extent owner */
+	struct xfs_trans	*tp)		/* transaction */
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
+	struct xfs_buf		*agbp;
+	xfs_agnumber_t		agno;		/* allocation group number */
+	xfs_agblock_t		agbno;		/* ag start of range to free */
+	xfs_agblock_t		agbend;		/* ag end of range to free */
+	xfs_extlen_t		aglen;		/* ag length of range to free */
+	int			i, have;
+	xfs_agblock_t		lbno;		/* rlextent start */
+	xfs_extlen_t		llen;		/* rlextent length */
+	xfs_nlink_t		lnr;		/* rlextent refcount */
+	xfs_agblock_t		bno;		/* rlext block # in loop */
+	xfs_extlen_t		len;		/* rlext length in loop */
+	unsigned long long	blocks_freed;
+	xfs_fsblock_t		range_fsb;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb)) {
+		xfs_bmap_add_free(mp, flist, fsbno, fslen, owner);
+		return 0;
+	}
+
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	CHECK_AG_NUMBER(mp, agno);
+	ASSERT(fslen < mp->m_sb.sb_agblocks);
+	CHECK_AG_EXTENT(mp, agbno, fslen);
+	aglen = fslen;
+
+	/*
+	 * Drop reference counts in the reflink tree.
+	 */
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	if (error)
+		return error;
+
+	/*
+	 * Grab a rl btree cursor.
+	 */
+	cur = xfs_reflinkbt_init_cursor(mp, tp, agbp, agno);
+	bno = agbno;
+	len = aglen;
+	agbend = agbno + aglen - 1;
+	blocks_freed = 0;
+
+	/*
+	 * Account for a left extent that partially covers our range.
+	 */
+	error = xfs_reflink_lookup_le(cur, bno, &have);
+	if (error)
+		goto error0;
+	if (have) {
+		error = xfs_reflink_get_rec(cur, &lbno, &llen, &lnr, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, lbno, llen, lnr, error0);
+		if (lbno + llen > bno) {
+			blocks_freed += min(len, lbno + llen - bno);
+			bno += blocks_freed;
+			len -= blocks_freed;
+		}
+	}
+
+	while (len > 0) {
+		/*
+		 * Go find the next rlext.
+		 */
+		range_fsb = XFS_AGB_TO_FSB(mp, agno, bno);
+		error = xfs_btree_increment(cur, 0, &have);
+		if (error)
+			goto error0;
+		if (!have) {
+			/*
+			 * There's no right rlextent, so free bno to the end.
+			 */
+			lbno = bno + len;
+			llen = 0;
+		} else {
+			/*
+			 * Find the next rlextent.
+			 */
+			error = xfs_reflink_get_rec(cur, &lbno, &llen,
+					&lnr, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, lbno, llen, lnr,
+						      error0);
+			if (lbno >= bno + len) {
+				lbno = bno + len;
+				llen = 0;
+			}
+		}
+
+		/*
+		 * Free everything up to the start of the rlextent and
+		 * account for still-mapped blocks.
+		 */
+		if (lbno - bno > 0) {
+			xfs_bmap_add_free(mp, flist, range_fsb, lbno - bno,
+					  owner);
+			len -= lbno - bno;
+			bno += lbno - bno;
+		}
+		llen = min(llen, agbend + 1 - lbno);
+		blocks_freed += llen;
+		len -= llen;
+		bno += llen;
+	}
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	error = xfs_reflinkbt_adjust_refcount(mp, tp, agbp, agno, agbno, aglen,
+					      -1);
+	xfs_trans_brelse(tp, agbp);
+
+	return error;
+error0:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	xfs_trans_brelse(tp, agbp);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_reflink_btree.h b/fs/xfs/libxfs/xfs_reflink_btree.h
index d0785ff..4ea0ac4 100644
--- a/fs/xfs/libxfs/xfs_reflink_btree.h
+++ b/fs/xfs/libxfs/xfs_reflink_btree.h
@@ -71,4 +71,8 @@ extern int xfs_reflinkbt_adjust_refcount(struct xfs_mount *, struct xfs_trans *,
 		struct xfs_buf *, xfs_agnumber_t, xfs_agblock_t, xfs_extlen_t,
 		int);
 
+extern int xfs_reflink_bmap_add_free(struct xfs_mount *mp,
+		xfs_bmap_free_t *flist, xfs_fsblock_t fsbno, xfs_filblks_t len,
+		uint64_t owner, struct xfs_trans *tp);
+
 #endif	/* __XFS_REFLINK_BTREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

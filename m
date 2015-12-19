Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5B1547FFF
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:59:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EC590AC004
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:59:16 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id jz6PXs9PpTQ3OsnL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:59:15 -0800 (PST)
Subject: [PATCH 26/76] xfs: enhanced remove an extent from the rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:59:12 -0800
Message-ID: <20151219085912.12713.81363.stgit@birch.djwong.org>
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

Simplify the rmap extent removal since we never merge extents or anything
fancy like that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   49 ++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 7ad3cd5..8b244c4 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -121,15 +121,8 @@ xfs_rmap_get_rec(
 /*
  * Find the extent in the rmap btree and remove it.
  *
- * The record we find should always span a range greater than or equal to the
- * the extent being freed. This makes the code simple as, in theory, we do not
- * have to handle ranges that are split across multiple records as extents that
- * result in bmap btree extent merges should also result in rmap btree extent
- * merges.  The owner field ensures we don't merge extents from different
- * structures into the same record, hence this property should always hold true
- * if we ensure that the rmap btree supports at least the same size maximum
- * extent as the bmap btree (bmbt MAXEXTLEN is 2^21 blocks at present, rmap
- * btree record can hold 2^32 blocks in a single extent).
+ * The record we find should always be an exact match for the extent that we're
+ * looking for, since we insert them into the btree without modification.
  *
  * Special Case #1: when growing the filesystem, we "free" an extent when
  * growing the last AG. This extent is new space and so it is not tracked as
@@ -155,8 +148,11 @@ xfs_rmap_free(
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_btree_cur	*cur;
 	struct xfs_rmap_irec	ltrec;
+	uint64_t		ltoff;
 	int			error = 0;
 	int			i;
+	uint64_t		owner;
+	uint64_t		offset;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
@@ -164,12 +160,15 @@ xfs_rmap_free(
 	trace_xfs_rmap_free_extent(mp, agno, bno, len, oinfo);
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
 
+	xfs_owner_info_unpack(oinfo, &owner, &offset);
+
+	ltoff = ltrec.rm_offset & ~XFS_RMAP_OFF_BMBT;
 	/*
 	 * We should always have a left record because there's a static record
 	 * for the AG headers at rm_startblock == 0 created by mkfs/growfs that
 	 * will not ever be removed from the tree.
 	 */
-	error = xfs_rmap_lookup_le(cur, bno, len, owner, &i);
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, &i);
 	if (error)
 		goto out_error;
 	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
@@ -200,15 +199,30 @@ xfs_rmap_free(
 	//		ltrec.rm_blockcount, ltrec.rm_owner);
 
 	/* make sure the extent we found covers the entire freeing range. */
-	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno, out_error);
-	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_blockcount >= len, out_error);
-	XFS_WANT_CORRUPTED_GOTO(mp,
-		bno <= ltrec.rm_startblock + ltrec.rm_blockcount, out_error);
+	XFS_WANT_CORRUPTED_GOTO(mp, !XFS_RMAP_IS_UNWRITTEN(ltrec.rm_blockcount),
+		out_error);
+	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno &&
+		ltrec.rm_startblock + XFS_RMAP_LEN(ltrec.rm_blockcount) >=
+		bno + len, out_error);
 
 	/* make sure the owner matches what we expect to find in the tree */
 	XFS_WANT_CORRUPTED_GOTO(mp, owner == ltrec.rm_owner ||
-				    (owner < XFS_RMAP_OWN_NULL &&
-				     owner >= XFS_RMAP_OWN_MIN), out_error);
+				    XFS_RMAP_NON_INODE_OWNER(owner), out_error);
+
+	/* check the offset, if necessary */
+	if (!XFS_RMAP_NON_INODE_OWNER(owner)) {
+		if (XFS_RMAP_IS_BMBT(offset)) {
+			XFS_WANT_CORRUPTED_GOTO(mp,
+					XFS_RMAP_IS_BMBT(ltrec.rm_offset),
+					out_error);
+		} else {
+			XFS_WANT_CORRUPTED_GOTO(mp,
+					ltrec.rm_offset <= offset, out_error);
+			XFS_WANT_CORRUPTED_GOTO(mp,
+					offset <= ltoff + ltrec.rm_blockcount,
+					out_error);
+		}
+	}
 
 	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
 	//printk("remove exact\n");
@@ -267,7 +281,7 @@ xfs_rmap_free(
 		xfs_extlen_t	orig_len = ltrec.rm_blockcount;
 	//printk("remove middle\n");
 
-		ltrec.rm_blockcount = bno - ltrec.rm_startblock;;
+		ltrec.rm_blockcount = bno - ltrec.rm_startblock;
 		error = xfs_rmap_update(cur, &ltrec);
 		if (error)
 			goto out_error;
@@ -280,6 +294,7 @@ xfs_rmap_free(
 		cur->bc_rec.r.rm_blockcount = orig_len - len -
 						     ltrec.rm_blockcount;
 		cur->bc_rec.r.rm_owner = ltrec.rm_owner;
+		cur->bc_rec.r.rm_offset = offset;
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto out_error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

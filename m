Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 010F77FFF
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:59:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E750C304053
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:59:03 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4E8B3vFFVmVNEkMN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:59:02 -0800 (PST)
Subject: [PATCH 24/76] xfs: teach rmap_alloc how to deal with our larger
	rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:58:59 -0800
Message-ID: <20151219085859.12713.41554.stgit@birch.djwong.org>
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

Since reflink will require the rmapbt to mirror bmbt entries exactly, the
xfs_rmap_alloc function is only necessary to handle rmaps for bmbt blocks
and AG btrees.  Therefore, enhancing the function (and its extent merging
code) to handle the larger rmap records can be done simply.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c       |   50 +++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_rmap_btree.h |    1 +
 2 files changed, 40 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index d1b6c82..a225a64 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -145,16 +145,34 @@ out_error:
 }
 
 /*
- * When we allocate a new block, the first thing we do is add a reference to the
- * extent in the rmap btree. This takes the form of a [agbno, length, owner]
- * record.  Newly inserted extents should never overlap with an existing extent
- * in the rmap btree. Hence the insertion is a relatively trivial exercise,
- * involving checking for adjacent records and merging if the new extent is
- * contiguous and has the same owner.
- *
- * Note that we have no MAXEXTLEN limits here when merging as the length in the
- * record has the full 32 bits available and hence a single record can track the
- * entire space in the AG.
+ * A mergeable rmap should have the same owner, cannot be unwritten, and
+ * must be a bmbt rmap if we're asking about a bmbt rmap.
+ */
+static bool
+is_mergeable_rmap(
+	struct xfs_rmap_irec	*irec,
+	uint64_t		owner,
+	uint64_t		offset)
+{
+	if (irec->rm_owner == XFS_RMAP_OWN_NULL)
+		return false;
+	if (irec->rm_owner != owner)
+		return false;
+	if (XFS_RMAP_IS_UNWRITTEN(irec->rm_blockcount))
+		return false;
+	if (XFS_RMAP_IS_ATTR_FORK(offset) ^
+	    XFS_RMAP_IS_ATTR_FORK(irec->rm_offset))
+		return false;
+	if (XFS_RMAP_IS_BMBT(offset) ^ XFS_RMAP_IS_BMBT(irec->rm_offset))
+		return false;
+	return true;
+}
+
+/*
+ * When we allocate a new block, the first thing we do is add a reference to
+ * the extent in the rmap btree. This takes the form of a [agbno, length,
+ * owner, offset] record.  Flags are encoded in the high bits of the offset
+ * field.
  */
 int
 xfs_rmap_alloc(
@@ -172,6 +190,8 @@ xfs_rmap_alloc(
 	int			have_gt;
 	int			error = 0;
 	int			i;
+	uint64_t		owner;
+	uint64_t		offset;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
@@ -179,12 +199,14 @@ xfs_rmap_alloc(
 	trace_xfs_rmap_alloc_extent(mp, agno, bno, len, oinfo);
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
 
+	xfs_owner_info_unpack(oinfo, &owner, &offset);
+
 	/*
 	 * For the initial lookup, look for and exact match or the left-adjacent
 	 * record for our insertion point. This will also give us the record for
 	 * start block contiguity tests.
 	 */
-	error = xfs_rmap_lookup_le(cur, bno, len, owner, &i);
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, &i);
 	if (error)
 		goto out_error;
 	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
@@ -196,8 +218,11 @@ xfs_rmap_alloc(
 	//printk("rmalloc ag %d bno 0x%x/0x%x/0x%llx, ltrec 0x%x/0x%x/0x%llx\n",
 	//		agno, bno, len, owner, ltrec.rm_startblock,
 	//		ltrec.rm_blockcount, ltrec.rm_owner);
+	if (!is_mergeable_rmap(&ltrec, owner, offset))
+		ltrec.rm_owner = XFS_RMAP_OWN_NULL;
 
 	XFS_WANT_CORRUPTED_GOTO(mp,
+		ltrec.rm_owner == XFS_RMAP_OWN_NULL ||
 		ltrec.rm_startblock + ltrec.rm_blockcount <= bno, out_error);
 
 	/*
@@ -221,6 +246,8 @@ xfs_rmap_alloc(
 	} else {
 		gtrec.rm_owner = XFS_RMAP_OWN_NULL;
 	}
+	if (!is_mergeable_rmap(&gtrec, owner, offset))
+		gtrec.rm_owner = XFS_RMAP_OWN_NULL;
 
 	/*
 	 * Note: cursor currently points one record to the right of ltrec, even
@@ -291,6 +318,7 @@ xfs_rmap_alloc(
 		cur->bc_rec.r.rm_startblock = bno;
 		cur->bc_rec.r.rm_blockcount = len;
 		cur->bc_rec.r.rm_owner = owner;
+		cur->bc_rec.r.rm_offset = offset;
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto out_error;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index a5c97f8..0dfc151 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -58,6 +58,7 @@ int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t	bno,
 int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
 		int *stat);
 
+/* functions for updating the rmapbt for bmbt blocks and AG btree blocks */
 int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
 		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
 		   struct xfs_owner_info *oinfo);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

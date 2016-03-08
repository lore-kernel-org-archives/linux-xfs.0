Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3F34C29E19
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 22:17:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DBE59304039
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 20:17:13 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	SN5wHCn9dZ7sRTwi for <xfs@oss.sgi.com>;
	Mon, 07 Mar 2016 20:17:11 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ad94T-0004AO-5F
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:33 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ad94G-0007v1-JA
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/16] xfs: add an extent to the rmap btree
Date: Tue,  8 Mar 2016 15:16:15 +1100
Message-Id: <1457410578-30233-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1457410578-30233-1-git-send-email-david@fromorbit.com>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
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

Now all the btree, free space and transaction infrastructure is in
place, we can finally add the code to insert reverse mappings to the
rmap btree. Freeing will be done in a spearate patch, so just the
addition operation can be focussed on here.

[darrick.wong@oracle.com: handle owner offsets, fork and bmbt bits
 when adding rmaps]
[dchinner: remove remaining debug printk statements]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_rmap.c       | 159 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_rmap_btree.h |   1 +
 2 files changed, 159 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index f6fe742..56627c1c 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -144,6 +144,36 @@ out_error:
 	return error;
 }
 
+/*
+ * A mergeable rmap should have the same owner, cannot be unwritten, and
+ * must be a bmbt rmap if we're asking about a bmbt rmap.
+ */
+static bool
+xfs_rmap_is_mergeable(
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
+ */
 int
 xfs_rmap_alloc(
 	struct xfs_trans	*tp,
@@ -154,18 +184,145 @@ xfs_rmap_alloc(
 	struct xfs_owner_info	*oinfo)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_btree_cur	*cur;
+	struct xfs_rmap_irec	ltrec;
+	struct xfs_rmap_irec	gtrec;
+	int			have_gt;
 	int			error = 0;
+	int			i;
+	uint64_t		owner;
+	uint64_t		offset;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
 	trace_xfs_rmap_alloc_extent(mp, agno, bno, len, oinfo);
-	if (1)
+	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+
+	xfs_owner_info_unpack(oinfo, &owner, &offset);
+
+	/*
+	 * For the initial lookup, look for and exact match or the left-adjacent
+	 * record for our insertion point. This will also give us the record for
+	 * start block contiguity tests.
+	 */
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+
+	error = xfs_rmap_get_rec(cur, &ltrec, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+
+	if (!xfs_rmap_is_mergeable(&ltrec, owner, offset))
+		ltrec.rm_owner = XFS_RMAP_OWN_NULL;
+
+	XFS_WANT_CORRUPTED_GOTO(mp,
+		ltrec.rm_owner == XFS_RMAP_OWN_NULL ||
+		ltrec.rm_startblock + ltrec.rm_blockcount <= bno, out_error);
+
+	/*
+	 * Increment the cursor to see if we have a right-adjacent record to our
+	 * insertion point. This will give us the record for end block
+	 * contiguity tests.
+	 */
+	error = xfs_btree_increment(cur, 0, &have_gt);
+	if (error)
 		goto out_error;
+	if (have_gt) {
+		error = xfs_rmap_get_rec(cur, &gtrec, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= gtrec.rm_startblock,
+					out_error);
+	} else {
+		gtrec.rm_owner = XFS_RMAP_OWN_NULL;
+	}
+	if (!xfs_rmap_is_mergeable(&gtrec, owner, offset))
+		gtrec.rm_owner = XFS_RMAP_OWN_NULL;
+
+	/*
+	 * Note: cursor currently points one record to the right of ltrec, even
+	 * if there is no record in the tree to the right.
+	 */
+	if (ltrec.rm_owner == owner &&
+	    ltrec.rm_startblock + ltrec.rm_blockcount == bno) {
+		/*
+		 * left edge contiguous, merge into left record.
+		 *
+		 *       ltbno     ltlen
+		 * orig:   |ooooooooo|
+		 * adding:           |aaaaaaaaa|
+		 * result: |rrrrrrrrrrrrrrrrrrr|
+		 *                  bno       len
+		 */
+		ltrec.rm_blockcount += len;
+		if (gtrec.rm_owner == owner &&
+		    bno + len == gtrec.rm_startblock) {
+			//printk("add middle\n");
+			/*
+			 * right edge also contiguous, delete right record
+			 * and merge into left record.
+			 *
+			 *       ltbno     ltlen    gtbno     gtlen
+			 * orig:   |ooooooooo|         |ooooooooo|
+			 * adding:           |aaaaaaaaa|
+			 * result: |rrrrrrrrrrrrrrrrrrrrrrrrrrrrr|
+			 */
+			ltrec.rm_blockcount += gtrec.rm_blockcount;
+			error = xfs_btree_delete(cur, &i);
+			if (error)
+				goto out_error;
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+		}
+
+		/* point the cursor back to the left record and update */
+		error = xfs_btree_decrement(cur, 0, &have_gt);
+		if (error)
+			goto out_error;
+		error = xfs_rmap_update(cur, &ltrec);
+		if (error)
+			goto out_error;
+	} else if (gtrec.rm_owner == owner &&
+		   bno + len == gtrec.rm_startblock) {
+		/*
+		 * right edge contiguous, merge into right record.
+		 *
+		 *                 gtbno     gtlen
+		 * Orig:             |ooooooooo|
+		 * adding: |aaaaaaaaa|
+		 * Result: |rrrrrrrrrrrrrrrrrrr|
+		 *        bno       len
+		 */
+		gtrec.rm_startblock = bno;
+		gtrec.rm_blockcount += len;
+		error = xfs_rmap_update(cur, &gtrec);
+		if (error)
+			goto out_error;
+	} else {
+		/*
+		 * no contiguous edge with identical owner, insert
+		 * new record at current cursor position.
+		 */
+		cur->bc_rec.r.rm_startblock = bno;
+		cur->bc_rec.r.rm_blockcount = len;
+		cur->bc_rec.r.rm_owner = owner;
+		cur->bc_rec.r.rm_offset = offset;
+		error = xfs_btree_insert(cur, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	}
+
 	trace_xfs_rmap_alloc_extent_done(mp, agno, bno, len, oinfo);
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	return 0;
 
 out_error:
 	trace_xfs_rmap_alloc_extent_error(mp, agno, bno, len, oinfo);
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 	return error;
 }
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
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

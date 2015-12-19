Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 70029801B
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:59:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 616BA8F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:59:11 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ixUY4l4ns3LJe6nf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:59:09 -0800 (PST)
Subject: [PATCH 25/76] xfs: remove an extent from the rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:59:06 -0800
Message-ID: <20151219085906.12713.78253.stgit@birch.djwong.org>
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

>From : Dave Chinner <dchinner@redhat.com>

Now that we have records in the rmap btree, we need to remove them
when extents are freed. This needs to find the relevant record in
the btree and remove/trim/split it accordingly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_rmap.c |  154 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 153 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index a225a64..7ad3cd5 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -118,6 +118,31 @@ xfs_rmap_get_rec(
 	return 0;
 }
 
+/*
+ * Find the extent in the rmap btree and remove it.
+ *
+ * The record we find should always span a range greater than or equal to the
+ * the extent being freed. This makes the code simple as, in theory, we do not
+ * have to handle ranges that are split across multiple records as extents that
+ * result in bmap btree extent merges should also result in rmap btree extent
+ * merges.  The owner field ensures we don't merge extents from different
+ * structures into the same record, hence this property should always hold true
+ * if we ensure that the rmap btree supports at least the same size maximum
+ * extent as the bmap btree (bmbt MAXEXTLEN is 2^21 blocks at present, rmap
+ * btree record can hold 2^32 blocks in a single extent).
+ *
+ * Special Case #1: when growing the filesystem, we "free" an extent when
+ * growing the last AG. This extent is new space and so it is not tracked as
+ * used space in the btree. The growfs code will pass in an owner of
+ * XFS_RMAP_OWN_NULL to indicate that it expected that there is no owner of this
+ * extent. We verify that - the extent lookup result in a record that does not
+ * overlap.
+ *
+ * Special Case #2: EFIs do not record the owner of the extent, so when
+ * recovering EFIs from the log we pass in XFS_RMAP_OWN_UNKNOWN to tell the rmap
+ * btree to ignore the owner (i.e. wildcard match) so we don't trigger
+ * corruption checks during log recovery.
+ */
 int
 xfs_rmap_free(
 	struct xfs_trans	*tp,
@@ -128,19 +153,146 @@ xfs_rmap_free(
 	struct xfs_owner_info	*oinfo)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_btree_cur	*cur;
+	struct xfs_rmap_irec	ltrec;
 	int			error = 0;
+	int			i;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
 	trace_xfs_rmap_free_extent(mp, agno, bno, len, oinfo);
-	if (1)
+	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+
+	/*
+	 * We should always have a left record because there's a static record
+	 * for the AG headers at rm_startblock == 0 created by mkfs/growfs that
+	 * will not ever be removed from the tree.
+	 */
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+
+	error = xfs_rmap_get_rec(cur, &ltrec, &i);
+	if (error)
 		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+
+	/*
+	 * For growfs, the incoming extent must be beyond the left record we
+	 * just found as it is new space and won't be used by anyone. This is
+	 * just a corruption check as we don't actually do anything with this
+	 * extent.
+	 */
+	if (owner == XFS_RMAP_OWN_NULL) {
+		XFS_WANT_CORRUPTED_GOTO(mp, bno > ltrec.rm_startblock +
+						ltrec.rm_blockcount, out_error);
+		goto out_done;
+	}
+
+/*
+	if (owner != ltrec.rm_owner ||
+	    bno > ltrec.rm_startblock + ltrec.rm_blockcount)
+ */
+	//printk("rmfree  ag %d bno 0x%x/0x%x/0x%llx, ltrec 0x%x/0x%x/0x%llx\n",
+	//		agno, bno, len, owner, ltrec.rm_startblock,
+	//		ltrec.rm_blockcount, ltrec.rm_owner);
+
+	/* make sure the extent we found covers the entire freeing range. */
+	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno, out_error);
+	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_blockcount >= len, out_error);
+	XFS_WANT_CORRUPTED_GOTO(mp,
+		bno <= ltrec.rm_startblock + ltrec.rm_blockcount, out_error);
+
+	/* make sure the owner matches what we expect to find in the tree */
+	XFS_WANT_CORRUPTED_GOTO(mp, owner == ltrec.rm_owner ||
+				    (owner < XFS_RMAP_OWN_NULL &&
+				     owner >= XFS_RMAP_OWN_MIN), out_error);
+
+	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
+	//printk("remove exact\n");
+		/* exact match, simply remove the record from rmap tree */
+		error = xfs_btree_delete(cur, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	} else if (ltrec.rm_startblock == bno) {
+	//printk("remove left\n");
+		/*
+		 * overlap left hand side of extent: move the start, trim the
+		 * length and update the current record.
+		 *
+		 *       ltbno                ltlen
+		 * Orig:    |oooooooooooooooooooo|
+		 * Freeing: |fffffffff|
+		 * Result:            |rrrrrrrrrr|
+		 *         bno       len
+		 */
+		ltrec.rm_startblock += len;
+		ltrec.rm_blockcount -= len;
+		error = xfs_rmap_update(cur, &ltrec);
+		if (error)
+			goto out_error;
+	} else if (ltrec.rm_startblock + ltrec.rm_blockcount == bno + len) {
+	//printk("remove right\n");
+		/*
+		 * overlap right hand side of extent: trim the length and update
+		 * the current record.
+		 *
+		 *       ltbno                ltlen
+		 * Orig:    |oooooooooooooooooooo|
+		 * Freeing:            |fffffffff|
+		 * Result:  |rrrrrrrrrr|
+		 *                    bno       len
+		 */
+		ltrec.rm_blockcount -= len;
+		error = xfs_rmap_update(cur, &ltrec);
+		if (error)
+			goto out_error;
+	} else {
+
+		/*
+		 * overlap middle of extent: trim the length of the existing
+		 * record to the length of the new left-extent size, increment
+		 * the insertion position so we can insert a new record
+		 * containing the remaining right-extent space.
+		 *
+		 *       ltbno                ltlen
+		 * Orig:    |oooooooooooooooooooo|
+		 * Freeing:       |fffffffff|
+		 * Result:  |rrrrr|         |rrrr|
+		 *               bno       len
+		 */
+		xfs_extlen_t	orig_len = ltrec.rm_blockcount;
+	//printk("remove middle\n");
+
+		ltrec.rm_blockcount = bno - ltrec.rm_startblock;;
+		error = xfs_rmap_update(cur, &ltrec);
+		if (error)
+			goto out_error;
+
+		error = xfs_btree_increment(cur, 0, &i);
+		if (error)
+			goto out_error;
+
+		cur->bc_rec.r.rm_startblock = bno + len;
+		cur->bc_rec.r.rm_blockcount = orig_len - len -
+						     ltrec.rm_blockcount;
+		cur->bc_rec.r.rm_owner = ltrec.rm_owner;
+		error = xfs_btree_insert(cur, &i);
+		if (error)
+			goto out_error;
+	}
+
+out_done:
 	trace_xfs_rmap_free_extent_done(mp, agno, bno, len, oinfo);
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	return 0;
 
 out_error:
 	trace_xfs_rmap_free_extent_error(mp, agno, bno, len, oinfo);
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 	return error;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

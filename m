Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6404E29E45
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 22:17:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1A4AA8F8039
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 20:17:21 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jVU7JB4vAEeRKoKE for <xfs@oss.sgi.com>;
	Mon, 07 Mar 2016 20:17:18 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ad94T-0004AP-5e
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:33 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ad94G-0007v6-KF
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/16] xfs: remove an extent from the rmap btree
Date: Tue,  8 Mar 2016 15:16:16 +1100
Message-Id: <1457410578-30233-15-git-send-email-david@fromorbit.com>
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

Now that we have records in the rmap btree, we need to remove them
when extents are freed. This needs to find the relevant record in
the btree and remove/trim/split it accordingly.

[darrick.wong@oracle.com: make rmap routines handle the enlarged keyspace]
[dchinner: remove remaining unused debug printks]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_rmap.c | 158 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 156 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 56627c1c..d2e01b2 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -118,6 +118,24 @@ xfs_rmap_get_rec(
 	return 0;
 }
 
+/*
+ * Find the extent in the rmap btree and remove it.
+ *
+ * The record we find should always be an exact match for the extent that we're
+ * looking for, since we insert them into the btree without modification.
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
@@ -128,19 +146,156 @@ xfs_rmap_free(
 	struct xfs_owner_info	*oinfo)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_btree_cur	*cur;
+	struct xfs_rmap_irec	ltrec;
+	uint64_t		ltoff;
 	int			error = 0;
+	int			i;
+	uint64_t		owner;
+	uint64_t		offset;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
 	trace_xfs_rmap_free_extent(mp, agno, bno, len, oinfo);
-	if (1)
+	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+
+	xfs_owner_info_unpack(oinfo, &owner, &offset);
+
+	/*
+	 * We should always have a left record because there's a static record
+	 * for the AG headers at rm_startblock == 0 created by mkfs/growfs that
+	 * will not ever be removed from the tree.
+	 */
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, &i);
+	if (error)
 		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+
+	error = xfs_rmap_get_rec(cur, &ltrec, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	ltoff = ltrec.rm_offset & ~XFS_RMAP_OFF_BMBT;
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
+	/* make sure the extent we found covers the entire freeing range. */
+	XFS_WANT_CORRUPTED_GOTO(mp, !XFS_RMAP_IS_UNWRITTEN(ltrec.rm_blockcount),
+		out_error);
+	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno &&
+		ltrec.rm_startblock + XFS_RMAP_LEN(ltrec.rm_blockcount) >=
+		bno + len, out_error);
+
+	/* make sure the owner matches what we expect to find in the tree */
+	XFS_WANT_CORRUPTED_GOTO(mp, owner == ltrec.rm_owner ||
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
+
+	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
+		/* exact match, simply remove the record from rmap tree */
+		error = xfs_btree_delete(cur, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	} else if (ltrec.rm_startblock == bno) {
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
+
+		ltrec.rm_blockcount = bno - ltrec.rm_startblock;
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
+		cur->bc_rec.r.rm_offset = offset;
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
 
@@ -262,7 +417,6 @@ xfs_rmap_alloc(
 		ltrec.rm_blockcount += len;
 		if (gtrec.rm_owner == owner &&
 		    bno + len == gtrec.rm_startblock) {
-			//printk("add middle\n");
 			/*
 			 * right edge also contiguous, delete right record
 			 * and merge into left record.
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

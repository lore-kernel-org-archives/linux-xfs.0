Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9322D8168
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:35:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16BB6AC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:35:06 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id vc5lomk4YT0H8PlQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:35:03 -0700 (PDT)
Subject: [PATCH 040/145] xfs: remove an extent from the rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:34:56 -0700
Message-ID: <146612729610.16048.6640772609600442182.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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

From: Dave Chinner <dchinner@redhat.com>

Now that we have records in the rmap btree, we need to remove them
when extents are freed. This needs to find the relevant record in
the btree and remove/trim/split it accordingly.

v2: Update the free function to deal with non-shared file data, and
isolate the part that does the rmap update from the part that deals
with cursors.  This will be useful for deferred ops.

[darrick.wong@oracle.com: make rmap routines handle the enlarged keyspace]
[dchinner: remove remaining unused debug printks]
[darrick: fix a bug when growfs in an AG with an rmap ending at EOFS]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_rmap.c |  220 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 215 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index fc3522b..cc82824 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -131,6 +131,212 @@ xfs_rmap_get_rec(
 	return xfs_rmapbt_btrec_to_irec(rec, irec);
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
+STATIC int
+__xfs_rmap_free(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			unwritten,
+	struct xfs_owner_info	*oinfo)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_rmap_irec	ltrec;
+	uint64_t		ltoff;
+	int			error = 0;
+	int			i;
+	uint64_t		owner;
+	uint64_t		offset;
+	unsigned int		flags;
+	bool			ignore_off;
+
+	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
+	ignore_off = XFS_RMAP_NON_INODE_OWNER(owner) ||
+			(flags & XFS_RMAP_BMBT_BLOCK);
+	if (unwritten)
+		flags |= XFS_RMAP_UNWRITTEN;
+	trace_xfs_rmap_free_extent(mp, cur->bc_private.a.agno, bno, len,
+			unwritten, oinfo);
+
+	/*
+	 * We should always have a left record because there's a static record
+	 * for the AG headers at rm_startblock == 0 created by mkfs/growfs that
+	 * will not ever be removed from the tree.
+	 */
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, flags, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+
+	error = xfs_rmap_get_rec(cur, &ltrec, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
+			cur->bc_private.a.agno, ltrec.rm_startblock,
+			ltrec.rm_blockcount, ltrec.rm_owner,
+			ltrec.rm_offset, ltrec.rm_flags);
+	ltoff = ltrec.rm_offset;
+
+	/*
+	 * For growfs, the incoming extent must be beyond the left record we
+	 * just found as it is new space and won't be used by anyone. This is
+	 * just a corruption check as we don't actually do anything with this
+	 * extent.  Note that we need to use >= instead of > because it might
+	 * be the case that the "left" extent goes all the way to EOFS.
+	 */
+	if (owner == XFS_RMAP_OWN_NULL) {
+		XFS_WANT_CORRUPTED_GOTO(mp, bno >= ltrec.rm_startblock +
+						ltrec.rm_blockcount, out_error);
+		goto out_done;
+	}
+
+	/* Make sure the unwritten flag matches. */
+	XFS_WANT_CORRUPTED_GOTO(mp, (flags & XFS_RMAP_UNWRITTEN) ==
+			(ltrec.rm_flags & XFS_RMAP_UNWRITTEN), out_error);
+
+	/* Make sure the extent we found covers the entire freeing range. */
+	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno &&
+		ltrec.rm_startblock + ltrec.rm_blockcount >=
+		bno + len, out_error);
+
+	/* Make sure the owner matches what we expect to find in the tree. */
+	XFS_WANT_CORRUPTED_GOTO(mp, owner == ltrec.rm_owner ||
+				    XFS_RMAP_NON_INODE_OWNER(owner), out_error);
+
+	/* Check the offset, if necessary. */
+	if (!XFS_RMAP_NON_INODE_OWNER(owner)) {
+		if (flags & XFS_RMAP_BMBT_BLOCK) {
+			XFS_WANT_CORRUPTED_GOTO(mp,
+					ltrec.rm_flags & XFS_RMAP_BMBT_BLOCK,
+					out_error);
+		} else {
+			XFS_WANT_CORRUPTED_GOTO(mp,
+					ltrec.rm_offset <= offset, out_error);
+			XFS_WANT_CORRUPTED_GOTO(mp,
+					ltoff + ltrec.rm_blockcount >= offset + len,
+					out_error);
+		}
+	}
+
+	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
+		/* exact match, simply remove the record from rmap tree */
+		trace_xfs_rmapbt_delete(mp, cur->bc_private.a.agno,
+				ltrec.rm_startblock, ltrec.rm_blockcount,
+				ltrec.rm_owner, ltrec.rm_offset,
+				ltrec.rm_flags);
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
+		if (!ignore_off)
+			ltrec.rm_offset += len;
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
+		if (ignore_off)
+			cur->bc_rec.r.rm_offset = 0;
+		else
+			cur->bc_rec.r.rm_offset = offset + len;
+		cur->bc_rec.r.rm_flags = flags;
+		trace_xfs_rmapbt_insert(mp, cur->bc_private.a.agno,
+				cur->bc_rec.r.rm_startblock,
+				cur->bc_rec.r.rm_blockcount,
+				cur->bc_rec.r.rm_owner,
+				cur->bc_rec.r.rm_offset,
+				cur->bc_rec.r.rm_flags);
+		error = xfs_btree_insert(cur, &i);
+		if (error)
+			goto out_error;
+	}
+
+out_done:
+	trace_xfs_rmap_free_extent_done(mp, cur->bc_private.a.agno, bno, len,
+			unwritten, oinfo);
+out_error:
+	if (error)
+		trace_xfs_rmap_free_extent_error(mp, cur->bc_private.a.agno,
+				bno, len, unwritten, oinfo);
+	return error;
+}
+
+/*
+ * Remove a reference to an extent in the rmap btree.
+ */
 int
 xfs_rmap_free(
 	struct xfs_trans	*tp,
@@ -141,19 +347,23 @@ xfs_rmap_free(
 	struct xfs_owner_info	*oinfo)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	int			error = 0;
+	struct xfs_btree_cur	*cur;
+	int			error;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	trace_xfs_rmap_free_extent(mp, agno, bno, len, false, oinfo);
-	if (1)
+	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+
+	error = __xfs_rmap_free(cur, bno, len, false, oinfo);
+	if (error)
 		goto out_error;
-	trace_xfs_rmap_free_extent_done(mp, agno, bno, len, false, oinfo);
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	return 0;
 
 out_error:
-	trace_xfs_rmap_free_extent_error(mp, agno, bno, len, false, oinfo);
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 	return error;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 47B887CEF
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 00:00:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE65F304043
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:00:00 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Kro59Emc4z9jn9h7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:59:55 -0700 (PDT)
Subject: [PATCH 34/47] xfs: add an extent to the rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:59:49 -0700
Message-ID: <146907718971.25461.11622226359394117243.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now all the btree, free space and transaction infrastructure is in
place, we can finally add the code to insert reverse mappings to the
rmap btree. Freeing will be done in a separate patch, so just the
addition operation can be focussed on here.

v2: Update alloc function to handle non-shared file data.  Isolate the
part that makes changes from the part that initializes the rmap
cursor; this will be useful for deferred updates.

[darrick: handle owner offsets when adding rmaps]
[dchinner: remove remaining debug printk statements]
[darrick: move unwritten bit to rm_offset]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_rmap.c |  226 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h       |    2 
 2 files changed, 223 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 6638bc7..1c0e2a8 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -31,6 +31,7 @@
 #include "xfs_trans.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
@@ -158,6 +159,218 @@ out_error:
 	return error;
 }
 
+/*
+ * A mergeable rmap must have the same owner and the same values for
+ * the unwritten, attr_fork, and bmbt flags.  The startblock and
+ * offset are checked separately.
+ */
+static bool
+xfs_rmap_is_mergeable(
+	struct xfs_rmap_irec	*irec,
+	uint64_t		owner,
+	unsigned int		flags)
+{
+	if (irec->rm_owner == XFS_RMAP_OWN_NULL)
+		return false;
+	if (irec->rm_owner != owner)
+		return false;
+	if ((flags & XFS_RMAP_UNWRITTEN) ^
+	    (irec->rm_flags & XFS_RMAP_UNWRITTEN))
+		return false;
+	if ((flags & XFS_RMAP_ATTR_FORK) ^
+	    (irec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return false;
+	if ((flags & XFS_RMAP_BMBT_BLOCK) ^
+	    (irec->rm_flags & XFS_RMAP_BMBT_BLOCK))
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
+STATIC int
+xfs_rmap_map(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			unwritten,
+	struct xfs_owner_info	*oinfo)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_rmap_irec	ltrec;
+	struct xfs_rmap_irec	gtrec;
+	int			have_gt;
+	int			have_lt;
+	int			error = 0;
+	int			i;
+	uint64_t		owner;
+	uint64_t		offset;
+	unsigned int		flags = 0;
+	bool			ignore_off;
+
+	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
+	ASSERT(owner != 0);
+	ignore_off = XFS_RMAP_NON_INODE_OWNER(owner) ||
+			(flags & XFS_RMAP_BMBT_BLOCK);
+	if (unwritten)
+		flags |= XFS_RMAP_UNWRITTEN;
+	trace_xfs_rmap_map(mp, cur->bc_private.a.agno, bno, len,
+			unwritten, oinfo);
+
+	/*
+	 * For the initial lookup, look for an exact match or the left-adjacent
+	 * record for our insertion point. This will also give us the record for
+	 * start block contiguity tests.
+	 */
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, flags,
+			&have_lt);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, have_lt == 1, out_error);
+
+	error = xfs_rmap_get_rec(cur, &ltrec, &have_lt);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, have_lt == 1, out_error);
+	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
+			cur->bc_private.a.agno, ltrec.rm_startblock,
+			ltrec.rm_blockcount, ltrec.rm_owner,
+			ltrec.rm_offset, ltrec.rm_flags);
+
+	if (!xfs_rmap_is_mergeable(&ltrec, owner, flags))
+		have_lt = 0;
+
+	XFS_WANT_CORRUPTED_GOTO(mp,
+		have_lt == 0 ||
+		ltrec.rm_startblock + ltrec.rm_blockcount <= bno, out_error);
+
+	/*
+	 * Increment the cursor to see if we have a right-adjacent record to our
+	 * insertion point. This will give us the record for end block
+	 * contiguity tests.
+	 */
+	error = xfs_btree_increment(cur, 0, &have_gt);
+	if (error)
+		goto out_error;
+	if (have_gt) {
+		error = xfs_rmap_get_rec(cur, &gtrec, &have_gt);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 1, out_error);
+		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= gtrec.rm_startblock,
+					out_error);
+		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
+			cur->bc_private.a.agno, gtrec.rm_startblock,
+			gtrec.rm_blockcount, gtrec.rm_owner,
+			gtrec.rm_offset, gtrec.rm_flags);
+		if (!xfs_rmap_is_mergeable(&gtrec, owner, flags))
+			have_gt = 0;
+	}
+
+	/*
+	 * Note: cursor currently points one record to the right of ltrec, even
+	 * if there is no record in the tree to the right.
+	 */
+	if (have_lt &&
+	    ltrec.rm_startblock + ltrec.rm_blockcount == bno &&
+	    (ignore_off || ltrec.rm_offset + ltrec.rm_blockcount == offset)) {
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
+		if (have_gt &&
+		    bno + len == gtrec.rm_startblock &&
+		    (ignore_off || offset + len == gtrec.rm_offset) &&
+		    (unsigned long)ltrec.rm_blockcount + len +
+				gtrec.rm_blockcount <= XFS_RMAP_LEN_MAX) {
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
+			trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+					gtrec.rm_startblock,
+					gtrec.rm_blockcount,
+					gtrec.rm_owner,
+					gtrec.rm_offset,
+					gtrec.rm_flags);
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
+	} else if (have_gt &&
+		   bno + len == gtrec.rm_startblock &&
+		   (ignore_off || offset + len == gtrec.rm_offset)) {
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
+		if (!ignore_off)
+			gtrec.rm_offset = offset;
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
+		cur->bc_rec.r.rm_flags = flags;
+		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno, len,
+			owner, offset, flags);
+		error = xfs_btree_insert(cur, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	}
+
+	trace_xfs_rmap_map_done(mp, cur->bc_private.a.agno, bno, len,
+			unwritten, oinfo);
+out_error:
+	if (error)
+		trace_xfs_rmap_map_error(mp, cur->bc_private.a.agno,
+				error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Add a reference to an extent in the rmap btree.
+ */
 int
 xfs_rmap_alloc(
 	struct xfs_trans	*tp,
@@ -168,19 +381,22 @@ xfs_rmap_alloc(
 	struct xfs_owner_info	*oinfo)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	int			error = 0;
+	struct xfs_btree_cur	*cur;
+	int			error;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	trace_xfs_rmap_map(mp, agno, bno, len, false, oinfo);
-	if (1)
+	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+	error = xfs_rmap_map(cur, bno, len, false, oinfo);
+	if (error)
 		goto out_error;
-	trace_xfs_rmap_map_done(mp, agno, bno, len, false, oinfo);
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	return 0;
 
 out_error:
-	trace_xfs_rmap_map_error(mp, agno, error, _RET_IP_);
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7498c77..e099eda 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2551,6 +2551,8 @@ DEFINE_RMAPBT_EVENT(xfs_rmap_delete);
 DEFINE_AG_ERROR_EVENT(xfs_rmap_insert_error);
 DEFINE_AG_ERROR_EVENT(xfs_rmap_delete_error);
 DEFINE_AG_ERROR_EVENT(xfs_rmap_update_error);
+DEFINE_RMAPBT_EVENT(xfs_rmap_lookup_le_range_result);
+DEFINE_RMAPBT_EVENT(xfs_rmap_find_right_neighbor_result);
 
 #endif /* _TRACE_XFS_H */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

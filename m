Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D83E57F3F
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 08:20:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76ED6AC007
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 06:20:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qfkpCcnauXCupPYl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Sep 2014 06:20:33 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8ADKWoY007715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 09:20:33 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s8ADKWmm015976
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 09:20:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 2/5] xfs: refactor shift-by-merge into xfs_bmse_merge()
	helper
Date: Wed, 10 Sep 2014 09:20:28 -0400
Message-Id: <1410355231-50495-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1410355231-50495-1-git-send-email-bfoster@redhat.com>
References: <1410355231-50495-1-git-send-email-bfoster@redhat.com>
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

The extent shift mechanism in xfs_bmap_shift_extents() is complicated
and handles several different, non-deterministic scenarios. These
include extent shifts, extent merges and potential btree updates in
either of the former scenarios.

Refactor the code to be more linear and readable. The loop logic in
xfs_bmap_shift_extents() and some initial error checking is adjusted
slightly. The associated btree lookup and update/delete operations are
condensed into single blocks of code. This reduces the number of
btree-specific blocks and facilitates the separation of the merge
operation into a new xfs_bmse_merge() and xfs_bmse_can_merge() helpers.

This is a code refactor only. The behavior of extent shift and collapse
range is not modified.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 242 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 167 insertions(+), 75 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4b3f1b9..532c4aa 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5404,6 +5404,120 @@ error0:
 }
 
 /*
+ * Determine whether an extent shift can be accomplished by a merge with the
+ * extent that precedes the target hole of the shift.
+ */
+STATIC bool
+xfs_bmse_can_merge(
+	struct xfs_bmbt_irec	*left,	/* preceding extent */
+	struct xfs_bmbt_irec	*got,	/* current extent to shift */
+	xfs_fileoff_t		shift)	/* shift fsb */
+{
+	xfs_fileoff_t		startoff;
+
+	startoff = got->br_startoff - shift;
+
+	/*
+	 * The extent, once shifted, must be adjacent in-file and on-disk with
+	 * the preceding extent.
+	 */
+	if ((left->br_startoff + left->br_blockcount != startoff) ||
+	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
+	    (left->br_state != got->br_state) ||
+	    (left->br_blockcount + got->br_blockcount > MAXEXTLEN))
+		return false;
+
+	return true;
+}
+
+/*
+ * A bmap extent shift adjusts the file offset of an extent to fill a preceding
+ * hole in the file. If an extent shift would result in the extent being fully
+ * adjacent to the extent that currently precedes the hole, we can merge with
+ * the preceding extent rather than do the shift.
+ *
+ * This function assumes the caller has verified a shift-by-merge is possible
+ * with the provided extents via xfs_bmse_can_merge().
+ */
+STATIC int
+xfs_bmse_merge(
+	struct xfs_inode		*ip,
+	int				whichfork,
+	xfs_fileoff_t			shift,		/* shift fsb */
+	int				current_ext,	/* idx of gotp */
+	struct xfs_bmbt_rec_host	*gotp,		/* extent to shift */
+	struct xfs_bmbt_rec_host	*leftp,		/* preceding extent */
+	struct xfs_btree_cur		*cur,
+	int				*logflags)	/* output */
+{
+	struct xfs_ifork		*ifp;
+	struct xfs_bmbt_irec		got;
+	struct xfs_bmbt_irec		left;
+	xfs_filblks_t			blockcount;
+	int				error, i;
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	xfs_bmbt_get_all(gotp, &got);
+	xfs_bmbt_get_all(leftp, &left);
+	blockcount = left.br_blockcount + got.br_blockcount;
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_bmse_can_merge(&left, &got, shift));
+
+	/*
+	 * Merge the in-core extents. Note that the host record pointers and
+	 * current_ext index are invalid once the extent has been removed via
+	 * xfs_iext_remove().
+	 */
+	xfs_bmbt_set_blockcount(leftp, blockcount);
+	xfs_iext_remove(ip, current_ext, 1, 0);
+
+	/*
+	 * Update the on-disk extent count, the btree if necessary and log the
+	 * inode.
+	 */
+	XFS_IFORK_NEXT_SET(ip, whichfork,
+			   XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
+	*logflags |= XFS_ILOG_CORE;
+	if (!cur) {
+		*logflags |= XFS_ILOG_DEXT;
+		return 0;
+	}
+
+	/* lookup and remove the extent to merge */
+	error = xfs_bmbt_lookup_eq(cur, got.br_startoff, got.br_startblock,
+				   got.br_blockcount, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, out_error);
+
+	error = xfs_btree_delete(cur, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, out_error);
+
+	/* lookup and update size of the previous extent */
+	error = xfs_bmbt_lookup_eq(cur, left.br_startoff, left.br_startblock,
+				   left.br_blockcount, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, out_error);
+
+	left.br_blockcount = blockcount;
+
+	error = xfs_bmbt_update(cur, left.br_startoff, left.br_startblock,
+				left.br_blockcount, left.br_state);
+	if (error)
+		goto out_error;
+
+	return 0;
+
+out_error:
+	return error;
+}
+
+/*
  * Shift extent records to the left to cover a hole.
  *
  * The maximum number of extents to be shifted in a single operation is
@@ -5427,6 +5541,7 @@ xfs_bmap_shift_extents(
 {
 	struct xfs_btree_cur		*cur = NULL;
 	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_bmbt_rec_host	*leftp;
 	struct xfs_bmbt_irec            got;
 	struct xfs_bmbt_irec		left;
 	struct xfs_mount		*mp = ip->i_mount;
@@ -5438,7 +5553,6 @@ xfs_bmap_shift_extents(
 	int				i;
 	int				whichfork = XFS_DATA_FORK;
 	int				logflags = 0;
-	xfs_filblks_t			blockcount = 0;
 	int				total_extents;
 
 	if (unlikely(XFS_TEST_ERROR(
@@ -5464,6 +5578,13 @@ xfs_bmap_shift_extents(
 			return error;
 	}
 
+	if (ifp->if_flags & XFS_IFBROOT) {
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
+		cur->bc_private.b.firstblock = *firstblock;
+		cur->bc_private.b.flist = flist;
+		cur->bc_private.b.flags = 0;
+	}
+
 	/*
 	 * Look up the extent index for the fsb where we start shifting. We can
 	 * henceforth iterate with current_ext as extent list changes are locked
@@ -5476,14 +5597,17 @@ xfs_bmap_shift_extents(
 	gotp = xfs_iext_bno_to_ext(ifp, start_fsb, &current_ext);
 	if (!gotp) {
 		*done = 1;
-		return 0;
+		goto del_cursor;
 	}
+	xfs_bmbt_get_all(gotp, &got);
 
-	if (ifp->if_flags & XFS_IFBROOT) {
-		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.firstblock = *firstblock;
-		cur->bc_private.b.flist = flist;
-		cur->bc_private.b.flags = 0;
+	/*
+	 * If the first extent is shifted, offset_shift_fsb cannot be larger
+	 * than the starting offset of the first extent.
+	 */
+	if (current_ext == 0 && got.br_startoff < offset_shift_fsb) {
+		error = -EINVAL;
+		goto del_cursor;
 	}
 
 	/*
@@ -5493,30 +5617,41 @@ xfs_bmap_shift_extents(
 	 */
 	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
 	while (nexts++ < num_exts && current_ext < total_extents) {
-
-		gotp = xfs_iext_get_ext(ifp, current_ext);
-		xfs_bmbt_get_all(gotp, &got);
 		startoff = got.br_startoff - offset_shift_fsb;
 
-		/*
-		 * Before shifting extent into hole, make sure that the hole is
-		 * large enough to accommodate the shift.
-		 */
+		/* grab the left extent and check for a potential merge */
 		if (current_ext > 0) {
-			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, current_ext - 1),
-					 &left);
-			if (startoff < left.br_startoff + left.br_blockcount)
+			leftp = xfs_iext_get_ext(ifp, current_ext - 1);
+			xfs_bmbt_get_all(leftp, &left);
+
+			/* make sure hole is large enough for shift */
+			if (startoff < left.br_startoff + left.br_blockcount) {
 				error = -EINVAL;
-		} else if (offset_shift_fsb > got.br_startoff) {
-			/*
-			 * When first extent is shifted, offset_shift_fsb should
-			 * be less than the stating offset of the first extent.
-			 */
-			error = -EINVAL;
+				goto del_cursor;
+			}
+
+			if (xfs_bmse_can_merge(&left, &got, offset_shift_fsb)) {
+				error = xfs_bmse_merge(ip, whichfork,
+						offset_shift_fsb, current_ext, gotp,
+						leftp, cur, &logflags);
+				if (error)
+					goto del_cursor;
+
+				/*
+				 * The extent was merged so adjust the extent
+				 * index and move onto the next.
+				 */
+				current_ext--;
+				goto next;
+			}
 		}
-		if (error)
-			goto del_cursor;
 
+		/*
+		 * We didn't merge the extent so do the shift. Update the start
+		 * offset in the in-core extent and btree, if necessary.
+		 */
+		xfs_bmbt_set_startoff(gotp, startoff);
+		logflags |= XFS_ILOG_CORE;
 		if (cur) {
 			error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
 						   got.br_startblock,
@@ -5525,53 +5660,8 @@ xfs_bmap_shift_extents(
 			if (error)
 				goto del_cursor;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
-		}
-
-		/* Check if we can merge 2 adjacent extents */
-		if (current_ext &&
-		    left.br_startoff + left.br_blockcount == startoff &&
-		    left.br_startblock + left.br_blockcount ==
-				got.br_startblock &&
-		    left.br_state == got.br_state &&
-		    left.br_blockcount + got.br_blockcount <= MAXEXTLEN) {
-			blockcount = left.br_blockcount +
-				got.br_blockcount;
-			xfs_iext_remove(ip, current_ext, 1, 0);
-			logflags |= XFS_ILOG_CORE;
-			if (cur) {
-				error = xfs_btree_delete(cur, &i);
-				if (error)
-					goto del_cursor;
-				XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
-			} else {
-				logflags |= XFS_ILOG_DEXT;
-			}
-			XFS_IFORK_NEXT_SET(ip, whichfork,
-				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
-			gotp = xfs_iext_get_ext(ifp, --current_ext);
-			xfs_bmbt_get_all(gotp, &got);
-
-			/* Make cursor point to the extent we will update */
-			if (cur) {
-				error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
-							   got.br_startblock,
-							   got.br_blockcount,
-							   &i);
-				if (error)
-					goto del_cursor;
-				XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
-			}
 
-			xfs_bmbt_set_blockcount(gotp, blockcount);
-			got.br_blockcount = blockcount;
-		} else {
-			/* We have to update the startoff */
-			xfs_bmbt_set_startoff(gotp, startoff);
 			got.br_startoff = startoff;
-		}
-
-		logflags |= XFS_ILOG_CORE;
-		if (cur) {
 			error = xfs_bmbt_update(cur, got.br_startoff,
 						got.br_startblock,
 						got.br_blockcount,
@@ -5582,18 +5672,20 @@ xfs_bmap_shift_extents(
 			logflags |= XFS_ILOG_DEXT;
 		}
 
-		current_ext++;
+next:
+		/* update total extent count and grab the next record */
 		total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
+		if (++current_ext >= total_extents)
+			break;
+		gotp = xfs_iext_get_ext(ifp, current_ext);
+		xfs_bmbt_get_all(gotp, &got);
 	}
 
 	/* Check if we are done */
 	if (current_ext == total_extents)
 		*done = 1;
-	else if (next_fsb) {
-		gotp = xfs_iext_get_ext(ifp, current_ext);
-		xfs_bmbt_get_all(gotp, &got);
+	else if (next_fsb)
 		*next_fsb = got.br_startoff;
-	}
 
 del_cursor:
 	if (cur)
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

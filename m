Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6BE4E7F58
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 08:20:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CF63AAC00A
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 06:20:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 46w0l9aFg2sVLoeI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Sep 2014 06:20:33 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8ADKWBe001676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 09:20:32 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s8ADKW3Z015982
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 09:20:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 3/5] xfs: refactor single extent shift into
	xfs_bmse_shift_one() helper
Date: Wed, 10 Sep 2014 09:20:29 -0400
Message-Id: <1410355231-50495-4-git-send-email-bfoster@redhat.com>
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

xfs_bmap_shift_extents() has a variety of conditions and error checks
that make the logic difficult to follow and indent heavy. Refactor the
loop body of this function into a new xfs_bmse_shift_one() helper. This
simplifies the error checks, eliminates index decrement on merge hack by
pushing the index increment down into the helper, and makes the code
more readable by reducing multiple levels of indentation.

This is a code refactor only. The behavior of extent shift and collapse
range is not modified.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 164 ++++++++++++++++++++++++++---------------------
 1 file changed, 91 insertions(+), 73 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 532c4aa..69bf8d8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5518,6 +5518,88 @@ out_error:
 }
 
 /*
+ * Shift a single extent.
+ */
+STATIC int
+xfs_bmse_shift_one(
+	struct xfs_inode		*ip,
+	int				whichfork,
+	xfs_fileoff_t			offset_shift_fsb,
+	int				*current_ext,
+	struct xfs_bmbt_rec_host	*gotp,
+	struct xfs_btree_cur		*cur,
+	int				*logflags)
+{
+	struct xfs_ifork		*ifp;
+	xfs_fileoff_t			startoff;
+	struct xfs_bmbt_rec_host	*leftp;
+	struct xfs_bmbt_irec		got;
+	struct xfs_bmbt_irec		left;
+	int				error;
+	int				i;
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+
+	xfs_bmbt_get_all(gotp, &got);
+	startoff = got.br_startoff - offset_shift_fsb;
+
+	/*
+	 * If this is the first extent in the file, make sure there's enough
+	 * room at the start of the file and jump right to the shift as there's
+	 * no left extent to merge.
+	 */
+	if (*current_ext == 0) {
+		if (got.br_startoff < offset_shift_fsb)
+			return -EINVAL;
+		goto shift_extent;
+	}
+
+	/* grab the left extent and check for a large enough hole */
+	leftp = xfs_iext_get_ext(ifp, *current_ext - 1);
+	xfs_bmbt_get_all(leftp, &left);
+
+	if (startoff < left.br_startoff + left.br_blockcount)
+		return -EINVAL;
+
+	/* check whether to merge the extent or shift it down */
+	if (!xfs_bmse_can_merge(&left, &got, offset_shift_fsb))
+		goto shift_extent;
+
+	return xfs_bmse_merge(ip, whichfork, offset_shift_fsb, *current_ext,
+			      gotp, leftp, cur, logflags);
+
+shift_extent:
+	/*
+	 * Increment the extent index for the next iteration, update the start
+	 * offset of the in-core extent and update the btree if applicable.
+	 */
+	(*current_ext)++;
+	xfs_bmbt_set_startoff(gotp, startoff);
+	*logflags |= XFS_ILOG_CORE;
+	if (!cur) {
+		*logflags |= XFS_ILOG_DEXT;
+		return 0;
+	}
+
+	error = xfs_bmbt_lookup_eq(cur, got.br_startoff, got.br_startblock,
+				   got.br_blockcount, &i);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, out_error);
+
+	got.br_startoff = startoff;
+	error = xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
+				got.br_blockcount, got.br_state);
+	if (error)
+		return error;
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
@@ -5541,16 +5623,12 @@ xfs_bmap_shift_extents(
 {
 	struct xfs_btree_cur		*cur = NULL;
 	struct xfs_bmbt_rec_host	*gotp;
-	struct xfs_bmbt_rec_host	*leftp;
 	struct xfs_bmbt_irec            got;
-	struct xfs_bmbt_irec		left;
 	struct xfs_mount		*mp = ip->i_mount;
 	struct xfs_ifork		*ifp;
 	xfs_extnum_t			nexts = 0;
 	xfs_extnum_t			current_ext;
-	xfs_fileoff_t			startoff;
 	int				error = 0;
-	int				i;
 	int				whichfork = XFS_DATA_FORK;
 	int				logflags = 0;
 	int				total_extents;
@@ -5599,16 +5677,6 @@ xfs_bmap_shift_extents(
 		*done = 1;
 		goto del_cursor;
 	}
-	xfs_bmbt_get_all(gotp, &got);
-
-	/*
-	 * If the first extent is shifted, offset_shift_fsb cannot be larger
-	 * than the starting offset of the first extent.
-	 */
-	if (current_ext == 0 && got.br_startoff < offset_shift_fsb) {
-		error = -EINVAL;
-		goto del_cursor;
-	}
 
 	/*
 	 * There may be delalloc extents in the data fork before the range we
@@ -5617,75 +5685,25 @@ xfs_bmap_shift_extents(
 	 */
 	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
 	while (nexts++ < num_exts && current_ext < total_extents) {
-		startoff = got.br_startoff - offset_shift_fsb;
-
-		/* grab the left extent and check for a potential merge */
-		if (current_ext > 0) {
-			leftp = xfs_iext_get_ext(ifp, current_ext - 1);
-			xfs_bmbt_get_all(leftp, &left);
-
-			/* make sure hole is large enough for shift */
-			if (startoff < left.br_startoff + left.br_blockcount) {
-				error = -EINVAL;
-				goto del_cursor;
-			}
-
-			if (xfs_bmse_can_merge(&left, &got, offset_shift_fsb)) {
-				error = xfs_bmse_merge(ip, whichfork,
-						offset_shift_fsb, current_ext, gotp,
-						leftp, cur, &logflags);
-				if (error)
-					goto del_cursor;
-
-				/*
-				 * The extent was merged so adjust the extent
-				 * index and move onto the next.
-				 */
-				current_ext--;
-				goto next;
-			}
-		}
-
-		/*
-		 * We didn't merge the extent so do the shift. Update the start
-		 * offset in the in-core extent and btree, if necessary.
-		 */
-		xfs_bmbt_set_startoff(gotp, startoff);
-		logflags |= XFS_ILOG_CORE;
-		if (cur) {
-			error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
-						   got.br_startblock,
-						   got.br_blockcount,
-						   &i);
-			if (error)
-				goto del_cursor;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
-
-			got.br_startoff = startoff;
-			error = xfs_bmbt_update(cur, got.br_startoff,
-						got.br_startblock,
-						got.br_blockcount,
-						got.br_state);
-			if (error)
-				goto del_cursor;
-		} else {
-			logflags |= XFS_ILOG_DEXT;
-		}
+		error = xfs_bmse_shift_one(ip, whichfork, offset_shift_fsb,
+					&current_ext, gotp, cur, &logflags);
+		if (error)
+			goto del_cursor;
 
-next:
 		/* update total extent count and grab the next record */
 		total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
-		if (++current_ext >= total_extents)
+		if (current_ext >= total_extents)
 			break;
 		gotp = xfs_iext_get_ext(ifp, current_ext);
-		xfs_bmbt_get_all(gotp, &got);
 	}
 
 	/* Check if we are done */
-	if (current_ext == total_extents)
+	if (current_ext == total_extents) {
 		*done = 1;
-	else if (next_fsb)
+	} else if (next_fsb) {
+		xfs_bmbt_get_all(gotp, &got);
 		*next_fsb = got.br_startoff;
+	}
 
 del_cursor:
 	if (cur)
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

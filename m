Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A1BDB7F50
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 08:20:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 736EF304053
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 06:20:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id N9uQdvPMyHNeDF5Z (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Sep 2014 06:20:33 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8ADKWxQ030991
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 09:20:32 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s8ADKW38015979
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 09:20:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 1/5] xfs: track collapse via file offset rather than extent
	index
Date: Wed, 10 Sep 2014 09:20:27 -0400
Message-Id: <1410355231-50495-2-git-send-email-bfoster@redhat.com>
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

The collapse range implementation uses a transaction per extent shift.
The progress of the overall operation is tracked via the current extent
index of the in-core extent list. This is racy because the ilock must be
dropped and reacquired for each transaction according to locking and log
reservation rules. Therefore, writeback to prior regions of the file is
possible and can change the extent count. This changes the extent to
which the current index refers and causes the collapse to fail mid
operation. To avoid this problem, the entire file is currently written
back before the collapse operation starts.

To eliminate the need to flush the entire file, use the file offset
(fsb) to track the progress of the overall extent shift operation rather
than the extent index. Modify xfs_bmap_shift_extents() to
unconditionally convert the start_fsb parameter to an extent index and
return the file offset of the extent where the shift left off, if
further extents exist. The bulk of ths function can remain based on
extent index as ilock is held by the caller. xfs_collapse_file_space()
now uses the fsb output as the starting point for the subsequent shift.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 85 +++++++++++++++++++++++++-----------------------
 fs/xfs/libxfs/xfs_bmap.h |  7 ++--
 fs/xfs/xfs_bmap_util.c   | 12 +++----
 3 files changed, 53 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 86df952..4b3f1b9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5406,20 +5406,21 @@ error0:
 /*
  * Shift extent records to the left to cover a hole.
  *
- * The maximum number of extents to be shifted in a single operation
- * is @num_exts, and @current_ext keeps track of the current extent
- * index we have shifted. @offset_shift_fsb is the length by which each
- * extent is shifted. If there is no hole to shift the extents
- * into, this will be considered invalid operation and we abort immediately.
+ * The maximum number of extents to be shifted in a single operation is
+ * @num_exts. @start_fsb specifies the file offset to start the shift and the
+ * file offset where we've left off is returned in @next_fsb. @offset_shift_fsb
+ * is the length by which each extent is shifted. If there is no hole to shift
+ * the extents into, this will be considered invalid operation and we abort
+ * immediately.
  */
 int
 xfs_bmap_shift_extents(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
-	int			*done,
 	xfs_fileoff_t		start_fsb,
 	xfs_fileoff_t		offset_shift_fsb,
-	xfs_extnum_t		*current_ext,
+	int			*done,
+	xfs_fileoff_t		*next_fsb,
 	xfs_fsblock_t		*firstblock,
 	struct xfs_bmap_free	*flist,
 	int			num_exts)
@@ -5431,6 +5432,7 @@ xfs_bmap_shift_extents(
 	struct xfs_mount		*mp = ip->i_mount;
 	struct xfs_ifork		*ifp;
 	xfs_extnum_t			nexts = 0;
+	xfs_extnum_t			current_ext;
 	xfs_fileoff_t			startoff;
 	int				error = 0;
 	int				i;
@@ -5451,7 +5453,8 @@ xfs_bmap_shift_extents(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ASSERT(current_ext != NULL);
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
@@ -5462,20 +5465,18 @@ xfs_bmap_shift_extents(
 	}
 
 	/*
-	 * If *current_ext is 0, we would need to lookup the extent
-	 * from where we would start shifting and store it in gotp.
+	 * Look up the extent index for the fsb where we start shifting. We can
+	 * henceforth iterate with current_ext as extent list changes are locked
+	 * out via ilock.
+	 *
+	 * gotp can be null in 2 cases: 1) if there are no extents or 2)
+	 * start_fsb lies in a hole beyond which there are no extents. Either
+	 * way, we are done.
 	 */
-	if (!*current_ext) {
-		gotp = xfs_iext_bno_to_ext(ifp, start_fsb, current_ext);
-		/*
-		 * gotp can be null in 2 cases: 1) if there are no extents
-		 * or 2) start_fsb lies in a hole beyond which there are
-		 * no extents. Either way, we are done.
-		 */
-		if (!gotp) {
-			*done = 1;
-			return 0;
-		}
+	gotp = xfs_iext_bno_to_ext(ifp, start_fsb, &current_ext);
+	if (!gotp) {
+		*done = 1;
+		return 0;
 	}
 
 	if (ifp->if_flags & XFS_IFBROOT) {
@@ -5487,36 +5488,32 @@ xfs_bmap_shift_extents(
 
 	/*
 	 * There may be delalloc extents in the data fork before the range we
-	 * are collapsing out, so we cannot
-	 * use the count of real extents here. Instead we have to calculate it
-	 * from the incore fork.
+	 * are collapsing out, so we cannot use the count of real extents here.
+	 * Instead we have to calculate it from the incore fork.
 	 */
 	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
-	while (nexts++ < num_exts && *current_ext < total_extents) {
+	while (nexts++ < num_exts && current_ext < total_extents) {
 
-		gotp = xfs_iext_get_ext(ifp, *current_ext);
+		gotp = xfs_iext_get_ext(ifp, current_ext);
 		xfs_bmbt_get_all(gotp, &got);
 		startoff = got.br_startoff - offset_shift_fsb;
 
 		/*
-		 * Before shifting extent into hole, make sure that the hole
-		 * is large enough to accomodate the shift.
+		 * Before shifting extent into hole, make sure that the hole is
+		 * large enough to accommodate the shift.
 		 */
-		if (*current_ext) {
-			xfs_bmbt_get_all(xfs_iext_get_ext(ifp,
-						*current_ext - 1), &left);
-
+		if (current_ext > 0) {
+			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, current_ext - 1),
+					 &left);
 			if (startoff < left.br_startoff + left.br_blockcount)
 				error = -EINVAL;
 		} else if (offset_shift_fsb > got.br_startoff) {
 			/*
-			 * When first extent is shifted, offset_shift_fsb
-			 * should be less than the stating offset of
-			 * the first extent.
+			 * When first extent is shifted, offset_shift_fsb should
+			 * be less than the stating offset of the first extent.
 			 */
 			error = -EINVAL;
 		}
-
 		if (error)
 			goto del_cursor;
 
@@ -5531,7 +5528,7 @@ xfs_bmap_shift_extents(
 		}
 
 		/* Check if we can merge 2 adjacent extents */
-		if (*current_ext &&
+		if (current_ext &&
 		    left.br_startoff + left.br_blockcount == startoff &&
 		    left.br_startblock + left.br_blockcount ==
 				got.br_startblock &&
@@ -5539,7 +5536,7 @@ xfs_bmap_shift_extents(
 		    left.br_blockcount + got.br_blockcount <= MAXEXTLEN) {
 			blockcount = left.br_blockcount +
 				got.br_blockcount;
-			xfs_iext_remove(ip, *current_ext, 1, 0);
+			xfs_iext_remove(ip, current_ext, 1, 0);
 			logflags |= XFS_ILOG_CORE;
 			if (cur) {
 				error = xfs_btree_delete(cur, &i);
@@ -5551,7 +5548,7 @@ xfs_bmap_shift_extents(
 			}
 			XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
-			gotp = xfs_iext_get_ext(ifp, --*current_ext);
+			gotp = xfs_iext_get_ext(ifp, --current_ext);
 			xfs_bmbt_get_all(gotp, &got);
 
 			/* Make cursor point to the extent we will update */
@@ -5585,13 +5582,18 @@ xfs_bmap_shift_extents(
 			logflags |= XFS_ILOG_DEXT;
 		}
 
-		(*current_ext)++;
+		current_ext++;
 		total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
 	}
 
 	/* Check if we are done */
-	if (*current_ext == total_extents)
+	if (current_ext == total_extents)
 		*done = 1;
+	else if (next_fsb) {
+		gotp = xfs_iext_get_ext(ifp, current_ext);
+		xfs_bmbt_get_all(gotp, &got);
+		*next_fsb = got.br_startoff;
+	}
 
 del_cursor:
 	if (cur)
@@ -5600,5 +5602,6 @@ del_cursor:
 
 	if (logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
+
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b879ca5..44db6db 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -178,9 +178,8 @@ int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
 		xfs_extnum_t num);
 uint	xfs_default_attroffset(struct xfs_inode *ip);
 int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
-		int *done, xfs_fileoff_t start_fsb,
-		xfs_fileoff_t offset_shift_fsb, xfs_extnum_t *current_ext,
-		xfs_fsblock_t *firstblock, struct xfs_bmap_free	*flist,
-		int num_exts);
+		xfs_fileoff_t start_fsb, xfs_fileoff_t offset_shift_fsb,
+		int *done, xfs_fileoff_t *next_fsb, xfs_fsblock_t *firstblock,
+		struct xfs_bmap_free *flist, int num_exts);
 
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 1707980..1e96d77 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1456,18 +1456,18 @@ xfs_collapse_file_space(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	int			error;
-	xfs_extnum_t		current_ext = 0;
 	struct xfs_bmap_free	free_list;
 	xfs_fsblock_t		first_block;
 	int			committed;
 	xfs_fileoff_t		start_fsb;
+	xfs_fileoff_t		next_fsb;
 	xfs_fileoff_t		shift_fsb;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 
 	trace_xfs_collapse_file_space(ip);
 
-	start_fsb = XFS_B_TO_FSB(mp, offset + len);
+	next_fsb = XFS_B_TO_FSB(mp, offset + len);
 	shift_fsb = XFS_B_TO_FSB(mp, len);
 
 	/*
@@ -1525,10 +1525,10 @@ xfs_collapse_file_space(
 		 * We are using the write transaction in which max 2 bmbt
 		 * updates are allowed
 		 */
-		error = xfs_bmap_shift_extents(tp, ip, &done, start_fsb,
-					       shift_fsb, &current_ext,
-					       &first_block, &free_list,
-					       XFS_BMAP_MAX_SHIFT_EXTENTS);
+		start_fsb = next_fsb;
+		error = xfs_bmap_shift_extents(tp, ip, start_fsb, shift_fsb,
+				&done, &next_fsb, &first_block, &free_list,
+				XFS_BMAP_MAX_SHIFT_EXTENTS);
 		if (error)
 			goto out;
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

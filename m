Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2M5FmMN180527 for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 00:15:48 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KF7VIvgHLKiYGOCh for <xfs@oss.sgi.com>;
	Wed, 21 Mar 2012 22:15:46 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SAaNE-000360-2P
	for xfs@oss.sgi.com; Thu, 22 Mar 2012 16:15:44 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SAaMw-0000Wg-Kq
	for xfs@oss.sgi.com; Thu, 22 Mar 2012 16:15:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] xfs: fix fstrim offset calculations
Date: Thu, 22 Mar 2012 16:15:12 +1100
Message-Id: <1332393313-1955-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1332393313-1955-1-git-send-email-david@fromorbit.com>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

xfs_ioc_fstrim() doesn't treat the incoming offset and length
correctly. It treats them as a filesystem block address, rather than
a disk address. This is wrong because the range passed in is a
linear representation , while the filesystem block address notiation
is a sparse representation. Hence we cannot convert the range direct
to filesystem block units and then use that for calculating the
range to trim.

While this sounds dangerous, the problem is limited to calculting
what AGs need to be trimmed. The code that calcuates the actual
ranges to trim gets the right result (i.e. only ever discards free
space), even though it uses the wrong ranges to limit what is
trimmed. Hence this is not a bug that endangers user data.

Fix this by treating the range as a disk address range and use the
appropriate functions to convert the range into the desired formats
for calculations.

Further, fix the first free extent lookup (the longest) to actually
find the largest free extent. Currently this lookup uses a <=
lookup, which results in finding the extent to the left of the
largest because we can never get an exact match on the largest
extent. This is due to the fact that while we know it's size, we
don't know it's location and so the exact match fails and we move
one record to the left to get the next largest extent. Instead, use
a >= search so that the lookup returns the largest extent regardless
of the fact we don't get an exact match on it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c   |    2 +-
 fs/xfs/xfs_alloc.h   |    7 +++++
 fs/xfs/xfs_discard.c |   61 +++++++++++++++++++++++++++++++------------------
 3 files changed, 46 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 31e9033..0f0df27 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -69,7 +69,7 @@ xfs_alloc_lookup_eq(
  * Lookup the first record greater than or equal to [bno, len]
  * in the btree given by cur.
  */
-STATIC int				/* error */
+int				/* error */
 xfs_alloc_lookup_ge(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		bno,	/* starting block of extent */
diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index ab5d0fd..3a7e7d8 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -248,6 +248,13 @@ xfs_alloc_lookup_le(
 	xfs_extlen_t		len,	/* length of extent */
 	int			*stat);	/* success/failure */
 
+int				/* error */
+xfs_alloc_lookup_ge(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	int			*stat);	/* success/failure */
+
 int					/* error */
 xfs_alloc_get_rec(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 286a051..1ad3a4b 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -37,9 +37,9 @@ STATIC int
 xfs_trim_extents(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
-	xfs_fsblock_t		start,
-	xfs_fsblock_t		end,
-	xfs_fsblock_t		minlen,
+	xfs_daddr_t		start,
+	xfs_daddr_t		end,
+	xfs_daddr_t		minlen,
 	__uint64_t		*blocks_trimmed)
 {
 	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
@@ -67,7 +67,7 @@ xfs_trim_extents(
 	/*
 	 * Look up the longest btree in the AGF and start with it.
 	 */
-	error = xfs_alloc_lookup_le(cur, 0,
+	error = xfs_alloc_lookup_ge(cur, 0,
 			    be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest), &i);
 	if (error)
 		goto out_del_cursor;
@@ -77,8 +77,10 @@ xfs_trim_extents(
 	 * enough to be worth discarding.
 	 */
 	while (i) {
-		xfs_agblock_t fbno;
-		xfs_extlen_t flen;
+		xfs_agblock_t	fbno;
+		xfs_extlen_t	flen;
+		xfs_daddr_t	dbno;
+		xfs_extlen_t	dlen;
 
 		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
 		if (error)
@@ -87,9 +89,17 @@ xfs_trim_extents(
 		ASSERT(flen <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest));
 
 		/*
+		 * use daddr format for all range/len calculations as that is
+		 * the format the range/len variables are supplied in by
+		 * userspace.
+		 */
+		dbno = XFS_AGB_TO_DADDR(mp, agno, fbno);
+		dlen = XFS_FSB_TO_BB(mp, flen);
+
+		/*
 		 * Too small?  Give up.
 		 */
-		if (flen < minlen) {
+		if (dlen < minlen) {
 			trace_xfs_discard_toosmall(mp, agno, fbno, flen);
 			goto out_del_cursor;
 		}
@@ -99,8 +109,7 @@ xfs_trim_extents(
 		 * supposed to discard skip it.  Do not bother to trim
 		 * down partially overlapping ranges for now.
 		 */
-		if (XFS_AGB_TO_FSB(mp, agno, fbno) + flen < start ||
-		    XFS_AGB_TO_FSB(mp, agno, fbno) > end) {
+		if (dbno + dlen < start || dbno > end) {
 			trace_xfs_discard_exclude(mp, agno, fbno, flen);
 			goto next_extent;
 		}
@@ -115,10 +124,7 @@ xfs_trim_extents(
 		}
 
 		trace_xfs_discard_extent(mp, agno, fbno, flen);
-		error = -blkdev_issue_discard(bdev,
-				XFS_AGB_TO_DADDR(mp, agno, fbno),
-				XFS_FSB_TO_BB(mp, flen),
-				GFP_NOFS, 0);
+		error = -blkdev_issue_discard(bdev, dbno, dlen, GFP_NOFS, 0);
 		if (error)
 			goto out_del_cursor;
 		*blocks_trimmed += flen;
@@ -137,6 +143,15 @@ out_put_perag:
 	return error;
 }
 
+/*
+ * trim a range of the filesystem.
+ *
+ * Note: the parameters passed from userspace are byte ranges into the
+ * filesystem which does not match to the format we use for filesystem block
+ * addressing. FSB addressing is sparse (AGNO|AGBNO), while the incoming format
+ * is a linear address range. Hence we need to use DADDR based conversions and
+ * comparisons for determining the correct offset and regions to trim.
+ */
 int
 xfs_ioc_trim(
 	struct xfs_mount		*mp,
@@ -145,7 +160,7 @@ xfs_ioc_trim(
 	struct request_queue	*q = mp->m_ddev_targp->bt_bdev->bd_disk->queue;
 	unsigned int		granularity = q->limits.discard_granularity;
 	struct fstrim_range	range;
-	xfs_fsblock_t		start, end, minlen;
+	xfs_daddr_t		start, end, minlen;
 	xfs_agnumber_t		start_agno, end_agno, agno;
 	__uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
@@ -159,22 +174,22 @@ xfs_ioc_trim(
 
 	/*
 	 * Truncating down the len isn't actually quite correct, but using
-	 * XFS_B_TO_FSB would mean we trivially get overflows for values
+	 * BBTOB would mean we trivially get overflows for values
 	 * of ULLONG_MAX or slightly lower.  And ULLONG_MAX is the default
 	 * used by the fstrim application.  In the end it really doesn't
 	 * matter as trimming blocks is an advisory interface.
 	 */
-	start = XFS_B_TO_FSBT(mp, range.start);
-	end = start + XFS_B_TO_FSBT(mp, range.len) - 1;
-	minlen = XFS_B_TO_FSB(mp, max_t(u64, granularity, range.minlen));
+	start = BTOBB(range.start);
+	end = start + BTOBBT(range.len) - 1;
+	minlen = BTOBB(max_t(u64, granularity, range.minlen));
 
-	if (start >= mp->m_sb.sb_dblocks)
+	if (XFS_BB_TO_FSB(mp, start) >= mp->m_sb.sb_dblocks)
 		return -XFS_ERROR(EINVAL);
-	if (end > mp->m_sb.sb_dblocks - 1)
-		end = mp->m_sb.sb_dblocks - 1;
+	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
+		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)- 1;
 
-	start_agno = XFS_FSB_TO_AGNO(mp, start);
-	end_agno = XFS_FSB_TO_AGNO(mp, end);
+	start_agno = xfs_daddr_to_agno(mp, start);
+	end_agno = xfs_daddr_to_agno(mp, end);
 
 	for (agno = start_agno; agno <= end_agno; agno++) {
 		error = -xfs_trim_extents(mp, agno, start, end, minlen,
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

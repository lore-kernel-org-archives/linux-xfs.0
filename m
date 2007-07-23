Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jul 2007 19:29:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6N2TYbm013322
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 19:29:39 -0700
Date: Mon, 23 Jul 2007 12:29:30 +1000
From: David Chinner <dgc@sgi.com>
Subject: RFC: delalloc vs truncate race overflows transaction reservation
Message-ID: <20070723022930.GW12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


Last week while testing the demand reaping of the filestreams
objects, I had my test system fail repeatedly in test 167 with a
transaction reservation overrun assert failure.  The failure occurs
in xfs_trans_mod_sb() in the xfs_iomap_write_allocate() path.

The issue appears to be that in xfs_iomap(), we call xfs_bmapi()
to map the current extent over the range of of the request. This
returns a delalloc extent of X blocks, and then we call into
xfs_iomap_write_allocate() to do the allocation.

The problem here is that we drop the ILOCK between the first
mapping and the allocation. We have to drop it because we need
to start a transaction for the allocation. The result is that
the map can change when we drop the lock and so the range
we have in the map may be longer than the remaining delalloc
extent.

Basically, the only part of the delalloc extent that we originally
mapped that we can rely on being unchanged is the part that
spans the page we currently have locked under writeback. Hence
if we race with a truncate that starts before the page we are
writing back, the truncate gets blocked on this page until writeback
completes.

The problem arises if the truncate starts after the page we have
mapped but starts in the same extent. This converts part of the
range we mapped as delalloc into a hole and removes the space
reservation we had for this range.

As a result when we now try to do the delalloc, we end up with it
being split into two allocations. The first converts the delalloc
extent, the second allocates from the hole.

Because we are doing delalloc here, we don't take a transaction
reservation for the data blocks we are allocating, hence any
allocation that hits a hole will require blocks that we haven't
reserved. This is the case that leads to a transaction reservation
overrun and an assert failure.

The problem is due to the fact we pass xfs_bmapi two maps to the
allocate transaction. This means that the delalloc transaction can
allocate two extents in the one xfs_bmapi call. As a result, if
the delalloc extent is truncated, we will always try to allocate
a second extent within xfs_bmapi() without checking if it is needed.

The fix to this problem is to check ever allocated extent to see if
it spans the range we need allocated. If the extent does span the
range or part of the range, we should return that extent to the
caller straight away. We can only return a  single extent to the
caller, so allocating past what we can return is not necessary.

IOWs, if we pass a single map into the xfs_bmapi() call, we will
be able to check every single extent that is allocated and return
a good map prior to allocating into a hole with a reservation.

The patch below does this.

The question is - is there a another and/or better way to fix this?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_iomap.c |   75 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 25 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_iomap.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iomap.c	2007-07-16 20:32:59.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iomap.c	2007-07-19 22:28:11.670381107 +1000
@@ -728,6 +728,9 @@ retry:
  * the originating callers request.
  *
  * Called without a lock on the inode.
+ *
+ * We no longer bother to look at the incoming map - all we have to
+ * guarantee is that whatever we allocate fills the required range.
  */
 int
 xfs_iomap_write_allocate(
@@ -744,9 +747,9 @@ xfs_iomap_write_allocate(
 	xfs_fsblock_t	first_block;
 	xfs_bmap_free_t	free_list;
 	xfs_filblks_t	count_fsb;
-	xfs_bmbt_irec_t	imap[XFS_STRAT_WRITE_IMAPS];
+	xfs_bmbt_irec_t	imap;
 	xfs_trans_t	*tp;
-	int		i, nimaps, committed;
+	int		nimaps, committed;
 	int		error = 0;
 	int		nres;
 
@@ -793,13 +796,38 @@ xfs_iomap_write_allocate(
 
 			XFS_BMAP_INIT(&free_list, &first_block);
 
-			nimaps = XFS_STRAT_WRITE_IMAPS;
 			/*
-			 * Ensure we don't go beyond eof - it is possible
-			 * the extents changed since we did the read call,
-			 * we dropped the ilock in the interim.
+			 * it is possible that the extents have changed since
+			 * we did the read call as we dropped the ilock for a
+			 * while. We have to be careful about truncates or hole
+			 * punchs here - we are not allowed to allocate
+			 * non-delalloc blocks here.
+			 *
+			 * The only protection against truncation is the pages
+			 * for the range we are being asked to convert are
+			 * locked and hence a truncate will block on them
+			 * first.
+			 *
+			 * As a result, if we go beyond the range we really
+			 * need and hit an delalloc extent boundary followed by
+			 * a hole while we have excess blocks in the map, we
+			 * will fill the hole incorrectly and overrun the
+			 * transaction reservation.
+			 *
+			 * Using a single map prevents this as we are forced to
+			 * check each map we look for overlap with the desired
+			 * range and abort as soon as we find it. Also, given
+			 * that we only return a single map, having one beyond
+			 * what we can return is probably a bit silly.
+			 *
+			 * We also need to check that we don't go beyond EOF;
+			 * this is a truncate optimisation as a truncate sets
+			 * the new file size before block on the pages we
+			 * currently have locked under writeback. Because they
+			 * are about to be tossed, we don't need to write them
+			 * back....
 			 */
-
+			nimaps = 1;
 			end_fsb = XFS_B_TO_FSB(mp, ip->i_size);
 			xfs_bmap_last_offset(NULL, ip, &last_block,
 				XFS_DATA_FORK);
@@ -815,7 +843,7 @@ xfs_iomap_write_allocate(
 			/* Go get the actual blocks */
 			error = XFS_BMAPI(mp, tp, io, map_start_fsb, count_fsb,
 					XFS_BMAPI_WRITE, &first_block, 1,
-					imap, &nimaps, &free_list, NULL);
+					&imap, &nimaps, &free_list, NULL);
 			if (error)
 				goto trans_cancel;
 
@@ -834,27 +862,24 @@ xfs_iomap_write_allocate(
 		 * See if we were able to allocate an extent that
 		 * covers at least part of the callers request
 		 */
-		for (i = 0; i < nimaps; i++) {
-			if (unlikely(!imap[i].br_startblock &&
-				     !(io->io_flags & XFS_IOCORE_RT)))
-				return xfs_cmn_err_fsblock_zero(ip, &imap[i]);
-			if ((offset_fsb >= imap[i].br_startoff) &&
-			    (offset_fsb < (imap[i].br_startoff +
-					   imap[i].br_blockcount))) {
-				*map = imap[i];
-				*retmap = 1;
-				XFS_STATS_INC(xs_xstrat_quick);
-				return 0;
-			}
-			count_fsb -= imap[i].br_blockcount;
+		if (unlikely(!imap.br_startblock &&
+			     !(io->io_flags & XFS_IOCORE_RT)))
+			return xfs_cmn_err_fsblock_zero(ip, &imap);
+		if ((offset_fsb >= imap.br_startoff) &&
+		    (offset_fsb < (imap.br_startoff +
+				   imap.br_blockcount))) {
+			*map = imap;
+			*retmap = 1;
+			XFS_STATS_INC(xs_xstrat_quick);
+			return 0;
 		}
 
-		/* So far we have not mapped the requested part of the
+		/*
+		 * So far we have not mapped the requested part of the
 		 * file, just surrounding data, try again.
 		 */
-		nimaps--;
-		map_start_fsb = imap[nimaps].br_startoff +
-				imap[nimaps].br_blockcount;
+		count_fsb -= imap.br_blockcount;
+		map_start_fsb = imap.br_startoff + imap.br_blockcount;
 	}
 
 trans_cancel:

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727363AbfAQTUI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jan 2019 14:20:08 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C28B461F8
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jan 2019 19:20:07 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CE8D600C6
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jan 2019 19:20:07 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 5/5] xfs: revalidate imap properly before writeback delalloc conversion
Date: Thu, 17 Jan 2019 14:20:04 -0500
Message-Id: <20190117192004.49346-6-bfoster@redhat.com>
In-Reply-To: <20190117192004.49346-1-bfoster@redhat.com>
References: <20190117192004.49346-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The writeback delalloc conversion code has a couple historical hacks
to help deal with racing with other operations on the file under
writeback. For example, xfs_iomap_write_allocate() checks i_size
once under ilock to determine whether a truncate may have
invalidated some portion of the range we're about to map. This helps
prevent the bmapi call from doing physical allocation where only
delalloc conversion was expected (which is a transaction reservation
overrun vector). XFS_BMAPI_DELALLOC helps similarly protect us from
this problem as it ensures that the bmapi call will only convert
existing blocks.

Neither of these actually ensure we actually pass a valid range to
convert to xfs_bmapi_write(). The bmapi flag turns the
aforementioned physical allocation over a hole problem into an
explicit error, which means that any particular instances of that
problem change from being a transaction overrun error to a writeback
error. The latter means page discard, which is an ominous error even
if due to the underlying block(s) being punched out.

Now that we have a mechanism in place to track inode fork changes,
use it in xfs_iomap_write_allocate() to properly handle potential
changes to the cached writeback mapping and establish a valid range
to map. Check the already provided fork seqno once under ilock. If
it has changed, look up the extent again in the associated fork and
trim the caller's mapping to the latest version. We can expect to
still find the blocks backing the current file offset because the
page is held locked during writeback and page cache truncation
acquires the page lock and waits on writeback to complete before it
can toss the page. This ensures that writeback never attempts to map
a range of a file that has been punched out and never submits I/O to
blocks that are no longer mapped to the file.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 102 +++++++++++++++++++--------------------------
 1 file changed, 44 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ab69caa685b4..80da465ebf7a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -677,22 +677,24 @@ xfs_file_iomap_begin_delay(
  */
 int
 xfs_iomap_write_allocate(
-	xfs_inode_t	*ip,
-	int		whichfork,
-	xfs_off_t	offset,
-	xfs_bmbt_irec_t *imap,
-	unsigned int	*seq)
+	struct xfs_inode	*ip,
+	int			whichfork,
+	xfs_off_t		offset,
+	struct xfs_bmbt_irec	*imap,
+	unsigned int		*seq)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
-	xfs_fileoff_t	offset_fsb, last_block;
-	xfs_fileoff_t	end_fsb, map_start_fsb;
-	xfs_filblks_t	count_fsb;
-	xfs_trans_t	*tp;
-	int		nimaps;
-	int		error = 0;
-	int		flags = XFS_BMAPI_DELALLOC;
-	int		nres;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_trans	*tp;
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	timap;
+	xfs_fileoff_t		offset_fsb;
+	xfs_fileoff_t		map_start_fsb;
+	xfs_filblks_t		count_fsb;
+	int			nimaps;
+	int			error = 0;
+	int			flags = XFS_BMAPI_DELALLOC;
+	int			nres;
 
 	if (whichfork == XFS_COW_FORK)
 		flags |= XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
@@ -737,56 +739,40 @@ xfs_iomap_write_allocate(
 			xfs_trans_ijoin(tp, ip, 0);
 
 			/*
-			 * it is possible that the extents have changed since
-			 * we did the read call as we dropped the ilock for a
-			 * while. We have to be careful about truncates or hole
-			 * punchs here - we are not allowed to allocate
-			 * non-delalloc blocks here.
-			 *
-			 * The only protection against truncation is the pages
-			 * for the range we are being asked to convert are
-			 * locked and hence a truncate will block on them
-			 * first.
-			 *
-			 * As a result, if we go beyond the range we really
-			 * need and hit an delalloc extent boundary followed by
-			 * a hole while we have excess blocks in the map, we
-			 * will fill the hole incorrectly and overrun the
-			 * transaction reservation.
+			 * Now that we have ILOCK we must account for the fact
+			 * that the fork (and thus our mapping) could have
+			 * changed while the inode was unlocked. If the fork
+			 * has changed, trim the caller's mapping to the
+			 * current extent in the fork.
 			 *
-			 * Using a single map prevents this as we are forced to
-			 * check each map we look for overlap with the desired
-			 * range and abort as soon as we find it. Also, given
-			 * that we only return a single map, having one beyond
-			 * what we can return is probably a bit silly.
+			 * If the external change did not modify the current
+			 * mapping (or just grew it) this will have no effect.
+			 * If the current mapping shrunk, we expect to at
+			 * minimum still have blocks backing the current page as
+			 * the page has remained locked since writeback first
+			 * located delalloc block(s) at the page offset. A
+			 * racing truncate, hole punch or even reflink must wait
+			 * on page writeback before it can modify our page and
+			 * underlying block(s).
 			 *
-			 * We also need to check that we don't go beyond EOF;
-			 * this is a truncate optimisation as a truncate sets
-			 * the new file size before block on the pages we
-			 * currently have locked under writeback. Because they
-			 * are about to be tossed, we don't need to write them
-			 * back....
+			 * We'll update *seq before we drop ilock for the next
+			 * iteration.
 			 */
-			nimaps = 1;
-			end_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
-			error = xfs_bmap_last_offset(ip, &last_block,
-							XFS_DATA_FORK);
-			if (error)
-				goto trans_cancel;
-
-			last_block = XFS_FILEOFF_MAX(last_block, end_fsb);
-			if ((map_start_fsb + count_fsb) > last_block) {
-				count_fsb = last_block - map_start_fsb;
-				if (count_fsb == 0) {
-					error = -EAGAIN;
+			if (*seq != READ_ONCE(ifp->if_seq)) {
+				if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb,
+							    &icur, &timap) ||
+				    timap.br_startoff > offset_fsb) {
+					ASSERT(0);
+					error = -EFSCORRUPTED;
 					goto trans_cancel;
 				}
+				xfs_trim_extent(imap, timap.br_startoff,
+						timap.br_blockcount);
+				count_fsb = imap->br_blockcount;
+				map_start_fsb = imap->br_startoff;
 			}
 
-			/*
-			 * From this point onwards we overwrite the imap
-			 * pointer that the caller gave to us.
-			 */
+			nimaps = 1;
 			error = xfs_bmapi_write(tp, ip, map_start_fsb,
 						count_fsb, flags, nres, imap,
 						&nimaps);
-- 
2.17.2

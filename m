Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52364 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752230AbeEGSLk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 May 2018 14:11:40 -0400
Received: from smtp.corp.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1B8353002F93
        for <linux-xfs@vger.kernel.org>; Mon,  7 May 2018 18:11:40 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE6F731320A2
        for <linux-xfs@vger.kernel.org>; Mon,  7 May 2018 18:11:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 4/4] xfs: convert speculative preallocation to unwritten extents
Date: Mon,  7 May 2018 14:11:38 -0400
Message-Id: <20180507181138.43250-5-bfoster@redhat.com>
In-Reply-To: <20180507181138.43250-1-bfoster@redhat.com>
References: <20180507181138.43250-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

XXX: This is hacky/racy/broken and for educational purposes only.
     DO NOT APPLY.

Post-eof blocks are typically converted from delalloc to real extent
allocations when some file-mapped portion of the extent is converted
(at writeback time). When this occurs, sample the current size of
the file and convert any post-eof portion of the extent to an
unwritten extent.

The advantages of this behavior are:

- Eliminates the only user of XFS_BMAPI_NODISCARD (eofblocks).

- Reduces the window of stale data exposure associated with a
  filesystem crash during writeback. Incomplete writeback over
  previously converted speculative preallocation leaves behind
  unwritten extents rather than previous content of the blocks.

- Dramatically reduces the overhead of block zeroing during writes
  that jump over eof (and eofblocks). These writes currently issue
  buffered writes over all preallocated blocks, which consumes time,
  bandwidth and memory. For example, this patch improves the
  performance of the following (on a low-end vm) from ~29s to <1s:

	xfs_io -fc "falloc 0 8g"
		-c "pwrite 8g 4k"
		-c fsync
		-c "pwrite 16g 4k" <file>

  The above may also facilitate further optimizations such as
  invoking a selective/partial writeback @ EOF in
  xfs_file_aio_write_checks() to proactively convert preallocation.

The problems with this patch are that it is quite hacky and racy
with respect to buffered writes that may occur over preallocated
extents in parallel with writeback. This requires careful attention
to i_size as well as some hacks to ensure that delalloc page buffers
are handled properly when the underlying extent may have been
converted after the page was allocated (observed during generic/032
and generic/464). Finally, the separate conversion means that the
operation requires optimistic transaction block reservation rather
than relying on indlen blocks originally attached to the delalloc
extents.

The broader goal in this area of the writeback code is the
elimination of buffer_heads entirely, replaced with reliance on
underlying extent state, and unconditional conversion of all
delalloc extents to unwritten. This closes the stale data exposure
problem completely and eliminates the need for the selective
post-eof hack implemented here.

As a result, this patch was an experiment to document the complexity
involved with and benefits of selective unwritten conversion of
post-eof blocks. The fact that it still requires mucking around with
page buffer handling suggests that in its current form, it's
probably best to defer this to a broader writeback rework that
treats all delalloc blocks consistently.

Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_aops.c  |  3 +++
 fs/xfs/xfs_iomap.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 0ab824f574ed..3f507125d623 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -979,6 +979,9 @@ xfs_writepage_map(
 					     wpc->io_type);
 			if (error)
 				goto out;
+			if (wpc->io_type == XFS_IO_DELALLOC &&
+			    wpc->imap.br_state == XFS_EXT_UNWRITTEN)
+				wpc->io_type = XFS_IO_UNWRITTEN;
 			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
 							 offset);
 		}
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 046469fcc1b8..670404025ece 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -657,6 +657,54 @@ xfs_file_iomap_begin_delay(
 	return error;
 }
 
+/*
+ * Convert any post-eof blocks that are part of the current allocation to
+ * unwritten extents. This optimizations prevents unnecessary online discards of
+ * speculative prealloc on file removal or truncate. It also prevents zeroing on
+ * file extending writes that might skip over preallocated blocks.
+ *
+ * NOTE: This can be removed once we finally kill off buffer_heads and convert
+ * all delalloc blocks to unwritten by default.
+ */
+static int
+xfs_iomap_convert_eofblocks(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	xfs_fileoff_t		end_fsb,
+	xfs_fsblock_t		*first_block,
+	struct xfs_defer_ops	*dfops,
+	xfs_fileoff_t		*conv_fsb)
+{
+	struct xfs_mount	*mp	= ip->i_mount;
+	struct xfs_bmbt_irec	crec	= *imap;
+	int			nimaps	= 1;
+	int			error;
+	int64_t			nres;
+
+	/* check for post-eof blocks, nothing to do there are none */
+	xfs_trim_extent(&crec, end_fsb, crec.br_blockcount);
+	if (!crec.br_blockcount || crec.br_blockcount == imap->br_blockcount)
+		return 0;
+	ASSERT(crec.br_state == XFS_EXT_NORM);
+
+	/* XXX: transaction hack */
+	nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	error = xfs_mod_fdblocks(tp->t_mountp, -nres, false);
+	if (error)
+		return error == -ENOSPC ? 0 : error;
+	tp->t_blk_res += nres;
+
+	*conv_fsb = crec.br_startoff;
+
+	error = xfs_bmapi_write(tp, ip, crec.br_startoff, crec.br_blockcount,
+				XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT,
+				first_block, nres, &crec, &nimaps, dfops);
+	if (error)
+		return error;
+	return 0;
+}
+
 /*
  * Pass in a delayed allocate extent, convert it to real extents;
  * return to the caller the extent we create which maps on top of
@@ -677,6 +725,7 @@ xfs_iomap_write_allocate(
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb, last_block;
 	xfs_fileoff_t	end_fsb, map_start_fsb;
+	xfs_fileoff_t	conv_fsb;
 	xfs_fsblock_t	first_block;
 	struct xfs_defer_ops	dfops;
 	xfs_filblks_t	count_fsb;
@@ -712,6 +761,7 @@ xfs_iomap_write_allocate(
 		 * but before our buffer starts.
 		 */
 		nimaps = 0;
+		conv_fsb = NULLFILEOFF;
 		while (nimaps == 0) {
 			nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 			/*
@@ -785,6 +835,11 @@ xfs_iomap_write_allocate(
 						count_fsb, flags, &first_block,
 						nres, imap, &nimaps,
 						&dfops);
+			/* convert any speculative prealloc in this mapping */
+			if (!error && nimaps)
+				error = xfs_iomap_convert_eofblocks(tp, ip,
+						imap, end_fsb, &first_block, &dfops,
+						&conv_fsb);
 			if (error)
 				goto trans_cancel;
 
@@ -809,6 +864,13 @@ xfs_iomap_write_allocate(
 		if ((offset_fsb >= imap->br_startoff) &&
 		    (offset_fsb < (imap->br_startoff +
 				   imap->br_blockcount))) {
+			if (conv_fsb != NULLFILEOFF) {
+				xfs_trim_extent(imap, imap->br_startoff,
+						conv_fsb - imap->br_startoff);
+				ASSERT(offset_fsb >= imap->br_startoff &&
+				       offset_fsb < (imap->br_startoff +
+						     imap->br_blockcount));
+			}
 			XFS_STATS_INC(mp, xs_xstrat_quick);
 			return 0;
 		}
-- 
2.14.3


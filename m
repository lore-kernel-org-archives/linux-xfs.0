Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17231 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932181AbcI1C45 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:56:57 -0400
Subject: [PATCH 30/63] xfs: create delalloc extents in CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:56:50 -0700
Message-ID: <147503141029.30303.15038845918187439996.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Wire up iomap_begin to detect shared extents and create delayed allocation
extents in the CoW fork:

 1) Check if we already have an extent in the COW fork for the area.
    If so nothing to do, we can move along.
 2) Look up block number for the current extent, and if there is none
    it's not shared move along.
 3) Unshare the current extent as far as we are going to write into it.
    For this we avoid an additional COW fork lookup and use the
    information we set aside in step 1) above.
 4) Goto 1) unless we've covered the whole range.

Last but not least, this updates the xfs_reflink_reserve_cow_range calling
convention to pass a byte offset and length, as that is what both callers
expect anyway.  This patch has been refactored considerably as part of the
iomap transition.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c   |   12 ++-
 fs/xfs/xfs_reflink.c |  202 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    9 ++
 3 files changed, 221 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 59c7beb..e8312b0 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -39,6 +39,7 @@
 #include "xfs_quota.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
+#include "xfs_reflink.h"
 
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
@@ -961,8 +962,15 @@ xfs_file_iomap_begin(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if ((flags & IOMAP_WRITE) &&
-	    !IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
+	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
+		error = xfs_reflink_reserve_cow_range(ip, offset, length);
+		if (error < 0)
+			return error;
+	}
+
+	if ((flags & IOMAP_WRITE) && !IS_DAX(inode) &&
+		   !xfs_get_extsz_hint(ip)) {
+		/* Reserve delalloc blocks for regular writeback. */
 		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
 				iomap);
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7adbb83..05a7fe6 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -51,6 +51,7 @@
 #include "xfs_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
+#include "xfs_iomap.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -112,3 +113,204 @@
  * ioend structure.  Better yet, the more ground we can cover with one
  * ioend, the better.
  */
+
+/*
+ * Given an AG extent, find the lowest-numbered run of shared blocks within
+ * that range and return the range in fbno/flen.
+ */
+int
+xfs_reflink_find_shared(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	xfs_agblock_t		*fbno,
+	xfs_extlen_t		*flen,
+	bool			find_maximal)
+{
+	struct xfs_buf		*agbp;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		return error;
+
+	cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
+
+	error = xfs_refcount_find_shared(cur, agbno, aglen, fbno, flen,
+			find_maximal);
+
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+
+	xfs_buf_relse(agbp);
+	return error;
+}
+
+/*
+ * Trim the mapping to the next block where there's a change in the
+ * shared/unshared status.  More specifically, this means that we
+ * find the lowest-numbered extent of shared blocks that coincides with
+ * the given block mapping.  If the shared extent overlaps the start of
+ * the mapping, trim the mapping to the end of the shared extent.  If
+ * the shared region intersects the mapping, trim the mapping to the
+ * start of the shared extent.  If there are no shared regions that
+ * overlap, just return the original extent.
+ */
+int
+xfs_reflink_trim_around_shared(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*irec,
+	bool			*shared,
+	bool			*trimmed)
+{
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_extlen_t		aglen;
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
+	int			error = 0;
+
+	/* Holes, unwritten, and delalloc extents cannot be shared */
+	if (!xfs_is_reflink_inode(ip) ||
+	    ISUNWRITTEN(irec) ||
+	    irec->br_startblock == HOLESTARTBLOCK ||
+	    irec->br_startblock == DELAYSTARTBLOCK) {
+		*shared = false;
+		return 0;
+	}
+
+	trace_xfs_reflink_trim_around_shared(ip, irec);
+
+	agno = XFS_FSB_TO_AGNO(ip->i_mount, irec->br_startblock);
+	agbno = XFS_FSB_TO_AGBNO(ip->i_mount, irec->br_startblock);
+	aglen = irec->br_blockcount;
+
+	error = xfs_reflink_find_shared(ip->i_mount, agno, agbno,
+			aglen, &fbno, &flen, true);
+	if (error)
+		return error;
+
+	*shared = *trimmed = false;
+	if (flen == 0) {
+		/* No shared blocks at all. */
+		return 0;
+	} else if (fbno == agbno) {
+		/* The start of this extent is shared. */
+		irec->br_blockcount = flen;
+		*shared = true;
+		*trimmed = true;
+		return 0;
+	} else {
+		/* There's a shared extent midway through this extent. */
+		irec->br_blockcount = fbno - agbno;
+		*trimmed = true;
+		return 0;
+	}
+}
+
+/* Create a CoW reservation for a range of blocks within a file. */
+static int
+__xfs_reflink_reserve_cow(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		*offset_fsb,
+	xfs_fileoff_t		end_fsb)
+{
+	struct xfs_bmbt_irec	got, prev, imap;
+	xfs_fileoff_t		orig_end_fsb;
+	int			nimaps, eof = 0, error = 0;
+	bool			shared = false, trimmed = false;
+	xfs_extnum_t		idx;
+
+	/* Already reserved?  Skip the refcount btree access. */
+	xfs_bmap_search_extents(ip, *offset_fsb, XFS_COW_FORK, &eof, &idx,
+			&got, &prev);
+	if (!eof && got.br_startoff <= *offset_fsb) {
+		end_fsb = orig_end_fsb = got.br_startoff + got.br_blockcount;
+		trace_xfs_reflink_cow_found(ip, &got);
+		goto done;
+	}
+
+	/* Read extent from the source file. */
+	nimaps = 1;
+	error = xfs_bmapi_read(ip, *offset_fsb, end_fsb - *offset_fsb,
+			&imap, &nimaps, 0);
+	if (error)
+		goto out_unlock;
+	ASSERT(nimaps == 1);
+
+	/* Trim the mapping to the nearest shared extent boundary. */
+	error = xfs_reflink_trim_around_shared(ip, &imap, &shared, &trimmed);
+	if (error)
+		goto out_unlock;
+
+	end_fsb = orig_end_fsb = imap.br_startoff + imap.br_blockcount;
+
+	/* Not shared?  Just report the (potentially capped) extent. */
+	if (!shared)
+		goto done;
+
+	/*
+	 * Fork all the shared blocks from our write offset until the end of
+	 * the extent.
+	 */
+	error = xfs_qm_dqattach_locked(ip, 0);
+	if (error)
+		goto out_unlock;
+
+retry:
+	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, *offset_fsb,
+			end_fsb - *offset_fsb, &got,
+			&prev, &idx, eof);
+	switch (error) {
+	case 0:
+		break;
+	case -ENOSPC:
+	case -EDQUOT:
+		/* retry without any preallocation */
+		trace_xfs_reflink_cow_enospc(ip, &imap);
+		if (end_fsb != orig_end_fsb) {
+			end_fsb = orig_end_fsb;
+			goto retry;
+		}
+		/*FALLTHRU*/
+	default:
+		goto out_unlock;
+	}
+
+	trace_xfs_reflink_cow_alloc(ip, &got);
+done:
+	*offset_fsb = end_fsb;
+out_unlock:
+	return error;
+}
+
+/* Create a CoW reservation for part of a file. */
+int
+xfs_reflink_reserve_cow_range(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		count)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		offset_fsb, end_fsb;
+	int			error;
+
+	trace_xfs_reflink_reserve_cow_range(ip, offset, count);
+
+	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	end_fsb = XFS_B_TO_FSB(mp, offset + count);
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	while (offset_fsb < end_fsb) {
+		error = __xfs_reflink_reserve_cow(ip, &offset_fsb, end_fsb);
+		if (error) {
+			trace_xfs_reflink_reserve_cow_range_error(ip, error,
+				_RET_IP_);
+			break;
+		}
+	}
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 820b151..f824f87 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -20,4 +20,13 @@
 #ifndef __XFS_REFLINK_H
 #define __XFS_REFLINK_H 1
 
+extern int xfs_reflink_find_shared(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
+		xfs_extlen_t *flen, bool find_maximal);
+extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
+		struct xfs_bmbt_irec *irec, bool *shared, bool *trimmed);
+
+extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip,
+		xfs_off_t offset, xfs_off_t count);
+
 #endif /* __XFS_REFLINK_H */


Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BBE037DA5
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:35:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23A12AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:35:55 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id bD7KQfI9lHz58QEN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:35:52 -0700 (PDT)
Subject: [PATCH 35/71] xfs: create delalloc extents in CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:35:46 -0700
Message-ID: <147216814632.867.1974926574237679668.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Wire up write_begin and page_mkwrite to detect shared extents and
create delayed allocation extents in the CoW fork.

v2: Make trim_extent better at constraining the extent to just
the range passed in.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch: rewrite for the iomap-based write path]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c   |   12 +++
 fs/xfs/xfs_reflink.c |  184 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    6 ++
 3 files changed, 202 insertions(+)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1835f3e..f4b735d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -38,6 +38,7 @@
 #include "xfs_quota.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
+#include "xfs_reflink.h"
 
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
@@ -1035,6 +1036,17 @@ xfs_file_iomap_begin(
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
+	/* Reserve delalloc blocks for CoW. */
+	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
+		trace_xfs_reflink_reserve_cow_range(ip, offset, length);
+
+		error = xfs_reflink_reserve_cow_range(ip, offset_fsb, end_fsb);
+		if (error) {
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			return error;
+		}
+	}
+
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
 			       &nimaps, XFS_BMAPI_ENTIRE);
 	if (error) {
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7adbb83..eea0120 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -51,6 +51,7 @@
 #include "xfs_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
+#include "xfs_iomap.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -112,3 +113,186 @@
  * ioend structure.  Better yet, the more ground we can cover with one
  * ioend, the better.
  */
+
+/* Trim extent to fit a logical block range. */
+static void
+xfs_trim_extent(
+	struct xfs_bmbt_irec	*irec,
+	xfs_fileoff_t		bno,
+	xfs_filblks_t		len)
+{
+	xfs_fileoff_t		distance;
+	xfs_fileoff_t		end = bno + len;
+
+	if (irec->br_startoff + irec->br_blockcount <= bno ||
+	    irec->br_startoff >= end) {
+		irec->br_blockcount = 0;
+		return;
+	}
+
+	if (irec->br_startoff < bno) {
+		distance = bno - irec->br_startoff;
+		if (irec->br_startblock != DELAYSTARTBLOCK &&
+		    irec->br_startblock != HOLESTARTBLOCK)
+			irec->br_startblock += distance;
+		irec->br_startoff += distance;
+		irec->br_blockcount -= distance;
+	}
+
+	if (end < irec->br_startoff + irec->br_blockcount) {
+		distance = irec->br_startoff + irec->br_blockcount - end;
+		irec->br_blockcount -= distance;
+	}
+}
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
+/* Find the shared ranges under an irec, and set up delalloc extents. */
+static int
+xfs_reflink_reserve_cow_extent(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*irec)
+{
+	struct xfs_bmbt_irec	rec;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_extlen_t		aglen;
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
+	xfs_fileoff_t		lblk;
+	xfs_off_t		foffset;
+	xfs_extlen_t		distance;
+	size_t			fsize;
+	int			error = 0;
+
+	/* Holes, unwritten, and delalloc extents cannot be shared */
+	if (ISUNWRITTEN(irec) ||
+	    irec->br_startblock == HOLESTARTBLOCK ||
+	    irec->br_startblock == DELAYSTARTBLOCK)
+		return 0;
+
+	trace_xfs_reflink_reserve_cow_extent(ip, irec);
+	agno = XFS_FSB_TO_AGNO(ip->i_mount, irec->br_startblock);
+	agbno = XFS_FSB_TO_AGBNO(ip->i_mount, irec->br_startblock);
+	lblk = irec->br_startoff;
+	aglen = irec->br_blockcount;
+
+	while (aglen > 0) {
+		/* Find maximal fork range within this extent */
+		error = xfs_reflink_find_shared(ip->i_mount, agno, agbno,
+				aglen, &fbno, &flen, true);
+		if (error)
+			break;
+		if (flen == 0) {
+			distance = fbno - agbno;
+			goto advloop;
+		}
+
+		/* Add as much as we can to the cow fork */
+		foffset = XFS_FSB_TO_B(ip->i_mount, lblk + fbno - agbno);
+		fsize = XFS_FSB_TO_B(ip->i_mount, flen);
+		error = xfs_iomap_cow_delay(ip, foffset, fsize, &rec);
+		if (error)
+			break;
+
+		distance = (rec.br_startoff - lblk) + rec.br_blockcount;
+advloop:
+		if (aglen < distance)
+			break;
+		aglen -= distance;
+		agbno += distance;
+		lblk += distance;
+	}
+
+	if (error)
+		trace_xfs_reflink_reserve_cow_extent_error(ip, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Create CoW reservations for all shared blocks within a byte range of
+ * a file.
+ */
+int
+xfs_reflink_reserve_cow_range(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		offset_fsb,
+	xfs_fileoff_t		end_fsb)
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	struct xfs_bmbt_rec_host *gotp;
+	struct xfs_bmbt_irec	imap;
+	xfs_extnum_t		idx;
+	int			nimaps, error = 0;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	trace_xfs_reflink_reserve_cow_range(ip,
+			XFS_FSB_TO_B(ip->i_mount, end_fsb - offset_fsb),
+			XFS_FSB_TO_B(ip->i_mount, offset_fsb));
+
+	while (offset_fsb < end_fsb) {
+		/* Already reserved?  Skip the refcount btree access. */
+		gotp = xfs_iext_bno_to_ext(ifp, offset_fsb, &idx);
+		if (gotp) {
+			xfs_bmbt_get_all(gotp, &imap);
+			if (imap.br_startoff <= offset_fsb &&
+			    imap.br_startoff + imap.br_blockcount > offset_fsb) {
+				offset_fsb = imap.br_startoff + imap.br_blockcount;
+				continue;
+			}
+		}
+
+		/* Read extent from the source file. */
+		nimaps = 1;
+		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+				&imap, &nimaps, 0);
+		if (error)
+			break;
+
+		if (nimaps == 0)
+			break;
+
+		/* Fork all the shared blocks in this extent. */
+		error = xfs_reflink_reserve_cow_extent(ip, &imap);
+		if (error)
+			break;
+
+		offset_fsb += imap.br_blockcount;
+	}
+
+	if (error)
+		trace_xfs_reflink_reserve_cow_range_error(ip, error, _RET_IP_);
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 820b151..a724cb8 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -20,4 +20,10 @@
 #ifndef __XFS_REFLINK_H
 #define __XFS_REFLINK_H 1
 
+extern int xfs_reflink_find_shared(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
+		xfs_extlen_t *flen, bool find_maximal);
+extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip,
+		xfs_fileoff_t offset_fsb, xfs_fileoff_t end_fsb);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

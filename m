Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AA33D7E8A
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:26:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A974304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:26:27 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id m8MpsjXw78tNEnOi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:26:24 -0700 (PDT)
Subject: [PATCH 079/119] xfs: create delalloc extents in CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:26:18 -0700
Message-ID: <146612677795.12839.15535158428152936702.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Wire up write_begin and page_mkwrite to detect shared extents and
create delayed allocation extents in the CoW fork.

v2: Make trim_extent better at constraining the extent to just
the range passed in.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c    |   10 +++
 fs/xfs/xfs_file.c    |   10 +++
 fs/xfs/xfs_reflink.c |  158 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    3 +
 4 files changed, 181 insertions(+)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4c463b9..66a2a9b 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -31,6 +31,7 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_reflink.h"
 #include <linux/gfp.h>
 #include <linux/mpage.h>
 #include <linux/pagevec.h>
@@ -1567,6 +1568,15 @@ xfs_vm_write_begin(
 	if (!page)
 		return -ENOMEM;
 
+	/* Reserve delalloc blocks for CoW. */
+	status = xfs_reflink_reserve_cow_range(XFS_I(mapping->host), pos, len);
+	if (status) {
+		unlock_page(page);
+		put_page(page);
+		*pagep = NULL;
+		return status;
+	}
+
 	status = __block_write_begin(page, pos, len, xfs_get_blocks);
 	if (xfs_mp_fail_writes(mp))
 		status = -EIO;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 47fc632..148d0b3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -37,6 +37,7 @@
 #include "xfs_log.h"
 #include "xfs_icache.h"
 #include "xfs_pnfs.h"
+#include "xfs_reflink.h"
 
 #include <linux/dcache.h>
 #include <linux/falloc.h>
@@ -1550,6 +1551,14 @@ xfs_filemap_page_mkwrite(
 	file_update_time(vma->vm_file);
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
+	/* Reserve delalloc blocks for CoW. */
+	ret = xfs_reflink_reserve_cow_range(XFS_I(inode),
+			vmf->page->index << PAGE_SHIFT, PAGE_SIZE);
+	if (ret) {
+		ret = block_page_mkwrite_return(ret);
+		goto out;
+	}
+
 	if (IS_DAX(inode)) {
 		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault);
 	} else {
@@ -1557,6 +1566,7 @@ xfs_filemap_page_mkwrite(
 		ret = block_page_mkwrite_return(ret);
 	}
 
+out:
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	sb_end_pagefault(inode->i_sb);
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7adbb83..112d86b 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -51,6 +51,7 @@
 #include "xfs_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
+#include "xfs_iomap.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -112,3 +113,160 @@
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
+		error = xfs_refcount_find_shared(ip->i_mount, agno, agbno,
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
+	xfs_off_t		pos,
+	xfs_off_t		len)
+{
+	struct xfs_bmbt_irec	imap;
+	int			nimaps;
+	int			error = 0;
+	xfs_fileoff_t		lblk;
+	xfs_fileoff_t		next_lblk;
+	struct xfs_ifork	*ifp;
+	struct xfs_bmbt_rec_host	*gotp;
+	xfs_extnum_t		idx;
+
+	if (!xfs_is_reflink_inode(ip))
+		return 0;
+
+	trace_xfs_reflink_reserve_cow_range(ip, len, pos, 0);
+
+	lblk = XFS_B_TO_FSBT(ip->i_mount, pos);
+	next_lblk = XFS_B_TO_FSB(ip->i_mount, pos + len);
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	while (lblk < next_lblk) {
+		/* Already reserved?  Skip the refcount btree access. */
+		gotp = xfs_iext_bno_to_ext(ifp, lblk, &idx);
+		if (gotp) {
+			xfs_bmbt_get_all(gotp, &imap);
+			if (imap.br_startoff <= lblk &&
+			    imap.br_startoff + imap.br_blockcount > lblk) {
+				lblk = imap.br_startoff + imap.br_blockcount;
+				continue;
+			}
+		}
+
+		/* Read extent from the source file. */
+		nimaps = 1;
+		error = xfs_bmapi_read(ip, lblk, next_lblk - lblk, &imap,
+				&nimaps, 0);
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
+		lblk += imap.br_blockcount;
+	}
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	if (error)
+		trace_xfs_reflink_reserve_cow_range_error(ip, error, _RET_IP_);
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 820b151..7b0a215 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -20,4 +20,7 @@
 #ifndef __XFS_REFLINK_H
 #define __XFS_REFLINK_H 1
 
+extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip, xfs_off_t pos,
+		xfs_off_t len);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

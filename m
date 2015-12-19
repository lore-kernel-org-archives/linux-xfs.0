Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D0E280E5
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:02:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F353A304059
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:02:40 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id CU9Qxy1hc0BUj196 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:02:39 -0800 (PST)
Subject: [PATCH 55/76] xfs: create delalloc extents in CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:02:35 -0800
Message-ID: <20151219090235.12713.1535.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Wire up write_begin and page_mkwrite to detect shared extents and
create delayed allocation extents in the CoW fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c    |   10 ++++
 fs/xfs/xfs_file.c    |   10 ++++
 fs/xfs/xfs_reflink.c |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    3 +
 4 files changed, 163 insertions(+)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 29e7e5d..afb62e0 100644
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
@@ -1831,6 +1832,15 @@ xfs_vm_write_begin(
 	if (!page)
 		return -ENOMEM;
 
+	/* Reserve delalloc blocks for CoW. */
+	status = xfs_reflink_reserve_cow_range(XFS_I(mapping->host), pos, len);
+	if (status) {
+		unlock_page(page);
+		page_cache_release(page);
+		*pagep = NULL;
+		return status;
+	}
+
 	status = __block_write_begin(page, pos, len, xfs_get_blocks);
 	if (unlikely(status)) {
 		struct inode	*inode = mapping->host;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f5392ab..0fbcb38 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -37,6 +37,7 @@
 #include "xfs_log.h"
 #include "xfs_icache.h"
 #include "xfs_pnfs.h"
+#include "xfs_reflink.h"
 
 #include <linux/dcache.h>
 #include <linux/falloc.h>
@@ -1518,6 +1519,14 @@ xfs_filemap_page_mkwrite(
 	file_update_time(vma->vm_file);
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
+	/* Reserve delalloc blocks for CoW. */
+	ret = xfs_reflink_reserve_cow_range(XFS_I(inode),
+			vmf->page->index << PAGE_CACHE_SHIFT, PAGE_CACHE_SIZE);
+	if (ret) {
+		ret = block_page_mkwrite_return(ret);
+		goto out;
+	}
+
 	if (IS_DAX(inode)) {
 		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault, NULL);
 	} else {
@@ -1525,6 +1534,7 @@ xfs_filemap_page_mkwrite(
 		ret = block_page_mkwrite_return(ret);
 	}
 
+out:
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	sb_end_pagefault(inode->i_sb);
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index bbcd50c..fdc538e 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -48,6 +48,7 @@
 #include "xfs_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
+#include "xfs_iomap.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -109,3 +110,142 @@
  * ioend structure.  Better yet, the more ground we can cover with one
  * ioend, the better.
  */
+
+/* Trim extent to fit a logical block range. */
+static void
+xfs_trim_extent(
+	struct xfs_bmbt_irec	*irec,
+	xfs_fileoff_t		bno,
+	xfs_extlen_t		len)
+{
+	xfs_fileoff_t		distance;
+	xfs_fileoff_t		end = bno + len;
+
+	if (irec->br_startoff < bno) {
+		distance = bno - irec->br_startoff;
+		irec->br_startblock += distance;
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
+STATIC int
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
+/**
+ * xfs_reflink_reserve_cow_range() -- Reserve blocks to satisfy a copy on
+ *				      write operation.
+ * @ip: XFS inode.
+ * @pos: file offset to start CoWing.
+ * @len: number of bytes to CoW.
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
+	xfs_off_t		offset;
+
+	if (!xfs_is_reflink_inode(ip))
+		return 0;
+
+	trace_xfs_reflink_reserve_cow_range(ip, len, pos, 0);
+
+	lblk = XFS_B_TO_FSBT(ip->i_mount, pos);
+	next_lblk = XFS_B_TO_FSB(ip->i_mount, pos + len - 1);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	while (lblk < next_lblk) {
+		offset = XFS_FSB_TO_B(ip->i_mount, lblk);
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
index e967cff..41afdbe 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -18,4 +18,7 @@
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

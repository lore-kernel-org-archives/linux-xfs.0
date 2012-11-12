Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACBs1nQ217905 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 05:54:01 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	IJpxACjCkI0RzM9Z for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 03:56:01 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TXsbI-00053i-4k
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:54:48 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TXsay-00011x-0j
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:54:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/32] xfs: remove xfs_flushinval_pages
Date: Mon, 12 Nov 2012 22:53:57 +1100
Message-Id: <1352721264-3700-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1352721264-3700-1-git-send-email-david@fromorbit.com>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
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

It's just a simple wrapper around VFS functionality, and is actually
bugging in that it doesn't remove mappings before invalidating the
page cache. Remove it and replace it with the correct VFS
functionality.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile       |    1 -
 fs/xfs/xfs_dfrag.c    |   10 ++++------
 fs/xfs/xfs_file.c     |   23 ++++++++++++-----------
 fs/xfs/xfs_fs_subr.c  |   46 ----------------------------------------------
 fs/xfs/xfs_vnodeops.c |   11 +++++------
 fs/xfs/xfs_vnodeops.h |    2 --
 6 files changed, 21 insertions(+), 72 deletions(-)
 delete mode 100644 fs/xfs/xfs_fs_subr.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e65357b..d02201d 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -37,7 +37,6 @@ xfs-y				+= xfs_aops.o \
 				   xfs_file.o \
 				   xfs_filestream.o \
 				   xfs_fsops.o \
-				   xfs_fs_subr.o \
 				   xfs_globals.o \
 				   xfs_icache.o \
 				   xfs_ioctl.o \
diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index b2c63a2..d0e9c74 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -246,12 +246,10 @@ xfs_swap_extents(
 		goto out_unlock;
 	}
 
-	if (VN_CACHED(VFS_I(tip)) != 0) {
-		error = xfs_flushinval_pages(tip, 0, -1,
-				FI_REMAPF_LOCKED);
-		if (error)
-			goto out_unlock;
-	}
+	error = -filemap_write_and_wait(VFS_I(ip)->i_mapping);
+	if (error)
+		goto out_unlock;
+	truncate_pagecache_range(VFS_I(ip), 0, -1);
 
 	/* Verify O_DIRECT for ftmp */
 	if (VN_CACHED(VFS_I(tip)) != 0) {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index daf4066..c42f99e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -255,15 +255,14 @@ xfs_file_aio_read(
 		xfs_buftarg_t	*target =
 			XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp;
-		if ((iocb->ki_pos & target->bt_smask) ||
-		    (size & target->bt_smask)) {
-			if (iocb->ki_pos == i_size_read(inode))
+		if ((pos & target->bt_smask) || (size & target->bt_smask)) {
+			if (pos == i_size_read(inode))
 				return 0;
 			return -XFS_ERROR(EINVAL);
 		}
 	}
 
-	n = mp->m_super->s_maxbytes - iocb->ki_pos;
+	n = mp->m_super->s_maxbytes - pos;
 	if (n <= 0 || size == 0)
 		return 0;
 
@@ -289,20 +288,21 @@ xfs_file_aio_read(
 		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
 
 		if (inode->i_mapping->nrpages) {
-			ret = -xfs_flushinval_pages(ip,
-					(iocb->ki_pos & PAGE_CACHE_MASK),
-					-1, FI_REMAPF_LOCKED);
+			ret = -filemap_write_and_wait_range(
+							VFS_I(ip)->i_mapping,
+							pos, -1);
 			if (ret) {
 				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
 				return ret;
 			}
+			truncate_pagecache_range(VFS_I(ip), pos, -1);
 		}
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
 	}
 
-	trace_xfs_file_read(ip, size, iocb->ki_pos, ioflags);
+	trace_xfs_file_read(ip, size, pos, ioflags);
 
-	ret = generic_file_aio_read(iocb, iovp, nr_segs, iocb->ki_pos);
+	ret = generic_file_aio_read(iocb, iovp, nr_segs, pos);
 	if (ret > 0)
 		XFS_STATS_ADD(xs_read_bytes, ret);
 
@@ -670,10 +670,11 @@ xfs_file_dio_aio_write(
 		goto out;
 
 	if (mapping->nrpages) {
-		ret = -xfs_flushinval_pages(ip, (pos & PAGE_CACHE_MASK), -1,
-							FI_REMAPF_LOCKED);
+		ret = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
+						    pos, -1);
 		if (ret)
 			goto out;
+		truncate_pagecache_range(VFS_I(ip), pos, -1);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_fs_subr.c b/fs/xfs/xfs_fs_subr.c
deleted file mode 100644
index b538089..0000000
--- a/fs/xfs/xfs_fs_subr.c
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * Copyright (c) 2000-2002,2005-2006 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include "xfs.h"
-#include "xfs_vnodeops.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_inode.h"
-#include "xfs_trace.h"
-
-/*
- * note: all filemap functions return negative error codes. These
- * need to be inverted before returning to the xfs core functions.
- */
-int
-xfs_flushinval_pages(
-	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last,
-	int		fiopt)
-{
-	struct address_space *mapping = VFS_I(ip)->i_mapping;
-	int		ret = 0;
-
-	trace_xfs_pagecache_inval(ip, first, last);
-
-	xfs_iflags_clear(ip, XFS_ITRUNCATED);
-	ret = filemap_write_and_wait_range(mapping, first,
-				last == -1 ? LLONG_MAX : last);
-	if (!ret)
-		truncate_inode_pages_range(mapping, first, last);
-	return -ret;
-}
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 31de73e..165cb92 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1958,12 +1958,11 @@ xfs_free_file_space(
 
 	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
 	ioffset = offset & ~(rounding - 1);
-
-	if (VN_CACHED(VFS_I(ip)) != 0) {
-		error = xfs_flushinval_pages(ip, ioffset, -1, FI_REMAPF_LOCKED);
-		if (error)
-			goto out_unlock_iolock;
-	}
+	error = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
+					      ioffset, -1);
+	if (error)
+		goto out_unlock_iolock;
+	truncate_pagecache_range(VFS_I(ip), ioffset, -1);
 
 	/*
 	 * Need to zero the stuff we're not freeing, on disk.
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index 73cb3cb..91a03fa 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -48,8 +48,6 @@ int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		int flags, struct attrlist_cursor_kern *cursor);
-int xfs_flushinval_pages(struct xfs_inode *ip, xfs_off_t first,
-		xfs_off_t last, int fiopt);
 
 int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
 int xfs_free_eofblocks(struct xfs_mount *, struct xfs_inode *, bool);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

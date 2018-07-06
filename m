Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42840 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753827AbeGFDMt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jul 2018 23:12:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w66395RJ180419
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:12:48 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2k0dnt809b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jul 2018 03:12:48 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w663ClZS017229
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:12:47 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w663ClZi017465
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:12:47 GMT
From: Shan Hai <shan.hai@oracle.com>
Subject: [PATCH RFC 4/8] xfs: implement inline data read write code
Date: Fri,  6 Jul 2018 11:12:25 +0800
Message-Id: <1530846750-6686-5-git-send-email-shan.hai@oracle.com>
In-Reply-To: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Implement read/write functions for inline data access and use them
for buffered/DIO/DAX operations.

Signed-off-by: Shan Hai <shan.hai@oracle.com>
---
 fs/xfs/xfs_file.c | 244 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 242 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a3e7767a5715..55047928b720 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -27,6 +27,7 @@
 #include "xfs_pnfs.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_defer.h"
 
 #include <linux/dcache.h>
 #include <linux/falloc.h>
@@ -175,6 +176,185 @@ xfs_file_fsync(
 	return error;
 }
 
+/*
+ * Read the inline data of a local format file.
+ */
+STATIC ssize_t
+xfs_file_inline_data_read(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct kiocb		*iocb,
+	struct iov_iter		*to)
+{
+	xfs_ifork_t		*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct inode		*inode = VFS_I(ip);
+	loff_t			isize = i_size_read(inode);
+	loff_t			*ppos = &iocb->ki_pos;
+	size_t			count = iov_iter_count(to);
+	ssize_t			ret = 0;
+
+	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ||
+	       XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
+
+	if (!count)
+		return 0;
+
+	if (unlikely(*ppos >= inode->i_sb->s_maxbytes))
+		return 0;
+
+	if (*ppos > isize)
+		return 0;
+
+	iov_iter_truncate(to, inode->i_sb->s_maxbytes);
+	count = (*ppos + count > isize) ? isize - *ppos : count;
+	ret = copy_to_iter(ifp->if_u1.if_data + *ppos, count, to);
+	*ppos += ret;
+
+	return ret;
+}
+
+/*
+ * Try to inline the data into the xfs inode data fork when it has enough
+ * space to hold it. The data inlining happens at below points:
+ *
+ * - writeback: for buffered writes
+ * - write_iter: for dax/dio writes
+ *
+ * The extents to local format conversion is done here for DAX/DIO write,
+ * while the same conversion is done in the writeback path for buffered write.
+ * This function also converts inode from local to extents when the data
+ * fork could not hold the data inline anymore.
+ */
+STATIC ssize_t
+xfs_file_inline_data_write(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct kiocb		*iocb,
+	struct iov_iter		*from)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_ifork_t		*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct inode		*inode = VFS_I(ip);
+	struct address_space	*mapping = inode->i_mapping;
+	loff_t			pos = iocb->ki_pos;
+	size_t			count = iov_iter_count(from);
+	struct xfs_trans	*tp;
+	struct xfs_defer_ops	dfops;
+	xfs_fsblock_t		first_block;
+	int			ret;
+	int			error = 0;
+	int			logflags = 0;
+	loff_t			written = 0;
+	xfs_fileoff_t		bno = 0;
+	struct xfs_bmbt_irec	map;
+	int			nmap;
+	struct page		*page;
+	char			*kaddr;
+
+	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ||
+	       XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 1, 0, 0, &tp);
+	if (error) {
+		ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+	xfs_defer_init(&dfops, &first_block);
+
+	if (pos + count > XFS_IFORK_DSIZE(ip)) {
+		if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS) {
+			error = 0;
+			goto trans_cancel;
+		}
+
+		page = find_or_create_page(mapping, pos >> PAGE_SHIFT, GFP_NOFS);
+		if (!page) {
+			error = -ENOMEM;
+			goto trans_cancel;
+		}
+		kaddr = kmap_atomic(page);
+		memcpy(kaddr, ifp->if_u1.if_data, ifp->if_bytes);
+		kunmap_atomic(kaddr);
+		SetPageUptodate(page);
+		unlock_page(page);
+		put_page(page);
+
+		xfs_bmap_forkoff_reset(ip, whichfork);
+		ifp->if_flags &= ~XFS_IFINLINE;
+		ifp->if_flags |= XFS_IFEXTENTS;
+		ifp->if_u1.if_root = NULL;
+		ifp->if_height = 0;
+		ifp->if_bytes = 0;
+		XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
+
+		written = ifp->if_bytes;
+		error = xfs_bmap_first_unused(tp, ip, 1, &bno, whichfork);
+		if (error)
+			goto trans_cancel;
+		nmap = 1;
+		error = xfs_bmapi_write(tp, ip, bno, 1, XFS_BMAPI_ENTIRE,
+				&first_block, 1, &map, &nmap, &dfops);
+		if (error)
+			goto trans_cancel;
+
+		goto out_local_to_extents;
+	}
+
+	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
+		xfs_idata_realloc(ip, (pos + count) - ifp->if_bytes, whichfork);
+		ret = copy_from_iter(ifp->if_u1.if_data + pos, count, from);
+		written = ret;
+		goto out;
+	}
+
+	if (IS_DAX(inode) || iocb->ki_flags & IOCB_DIRECT) {
+		struct page	*page = alloc_page(GFP_KERNEL | GFP_NOFS);
+		if (!page) {
+			error = -ENOMEM;
+			goto trans_cancel;
+		}
+
+		kaddr = kmap_atomic(page);
+		ret = copy_from_iter(kaddr + pos, count, from);
+		kunmap_atomic(kaddr);
+		written = ret;
+		error = xfs_bmap_extents_to_local(tp, ip, &dfops, &logflags,
+							XFS_DATA_FORK, page);
+		if (error) {
+			__free_page(page);
+			goto trans_cancel;
+		}
+
+		__free_page(page);
+		goto out;
+	}
+trans_cancel:
+	xfs_defer_cancel(&dfops);
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+out:
+	if (pos + written > i_size_read(inode))
+		i_size_write(inode, pos + written);
+	ip->i_d.di_size = pos + written;
+
+out_local_to_extents:
+	logflags |= (XFS_ILOG_DDATA | XFS_ILOG_CORE);
+	xfs_trans_log_inode(tp, ip, logflags);
+
+	error = xfs_defer_finish(&tp, &dfops);
+	if (error)
+		goto trans_cancel;
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	return written > 0 ? written : error;
+}
+
+
 STATIC ssize_t
 xfs_file_dio_aio_read(
 	struct kiocb		*iocb,
@@ -192,7 +372,12 @@ xfs_file_dio_aio_read(
 	file_accessed(iocb->ki_filp);
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	ret = iomap_dio_rw(iocb, to, &xfs_iomap_ops, NULL);
+	if (xfs_sb_version_hasinlinedata(&ip->i_mount->m_sb) &&
+	    XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) == XFS_DINODE_FMT_LOCAL) {
+		ret = xfs_file_inline_data_read(ip, XFS_DATA_FORK, iocb, to);
+	} else {
+		ret = iomap_dio_rw(iocb, to, &xfs_iomap_ops, NULL);
+	}
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	return ret;
@@ -219,6 +404,13 @@ xfs_file_dax_read(
 		xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	}
 
+	if (xfs_sb_version_hasinlinedata(&ip->i_mount->m_sb) &&
+	    XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) == XFS_DINODE_FMT_LOCAL) {
+		ret = xfs_file_inline_data_read(ip, XFS_DATA_FORK, iocb, to);
+	} else {
+		ret = dax_iomap_rw(iocb, to, &xfs_iomap_ops);
+	}
+
 	ret = dax_iomap_rw(iocb, to, &xfs_iomap_ops);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
@@ -242,7 +434,12 @@ xfs_file_buffered_aio_read(
 	} else {
 		xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	}
-	ret = generic_file_read_iter(iocb, to);
+
+	if (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) == XFS_DINODE_FMT_LOCAL) {
+		ret = xfs_file_inline_data_read(ip, XFS_DATA_FORK, iocb, to);
+	} else {
+		ret = generic_file_read_iter(iocb, to);
+	}
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	return ret;
@@ -487,6 +684,7 @@ xfs_file_dio_aio_write(
 	size_t			count = iov_iter_count(from);
 	struct xfs_buftarg      *target = XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp;
+	int			error;
 
 	/* DIO must be aligned to device logical sector size */
 	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
@@ -547,6 +745,22 @@ xfs_file_dio_aio_write(
 	}
 
 	trace_xfs_file_direct_write(ip, count, iocb->ki_pos);
+
+	if (xfs_sb_version_hasinlinedata(&mp->m_sb) &&
+		XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE &&
+		S_ISREG(inode->i_mode)) {
+		error = xfs_file_inline_data_write(ip, XFS_DATA_FORK, iocb,
+							from);
+		if (error) {
+			ret = error;
+			goto out;
+		}
+		if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
+			ret = count;
+			goto out;
+		}
+	}
+
 	ret = iomap_dio_rw(iocb, from, &xfs_iomap_ops, xfs_dio_write_end_io);
 out:
 	xfs_iunlock(ip, iolock);
@@ -586,6 +800,20 @@ xfs_file_dax_write(
 	count = iov_iter_count(from);
 
 	trace_xfs_file_dax_write(ip, count, pos);
+
+	if (xfs_sb_version_hasinlinedata(&ip->i_mount->m_sb) &&
+		ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
+		S_ISREG(inode->i_mode)) {
+		error = xfs_file_inline_data_write(ip, XFS_DATA_FORK,
+							iocb, from);
+		if (error)
+			goto out;
+		if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
+			ret = count;
+			goto out;
+		}
+	}
+
 	ret = dax_iomap_rw(iocb, from, &xfs_iomap_ops);
 	if (ret > 0 && iocb->ki_pos > i_size_read(inode)) {
 		i_size_write(inode, iocb->ki_pos);
@@ -614,6 +842,7 @@ xfs_file_buffered_aio_write(
 	struct address_space	*mapping = file->f_mapping;
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret;
 	int			enospc = 0;
 	int			iolock;
@@ -629,6 +858,17 @@ xfs_file_buffered_aio_write(
 	if (ret)
 		goto out;
 
+	if (xfs_sb_version_hasinlinedata(&mp->m_sb) &&
+		XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE) {
+		ret = xfs_file_inline_data_write(ip, XFS_DATA_FORK, iocb, from);
+		if (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) ==
+							XFS_DINODE_FMT_LOCAL){
+			if (likely(ret >= 0))
+				iocb->ki_pos += ret;
+			goto out;
+		}
+	}
+
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = inode_to_bdi(inode);
 
-- 
2.11.0


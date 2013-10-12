Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 63DF27F52
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 02:56:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D88AEAC001
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 00:56:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id Nakq4eDmOm0jk4jw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Oct 2013 00:56:41 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VUu40-0000ls-DD
	for xfs@oss.sgi.com; Sat, 12 Oct 2013 07:56:40 +0000
Message-Id: <20131012075640.290849068@bombadil.infradead.org>
Date: Sat, 12 Oct 2013 00:55:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/5] xfs: always hold the iolock when calling
	xfs_change_file_space
References: <20131012075503.370510641@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_ATTR_NOLOCK
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Currently fallocate always holds the iolock when calling into
xfs_change_file_space, while the ioctl path lets some of the lower level
functions take it, but leave it out in others.

This patch makes sure the ioctl path also always holds the iolock and
thus introduces consistent locking for the preallocation operations while
simplifying the code and allowing to kill the now unused XFS_ATTR_NOLOCK
flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_bmap_util.c |   71 ++++++++++++++++---------------------------------
 fs/xfs/xfs_file.c      |    2 -
 fs/xfs/xfs_ioctl.c     |    2 +
 fs/xfs/xfs_iops.h      |    1 
 4 files changed, 27 insertions(+), 49 deletions(-)

Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2013-10-01 20:19:12.000000000 +0200
+++ xfs/fs/xfs/xfs_file.c	2013-10-01 20:21:00.720144850 +0200
@@ -816,7 +816,7 @@ xfs_file_fallocate(
 	xfs_flock64_t	bf;
 	xfs_inode_t	*ip = XFS_I(inode);
 	int		cmd = XFS_IOC_RESVSP;
-	int		attr_flags = XFS_ATTR_NOLOCK;
+	int		attr_flags = 0;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
Index: xfs/fs/xfs/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ioctl.c	2013-10-01 20:16:53.000000000 +0200
+++ xfs/fs/xfs/xfs_ioctl.c	2013-10-01 20:21:00.724144850 +0200
@@ -670,7 +670,9 @@ xfs_ioc_space(
 	error = mnt_want_write_file(filp);
 	if (error)
 		return error;
+	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 	error = xfs_change_file_space(ip, cmd, bf, filp->f_pos, attr_flags);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	mnt_drop_write_file(filp);
 	return -error;
 }
Index: xfs/fs/xfs/xfs_bmap_util.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_util.c	2013-10-01 20:19:12.404142276 +0200
+++ xfs/fs/xfs/xfs_bmap_util.c	2013-10-01 20:22:25.328146861 +0200
@@ -989,8 +989,7 @@ xfs_alloc_file_space(
 	xfs_inode_t		*ip,
 	xfs_off_t		offset,
 	xfs_off_t		len,
-	int			alloc_type,
-	int			attr_flags)
+	int			alloc_type)
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
@@ -1248,8 +1247,7 @@ STATIC int
 xfs_free_file_space(
 	xfs_inode_t		*ip,
 	xfs_off_t		offset,
-	xfs_off_t		len,
-	int			attr_flags)
+	xfs_off_t		len)
 {
 	int			committed;
 	int			done;
@@ -1267,7 +1265,6 @@ xfs_free_file_space(
 	int			rt;
 	xfs_fileoff_t		startoffset_fsb;
 	xfs_trans_t		*tp;
-	int			need_iolock = 1;
 
 	mp = ip->i_mount;
 
@@ -1284,20 +1281,15 @@ xfs_free_file_space(
 	startoffset_fsb	= XFS_B_TO_FSB(mp, offset);
 	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
 
-	if (attr_flags & XFS_ATTR_NOLOCK)
-		need_iolock = 0;
-	if (need_iolock) {
-		xfs_ilock(ip, XFS_IOLOCK_EXCL);
-		/* wait for the completion of any pending DIOs */
-		inode_dio_wait(VFS_I(ip));
-	}
+	/* wait for the completion of any pending DIOs */
+	inode_dio_wait(VFS_I(ip));
 
 	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
 	ioffset = offset & ~(rounding - 1);
 	error = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
 					      ioffset, -1);
 	if (error)
-		goto out_unlock_iolock;
+		goto out;
 	truncate_pagecache_range(VFS_I(ip), ioffset, -1);
 
 	/*
@@ -1311,7 +1303,7 @@ xfs_free_file_space(
 		error = xfs_bmapi_read(ip, startoffset_fsb, 1,
 					&imap, &nimap, 0);
 		if (error)
-			goto out_unlock_iolock;
+			goto out;
 		ASSERT(nimap == 0 || nimap == 1);
 		if (nimap && imap.br_startblock != HOLESTARTBLOCK) {
 			xfs_daddr_t	block;
@@ -1326,7 +1318,7 @@ xfs_free_file_space(
 		error = xfs_bmapi_read(ip, endoffset_fsb - 1, 1,
 					&imap, &nimap, 0);
 		if (error)
-			goto out_unlock_iolock;
+			goto out;
 		ASSERT(nimap == 0 || nimap == 1);
 		if (nimap && imap.br_startblock != HOLESTARTBLOCK) {
 			ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
@@ -1412,18 +1404,15 @@ xfs_free_file_space(
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
- out_unlock_iolock:
-	if (need_iolock)
-		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+ out:
 	return error;
 
  error0:
 	xfs_bmap_cancel(&free_list);
  error1:
 	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
-	xfs_iunlock(ip, need_iolock ? (XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL) :
-		    XFS_ILOCK_EXCL);
-	return error;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	goto out;
 }
 
 
@@ -1431,8 +1420,7 @@ STATIC int
 xfs_zero_file_space(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	xfs_off_t		len,
-	int			attr_flags)
+	xfs_off_t		len)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	uint			granularity;
@@ -1453,9 +1441,6 @@ xfs_zero_file_space(
 	ASSERT(start_boundary >= offset);
 	ASSERT(end_boundary <= offset + len);
 
-	if (!(attr_flags & XFS_ATTR_NOLOCK))
-		xfs_ilock(ip, XFS_IOLOCK_EXCL);
-
 	if (start_boundary < end_boundary - 1) {
 		/* punch out the page cache over the conversion range */
 		truncate_pagecache_range(VFS_I(ip), start_boundary,
@@ -1463,16 +1448,16 @@ xfs_zero_file_space(
 		/* convert the blocks */
 		error = xfs_alloc_file_space(ip, start_boundary,
 					end_boundary - start_boundary - 1,
-					XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT,
-					attr_flags);
+					XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT);
 		if (error)
-			goto out_unlock;
+			goto out;
 
 		/* We've handled the interior of the range, now for the edges */
-		if (start_boundary != offset)
+		if (start_boundary != offset) {
 			error = xfs_iozero(ip, offset, start_boundary - offset);
-		if (error)
-			goto out_unlock;
+			if (error)
+				goto out;
+		}
 
 		if (end_boundary != offset + len)
 			error = xfs_iozero(ip, end_boundary,
@@ -1486,9 +1471,7 @@ xfs_zero_file_space(
 		error = xfs_iozero(ip, offset, len);
 	}
 
-out_unlock:
-	if (!(attr_flags & XFS_ATTR_NOLOCK))
-		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+out:
 	return error;
 
 }
@@ -1571,8 +1554,7 @@ xfs_change_file_space(
 	setprealloc = clrprealloc = 0;
 	switch (cmd) {
 	case XFS_IOC_ZERO_RANGE:
-		error = xfs_zero_file_space(ip, startoffset, bf->l_len,
-						attr_flags);
+		error = xfs_zero_file_space(ip, startoffset, bf->l_len);
 		if (error)
 			return error;
 		setprealloc = 1;
@@ -1581,7 +1563,7 @@ xfs_change_file_space(
 	case XFS_IOC_RESVSP:
 	case XFS_IOC_RESVSP64:
 		error = xfs_alloc_file_space(ip, startoffset, bf->l_len,
-						XFS_BMAPI_PREALLOC, attr_flags);
+						XFS_BMAPI_PREALLOC);
 		if (error)
 			return error;
 		setprealloc = 1;
@@ -1589,8 +1571,8 @@ xfs_change_file_space(
 
 	case XFS_IOC_UNRESVSP:
 	case XFS_IOC_UNRESVSP64:
-		if ((error = xfs_free_file_space(ip, startoffset, bf->l_len,
-								attr_flags)))
+		error = xfs_free_file_space(ip, startoffset, bf->l_len);
+		if (error)
 			return error;
 		break;
 
@@ -1608,22 +1590,17 @@ xfs_change_file_space(
 		 * truncate, direct IO) from racing against the transient
 		 * allocated but not written state we can have here.
 		 */
-		xfs_ilock(ip, XFS_IOLOCK_EXCL);
 		if (startoffset > fsize) {
 			error = xfs_alloc_file_space(ip, fsize,
-					startoffset - fsize, 0,
-					attr_flags | XFS_ATTR_NOLOCK);
-			if (error) {
-				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+					startoffset - fsize, 0);
+			if (error)
 				break;
-			}
 		}
 
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = startoffset;
 
 		error = xfs_setattr_size(ip, &iattr);
-		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
 		if (error)
 			return error;
Index: xfs/fs/xfs/xfs_iops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_iops.h	2013-10-01 20:19:51.160143197 +0200
+++ xfs/fs/xfs/xfs_iops.h	2013-10-01 20:21:19.416145295 +0200
@@ -31,7 +31,6 @@ extern void xfs_setup_inode(struct xfs_i
  * Internal setattr interfaces.
  */
 #define	XFS_ATTR_DMI		0x01	/* invocation from a DMI function */
-#define XFS_ATTR_NOLOCK		0x04	/* Don't grab any conflicting locks */
 #define XFS_ATTR_NOACL		0x08	/* Don't call xfs_acl_chmod */
 #define XFS_ATTR_SYNC		0x10	/* synchronous operation required */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

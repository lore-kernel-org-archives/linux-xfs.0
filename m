Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8MKrXWM216490 for <xfs@oss.sgi.com>; Tue, 22 Sep 2009 15:53:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C9C316BE22C
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2009 13:54:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id aFfmxGJjLfIQdHtT for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2009 13:54:51 -0700 (PDT)
Date: Tue, 22 Sep 2009 16:54:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 13/n] xfs: new truncate sequence
Message-ID: <20090922205447.GB12224@infradead.org>
References: <20090820163504.131529718@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090820163504.131529718@suse.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com



Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: vfs-2.6.git/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- vfs-2.6.git.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-09-22 11:28:48.581004129 -0300
+++ vfs-2.6.git/fs/xfs/linux-2.6/xfs_aops.c	2009-09-22 12:11:08.625765641 -0300
@@ -1563,6 +1563,45 @@ xfs_vm_direct_IO(
 	return ret;
 }
 
+STATIC void
+xfs_truncate_excess_blocks(
+	struct address_space	*mapping,
+	loff_t			pos,
+	unsigned		len)
+{
+	struct inode 		*inode = mapping->host;
+	loff_t			isize = inode->i_size;
+
+	if (pos + len > isize) {
+		struct iattr	ia;
+		int error;
+
+		ia.ia_valid = ATTR_SIZE | ATTR_FORCE,
+		ia.ia_size = isize,
+
+		error = xfs_setattr(XFS_I(inode), &ia, XFS_ATTR_NOLOCK);
+		WARN_ON(error); /* not much we can do here. */
+	}
+}
+
+STATIC int
+xfs_vm_write_end(
+	struct file		*file,
+	struct address_space	*mapping,
+	loff_t			pos,
+	unsigned		len,
+	unsigned		copied,
+	struct page		*page,
+	void			*fsdata)
+{
+	int			ret;
+
+	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
+	if (ret < len)
+		xfs_truncate_excess_blocks(mapping, pos, len);
+	return ret;
+}
+
 STATIC int
 xfs_vm_write_begin(
 	struct file		*file,
@@ -1573,9 +1612,14 @@ xfs_vm_write_begin(
 	struct page		**pagep,
 	void			**fsdata)
 {
+	int			ret;
+
 	*pagep = NULL;
-	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 								xfs_get_blocks);
+	if (ret < 0)
+		xfs_truncate_excess_blocks(mapping, pos, len);
+	return ret;
 }
 
 STATIC sector_t
@@ -1630,7 +1674,7 @@ const struct address_space_operations xf
 	.releasepage		= xfs_vm_releasepage,
 	.invalidatepage		= xfs_vm_invalidatepage,
 	.write_begin		= xfs_vm_write_begin,
-	.write_end		= generic_write_end,
+	.write_end		= xfs_vm_write_end,
 	.bmap			= xfs_vm_bmap,
 	.direct_IO		= xfs_vm_direct_IO,
 	.migratepage		= buffer_migrate_page,
Index: vfs-2.6.git/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- vfs-2.6.git.orig/fs/xfs/linux-2.6/xfs_iops.c	2009-09-22 11:28:48.585004290 -0300
+++ vfs-2.6.git/fs/xfs/linux-2.6/xfs_iops.c	2009-09-22 12:11:47.725937790 -0300
@@ -547,21 +547,6 @@ xfs_vn_setattr(
 	return -xfs_setattr(XFS_I(dentry->d_inode), iattr, 0);
 }
 
-/*
- * block_truncate_page can return an error, but we can't propagate it
- * at all here. Leave a complaint + stack trace in the syslog because
- * this could be bad. If it is bad, we need to propagate the error further.
- */
-STATIC void
-xfs_vn_truncate(
-	struct inode	*inode)
-{
-	int	error;
-	error = block_truncate_page(inode->i_mapping, inode->i_size,
-							xfs_get_blocks);
-	WARN_ON(error);
-}
-
 STATIC long
 xfs_vn_fallocate(
 	struct inode	*inode,
@@ -688,7 +673,7 @@ xfs_vn_fiemap(
 
 static const struct inode_operations xfs_inode_operations = {
 	.check_acl		= xfs_check_acl,
-	.truncate		= xfs_vn_truncate,
+	.truncate_kludge_to_be_killed = 1,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
Index: vfs-2.6.git/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- vfs-2.6.git.orig/fs/xfs/linux-2.6/xfs_linux.h	2009-09-22 11:28:48.585004290 -0300
+++ vfs-2.6.git/fs/xfs/linux-2.6/xfs_linux.h	2009-09-22 12:11:08.637764444 -0300
@@ -159,9 +159,6 @@
  */
 #define xfs_sort(a,n,s,fn)	sort(a,n,s,fn,NULL)
 #define xfs_stack_trace()	dump_stack()
-#define xfs_itruncate_data(ip, off)	\
-	(-vmtruncate(VFS_I(ip), (off)))
-
 
 /* Move the kernel do_div definition off to one side */
 
Index: vfs-2.6.git/fs/xfs/xfs_vnodeops.c
===================================================================
--- vfs-2.6.git.orig/fs/xfs/xfs_vnodeops.c	2009-09-22 12:10:45.977765610 -0300
+++ vfs-2.6.git/fs/xfs/xfs_vnodeops.c	2009-09-22 12:12:54.586307127 -0300
@@ -197,9 +197,11 @@ xfs_setattr(
 	 * Truncate file.  Must have write permission and not be a directory.
 	 */
 	if (mask & ATTR_SIZE) {
+		loff_t oldsize = ip->i_size;
+		loff_t newsize = iattr->ia_size;
+
 		/* Short circuit the truncate case for zero length files */
-		if (iattr->ia_size == 0 &&
-		    ip->i_size == 0 && ip->i_d.di_nextents == 0) {
+		if (newsize == 0 && oldsize == 0 && ip->i_d.di_nextents == 0) {
 			xfs_iunlock(ip, XFS_ILOCK_EXCL);
 			lock_flags &= ~XFS_ILOCK_EXCL;
 			if (mask & ATTR_CTIME)
@@ -231,16 +233,19 @@ xfs_setattr(
 		 * to the transaction, because the inode cannot be unlocked
 		 * once it is a part of the transaction.
 		 */
-		if (iattr->ia_size > ip->i_size) {
+		if (newsize > oldsize) {
 			/*
 			 * Do the first part of growing a file: zero any data
 			 * in the last block that is beyond the old EOF.  We
 			 * need to do this before the inode is joined to the
 			 * transaction to modify the i_size.
 			 */
-			code = xfs_zero_eof(ip, iattr->ia_size, ip->i_size);
+			code = xfs_zero_eof(ip, newsize, oldsize);
+			if (code)
+				goto error_return;
 		}
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		lock_flags &= ~XFS_ILOCK_EXCL;
 
 		/*
 		 * We are going to log the inode size change in this
@@ -254,25 +259,28 @@ xfs_setattr(
 		 * really care about here and prevents waiting for other data
 		 * not within the range we care about here.
 		 */
-		if (!code &&
-		    ip->i_size != ip->i_d.di_size &&
-		    iattr->ia_size > ip->i_d.di_size) {
-			code = xfs_flush_pages(ip,
-					ip->i_d.di_size, iattr->ia_size,
-					XFS_B_ASYNC, FI_NONE);
+		if (oldsize != ip->i_d.di_size && newsize > ip->i_d.di_size) {
+			code = xfs_flush_pages(ip, ip->i_d.di_size, newsize,
+					       XFS_B_ASYNC, FI_NONE);
+			if (code)
+				goto error_return;
 		}
 
 		/* wait for all I/O to complete */
 		xfs_ioend_wait(ip);
 
-		if (!code)
-			code = xfs_itruncate_data(ip, iattr->ia_size);
-		if (code) {
-			ASSERT(tp == NULL);
-			lock_flags &= ~XFS_ILOCK_EXCL;
-			ASSERT(lock_flags == XFS_IOLOCK_EXCL);
+		code = -inode_newsize_ok(inode, newsize);
+		if (code)
 			goto error_return;
-		}
+
+		code = -block_truncate_page(inode->i_mapping, newsize,
+					    xfs_get_blocks);
+		if (code)
+			goto error_return;
+
+		i_size_write(inode, newsize);
+		truncate_pagecache(inode, oldsize, newsize);
+
 		tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
 		if ((code = xfs_trans_reserve(tp, 0,
 					     XFS_ITRUNCATE_LOG_RES(mp), 0,
@@ -284,6 +292,7 @@ xfs_setattr(
 			return code;
 		}
 		commit_flags = XFS_TRANS_RELEASE_LOG_RES;
+		lock_flags |= XFS_ILOCK_EXCL;
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 		xfs_trans_ijoin(tp, ip, lock_flags);
@@ -295,23 +304,23 @@ xfs_setattr(
 		 * the semantic difference between truncate() and ftruncate()
 		 * as implemented in the VFS.
 		 */
-		if (iattr->ia_size != ip->i_size || (mask & ATTR_CTIME))
+		if (newsize != ip->i_size || (mask & ATTR_CTIME))
 			timeflags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
 
-		if (iattr->ia_size > ip->i_size) {
-			ip->i_d.di_size = iattr->ia_size;
-			ip->i_size = iattr->ia_size;
+		if (newsize > ip->i_size) {
+			ip->i_d.di_size = newsize;
+			ip->i_size = newsize;
 			if (!(flags & XFS_ATTR_DMI))
 				xfs_ichgtime(ip, XFS_ICHGTIME_CHG);
 			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		} else if (iattr->ia_size <= ip->i_size ||
-			   (iattr->ia_size == 0 && ip->i_d.di_nextents)) {
+		} else if (newsize <= ip->i_size ||
+			   (newsize == 0 && ip->i_d.di_nextents)) {
 			/*
 			 * signal a sync transaction unless
 			 * we're truncating an already unlinked
 			 * file on a wsync filesystem
 			 */
-			code = xfs_itruncate_finish(&tp, ip, iattr->ia_size,
+			code = xfs_itruncate_finish(&tp, ip, newsize,
 					    XFS_DATA_FORK,
 					    ((ip->i_d.di_nlink != 0 ||
 					      !(mp->m_flags & XFS_MOUNT_WSYNC))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

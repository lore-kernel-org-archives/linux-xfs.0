Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5E9EvvN034556 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 04:14:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 301741BDA9A7
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 02:17:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oB8Gm2SMwsxkzxyL for
	<xfs@oss.sgi.com>; Mon, 14 Jun 2010 02:17:33 -0700 (PDT)
Date: Mon, 14 Jun 2010 05:17:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: new truncate sequence
Message-ID: <20100614091731.GA22088@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: npiggin@suse.de, viro@zeniv.linux.org.uk

Convert XFS to the new truncate sequence.  We still can have errors after
updating the file size in xfs_setattr, but these are real I/O errors and lead
to a transaction abort and filesystem shutdown, so they are not an issue.

Errors from ->write_begin and write_end can now be handled correctly because
we can actually get rid of the delalloc extents while previous the buffer
state was stipped in block_invalidatepage.

There is still no error handling for ->direct_IO, because doing so will need
some major restructuring given that we only have the iolock shared and do not
hold i_mutex at all.  Fortunately leaving the normally allocated blocks behind
there is not a major issue and this will get cleaned up by xfs_free_eofblock
later.

Note: the patch is against Al's vfs.git tree as that contains the nessecary
preparations.  I'd prefer to get it applied there so that we can get some
testing in linux-next.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-06-11 18:20:44.758254642 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2010-06-11 19:33:40.285005724 +0200
@@ -1674,6 +1674,22 @@ xfs_vm_direct_IO(
 	return ret;
 }
 
+STATIC void
+xfs_vm_write_failed(
+	struct address_space	*mapping,
+	loff_t			to)
+{
+	struct inode		*inode = mapping->host;
+
+	if (to > inode->i_size) {
+		struct iattr	ia = {
+			.ia_valid	= ATTR_SIZE | ATTR_FORCE,
+			.ia_size	= inode->i_size,
+		};
+		xfs_setattr(XFS_I(inode), &ia, XFS_ATTR_NOLOCK);
+	}
+}
+
 STATIC int
 xfs_vm_write_begin(
 	struct file		*file,
@@ -1688,12 +1704,26 @@ xfs_vm_write_begin(
 
 	ret = block_write_begin(mapping, pos, len, flags, pagep,
 				xfs_get_blocks);
-	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-	}
+	if (unlikely(ret))
+		xfs_vm_write_failed(mapping, pos + len);
+	return ret;
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
 
+	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
+	if (unlikely(ret < len))
+		xfs_vm_write_failed(mapping, pos + len);
 	return ret;
 }
 
@@ -1739,7 +1769,7 @@ const struct address_space_operations xf
 	.releasepage		= xfs_vm_releasepage,
 	.invalidatepage		= xfs_vm_invalidatepage,
 	.write_begin		= xfs_vm_write_begin,
-	.write_end		= generic_write_end,
+	.write_end		= xfs_vm_write_end,
 	.bmap			= xfs_vm_bmap,
 	.direct_IO		= xfs_vm_direct_IO,
 	.migratepage		= buffer_migrate_page,
Index: linux-2.6/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_iops.c	2010-06-10 19:52:20.400004327 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_iops.c	2010-06-11 18:20:50.554011870 +0200
@@ -548,21 +548,6 @@ xfs_vn_setattr(
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
@@ -702,7 +687,6 @@ xfs_vn_fiemap(
 
 static const struct inode_operations xfs_inode_operations = {
 	.check_acl		= xfs_check_acl,
-	.truncate		= xfs_vn_truncate,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
Index: linux-2.6/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_linux.h	2010-06-10 19:52:20.484003629 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_linux.h	2010-06-11 18:20:50.559254502 +0200
@@ -157,8 +157,6 @@
  */
 #define xfs_sort(a,n,s,fn)	sort(a,n,s,fn,NULL)
 #define xfs_stack_trace()	dump_stack()
-#define xfs_itruncate_data(ip, off)	\
-	(-vmtruncate(VFS_I(ip), (off)))
 
 
 /* Move the kernel do_div definition off to one side */
Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c	2010-06-10 19:52:20.578004327 +0200
+++ linux-2.6/fs/xfs/xfs_vnodeops.c	2010-06-11 18:20:50.564254781 +0200
@@ -236,8 +236,11 @@ xfs_setattr(
 			 * transaction to modify the i_size.
 			 */
 			code = xfs_zero_eof(ip, iattr->ia_size, ip->i_size);
+			if (code)
+				goto error_return;
 		}
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		lock_flags &= ~XFS_ILOCK_EXCL;
 
 		/*
 		 * We are going to log the inode size change in this
@@ -251,36 +254,35 @@ xfs_setattr(
 		 * really care about here and prevents waiting for other data
 		 * not within the range we care about here.
 		 */
-		if (!code &&
-		    ip->i_size != ip->i_d.di_size &&
+		if (ip->i_size != ip->i_d.di_size &&
 		    iattr->ia_size > ip->i_d.di_size) {
 			code = xfs_flush_pages(ip,
 					ip->i_d.di_size, iattr->ia_size,
 					XBF_ASYNC, FI_NONE);
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
-			ASSERT(lock_flags == XFS_IOLOCK_EXCL || !need_iolock);
+		code = -block_truncate_page(inode->i_mapping, iattr->ia_size,
+					    xfs_get_blocks);
+		if (code)
 			goto error_return;
-		}
+
 		tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
-		if ((code = xfs_trans_reserve(tp, 0,
-					     XFS_ITRUNCATE_LOG_RES(mp), 0,
-					     XFS_TRANS_PERM_LOG_RES,
-					     XFS_ITRUNCATE_LOG_COUNT))) {
-			xfs_trans_cancel(tp, 0);
-			if (need_iolock)
-				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-			return code;
-		}
+		code = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
+					 XFS_TRANS_PERM_LOG_RES,
+					 XFS_ITRUNCATE_LOG_COUNT);
+		if (code)
+			goto error_return;
+
+		truncate_setsize(inode, iattr->ia_size);
+
 		commit_flags = XFS_TRANS_RELEASE_LOG_RES;
+		lock_flags |= XFS_ILOCK_EXCL;
+
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 		xfs_trans_ijoin(tp, ip, lock_flags);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

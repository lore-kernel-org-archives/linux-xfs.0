Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752628AbeDSOfP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Apr 2018 10:35:15 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DE1A040704BE
        for <linux-xfs@vger.kernel.org>; Thu, 19 Apr 2018 14:35:14 +0000 (UTC)
Received: from odin.brq.redhat.com (unknown [10.43.17.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DD542026E04
        for <linux-xfs@vger.kernel.org>; Thu, 19 Apr 2018 14:35:14 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: Add a helper to retrieve xfs_inode from the address_space
Date: Thu, 19 Apr 2018 16:35:11 +0200
Message-Id: <20180419143511.16924-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Reduce some code and local variable allocation on file operations by
using a new helper.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Hi, I though this could be useful instead of keeping allocating file,
address_space and inode structs in several places, just to retrieve the
xfs_inode, what you guys think?

XFS_FTOINO() isn't really a good name, that's the first one which came to my
mind, if this is useful at all I can change the name to something else, like
XFS_AS_TO_INO() maybe, or something else?!

Although I think some vfs_wide helper like file_inode() would be more useful,
but, well, it's just an idea that came to my mind.

Cheers

 fs/xfs/xfs_file.c  | 37 ++++++++++++++-----------------------
 fs/xfs/xfs_inode.h |  5 +++++
 2 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 299aee4b7b0b..b57e39a78ff6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -95,7 +95,7 @@ xfs_dir_fsync(
 	loff_t			end,
 	int			datasync)
 {
-	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
+	struct xfs_inode	*ip = XFS_FTOINO(file);
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_lsn_t		lsn = 0;
 
@@ -118,8 +118,7 @@ xfs_file_fsync(
 	loff_t			end,
 	int			datasync)
 {
-	struct inode		*inode = file->f_mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_inode	*ip = XFS_FTOINO(file);
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error = 0;
 	int			log_flushed = 0;
@@ -215,7 +214,7 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct xfs_inode	*ip = XFS_FTOINO(iocb->ki_filp);
 	size_t			count = iov_iter_count(to);
 	ssize_t			ret = 0;
 
@@ -300,8 +299,8 @@ xfs_file_aio_write_checks(
 	int			*iolock)
 {
 	struct file		*file = iocb->ki_filp;
-	struct inode		*inode = file->f_mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_inode	*ip = XFS_FTOINO(file);
+	struct inode		*inode = VFS_I(ip);
 	ssize_t			error = 0;
 	size_t			count = iov_iter_count(from);
 	bool			drained_dio = false;
@@ -364,7 +363,7 @@ xfs_file_aio_write_checks(
 			drained_dio = true;
 			goto restart;
 		}
-	
+
 		trace_xfs_zero_eof(ip, isize, iocb->ki_pos - isize);
 		error = iomap_zero_range(inode, isize, iocb->ki_pos - isize,
 				NULL, &xfs_iomap_ops);
@@ -482,10 +481,8 @@ xfs_file_dio_aio_write(
 	struct kiocb		*iocb,
 	struct iov_iter		*from)
 {
-	struct file		*file = iocb->ki_filp;
-	struct address_space	*mapping = file->f_mapping;
-	struct inode		*inode = mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_inode	*ip = XFS_FTOINO(iocb->ki_filp);
+	struct inode		*inode = VFS_I(ip);
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0;
 	int			unaligned_io = 0;
@@ -570,8 +567,8 @@ xfs_file_dax_write(
 	struct kiocb		*iocb,
 	struct iov_iter		*from)
 {
-	struct inode		*inode = iocb->ki_filp->f_mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_inode	*ip = XFS_FTOINO(iocb->ki_filp);
+	struct inode		*inode = VFS_I(ip);
 	int			iolock = XFS_IOLOCK_EXCL;
 	ssize_t			ret, error = 0;
 	size_t			count;
@@ -607,10 +604,7 @@ xfs_file_buffered_aio_write(
 	struct kiocb		*iocb,
 	struct iov_iter		*from)
 {
-	struct file		*file = iocb->ki_filp;
-	struct address_space	*mapping = file->f_mapping;
-	struct inode		*inode = mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_inode	*ip = XFS_FTOINO(iocb->ki_filp);
 	ssize_t			ret;
 	int			enospc = 0;
 	int			iolock;
@@ -627,7 +621,7 @@ xfs_file_buffered_aio_write(
 		goto out;
 
 	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = inode_to_bdi(inode);
+	current->backing_dev_info = inode_to_bdi(VFS_I(ip));
 
 	trace_xfs_file_buffered_write(ip, iov_iter_count(from), iocb->ki_pos);
 	ret = iomap_file_buffered_write(iocb, from, &xfs_iomap_ops);
@@ -677,10 +671,7 @@ xfs_file_write_iter(
 	struct kiocb		*iocb,
 	struct iov_iter		*from)
 {
-	struct file		*file = iocb->ki_filp;
-	struct address_space	*mapping = file->f_mapping;
-	struct inode		*inode = mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_inode	*ip = XFS_FTOINO(iocb->ki_filp);
 	ssize_t			ret;
 	size_t			ocount = iov_iter_count(from);
 
@@ -692,7 +683,7 @@ xfs_file_write_iter(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	if (IS_DAX(inode))
+	if (IS_DAX(VFS_I(ip)))
 		ret = xfs_file_dax_write(iocb, from);
 	else if (iocb->ki_flags & IOCB_DIRECT) {
 		/*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1eebc53df7d7..dd359644de22 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -84,6 +84,11 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
 	return &ip->i_vnode;
 }
 
+/* convert from file to xfs inode */
+static inline struct xfs_inode *XFS_FTOINO(struct file *filp)
+{
+	return XFS_I(filp->f_mapping->host);
+}
 /*
  * For regular files we only update the on-disk filesize when actually
  * writing data back to disk.  Until then only the copy in the VFS inode
-- 
2.14.3


Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAEGHf9U193815 for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 10:17:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B265C1D976F2
	for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:18:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oOheXPTJMnw97I4b for
	<xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:18:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1N9LK5-0004V4-BR
	for xfs@oss.sgi.com; Sat, 14 Nov 2009 16:18:01 +0000
Message-Id: <20091114161801.238873282@bombadil.infradead.org>
Date: Sat, 14 Nov 2009 11:17:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/7] xfs: remove IO_ISAIO
References: <20091114161717.233372584@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-IO_ISAIO
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

We set this flag for all read/write I/O since early Linux 2.6.x.
Remove it as it has lost it's purpose long ago.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2009-10-11 14:25:17.496003686 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2009-11-12 17:14:06.160023109 +0100
@@ -52,7 +52,7 @@ xfs_file_aio_read(
 	loff_t			pos)
 {
 	struct file		*file = iocb->ki_filp;
-	int			ioflags = IO_ISAIO;
+	int			ioflags = 0;
 
 	BUG_ON(iocb->ki_pos != pos);
 	if (unlikely(file->f_flags & O_DIRECT))
@@ -71,7 +71,7 @@ xfs_file_aio_write(
 	loff_t			pos)
 {
 	struct file		*file = iocb->ki_filp;
-	int			ioflags = IO_ISAIO;
+	int			ioflags = 0;
 
 	BUG_ON(iocb->ki_pos != pos);
 	if (unlikely(file->f_flags & O_DIRECT))
Index: xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2009-11-12 17:10:19.909278501 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_lrw.c	2009-11-12 17:14:06.161003891 +0100
@@ -255,8 +255,6 @@ xfs_read(
 
 	iocb->ki_pos = *offset;
 	ret = generic_file_aio_read(iocb, iovp, segs, *offset);
-	if (ret == -EIOCBQUEUED && !(ioflags & IO_ISAIO))
-		ret = wait_on_sync_kiocb(iocb);
 	if (ret > 0)
 		XFS_STATS_ADD(xs_read_bytes, ret);
 
@@ -774,9 +772,6 @@ write_retry:
 
 	current->backing_dev_info = NULL;
 
-	if (ret == -EIOCBQUEUED && !(ioflags & IO_ISAIO))
-		ret = wait_on_sync_kiocb(iocb);
-
 	isize = i_size_read(inode);
 	if (unlikely(ret < 0 && ret != -EFAULT && *offset > isize))
 		*offset = isize;
Index: xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2009-11-12 17:10:19.942276910 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_vnode.h	2009-11-12 17:14:06.161003891 +0100
@@ -36,7 +36,6 @@ struct attrlist_cursor_kern;
 /*
  * Flags for read/write calls - same values as IRIX
  */
-#define IO_ISAIO	0x00001		/* don't wait for completion */
 #define IO_ISDIRECT	0x00004		/* bypass page cache */
 #define IO_INVIS	0x00020		/* don't update inode timestamps */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

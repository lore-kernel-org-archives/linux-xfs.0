Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Feb 2008 20:42:58 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m184gppD001749
	for <xfs@oss.sgi.com>; Thu, 7 Feb 2008 20:42:52 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0B4E5B3128
	for <xfs@oss.sgi.com>; Thu,  7 Feb 2008 20:43:03 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id KXJfgdLPqBowpzC6 for <xfs@oss.sgi.com>; Thu, 07 Feb 2008 20:43:03 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m184gvF3015052
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2008 05:42:57 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m184gvZ5015050
	for xfs@oss.sgi.com; Fri, 8 Feb 2008 05:42:57 +0100
Date: Fri, 8 Feb 2008 05:42:57 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, mainline-only] remove sendfile leftovers
Message-ID: <20080208044256.GA15013@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Remove the last sendfile leftovers in mainline.  This code is already
gone in CVS.


Signed-off-by: Christoph Hellwig <hch@lst.de>

diff -uNr -Xdontdiff -p linux-2.6/fs/xfs/linux-2.6/xfs_lrw.h linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.h
--- linux-2.6/fs/xfs/linux-2.6/xfs_lrw.h	2008-02-08 05:19:59.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.h	2007-10-31 15:08:27.000000000 +0100
@@ -50,7 +50,6 @@ struct xfs_iomap;
 #define	XFS_INVAL_CACHED	18
 #define	XFS_DIORD_ENTER		19
 #define	XFS_DIOWR_ENTER		20
-#define	XFS_SENDFILE_ENTER	21
 #define	XFS_WRITEPAGE_ENTER	22
 #define	XFS_RELEASEPAGE_ENTER	23
 #define	XFS_INVALIDPAGE_ENTER	24
diff -uNr -Xdontdiff -p linux-2.6/fs/xfs/xfs_vnodeops.h linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
--- linux-2.6/fs/xfs/xfs_vnodeops.h	2008-02-08 05:19:59.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2008-02-08 05:20:52.000000000 +0100
@@ -60,9 +60,6 @@ int xfs_ioctl(struct xfs_inode *ip, stru
 ssize_t xfs_read(struct xfs_inode *ip, struct kiocb *iocb,
 		const struct iovec *iovp, unsigned int segs,
 		loff_t *offset, int ioflags);
-ssize_t xfs_sendfile(struct xfs_inode *ip, struct file *filp,
-		loff_t *offset, int ioflags, size_t count,
-		read_actor_t actor, void *target);
 ssize_t xfs_splice_read(struct xfs_inode *ip, struct file *infilp,
 		loff_t *ppos, struct pipe_inode_info *pipe, size_t count,
 		int flags, int ioflags);

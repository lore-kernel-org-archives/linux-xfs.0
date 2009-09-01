Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n81I5LsR198025 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 13:05:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 252C014EE726
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 11:06:17 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IJJVSY57Ers7AhbA for
	<xfs@oss.sgi.com>; Tue, 01 Sep 2009 11:06:17 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MiXhE-0007C5-9r
	for xfs@oss.sgi.com; Tue, 01 Sep 2009 18:03:08 +0000
Date: Tue, 1 Sep 2009 14:03:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: actually enable the swapext compat handler
Message-ID: <20090901180308.GA26071@infradead.org>
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

Fix a small typo in the compat ioctl handler that cause the swapext
compat handler to never be called.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2009-08-31 15:25:06.093044591 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c	2009-08-31 15:25:10.856544216 -0300
@@ -619,7 +619,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_GETVERSION_32:
 		cmd = _NATIVE_IOC(cmd, long);
 		return xfs_file_ioctl(filp, cmd, p);
-	case XFS_IOC_SWAPEXT: {
+	case XFS_IOC_SWAPEXT_32: {
 		struct xfs_swapext	  sxp;
 		struct compat_xfs_swapext __user *sxu = arg;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

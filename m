Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o639IS4S022885 for <xfs@oss.sgi.com>; Sat, 3 Jul 2010 04:18:31 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D7F4426347
	for <xfs@oss.sgi.com>; Sat,  3 Jul 2010 02:21:17 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8IxlghbAxhvCit5e for
	<xfs@oss.sgi.com>; Sat, 03 Jul 2010 02:21:17 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OUyuT-0007Cj-2M
	for xfs@oss.sgi.com; Sat, 03 Jul 2010 09:21:17 +0000
Date: Sat, 3 Jul 2010 05:21:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: remove a dmapi leftover
Message-ID: <20100703092116.GA27669@infradead.org>
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

The open_exec file operation is only added by the external dmapi patch.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-07-03 10:54:07.323263955 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-07-03 10:54:11.636128320 +0200
@@ -921,9 +921,6 @@ const struct file_operations xfs_file_op
 	.open		= xfs_file_open,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
-#ifdef HAVE_FOP_OPEN_EXEC
-	.open_exec	= xfs_file_open_exec,
-#endif
 };
 
 const struct file_operations xfs_dir_file_operations = {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

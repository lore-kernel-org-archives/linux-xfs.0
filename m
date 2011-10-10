Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AGrRQl189824 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:53:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F9051C7C9CE
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 09:53:26 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	edVSdrFbf4Is88gY for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 09:53:26 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RDJ6U-0008DF-KD
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 16:53:26 +0000
Message-Id: <20111010165326.569684018@bombadil.infradead.org>
Date: Mon, 10 Oct 2011 12:52:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/11] xfs: remove xfs_get_buftarg_list
References: <20111010165242.656850411@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_get_buftarg_list
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

The code is unused and under a config option that doesn't exist, remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-10-02 14:05:00.984771623 +0200
+++ xfs/fs/xfs/xfs_buf.c	2011-10-02 14:06:02.936771751 +0200
@@ -1835,11 +1835,3 @@ xfs_buf_terminate(void)
 	destroy_workqueue(xfslogd_workqueue);
 	kmem_zone_destroy(xfs_buf_zone);
 }
-
-#ifdef CONFIG_KDB_MODULES
-struct list_head *
-xfs_get_buftarg_list(void)
-{
-	return &xfs_buftarg_list;
-}
-#endif
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2011-10-02 14:06:00.752771537 +0200
+++ xfs/fs/xfs/xfs_buf.h	2011-10-02 14:06:02.936771751 +0200
@@ -311,10 +311,6 @@ extern void xfs_wait_buftarg(xfs_buftarg
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
 extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
 
-#ifdef CONFIG_KDB_MODULES
-extern struct list_head *xfs_get_buftarg_list(void);
-#endif
-
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

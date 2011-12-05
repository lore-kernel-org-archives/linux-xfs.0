Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB58rN8h123549 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 02:53:24 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6869128B48D
	for <xfs@oss.sgi.com>; Mon,  5 Dec 2011 00:53:22 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	apF9OcrJTkb18v8E for <xfs@oss.sgi.com>;
	Mon, 05 Dec 2011 00:53:22 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RXUIb-0002sG-WB
	for xfs@oss.sgi.com; Mon, 05 Dec 2011 08:53:22 +0000
Date: Mon, 5 Dec 2011 03:53:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: mark the xfssyncd workqueue as non-reentrant
Message-ID: <20111205085321.GA10986@infradead.org>
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

On a system with lots of memory pressure that is stuck on synchronous inode
reclaim the workqueue code will run one instance of the inode reclaim work
item on every CPU. which is not what we want.  Make sure to mark the
xfssyncd workqueue as non-reentrant to make sure there only is one instace
of each running globally.  Also stop using special paramater for the
workqueue; now that we guarantee each fs has only running one of each works
at a time there is no need to artificially lower max_active and compensate
for that by setting the WQ_CPU_INTENSIVE flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-12-02 19:39:38.190494354 +0100
+++ xfs/fs/xfs/xfs_super.c	2011-12-02 19:42:28.527160003 +0100
@@ -1641,12 +1641,12 @@ STATIC int __init
 xfs_init_workqueues(void)
 {
 	/*
-	 * max_active is set to 8 to give enough concurency to allow
-	 * multiple work operations on each CPU to run. This allows multiple
-	 * filesystems to be running sync work concurrently, and scales with
-	 * the number of CPUs in the system.
+	 * We never want to the same work item to run twice, reclaiming inodes
+	 * or idling the log is not going to get any faster by multiple CPUs
+	 * competing for ressources.  Use the default large max_active value
+	 * so that even lots of filesystems can perform these task in parallel.
 	 */
-	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_CPU_INTENSIVE, 8);
+	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_NON_REENTRANT, 0);
 	if (!xfs_syncd_wq)
 		return -ENOMEM;
 	return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

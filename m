Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AGrUf0189865 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:53:30 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59AFB16BAEC9
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 10:00:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	rmV1pVAz2pbf4qoE for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 10:00:40 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RDJ6W-0008IP-E5
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 16:53:28 +0000
Message-Id: <20111010165328.386947740@bombadil.infradead.org>
Date: Mon, 10 Oct 2011 12:52:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/11] xfs: do not flush data workqueues in xfs_flush_buftarg
References: <20111010165242.656850411@bombadil.infradead.org>
Content-Disposition: inline;
	filename=xfs-stop-flushing-data-wqs-in-xfs_flush_buftarg
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

When we call xfs_flush_buftarg (generally from sync or umount) it already
is too late to flush the data workqueues, as I/O completion is signalled
for them and we are thus already done with the data we would flush here.

There are places where flushing them might be useful, but the current
sync interface doesn't give us that opportunity.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-10-10 18:43:04.493870127 +0200
+++ xfs/fs/xfs/xfs_buf.c	2011-10-10 18:43:20.552427959 +0200
@@ -1623,13 +1623,6 @@ xfs_buf_delwri_promote(
 	spin_unlock(&btp->bt_delwri_lock);
 }
 
-STATIC void
-xfs_buf_runall_queues(
-	struct workqueue_struct	*queue)
-{
-	flush_workqueue(queue);
-}
-
 /*
  * Move as many buffers as specified to the supplied list
  * idicating if we skipped any buffers to prevent deadlocks.
@@ -1752,9 +1745,7 @@ xfs_flush_buftarg(
 	LIST_HEAD(wait_list);
 	struct blk_plug plug;
 
-	xfs_buf_runall_queues(xfsconvertd_workqueue);
-	xfs_buf_runall_queues(xfsdatad_workqueue);
-	xfs_buf_runall_queues(xfslogd_workqueue);
+	flush_workqueue(xfslogd_workqueue);
 
 	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
 	pincount = xfs_buf_delwri_split(target, &tmp_list, 0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

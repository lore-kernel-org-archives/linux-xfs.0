Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7N8TFva164703 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 03:29:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 007BC1DA1884
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 01:29:13 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	mAyeF3r6Kh9OVXP3 for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 01:29:13 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QvmMD-000648-G5
	for xfs@oss.sgi.com; Tue, 23 Aug 2011 08:29:13 +0000
Message-Id: <20110823082913.453050111@bombadil.infradead.org>
Date: Tue, 23 Aug 2011 04:28:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/11] xfs: reduce ioend latency
References: <20110823082802.335389799@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-io-latency
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

There is no reason to queue up ioends for processing in user context
unless we actually need it.  Just complete ioends that do not convert
unwritten extents or need a size update from the end_io context.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.c	2011-08-13 10:57:57.559366326 -0700
+++ xfs/fs/xfs/xfs_aops.c	2011-08-13 10:57:57.979364052 -0700
@@ -150,6 +150,15 @@ xfs_ioend_new_eof(
 }
 
 /*
+ * Fast and loose check if this write could update the on-disk inode size.
+ */
+static inline bool xfs_ioend_is_append(struct xfs_ioend *ioend)
+{
+	return ioend->io_offset + ioend->io_size >
+		XFS_I(ioend->io_inode)->i_d.di_size;
+}
+
+/*
  * Update on-disk file size now that data has been written to disk.  The
  * current in-memory file size is i_size.  If a write is beyond eof i_new_size
  * will be the intended file size until i_size is updated.  If this write does
@@ -186,6 +195,9 @@ xfs_setfilesize(
 
 /*
  * Schedule IO completion handling on the final put of an ioend.
+ *
+ * If there is no work to do we might as well call it a day and free the
+ * ioend right now.
  */
 STATIC void
 xfs_finish_ioend(
@@ -194,8 +206,10 @@ xfs_finish_ioend(
 	if (atomic_dec_and_test(&ioend->io_remaining)) {
 		if (ioend->io_type == IO_UNWRITTEN)
 			queue_work(xfsconvertd_workqueue, &ioend->io_work);
-		else
+		else if (xfs_ioend_is_append(ioend))
 			queue_work(xfsdatad_workqueue, &ioend->io_work);
+		else
+			xfs_destroy_ioend(ioend);
 	}
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

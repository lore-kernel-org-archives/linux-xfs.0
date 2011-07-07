Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67B6hvk159850 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 06:06:43 -0500
Message-Id: <20110707110640.863389024@bombadil.infradead.org>
Date: Thu, 07 Jul 2011 07:05:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/28] xfs: re-enable non-blocking behaviour in xfs_map_blocks
References: <20110707110535.205001532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-writepage-repair-nolock-support
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
Cc: Alex Elder <aelder@sgi.com>

The non-blockig behaviour in xfs_vm_writepage currently is conditional on
having both the WB_SYNC_NONE sync_mode and the nonblocking flag set.
The latter used to be used by both pdflush, kswapd and a few other places
in older kernels, but has been fading out starting with the introduction
of the per-bdi flusher threads.

Enable the non-blocking behaviour for all WB_SYNC_NONE calls to get back
the behaviour we want.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2011-07-06 09:12:22.466600907 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2011-07-06 09:12:26.069934110 +0200
@@ -960,7 +960,7 @@ xfs_vm_writepage(
 	offset = page_offset(page);
 	type = IO_OVERWRITE;
 
-	if (wbc->sync_mode == WB_SYNC_NONE && wbc->nonblocking)
+	if (wbc->sync_mode == WB_SYNC_NONE)
 		nonblocking = 1;
 
 	do {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

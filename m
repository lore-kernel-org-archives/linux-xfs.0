Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619k3N5055976 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:46:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 353631E56724
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:46:02 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3IgRdUdiHgi9Chpj for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:46:02 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QcaIU-0001qN-GE
	for xfs@oss.sgi.com; Fri, 01 Jul 2011 09:46:02 +0000
Message-Id: <20110701094602.465074143@bombadil.infradead.org>
Date: Fri, 01 Jul 2011 05:43:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/27] xfs: re-enable non-blocking behaviour in xfs_map_blocks
References: <20110701094321.936534538@bombadil.infradead.org>
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

The non-blockig behaviour in xfs_map_blocks currently is conditional on
having both the WB_SYNC_NONE sync_mode and the nonblocking flag set.
The latter used to be used by both pdflush, kswapd and a few other places
in older kernels, but has been fading out starting with the introduction
of the per-bdi flusher threads.

Enable the non-blocking behaviour for all WB_SYNC_NONE calls to get back
the behaviour we want.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2011-06-30 20:10:06.959596789 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2011-06-30 20:10:19.749596630 +0200
@@ -959,7 +959,7 @@ xfs_vm_writepage(
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

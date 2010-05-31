Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6XSe178891 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 049EE157FB5A
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:11:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id v9X6iDnOrsDSNtyi for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:11:12 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xv-0000qR-9M
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:08:59 +0000
Message-Id: <20100531160859.184576507@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/17] xfs: skip writeback from reclaim context
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-disable-allocations-from-reclaim
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

Allowing writeback from reclaim context causes massive problems with stack
overflows as we can call into the writeback code which tends to be a heavy
stack user both in the generic code and XFS from random contexts that
perform memory allocations.

Follow the example of btrfs (and in slightly different form ext4) and refuse
to write out data from reclaim context.  This issue should really be handled
by the VM so that we can tune better for this case, but until we get it
sorted out there we have to hack around this in each filesystem with a
complex writeback path.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-05-29 18:09:01.713253891 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-05-29 18:11:46.847261713 +0200
@@ -1333,6 +1333,21 @@ xfs_vm_writepage(
 	trace_xfs_writepage(inode, page, 0);
 
 	/*
+	 * Refuse to write the page out if we are called from reclaim context.
+	 *
+	 * This is primarily to avoid stack overflows when called from deep
+	 * used stacks in random callers for direct reclaim, but disabling
+	 * reclaim for kswap is a nice side-effect as kswapd causes rather
+	 * suboptimal I/O patters, too.
+	 *
+	 * This should really be done by the core VM, but until that happens
+	 * filesystems like XFS, btrfs and ext4 have to take care of this
+	 * by themselves.
+	 */
+	if (current->flags & PF_MEMALLOC)
+		goto out_fail;
+
+	/*
 	 * We need a transaction if:
 	 *  1. There are delalloc buffers on the page
 	 *  2. The page is uptodate and we have unmapped buffers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

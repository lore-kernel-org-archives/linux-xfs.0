Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAALbiM4257633 for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 15:37:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E20E13A9984
	for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 13:39:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DH6DLPnx4TAN2quv for
	<xfs@oss.sgi.com>; Wed, 10 Nov 2010 13:39:12 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PGINr-0002v0-Pn
	for xfs@oss.sgi.com; Wed, 10 Nov 2010 21:39:11 +0000
Date: Wed, 10 Nov 2010 16:39:11 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: remove incorrect assert in xfs_vm_writepage
Message-ID: <20101110213911.GA11214@infradead.org>
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


In commit 20cb52ebd1b5ca6fa8a5d9b6b1392292f5ca8a45, titled
"xfs: simplify xfs_vm_writepage" I added an assert that any !mapped and
uptodate buffers are not dirty.  That asserts turns out to trigger a lot
when running fsx on filesystems with small block sizes.  The reason for
that is that the assert is simply incorrect.  !mapped and uptodate
just mean this buffer covers a hole, and whenever we do a set_page_dirty
we mark all blocks in the page dirty, no matter if they have data or
not.  So remove the assert, and update the comment above the condition
to match reality.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-11-10 16:56:00.464863012 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-11-10 17:00:23.528196346 +0100
@@ -1111,11 +1111,12 @@ xfs_vm_writepage(
 			uptodate = 0;
 
 		/*
-		 * A hole may still be marked uptodate because discard_buffer
-		 * leaves the flag set.
+		 * set_page_dirty dirties all buffers in a page, independent
+		 * of their state.  The dirty state however is entirely
+		 * meaningless for holes (!mapped && uptodate), so skip
+		 * buffers covering holes here.
 		 */
 		if (!buffer_mapped(bh) && buffer_uptodate(bh)) {
-			ASSERT(!buffer_dirty(bh));
 			imap_valid = 0;
 			continue;
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

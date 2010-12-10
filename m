Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBA8fDRe205179 for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 02:41:15 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CD66160F98B
	for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AUrICICJOTst1Dfw for
	<xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PQyZB-0006ND-LB
	for xfs@oss.sgi.com; Fri, 10 Dec 2010 08:43:01 +0000
Message-Id: <20101210084301.616302405@bombadil.infradead.org>
Date: Fri, 10 Dec 2010 03:42:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/10] xfs: improve mapping type check in xfs_vm_writepage
References: <20101210084215.259628825@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-iomap-type-checking
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

Currently we only refuse a "read-only" mapping for writing out
unwritten and delayed buffers, and refuse any other for overwrites.
Improve the checks to require delalloc mappings for delayed buffers,
and unwritten extent mappings for unwritten extents.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-12-09 15:46:04.943253809 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-12-09 15:47:20.583004194 +0100
@@ -1082,17 +1082,17 @@ xfs_vm_writepage(
 		if (buffer_unwritten(bh) || buffer_delay(bh)) {
 			int new_ioend = 0;
 
-			/*
-			 * Make sure we don't use a read-only iomap
-			 */
-			if (flags == BMAPI_READ)
-				imap_valid = 0;
-
 			if (buffer_unwritten(bh)) {
-				type = IO_UNWRITTEN;
+				if (type != IO_UNWRITTEN) {
+					type = IO_UNWRITTEN;
+					imap_valid = 0;
+				}
 				flags = BMAPI_WRITE | BMAPI_IGNSTATE;
 			} else if (buffer_delay(bh)) {
-				type = IO_DELAY;
+				if (type != IO_DELAY) {
+					type = IO_DELAY;
+					imap_valid = 0;
+				}
 				flags = BMAPI_ALLOCATE;
 
 				if (wbc->sync_mode == WB_SYNC_NONE)
@@ -1128,8 +1128,11 @@ xfs_vm_writepage(
 			 * That means it must already have extents allocated
 			 * underneath it. Map the extent by reading it.
 			 */
-			if (!imap_valid || flags != BMAPI_READ) {
+			if (flags != BMAPI_READ) {
 				flags = BMAPI_READ;
+				imap_valid = 0;
+			}
+			if (!imap_valid) {
 				size = xfs_probe_cluster(inode, page, bh, head);
 				err = xfs_map_blocks(inode, offset, size,
 						&imap, flags);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

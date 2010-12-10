Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBA8fChh205170 for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 02:41:14 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AD161CAE1E8
	for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DDrZtgYEqMD834yV for
	<xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PQyZC-0006OG-2S
	for xfs@oss.sgi.com; Fri, 10 Dec 2010 08:43:02 +0000
Message-Id: <20101210084302.036988910@bombadil.infradead.org>
Date: Fri, 10 Dec 2010 03:42:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/10] xfs: a few small tweaks for overwrites in
	xfs_vm_writepage
References: <20101210084215.259628825@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-stop-trylocking-buffers
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

Don't trylock the buffer.  We are the only one ever locking it for
a regular file address space, and trylock was only copied from the
generic code which did it due to the old buffer based writeout in
jbd.  Also make sure to only write out the buffer if the iomap
actually is valid, because we wouldn't have a proper mapping
otherwise.  In practice we will never get an invalid mapping here
as the page lock guarantees truncate doesn't race with us, but
better be safe than sorry.  Also make sure we allocate a new ioend
when crossing boundaries between mappings, just like we do for
delalloc and unwritten extents.  Again this currently doesn't
matter as the I/O end handler only cares for the boundaries for
unwritten extents, but this makes the code fully correct and the
same as for delalloc/unwritten extents.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-12-09 15:47:31.707272459 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-12-09 15:47:44.805272667 +0100
@@ -1051,6 +1051,8 @@ xfs_vm_writepage(
 	type = IO_NEW;
 
 	do {
+		int new_ioend = 0;
+
 		if (offset >= end_offset)
 			break;
 		if (!buffer_uptodate(bh))
@@ -1071,8 +1073,6 @@ xfs_vm_writepage(
 			imap_valid = xfs_imap_valid(inode, &imap, offset);
 
 		if (buffer_unwritten(bh) || buffer_delay(bh)) {
-			int new_ioend = 0;
-
 			if (buffer_unwritten(bh)) {
 				if (type != IO_UNWRITTEN) {
 					type = IO_UNWRITTEN;
@@ -1124,6 +1124,7 @@ xfs_vm_writepage(
 				imap_valid = 0;
 			}
 			if (!imap_valid) {
+				new_ioend = 1;
 				size = xfs_probe_cluster(inode, page, bh, head);
 				err = xfs_map_blocks(inode, offset, size,
 						&imap, flags);
@@ -1142,14 +1143,12 @@ xfs_vm_writepage(
 			 * that we are writing into for the first time.
 			 */
 			type = IO_NEW;
-			if (trylock_buffer(bh)) {
-				if (imap_valid)
-					all_bh = 1;
+			if (imap_valid) {
+				all_bh = 1;
+				lock_buffer(bh);
 				xfs_add_to_ioend(inode, bh, offset, type,
-						&ioend, !imap_valid);
+						&ioend, new_ioend);
 				count++;
-			} else {
-				imap_valid = 0;
 			}
 		} else if (PageUptodate(page)) {
 			ASSERT(buffer_mapped(bh));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

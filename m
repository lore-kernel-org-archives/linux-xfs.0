Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAMD7Rsp228610 for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 07:07:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3E6F13DECAD
	for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 05:09:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id H3M16Y8lI6GFwdyH for
	<xfs@oss.sgi.com>; Mon, 22 Nov 2010 05:09:04 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PKW8l-0005dV-If
	for xfs@oss.sgi.com; Mon, 22 Nov 2010 13:09:03 +0000
Message-Id: <20101122130903.533699161@bombadil.infradead.org>
Date: Mon, 22 Nov 2010 08:05:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/10] xfs: a few small tweaks for overwrites in
	xfs_vm_writepage
References: <20101122130506.868076797@bombadil.infradead.org>
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

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-11-19 14:56:20.698273575 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-11-19 14:58:28.232030174 +0100
@@ -1096,6 +1096,8 @@ xfs_vm_writepage(
 	type = IO_NEW;
 
 	do {
+		int new_ioend = 0;
+
 		if (offset >= end_offset)
 			break;
 		if (!buffer_uptodate(bh))
@@ -1116,8 +1118,6 @@ xfs_vm_writepage(
 			imap_valid = xfs_imap_valid(inode, &imap, offset);
 
 		if (buffer_unwritten(bh) || buffer_delay(bh)) {
-			int new_ioend = 0;
-
 			if (buffer_unwritten(bh)) {
 				if (type != IO_UNWRITTEN) {
 					type = IO_UNWRITTEN;
@@ -1169,6 +1169,7 @@ xfs_vm_writepage(
 				imap_valid = 0;
 			}
 			if (!imap_valid) {
+				new_ioend = 1;
 				size = xfs_probe_cluster(inode, page, bh, head);
 				err = xfs_map_blocks(inode, offset, size,
 						&imap, flags);
@@ -1187,14 +1188,12 @@ xfs_vm_writepage(
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

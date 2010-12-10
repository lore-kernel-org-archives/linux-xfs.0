Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBA8fE4q205194 for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 02:41:14 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06144160F98E
	for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id beg1NP4dVCRIg084 for
	<xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:03 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PQyZD-0006RQ-Be
	for xfs@oss.sgi.com; Fri, 10 Dec 2010 08:43:03 +0000
Message-Id: <20101210084303.320837611@bombadil.infradead.org>
Date: Fri, 10 Dec 2010 03:42:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/10] xfs: refactor xfs_vm_writepage
References: <20101210084215.259628825@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-factor-writepage
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

After the last patches the code for overwrites is the same as for
delayed and unwritten extents except that it doesn't need to call
xfs_map_at_offset.  Take care of that fact to simplify xfs_vm_writepage.

The buffer loop now first checks the type of buffer and checks/sets
the ioend type, or continues to the next buffer if it's not interesting
to us.  Only after that we validate the iomap and perform the block
mapping if needed, all in common code for the cases where we have to
do work.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-12-09 15:52:12.718004124 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-12-09 15:52:23.144273297 +0100
@@ -999,74 +999,55 @@ xfs_vm_writepage(
 			continue;
 		}
 
-		if (imap_valid)
-			imap_valid = xfs_imap_valid(inode, &imap, offset);
-
-		if (buffer_unwritten(bh) || buffer_delay(bh)) {
-			if (buffer_unwritten(bh)) {
-				if (type != IO_UNWRITTEN) {
-					type = IO_UNWRITTEN;
-					imap_valid = 0;
-				}
-			} else if (buffer_delay(bh)) {
-				if (type != IO_DELALLOC) {
-					type = IO_DELALLOC;
-					imap_valid = 0;
-				}
-			}
-
-			if (!imap_valid) {
-				/*
-				 * If we didn't have a valid mapping then we
-				 * need to ensure that we put the new mapping
-				 * in a new ioend structure. This needs to be
-				 * done to ensure that the ioends correctly
-				 * reflect the block mappings at io completion
-				 * for unwritten extent conversion.
-				 */
-				new_ioend = 1;
-				err = xfs_map_blocks(inode, offset, &imap,
-						     type, nonblocking);
-				if (err)
-					goto error;
-				imap_valid = xfs_imap_valid(inode, &imap,
-							    offset);
+		if (buffer_unwritten(bh)) {
+			if (type != IO_UNWRITTEN) {
+				type = IO_UNWRITTEN;
+				imap_valid = 0;
 			}
-			if (imap_valid) {
-				xfs_map_at_offset(inode, bh, &imap, offset);
-				xfs_add_to_ioend(inode, bh, offset, type,
-						 &ioend, new_ioend);
-				count++;
+		} else if (buffer_delay(bh)) {
+			if (type != IO_DELALLOC) {
+				type = IO_DELALLOC;
+				imap_valid = 0;
 			}
 		} else if (buffer_uptodate(bh)) {
-			/*
-			 * we got here because the buffer is already mapped.
-			 * That means it must already have extents allocated
-			 * underneath it. Map the extent by reading it.
-			 */
 			if (type != IO_OVERWRITE) {
 				type = IO_OVERWRITE;
 				imap_valid = 0;
 			}
-			if (!imap_valid) {
-				new_ioend = 1;
-				err = xfs_map_blocks(inode, offset,
-						&imap, type, nonblocking);
-				if (err)
-					goto error;
-				imap_valid = xfs_imap_valid(inode, &imap,
-							    offset);
+		} else {
+			if (PageUptodate(page)) {
+				ASSERT(buffer_mapped(bh));
+				imap_valid = 0;
 			}
+			continue;
+		}
 
-			if (imap_valid) {
+		if (imap_valid)
+			imap_valid = xfs_imap_valid(inode, &imap, offset);
+		if (!imap_valid) {
+			/*
+			 * If we didn't have a valid mapping then we need to
+			 * put the new mapping into a separate ioend structure.
+			 * This ensures non-contiguous extents always have
+			 * separate ioends, which is particularly important
+			 * for unwritten extent conversion at I/O completion
+			 * time.
+			 */
+			new_ioend = 1;
+			err = xfs_map_blocks(inode, offset, &imap, type,
+					     nonblocking);
+			if (err)
+				goto error;
+			imap_valid = xfs_imap_valid(inode, &imap, offset);
+		}
+		if (imap_valid) {
+			if (type == IO_OVERWRITE)
 				lock_buffer(bh);
-				xfs_add_to_ioend(inode, bh, offset, type,
-						&ioend, new_ioend);
-				count++;
-			}
-		} else if (PageUptodate(page)) {
-			ASSERT(buffer_mapped(bh));
-			imap_valid = 0;
+			else
+				xfs_map_at_offset(inode, bh, &imap, offset);
+			xfs_add_to_ioend(inode, bh, offset, type, &ioend,
+					 new_ioend);
+			count++;
 		}
 
 		if (!iohead)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

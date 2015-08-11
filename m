Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA9047F51
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 17:49:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3D2F2AC003
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 15:49:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	4j1BoJmKa0G7ZIbs for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 15:49:53 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZPIMh-0005YF-05
	for xfs@oss.sgi.com; Wed, 12 Aug 2015 08:49:51 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ZPIMg-0004OU-VM
	for xfs@oss.sgi.com; Wed, 12 Aug 2015 08:49:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/8] xfs: io type needs to be part of the writepage context
Date: Wed, 12 Aug 2015 08:49:42 +1000
Message-Id: <1439333388-16452-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1439333388-16452-1-git-send-email-david@fromorbit.com>
References: <1439333388-16452-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

If we don't pass the IO type we are mapping with the writepage
context, then the imap is recalculated on every delalloc page that
is passed to xfs_do_writepage(). This defeats the purpose of having
a cached imap between calls and increases the overhead of delalloc
writeback significantly.

Fix this by moving the io type into the writepage context structure
so that it moves with the cached imap through the stack.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6dc1154..4d5479d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -42,6 +42,7 @@
 struct xfs_writepage_ctx {
 	struct xfs_bmbt_irec    imap;
 	bool			imap_valid;
+	unsigned int		io_type;
 };
 
 void
@@ -952,7 +953,6 @@ xfs_do_writepage(
 	struct buffer_head	*bh, *head;
 	xfs_ioend_t		*ioend = NULL, *iohead = NULL;
 	loff_t			offset;
-	unsigned int		type;
 	__uint64_t              end_offset;
 	pgoff_t                 end_index, last_index;
 	ssize_t			len;
@@ -1056,7 +1056,6 @@ xfs_do_writepage(
 
 	bh = head = page_buffers(page);
 	offset = page_offset(page);
-	type = XFS_IO_OVERWRITE;
 
 	if (wbc->sync_mode == WB_SYNC_NONE)
 		nonblocking = 1;
@@ -1081,18 +1080,18 @@ xfs_do_writepage(
 		}
 
 		if (buffer_unwritten(bh)) {
-			if (type != XFS_IO_UNWRITTEN) {
-				type = XFS_IO_UNWRITTEN;
+			if (wpc->io_type != XFS_IO_UNWRITTEN) {
+				wpc->io_type = XFS_IO_UNWRITTEN;
 				wpc->imap_valid = false;
 			}
 		} else if (buffer_delay(bh)) {
-			if (type != XFS_IO_DELALLOC) {
-				type = XFS_IO_DELALLOC;
+			if (wpc->io_type != XFS_IO_DELALLOC) {
+				wpc->io_type = XFS_IO_DELALLOC;
 				wpc->imap_valid = false;
 			}
 		} else if (buffer_uptodate(bh)) {
-			if (type != XFS_IO_OVERWRITE) {
-				type = XFS_IO_OVERWRITE;
+			if (wpc->io_type != XFS_IO_OVERWRITE) {
+				wpc->io_type = XFS_IO_OVERWRITE;
 				wpc->imap_valid = false;
 			}
 		} else {
@@ -1121,8 +1120,8 @@ xfs_do_writepage(
 			 * time.
 			 */
 			new_ioend = 1;
-			err = xfs_map_blocks(inode, offset, &wpc->imap, type,
-					     nonblocking);
+			err = xfs_map_blocks(inode, offset, &wpc->imap,
+					     wpc->io_type, nonblocking);
 			if (err)
 				goto error;
 			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
@@ -1130,10 +1129,10 @@ xfs_do_writepage(
 		}
 		if (wpc->imap_valid) {
 			lock_buffer(bh);
-			if (type != XFS_IO_OVERWRITE)
+			if (wpc->io_type != XFS_IO_OVERWRITE)
 				xfs_map_at_offset(inode, bh, &wpc->imap, offset);
-			xfs_add_to_ioend(inode, bh, offset, type, &ioend,
-					 new_ioend);
+			xfs_add_to_ioend(inode, bh, offset, wpc->io_type,
+					 &ioend, new_ioend);
 			count++;
 		}
 
@@ -1214,7 +1213,9 @@ xfs_vm_writepage(
 	struct page		*page,
 	struct writeback_control *wbc)
 {
-	struct xfs_writepage_ctx wpc = {};
+	struct xfs_writepage_ctx wpc = {
+		.io_type = XFS_IO_OVERWRITE,
+	};
 
 	return xfs_do_writepage(page, wbc, &wpc);
 }
@@ -1224,7 +1225,9 @@ xfs_vm_writepages(
 	struct address_space	*mapping,
 	struct writeback_control *wbc)
 {
-	struct xfs_writepage_ctx wpc = {};
+	struct xfs_writepage_ctx wpc = {
+		.io_type = XFS_IO_OVERWRITE,
+	};
 	struct blk_plug		plug;
 	int			ret;
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

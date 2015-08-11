Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 79B757F59
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 17:50:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 43B168F8035
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 15:50:00 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	BJmt7JcxzZuRUYQV for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 15:49:57 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZPIMg-0005YE-Vi
	for xfs@oss.sgi.com; Wed, 12 Aug 2015 08:49:51 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ZPIMg-0004OP-V2
	for xfs@oss.sgi.com; Wed, 12 Aug 2015 08:49:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/8] xfs: Introduce writeback context for writepages
Date: Wed, 12 Aug 2015 08:49:41 +1000
Message-Id: <1439333388-16452-2-git-send-email-david@fromorbit.com>
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

xfs_vm_writepages() calls generic_writepages to writeback a range of
a file, but then xfs_vm_writepage() clusters pages itself as it does
not have any context it can pass between->writepage calls from
__write_cache_pages().

Introduce a writeback context for xfs_vm_writepages() and call
__write_cache_pages directly with our own writepage callback so that
we can pass that context to each writepage invocation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 73 +++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3859f5e..6dc1154 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -36,6 +36,14 @@
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
 
+/*
+ * structure owned by writepages passed to individual writepage calls
+ */
+struct xfs_writepage_ctx {
+	struct xfs_bmbt_irec    imap;
+	bool			imap_valid;
+};
+
 void
 xfs_count_page_state(
 	struct page		*page,
@@ -334,7 +342,7 @@ xfs_map_blocks(
 	return 0;
 }
 
-STATIC int
+STATIC bool
 xfs_imap_valid(
 	struct inode		*inode,
 	struct xfs_bmbt_irec	*imap,
@@ -934,20 +942,21 @@ out_invalidate:
  * For any other dirty buffer heads on the page we should flush them.
  */
 STATIC int
-xfs_vm_writepage(
+xfs_do_writepage(
 	struct page		*page,
-	struct writeback_control *wbc)
+	struct writeback_control *wbc,
+	void			*data)
 {
+	struct xfs_writepage_ctx *wpc = data;
 	struct inode		*inode = page->mapping->host;
 	struct buffer_head	*bh, *head;
-	struct xfs_bmbt_irec	imap;
 	xfs_ioend_t		*ioend = NULL, *iohead = NULL;
 	loff_t			offset;
 	unsigned int		type;
 	__uint64_t              end_offset;
 	pgoff_t                 end_index, last_index;
 	ssize_t			len;
-	int			err, imap_valid = 0, uptodate = 1;
+	int			err, uptodate = 1;
 	int			count = 0;
 	int			nonblocking = 0;
 
@@ -1067,24 +1076,24 @@ xfs_vm_writepage(
 		 * buffers covering holes here.
 		 */
 		if (!buffer_mapped(bh) && buffer_uptodate(bh)) {
-			imap_valid = 0;
+			wpc->imap_valid = false;
 			continue;
 		}
 
 		if (buffer_unwritten(bh)) {
 			if (type != XFS_IO_UNWRITTEN) {
 				type = XFS_IO_UNWRITTEN;
-				imap_valid = 0;
+				wpc->imap_valid = false;
 			}
 		} else if (buffer_delay(bh)) {
 			if (type != XFS_IO_DELALLOC) {
 				type = XFS_IO_DELALLOC;
-				imap_valid = 0;
+				wpc->imap_valid = false;
 			}
 		} else if (buffer_uptodate(bh)) {
 			if (type != XFS_IO_OVERWRITE) {
 				type = XFS_IO_OVERWRITE;
-				imap_valid = 0;
+				wpc->imap_valid = false;
 			}
 		} else {
 			if (PageUptodate(page))
@@ -1095,13 +1104,14 @@ xfs_vm_writepage(
 			 * subsequent writeable buffers into a new
 			 * ioend.
 			 */
-			imap_valid = 0;
+			wpc->imap_valid = false;
 			continue;
 		}
 
-		if (imap_valid)
-			imap_valid = xfs_imap_valid(inode, &imap, offset);
-		if (!imap_valid) {
+		if (wpc->imap_valid)
+			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
+							 offset);
+		if (!wpc->imap_valid) {
 			/*
 			 * If we didn't have a valid mapping then we need to
 			 * put the new mapping into a separate ioend structure.
@@ -1111,16 +1121,17 @@ xfs_vm_writepage(
 			 * time.
 			 */
 			new_ioend = 1;
-			err = xfs_map_blocks(inode, offset, &imap, type,
+			err = xfs_map_blocks(inode, offset, &wpc->imap, type,
 					     nonblocking);
 			if (err)
 				goto error;
-			imap_valid = xfs_imap_valid(inode, &imap, offset);
+			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
+							 offset);
 		}
-		if (imap_valid) {
+		if (wpc->imap_valid) {
 			lock_buffer(bh);
 			if (type != XFS_IO_OVERWRITE)
-				xfs_map_at_offset(inode, bh, &imap, offset);
+				xfs_map_at_offset(inode, bh, &wpc->imap, offset);
 			xfs_add_to_ioend(inode, bh, offset, type, &ioend,
 					 new_ioend);
 			count++;
@@ -1147,10 +1158,10 @@ xfs_vm_writepage(
 	 * completion path as we have marked the initial page as under writeback
 	 * and unlocked it.
 	 */
-	if (imap_valid) {
+	if (wpc->imap_valid) {
 		xfs_off_t		end_index;
 
-		end_index = imap.br_startoff + imap.br_blockcount;
+		end_index = wpc->imap.br_startoff + wpc->imap.br_blockcount;
 
 		/* to bytes */
 		end_index <<= inode->i_blkbits;
@@ -1162,7 +1173,7 @@ xfs_vm_writepage(
 		if (end_index > last_index)
 			end_index = last_index;
 
-		xfs_cluster_write(inode, page->index + 1, &imap, &ioend,
+		xfs_cluster_write(inode, page->index + 1, &wpc->imap, &ioend,
 				  wbc, end_index);
 	}
 
@@ -1188,6 +1199,8 @@ error:
 	xfs_aops_discard_page(page);
 	ClearPageUptodate(page);
 	unlock_page(page);
+	mapping_set_error(page->mapping, err);
+	wpc->imap_valid = false;
 	return err;
 
 redirty:
@@ -1197,12 +1210,30 @@ redirty:
 }
 
 STATIC int
+xfs_vm_writepage(
+	struct page		*page,
+	struct writeback_control *wbc)
+{
+	struct xfs_writepage_ctx wpc = {};
+
+	return xfs_do_writepage(page, wbc, &wpc);
+}
+
+STATIC int
 xfs_vm_writepages(
 	struct address_space	*mapping,
 	struct writeback_control *wbc)
 {
+	struct xfs_writepage_ctx wpc = {};
+	struct blk_plug		plug;
+	int			ret;
+
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
-	return generic_writepages(mapping, wbc);
+	blk_start_plug(&plug);
+	ret = write_cache_pages(mapping, wbc, xfs_do_writepage, &wpc);
+	blk_finish_plug(&plug);
+
+	return ret;
 }
 
 /*
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

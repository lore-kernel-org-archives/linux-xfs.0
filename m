Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NefZ4067636 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:41 -0600
Message-Id: <20121203144310.289239261@sgi.com>
Date: Mon, 03 Dec 2012 17:42:24 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 16/36] xfs: page type check in writeback only
	checks last buffer
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=075
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: 6ffc4db5de61d36e969a26bc94509c59246c81f8

xfs_is_delayed_page() checks to see if a page has buffers matching
the given IO type passed in. It does so by walking the buffer heads
on the page and checking if the state flags match the IO type.

However, the "acceptable" variable that is calculated is overwritten
every time a new buffer is checked. Hence if the first buffer on the
page is of the right type, this state is lost if the second buffer
is not of the correct type. This means that xfs_aops_discard_page()
may not discard delalloc regions when it is supposed to, and
xfs_convert_page() may not cluster IO as efficiently as possible.

This problem only occurs on filesystems with a block size smaller
than page size.

Also, rename xfs_is_delayed_page() to xfs_check_page_type() to
better describe what it is doing - it is not delalloc specific
anymore.

The problem was first noticed by Peter Watkins.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -636,7 +636,7 @@ xfs_map_at_offset(
  * or delayed allocate extent.
  */
 STATIC int
-xfs_is_delayed_page(
+xfs_check_page_type(
 	struct page		*page,
 	unsigned int		type)
 {
@@ -650,11 +650,11 @@ xfs_is_delayed_page(
 		bh = head = page_buffers(page);
 		do {
 			if (buffer_unwritten(bh))
-				acceptable = (type == IO_UNWRITTEN);
+				acceptable += (type == IO_UNWRITTEN);
 			else if (buffer_delay(bh))
-				acceptable = (type == IO_DELALLOC);
+				acceptable += (type == IO_DELALLOC);
 			else if (buffer_dirty(bh) && buffer_mapped(bh))
-				acceptable = (type == IO_OVERWRITE);
+				acceptable += (type == IO_OVERWRITE);
 			else
 				break;
 		} while ((bh = bh->b_this_page) != head);
@@ -697,7 +697,7 @@ xfs_convert_page(
 		goto fail_unlock_page;
 	if (page->mapping != inode->i_mapping)
 		goto fail_unlock_page;
-	if (!xfs_is_delayed_page(page, (*ioendp)->io_type))
+	if (!xfs_check_page_type(page, (*ioendp)->io_type))
 		goto fail_unlock_page;
 
 	/*
@@ -847,7 +847,7 @@ xfs_aops_discard_page(
 	struct buffer_head	*bh, *head;
 	loff_t			offset = page_offset(page);
 
-	if (!xfs_is_delayed_page(page, IO_DELALLOC))
+	if (!xfs_check_page_type(page, IO_DELALLOC))
 		goto out_invalidate;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

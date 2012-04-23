Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xZuU127565 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:35 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	TzIiDXWxl3FXTAx4 for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:33 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCJ8-0001aK-Ov
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:30 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCIo-0004Y0-Lo
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/37] xfs: page type check in writeback only checks last
	buffer
Date: Mon, 23 Apr 2012 15:58:43 +1000
Message-Id: <1335160747-17254-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

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
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_aops.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 0fd7c2b..4588a7c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -623,7 +623,7 @@ xfs_map_at_offset(
  * or delayed allocate extent.
  */
 STATIC int
-xfs_is_delayed_page(
+xfs_check_page_type(
 	struct page		*page,
 	unsigned int		type)
 {
@@ -637,11 +637,11 @@ xfs_is_delayed_page(
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
@@ -684,7 +684,7 @@ xfs_convert_page(
 		goto fail_unlock_page;
 	if (page->mapping != inode->i_mapping)
 		goto fail_unlock_page;
-	if (!xfs_is_delayed_page(page, (*ioendp)->io_type))
+	if (!xfs_check_page_type(page, (*ioendp)->io_type))
 		goto fail_unlock_page;
 
 	/*
@@ -834,7 +834,7 @@ xfs_aops_discard_page(
 	struct buffer_head	*bh, *head;
 	loff_t			offset = page_offset(page);
 
-	if (!xfs_is_delayed_page(page, IO_DELALLOC))
+	if (!xfs_check_page_type(page, IO_DELALLOC))
 		goto out_invalidate;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

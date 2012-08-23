Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54KgU135667 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:20 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7Jlvp8gQsoPhD8tV for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:05 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbK-0003J5-KY
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PbA-0003hY-9u
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 075/102] xfs: page type check in writeback only checks last
	buffer
Date: Thu, 23 Aug 2012 15:02:33 +1000
Message-Id: <1345698180-13612-76-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index d2d3c84..51f7db1 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -660,7 +660,7 @@ xfs_map_at_offset(
  * or delayed allocate extent.
  */
 STATIC int
-xfs_is_delayed_page(
+xfs_check_page_type(
 	struct page		*page,
 	unsigned int		type)
 {
@@ -674,11 +674,11 @@ xfs_is_delayed_page(
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
@@ -721,7 +721,7 @@ xfs_convert_page(
 		goto fail_unlock_page;
 	if (page->mapping != inode->i_mapping)
 		goto fail_unlock_page;
-	if (!xfs_is_delayed_page(page, (*ioendp)->io_type))
+	if (!xfs_check_page_type(page, (*ioendp)->io_type))
 		goto fail_unlock_page;
 
 	/*
@@ -871,7 +871,7 @@ xfs_aops_discard_page(
 	struct buffer_head	*bh, *head;
 	loff_t			offset = page_offset(page);
 
-	if (!xfs_is_delayed_page(page, IO_DELALLOC))
+	if (!xfs_check_page_type(page, IO_DELALLOC))
 		goto out_invalidate;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

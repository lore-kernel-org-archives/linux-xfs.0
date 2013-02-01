Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 041877F56
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 04:44:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BB7918F8039
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 02:44:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VDTJXQJmxhvzbCmD for
	<xfs@oss.sgi.com>; Fri, 01 Feb 2013 02:44:00 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 04/18] jbd: change journal_invalidatepage() to accept length
Date: Fri,  1 Feb 2013 11:43:30 +0100
Message-Id: <1359715424-32318-5-git-send-email-lczerner@redhat.com>
In-Reply-To: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
References: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
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
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

->invalidatepage() aop now accepts range to invalidate so we can make
use of it in journal_invalidatepage() and all the users in ext3 file
system. Also update ext3 trace point to print out length argument.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext3/inode.c             |    6 +++---
 fs/jbd/transaction.c        |   19 ++++++++++++++-----
 include/linux/jbd.h         |    2 +-
 include/trace/events/ext3.h |   12 +++++++-----
 4 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 0b8d382..88404fd 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1824,15 +1824,15 @@ static void ext3_invalidatepage(struct page *page, unsigned int offset,
 {
 	journal_t *journal = EXT3_JOURNAL(page->mapping->host);
 
-	trace_ext3_invalidatepage(page, offset);
+	trace_ext3_invalidatepage(page, offset, length);
 
 	/*
 	 * If it's a full truncate we just forget about the pending dirtying
 	 */
-	if (offset == 0)
+	if (offset == 0 && length == PAGE_CACHE_SIZE)
 		ClearPageChecked(page);
 
-	journal_invalidatepage(journal, page, offset);
+	journal_invalidatepage(journal, page, offset, length);
 }
 
 static int ext3_releasepage(struct page *page, gfp_t wait)
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 071d690..a1fef89 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -2020,16 +2020,20 @@ zap_buffer_unlocked:
  * void journal_invalidatepage() - invalidate a journal page
  * @journal: journal to use for flush
  * @page:    page to flush
- * @offset:  length of page to invalidate.
+ * @offset:  offset of the range to invalidate
+ * @length:  length of the range to invalidate
  *
- * Reap page buffers containing data after offset in page.
+ * Reap page buffers containing data in specified range in page.
  */
 void journal_invalidatepage(journal_t *journal,
 		      struct page *page,
-		      unsigned long offset)
+		      unsigned int offset,
+		      unsigned int length)
 {
 	struct buffer_head *head, *bh, *next;
+	unsigned int stop = offset + length;
 	unsigned int curr_off = 0;
+	int partial_page = (offset || length < PAGE_CACHE_SIZE);
 	int may_free = 1;
 
 	if (!PageLocked(page))
@@ -2037,6 +2041,8 @@ void journal_invalidatepage(journal_t *journal,
 	if (!page_has_buffers(page))
 		return;
 
+	BUG_ON(stop > PAGE_CACHE_SIZE || stop < length);
+
 	/* We will potentially be playing with lists other than just the
 	 * data lists (especially for journaled data mode), so be
 	 * cautious in our locking. */
@@ -2046,11 +2052,14 @@ void journal_invalidatepage(journal_t *journal,
 		unsigned int next_off = curr_off + bh->b_size;
 		next = bh->b_this_page;
 
+		if (next_off > stop)
+			return;
+
 		if (offset <= curr_off) {
 			/* This block is wholly outside the truncation point */
 			lock_buffer(bh);
 			may_free &= journal_unmap_buffer(journal, bh,
-							 offset > 0);
+							 partial_page);
 			unlock_buffer(bh);
 		}
 		curr_off = next_off;
@@ -2058,7 +2067,7 @@ void journal_invalidatepage(journal_t *journal,
 
 	} while (bh != head);
 
-	if (!offset) {
+	if (!partial_page) {
 		if (may_free && try_to_free_buffers(page))
 			J_ASSERT(!page_has_buffers(page));
 	}
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index c8f3297..d02e16c 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -840,7 +840,7 @@ extern void	 journal_release_buffer (handle_t *, struct buffer_head *);
 extern int	 journal_forget (handle_t *, struct buffer_head *);
 extern void	 journal_sync_buffer (struct buffer_head *);
 extern void	 journal_invalidatepage(journal_t *,
-				struct page *, unsigned long);
+				struct page *, unsigned int, unsigned int);
 extern int	 journal_try_to_free_buffers(journal_t *, struct page *, gfp_t);
 extern int	 journal_stop(handle_t *);
 extern int	 journal_flush (journal_t *);
diff --git a/include/trace/events/ext3.h b/include/trace/events/ext3.h
index 15d11a3..6797b9d 100644
--- a/include/trace/events/ext3.h
+++ b/include/trace/events/ext3.h
@@ -290,13 +290,14 @@ DEFINE_EVENT(ext3__page_op, ext3_releasepage,
 );
 
 TRACE_EVENT(ext3_invalidatepage,
-	TP_PROTO(struct page *page, unsigned long offset),
+	TP_PROTO(struct page *page, unsigned int offset, unsigned int length),
 
-	TP_ARGS(page, offset),
+	TP_ARGS(page, offset, length),
 
 	TP_STRUCT__entry(
 		__field(	pgoff_t, index			)
-		__field(	unsigned long, offset		)
+		__field(	unsigned int, offset		)
+		__field(	unsigned int, length		)
 		__field(	ino_t,	ino			)
 		__field(	dev_t,	dev			)
 
@@ -305,14 +306,15 @@ TRACE_EVENT(ext3_invalidatepage,
 	TP_fast_assign(
 		__entry->index	= page->index;
 		__entry->offset	= offset;
+		__entry->length	= length;
 		__entry->ino	= page->mapping->host->i_ino;
 		__entry->dev	= page->mapping->host->i_sb->s_dev;
 	),
 
-	TP_printk("dev %d,%d ino %lu page_index %lu offset %lu",
+	TP_printk("dev %d,%d ino %lu page_index %lu offset %u length %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
-		  __entry->index, __entry->offset)
+		  __entry->index, __entry->offset, __entry->length)
 );
 
 TRACE_EVENT(ext3_discard_blocks,
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

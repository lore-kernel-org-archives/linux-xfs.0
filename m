Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E9A0B7F37
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 11:37:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84D16AC007
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 09:37:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DPhmXXVBH2TR6pxu for
	<xfs@oss.sgi.com>; Tue, 14 May 2013 09:37:54 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v4 05/20] xfs: use ->invalidatepage() length argument
Date: Tue, 14 May 2013 18:37:19 +0200
Message-Id: <1368549454-8930-6-git-send-email-lczerner@redhat.com>
In-Reply-To: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
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
Cc: hughd@google.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org

->invalidatepage() aop now accepts range to invalidate so we can make
use of it in xfs_vm_invalidatepage()

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com
---
v4: use xfs_page_class instead of separate tracepoint

 fs/xfs/xfs_aops.c  |    9 +++++----
 fs/xfs/xfs_trace.h |   15 ++++++++++-----
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e426796..55c85ec 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -826,8 +826,9 @@ xfs_vm_invalidatepage(
 	unsigned int		offset,
 	unsigned int		length)
 {
-	trace_xfs_invalidatepage(page->mapping->host, page, offset);
-	block_invalidatepage(page, offset, PAGE_CACHE_SIZE - offset);
+	trace_xfs_invalidatepage(page->mapping->host, page, offset,
+				 length);
+	block_invalidatepage(page, offset, length);
 }
 
 /*
@@ -921,7 +922,7 @@ xfs_vm_writepage(
 	int			count = 0;
 	int			nonblocking = 0;
 
-	trace_xfs_writepage(inode, page, 0);
+	trace_xfs_writepage(inode, page, 0, 0);
 
 	ASSERT(page_has_buffers(page));
 
@@ -1152,7 +1153,7 @@ xfs_vm_releasepage(
 {
 	int			delalloc, unwritten;
 
-	trace_xfs_releasepage(page->mapping->host, page, 0);
+	trace_xfs_releasepage(page->mapping->host, page, 0, 0);
 
 	xfs_count_page_state(page, &delalloc, &unwritten);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 16a8129..7f075ed 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -950,14 +950,16 @@ DEFINE_RW_EVENT(xfs_file_splice_read);
 DEFINE_RW_EVENT(xfs_file_splice_write);
 
 DECLARE_EVENT_CLASS(xfs_page_class,
-	TP_PROTO(struct inode *inode, struct page *page, unsigned long off),
-	TP_ARGS(inode, page, off),
+	TP_PROTO(struct inode *inode, struct page *page, unsigned long off,
+		 unsigned int len),
+	TP_ARGS(inode, page, off, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(pgoff_t, pgoff)
 		__field(loff_t, size)
 		__field(unsigned long, offset)
+		__field(unsigned int, length)
 		__field(int, delalloc)
 		__field(int, unwritten)
 	),
@@ -971,24 +973,27 @@ DECLARE_EVENT_CLASS(xfs_page_class,
 		__entry->pgoff = page_offset(page);
 		__entry->size = i_size_read(inode);
 		__entry->offset = off;
+		__entry->length = len;
 		__entry->delalloc = delalloc;
 		__entry->unwritten = unwritten;
 	),
 	TP_printk("dev %d:%d ino 0x%llx pgoff 0x%lx size 0x%llx offset %lx "
-		  "delalloc %d unwritten %d",
+		  "length %x delalloc %d unwritten %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->pgoff,
 		  __entry->size,
 		  __entry->offset,
+		  __entry->length,
 		  __entry->delalloc,
 		  __entry->unwritten)
 )
 
 #define DEFINE_PAGE_EVENT(name)		\
 DEFINE_EVENT(xfs_page_class, name,	\
-	TP_PROTO(struct inode *inode, struct page *page, unsigned long off),	\
-	TP_ARGS(inode, page, off))
+	TP_PROTO(struct inode *inode, struct page *page, unsigned long off, \
+		 unsigned int len),	\
+	TP_ARGS(inode, page, off, len))
 DEFINE_PAGE_EVENT(xfs_writepage);
 DEFINE_PAGE_EVENT(xfs_releasepage);
 DEFINE_PAGE_EVENT(xfs_invalidatepage);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

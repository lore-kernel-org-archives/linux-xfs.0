Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6R81qPe190428 for <xfs@oss.sgi.com>; Fri, 27 Jul 2012 03:01:52 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rTxAJvzUxIqnLbqf for
	<xfs@oss.sgi.com>; Fri, 27 Jul 2012 01:01:51 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 04/15] xfs: implement invalidatepage_range aop
Date: Fri, 27 Jul 2012 10:01:03 +0200
Message-Id: <1343376074-28034-5-git-send-email-lczerner@redhat.com>
In-Reply-To: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
References: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: tytso@mit.edu, linux-mmc@vger.kernel.org, hughd@google.com, xfs@oss.sgi.com, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

mm now supports invalidatepage_range address space operation which is
useful to allow truncating page range which is not aligned to the end of
the page. This will help in punch hole implementation once
truncate_inode_pages_range() is modify to allow this as well.

With this commit xfs now register only invalidatepage_range.
Additionally we also update the respective trace point.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com
---
 fs/xfs/xfs_aops.c  |   14 ++++++++------
 fs/xfs/xfs_trace.h |   41 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8dad722..7aa3d68 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -798,12 +798,14 @@ xfs_cluster_write(
 }
 
 STATIC void
-xfs_vm_invalidatepage(
+xfs_vm_invalidatepage_range(
 	struct page		*page,
-	unsigned long		offset)
+	unsigned long		offset,
+	unsigned long		length)
 {
-	trace_xfs_invalidatepage(page->mapping->host, page, offset);
-	block_invalidatepage(page, offset);
+	trace_xfs_invalidatepage_range(page->mapping->host, page, offset,
+				       length);
+	block_invalidatepage_range(page, offset, length);
 }
 
 /*
@@ -867,7 +869,7 @@ next_buffer:
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out_invalidate:
-	xfs_vm_invalidatepage(page, 0);
+	xfs_vm_invalidatepage_range(page, 0, PAGE_CACHE_SIZE);
 	return;
 }
 
@@ -1613,7 +1615,7 @@ const struct address_space_operations xfs_address_space_operations = {
 	.writepage		= xfs_vm_writepage,
 	.writepages		= xfs_vm_writepages,
 	.releasepage		= xfs_vm_releasepage,
-	.invalidatepage		= xfs_vm_invalidatepage,
+	.invalidatepage_range	= xfs_vm_invalidatepage_range,
 	.write_begin		= xfs_vm_write_begin,
 	.write_end		= xfs_vm_write_end,
 	.bmap			= xfs_vm_bmap,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index caf5dab..1414e93 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -981,7 +981,46 @@ DEFINE_EVENT(xfs_page_class, name,	\
 	TP_ARGS(inode, page, off))
 DEFINE_PAGE_EVENT(xfs_writepage);
 DEFINE_PAGE_EVENT(xfs_releasepage);
-DEFINE_PAGE_EVENT(xfs_invalidatepage);
+
+TRACE_EVENT(xfs_invalidatepage_range,
+	TP_PROTO(struct inode *inode, struct page *page, unsigned long off,
+		 unsigned long len),
+	TP_ARGS(inode, page, off, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(pgoff_t, pgoff)
+		__field(loff_t, size)
+		__field(unsigned long, offset)
+		__field(unsigned long, length)
+		__field(int, delalloc)
+		__field(int, unwritten)
+	),
+	TP_fast_assign(
+		int delalloc = -1, unwritten = -1;
+
+		if (page_has_buffers(page))
+			xfs_count_page_state(page, &delalloc, &unwritten);
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = XFS_I(inode)->i_ino;
+		__entry->pgoff = page_offset(page);
+		__entry->size = i_size_read(inode);
+		__entry->offset = off;
+		__entry->length = len;
+		__entry->delalloc = delalloc;
+		__entry->unwritten = unwritten;
+	),
+	TP_printk("dev %d:%d ino 0x%llx pgoff 0x%lx size 0x%llx offset %lx "
+		  "length %lx delalloc %d unwritten %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->pgoff,
+		  __entry->size,
+		  __entry->offset,
+		  __entry->length,
+		  __entry->delalloc,
+		  __entry->unwritten)
+)
 
 DECLARE_EVENT_CLASS(xfs_imap_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

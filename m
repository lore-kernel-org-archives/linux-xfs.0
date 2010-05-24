Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4O8LJjD168438 for <xfs@oss.sgi.com>; Mon, 24 May 2010 03:21:20 -0500
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E7F01574727
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 01:25:13 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id DRPez0SmHD6BpC9J for
	<xfs@oss.sgi.com>; Mon, 24 May 2010 01:25:13 -0700 (PDT)
Message-ID: <4BFA3815.7070000@cn.fujitsu.com>
Date: Mon, 24 May 2010 16:25:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: convert more trace events to DEFINE_EVENT
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <dchinner@redhat.com>, Alex Elder <aelder@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com

Use DECLARE_EVENT_CLASS, and save ~15K:

   text    data     bss     dec     hex filename
 171949   43028      48  215025   347f1 fs/xfs/linux-2.6/xfs_trace.o.orig
 156521   43028      36  199585   30ba1 fs/xfs/linux-2.6/xfs_trace.o

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |  356 ++++++++++++++++++++++--------------------
 1 files changed, 188 insertions(+), 168 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 8a319cf..7f5fb71 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -82,33 +82,6 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	)
 )
 
-#define DEFINE_PERAG_REF_EVENT(name) \
-TRACE_EVENT(name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount, \
-		 unsigned long caller_ip), \
-	TP_ARGS(mp, agno, refcount, caller_ip), \
-	TP_STRUCT__entry( \
-		__field(dev_t, dev) \
-		__field(xfs_agnumber_t, agno) \
-		__field(int, refcount) \
-		__field(unsigned long, caller_ip) \
-	), \
-	TP_fast_assign( \
-		__entry->dev = mp->m_super->s_dev; \
-		__entry->agno = agno; \
-		__entry->refcount = refcount; \
-		__entry->caller_ip = caller_ip; \
-	), \
-	TP_printk("dev %d:%d agno %u refcount %d caller %pf", \
-		  MAJOR(__entry->dev), MINOR(__entry->dev), \
-		  __entry->agno, \
-		  __entry->refcount, \
-		  (char *)__entry->caller_ip) \
-);
-
-DEFINE_PERAG_REF_EVENT(xfs_perag_get)
-DEFINE_PERAG_REF_EVENT(xfs_perag_put)
-
 #define DEFINE_ATTR_LIST_EVENT(name) \
 DEFINE_EVENT(xfs_attr_list_class, name, \
 	TP_PROTO(struct xfs_attr_list_context *ctx), \
@@ -122,6 +95,37 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_list_add);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_list_wrong_blk);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound);
 
+DECLARE_EVENT_CLASS(xfs_perag_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
+		 unsigned long caller_ip),
+	TP_ARGS(mp, agno, refcount, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, refcount)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->refcount = refcount;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d agno %u refcount %d caller %pf",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->refcount,
+		  (char *)__entry->caller_ip)
+);
+
+#define DEFINE_PERAG_REF_EVENT(name)	\
+DEFINE_EVENT(xfs_perag_class, name,	\
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,	\
+		 unsigned long caller_ip),					\
+	TP_ARGS(mp, agno, refcount, caller_ip))
+DEFINE_PERAG_REF_EVENT(xfs_perag_get);
+DEFINE_PERAG_REF_EVENT(xfs_perag_put);
+
 TRACE_EVENT(xfs_attr_list_node_descend,
 	TP_PROTO(struct xfs_attr_list_context *ctx,
 		 struct xfs_da_node_entry *btree),
@@ -775,165 +779,181 @@ DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
 
-#define DEFINE_RW_EVENT(name) \
-TRACE_EVENT(name, \
-	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags), \
-	TP_ARGS(ip, count, offset, flags), \
-	TP_STRUCT__entry( \
-		__field(dev_t, dev) \
-		__field(xfs_ino_t, ino) \
-		__field(xfs_fsize_t, size) \
-		__field(xfs_fsize_t, new_size) \
-		__field(loff_t, offset) \
-		__field(size_t, count) \
-		__field(int, flags) \
-	), \
-	TP_fast_assign( \
-		__entry->dev = VFS_I(ip)->i_sb->s_dev; \
-		__entry->ino = ip->i_ino; \
-		__entry->size = ip->i_d.di_size; \
-		__entry->new_size = ip->i_new_size; \
-		__entry->offset = offset; \
-		__entry->count = count; \
-		__entry->flags = flags; \
-	), \
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx " \
-		  "offset 0x%llx count 0x%zx ioflags %s", \
-		  MAJOR(__entry->dev), MINOR(__entry->dev), \
-		  __entry->ino, \
-		  __entry->size, \
-		  __entry->new_size, \
-		  __entry->offset, \
-		  __entry->count, \
-		  __print_flags(__entry->flags, "|", XFS_IO_FLAGS)) \
+DECLARE_EVENT_CLASS(xfs_file_class,
+	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags),
+	TP_ARGS(ip, count, offset, flags),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_fsize_t, new_size)
+		__field(loff_t, offset)
+		__field(size_t, count)
+		__field(int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_d.di_size;
+		__entry->new_size = ip->i_new_size;
+		__entry->offset = offset;
+		__entry->count = count;
+		__entry->flags = flags;
+	),
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx "
+		  "offset 0x%llx count 0x%zx ioflags %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->new_size,
+		  __entry->offset,
+		  __entry->count,
+		  __print_flags(__entry->flags, "|", XFS_IO_FLAGS))
 )
+
+#define DEFINE_RW_EVENT(name)		\
+DEFINE_EVENT(xfs_file_class, name,	\
+	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags),	\
+	TP_ARGS(ip, count, offset, flags))
 DEFINE_RW_EVENT(xfs_file_read);
 DEFINE_RW_EVENT(xfs_file_buffered_write);
 DEFINE_RW_EVENT(xfs_file_direct_write);
 DEFINE_RW_EVENT(xfs_file_splice_read);
 DEFINE_RW_EVENT(xfs_file_splice_write);
 
-
-#define DEFINE_PAGE_EVENT(name) \
-TRACE_EVENT(name, \
-	TP_PROTO(struct inode *inode, struct page *page, unsigned long off), \
-	TP_ARGS(inode, page, off), \
-	TP_STRUCT__entry( \
-		__field(dev_t, dev) \
-		__field(xfs_ino_t, ino) \
-		__field(pgoff_t, pgoff) \
-		__field(loff_t, size) \
-		__field(unsigned long, offset) \
-		__field(int, delalloc) \
-		__field(int, unmapped) \
-		__field(int, unwritten) \
-	), \
-	TP_fast_assign( \
-		int delalloc = -1, unmapped = -1, unwritten = -1; \
-	\
-		if (page_has_buffers(page)) \
-			xfs_count_page_state(page, &delalloc, \
-					     &unmapped, &unwritten); \
-		__entry->dev = inode->i_sb->s_dev; \
-		__entry->ino = XFS_I(inode)->i_ino; \
-		__entry->pgoff = page_offset(page); \
-		__entry->size = i_size_read(inode); \
-		__entry->offset = off; \
-		__entry->delalloc = delalloc; \
-		__entry->unmapped = unmapped; \
-		__entry->unwritten = unwritten; \
-	), \
-	TP_printk("dev %d:%d ino 0x%llx pgoff 0x%lx size 0x%llx offset %lx " \
-		  "delalloc %d unmapped %d unwritten %d", \
-		  MAJOR(__entry->dev), MINOR(__entry->dev), \
-		  __entry->ino, \
-		  __entry->pgoff, \
-		  __entry->size, \
-		  __entry->offset, \
-		  __entry->delalloc, \
-		  __entry->unmapped, \
-		  __entry->unwritten) \
+DECLARE_EVENT_CLASS(xfs_page_class,
+	TP_PROTO(struct inode *inode, struct page *page, unsigned long off),
+	TP_ARGS(inode, page, off),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(pgoff_t, pgoff)
+		__field(loff_t, size)
+		__field(unsigned long, offset)
+		__field(int, delalloc)
+		__field(int, unmapped)
+		__field(int, unwritten)
+	),
+	TP_fast_assign(
+		int delalloc = -1, unmapped = -1, unwritten = -1;
+
+		if (page_has_buffers(page))
+			xfs_count_page_state(page, &delalloc,
+					     &unmapped, &unwritten);
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = XFS_I(inode)->i_ino;
+		__entry->pgoff = page_offset(page);
+		__entry->size = i_size_read(inode);
+		__entry->offset = off;
+		__entry->delalloc = delalloc;
+		__entry->unmapped = unmapped;
+		__entry->unwritten = unwritten;
+	),
+	TP_printk("dev %d:%d ino 0x%llx pgoff 0x%lx size 0x%llx offset %lx "
+		  "delalloc %d unmapped %d unwritten %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->pgoff,
+		  __entry->size,
+		  __entry->offset,
+		  __entry->delalloc,
+		  __entry->unmapped,
+		  __entry->unwritten)
 )
+
+#define DEFINE_PAGE_EVENT(name)		\
+DEFINE_EVENT(xfs_page_class, name,	\
+	TP_PROTO(struct inode *inode, struct page *page, unsigned long off),	\
+	TP_ARGS(inode, page, off))
 DEFINE_PAGE_EVENT(xfs_writepage);
 DEFINE_PAGE_EVENT(xfs_releasepage);
 DEFINE_PAGE_EVENT(xfs_invalidatepage);
 
-#define DEFINE_IOMAP_EVENT(name) \
-TRACE_EVENT(name, \
-	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count, \
-		 int flags, struct xfs_bmbt_irec *irec), \
-	TP_ARGS(ip, offset, count, flags, irec), \
-	TP_STRUCT__entry( \
-		__field(dev_t, dev) \
-		__field(xfs_ino_t, ino) \
-		__field(loff_t, size) \
-		__field(loff_t, new_size) \
-		__field(loff_t, offset) \
-		__field(size_t, count) \
-		__field(int, flags) \
-		__field(xfs_fileoff_t, startoff) \
-		__field(xfs_fsblock_t, startblock) \
-		__field(xfs_filblks_t, blockcount) \
-	), \
-	TP_fast_assign( \
-		__entry->dev = VFS_I(ip)->i_sb->s_dev; \
-		__entry->ino = ip->i_ino; \
-		__entry->size = ip->i_d.di_size; \
-		__entry->new_size = ip->i_new_size; \
-		__entry->offset = offset; \
-		__entry->count = count; \
-		__entry->flags = flags; \
-		__entry->startoff = irec ? irec->br_startoff : 0; \
-		__entry->startblock = irec ? irec->br_startblock : 0; \
-		__entry->blockcount = irec ? irec->br_blockcount : 0; \
-	), \
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx " \
-		  "offset 0x%llx count %zd flags %s " \
-		  "startoff 0x%llx startblock %lld blockcount 0x%llx", \
-		  MAJOR(__entry->dev), MINOR(__entry->dev), \
-		  __entry->ino, \
-		  __entry->size, \
-		  __entry->new_size, \
-		  __entry->offset, \
-		  __entry->count, \
-		  __print_flags(__entry->flags, "|", BMAPI_FLAGS), \
-		  __entry->startoff, \
-		  (__int64_t)__entry->startblock, \
-		  __entry->blockcount) \
+DECLARE_EVENT_CLASS(xfs_iomap_class,
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
+		 int flags, struct xfs_bmbt_irec *irec),
+	TP_ARGS(ip, offset, count, flags, irec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(loff_t, size)
+		__field(loff_t, new_size)
+		__field(loff_t, offset)
+		__field(size_t, count)
+		__field(int, flags)
+		__field(xfs_fileoff_t, startoff)
+		__field(xfs_fsblock_t, startblock)
+		__field(xfs_filblks_t, blockcount)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_d.di_size;
+		__entry->new_size = ip->i_new_size;
+		__entry->offset = offset;
+		__entry->count = count;
+		__entry->flags = flags;
+		__entry->startoff = irec ? irec->br_startoff : 0;
+		__entry->startblock = irec ? irec->br_startblock : 0;
+		__entry->blockcount = irec ? irec->br_blockcount : 0;
+	),
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx "
+		  "offset 0x%llx count %zd flags %s "
+		  "startoff 0x%llx startblock %lld blockcount 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->new_size,
+		  __entry->offset,
+		  __entry->count,
+		  __print_flags(__entry->flags, "|", BMAPI_FLAGS),
+		  __entry->startoff,
+		  (__int64_t)__entry->startblock,
+		  __entry->blockcount)
 )
+
+#define DEFINE_IOMAP_EVENT(name)	\
+DEFINE_EVENT(xfs_iomap_class, name,	\
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,	\
+		 int flags, struct xfs_bmbt_irec *irec),		\
+	TP_ARGS(ip, offset, count, flags, irec))
 DEFINE_IOMAP_EVENT(xfs_iomap_enter);
 DEFINE_IOMAP_EVENT(xfs_iomap_found);
 DEFINE_IOMAP_EVENT(xfs_iomap_alloc);
 
-#define DEFINE_SIMPLE_IO_EVENT(name) \
-TRACE_EVENT(name, \
-	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count), \
-	TP_ARGS(ip, offset, count), \
-	TP_STRUCT__entry( \
-		__field(dev_t, dev) \
-		__field(xfs_ino_t, ino) \
-		__field(loff_t, size) \
-		__field(loff_t, new_size) \
-		__field(loff_t, offset) \
-		__field(size_t, count) \
-	), \
-	TP_fast_assign( \
-		__entry->dev = VFS_I(ip)->i_sb->s_dev; \
-		__entry->ino = ip->i_ino; \
-		__entry->size = ip->i_d.di_size; \
-		__entry->new_size = ip->i_new_size; \
-		__entry->offset = offset; \
-		__entry->count = count; \
-	), \
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx " \
-		  "offset 0x%llx count %zd", \
-		  MAJOR(__entry->dev), MINOR(__entry->dev), \
-		  __entry->ino, \
-		  __entry->size, \
-		  __entry->new_size, \
-		  __entry->offset, \
-		  __entry->count) \
+DECLARE_EVENT_CLASS(xfs_simple_io_class,
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
+	TP_ARGS(ip, offset, count),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(loff_t, size)
+		__field(loff_t, new_size)
+		__field(loff_t, offset)
+		__field(size_t, count)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_d.di_size;
+		__entry->new_size = ip->i_new_size;
+		__entry->offset = offset;
+		__entry->count = count;
+	),
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx "
+		  "offset 0x%llx count %zd",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->new_size,
+		  __entry->offset,
+		  __entry->count)
 );
+
+#define DEFINE_SIMPLE_IO_EVENT(name)	\
+DEFINE_EVENT(xfs_simple_io_class, name,	\
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),	\
+	TP_ARGS(ip, offset, count))
 DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc);
 DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
 
-- 
1.6.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

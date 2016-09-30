Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42464 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754109AbcI3DId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:08:33 -0400
Subject: [PATCH 26/63] xfs: define tracepoints for reflink activities
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:08:29 -0700
Message-ID: <147520490964.29434.15859805604672051994.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Define all the tracepoints we need to inspect the runtime operation
of reflink/dedupe/copy-on-write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trace.h |  333 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 333 insertions(+)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index e17a4cf..5403199 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3024,6 +3024,339 @@ TRACE_EVENT(xfs_bmap_remap_alloc,
 );
 DEFINE_INODE_ERROR_EVENT(xfs_bmap_remap_alloc_error);
 
+/* reflink tracepoint classes */
+
+/* two-file io tracepoint class */
+DECLARE_EVENT_CLASS(xfs_double_io_class,
+	TP_PROTO(struct xfs_inode *src, xfs_off_t soffset, xfs_off_t len,
+		 struct xfs_inode *dest, xfs_off_t doffset),
+	TP_ARGS(src, soffset, len, dest, doffset),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, src_ino)
+		__field(loff_t, src_isize)
+		__field(loff_t, src_disize)
+		__field(loff_t, src_offset)
+		__field(size_t, len)
+		__field(xfs_ino_t, dest_ino)
+		__field(loff_t, dest_isize)
+		__field(loff_t, dest_disize)
+		__field(loff_t, dest_offset)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(src)->i_sb->s_dev;
+		__entry->src_ino = src->i_ino;
+		__entry->src_isize = VFS_I(src)->i_size;
+		__entry->src_disize = src->i_d.di_size;
+		__entry->src_offset = soffset;
+		__entry->len = len;
+		__entry->dest_ino = dest->i_ino;
+		__entry->dest_isize = VFS_I(dest)->i_size;
+		__entry->dest_disize = dest->i_d.di_size;
+		__entry->dest_offset = doffset;
+	),
+	TP_printk("dev %d:%d count %zd "
+		  "ino 0x%llx isize 0x%llx disize 0x%llx offset 0x%llx -> "
+		  "ino 0x%llx isize 0x%llx disize 0x%llx offset 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->len,
+		  __entry->src_ino,
+		  __entry->src_isize,
+		  __entry->src_disize,
+		  __entry->src_offset,
+		  __entry->dest_ino,
+		  __entry->dest_isize,
+		  __entry->dest_disize,
+		  __entry->dest_offset)
+)
+
+#define DEFINE_DOUBLE_IO_EVENT(name)	\
+DEFINE_EVENT(xfs_double_io_class, name,	\
+	TP_PROTO(struct xfs_inode *src, xfs_off_t soffset, xfs_off_t len, \
+		 struct xfs_inode *dest, xfs_off_t doffset), \
+	TP_ARGS(src, soffset, len, dest, doffset))
+
+/* two-file vfs io tracepoint class */
+DECLARE_EVENT_CLASS(xfs_double_vfs_io_class,
+	TP_PROTO(struct inode *src, u64 soffset, u64 len,
+		 struct inode *dest, u64 doffset),
+	TP_ARGS(src, soffset, len, dest, doffset),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, src_ino)
+		__field(loff_t, src_isize)
+		__field(loff_t, src_offset)
+		__field(size_t, len)
+		__field(unsigned long, dest_ino)
+		__field(loff_t, dest_isize)
+		__field(loff_t, dest_offset)
+	),
+	TP_fast_assign(
+		__entry->dev = src->i_sb->s_dev;
+		__entry->src_ino = src->i_ino;
+		__entry->src_isize = i_size_read(src);
+		__entry->src_offset = soffset;
+		__entry->len = len;
+		__entry->dest_ino = dest->i_ino;
+		__entry->dest_isize = i_size_read(dest);
+		__entry->dest_offset = doffset;
+	),
+	TP_printk("dev %d:%d count %zd "
+		  "ino 0x%lx isize 0x%llx offset 0x%llx -> "
+		  "ino 0x%lx isize 0x%llx offset 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->len,
+		  __entry->src_ino,
+		  __entry->src_isize,
+		  __entry->src_offset,
+		  __entry->dest_ino,
+		  __entry->dest_isize,
+		  __entry->dest_offset)
+)
+
+#define DEFINE_DOUBLE_VFS_IO_EVENT(name)	\
+DEFINE_EVENT(xfs_double_vfs_io_class, name,	\
+	TP_PROTO(struct inode *src, u64 soffset, u64 len, \
+		 struct inode *dest, u64 doffset), \
+	TP_ARGS(src, soffset, len, dest, doffset))
+
+/* CoW write tracepoint */
+DECLARE_EVENT_CLASS(xfs_copy_on_write_class,
+	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk, xfs_fsblock_t pblk,
+		 xfs_extlen_t len, xfs_fsblock_t new_pblk),
+	TP_ARGS(ip, lblk, pblk, len, new_pblk),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fileoff_t, lblk)
+		__field(xfs_fsblock_t, pblk)
+		__field(xfs_extlen_t, len)
+		__field(xfs_fsblock_t, new_pblk)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->lblk = lblk;
+		__entry->pblk = pblk;
+		__entry->len = len;
+		__entry->new_pblk = new_pblk;
+	),
+	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx pblk 0x%llx "
+		  "len 0x%x new_pblk %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->lblk,
+		  __entry->pblk,
+		  __entry->len,
+		  __entry->new_pblk)
+)
+
+#define DEFINE_COW_EVENT(name)	\
+DEFINE_EVENT(xfs_copy_on_write_class, name,	\
+	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk, xfs_fsblock_t pblk, \
+		 xfs_extlen_t len, xfs_fsblock_t new_pblk), \
+	TP_ARGS(ip, lblk, pblk, len, new_pblk))
+
+/* inode/irec events */
+DECLARE_EVENT_CLASS(xfs_inode_irec_class,
+	TP_PROTO(struct xfs_inode *ip, struct xfs_bmbt_irec *irec),
+	TP_ARGS(ip, irec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fileoff_t, lblk)
+		__field(xfs_extlen_t, len)
+		__field(xfs_fsblock_t, pblk)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->lblk = irec->br_startoff;
+		__entry->len = irec->br_blockcount;
+		__entry->pblk = irec->br_startblock;
+	),
+	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x pblk %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->lblk,
+		  __entry->len,
+		  __entry->pblk)
+);
+#define DEFINE_INODE_IREC_EVENT(name) \
+DEFINE_EVENT(xfs_inode_irec_class, name, \
+	TP_PROTO(struct xfs_inode *ip, struct xfs_bmbt_irec *irec), \
+	TP_ARGS(ip, irec))
+
+/* refcount/reflink tracepoint definitions */
+
+/* reflink tracepoints */
+DEFINE_INODE_EVENT(xfs_reflink_set_inode_flag);
+DEFINE_INODE_EVENT(xfs_reflink_unset_inode_flag);
+DEFINE_ITRUNC_EVENT(xfs_reflink_update_inode_size);
+DEFINE_IOMAP_EVENT(xfs_reflink_remap_imap);
+TRACE_EVENT(xfs_reflink_remap_blocks_loop,
+	TP_PROTO(struct xfs_inode *src, xfs_fileoff_t soffset,
+		 xfs_filblks_t len, struct xfs_inode *dest,
+		 xfs_fileoff_t doffset),
+	TP_ARGS(src, soffset, len, dest, doffset),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, src_ino)
+		__field(xfs_fileoff_t, src_lblk)
+		__field(xfs_filblks_t, len)
+		__field(xfs_ino_t, dest_ino)
+		__field(xfs_fileoff_t, dest_lblk)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(src)->i_sb->s_dev;
+		__entry->src_ino = src->i_ino;
+		__entry->src_lblk = soffset;
+		__entry->len = len;
+		__entry->dest_ino = dest->i_ino;
+		__entry->dest_lblk = doffset;
+	),
+	TP_printk("dev %d:%d len 0x%llx "
+		  "ino 0x%llx offset 0x%llx blocks -> "
+		  "ino 0x%llx offset 0x%llx blocks",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->len,
+		  __entry->src_ino,
+		  __entry->src_lblk,
+		  __entry->dest_ino,
+		  __entry->dest_lblk)
+);
+TRACE_EVENT(xfs_reflink_punch_range,
+	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk,
+		 xfs_extlen_t len),
+	TP_ARGS(ip, lblk, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fileoff_t, lblk)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->lblk = lblk;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->lblk,
+		  __entry->len)
+);
+TRACE_EVENT(xfs_reflink_remap,
+	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk,
+		 xfs_extlen_t len, xfs_fsblock_t new_pblk),
+	TP_ARGS(ip, lblk, len, new_pblk),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fileoff_t, lblk)
+		__field(xfs_extlen_t, len)
+		__field(xfs_fsblock_t, new_pblk)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->lblk = lblk;
+		__entry->len = len;
+		__entry->new_pblk = new_pblk;
+	),
+	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x new_pblk %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->lblk,
+		  __entry->len,
+		  __entry->new_pblk)
+);
+DEFINE_DOUBLE_IO_EVENT(xfs_reflink_remap_range);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_range_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_set_inode_flag_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_update_inode_size_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_reflink_main_loop_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_read_iomap_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_blocks_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_extent_error);
+
+/* dedupe tracepoints */
+DEFINE_DOUBLE_IO_EVENT(xfs_reflink_compare_extents);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_compare_extents_error);
+
+/* ioctl tracepoints */
+DEFINE_DOUBLE_VFS_IO_EVENT(xfs_ioctl_reflink);
+DEFINE_DOUBLE_VFS_IO_EVENT(xfs_ioctl_clone_range);
+DEFINE_DOUBLE_VFS_IO_EVENT(xfs_ioctl_file_extent_same);
+TRACE_EVENT(xfs_ioctl_clone,
+	TP_PROTO(struct inode *src, struct inode *dest),
+	TP_ARGS(src, dest),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, src_ino)
+		__field(loff_t, src_isize)
+		__field(unsigned long, dest_ino)
+		__field(loff_t, dest_isize)
+	),
+	TP_fast_assign(
+		__entry->dev = src->i_sb->s_dev;
+		__entry->src_ino = src->i_ino;
+		__entry->src_isize = i_size_read(src);
+		__entry->dest_ino = dest->i_ino;
+		__entry->dest_isize = i_size_read(dest);
+	),
+	TP_printk("dev %d:%d "
+		  "ino 0x%lx isize 0x%llx -> "
+		  "ino 0x%lx isize 0x%llx\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->src_ino,
+		  __entry->src_isize,
+		  __entry->dest_ino,
+		  __entry->dest_isize)
+);
+
+/* unshare tracepoints */
+DEFINE_SIMPLE_IO_EVENT(xfs_reflink_unshare);
+DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cow_eof_block);
+DEFINE_PAGE_EVENT(xfs_reflink_unshare_page);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_cow_eof_block_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_dirty_page_error);
+
+/* copy on write */
+DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_around_shared);
+
+DEFINE_RW_EVENT(xfs_reflink_reserve_cow_range);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_reserve_cow_extent);
+DEFINE_RW_EVENT(xfs_reflink_allocate_cow_range);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_allocate_cow_extent);
+
+DEFINE_INODE_IREC_EVENT(xfs_reflink_bounce_dio_write);
+DEFINE_IOMAP_EVENT(xfs_reflink_find_cow_mapping);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_irec);
+DEFINE_SIMPLE_IO_EVENT(xfs_iomap_cow_delay);
+
+DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
+DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_piece);
+
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_reserve_cow_range_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_reserve_cow_extent_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_allocate_cow_range_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_cow_range_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_end_cow_error);
+
+DEFINE_COW_EVENT(xfs_reflink_fork_buf);
+DEFINE_COW_EVENT(xfs_reflink_finish_fork_buf);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_fork_buf_error);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_finish_fork_buf_error);
+
+DEFINE_INODE_EVENT(xfs_reflink_cancel_pending_cow);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_cancel_cow);
+DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_pending_cow_error);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH


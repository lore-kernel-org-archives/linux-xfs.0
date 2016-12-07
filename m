Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932209AbcLGUFw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 15:05:52 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E1A1E624D7
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 20:05:51 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uB7K5oLS032207
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Wed, 7 Dec 2016 15:05:51 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: nuke unused tracepoint definitions
Message-ID: <ab512340-9567-cc58-e0a8-7891041d1d12@redhat.com>
Date: Wed, 7 Dec 2016 14:05:50 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is all unused code, so remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 xfs_trace.h |  113 ------------------------------------------------------------
 1 file changed, 113 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ad188d3..89b6d0a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -136,8 +136,6 @@
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_eofblocks);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_eofblocks);
-DEFINE_PERAG_REF_EVENT(xfs_perag_set_cowblocks);
-DEFINE_PERAG_REF_EVENT(xfs_perag_clear_cowblocks);
 
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
@@ -355,7 +353,6 @@
 DEFINE_BUF_EVENT(xfs_buf_iodone);
 DEFINE_BUF_EVENT(xfs_buf_submit);
 DEFINE_BUF_EVENT(xfs_buf_submit_wait);
-DEFINE_BUF_EVENT(xfs_buf_bawrite);
 DEFINE_BUF_EVENT(xfs_buf_lock);
 DEFINE_BUF_EVENT(xfs_buf_lock_done);
 DEFINE_BUF_EVENT(xfs_buf_trylock_fail);
@@ -367,19 +364,15 @@
 DEFINE_BUF_EVENT(xfs_buf_delwri_queued);
 DEFINE_BUF_EVENT(xfs_buf_delwri_split);
 DEFINE_BUF_EVENT(xfs_buf_get_uncached);
-DEFINE_BUF_EVENT(xfs_bdstrat_shut);
 DEFINE_BUF_EVENT(xfs_buf_item_relse);
 DEFINE_BUF_EVENT(xfs_buf_item_iodone_async);
 DEFINE_BUF_EVENT(xfs_buf_error_relse);
 DEFINE_BUF_EVENT(xfs_buf_wait_buftarg);
-DEFINE_BUF_EVENT(xfs_trans_read_buf_io);
 DEFINE_BUF_EVENT(xfs_trans_read_buf_shut);
 
 /* not really buffer traces, but the buf provides useful information */
 DEFINE_BUF_EVENT(xfs_btree_corrupt);
-DEFINE_BUF_EVENT(xfs_da_btree_corrupt);
 DEFINE_BUF_EVENT(xfs_reset_dqcounts);
-DEFINE_BUF_EVENT(xfs_inode_item_push);
 
 /* pass flags explicitly */
 DECLARE_EVENT_CLASS(xfs_buf_flags_class,
@@ -541,7 +534,6 @@
 DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_buf_ordered);
 
 DECLARE_EVENT_CLASS(xfs_filestream_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_agnumber_t agno),
@@ -680,7 +672,6 @@
 DEFINE_INODE_EVENT(xfs_dir_fsync);
 DEFINE_INODE_EVENT(xfs_file_fsync);
 DEFINE_INODE_EVENT(xfs_destroy_inode);
-DEFINE_INODE_EVENT(xfs_evict_inode);
 DEFINE_INODE_EVENT(xfs_update_time);
 
 DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
@@ -689,8 +680,6 @@
 DEFINE_INODE_EVENT(xfs_inode_set_eofblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_clear_eofblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
-DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
-DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
 
 DEFINE_INODE_EVENT(xfs_filemap_fault);
@@ -798,7 +787,6 @@
 DEFINE_EVENT(xfs_iref_class, name, \
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip), \
 	TP_ARGS(ip, caller_ip))
-DEFINE_IREF_EVENT(xfs_ihold);
 DEFINE_IREF_EVENT(xfs_irele);
 DEFINE_IREF_EVENT(xfs_inode_pin);
 DEFINE_IREF_EVENT(xfs_inode_unpin);
@@ -939,7 +927,6 @@
 DEFINE_DQUOT_EVENT(xfs_dqget_freeing);
 DEFINE_DQUOT_EVENT(xfs_dqget_dup);
 DEFINE_DQUOT_EVENT(xfs_dqput);
-DEFINE_DQUOT_EVENT(xfs_dqput_wait);
 DEFINE_DQUOT_EVENT(xfs_dqput_free);
 DEFINE_DQUOT_EVENT(xfs_dqrele);
 DEFINE_DQUOT_EVENT(xfs_dqflush);
@@ -1815,7 +1802,6 @@
 DEFINE_ATTR_EVENT(xfs_attr_sf_create);
 DEFINE_ATTR_EVENT(xfs_attr_sf_lookup);
 DEFINE_ATTR_EVENT(xfs_attr_sf_remove);
-DEFINE_ATTR_EVENT(xfs_attr_sf_removename);
 DEFINE_ATTR_EVENT(xfs_attr_sf_to_leaf);
 
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add);
@@ -1844,7 +1830,6 @@
 
 DEFINE_ATTR_EVENT(xfs_attr_node_addname);
 DEFINE_ATTR_EVENT(xfs_attr_node_get);
-DEFINE_ATTR_EVENT(xfs_attr_node_lookup);
 DEFINE_ATTR_EVENT(xfs_attr_node_replace);
 DEFINE_ATTR_EVENT(xfs_attr_node_removename);
 
@@ -2440,11 +2425,9 @@
 
 DEFINE_DEFER_ERROR_EVENT(xfs_defer_trans_roll_error);
 DEFINE_DEFER_ERROR_EVENT(xfs_defer_finish_error);
-DEFINE_DEFER_ERROR_EVENT(xfs_defer_op_finish_error);
 
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_intake_work);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_intake_cancel);
-DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_commit);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_cancel);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
@@ -3092,87 +3075,6 @@
 		 struct xfs_inode *dest, xfs_off_t doffset), \
 	TP_ARGS(src, soffset, len, dest, doffset))
 
-/* two-file vfs io tracepoint class */
-DECLARE_EVENT_CLASS(xfs_double_vfs_io_class,
-	TP_PROTO(struct inode *src, u64 soffset, u64 len,
-		 struct inode *dest, u64 doffset),
-	TP_ARGS(src, soffset, len, dest, doffset),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(unsigned long, src_ino)
-		__field(loff_t, src_isize)
-		__field(loff_t, src_offset)
-		__field(size_t, len)
-		__field(unsigned long, dest_ino)
-		__field(loff_t, dest_isize)
-		__field(loff_t, dest_offset)
-	),
-	TP_fast_assign(
-		__entry->dev = src->i_sb->s_dev;
-		__entry->src_ino = src->i_ino;
-		__entry->src_isize = i_size_read(src);
-		__entry->src_offset = soffset;
-		__entry->len = len;
-		__entry->dest_ino = dest->i_ino;
-		__entry->dest_isize = i_size_read(dest);
-		__entry->dest_offset = doffset;
-	),
-	TP_printk("dev %d:%d count %zd "
-		  "ino 0x%lx isize 0x%llx offset 0x%llx -> "
-		  "ino 0x%lx isize 0x%llx offset 0x%llx",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->len,
-		  __entry->src_ino,
-		  __entry->src_isize,
-		  __entry->src_offset,
-		  __entry->dest_ino,
-		  __entry->dest_isize,
-		  __entry->dest_offset)
-)
-
-#define DEFINE_DOUBLE_VFS_IO_EVENT(name)	\
-DEFINE_EVENT(xfs_double_vfs_io_class, name,	\
-	TP_PROTO(struct inode *src, u64 soffset, u64 len, \
-		 struct inode *dest, u64 doffset), \
-	TP_ARGS(src, soffset, len, dest, doffset))
-
-/* CoW write tracepoint */
-DECLARE_EVENT_CLASS(xfs_copy_on_write_class,
-	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk, xfs_fsblock_t pblk,
-		 xfs_extlen_t len, xfs_fsblock_t new_pblk),
-	TP_ARGS(ip, lblk, pblk, len, new_pblk),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fileoff_t, lblk)
-		__field(xfs_fsblock_t, pblk)
-		__field(xfs_extlen_t, len)
-		__field(xfs_fsblock_t, new_pblk)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->lblk = lblk;
-		__entry->pblk = pblk;
-		__entry->len = len;
-		__entry->new_pblk = new_pblk;
-	),
-	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx pblk 0x%llx "
-		  "len 0x%x new_pblk %llu",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->lblk,
-		  __entry->pblk,
-		  __entry->len,
-		  __entry->new_pblk)
-)
-
-#define DEFINE_COW_EVENT(name)	\
-DEFINE_EVENT(xfs_copy_on_write_class, name,	\
-	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk, xfs_fsblock_t pblk, \
-		 xfs_extlen_t len, xfs_fsblock_t new_pblk), \
-	TP_ARGS(ip, lblk, pblk, len, new_pblk))
-
 /* inode/irec events */
 DECLARE_EVENT_CLASS(xfs_inode_irec_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_bmbt_irec *irec),
@@ -3292,8 +3194,6 @@
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_set_inode_flag_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_update_inode_size_error);
-DEFINE_INODE_ERROR_EVENT(xfs_reflink_reflink_main_loop_error);
-DEFINE_INODE_ERROR_EVENT(xfs_reflink_read_iomap_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_blocks_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_extent_error);
 
@@ -3302,9 +3202,6 @@
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_compare_extents_error);
 
 /* ioctl tracepoints */
-DEFINE_DOUBLE_VFS_IO_EVENT(xfs_ioctl_reflink);
-DEFINE_DOUBLE_VFS_IO_EVENT(xfs_ioctl_clone_range);
-DEFINE_DOUBLE_VFS_IO_EVENT(xfs_ioctl_file_extent_same);
 TRACE_EVENT(xfs_ioctl_clone,
 	TP_PROTO(struct inode *src, struct inode *dest),
 	TP_ARGS(src, dest),
@@ -3334,11 +3231,7 @@
 
 /* unshare tracepoints */
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_unshare);
-DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cow_eof_block);
-DEFINE_PAGE_EVENT(xfs_reflink_unshare_page);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
-DEFINE_INODE_ERROR_EVENT(xfs_reflink_cow_eof_block_error);
-DEFINE_INODE_ERROR_EVENT(xfs_reflink_dirty_page_error);
 
 /* copy on write */
 DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_around_shared);
@@ -3363,14 +3256,8 @@
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_cow_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_end_cow_error);
 
-DEFINE_COW_EVENT(xfs_reflink_fork_buf);
-DEFINE_COW_EVENT(xfs_reflink_finish_fork_buf);
-DEFINE_INODE_ERROR_EVENT(xfs_reflink_fork_buf_error);
-DEFINE_INODE_ERROR_EVENT(xfs_reflink_finish_fork_buf_error);
 
-DEFINE_INODE_EVENT(xfs_reflink_cancel_pending_cow);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cancel_cow);
-DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_pending_cow_error);
 
 /* rmap swapext tracepoints */
 DEFINE_INODE_IREC_EVENT(xfs_swap_extent_rmap_remap);


Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DAE0629DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 23:24:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA81F304048
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 21:24:31 -0800 (PST)
Received: from ozlabs.org (ozlabs.org [103.22.144.67]) by cuda.sgi.com with
	ESMTP id jrAJouPMqn7Y9xSV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 21:24:23 -0800 (PST)
Date: Wed, 10 Feb 2016 16:24:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the akpm-current tree with the xfs tree
Message-ID: <20160210162420.2d1a352a@canb.auug.org.au>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, David Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: linux-next@vger.kernel.org, Ryan Ding <ryan.ding@oracle.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in:

  fs/ocfs2/aops.c

between commit:

  187372a3b9fa ("direct-io: always call ->end_io if non-NULL")

from the xfs tree and commit:

  8e1fbb488a18 ("ocfs2: fix sparse file & data ordering issue in direct io")

from the akpm-current tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

-- 
Cheers,
Stephen Rothwell

diff --cc fs/ocfs2/aops.c
index 5dcc5f5a842e,3d3952ebe101..000000000000
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@@ -2476,6 -2099,356 +2099,361 @@@ static int ocfs2_write_end(struct file 
  	return ret;
  }
  
+ struct ocfs2_dio_write_ctxt {
+ 	struct list_head	dw_zero_list;
+ 	unsigned		dw_zero_count;
+ 	int			dw_orphaned;
+ 	pid_t			dw_writer_pid;
+ };
+ 
+ static struct ocfs2_dio_write_ctxt *
+ ocfs2_dio_alloc_write_ctx(struct buffer_head *bh, int *alloc)
+ {
+ 	struct ocfs2_dio_write_ctxt *dwc = NULL;
+ 
+ 	if (bh->b_private)
+ 		return bh->b_private;
+ 
+ 	dwc = kmalloc(sizeof(struct ocfs2_dio_write_ctxt), GFP_NOFS);
+ 	if (dwc == NULL)
+ 		return NULL;
+ 	INIT_LIST_HEAD(&dwc->dw_zero_list);
+ 	dwc->dw_zero_count = 0;
+ 	dwc->dw_orphaned = 0;
+ 	dwc->dw_writer_pid = task_pid_nr(current);
+ 	bh->b_private = dwc;
+ 	*alloc = 1;
+ 
+ 	return dwc;
+ }
+ 
+ static void ocfs2_dio_free_write_ctx(struct inode *inode,
+ 				     struct ocfs2_dio_write_ctxt *dwc)
+ {
+ 	ocfs2_free_unwritten_list(inode, &dwc->dw_zero_list);
+ 	kfree(dwc);
+ }
+ 
+ /*
+  * TODO: Make this into a generic get_blocks function.
+  *
+  * From do_direct_io in direct-io.c:
+  *  "So what we do is to permit the ->get_blocks function to populate
+  *   bh.b_size with the size of IO which is permitted at this offset and
+  *   this i_blkbits."
+  *
+  * This function is called directly from get_more_blocks in direct-io.c.
+  *
+  * called like this: dio->get_blocks(dio->inode, fs_startblk,
+  * 					fs_count, map_bh, dio->rw == WRITE);
+  */
+ static int ocfs2_dio_get_block(struct inode *inode, sector_t iblock,
+ 			       struct buffer_head *bh_result, int create)
+ {
+ 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+ 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+ 	struct ocfs2_write_ctxt *wc;
+ 	struct ocfs2_write_cluster_desc *desc = NULL;
+ 	struct ocfs2_dio_write_ctxt *dwc = NULL;
+ 	struct buffer_head *di_bh = NULL;
+ 	u64 p_blkno;
+ 	loff_t pos = iblock << inode->i_sb->s_blocksize_bits;
+ 	unsigned len, total_len = bh_result->b_size;
+ 	int ret = 0, first_get_block = 0;
+ 
+ 	len = osb->s_clustersize - (pos & (osb->s_clustersize - 1));
+ 	len = min(total_len, len);
+ 
+ 	mlog(0, "get block of %lu at %llu:%u req %u\n",
+ 			inode->i_ino, pos, len, total_len);
+ 
+ 	/*
+ 	 * Because we need to change file size in ocfs2_dio_end_io_write(), or
+ 	 * we may need to add it to orphan dir. So can not fall to fast path
+ 	 * while file size will be changed.
+ 	 */
+ 	if (pos + total_len <= i_size_read(inode)) {
+ 		down_read(&oi->ip_alloc_sem);
+ 		/* This is the fast path for re-write. */
+ 		ret = ocfs2_get_block(inode, iblock, bh_result, create);
+ 
+ 		up_read(&oi->ip_alloc_sem);
+ 
+ 		if (buffer_mapped(bh_result) &&
+ 		    !buffer_new(bh_result) &&
+ 		    ret == 0)
+ 			goto out;
+ 
+ 		/* Clear state set by ocfs2_get_block. */
+ 		bh_result->b_state = 0;
+ 	}
+ 
+ 	dwc = ocfs2_dio_alloc_write_ctx(bh_result, &first_get_block);
+ 	if (unlikely(dwc == NULL)) {
+ 		ret = -ENOMEM;
+ 		mlog_errno(ret);
+ 		goto out;
+ 	}
+ 
+ 	if (ocfs2_clusters_for_bytes(inode->i_sb, pos + total_len) >
+ 	    ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode)) &&
+ 	    !dwc->dw_orphaned) {
+ 		/*
+ 		 * when we are going to alloc extents beyond file size, add the
+ 		 * inode to orphan dir, so we can recall those spaces when
+ 		 * system crashed during write.
+ 		 */
+ 		ret = ocfs2_add_inode_to_orphan(osb, inode);
+ 		if (ret < 0) {
+ 			mlog_errno(ret);
+ 			goto out;
+ 		}
+ 		dwc->dw_orphaned = 1;
+ 	}
+ 
+ 	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+ 	if (ret) {
+ 		mlog_errno(ret);
+ 		goto out;
+ 	}
+ 
+ 	down_write(&oi->ip_alloc_sem);
+ 
+ 	if (first_get_block) {
+ 		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+ 			ret = ocfs2_zero_tail(inode, di_bh, pos);
+ 		else
+ 			ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos,
+ 							   total_len, NULL);
+ 		if (ret < 0) {
+ 			mlog_errno(ret);
+ 			goto unlock;
+ 		}
+ 	}
+ 
+ 	ret = ocfs2_write_begin_nolock(inode->i_mapping, pos, len,
+ 				       OCFS2_WRITE_DIRECT, NULL,
+ 				       (void **)&wc, di_bh, NULL);
+ 	if (ret) {
+ 		mlog_errno(ret);
+ 		goto unlock;
+ 	}
+ 
+ 	desc = &wc->w_desc[0];
+ 
+ 	p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, desc->c_phys);
+ 	BUG_ON(p_blkno == 0);
+ 	p_blkno += iblock & (u64)(ocfs2_clusters_to_blocks(inode->i_sb, 1) - 1);
+ 
+ 	map_bh(bh_result, inode->i_sb, p_blkno);
+ 	bh_result->b_size = len;
+ 	if (desc->c_needs_zero)
+ 		set_buffer_new(bh_result);
+ 
+ 	/* May sleep in end_io. It should not happen in a irq context. So defer
+ 	 * it to dio work queue. */
+ 	set_buffer_defer_completion(bh_result);
+ 
+ 	if (!list_empty(&wc->w_unwritten_list)) {
+ 		struct ocfs2_unwritten_extent *ue = NULL;
+ 
+ 		ue = list_first_entry(&wc->w_unwritten_list,
+ 				      struct ocfs2_unwritten_extent,
+ 				      ue_node);
+ 		BUG_ON(ue->ue_cpos != desc->c_cpos);
+ 		/* The physical address may be 0, fill it. */
+ 		ue->ue_phys = desc->c_phys;
+ 
+ 		list_splice_tail_init(&wc->w_unwritten_list, &dwc->dw_zero_list);
+ 		dwc->dw_zero_count++;
+ 	}
+ 
+ 	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, NULL, wc);
+ 	BUG_ON(ret != len);
+ 	ret = 0;
+ unlock:
+ 	up_write(&oi->ip_alloc_sem);
+ 	ocfs2_inode_unlock(inode, 1);
+ 	brelse(di_bh);
+ out:
+ 	if (ret < 0)
+ 		ret = -EIO;
+ 	return ret;
+ }
+ 
+ static void ocfs2_dio_end_io_write(struct inode *inode,
+ 				   struct ocfs2_dio_write_ctxt *dwc,
+ 				   loff_t offset,
+ 				   ssize_t bytes)
+ {
+ 	struct ocfs2_cached_dealloc_ctxt dealloc;
+ 	struct ocfs2_extent_tree et;
+ 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+ 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+ 	struct ocfs2_unwritten_extent *ue = NULL;
+ 	struct buffer_head *di_bh = NULL;
+ 	struct ocfs2_dinode *di;
+ 	struct ocfs2_alloc_context *data_ac = NULL;
+ 	struct ocfs2_alloc_context *meta_ac = NULL;
+ 	handle_t *handle = NULL;
+ 	loff_t end = offset + bytes;
+ 	int ret = 0, credits = 0, locked = 0;
+ 
+ 	ocfs2_init_dealloc_ctxt(&dealloc);
+ 
+ 	/* We do clear unwritten, delete orphan, change i_size here. If neither
+ 	 * of these happen, we can skip all this. */
+ 	if (list_empty(&dwc->dw_zero_list) &&
+ 	    end <= i_size_read(inode) &&
+ 	    !dwc->dw_orphaned)
+ 		goto out;
+ 
+ 	/* ocfs2_file_write_iter will get i_mutex, so we need not lock if we
+ 	 * are in that context. */
+ 	if (dwc->dw_writer_pid != task_pid_nr(current)) {
+ 		mutex_lock(&inode->i_mutex);
+ 		locked = 1;
+ 	}
+ 
+ 	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+ 	if (ret < 0) {
+ 		mlog_errno(ret);
+ 		goto out;
+ 	}
+ 
+ 	down_write(&oi->ip_alloc_sem);
+ 
+ 	/* Delete orphan before acquire i_mutex. */
+ 	if (dwc->dw_orphaned) {
+ 		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
+ 
+ 		end = end > i_size_read(inode) ? end : 0;
+ 
+ 		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
+ 				!!end, end);
+ 		if (ret < 0)
+ 			mlog_errno(ret);
+ 	}
+ 
+ 	di = (struct ocfs2_dinode *)di_bh;
+ 
+ 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
+ 
+ 	ret = ocfs2_lock_allocators(inode, &et, 0, dwc->dw_zero_count*2,
+ 				    &data_ac, &meta_ac);
+ 	if (ret) {
+ 		mlog_errno(ret);
+ 		goto unlock;
+ 	}
+ 
+ 	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
+ 
+ 	handle = ocfs2_start_trans(osb, credits);
+ 	if (IS_ERR(handle)) {
+ 		ret = PTR_ERR(handle);
+ 		mlog_errno(ret);
+ 		goto unlock;
+ 	}
+ 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+ 				      OCFS2_JOURNAL_ACCESS_WRITE);
+ 	if (ret) {
+ 		mlog_errno(ret);
+ 		goto commit;
+ 	}
+ 
+ 	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
+ 		ret = ocfs2_mark_extent_written(inode, &et, handle,
+ 						ue->ue_cpos, 1,
+ 						ue->ue_phys,
+ 						meta_ac, &dealloc);
+ 		if (ret < 0) {
+ 			mlog_errno(ret);
+ 			break;
+ 		}
+ 	}
+ 
+ 	if (end > i_size_read(inode)) {
+ 		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
+ 		if (ret < 0)
+ 			mlog_errno(ret);
+ 	}
+ commit:
+ 	ocfs2_commit_trans(osb, handle);
+ unlock:
+ 	up_write(&oi->ip_alloc_sem);
+ 	ocfs2_inode_unlock(inode, 1);
+ 	brelse(di_bh);
+ out:
+ 	if (data_ac)
+ 		ocfs2_free_alloc_context(data_ac);
+ 	if (meta_ac)
+ 		ocfs2_free_alloc_context(meta_ac);
+ 	ocfs2_run_deallocs(osb, &dealloc);
+ 	if (locked)
+ 		mutex_unlock(&inode->i_mutex);
+ 	ocfs2_dio_free_write_ctx(inode, dwc);
+ }
+ 
+ /*
+  * ocfs2_dio_end_io is called by the dio core when a dio is finished.  We're
+  * particularly interested in the aio/dio case.  We use the rw_lock DLM lock
+  * to protect io on one node from truncation on another.
+  */
 -static void ocfs2_dio_end_io(struct kiocb *iocb,
 -			     loff_t offset,
 -			     ssize_t bytes,
 -			     void *private)
++static int ocfs2_dio_end_io(struct kiocb *iocb,
++			    loff_t offset,
++			    ssize_t bytes,
++			    void *private)
+ {
+ 	struct inode *inode = file_inode(iocb->ki_filp);
+ 	int level;
+ 
++	if (bytes <= 0)
++		return 0;
++
+ 	/* this io's submitter should not have unlocked this before we could */
+ 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
+ 
+ 	if (private)
+ 		ocfs2_dio_end_io_write(inode, private, offset, bytes);
+ 
+ 	ocfs2_iocb_clear_rw_locked(iocb);
+ 
+ 	level = ocfs2_iocb_rw_locked_level(iocb);
+ 	ocfs2_rw_unlock(inode, level);
++
++	return 0;
+ }
+ 
+ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
+ 			       loff_t offset)
+ {
+ 	struct file *file = iocb->ki_filp;
+ 	struct inode *inode = file_inode(file)->i_mapping->host;
+ 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+ 	loff_t end = offset + iter->count;
+ 	get_block_t *get_block;
+ 
+ 	/*
+ 	 * Fallback to buffered I/O if we see an inode without
+ 	 * extents.
+ 	 */
+ 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+ 		return 0;
+ 
+ 	/* Fallback to buffered I/O if we do not support append dio. */
+ 	if (end > i_size_read(inode) && !ocfs2_supports_append_dio(osb))
+ 		return 0;
+ 
+ 	if (iov_iter_rw(iter) == READ)
+ 		get_block = ocfs2_get_block;
+ 	else
+ 		get_block = ocfs2_dio_get_block;
+ 
+ 	return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
+ 				    iter, offset, get_block,
+ 				    ocfs2_dio_end_io, NULL, 0);
+ }
+ 
  const struct address_space_operations ocfs2_aops = {
  	.readpage		= ocfs2_readpage,
  	.readpages		= ocfs2_readpages,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

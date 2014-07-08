Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 26AD57F47
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 09:34:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1223A8F8087
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 07:34:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D7HmDhDY29FrQH7x (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 07:34:52 -0700 (PDT)
Date: Tue, 8 Jul 2014 16:02:28 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 3/3] ext4: Add support IOC_MOV_DATA ioctl
In-Reply-To: <004001cf9aa4$2670e280$7352a780$@samsung.com>
Message-ID: <alpine.LFD.2.00.1407081558280.2180@localhost.localdomain>
References: <004001cf9aa4$2670e280$7352a780$@samsung.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1224561518-1404828153=:2180"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1224561518-1404828153=:2180
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT

On Tue, 8 Jul 2014, Namjae Jeon wrote:

> Date: Tue, 08 Jul 2014 21:00:02 +0900
> From: Namjae Jeon <namjae.jeon@samsung.com>
> To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
>     linux-kernel@vger.kernel.org, Luká¹ Czerner <lczerner@redhat.com>,
>     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@infradead.org>,
>     Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com
> Subject: [PATCH 3/3] ext4: Add support IOC_MOV_DATA ioctl
> 
> This patch implements fs ioctl's IOC_MOV_DATA for Ext4.

Hmm isn't this basically what ext4_move_extents() does ? eg.
EXT4_IOC_MOVE_EXT ?

I guess that the intention here is to do the move, without actually
moving the data right ? But nevertheless maybe some code can be
shared with ext4_move_extents() ?

-Lukas

> 
> The semantics of this ioctl are:
> 1) Like collapse range, offsets and length should be file system block size
>    aligned.
> 2) In the receiver file, atleast length size hole should be present at
>    receiver_offset
> 3) It does not change file size of any of donor or receiver file.
> 4) It leaves a hole at the place from where blocks are moved out in donor file.
> 5) Both (donor_offset + length) and (receiver_offset + length) should be within
>    size of donor file and receiver file respectively.
>    Only unwritten extents resides beyond file size and it does not make sense
>    to transfer unwritten extents, leave apart the security issues it may raise.
> 6) If the range to be transfered from donor file contain any holes, they are
>    replicated as it is in receiver file. It mean holes are preserved and
>    the length of hole will be added to moved_len signifying that the hole range
>    is succesfully transfered.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  fs/ext4/ext4.h    |   2 +
>  fs/ext4/extents.c | 375 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/file.c    |   1 +
>  3 files changed, 378 insertions(+)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 6386c5f..26478eb 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2725,6 +2725,8 @@ extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  extern int ext4_ext_precache(struct inode *inode);
>  extern int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len);
>  extern int ext4_insert_range(struct file *file, loff_t offset, loff_t len);
> +extern int ext4_mov_data(struct inode *, struct inode *, loff_t, loff_t, loff_t,
> +			 loff_t *);
>  
>  /* move_extent.c */
>  extern void ext4_double_down_write_data_sem(struct inode *first,
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 0c2432e..511db03 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5811,3 +5811,378 @@ out_mutex:
>  	mutex_unlock(&inode->i_mutex);
>  	return ret;
>  }
> +
> +/*
> + * If offset_lblk does not lie on the extent start boundary, split extent
> + */
> +int ext4_find_and_split_extent_at(struct inode *inode, ext4_lblk_t offset_lblk)
> +{
> +	struct ext4_ext_path *path;
> +	handle_t *handle;
> +	int credits, err = 0, split_flag, ex_len;
> +	struct ext4_extent *ex;
> +	int depth = ext_depth(inode);
> +	ext4_lblk_t ex_start;
> +
> +	path = ext4_ext_find_extent(inode, offset_lblk, NULL, 0);
> +	if (IS_ERR(path))
> +		return PTR_ERR(path);
> +
> +	ex = path[depth].p_ext;
> +	if (!ex)
> +		goto free_path;
> +	ex_start = le32_to_cpu(ex->ee_block);
> +	ex_len = ext4_ext_get_actual_len(ex);
> +
> +	if (offset_lblk > ex_start && offset_lblk < (ex_start + ex_len)) {
> +		credits = ext4_writepage_trans_blocks(inode);
> +		handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
> +		if (IS_ERR(handle)) {
> +			err = PTR_ERR(handle);
> +			goto free_path;
> +		}
> +		if (ext4_ext_is_unwritten(ex))
> +			split_flag = EXT4_EXT_MARK_UNWRIT1 |
> +				     EXT4_EXT_MARK_UNWRIT2;
> +		else
> +			split_flag = 0;
> +
> +		err = ext4_split_extent_at(handle, inode, path, offset_lblk,
> +					   split_flag, EXT4_EX_NOCACHE |
> +					   EXT4_GET_BLOCKS_PRE_IO);
> +		ext4_journal_stop(handle);
> +	}
> +
> +free_path:
> +	ext4_ext_drop_refs(path);
> +	kfree(path);
> +	return err;
> +}
> +
> +/*
> + * Compute the size of hole in terms of filesystem blocks present at offset_lblk
> + * until the next extent is found OR till we reach the last block within isize.
> + * Store the computed value in hole_blkcnt.
> + * offset_lblk should be within isize of inode.
> + */
> +int ext4_compute_hole_size(struct inode *inode, ext4_lblk_t offset_lblk,
> +			   ext4_lblk_t *hole_blkcnt)
> +{
> +	struct ext4_ext_path *path;
> +	struct ext4_extent *ex;
> +	ext4_lblk_t ex_start, isize_lblk;
> +	int ret = 0, depth, ex_len;
> +
> +	isize_lblk = (inode->i_size + EXT4_BLOCK_SIZE(inode->i_sb) - 1) >>
> +		     EXT4_BLOCK_SIZE_BITS(inode->i_sb);
> +
> +	if (offset_lblk > isize_lblk)
> +		return -EINVAL;
> +
> +	*hole_blkcnt = 0;
> +	path = ext4_ext_find_extent(inode, offset_lblk, NULL, 0);
> +	if (IS_ERR(path))
> +		return PTR_ERR(path);
> +
> +	depth = ext_depth(inode);
> +	ex = path[depth].p_ext;
> +	if (!ex) {
> +		/* No blocks allocated in this file */
> +		*hole_blkcnt = isize_lblk - offset_lblk;
> +		goto out;
> +	}
> +	ex_start = le32_to_cpu(ex->ee_block);
> +	ex_len = ext4_ext_get_actual_len(ex);
> +
> +	/* if offset_lblk lies within extent? */
> +	if (offset_lblk >= ex_start && offset_lblk < (ex_start + ex_len))
> +		goto out;
> +
> +	if (ex_start < offset_lblk) {
> +		ret = mext_next_extent(inode, path, &ex);
> +		if (!ret) {
> +			ex_start = le32_to_cpu(ex->ee_block);
> +		} else {
> +			if (ret == 1) {
> +				*hole_blkcnt = isize_lblk - offset_lblk;
> +				ret = 0;
> +			}
> +			goto out;
> +		}
> +	}
> +	*hole_blkcnt = (ex_start < isize_lblk) ? (ex_start - offset_lblk) :
> +						 (isize_lblk - offset_lblk);
> +out:
> +	ext4_ext_drop_refs(path);
> +	kfree(path);
> +
> +	return ret;
> +}
> +
> +/*
> + * Remove a complete extent from in memory and on-disk extent tree
> + * without freeing any data blocks covered by the extent. Caller must call
> + * ext4_mark_inode_dirty() to sync the changes to disk.
> + */
> +int ext4_ext_rm_extent(handle_t *handle, struct inode *inode,
> +		       struct ext4_ext_path *path, struct ext4_extent *ex)
> +{
> +	struct ext4_extent_header *eh;
> +	int depth = ext_depth(inode);
> +	int credits, err, correct_index = 0;
> +	int ex_ee_len = ext4_ext_get_actual_len(ex);
> +
> +	if (!path[depth].p_hdr)
> +		path[depth].p_hdr = ext_block_hdr(path[depth].p_bh);
> +	eh = path[depth].p_hdr;
> +
> +	credits = 7 + 2*(ex_ee_len/EXT4_BLOCKS_PER_GROUP(inode->i_sb));
> +	if (ex == EXT_FIRST_EXTENT(eh)) {
> +		correct_index = 1;
> +		credits += (ext_depth(inode)) + 1;
> +	}
> +	credits += EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb);
> +	err = ext4_ext_truncate_extend_restart(handle, inode, credits);
> +	if (err)
> +		return err;
> +
> +	err = ext4_ext_get_access(handle, inode, path + depth);
> +	if (err)
> +		return err;
> +
> +	ext4_ext_store_pblock(ex, 0);
> +	memmove(ex, ex+1,
> +		(EXT_LAST_EXTENT(eh) - ex) * sizeof(struct ext4_extent));
> +	memset(EXT_LAST_EXTENT(eh), 0, sizeof(struct ext4_extent));
> +	le16_add_cpu(&eh->eh_entries, -1);
> +
> +	err = ext4_ext_dirty(handle, inode, path + depth);
> +	if (err)
> +		return err;
> +
> +	if (correct_index && eh->eh_entries)
> +		err = ext4_ext_correct_indexes(handle, inode, path);
> +
> +	if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL)
> +		err = ext4_ext_rm_idx(handle, inode, path, depth);
> +
> +	return err;
> +}
> +
> +/*
> + * Move len_lblk amount of blocks from donor inode to receiver inode.
> + * Blocks are to be moved from doffset_lblk and moved to roffset_lblk.
> + * Caller of this function must make sure there is atleast len_lblk size
> + * hole at roffset_lblk. Also doffset_lblk and doffset_lblk + len_lblk
> + * should fall on extent boundary.
> + */
> +int ext4_ext_mov_data(struct inode *donor, struct inode *receiver,
> +		      ext4_lblk_t doffset_lblk, ext4_lblk_t roffset_lblk,
> +		      ext4_lblk_t len_lblk, loff_t *bytes_moved)
> +{
> +	int error = 0, depth = ext_depth(donor);
> +	struct ext4_ext_path *path;
> +	struct ext4_extent *ex;
> +	loff_t blocks_moved = 0;
> +	handle_t *handle;
> +	int credits = ext4_writepage_trans_blocks(donor) +
> +		      ext4_writepage_trans_blocks(receiver);
> +
> +	while (blocks_moved < len_lblk && !error) {
> +		struct ext4_ext_path *rpath = NULL;
> +		ext4_lblk_t ex_start;
> +		int ex_len;
> +
> +		path = ext4_ext_find_extent(donor, doffset_lblk, NULL, 0);
> +		if (IS_ERR(path)) {
> +			error = PTR_ERR(path);
> +			break;
> +		}
> +		ex = path[depth].p_ext;
> +		/*
> +		 * No allocated blocks? This could only happen during
> +		 * 1st iteration. Otherwise it is en error.
> +		 */
> +		if (!ex) {
> +			if (blocks_moved)
> +				error = -EIO;
> +			else
> +				blocks_moved = len_lblk;
> +			goto out;
> +		}
> +		ex_start = le32_to_cpu(ex->ee_block);
> +		ex_len = ext4_ext_get_actual_len(ex);
> +
> +		if (doffset_lblk != ex_start) {
> +			/* Hole within range, move to the next extent */
> +			if (ex_start < doffset_lblk)
> +				error = mext_next_extent(donor, path, &ex);
> +			/* Below if will also handle ex_start > doffset_lblk */
> +			if (error == 0) {
> +				ex_start = le32_to_cpu(ex->ee_block);
> +				blocks_moved += ex_start - doffset_lblk;
> +				roffset_lblk += ex_start - doffset_lblk;
> +				doffset_lblk = ex_start;
> +			}
> +			if (error == 1) {
> +				/* doffset_lblk till EOF is hole. Success!! */
> +				blocks_moved = len_lblk;
> +				error = 0;
> +			}
> +			goto out;
> +		}
> +
> +		/* Add this extent to receiver */
> +		handle = ext4_journal_start(donor, EXT4_HT_TRUNCATE, credits);
> +		if (IS_ERR(handle)) {
> +			error = PTR_ERR(handle);
> +			goto out;
> +		}
> +
> +		rpath = ext4_ext_find_extent(receiver, roffset_lblk, NULL, 0);
> +		if (IS_ERR(rpath)) {
> +			error = PTR_ERR(rpath);
> +			ext4_journal_stop(handle);
> +			goto out;
> +		}
> +		ex->ee_block = cpu_to_le32(roffset_lblk);
> +		error = ext4_ext_insert_extent(handle, receiver, rpath, ex, 0);
> +		if (error)
> +			goto hout;
> +
> +		/* Remove this extent from donor */
> +		error = ext4_ext_rm_extent(handle, donor, path, ex);
> +		if (error)
> +			goto hout;
> +
> +		/* Extent moved successfully */
> +		roffset_lblk += ex_len;
> +		doffset_lblk += ex_len;
> +		blocks_moved += ex_len;
> +
> +		donor->i_blocks -= (ex_len << (donor->i_blkbits - 9));
> +		receiver->i_blocks += (ex_len << (receiver->i_blkbits - 9));
> +		donor->i_mtime = donor->i_ctime = ext4_current_time(donor);
> +		receiver->i_mtime = receiver->i_ctime =
> +						ext4_current_time(receiver);
> +		ext4_mark_inode_dirty(handle, donor);
> +		ext4_mark_inode_dirty(handle, receiver);
> +hout:
> +		ext4_journal_stop(handle);
> +		ext4_ext_drop_refs(rpath);
> +		kfree(rpath);
> +out:
> +		ext4_ext_drop_refs(path);
> +		kfree(path);
> +	}
> +
> +	/* This can happen when (doffset_lblk + len_lblk) is in a hole */
> +	if (blocks_moved > len_lblk)
> +		blocks_moved = len_lblk;
> +
> +	*bytes_moved = blocks_moved << EXT4_BLOCK_SIZE_BITS(donor->i_sb);
> +	return error;
> +}
> +
> +int ext4_mov_data(struct inode *donor, struct inode *receiver, loff_t doffset,
> +		  loff_t roffset, loff_t len, loff_t *moved_len)
> +{
> +	struct super_block *sb = donor->i_sb;
> +	loff_t d_pg_off, r_pg_off, pg_len;
> +	ext4_lblk_t doffset_lblk, roffset_lblk, len_lblk, hole_size;
> +	int error;
> +
> +	if (doffset & (EXT4_BLOCK_SIZE(sb) - 1) ||
> +	    roffset & (EXT4_BLOCK_SIZE(sb) - 1) ||
> +	    len & (EXT4_BLOCK_SIZE(sb) - 1))
> +		return -EINVAL;
> +
> +	if (EXT4_SB(sb)->s_cluster_ratio > 1)
> +		return -EOPNOTSUPP;
> +
> +	if (!ext4_test_inode_flag(donor, EXT4_INODE_EXTENTS) ||
> +	    !ext4_test_inode_flag(receiver, EXT4_INODE_EXTENTS))
> +		return -EOPNOTSUPP;
> +
> +	doffset_lblk = doffset >> EXT4_BLOCK_SIZE_BITS(sb);
> +	roffset_lblk = roffset >> EXT4_BLOCK_SIZE_BITS(sb);
> +	len_lblk = len >> EXT4_BLOCK_SIZE_BITS(sb);
> +
> +	d_pg_off = round_down(doffset, PAGE_SIZE);
> +	r_pg_off = round_down(roffset, PAGE_SIZE);
> +	pg_len = round_up(len, PAGE_SIZE);
> +
> +	if (ext4_should_journal_data(donor)) {
> +		error = ext4_force_commit(donor->i_sb);
> +		if (error)
> +			return error;
> +		error = ext4_force_commit(receiver->i_sb);
> +		if (error)
> +			return error;
> +	}
> +
> +	error = filemap_write_and_wait_range(donor->i_mapping,
> +					     d_pg_off, d_pg_off + pg_len);
> +	if (error)
> +		return error;
> +	error = filemap_write_and_wait_range(receiver->i_mapping,
> +					     r_pg_off, r_pg_off + pg_len);
> +	if (error)
> +		return error;
> +
> +	lock_two_nondirectories(donor, receiver);
> +
> +	/* Check for isize limits for both files */
> +	if (doffset + len > donor->i_size ||
> +	    roffset + len > receiver->i_size) {
> +		error = -EINVAL;
> +		goto out_mutex;
> +	}
> +
> +	truncate_pagecache_range(donor, d_pg_off, d_pg_off + pg_len - 1);
> +	truncate_pagecache_range(receiver, r_pg_off, r_pg_off + pg_len - 1);
> +
> +	ext4_inode_block_unlocked_dio(donor);
> +	inode_dio_wait(donor);
> +	ext4_inode_block_unlocked_dio(receiver);
> +	inode_dio_wait(receiver);
> +
> +	ext4_discard_preallocations(donor);
> +	ext4_discard_preallocations(receiver);
> +
> +	error = ext4_es_remove_extent(donor, doffset_lblk, len_lblk);
> +	if (error)
> +		goto out_sem;
> +	error = ext4_es_remove_extent(receiver, roffset_lblk, len_lblk);
> +	if (error)
> +		goto out_sem;
> +
> +	error = ext4_compute_hole_size(receiver, roffset_lblk, &hole_size);
> +	if (error)
> +		goto out_sem;
> +	if (len_lblk > hole_size) {
> +		error = -EINVAL;
> +		goto out_sem;
> +	}
> +
> +	error = ext4_find_and_split_extent_at(donor, doffset_lblk);
> +	if (error)
> +		goto out_sem;
> +
> +	error = ext4_find_and_split_extent_at(donor, doffset_lblk + len_lblk);
> +	if (error)
> +		goto out_sem;
> +
> +	error = ext4_ext_mov_data(donor, receiver, doffset_lblk,
> +				  roffset_lblk, len_lblk, moved_len);
> +
> +	ext4_discard_preallocations(donor);
> +	ext4_discard_preallocations(receiver);
> +out_sem:
> +	ext4_inode_resume_unlocked_dio(donor);
> +	ext4_inode_resume_unlocked_dio(receiver);
> +
> +out_mutex:
> +	unlock_two_nondirectories(donor, receiver);
> +	return error;
> +}
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 8695f70..d2feaba 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -614,5 +614,6 @@ const struct inode_operations ext4_file_inode_operations = {
>  	.get_acl	= ext4_get_acl,
>  	.set_acl	= ext4_set_acl,
>  	.fiemap		= ext4_fiemap,
> +	.mov_data	= ext4_mov_data,
>  };
>  
> 
--8323328-1224561518-1404828153=:2180
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-1224561518-1404828153=:2180--

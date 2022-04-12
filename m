Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB23C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 17:04:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiDLRHD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 13:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346743AbiDLRHC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 13:07:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F8C13E8C
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 10:04:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 216C4B81F15
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 17:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70CAC385A5;
        Tue, 12 Apr 2022 17:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649783080;
        bh=UvsivTtyguqqtrVkOTh6Fd/dc5ArNqyBEEr9znZBwNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NKWpQ+UB1LcTH2Xmry7pjLFBxDuww2SlPZgV+IgTjyyHAr2KkbgTajlweBld21NMP
         lwhrjMa/bHqDyDcjWA/8vDcJ8XGjrC2pHmfETDJJ8O+ITo8ApMHbMA6zN0TTHgdHBz
         vY3UmaKPyLUYXvxGCbefznv9aHt2UHscSca7PSa710RSu9vVQBfRCQGIfL1IBOyg8U
         jiKvKSFjqN+QBKglS/BFN5DREa5GV09HQ3gB8WofuhmiN70PRGxIaWyQ6qCEOZmhMO
         QZJUcaT5flsPYQZ5MhXD101RE/4m6Ibg0F3pmi1j7VXt7mYHqk7ggM2mukuHzT8Kx0
         U/sdTpuZBVPPA==
Date:   Tue, 12 Apr 2022 10:04:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V9.2] xfs: Directory's data fork extent counter can never
 overflow
Message-ID: <20220412170440.GD16799@magnolia>
References: <20220406061904.595597-16-chandan.babu@oracle.com>
 <20220412140237.1759506-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412140237.1759506-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 12, 2022 at 07:32:37PM +0530, Chandan Babu R wrote:
> The maximum file size that can be represented by the data fork extent counter
> in the worst case occurs when all extents are 1 block in length and each block
> is 1KB in size.
> 
> With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
> 1KB sized blocks, a file can reach upto,
> (2^31) * 1KB = 2TB
> 
> This is much larger than the theoretical maximum size of a directory
> i.e. XFS_DIR2_SPACE_SIZE * 3 = ~96GB.
> 
> Since a directory's inode can never overflow its data fork extent counter,
> this commit removes all the overflow checks associated with
> it. xfs_dinode_verify() now performs a rough check to verify if a diretory's
> data fork is larger than 96GB.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Neato!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 20 -------------
>  fs/xfs/libxfs/xfs_da_btree.h   |  1 +
>  fs/xfs/libxfs/xfs_da_format.h  |  1 +
>  fs/xfs/libxfs/xfs_dir2.c       |  8 +++++
>  fs/xfs/libxfs/xfs_format.h     | 13 ++++++++
>  fs/xfs/libxfs/xfs_inode_buf.c  |  3 ++
>  fs/xfs/libxfs/xfs_inode_fork.h | 13 --------
>  fs/xfs/xfs_inode.c             | 55 ++--------------------------------
>  fs/xfs/xfs_symlink.c           |  5 ----
>  9 files changed, 28 insertions(+), 91 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 1254d4d4821e..4fab0c92ab70 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5147,26 +5147,6 @@ xfs_bmap_del_extent_real(
>  		 * Deleting the middle of the extent.
>  		 */
>  
> -		/*
> -		 * For directories, -ENOSPC is returned since a directory entry
> -		 * remove operation must not fail due to low extent count
> -		 * availability. -ENOSPC will be handled by higher layers of XFS
> -		 * by letting the corresponding empty Data/Free blocks to linger
> -		 * until a future remove operation. Dabtree blocks would be
> -		 * swapped with the last block in the leaf space and then the
> -		 * new last block will be unmapped.
> -		 *
> -		 * The above logic also applies to the source directory entry of
> -		 * a rename operation.
> -		 */
> -		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
> -		if (error) {
> -			ASSERT(S_ISDIR(VFS_I(ip)->i_mode) &&
> -				whichfork == XFS_DATA_FORK);
> -			error = -ENOSPC;
> -			goto done;
> -		}
> -
>  		old = got;
>  
>  		got.br_blockcount = del->br_startoff - got.br_startoff;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 0faf7d9ac241..7f08f6de48bf 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -30,6 +30,7 @@ struct xfs_da_geometry {
>  	unsigned int	free_hdr_size;	/* dir2 free header size */
>  	unsigned int	free_max_bests;	/* # of bests entries in dir2 free */
>  	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
> +	xfs_extnum_t	max_extents;	/* Max. extents in corresponding fork */
>  
>  	xfs_dir2_data_aoff_t data_first_offset;
>  	size_t		data_entry_offset;
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 5a49caa5c9df..95354b7ab7f5 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -277,6 +277,7 @@ xfs_dir2_sf_firstentry(struct xfs_dir2_sf_hdr *hdr)
>   * Directory address space divided into sections,
>   * spaces separated by 32GB.
>   */
> +#define	XFS_DIR2_MAX_SPACES	3
>  #define	XFS_DIR2_SPACE_SIZE	(1ULL << (32 + XFS_DIR2_DATA_ALIGN_LOG))
>  #define	XFS_DIR2_DATA_SPACE	0
>  #define	XFS_DIR2_DATA_OFFSET	(XFS_DIR2_DATA_SPACE * XFS_DIR2_SPACE_SIZE)
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 5f1e4799e8fa..3cd51fa3837b 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -150,6 +150,8 @@ xfs_da_mount(
>  	dageo->freeblk = xfs_dir2_byte_to_da(dageo, XFS_DIR2_FREE_OFFSET);
>  	dageo->node_ents = (dageo->blksize - dageo->node_hdr_size) /
>  				(uint)sizeof(xfs_da_node_entry_t);
> +	dageo->max_extents = (XFS_DIR2_MAX_SPACES * XFS_DIR2_SPACE_SIZE) >>
> +					mp->m_sb.sb_blocklog;
>  	dageo->magicpct = (dageo->blksize * 37) / 100;
>  
>  	/* set up attribute geometry - single fsb only */
> @@ -161,6 +163,12 @@ xfs_da_mount(
>  	dageo->node_hdr_size = mp->m_dir_geo->node_hdr_size;
>  	dageo->node_ents = (dageo->blksize - dageo->node_hdr_size) /
>  				(uint)sizeof(xfs_da_node_entry_t);
> +
> +	if (xfs_has_large_extent_counts(mp))
> +		dageo->max_extents = XFS_MAX_EXTCNT_ATTR_FORK_LARGE;
> +	else
> +		dageo->max_extents = XFS_MAX_EXTCNT_ATTR_FORK_SMALL;
> +
>  	dageo->magicpct = (dageo->blksize * 37) / 100;
>  	return 0;
>  }
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 82b404c99b80..43de892d0305 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -915,6 +915,19 @@ enum xfs_dinode_fmt {
>   *
>   * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
>   * 2^48 was chosen as the maximum data fork extent count.
> + *
> + * The maximum file size that can be represented by the data fork extent counter
> + * in the worst case occurs when all extents are 1 block in length and each
> + * block is 1KB in size.
> + *
> + * With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and
> + * with 1KB sized blocks, a file can reach upto,
> + * 1KB * (2^31) = 2TB
> + *
> + * This is much larger than the theoretical maximum size of a directory
> + * i.e. XFS_DIR2_SPACE_SIZE * XFS_DIR2_MAX_SPACES = ~96GB.
> + *
> + * Hence, a directory inode can never overflow its data fork extent counter.
>   */
>  #define XFS_MAX_EXTCNT_DATA_FORK_LARGE	((xfs_extnum_t)((1ULL << 48) - 1))
>  #define XFS_MAX_EXTCNT_ATTR_FORK_LARGE	((xfs_extnum_t)((1ULL << 32) - 1))
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index ee8d4eb7d048..74b82ec80f8e 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -491,6 +491,9 @@ xfs_dinode_verify(
>  	if (mode && nextents + naextents > nblocks)
>  		return __this_address;
>  
> +	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
> +		return __this_address;
> +
>  	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
>  		return __this_address;
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index fd5c3c2d77e0..6f9d69f8896e 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -39,19 +39,6 @@ struct xfs_ifork {
>   */
>  #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
>  
> -/*
> - * Directory entry addition can cause the following,
> - * 1. Data block can be added/removed.
> - *    A new extent can cause extent count to increase by 1.
> - * 2. Free disk block can be added/removed.
> - *    Same behaviour as described above for Data block.
> - * 3. Dabtree blocks.
> - *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
> - *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
> - */
> -#define XFS_IEXT_DIR_MANIP_CNT(mp) \
> -	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
> -
>  /*
>   * Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to
>   * be added. One extra extent for dabtree in case a local attr is
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index adc1355ce853..20f15a0393e1 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1024,11 +1024,6 @@ xfs_create(
>  	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
>  	unlock_dp_on_error = true;
>  
> -	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> -			XFS_IEXT_DIR_MANIP_CNT(mp));
> -	if (error)
> -		goto out_trans_cancel;
> -
>  	/*
>  	 * A newly created regular or special file just has one directory
>  	 * entry pointing to them, but a directory also the "." entry
> @@ -1242,11 +1237,6 @@ xfs_link(
>  	if (error)
>  		goto std_return;
>  
> -	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> -			XFS_IEXT_DIR_MANIP_CNT(mp));
> -	if (error)
> -		goto error_return;
> -
>  	/*
>  	 * If we are using project inheritance, we only allow hard link
>  	 * creation in our tree when the project IDs are the same; else
> @@ -3210,35 +3200,6 @@ xfs_rename(
>  	/*
>  	 * Check for expected errors before we dirty the transaction
>  	 * so we can return an error without a transaction abort.
> -	 *
> -	 * Extent count overflow check:
> -	 *
> -	 * From the perspective of src_dp, a rename operation is essentially a
> -	 * directory entry remove operation. Hence the only place where we check
> -	 * for extent count overflow for src_dp is in
> -	 * xfs_bmap_del_extent_real(). xfs_bmap_del_extent_real() returns
> -	 * -ENOSPC when it detects a possible extent count overflow and in
> -	 * response, the higher layers of directory handling code do the
> -	 * following:
> -	 * 1. Data/Free blocks: XFS lets these blocks linger until a
> -	 *    future remove operation removes them.
> -	 * 2. Dabtree blocks: XFS swaps the blocks with the last block in the
> -	 *    Leaf space and unmaps the last block.
> -	 *
> -	 * For target_dp, there are two cases depending on whether the
> -	 * destination directory entry exists or not.
> -	 *
> -	 * When destination directory entry does not exist (i.e. target_ip ==
> -	 * NULL), extent count overflow check is performed only when transaction
> -	 * has a non-zero sized space reservation associated with it.  With a
> -	 * zero-sized space reservation, XFS allows a rename operation to
> -	 * continue only when the directory has sufficient free space in its
> -	 * data/leaf/free space blocks to hold the new entry.
> -	 *
> -	 * When destination directory entry exists (i.e. target_ip != NULL), all
> -	 * we need to do is change the inode number associated with the already
> -	 * existing entry. Hence there is no need to perform an extent count
> -	 * overflow check.
>  	 */
>  	if (target_ip == NULL) {
>  		/*
> @@ -3249,12 +3210,6 @@ xfs_rename(
>  			error = xfs_dir_canenter(tp, target_dp, target_name);
>  			if (error)
>  				goto out_trans_cancel;
> -		} else {
> -			error = xfs_iext_count_may_overflow(target_dp,
> -					XFS_DATA_FORK,
> -					XFS_IEXT_DIR_MANIP_CNT(mp));
> -			if (error)
> -				goto out_trans_cancel;
>  		}
>  	} else {
>  		/*
> @@ -3422,18 +3377,12 @@ xfs_rename(
>  	 * inode number of the whiteout inode rather than removing it
>  	 * altogether.
>  	 */
> -	if (wip) {
> +	if (wip)
>  		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
>  					spaceres);
> -	} else {
> -		/*
> -		 * NOTE: We don't need to check for extent count overflow here
> -		 * because the dir remove name code will leave the dir block in
> -		 * place if the extent count would overflow.
> -		 */
> +	else
>  		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
>  					   spaceres);
> -	}
>  
>  	if (error)
>  		goto out_trans_cancel;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index affbedf78160..4145ba872547 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -226,11 +226,6 @@ xfs_symlink(
>  		goto out_trans_cancel;
>  	}
>  
> -	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> -			XFS_IEXT_DIR_MANIP_CNT(mp));
> -	if (error)
> -		goto out_trans_cancel;
> -
>  	/*
>  	 * Allocate an inode for the symlink.
>  	 */
> -- 
> 2.30.2
> 

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752658AbdCHMau (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 07:30:50 -0500
Date: Wed, 8 Mar 2017 07:30:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3] xfs: use iomap new flag for newly allocated delalloc
 blocks
Message-ID: <20170308123022.GA23404@bfoster.bfoster>
References: <1488899701-11051-1-git-send-email-bfoster@redhat.com>
 <20170307223319.GA1626@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170307223319.GA1626@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Xiong Zhou <xzhou@redhat.com>

On Tue, Mar 07, 2017 at 02:33:19PM -0800, Christoph Hellwig wrote:
> I still really hate that new xfs_bmapi_reserve_delalloc parameter,
> as there shouldn't be any need for it in the caller.   I also don't
> think the existing asserts there are very helpful, so I'd suggest
> to just remove them.
> 

Ok, fair enough.. v4 it is. I'll just warn about the not up-to-date got
in the comment.

Brian

> Below is my quick hack of your patch with that edited in, but be aware
> that it's completely untested.
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index a9c66d47757a..f32d12cfa42a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4150,6 +4150,19 @@ xfs_bmapi_read(
>  	return 0;
>  }
>  
> +/*
> + * Add a delayed allocation extent to an inode. Blocks are reserved from the
> + * global pool and the extent inserted into the inode in-core extent tree.
> + *
> + * On entry, got refers to the first extent beyond the offset of the extent to
> + * allocate or eof is specified if no such extent exists. On return, got refers
> + * to the newly allocated portion of the extent, which may be a subset of actual
> + * entry in the inodes extent list if it has been merged.
> + * 
> + * This difference is useful for callers that must distinguish newly allocated
> + * blocks from preexisting delalloc blocks within the range of the allocation
> + * request (in order to properly handle buffered write failure, for example).
> + */
>  int
>  xfs_bmapi_reserve_delalloc(
>  	struct xfs_inode	*ip,
> @@ -4236,13 +4249,8 @@ xfs_bmapi_reserve_delalloc(
>  	got->br_startblock = nullstartblock(indlen);
>  	got->br_blockcount = alen;
>  	got->br_state = XFS_EXT_NORM;
> -	xfs_bmap_add_extent_hole_delay(ip, whichfork, lastx, got);
>  
> -	/*
> -	 * Update our extent pointer, given that xfs_bmap_add_extent_hole_delay
> -	 * might have merged it into one of the neighbouring ones.
> -	 */
> -	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), got);
> +	xfs_bmap_add_extent_hole_delay(ip, whichfork, lastx, got);
>  
>  	/*
>  	 * Tag the inode if blocks were preallocated. Note that COW fork
> @@ -4254,10 +4262,6 @@ xfs_bmapi_reserve_delalloc(
>  	if (whichfork == XFS_COW_FORK && (prealloc || aoff < off || alen > len))
>  		xfs_inode_set_cowblocks_tag(ip);
>  
> -	ASSERT(got->br_startoff <= aoff);
> -	ASSERT(got->br_startoff + got->br_blockcount >= aoff + alen);
> -	ASSERT(isnullstartblock(got->br_startblock));
> -	ASSERT(got->br_state == XFS_EXT_NORM);
>  	return 0;
>  
>  out_unreserve_blocks:
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 41662fb14e87..ce39d0143567 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -613,7 +613,8 @@ xfs_file_iomap_begin_delay(
>  
>  retry:
>  	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
> -			end_fsb - offset_fsb, prealloc_blocks, &got, &idx, eof);
> +			end_fsb - offset_fsb, prealloc_blocks, &got, &idx,
> +			eof);
>  	switch (error) {
>  	case 0:
>  		break;
> @@ -630,6 +631,12 @@ xfs_file_iomap_begin_delay(
>  		goto out_unlock;
>  	}
>  
> +	/*
> +	 * IOMAP_F_NEW controls whether we punch out delalloc blocks if the
> +	 * write happens to fail, which means we can't combine newly allocated
> +	 * blocks with preexisting delalloc blocks in the same iomap.
> +	 */
> +	iomap->flags = IOMAP_F_NEW;
>  	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
>  done:
>  	if (isnullstartblock(got.br_startblock))
> @@ -1071,16 +1078,22 @@ xfs_file_iomap_end_delalloc(
>  	struct xfs_inode	*ip,
>  	loff_t			offset,
>  	loff_t			length,
> -	ssize_t			written)
> +	ssize_t			written,
> +	struct iomap		*iomap)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_fileoff_t		start_fsb;
>  	xfs_fileoff_t		end_fsb;
>  	int			error = 0;
>  
> -	/* behave as if the write failed if drop writes is enabled */
> -	if (xfs_mp_drop_writes(mp))
> +	/*
> +	 * Behave as if the write failed if drop writes is enabled. Set the NEW
> +	 * flag to force delalloc cleanup.
> +	 */
> +	if (xfs_mp_drop_writes(mp)) {
> +		iomap->flags |= IOMAP_F_NEW;
>  		written = 0;
> +	}
>  
>  	/*
>  	 * start_fsb refers to the first unused block after a short write. If
> @@ -1094,14 +1107,14 @@ xfs_file_iomap_end_delalloc(
>  	end_fsb = XFS_B_TO_FSB(mp, offset + length);
>  
>  	/*
> -	 * Trim back delalloc blocks if we didn't manage to write the whole
> -	 * range reserved.
> +	 * Trim delalloc blocks if they were allocated by this write and we
> +	 * didn't manage to write the whole range.
>  	 *
>  	 * We don't need to care about racing delalloc as we hold i_mutex
>  	 * across the reserve/allocate/unreserve calls. If there are delalloc
>  	 * blocks in the range, they are ours.
>  	 */
> -	if (start_fsb < end_fsb) {
> +	if ((iomap->flags & IOMAP_F_NEW) && start_fsb < end_fsb) {
>  		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
>  					 XFS_FSB_TO_B(mp, end_fsb) - 1);
>  
> @@ -1131,7 +1144,7 @@ xfs_file_iomap_end(
>  {
>  	if ((flags & IOMAP_WRITE) && iomap->type == IOMAP_DELALLOC)
>  		return xfs_file_iomap_end_delalloc(XFS_I(inode), offset,
> -				length, written);
> +				length, written, iomap);
>  	return 0;
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

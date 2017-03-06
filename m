Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:48427 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753993AbdCFUMT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 15:12:19 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v26I2Nhh012451
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 6 Mar 2017 18:02:24 GMT
Date: Mon, 6 Mar 2017 10:00:44 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: use iomap new flag for newly allocated delalloc
 blocks
Message-ID: <20170306180044.GB5280@birch.djwong.org>
References: <1488561798-23545-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488561798-23545-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Mar 03, 2017 at 12:23:18PM -0500, Brian Foster wrote:
> Commit fa7f138 ("xfs: clear delalloc and cache on buffered write
> failure") fixed one regression in the iomap error handling code and
> exposed another. The fundamental problem is that if a buffered write
> is a rewrite of preexisting delalloc blocks and the write fails, the
> failure handling code can punch out preexisting blocks with valid
> file data.
> 
> This was reproduced directly by sub-block writes in the LTP
> kernel/syscalls/write/write03 test. A first 100 byte write allocates
> a single block in a file. A subsequent 100 byte write fails and
> punches out the block, including the data successfully written by
> the previous write.
> 
> To address this problem, update the ->iomap_begin() handler to
> distinguish newly allocated delalloc blocks from preexisting
> delalloc blocks via the IOMAP_F_NEW flag. Use this flag in the
> ->iomap_end() handler to decide when a failed or short write should
> punch out delalloc blocks.
> 
> This introduces the subtle requirement that ->iomap_begin() should
> never combine newly allocated delalloc blocks with existing blocks
> in the resulting iomap descriptor. This can occur when a new
> delalloc reservation merges with a neighboring extent that is part
> of the current write, for example. Therefore, update
> xfs_bmapi_reserve_delalloc() to conditionally return the allocated
> record along with the updated 'got' record and map the former into
> the iomap.  This ensures that preexisting delalloc blocks are always
> handled as "found" blocks and not punched out on a failed rewrite.
> 
> Reported-by: Xiong Zhou <xzhou@redhat.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This version simply changes the interface to
> xfs_bmapi_reserve_delalloc() for using the allocated range rather than
> the fully up-to-date record after the allocation. Thoughts? If this is
> still too ugly I suppose we could just do as Christoph suggested
> originally and drop the update of got entirely. I'm just not that fond
> of the landmine that leaves around should some future caller expect
> 'got' to be updated, or worse, for somebody to re-add it to
> bmapi_reserve_delalloc() without us remembering the requirement for
> IOMAP_F_NEW and quietly breaking write failure handling again.

Could you add a comment above xfs_bmapi_reserve_delalloc summarizing
what the function is supposed to do and capturing the justification for
for arec?  I concede it's a little funny to mention iomap requirements
in libxfs, but I'd rather it get written down than left as a potential
landmine.

> Brian
> 
> v2:
> - Use arec param rather than bmapi flag in xfs_bmapi_reserve_delalloc().
> v1: http://www.spinics.net/lists/linux-xfs/msg04604.html
> 
>  fs/xfs/libxfs/xfs_bmap.c | 11 ++++++++---
>  fs/xfs/libxfs/xfs_bmap.h |  3 ++-
>  fs/xfs/xfs_iomap.c       | 34 +++++++++++++++++++++++++---------
>  fs/xfs/xfs_reflink.c     |  2 +-
>  4 files changed, 36 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index a9c66d4..dcc6c13 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4159,7 +4159,8 @@ xfs_bmapi_reserve_delalloc(
>  	xfs_filblks_t		prealloc,
>  	struct xfs_bmbt_irec	*got,
>  	xfs_extnum_t		*lastx,
> -	int			eof)
> +	int			eof,
> +	struct xfs_bmbt_irec	*arec)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> @@ -4236,11 +4237,15 @@ xfs_bmapi_reserve_delalloc(
>  	got->br_startblock = nullstartblock(indlen);
>  	got->br_blockcount = alen;
>  	got->br_state = XFS_EXT_NORM;
> +	if (arec)
> +		*arec = *got;
> +
>  	xfs_bmap_add_extent_hole_delay(ip, whichfork, lastx, got);
>  
>  	/*
> -	 * Update our extent pointer, given that xfs_bmap_add_extent_hole_delay
> -	 * might have merged it into one of the neighbouring ones.
> +	 * Update our extent pointer if the caller asked for entire extents.
> +	 * xfs_bmap_add_extent_hole_delay() might have merged it into one of
> +	 * the neighbouring ones.
>  	 */
>  	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), got);
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index cdef87d..c61f2a7 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -243,7 +243,8 @@ int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>  int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
>  int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
>  		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
> -		struct xfs_bmbt_irec *got, xfs_extnum_t *lastx, int eof);
> +		struct xfs_bmbt_irec *got, xfs_extnum_t *lastx, int eof,
> +		struct xfs_bmbt_irec *arec);
>  
>  enum xfs_bmap_intent_type {
>  	XFS_BMAP_MAP = 1,
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 41662fb..bdbab0f 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -531,7 +531,7 @@ xfs_file_iomap_begin_delay(
>  		XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
>  	xfs_fileoff_t		end_fsb;
>  	int			error = 0, eof = 0;
> -	struct xfs_bmbt_irec	got;
> +	struct xfs_bmbt_irec	got, arec;
>  	xfs_extnum_t		idx;
>  	xfs_fsblock_t		prealloc_blocks = 0;
>  
> @@ -613,7 +613,8 @@ xfs_file_iomap_begin_delay(
>  
>  retry:
>  	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
> -			end_fsb - offset_fsb, prealloc_blocks, &got, &idx, eof);
> +			end_fsb - offset_fsb, prealloc_blocks, &got, &idx,
> +			eof, &arec);
>  	switch (error) {
>  	case 0:
>  		break;
> @@ -630,6 +631,15 @@ xfs_file_iomap_begin_delay(
>  		goto out_unlock;
>  	}
>  
> +	/*
> +	 * IOMAP_F_NEW controls whether we punch out delalloc blocks if the
> +	 * write happens to fail, which means we can't combine newly allocated
> +	 * blocks with preexisting delalloc blocks in the same iomap. got may
> +	 * have been merged with contiguous extents, so use arec to map only the
> +	 * newly allocated blocks.
> +	 */
> +	got = arec;
> +	iomap->flags = IOMAP_F_NEW;
>  	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
>  done:
>  	if (isnullstartblock(got.br_startblock))
> @@ -1071,16 +1081,22 @@ xfs_file_iomap_end_delalloc(
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
> @@ -1094,14 +1110,14 @@ xfs_file_iomap_end_delalloc(
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
> +	if (iomap->flags & IOMAP_F_NEW && start_fsb < end_fsb) {

Doesn't the IOMAP_F_NEW check here need parentheses?

--D

>  		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
>  					 XFS_FSB_TO_B(mp, end_fsb) - 1);
>  
> @@ -1131,7 +1147,7 @@ xfs_file_iomap_end(
>  {
>  	if ((flags & IOMAP_WRITE) && iomap->type == IOMAP_DELALLOC)
>  		return xfs_file_iomap_end_delalloc(XFS_I(inode), offset,
> -				length, written);
> +				length, written, iomap);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index da6d08f..c29cc08 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -313,7 +313,7 @@ xfs_reflink_reserve_cow(
>  		return error;
>  
>  	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, imap->br_startoff,
> -			imap->br_blockcount, 0, &got, &idx, eof);
> +			imap->br_blockcount, 0, &got, &idx, eof, NULL);
>  	if (error == -ENOSPC || error == -EDQUOT)
>  		trace_xfs_reflink_cow_enospc(ip, imap);
>  	if (error)
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

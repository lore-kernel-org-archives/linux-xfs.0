Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38612 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726774AbfFYClH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 22:41:07 -0400
Date: Tue, 25 Jun 2019 12:39:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: convert extents in place for ZERO_RANGE
Message-ID: <20190625023954.GF7777@dread.disaster.area>
References: <ace9a6b9-3833-ec15-e3df-b9d88985685e@redhat.com>
 <25a2ebbc-0ec9-f5dd-eba0-4101c80837dd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25a2ebbc-0ec9-f5dd-eba0-4101c80837dd@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jun 24, 2019 at 07:48:11PM -0500, Eric Sandeen wrote:
> Rather than completely removing and re-allocating a range
> during ZERO_RANGE fallocate calls, convert whole blocks in the
> range using xfs_alloc_file_space(XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT)
> and then zero the edges with xfs_zero_range()

That's what I originally used to implement ZERO_RANGE and that
had problems with zeroing the partial blocks either side and
unexpected inode size changes. See commit:

5d11fb4b9a1d xfs: rework zero range to prevent invalid i_size updates

I also remember discussion about zero range being inefficient on
sparse files and fragmented files - the current implementation
effectively defragments such files, whilst using XFS_BMAPI_CONVERT
just leaves all the fragments behind.

> (Note that this changes the rounding direction of the
> xfs_alloc_file_space range, because we only want to hit whole
> blocks within the range.)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> <currently running fsx ad infinitum, so far so good>
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0a96c4d1718e..eae202bfe134 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1164,23 +1164,25 @@ xfs_zero_file_space(
>  
>  	blksize = 1 << mp->m_sb.sb_blocklog;
>  
> +	error = xfs_flush_unmap_range(ip, offset, len);
> +	if (error)
> +		return error;
>  	/*
> -	 * Punch a hole and prealloc the range. We use hole punch rather than
> -	 * unwritten extent conversion for two reasons:
> -	 *
> -	 * 1.) Hole punch handles partial block zeroing for us.
> -	 *
> -	 * 2.) If prealloc returns ENOSPC, the file range is still zero-valued
> -	 * by virtue of the hole punch.
> +	 * Convert whole blocks in the range to unwritten, then call iomap
> +	 * via xfs_zero_range to zero the range.  iomap will skip holes and
> +	 * unwritten extents, and just zero the edges if needed.  If conversion
> +	 * fails, iomap will simply write zeros to the whole range.
> +	 * nb: always_cow doesn't support unwritten extents.
>  	 */
> -	error = xfs_free_file_space(ip, offset, len);
> -	if (error || xfs_is_always_cow_inode(ip))
> -		return error;
> +	if (!xfs_is_always_cow_inode(ip))
> +		xfs_alloc_file_space(ip, round_up(offset, blksize),
> +				     round_down(offset + len, blksize) -
> +				     round_up(offset, blksize),
> +				     XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT);

If this fails with, say, corruption we should abort with an error,
not ignore it. I think we can only safely ignore ENOSPC and maybe
EDQUOT here...

> -	return xfs_alloc_file_space(ip, round_down(offset, blksize),
> -				     round_up(offset + len, blksize) -
> -				     round_down(offset, blksize),
> -				     XFS_BMAPI_PREALLOC);
> +	error = xfs_zero_range(ip, offset, len);

What prevents xfs_zero_range() from changing the file size if
offset + len is beyond EOF and there are allocated extents (from
delalloc conversion) beyond EOF? (i.e. FALLOC_FL_KEEP_SIZE is set by
the caller).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

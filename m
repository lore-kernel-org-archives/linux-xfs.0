Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41000 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbeJCTIm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Oct 2018 15:08:42 -0400
Date: Wed, 3 Oct 2018 08:20:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: zero posteof blocks when cloning above eof
Message-ID: <20181003122027.GD61971@bfoster>
References: <20181003020342.GD19324@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181003020342.GD19324@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, zlang@redhat.com

On Tue, Oct 02, 2018 at 07:03:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're reflinking between two files and the destination file range
> is well beyond the destination file's EOF marker, zero any posteof
> speculative preallocations in the destination file so that we don't
> expose stale disk contents.  The previous strategy of trying to clear
> the preallocations does not work if the destination file has the
> PREALLOC flag set but no delalloc blocks.
> 
> Uncovered by shared/010.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Bugzilla-id: https://bugzilla.kernel.org/show_bug.cgi?id=201259
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |   34 ++++++++++++++++++++++++++--------
>  1 file changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 38f405415b88..c8e996a99a74 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1195,6 +1195,27 @@ xfs_iolock_two_inodes_and_break_layout(
>  	return 0;
>  }
>  
> +/*
> + * If we're reflinking to a point past the destination file's EOF, we must
> + * zero any speculative post-EOF preallocations that sit between the old EOF
> + * and the destination file offset.
> + */
> +static int
> +xfs_reflink_zero_posteof(
> +	struct xfs_inode	*ip,
> +	loff_t			pos)
> +{
> +	loff_t			isize = i_size_read(VFS_I(ip));
> +	bool			did_zeroing = false;
> +
> +	if (pos <= isize)
> +		return 0;
> +
> +	trace_xfs_zero_eof(ip, isize, pos - isize);
> +	return iomap_zero_range(VFS_I(ip), isize, pos - isize, &did_zeroing,
> +			&xfs_iomap_ops);

iomap_zero_range() accepts NULL for the *did_zero param. Otherwise seems
fine, barring Eric's question on whether we need additional checks..

Brian

> +}
> +
>  /*
>   * Link a range of blocks from one file to another.
>   */
> @@ -1257,15 +1278,12 @@ xfs_reflink_remap_range(
>  	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
>  
>  	/*
> -	 * Clear out post-eof preallocations because we don't have page cache
> -	 * backing the delayed allocations and they'll never get freed on
> -	 * their own.
> +	 * Zero existing post-eof speculative preallocations in the destination
> +	 * file.
>  	 */
> -	if (xfs_can_free_eofblocks(dest, true)) {
> -		ret = xfs_free_eofblocks(dest);
> -		if (ret)
> -			goto out_unlock;
> -	}
> +	ret = xfs_reflink_zero_posteof(dest, pos_out);
> +	if (ret)
> +		goto out_unlock;
>  
>  	/* Set flags and remap blocks. */
>  	ret = xfs_reflink_set_inode_flag(src, dest);

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60524 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbeJCS7X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Oct 2018 14:59:23 -0400
Subject: Re: [PATCH] xfs: zero posteof blocks when cloning above eof
References: <20181003020342.GD19324@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <24443553-fc5e-a377-dcb4-dabc0177bf99@sandeen.net>
Date: Wed, 3 Oct 2018 07:11:14 -0500
MIME-Version: 1.0
In-Reply-To: <20181003020342.GD19324@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, zlang@redhat.com

On 10/2/18 9:03 PM, Darrick J. Wong wrote:
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

The action makes sense, and this does resolve my simple testcase,
and makes shared/010 pass for me as well.

However, this makes my correctness spidey-sense tingle; why is there
a new helper unique to extending reflinks, when extending writes already
must do the same thing?  I didn't follow all the discussion on IRC,
but might be worth explaining on the list for others as well.  Are there
any other extending write tests that aren't happening for extending reflink?

-Eric

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
> 

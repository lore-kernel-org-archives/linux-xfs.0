Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757058AbdCULjy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Mar 2017 07:39:54 -0400
Date: Tue, 21 Mar 2017 07:39:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: Honor FALLOC_FL_KEEP_SIZE when punching ends of
 files
Message-ID: <20170321113932.GA58653@bfoster.bfoster>
References: <22a11e65fd5037498a78de61f3ed4dae466ad854.1489791330.git.calvinowens@fb.com>
 <19504ff40a16efff2e51d85388fce5be578edbc3.1489985397.git.calvinowens@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19504ff40a16efff2e51d85388fce5be578edbc3.1489985397.git.calvinowens@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Calvin Owens <calvinowens@fb.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, kernel-team@fb.com, stable@vger.kernel.org

On Sun, Mar 19, 2017 at 09:54:51PM -0700, Calvin Owens wrote:
> When punching past EOF on XFS, fallocate(mode=PUNCH_HOLE|KEEP_SIZE) will
> round the file size up to the nearest multiple of PAGE_SIZE:
> 
>   calvinow@vm-disks/generic-xfs-1 ~$ dd if=/dev/urandom of=test bs=2048 count=1
>   calvinow@vm-disks/generic-xfs-1 ~$ stat test
>     Size: 2048            Blocks: 8          IO Block: 4096   regular file
>   calvinow@vm-disks/generic-xfs-1 ~$ fallocate -n -l 2048 -o 2048 -p test
>   calvinow@vm-disks/generic-xfs-1 ~$ stat test
>     Size: 4096            Blocks: 8          IO Block: 4096   regular file
> 
> Commit 3c2bdc912a1cc050 ("xfs: kill xfs_zero_remaining_bytes") replaced
> xfs_zero_remaining_bytes() with calls to iomap helpers. The new helpers
> don't enforce that [pos,offset) lies strictly on [0,i_size) when being
> called from xfs_free_file_space(), so by "leaking" these ranges into
> xfs_zero_range() we get this buggy behavior.
> 
> Fix this by reintroducing the checks xfs_zero_remaining_bytes() did
> against i_size at the bottom of xfs_free_file_space().
> 
> Reported-by: Aaron Gao <gzh@fb.com>
> Fixes: 3c2bdc912a1cc050 ("xfs: kill xfs_zero_remaining_bytes")
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: <stable@vger.kernel.org> # 4.8+
> Signed-off-by: Calvin Owens <calvinowens@fb.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 8b75dce..0796ebc 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1309,6 +1309,17 @@ xfs_free_file_space(
>  	}
>  
>  	/*
> +	 * Avoid doing I/O beyond eof - it's not necessary
> +	 * since nothing can read beyond eof.  The space will
> +	 * be zeroed when the file is extended anyway.
> +	 */

I'd suggest to update the comment below with this information and move
the following bits down below it as well.

> +	if (offset >= XFS_ISIZE(ip))
> +		return 0;
> +
> +	if ((offset + len) >= XFS_ISIZE(ip))
> +		len = XFS_ISIZE(ip) - offset - 1;
> +

This looks like an off-by-one. Do you mean the following?

	if (offset + len > XFS_ISIZE(ip))
		len = XFS_ISIZE(ip) - offset;

Brian

> +	/*
>  	 * Now that we've unmap all full blocks we'll have to zero out any
>  	 * partial block at the beginning and/or end.  xfs_zero_range is
>  	 * smart enough to skip any holes, including those we just created.
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54494 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731134AbeKVEpJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 23:45:09 -0500
Date: Wed, 21 Nov 2018 10:09:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/7] xfs: don't ENOSPC on writeback when punching holes
Message-ID: <20181121180936.GR6792@magnolia>
References: <20181119210459.8506-1-david@fromorbit.com>
 <20181119210459.8506-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119210459.8506-7-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 20, 2018 at 08:04:58AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Just tried to punch a 40T sparse file when enospc was triggered due
> to extent size hints consuming more space than expected. It failed
> with:
> 
> # sudo xfs_io -c "fpunch 0 40t" /mnt/fast/xfs-arekm.img
> fallocate: No space left on device
> #
> 
> because the writeback error of ENOSPC was being reported. We're
> going to free that space, so we don't care if there was a ENOSPC
> writeback error. So ignore ENOSPC errors and punch anyway.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 167ff4297e5c..cc7a0d47c529 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1060,8 +1060,13 @@ xfs_flush_unmap_range(
>  	start = round_down(offset, rounding);
>  	end = round_up(offset + len, rounding) - 1;
>  
> +	/*
> +	 * We're going to trash the data in this range, so if writeback reports
> +	 * an enospc error, don't let it stop us from /freeing the space/ in the
> +	 * range to alleviate the ENOSPC condition.
> +	 */
>  	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
> -	if (error)
> +	if (error && error != -ENOSPC)

I think there's a bug here -- COLLAPSE_RANGE and INSERT_RANGE call
xfs_prepare_shift to writeback and invalidate the pagecache from a
selected offset to EOF, and _prepare_shift calls _flush_unmap_range.

So if we have a dirty 100 block file and we ask xfs to collapse 3 blocks
at block 17, it'll _prepare_shift blocks 20-99 before shifting them down
by 3 blocks.  If we instead asked to insert 3 blocks at block 17, it'll
_prepare_shift blocks 17-99 before shifting them up by 3 blocks.

Unlike the punch/reflink cases, the _prepare_shift ranges aren't doomed,
so the user might want to know if the write fails.

--D

>  		return error;
>  	truncate_pagecache_range(inode, start, end);
>  	return 0;
> -- 
> 2.19.1
> 

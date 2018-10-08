Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18819 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727328AbeJHWnu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Oct 2018 18:43:50 -0400
Date: Mon, 8 Oct 2018 11:31:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: cancel COW blocks before swapext
Message-ID: <20181008153132.GA6377@bfoster>
References: <20181008101624.28120-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181008101624.28120-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 08, 2018 at 12:16:24PM +0200, Christoph Hellwig wrote:
> We need to make sure we have no outstanding COW blocks before we swap
> extents, as there is nothing preventing us from having preallocated COW
> delalloc on either inode that swapext is called on.  That case can
> easily be reproduced by running generic/324 in always_cow mode:
> 

Ok, I'm a little curious how you end up with delayed allocation
cowblocks in the temporary inode (created by xfs_fsr), but it sounds
like you have a mechanism enabled that utilizes cow in more situations
than purely shared blocks..?

Out of curiosity, what does xfs_fsr do to trigger cow fork reservation
in always_cow mode? Is it limited to overwrites, or do all writes result
in some kind of cow reservation?

> [  620.760572] XFS: Assertion failed: tip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap_util.c, line: 1669
> [  620.761608] ------------[ cut here ]------------
...
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 7cfda25f1bb1..97f7543fdfb6 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1465,6 +1465,12 @@ xfs_swap_extent_flush(
>  		return error;
>  	truncate_pagecache_range(VFS_I(ip), 0, -1);
>  
> +	if (xfs_inode_has_cow_data(ip)) {
> +		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
> +		if (error)
> +			return error;
> +	}
> +

Same comment as before.. we have 20-30 lines of code in
xfs_swap_extents() dedicated to swapping the cowblocks tags and cow
forks when ->if_bytes != 0. This patch appears to nullify that code, so
we should at least be able to reduce some of that to asserts.

Brian

>  	/* Verify O_DIRECT for ftmp */
>  	if (VFS_I(ip)->i_mapping->nrpages)
>  		return -EINVAL;
> -- 
> 2.19.0
> 

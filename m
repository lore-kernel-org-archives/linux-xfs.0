Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39902 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030397AbcJQRVF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 13:21:05 -0400
Date: Mon, 17 Oct 2016 13:21:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/9] xfs: refactor xfs_bunmapi_cow
Message-ID: <20161017172103.GH12736@bfoster.bfoster>
References: <1476521554-1894-1-git-send-email-hch@lst.de>
 <1476521554-1894-7-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476521554-1894-7-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Sat, Oct 15, 2016 at 10:52:31AM +0200, Christoph Hellwig wrote:
> Split out two helpers for deleting delayed or real extents from the COW fork.
> This allows to call them directly from xfs_reflink_cow_end_io once that
> function is refactored to iterate the extent tree.  It will also allow
> to reuse the delalloc deletion from xfs_bunmapi in the future.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 374 ++++++++++++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_bmap.h |   5 +
>  fs/xfs/xfs_reflink.c     |   5 -
>  3 files changed, 225 insertions(+), 159 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 5d230ea..f33f737 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -535,11 +535,6 @@ xfs_reflink_cancel_cow_blocks(
>  		trace_xfs_reflink_cancel_cow(ip, &irec);
>  
>  		if (irec.br_startblock == DELAYSTARTBLOCK) {
> -			/* Free a delayed allocation. */
> -			xfs_mod_fdblocks(ip->i_mount, irec.br_blockcount,
> -					false);

Don't we still need this call, or am I missing where it exists
elsewhere? Also, IIRC we might need to make sure this occurs after
xfs_bunmapi_cow() since the latter can steal blocks from the deleted
extent for indirect blocks (e.g., where we call
xfs_bmap_split_indlen()).

Brian

> -			ip->i_delayed_blks -= irec.br_blockcount;
> -
>  			/* Remove the mapping from the CoW fork. */
>  			error = xfs_bunmapi_cow(ip, &irec);
>  			if (error)
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

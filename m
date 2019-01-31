Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729317AbfAaT3I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 14:29:08 -0500
Date: Thu, 31 Jan 2019 14:29:05 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/11] xfs: move stat accounting to
 xfs_bmapi_convert_delalloc
Message-ID: <20190131192905.GK36239@bfoster>
References: <20190131075524.4769-1-hch@lst.de>
 <20190131075524.4769-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131075524.4769-10-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 08:55:22AM +0100, Christoph Hellwig wrote:
> This way we can actually count how many bytes got converted and how many
> calls we need, unlike in the caller which doesn't have the detailed
> view.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 4 ++++
>  fs/xfs/xfs_iomap.c       | 4 ----
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 408a6da14849..8e89f8fcec52 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4514,6 +4514,10 @@ xfs_bmapi_convert_delalloc(
>  		goto out_finish;
>  	}
>  
> +	XFS_STATS_ADD(mp, xs_xstrat_bytes,
> +		      XFS_FSB_TO_B(mp, bma.got.br_blockcount));

Hmm.. shouldn't this one be the blockcount of the initial delalloc
extent? I think this can be skewed if the delalloc blocks happen to
merge with an existing real extent.

Brian

> +	XFS_STATS_INC(mp, xs_xstrat_quick);
> +
>  	ASSERT(!isnullstartblock(bma.got.br_startblock));
>  	ASSERT(bma.got.br_startblock || XFS_IS_REALTIME_INODE(ip));
>  	*imap = bma.got;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 39be741cac5a..15da53b5fb53 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -707,9 +707,6 @@ xfs_iomap_write_allocate(
>  	map_start_fsb = imap->br_startoff;
>  	map_count_fsb = imap->br_blockcount;
>  
> -	XFS_STATS_ADD(mp, xs_xstrat_bytes,
> -		      XFS_FSB_TO_B(mp, imap->br_blockcount));
> -
>  	while (true) {
>  		/*
>  		 * Allocate in a loop because it may take several attempts to
> @@ -741,7 +738,6 @@ xfs_iomap_write_allocate(
>  		if ((offset_fsb >= imap->br_startoff) &&
>  		    (offset_fsb < (imap->br_startoff +
>  				   imap->br_blockcount))) {
> -			XFS_STATS_INC(mp, xs_xstrat_quick);
>  			xfs_trim_extent(imap, map_start_fsb, map_count_fsb);
>  			ASSERT(offset_fsb >= imap->br_startoff &&
>  			       offset_fsb < imap->br_startoff + imap->br_blockcount);
> -- 
> 2.20.1
> 

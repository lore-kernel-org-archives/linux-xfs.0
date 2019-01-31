Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfAaT2n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 14:28:43 -0500
Date: Thu, 31 Jan 2019 14:28:39 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/11] xfs: split XFS_BMAPI_DELALLOC handling from
 xfs_bmapi_write
Message-ID: <20190131192839.GI36239@bfoster>
References: <20190131075524.4769-1-hch@lst.de>
 <20190131075524.4769-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131075524.4769-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 08:55:20AM +0100, Christoph Hellwig wrote:
> Delalloc conversion has traditionally been part of our function to
> allocate blocks on disk (first xfs_bmapi, then xfs_bmapi_write), but
> delalloc conversion is a little special as we really do not want
> to allocate blocks over holes, for which we don't have reservations.
> 
> Split the delalloc conversions into a separate helper to keep the
> code simple and structured.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 104 +++++++++++++++++++++------------------
>  fs/xfs/libxfs/xfs_bmap.h |   4 --
>  2 files changed, 57 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index d75f45d9b7d1..818cd018d510 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
...
> @@ -4487,21 +4452,66 @@ xfs_bmapi_convert_delalloc(
>  	xfs_fileoff_t		offset_fsb,
>  	struct xfs_bmbt_irec	*imap)
>  {
> -	int			flags = XFS_BMAPI_DELALLOC, nimaps = 1, error;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	struct xfs_bmalloca	bma = { NULL };
> +	int			error;
>  
...
> +
> +	bma.tp = tp;
> +	bma.ip = ip;
> +	bma.wasdel = true;
> +	bma.offset = bma.got.br_startoff;
> +	bma.length = bma.got.br_blockcount;

Do we need a MAXEXTLEN cap here? Otherwise the rest looks sane to me.

Brian

> +	bma.total = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
> +	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
> +	if (whichfork == XFS_COW_FORK)
> +		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
> +
> +	if (!xfs_iext_peek_prev_extent(ifp, &bma.icur, &bma.prev))
> +		bma.prev.br_startoff = NULLFILEOFF;
> +
> +	error = xfs_bmapi_allocate(&bma);
> +	if (error)
> +		goto out_finish;
> +	if (WARN_ON_ONCE(bma.blkno == NULLFSBLOCK)) {
> +		error = -ENOSPC;
> +		goto out_finish;
> +	}
> +
> +	ASSERT(!isnullstartblock(bma.got.br_startblock));
> +	ASSERT(bma.got.br_startblock || XFS_IS_REALTIME_INODE(ip));
> +	*imap = bma.got;
> +
> +	if (whichfork == XFS_COW_FORK) {
> +		error = xfs_refcount_alloc_cow_extent(tp, bma.blkno,
> +				bma.length);
> +		if (error)
> +			goto out_finish;
> +	}
> +
> +	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
> +			whichfork);
> +out_finish:
> +	xfs_bmapi_finish(&bma, whichfork, error);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index c385987251cd..5bdfa8001f07 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -95,9 +95,6 @@ struct xfs_extent_free_item
>  /* Map something in the CoW fork. */
>  #define XFS_BMAPI_COWFORK	0x200
>  
> -/* Only convert delalloc space, don't allocate entirely new extents */
> -#define XFS_BMAPI_DELALLOC	0x400
> -
>  /* Only convert unwritten extents, don't allocate new blocks */
>  #define XFS_BMAPI_CONVERT_ONLY	0x800
>  
> @@ -117,7 +114,6 @@ struct xfs_extent_free_item
>  	{ XFS_BMAPI_ZERO,	"ZERO" }, \
>  	{ XFS_BMAPI_REMAP,	"REMAP" }, \
>  	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
> -	{ XFS_BMAPI_DELALLOC,	"DELALLOC" }, \
>  	{ XFS_BMAPI_CONVERT_ONLY, "CONVERT_ONLY" }, \
>  	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
>  	{ XFS_BMAPI_NORMAP,	"NORMAP" }
> -- 
> 2.20.1
> 

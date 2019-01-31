Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbfAaTbo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 14:31:44 -0500
Date: Thu, 31 Jan 2019 14:31:42 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 10/11] xfs: move xfs_iomap_write_allocate to xfs_aops.c
Message-ID: <20190131193141.GL36239@bfoster>
References: <20190131075524.4769-1-hch@lst.de>
 <20190131075524.4769-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131075524.4769-11-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 08:55:23AM +0100, Christoph Hellwig wrote:
> This function is a small wrapper only used by the writeback code, so
> move it together with the writeback code and simplify it down to the
> glorified do { } while loop that is now is.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c  | 47 ++++++++++++++++++++++++---
>  fs/xfs/xfs_iomap.c | 81 ----------------------------------------------
>  fs/xfs/xfs_iomap.h |  2 --
>  3 files changed, 42 insertions(+), 88 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 9c2a1947d5dd..d95156d8e801 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -329,6 +329,44 @@ xfs_imap_valid(
>  	return true;
>  }
>  
...
> +static int
> +xfs_convert_blocks(
> +	struct xfs_writepage_ctx *wpc,
> +	struct xfs_inode	*ip,
> +	xfs_fileoff_t		offset_fsb,
> +	struct xfs_bmbt_irec	*got)
> +{
> +	int			error;
> +
...
> +
> +	xfs_trim_extent(&wpc->imap, got->br_startoff, got->br_blockcount);

I see that the comment above the function describes this, but I'd rather
see it here and continue to detail exactly why it's needed (i.e., to
preserve the already determined COW overlap).

I'm also wondering whether this would be more clear if we passed
something like a "max len" parameter (relative to offset_fsb) rather
than the caller's got pointer.

> +	return 0;
> +}
> +
...
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 15da53b5fb53..361dfe7af783 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -665,87 +665,6 @@ xfs_file_iomap_begin_delay(
>  	return error;
>  }
>  
...
> -int
> -xfs_iomap_write_allocate(
> -	struct xfs_inode	*ip,
> -	int			whichfork,
> -	xfs_off_t		offset,
> -	struct xfs_bmbt_irec	*imap,
> -	unsigned int		*seq)
> -{
...
> 
> -	/*
> -	 * Make sure that the dquots are there.
> -	 */
> -	error = xfs_qm_dqattach(ip);
> -	if (error)
> -		return error;
> -

I think the commit log needs notes on why this and the
xfs_alert_fsblock_zero() hunk below going away is Ok.

Brian

> -	/*
> -	 * Store the file range the caller is interested in because it encodes
> -	 * state such as potential overlap with COW fork blocks. We must trim
> -	 * the allocated extent down to this range to maintain consistency with
> -	 * what the caller expects. Revalidation of the range itself is the
> -	 * responsibility of the caller.
> -	 */
> -	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> -	map_start_fsb = imap->br_startoff;
> -	map_count_fsb = imap->br_blockcount;
> -
> -	while (true) {
> -		/*
> -		 * Allocate in a loop because it may take several attempts to
> -		 * allocate real blocks for a contiguous delalloc extent if free
> -		 * space is sufficiently fragmented.
> -		 */
> -
> -		/*
> -		 * ilock was dropped since imap was populated which means it
> -		 * might no longer be valid. The current page is held locked so
> -		 * nothing could have removed the block backing offset_fsb.
> -		 * Attempt to allocate whatever delalloc extent currently backs
> -		 * offset_fsb and put the result in the imap pointer from the
> -		 * caller. We'll trim it down to the caller's most recently
> -		 * validated range before we return.
> -		 */
> -		error = xfs_bmapi_convert_delalloc(ip, whichfork, offset_fsb,
> -				imap, seq);
> -		if (error)
> -			return error;
> -
> -		/*
> -		 * See if we were able to allocate an extent that covers at
> -		 * least part of the callers request.
> -		 */
> -		if (!(imap->br_startblock || XFS_IS_REALTIME_INODE(ip)))
> -			return xfs_alert_fsblock_zero(ip, imap);
> -
> -		if ((offset_fsb >= imap->br_startoff) &&
> -		    (offset_fsb < (imap->br_startoff +
> -				   imap->br_blockcount))) {
> -			xfs_trim_extent(imap, map_start_fsb, map_count_fsb);
> -			ASSERT(offset_fsb >= imap->br_startoff &&
> -			       offset_fsb < imap->br_startoff + imap->br_blockcount);
> -			return 0;
> -		}
> -	}
> -}
> -
>  int
>  xfs_iomap_write_unwritten(
>  	xfs_inode_t	*ip,
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index c6170548831b..6b16243db0b7 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -13,8 +13,6 @@ struct xfs_bmbt_irec;
>  
>  int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
>  			struct xfs_bmbt_irec *, int);
> -int xfs_iomap_write_allocate(struct xfs_inode *, int, xfs_off_t,
> -			struct xfs_bmbt_irec *, unsigned int *);
>  int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
>  
>  void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
> -- 
> 2.20.1
> 

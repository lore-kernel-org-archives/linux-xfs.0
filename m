Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38212 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751173AbdIKPt1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Sep 2017 11:49:27 -0400
Date: Mon, 11 Sep 2017 11:49:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: rewrite getbmap using the xfs_iext_* helpers
Message-ID: <20170911154925.GB13400@bfoster.bfoster>
References: <20170903155140.17256-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903155140.17256-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 05:51:39PM +0200, Christoph Hellwig wrote:
> Currently getbmap uses xfs_bmapi_read to query the extent map, and then
> fixes up various bits that are eventually reported to userspace.
> 
> This patch instead rewrites it to use xfs_iext_lookup_extent and
> xfs_iext_get_extent to iteratively process the extent map.  This not
> only avoids the need to allocate a map for the returned xfs_bmbt_irec
> structures but also greatly simplified the code.
> 
> There are two intentional behavior changes compared to the old code:
> 
>  - the current code reports unwritten extents that don't directly border
>    a written one as unwritten even when not passing the BMV_IF_PREALLOC
>    option, contrary to the documentation.  The new code requires the
>    BMV_IF_PREALLOC flag to report the unwrittent extent bit.
>  - The new code does never merges consecutive extents, unlike the old
>    code that sometimes does it based on the boundaries of the
>    xfs_bmapi_read calls.  Note that the extent merging behavior was
>    entirely undocumented.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_bmap_util.c | 525 ++++++++++++++++++++-----------------------------
>  1 file changed, 208 insertions(+), 317 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index cd9a5400ba4f..a11f4c300643 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
...
> @@ -668,147 +599,107 @@ xfs_getbmap(
...
> +		/*
> +		 * In order to report shared extents accurately, we report each
> +		 * distinct shared / unshared part of a single bmbt record with
> +		 * an individual getbmapx record.
> +		 */
> +		bno = got.br_startoff + got.br_blockcount;
> +		rec = got;
> +		do {
> +			error = xfs_getbmap_report_one(ip, bmv, out, bmv_end,
> +					&rec);
> +			if (error || xfs_getbmap_full(bmv))
> +				goto out_unlock_ilock;
> +		} while (xfs_getbmap_next_rec(&rec, bno));
> +
> +		if (!xfs_iext_get_extent(ifp, ++idx, &got)) {
> +			xfs_fileoff_t	end = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
> +
> +			out[bmv->bmv_entries].bmv_oflags |= BMV_OF_LAST;
> +

I'm a little confused about the above bit. Isn't ->bmv_entries already
incremented past the last reported extent? Further, if there is a hole
to be reported, we potentially do that just below (which means that
->bmv_entries may or may not refer to the last reported segment here)..?

Otherwise the rest of the patch looks good to me.

Brian

> +			if (whichfork != XFS_ATTR_FORK && bno < end &&
> +			    !xfs_getbmap_full(bmv)) {
> +				xfs_getbmap_report_hole(ip, bmv, out, bmv_end,
> +						bno, end);
>  			}
> -			bmv->bmv_entries++;
> -			cur_ext++;
> +			break;
>  		}
> -	} while (nmap && bmv->bmv_length && cur_ext < bmv->bmv_count - 1);
>  
> - out_free_map:
> -	kmem_free(map);
> - out_unlock_ilock:
> +		if (bno >= first_bno + len)
> +			break;
> +	}
> +
> +out_unlock_ilock:
>  	xfs_iunlock(ip, lock);
> - out_unlock_iolock:
> +out_unlock_iolock:
>  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
>  
> -	for (i = 0; i < cur_ext; i++) {
> +	for (i = 0; i < bmv->bmv_entries; i++) {
>  		/* format results & advance arg */
>  		error = formatter(&arg, &out[i]);
>  		if (error)
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

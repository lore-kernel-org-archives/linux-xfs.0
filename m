Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34256 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754465AbcKURT0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Nov 2016 12:19:26 -0500
Date: Mon, 21 Nov 2016 12:19:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/14] xfs: use new extent lookup helpers in
 xfs_bmapi_write
Message-ID: <20161121171924.GC13300@bfoster.bfoster>
References: <1479746336-10986-1-git-send-email-hch@lst.de>
 <1479746336-10986-5-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479746336-10986-5-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 21, 2016 at 05:38:46PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 1a0fee4..9a8621d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4561,7 +4561,7 @@ xfs_bmapi_write(
>  	struct xfs_ifork	*ifp;
>  	struct xfs_bmalloca	bma = { NULL };	/* args for xfs_bmap_alloc */
>  	xfs_fileoff_t		end;		/* end of mapped file region */
> -	int			eof;		/* after the end of extents */
> +	bool			eof = false;	/* after the end of extents */
>  	int			error;		/* error return */
>  	int			n;		/* current extent index */
>  	xfs_fileoff_t		obno;		/* old block number (offset) */
> @@ -4639,12 +4639,14 @@ xfs_bmapi_write(
>  			goto error0;
>  	}
>  
> -	xfs_bmap_search_extents(ip, bno, whichfork, &eof, &bma.idx, &bma.got,
> -				&bma.prev);
>  	n = 0;
>  	end = bno + len;
>  	obno = bno;
>  
> +	if (!xfs_iext_lookup_extent(ip, ifp, bno, &bma.idx, &bma.got))
> +		eof = true;
> +	if (!xfs_iext_get_extent(ifp, bma.idx - 1, &bma.prev))
> +		bma.prev.br_startoff = NULLFILEOFF;
>  	bma.tp = tp;
>  	bma.ip = ip;
>  	bma.total = total;
> @@ -4731,11 +4733,8 @@ xfs_bmapi_write(
>  
>  		/* Else go on to the next record. */
>  		bma.prev = bma.got;
> -		if (++bma.idx < xfs_iext_count(ifp)) {
> -			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma.idx),
> -					 &bma.got);
> -		} else
> -			eof = 1;
> +		if (!xfs_iext_get_extent(ifp, ++bma.idx, &bma.got))
> +			eof = true;
>  	}
>  	*nmap = n;
>  
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

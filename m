Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35486 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753525AbcKQSMA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Nov 2016 13:12:00 -0500
Date: Thu, 17 Nov 2016 13:11:58 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/14] xfs: use new extent lookup helpers in
 xfs_bmapi_read
Message-ID: <20161117181158.GE49658@bfoster.bfoster>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
 <1479143565-30615-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479143565-30615-4-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 14, 2016 at 06:12:34PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 98f490b..1a0fee4 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4145,12 +4145,11 @@ xfs_bmapi_read(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp;
>  	struct xfs_bmbt_irec	got;
> -	struct xfs_bmbt_irec	prev;
>  	xfs_fileoff_t		obno;
>  	xfs_fileoff_t		end;
> -	xfs_extnum_t		lastx;
> +	xfs_extnum_t		idx;
>  	int			error;
> -	int			eof;
> +	bool			eof = false;
>  	int			n = 0;
>  	int			whichfork = xfs_bmapi_whichfork(flags);
>  
> @@ -4190,7 +4189,8 @@ xfs_bmapi_read(
>  			return error;
>  	}
>  
> -	xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &got, &prev);
> +	if (!xfs_iext_lookup_extent(ip, ifp, bno, &idx, &got))
> +		eof = true;
>  	end = bno + len;
>  	obno = bno;
>  
> @@ -4221,10 +4221,8 @@ xfs_bmapi_read(
>  			break;
>  
>  		/* Else go on to the next record. */
> -		if (++lastx < xfs_iext_count(ifp))
> -			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx), &got);
> -		else
> -			eof = 1;
> +		if (!xfs_iext_get_extent(ifp, ++idx, &got))
> +			eof = true;
>  	}
>  	*nmap = n;
>  	return 0;
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

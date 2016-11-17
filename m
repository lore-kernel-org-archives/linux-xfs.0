Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934681AbcKQTMw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Nov 2016 14:12:52 -0500
Date: Thu, 17 Nov 2016 14:12:50 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 14/14] xfs: remove NULLEXTNUM
Message-ID: <20161117191250.GP49658@bfoster.bfoster>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
 <1479143565-30615-15-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479143565-30615-15-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 14, 2016 at 06:12:45PM +0100, Christoph Hellwig wrote:
> We only ever set a field to this constant for an impossible to reach
> error case in xfs_bmap_search_extents.  That functions has been removed,
> so we can remove the constant as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c  | 2 +-
>  fs/xfs/libxfs/xfs_types.h | 1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 856d98d..3ab68db 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4260,7 +4260,7 @@ xfs_bmapi_allocate(
>  	if (bma->wasdel) {
>  		bma->length = (xfs_extlen_t)bma->got.br_blockcount;
>  		bma->offset = bma->got.br_startoff;
> -		if (bma->idx != NULLEXTNUM && bma->idx) {
> +		if (bma->idx) {
>  			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx - 1),
>  					 &bma->prev);
>  		}
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index cf044c0..717909f 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -57,7 +57,6 @@ typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
>  
>  #define	NULLAGBLOCK	((xfs_agblock_t)-1)
>  #define	NULLAGNUMBER	((xfs_agnumber_t)-1)
> -#define	NULLEXTNUM	((xfs_extnum_t)-1)
>  
>  #define NULLCOMMITLSN	((xfs_lsn_t)-1)
>  
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

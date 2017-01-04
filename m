Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56362 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936059AbdADOeG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Jan 2017 09:34:06 -0500
Date: Wed, 4 Jan 2017 09:34:05 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/5] xfs: fix the alignment fallback in xfs_bmap_btalloc
Message-ID: <20170104143405.GB41989@bfoster.bfoster>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
 <1482436822-31546-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482436822-31546-3-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Thu, Dec 22, 2016 at 09:00:19PM +0100, Christoph Hellwig wrote:
> The way the alignment field is used the minimum possible alignment is 1.
> By setting it to 0 we'll mess up calculations that rely on this.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 2760bc3..19c05e9 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3796,7 +3796,7 @@ xfs_bmap_btalloc(
>  		 */
>  		args.type = atype;
>  		args.fsbno = ap->blkno;
> -		args.alignment = 0;
> +		args.alignment = 1;

Ok, but we have the following near the top of xfs_alloc_vextent():

        if (args->alignment == 0)
                args->alignment = 1;

... so I'm not sure the commit log description is accurate. That aside:

Reviewed-by: Brian Foster <bfoster@redhat.com>

Brian

>  		if ((error = xfs_alloc_vextent(&args)))
>  			return error;
>  	}
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941117AbcJSO2E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Oct 2016 10:28:04 -0400
Date: Wed, 19 Oct 2016 09:48:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: fix the AG loop in xfs_alloc_vextent for busy
 extents
Message-ID: <20161019134806.GB28993@bfoster.bfoster>
References: <1476735753-5861-1-git-send-email-hch@lst.de>
 <1476735753-5861-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476735753-5861-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, michaelcallahan@fb.com

On Mon, Oct 17, 2016 at 10:22:31PM +0200, Christoph Hellwig wrote:
> If we have too many busy extents, or just enough to make our wanted
> allocation impossible we will never move on to another AG in
> xfs_alloc_vextent currently.  Change the loop exit condition to keep
> looking for an AG if we can't allocate an extent.
> 
> For the single AG cases we don't need to change anything as the higher
> layers need to handle this case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index effb64c..0a04bec 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2753,13 +2753,18 @@ xfs_alloc_vextent(
>  				trace_xfs_alloc_vextent_nofix(args);
>  				goto error0;
>  			}
> +
>  			/*
> -			 * If we get a buffer back then the allocation will fly.
> +			 * If we get a buffer back then the allocation will fly,
> +			 * unless there are busy extents in the way.
>  			 */
>  			if (args->agbp) {
> -				if ((error = xfs_alloc_ag_vextent(args)))
> +				error = xfs_alloc_ag_vextent(args);
> +				if (error)
>  					goto error0;
> -				break;
> +				if (args->agbno != NULLAGBLOCK)
> +					break;
> +				xfs_trans_brelse(args->tp, args->agbp);

How is this safe with respect to xfs_alloc_fix_freelist() potentially
dirtying the agf? Haven't we had deadlock and/or other problems due to
xfs_alloc_fix_freelist() succeeding when an allocation ultimately fails,
and subsequently rotating to a potentially lower agno?

Brian

>  			}
>  
>  			trace_xfs_alloc_vextent_loopfailed(args);
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

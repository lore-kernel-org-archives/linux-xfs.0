Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FE1C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 22:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74FDA6135C
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 22:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhESW5e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 18:57:34 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:46900 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229465AbhESW5d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 18:57:33 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 2F49368559;
        Thu, 20 May 2021 08:56:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljV6o-002wml-Kl; Thu, 20 May 2021 08:56:10 +1000
Date:   Thu, 20 May 2021 08:56:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: remove the size and nbytes variables in
 xfs_buf_alloc_pages
Message-ID: <20210519225610.GF664593@dread.disaster.area>
References: <20210519190900.320044-1-hch@lst.de>
 <20210519190900.320044-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519190900.320044-7-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=_880W3eISPMI8fE42WEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 09:08:55PM +0200, Christoph Hellwig wrote:
> These variables are not used for anything but recursively updating each
> other.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 76240d84d58b61..08c8667e6027fc 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -383,8 +383,6 @@ xfs_buf_alloc_pages(
>  	struct xfs_buf		*bp,
>  	uint			flags)
>  {
> -	size_t			size;
> -	size_t			nbytes;
>  	gfp_t			gfp_mask = xb_to_gfp(flags);
>  	unsigned short		page_count, i;
>  	xfs_off_t		start, end;
> @@ -396,7 +394,6 @@ xfs_buf_alloc_pages(
>  	if (!(flags & XBF_READ))
>  		gfp_mask |= __GFP_ZERO;
>  
> -	size = BBTOB(bp->b_length);
>  	start = BBTOB(bp->b_maps[0].bm_bn) >> PAGE_SHIFT;
>  	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
>  								>> PAGE_SHIFT;
> @@ -436,8 +433,6 @@ xfs_buf_alloc_pages(
>  			goto retry;
>  		}
>  
> -		nbytes = min_t(size_t, size, PAGE_SIZE);
> -		size -= nbytes;
>  		bp->b_pages[i] = page;
>  	}
>  	return 0;

These have already gone away with the bulk allocation patch. I think
you should rebase this series on top of that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

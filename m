Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F82C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 22:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 945E5611AE
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 22:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhESWlv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 18:41:51 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:59448 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229498AbhESWlu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 18:41:50 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 8041866B64;
        Thu, 20 May 2021 08:40:29 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljUrc-002wVE-Mb; Thu, 20 May 2021 08:40:28 +1000
Date:   Thu, 20 May 2021 08:40:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: cleanup _xfs_buf_get_pages
Message-ID: <20210519224028.GD664593@dread.disaster.area>
References: <20210519190900.320044-1-hch@lst.de>
 <20210519190900.320044-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210519190900.320044-5-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=IkcTkHD0fZMA:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=EX9OPJ4Y7lljhWOzf7IA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 09:08:53PM +0200, Christoph Hellwig wrote:
> Remove the check for an existing b_pages array as this function is always
> called right after allocating a buffer, so this can't happen.  Also
> use kmem_zalloc to allocate the page array instead of doing a manual
> memset gіven that the inline array is already pre-zeroed as part of the
> freshly allocated buffer anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 392b85d059bff5..9c64c374411081 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -281,19 +281,18 @@ _xfs_buf_get_pages(
>  	struct xfs_buf		*bp,
>  	int			page_count)
>  {
> -	/* Make sure that we have a page list */
> -	if (bp->b_pages == NULL) {
> -		bp->b_page_count = page_count;
> -		if (page_count <= XB_PAGES) {
> -			bp->b_pages = bp->b_page_array;
> -		} else {
> -			bp->b_pages = kmem_alloc(sizeof(struct page *) *
> -						 page_count, KM_NOFS);
> -			if (bp->b_pages == NULL)
> -				return -ENOMEM;
> -		}
> -		memset(bp->b_pages, 0, sizeof(struct page *) * page_count);
> +	ASSERT(bp->b_pages == NULL);
> +
> +	bp->b_page_count = page_count;
> +	if (page_count > XB_PAGES) {
> +		bp->b_pages = kmem_zalloc(sizeof(struct page *) * page_count,
> +					  KM_NOFS);
> +		if (!bp->b_pages)
> +			return -ENOMEM;
> +	} else {
> +		bp->b_pages = bp->b_page_array;
>  	}
> +
>  	return 0;
>  }

This will not apply (and break) the bulk alloc patch I sent out - we
have to ensure that the b_pages array is always zeroed before we
call the bulk alloc function, hence I moved the memset() in this
function to be unconditional. I almost cleaned up this function in
that patchset....

Just doing this:

	bp->b_page_count = page_count;
	if (page_count > XB_PAGES) {
		bp->b_pages = kmem_alloc(sizeof(struct page *) * page_count,
					 KM_NOFS);
		if (!bp->b_pages)
			return -ENOMEM;
	} else {
		bp->b_pages = bp->b_page_array;
	}
	memset(bp->b_pages, 0, sizeof(struct page *) * page_count);

	return 0;

will make it work fine with bulk alloc.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

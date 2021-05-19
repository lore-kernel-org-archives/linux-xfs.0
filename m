Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16A5C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 22:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8F26611AE
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 22:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhESWh4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 18:37:56 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53811 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229508AbhESWhz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 18:37:55 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 710EC1043AE0;
        Thu, 20 May 2021 08:36:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljUno-002wSK-Jf; Thu, 20 May 2021 08:36:32 +1000
Date:   Thu, 20 May 2021 08:36:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: split xfs_buf_allocate_memory
Message-ID: <20210519223632.GC664593@dread.disaster.area>
References: <20210519190900.320044-1-hch@lst.de>
 <20210519190900.320044-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519190900.320044-3-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=Ym7UvygxC5MOHXh6F7EA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 09:08:51PM +0200, Christoph Hellwig wrote:
> Split xfs_buf_allocate_memory into one helper that allocates from
> slab and one that allocates using the page allocator.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
....
> +static int
> +xfs_buf_alloc_slab(
> +	struct xfs_buf		*bp,
> +	unsigned int		flags)
> +{

xfs_buf_alloc_kmem() or xfs_buf_alloc_heap() would be better, I
think, because it matches the flag used to indicate how the memory
associated with the buffer was allocated.

> @@ -720,9 +717,17 @@ xfs_buf_get_map(
>  	if (error)
>  		return error;
>  
> -	error = xfs_buf_allocate_memory(new_bp, flags);
> -	if (error)
> -		goto out_free_buf;
> +	/*
> +	 * For buffers that are contained within a single page, just allocate
> +	 * the memory from the heap - there's no need for the complexity of
> +	 * page arrays to keep allocation down to order 0.
> +	 */
> +	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
> +	    xfs_buf_alloc_slab(new_bp, flags) < 0) {
> +		error = xfs_buf_alloc_pages(new_bp, flags);
> +		if (error)
> +			goto out_free_buf;
> +	}

Took me a moment to grok the logic pattern here, then I realised the
comment didn't help as it makes no indication that the heap
allocation is best effort and will fall back to pages. A small tweak
like:

	/*
	 * For buffers that fit entirely within a single page, first
	 * attempt to allocate the memory from the heap to minimise
	 * memory usage. If we can't get heap memory for these small
	 * buffers, we fall back to using the page allocator.
	 */

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

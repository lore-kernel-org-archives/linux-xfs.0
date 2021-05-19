Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B74C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 22:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8728F6135C
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 22:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhESW4m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 18:56:42 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:43059 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229518AbhESW4l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 18:56:41 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 26E8711409D0;
        Thu, 20 May 2021 08:55:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljV5y-002wm0-Iy; Thu, 20 May 2021 08:55:18 +1000
Date:   Thu, 20 May 2021 08:55:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: remove the xb_page_found stat counter in
 xfs_buf_alloc_pages
Message-ID: <20210519225518.GE664593@dread.disaster.area>
References: <20210519190900.320044-1-hch@lst.de>
 <20210519190900.320044-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519190900.320044-6-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=jr-9ztd1AjOI1_L53wsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 09:08:54PM +0200, Christoph Hellwig wrote:
> We did not find any page, we're allocating them all from the page
> allocator.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9c64c374411081..76240d84d58b61 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -436,8 +436,6 @@ xfs_buf_alloc_pages(
>  			goto retry;
>  		}
>  
> -		XFS_STATS_INC(bp->b_mount, xb_page_found);
> -
>  		nbytes = min_t(size_t, size, PAGE_SIZE);
>  		size -= nbytes;
>  		bp->b_pages[i] = page;

NACK. This is actually telling us that a page was allocated
successfully. I just used this very stat in combination with the
page allocate failure stat (xb_page_retries) to determine that the
bulk alloc code was failing to allocate all the pages asked for at
least 20% of the time.

$ xfs_stats.pl
.....
    xs_ig_dup............             0  Buf Statistics
    xs_ig_reclaims.......      38377759    pb_get................     432887411
    xs_ig_attrchg........             1    pb_create.............       1839653
  Log Operations                           pb_get_locked.........     431047794
    xs_log_writes........         71572    pb_get_locked_waited..           346
    xs_log_blocks........      36644864    pb_busy_locked........         13615
    xs_log_noiclogs......           265    pb_miss_locked........       1839651
    xs_log_force.........           521    pb_page_retries.......        488537
    xs_log_force_sleep...           495    pb_page_found.........       1839431
                                           pb_get_read...........           577


See the pb_miss_locked, pb_page_found and pb_page_retries numbers?
Almost all cache misses required page (rather than heap) allocation,
and 25% of them bulk allocation failed to allocate all pages in a
single call.

So, yeah, the buffer cache stats are useful diagnostic information
that I use a lot...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

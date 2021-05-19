Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48800C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27D44611BD
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhESXYH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 19:24:07 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:47919 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229465AbhESXYH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 19:24:07 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D86A0861600;
        Thu, 20 May 2021 09:22:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljVWX-002x7Q-2U; Thu, 20 May 2021 09:22:45 +1000
Date:   Thu, 20 May 2021 09:22:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: centralize page allocation and freeing for
 buffers
Message-ID: <20210519232245.GG664593@dread.disaster.area>
References: <20210519190900.320044-1-hch@lst.de>
 <20210519190900.320044-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519190900.320044-9-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=KkEDsGn_QSIgVdj270kA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 09:08:57PM +0200, Christoph Hellwig wrote:
> Factor out two helpers that do everything needed for allocating and
> freeing pages that back a buffer, and remove the duplication between
> the different interfaces.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This seems really confused.

Up until this point in the patch set you are pulling code out
of xfs_buf_alloc_pages() into helpers. Now you are getting rid of
the helpers and putting the slightly modified code back into
xfs_buf_alloc_pages(). This doesn't make any sense at all.

The freeing helper now requires the buffer state to be
manipulated on allocation failure so that the free function doesn't
run off the end of the bp->b_pages array. That's a bit of a
landmine, and it doesn't really clean anything up much at all.

And on the allocation side there is new "fail fast" behaviour
because you've lifted the readahead out of xfs_buf_alloc_pages. You
also lifted the zeroing checks, which I note that you immediately
put back inside xfs_buf_alloc_pages() in the next patch.

The stuff up to this point in the series makes sense. From this
patch onwards it seems to me that you're just undoing the factoring
and cleanups from the first few patches...

I mean, like the factoring of xfs_buf_alloc_slab(), you could have
just factored out xfs_buf_alloc_pages(bp, page_count) from
xfs_buf_allocate_memory() and used that directly in
xfs_buf_get_uncached() and avoided a bunch of this factoring, make a
slight logic modification and recombine churn. And it would be
trivial to do on top of the bulk allocation patch which already
converts both of these functions to use bulk allocation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

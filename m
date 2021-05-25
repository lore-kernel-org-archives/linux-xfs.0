Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA4DC47086
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 22:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 450D86140B
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 22:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhEYWpb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 18:45:31 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:40425 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229952AbhEYWpb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 18:45:31 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 307A680CB81;
        Wed, 26 May 2021 08:43:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1llfmI-005DTx-52; Wed, 26 May 2021 08:43:58 +1000
Date:   Wed, 26 May 2021 08:43:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: cleanup _xfs_buf_get_pages
Message-ID: <20210525224358.GK664593@dread.disaster.area>
References: <20210519190900.320044-1-hch@lst.de>
 <20210519190900.320044-5-hch@lst.de>
 <20210519224028.GD664593@dread.disaster.area>
 <20210520052335.GB21165@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520052335.GB21165@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=BxDII7KeunfySy2DZVIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 20, 2021 at 07:23:35AM +0200, Christoph Hellwig wrote:
> On Thu, May 20, 2021 at 08:40:28AM +1000, Dave Chinner wrote:
> > This will not apply (and break) the bulk alloc patch I sent out - we
> > have to ensure that the b_pages array is always zeroed before we
> > call the bulk alloc function, hence I moved the memset() in this
> > function to be unconditional. I almost cleaned up this function in
> > that patchset....
> 
> The buffer is freshly allocated here using kmem_cache_zalloc, so
> b_pages can't be set, b_page_array is already zeroed from
> kmem_cache_zalloc, and the separate b_pages allocation is swithced
> to use kmem_zalloc.  I thought the commit log covers this, but maybe
> I need to improve it?

I think I'm still living in the past a bit, where the page array in
an active uncached buffer could change via the old "associate
memory" interface. We still actually have that interface in
userspace, but we don't have anything in the kernel that uses it any
more.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

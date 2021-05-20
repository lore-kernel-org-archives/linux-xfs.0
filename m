Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D64F1C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 05:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A050A610CB
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 05:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhETFg3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 May 2021 01:36:29 -0400
Received: from verein.lst.de ([213.95.11.211]:40729 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhETFg2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 May 2021 01:36:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id BFA9767373; Thu, 20 May 2021 07:35:04 +0200 (CEST)
Date:   Thu, 20 May 2021 07:35:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: centralize page allocation and freeing for
 buffers
Message-ID: <20210520053504.GA21318@lst.de>
References: <20210519190900.320044-1-hch@lst.de> <20210519190900.320044-9-hch@lst.de> <20210519232245.GG664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519232245.GG664593@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 20, 2021 at 09:22:45AM +1000, Dave Chinner wrote:
> Up until this point in the patch set you are pulling code out
> of xfs_buf_alloc_pages() into helpers. Now you are getting rid of
> the helpers and putting the slightly modified code back into
> xfs_buf_alloc_pages(). This doesn't make any sense at all.

It makes a whole lot of sense, but it seems you don't like the
structure :)

As stated in the commit log we now have one helper that sets a
_XBF_PAGES backing with pages and the map, and one helper to
tear it down.   I think it makes a whole lot of sense this way.

> The freeing helper now requires the buffer state to be
> manipulated on allocation failure so that the free function doesn't
> run off the end of the bp->b_pages array. That's a bit of a
> landmine, and it doesn't really clean anything up much at all.

It is something we also do elsewhere in the kernel.  Another
alternative would be to do a NULL check on the page, or to just
pointlessly duplicate the freeing loop.

> And on the allocation side there is new "fail fast" behaviour
> because you've lifted the readahead out of xfs_buf_alloc_pages. You
> also lifted the zeroing checks, which I note that you immediately
> put back inside xfs_buf_alloc_pages() in the next patch.

This is to clearly split code consolidatation from behavior changes.
I could move both earlier at the downside of adding a lot of new
code first that later gets removed.

> I mean, like the factoring of xfs_buf_alloc_slab(), you could have
> just factored out xfs_buf_alloc_pages(bp, page_count) from
> xfs_buf_allocate_memory() and used that directly in
> xfs_buf_get_uncached() and avoided a bunch of this factoring, make a
> slight logic modification and recombine churn. And it would be
> trivial to do on top of the bulk allocation patch which already
> converts both of these functions to use bulk allocation....

As mentioned in the cover letter: the bulk allocation review is what
trigger this as it tripped me following various lose ends.  And as
usual I'd rather have that kind of change at the end where the
surrounding code makes sense, so the rebased version is now is patch 11
of this series.

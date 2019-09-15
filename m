Return-Path: <SRS0=NVxF=XK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16351C4CECC
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Sep 2019 13:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E59E42077C
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Sep 2019 13:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbfIONJg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Sep 2019 09:09:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbfIONJg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Sep 2019 09:09:36 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D3D687FDCA;
        Sun, 15 Sep 2019 13:09:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E01DC608C0;
        Sun, 15 Sep 2019 13:09:32 +0000 (UTC)
Date:   Sun, 15 Sep 2019 09:09:31 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH REPOST 1/2] xfs: drop minlen before tossing alignment on
 bmap allocs
Message-ID: <20190915130931.GB37752@bfoster>
References: <20190912143223.24194-1-bfoster@redhat.com>
 <20190912143223.24194-2-bfoster@redhat.com>
 <20190912223519.GP16973@dread.disaster.area>
 <20190913145802.GB28512@bfoster>
 <20190914220035.GY16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190914220035.GY16973@dread.disaster.area>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Sun, 15 Sep 2019 13:09:35 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 15, 2019 at 08:00:35AM +1000, Dave Chinner wrote:
> On Fri, Sep 13, 2019 at 10:58:02AM -0400, Brian Foster wrote:
> > On Fri, Sep 13, 2019 at 08:35:19AM +1000, Dave Chinner wrote:
> > > On Thu, Sep 12, 2019 at 10:32:22AM -0400, Brian Foster wrote:
> > > > The bmap block allocation code issues a sequence of retries to
> > > > perform an optimal allocation, gradually loosening constraints as
> > > > allocations fail. For example, the first attempt might begin at a
> > > > particular bno, with maxlen == minlen and alignment incorporated. As
> > > > allocations fail, the parameters fall back to different modes, drop
> > > > alignment requirements and reduce the minlen and total block
> > > > requirements.
> > > > 
> > > > For large extent allocations with an args.total value that exceeds
> > > > the allocation length (i.e., non-delalloc), the total value tends to
> > > > dominate despite these fallbacks. For example, an aligned extent
> > > > allocation request of tens to hundreds of MB that cannot be
> > > > satisfied from a particular AG will not succeed after dropping
> > > > alignment or minlen because xfs_alloc_space_available() never
> > > > selects an AG that can't satisfy args.total. The retry sequence
> > > > eventually reduces total and ultimately succeeds if a minlen extent
> > > > is available somewhere, but the first several retries are
> > > > effectively pointless in this scenario.
> > > > 
> > > > Beyond simply being inefficient, another side effect of this
> > > > behavior is that we drop alignment requirements too aggressively.
> > > > Consider a 1GB fallocate on a 15GB fs with 16 AGs and 128k stripe
> > > > unit:
> > > > 
> > > >  # xfs_io -c "falloc 0 1g" /mnt/file
> > > >  # <xfstests>/src/t_stripealign /mnt/file 32
> > > >  /mnt/file: Start block 347176 not multiple of sunit 32
> > > 
> > > Ok, so what Carlos and I found last night was an issue with the
> > > the agresv code leading to the maximum free extent calculated
> > > by xfs_alloc_longest_free_extent() being longer than the largest
> > > allowable extent allocation (mp->m_ag_max_usable) resulting in the
> > > situation where blen > args->maxlen, and so in the case of initial
> > > allocation here, we never run this:
> > > 
> > > 	/*
> > > 	 * Adjust for alignment
> > > 	 */
> > > 	if (blen > args.alignment && blen <= args.maxlen)
> > > 		args.minlen = blen - args.alignment;
> > > 	args.minalignslop = 0;
> > > 
> ....
> > > > As a step towards addressing this problem, insert a new retry in the
> > > > bmap allocation sequence to drop minlen (from maxlen) before tossing
> > > > alignment. This should still result in as large of an extent as
> > > > possible as the block allocator prioritizes extent size in all but
> > > > exact allocation modes. By itself, this does not change the behavior
> > > > of the command above because the preallocation code still specifies
> > > > total based on maxlen. Instead, this facilitates preservation of
> > > > alignment once extra reservation is separated from the extent length
> > > > portion of the total block requirement.
> > > 
> > > AFAICT this is not necessary. The prototypoe patch I wrote last
> > > night while working through this with Carlos is attached below. I
> > > updated with a variant of your patch 2 to demonstrate that it does
> > > actually solve the problem of full AG allocation failing to be
> > > aligned.
> > > 
> > 
> > I agree that this addresses the reported issue, but I can reproduce
> > other corner cases affected by the original patch that aren't affected
> > by this one. For example, if the allocation request happens to be
> > slightly less than blen but not enough to allow for alignment, minlen
> > isn't dropped and we can run through the same allocation retry sequence
> > that kills off alignment before success.
> 
> But isn't that just another variation of the initial conditions
> (minlen/maxlen) not being set up correctly for alignment when the AG
> is empty?
> 

Perhaps, though I don't think it's exclusive to an empty AG.

> i.e. Take the above condition and change it like this:
> 
>  	/*
>  	 * Adjust for alignment
>  	 */
> -	if (blen > args.alignment && blen <= args.maxlen)
> +	if (blen > args.alignment && blen <= args.maxlen + args.alignment)
>  		args.minlen = blen - args.alignment;
>  	args.minalignslop = 0;
> 
> and now we cover all the cases when blen covers an aligned maxlen
> allocation...
> 

Do we want to consider whether minlen goes to 1? Otherwise that looks
reasonable to me. What I was trying to get at is just that we should
consider whether there are any other corner cases (that we might care
about) where this particular allocation might not behave as expected vs.
just the example used in the original commit log.

If somebody wants to send a finalized patch or two with these fixes
along with the bma.total one (or I can tack it on in reply..?), I'll
think about it further on review as well..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

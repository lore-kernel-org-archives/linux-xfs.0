Return-Path: <SRS0=/CVM=XI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C5BC49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Sep 2019 14:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1C0A20830
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Sep 2019 14:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388214AbfIMO6J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Sep 2019 10:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388211AbfIMO6J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Sep 2019 10:58:09 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 97E3F50F45;
        Fri, 13 Sep 2019 14:58:08 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD07C100EBA2;
        Fri, 13 Sep 2019 14:58:03 +0000 (UTC)
Date:   Fri, 13 Sep 2019 10:58:02 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH REPOST 1/2] xfs: drop minlen before tossing alignment on
 bmap allocs
Message-ID: <20190913145802.GB28512@bfoster>
References: <20190912143223.24194-1-bfoster@redhat.com>
 <20190912143223.24194-2-bfoster@redhat.com>
 <20190912223519.GP16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912223519.GP16973@dread.disaster.area>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 13 Sep 2019 14:58:08 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 13, 2019 at 08:35:19AM +1000, Dave Chinner wrote:
> On Thu, Sep 12, 2019 at 10:32:22AM -0400, Brian Foster wrote:
> > The bmap block allocation code issues a sequence of retries to
> > perform an optimal allocation, gradually loosening constraints as
> > allocations fail. For example, the first attempt might begin at a
> > particular bno, with maxlen == minlen and alignment incorporated. As
> > allocations fail, the parameters fall back to different modes, drop
> > alignment requirements and reduce the minlen and total block
> > requirements.
> > 
> > For large extent allocations with an args.total value that exceeds
> > the allocation length (i.e., non-delalloc), the total value tends to
> > dominate despite these fallbacks. For example, an aligned extent
> > allocation request of tens to hundreds of MB that cannot be
> > satisfied from a particular AG will not succeed after dropping
> > alignment or minlen because xfs_alloc_space_available() never
> > selects an AG that can't satisfy args.total. The retry sequence
> > eventually reduces total and ultimately succeeds if a minlen extent
> > is available somewhere, but the first several retries are
> > effectively pointless in this scenario.
> > 
> > Beyond simply being inefficient, another side effect of this
> > behavior is that we drop alignment requirements too aggressively.
> > Consider a 1GB fallocate on a 15GB fs with 16 AGs and 128k stripe
> > unit:
> > 
> >  # xfs_io -c "falloc 0 1g" /mnt/file
> >  # <xfstests>/src/t_stripealign /mnt/file 32
> >  /mnt/file: Start block 347176 not multiple of sunit 32
> 
> Ok, so what Carlos and I found last night was an issue with the
> the agresv code leading to the maximum free extent calculated
> by xfs_alloc_longest_free_extent() being longer than the largest
> allowable extent allocation (mp->m_ag_max_usable) resulting in the
> situation where blen > args->maxlen, and so in the case of initial
> allocation here, we never run this:
> 
> 	/*
> 	 * Adjust for alignment
> 	 */
> 	if (blen > args.alignment && blen <= args.maxlen)
> 		args.minlen = blen - args.alignment;
> 	args.minalignslop = 0;
> 

Interesting, I think I missed this logic when I looked at this
originally. It makes sense that we should be allowing this to handle the
maxlen = minlen alignment case.

> this is how we end up with args.minlen = args.maxlen and the
> initial allocation failing.
> 
> The issue is the way mp->m_ag_max_usable is calculated versus how
> the pag->pag_meta_resv.ar_reserved value is set up for the finobt.
> That is, "ask" = max tree size, and "used" = 1 because we have a
> root block allocated. that code does:
> 

Ok, I see that this behavior changes without perag reservations in the
mix (i.e., disable finobt, reflink, etc.). The perag reservation
calculation stuff always confuses me, however..

> 	mp->m_ag_max_unused -= ask;
> ...
> 	pag->pag_meta_resv.ar_reserved = ask - used
> 
> That means when we calculate the longest extent in the AG, we do:
> 
> 	longest = pag->pagf_longest - min_needed - resv(NONE)
> 		= pag->pagf_longest - min_needed - pag->pag_meta_resv.ar_reserved
> 

So here we use ar_reserved, which reflects outstanding and so far unused
reservation for the metadata type.

> whilst mp->m_ag_max_usable is calculated as
> 
> 	usable = agf_length - AG header blocks - AGFL - resv(ask)
> 

And here we apparently use the total reservation requirement, regardless
of how much is used, because we're calculating the maximum amount ever
available from the AG.

> When the AG is empty, this ends up with
> 
> 	pag->pagf_longest = agf_length - AG header blocks
> and
> 	min_needed = AGFL blocks
> and
> 	resv(ask) = pag->pag_meta_resv.ar_reserved + 1
> 
> and so:
> 	longest = usable + 1
> 
> And that's how we get blen = maxlen + 1, and that's why alignment is
> being dropped for the initial allocation in this "allocate full AG"
> corner case.
> 

And maxlen is capped to ->m_ag_max_usable, hence the delta between the
two values. I think this makes sense. Thanks for the breakdown.

> > Despite the filesystem being completely empty, the fact that the
> > allocation request cannot be satisifed from a single AG means the
> > allocation doesn't succeed until xfs_bmap_btalloc() drops total from
> > the original value based on maxlen. This occurs after we've dropped
> > minlen and alignment (unnecessarily).
> 
> Right, we'll continue to fail until minlen is reduced appropriately.
> But that's not an issue in the fallback algorithms, that's a problem
> with the initial conditions not being set up correctly.
> 
> > As a step towards addressing this problem, insert a new retry in the
> > bmap allocation sequence to drop minlen (from maxlen) before tossing
> > alignment. This should still result in as large of an extent as
> > possible as the block allocator prioritizes extent size in all but
> > exact allocation modes. By itself, this does not change the behavior
> > of the command above because the preallocation code still specifies
> > total based on maxlen. Instead, this facilitates preservation of
> > alignment once extra reservation is separated from the extent length
> > portion of the total block requirement.
> 
> AFAICT this is not necessary. The prototypoe patch I wrote last
> night while working through this with Carlos is attached below. I
> updated with a variant of your patch 2 to demonstrate that it does
> actually solve the problem of full AG allocation failing to be
> aligned.
> 

I agree that this addresses the reported issue, but I can reproduce
other corner cases affected by the original patch that aren't affected
by this one. For example, if the allocation request happens to be
slightly less than blen but not enough to allow for alignment, minlen
isn't dropped and we can run through the same allocation retry sequence
that kills off alignment before success.

This does raise an interesting question in that current allocation
behavior allocates one extent out of whatever that largest free extent
happened to be in the AG, regardless of whether it's aligned (because
args.alignment drops to 1 before minlen). With the retry in this patch,
we'd satisfy alignment but end up allocating two extents in the file
after chopping alignment off the first free extent.

I could see a reasonable argument for either. On one hand contiguity may
be preferable to alignment. On the other, the difference between one or
two extents in this case is basically the alignment size. Getting back
an unaligned extent of say 200MB over an aligned extent 128k smaller
might not be worth it, or at the very least unexpected to users who
don't understand XFS geometry when there are multiples of that amount of
free space still available in the broader fs. I don't feel too strongly
about it either way, but figured it's worth noting..

...
> 
> xfs: cap longest free extent to maximum allocatable
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Cap longest extent to the largest we can allocate based on limits
> calculated at mount time. Dynamic state (such as finobt blocks)
> can result in the longest free extent exceeding the size we can
> allocate, and that results in failure to align full AG allocations
> when the AG is empty.
> 
...
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Are either of you guys planning to post this patch without the
bmapi.total hack?

Brian

>  fs/xfs/libxfs/xfs_alloc.c |  3 ++-
>  fs/xfs/libxfs/xfs_bmap.c  | 14 ++++++++++++++
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 533b04aaf6f6..9dead25d2e70 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1989,7 +1989,8 @@ xfs_alloc_longest_free_extent(
>  	 * reservations and AGFL rules in place, we can return this extent.
>  	 */
>  	if (pag->pagf_longest > delta)
> -		return pag->pagf_longest - delta;
> +		return min_t(xfs_extlen_t, pag->pag_mount->m_ag_max_usable,
> +				pag->pagf_longest - delta);
>  
>  	/* Otherwise, let the caller try for 1 block if there's space. */
>  	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 054b4ce30033..b05683f649a6 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4286,6 +4286,20 @@ xfs_bmapi_write(
>  #endif
>  	whichfork = xfs_bmapi_whichfork(flags);
>  
> +	/*
> +	 * XXX: Hack!
> +	 *
> +	 * If the total blocks requested is larger than an AG, we can't allocate
> +	 * all the space atomically and within a single AG. This will be a
> +	 * "short" allocation. In this case, just ignore the total block count
> +	 * and rely on minleft calculations to ensure the allocation we do fits
> +	 * inside an AG properly.
> +	 *
> +	 * Based on a patch from Brian.
> +	 */
> +	if (bma.total > mp->m_ag_max_usable)
> +		bma.total = 0;
> +
>  	ASSERT(*nmap >= 1);
>  	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
>  	ASSERT(tp != NULL);

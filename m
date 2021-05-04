Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF790C433ED
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 00:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFA9D61185
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 00:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhEDAEK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 May 2021 20:04:10 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45608 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229619AbhEDAEK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 May 2021 20:04:10 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 93EB95ED3F9;
        Tue,  4 May 2021 10:03:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ldiWo-002D8K-Ax; Tue, 04 May 2021 10:03:06 +1000
Date:   Tue, 4 May 2021 10:03:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for AGFL
Message-ID: <20210504000306.GJ63242@dread.disaster.area>
References: <20210428065152.77280-1-chandanrlinux@gmail.com>
 <20210428065152.77280-2-chandanrlinux@gmail.com>
 <20210429011231.GF63242@dread.disaster.area>
 <875z0399gw.fsf@garuda>
 <20210430224415.GG63242@dread.disaster.area>
 <87y2cwnnzp.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2cwnnzp.fsf@garuda>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=tfik3ZwBfVseTzO5duUA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 03, 2021 at 03:22:10PM +0530, Chandan Babu R wrote:
> On 01 May 2021 at 04:14, Dave Chinner wrote:
> >> that end, I have tried to slightly simplify the patch that I had originally
> >> sent (i.e. [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for
> >> AGFL). The new patch removes one the boolean variables
> >> (i.e. alloc_small_extent) and also skips redundant searching of extent records
> >> when backtracking in preparation for searching smaller extents.
> >
> > I still don't think this is right approach because it tries to
> > correct a bad decision (use a busy extent instead of trying the next
> > free extent) with another bad decision (log force might not unbusy
> > the extent we are trying to allocate). We should not do either of
> > these things in this situation, nor do we need to mark busy extents
> > as being in a transaction to avoid deadlocks.
> >
> > That is, if all free extents are busy and there is nothing we can
> > allocate in the AG for the AGFL, then flush the busy extents and try
> > again while we hold the AGF locked. Because we hold the AGF locked,
> > nobody else can create new busy extents in the AG while we wait.
> > That means after a busy extent flush any remaining busy extents in
> > this AG are ones that we hold busy in this transaction and are the
> > ones we need to avoid allocating from in the first place.
> >
> > IOWs, we don't need to mark busy extents as being in a transaction
> > at all - we know that this is the only way we can have a busy extent
> > in the AG after we flush busy extents while holding the AGF locked.
> > And that means if we still can't find a free extent after a busy
> > extent flush, then we're definitely at ENOSPC in that AG as there
> > are no free extents we can safely allocate from in the AG....
> 
> ... Assume that there is one free busy extent in an AG and that it is 1 block
> in length. Also assume that the free extent is busy in the current
> transaction.

ISTR that this won't happen during extent allocation because the
transaction reservation and the AG selection code is supposed to
ensure there are sufficient free blocks both globally and in the AG
for the entire operation, not just one part of it.

Also, the extent freeing path is this:

...
  __xfs_free_extent()
    xfs_free_extent_fix_freelist()
      xfs_alloc_fix_freelist(XFS_ALLOC_FLAG_FREEING)

And that XFS_ALLOC_FLAG_FREEING is special - it means that we:

a) always say there is space available in the AG for the freeing
operation to take place, and
b) only perform best effort allocation to fill up the free list.

Case b) triggers this code:

                /*
                 * Stop if we run out.  Won't happen if callers are obeying
                 * the restrictions correctly.  Can happen for free calls
                 * on a completely full ag.
                 */
                if (targs.agbno == NULLAGBLOCK) {
                        if (flags & XFS_ALLOC_FLAG_FREEING)
                                break;
                        goto out_agflbp_relse;
                }


That is, if we fail to fix up the free list, we still go ahead with
the operation because freeing extents when we are at ENOSPC means
that, by definition, we don't need to allocate blocks to track the
new free space because the new free space records will fit inside
the root btree blocks that are already allocated.

Hence when doing allocation for the free list, we need to fail the
allocation rather than block on the only remaining free extent in
the AG. If we are freeing extents, the AGFL not being full is not an
issue at all. And if we are allocating extents, the transaction
reservations should have ensured that the AG had sufficient space in
it to complete the entire operation without deadlocking waiting for
space.

Either way, I don't see a problem with making sure the AGFL
allocations just skip busy extents and fail if the only free extents
are ones this transaction has freed itself.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

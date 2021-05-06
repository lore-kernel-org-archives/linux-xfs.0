Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE89C433ED
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 03:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0C74610F7
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 03:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhEFD2w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 May 2021 23:28:52 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:50949 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231253AbhEFD2w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 May 2021 23:28:52 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 41F503A3B;
        Thu,  6 May 2021 13:27:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1leUg3-005WS3-Gu; Thu, 06 May 2021 13:27:51 +1000
Date:   Thu, 6 May 2021 13:27:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for AGFL
Message-ID: <20210506032751.GN63242@dread.disaster.area>
References: <20210428065152.77280-1-chandanrlinux@gmail.com>
 <20210428065152.77280-2-chandanrlinux@gmail.com>
 <20210429011231.GF63242@dread.disaster.area>
 <875z0399gw.fsf@garuda>
 <20210430224415.GG63242@dread.disaster.area>
 <87y2cwnnzp.fsf@garuda>
 <20210504000306.GJ63242@dread.disaster.area>
 <874kfh5p32.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kfh5p32.fsf@garuda>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=R04aVgrrI8BGyaBlWOcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 05, 2021 at 06:12:41PM +0530, Chandan Babu R wrote:
> > Hence when doing allocation for the free list, we need to fail the
> > allocation rather than block on the only remaining free extent in
> > the AG. If we are freeing extents, the AGFL not being full is not an
> > issue at all. And if we are allocating extents, the transaction
> > reservations should have ensured that the AG had sufficient space in
> > it to complete the entire operation without deadlocking waiting for
> > space.
> >
> > Either way, I don't see a problem with making sure the AGFL
> > allocations just skip busy extents and fail if the only free extents
> > are ones this transaction has freed itself.
> >
> 
> Hmm. In the scenario where *all* free extents in the AG were originally freed
> by the current transaction (and hence busy in the transaction),

How does that happen? 

> we would need
> to be able to recognize this situation and skip invoking
> xfs_extent_busy_flush() altogether.

If we are freeing extents (i.e XFS_ALLOC_FLAG_FREEING is set) and
we are doing allocation for AGFL and we only found busy extents,
then it's OK to fail the allocation.

We have options here - once we get to the end of the btree and
haven't found a candidate that isn't busy, we could fail
immediately. Or maybe we try an optimisitic flush which forces the
log and waits for as short while (instead of forever) for the
generation to change and then fail if we get a timeout response. Or
maybe there's a more elegant way of doing this that hasn't yet
rattled out of my poor, overloaded brain right now.

Just because we currently do a blocking flush doesn't mean we always
must do a blocking flush....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

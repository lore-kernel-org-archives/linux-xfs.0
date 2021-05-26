Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09065C47087
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 02:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D45AB6101B
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 02:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhEZCDD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 22:03:03 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:50521 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231911AbhEZCDC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 22:03:02 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BC1C61043A71;
        Wed, 26 May 2021 12:01:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1llirO-005GnP-9s; Wed, 26 May 2021 12:01:26 +1000
Date:   Wed, 26 May 2021 12:01:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>
Subject: Re: patch review scheduling...
Message-ID: <20210526020126.GN664593@dread.disaster.area>
References: <20210526012704.GH202144@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526012704.GH202144@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=PmktHFhGuwvk4lmZ-gUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 25, 2021 at 06:27:04PM -0700, Darrick J. Wong wrote:
> Hello list, frequent-submitters, and usual-reviewer-suspects:
> 
> As you've all seen, we have quite a backlog of patch review for 5.14
> already.  The people cc'd on this message are the ones who either (a)
> authored the patches caught in the backlog, (b) commented on previous
> iterations of them, or (c) have participated in a lot of reviews before.
> 
> Normally I'd just chug through them all until I get to the end, but even
> after speed-reading through the shorter series (deferred xattrs,
> mmaplock, reflink+dax) I still have 73 to go, which is down from 109
> this morning.
> 
> So, time to be a bit more aggressive about planning.  I would love it if
> people dedicated some time this week to reviewing things, but before we
> even get there, I have other questions:
> 
> Dave: Between the CIL improvements and the perag refactoring, which
> would you rather get reviewed first?  The CIL improvments patches have
> been circulating longer, but they're more subtle changes.

The perag refactoring is already mostly reviewed and the changes are
simpler, so knock the rest of them out first.

The CIL series already has all the seperable changes up to patch 11
reviewed, so they can be merged without further review work.

The next chunk in that patch set is up to patch 25 (or is it 26?),
but I think there's only 4-5 patches in that set that are not yet
reviewed. That would be the next set to look at.

The rest of the patchset is the scalabilty stuff which probably is
going to be too much at this point, so we can leave it off to the
next cycle (when I'll put out another 20-30 patches I already have
on top of this with it...)

> Dave and Christoph: Can I rely on you both to sort out whatever
> conflicts arose around reworking memory page allocation for xfs_bufs?

Yep, we'll get that sorted out. There's no disagreement on where we
want to end up, just on how we get there :P

> Brian: Is it worth the time to iterate more on the ioend thresholds in
> the "iomap: avoid soft lockup warnings" series?  Specifically, I was
> kind of interested in whether or not we should/could scale the max ioend
> size limit with the optimal/max io request size that devices report,
> though I'm getting a feeling that block device limits are all over the
> place maybe we should start with the static limit and iterate up (or
> down?) from there...?

I recommend just staying with static limits to start with. This is
"good enough" to solve the immediate problems, and we can look for
more optimised solutions once we've merged the initial fixes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

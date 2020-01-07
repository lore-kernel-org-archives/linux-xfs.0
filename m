Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124EAC282DD
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 21:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2A9B2080A
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 21:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgAGVcA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 16:32:00 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48696 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726389AbgAGVcA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 16:32:00 -0500
Received: from dread.disaster.area (pa49-180-68-255.pa.nsw.optusnet.com.au [49.180.68.255])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 81BA07E827D;
        Wed,  8 Jan 2020 08:31:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iowSB-0005ur-DF; Wed, 08 Jan 2020 08:31:55 +1100
Date:   Wed, 8 Jan 2020 08:31:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Waiman Long <longman@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfs: Fix false positive lockdep warning with sb_internal
 & fs_reclaim
Message-ID: <20200107213155.GE23128@dread.disaster.area>
References: <20200102155208.8977-1-longman@redhat.com>
 <20200104023657.GA23128@dread.disaster.area>
 <922bff4b-a463-11db-f969-d268462802a1@redhat.com>
 <20200106210127.GC23128@dread.disaster.area>
 <92d8a1fc-4b9d-72bb-5b44-9da5f153945e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92d8a1fc-4b9d-72bb-5b44-9da5f153945e@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=sbdTpStuSq8iNQE8viVliQ==:117 a=sbdTpStuSq8iNQE8viVliQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=7-415B0cAAAA:8 a=OnEmKnlSv6uCDMwlAAQA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 10:40:12AM -0500, Waiman Long wrote:
> On 1/6/20 4:01 PM, Dave Chinner wrote:
> > On Mon, Jan 06, 2020 at 11:12:32AM -0500, Waiman Long wrote:
> >> On 1/3/20 9:36 PM, Dave Chinner wrote:
> >>> On Thu, Jan 02, 2020 at 10:52:08AM -0500, Waiman Long wrote:
> >>> IOWs, "fix" it by stating that "lockdep can't track freeze
> >>> dependencies correctly"?
> >> The lockdep code has a singular focus on spotting possible deadlock
> >> scenarios from a locking point of view.
> > IMO, lockdep only works for very simplistic locking strategies.
> > Anything complex requires more work to get lockdep annotations
> > "correct enough" to prevent false positives than it does to actually
> > read the code and very the locking is correct.
> >
> > Have you noticed we do runs of nested trylock-and-back-out-on-
> > failure because we lock objects in an order that might deadlock
> > because of cross-object state dependencies that can't be covered by
> > lockdep?  e.g. xfs_lock_inodes() which nests up to 5 inodes deep,
> > can nest 3 separate locks per inode and has to take into account
> > journal flushing depenedencies when locking multiple inodes?
> >
> > Lockdep is very simplisitic and the complex annotations we need to
> > handle situations like the above are very difficult to design,
> > use and maintainr. It's so much simpler just to use big hammers like
> > GFP_NOFS to shut up all the different types of false positives
> > lockdep throws up for reclaim context false positives because after
> > all these years there still isn't a viable mechanism to easily
> > express this sort of complex dependency chain.
>
> Regarding the trylock-and-back-out-on_failure code, do you think adding
> new APIs with timeout for mutex and rwsem and may be spin count for

Timeouts have no place in generic locking APIs. Indeed, in these
cases, timeouts do nothing to avoid the issues that require us to
use trylock-and-back-out algorithms, so timeouts do nothing but
hold off racing inode locks for unnecessarily long time periods
while we wait for something to happen somewhere else that we have no
direct control over....

> spinlock will help to at least reduce the number of failures that can
> happen in the code. RT mutex does have a rt_mutex_timed_lock(), but
> there is no equivalent for mutex and rwsem.

Realtime has all sorts of problems with blocking where normal
kernels don't (e.g. by turning spinlocks into mutexes) and so it
forces rt code to jump through all sorts of crazy hoops to prevent
priority inversions and deadlocks. If lock timeouts are necessary
to avoid deadlocks and/or priority inversions in your code, then
that indicates that there are locking algorithm problems that need
fixing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

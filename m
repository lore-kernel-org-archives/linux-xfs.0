Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F01C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 21:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 418E564F68
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 21:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhBCVVA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 16:21:00 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:41263 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229973AbhBCVU7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 16:20:59 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 0D2D6100A99;
        Thu,  4 Feb 2021 08:20:14 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l7PZN-005qjZ-Nm; Thu, 04 Feb 2021 08:20:13 +1100
Date:   Thu, 4 Feb 2021 08:20:13 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/5] xfs: various log stuff...
Message-ID: <20210203212013.GV4662@dread.disaster.area>
References: <20210128044154.806715-1-david@fromorbit.com>
 <20210201123943.GA3281245@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201123943.GA3281245@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=jEHcYJ-KuxDvHgv19YUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 01, 2021 at 12:39:43PM +0000, Christoph Hellwig wrote:
> On Thu, Jan 28, 2021 at 03:41:49PM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > Quick patch dump for y'all. A couple of minor cleanups to the
> > log behaviour, a fix for the CIL throttle hang and a couple of
> > patches to rework the cache flushing that journal IO does to reduce
> > the number of cache flushes by a couple of orders of magnitude.
> > 
> > All passes fstests with no regressions, no performance regressions
> > from fsmark, dbench and various fio workloads, some big gains even
> > on fast storage.
> 
> Can you elaborate on the big gains?

See the commit messages. dbench simulates fileserver behaviour with
extremely frequent fsync/->commit_metadata flush pointsi and that
shows gains at high client counts when logbsize=32k. fsmark is a
highly concurrent metadata modification worklaod designed to push
the journal to it's performance and scalability limits, etc, and
that shows 25% gains on logbsize=32k, bringing it up to the same
performance as logbsize=256k on the test machine.

> Workloads for one, but also
> what kind of storage.  For less FUA/flush to matter the device needs
> to have a write cache, which none of the really fast SSDs even has.

The gains are occurring on devices that have volatile caches. 
But that doesn't mean devices that have volatile caches are slow,
just that they can be faster with a better cache flushing strategy.

And yes, as you would expect, I don't see any change in behaviour on
data center SSDs that have no volatile caches because the block
layer elides cache flushes for them anyway.

But, really, device performance improvements really aren't the
motivation for this. The real motivation is removing orders of
magnitude of flush points from the software layers below the
filesystem. Stuff like software RAID, thin provisioning and other
functionality that must obey the flush/fua IOs they receive
regardless of whether the underlying hardware needs them or not.

Avoiding flush/fua for the journal IO means that RAID5/6 can cache
partial stripe writes from the XFS journal rather than having to
flush the partial stripe update for every journal IO. dm-thin
doesn't need to commit open transactions and flush all the dirty
data over newly allocated regions on every journal IO to a device
pool (i.e. cache flushes from one thinp device in a pool cause all
other thinp devices in the pool to stall new allocations until the
flush/fua is done). And so on.

There's no question at all that reducing the number of flush/fua
triggers is a good thing to be doing, regardless of the storage or
workloads that I've done validation testing on. The fact I've found
that on a decent performance SSD (120k randr IOPS, 60k randw IOPS)
shows a 25% increase in performance for journal IO bound workload
indicates just how much default configurations can be bound by the
journal cache flushes...

> So I'd only really expect gains from that on consumer grade SSDs and
> hard drives.

Sure, but those are exactly the devices we have always optimised
cache flushing for....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

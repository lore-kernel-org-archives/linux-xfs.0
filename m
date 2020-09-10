Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B8CC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 21:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1745221E2
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 21:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgIJV3m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 17:29:42 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60146 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728252AbgIJV3f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 17:29:35 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1E9773A89CE;
        Fri, 11 Sep 2020 07:29:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kGU8F-0005O7-St; Fri, 11 Sep 2020 07:29:27 +1000
Date:   Fri, 11 Sep 2020 07:29:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: EFI recovery needs it's own transaction
 reservation
Message-ID: <20200910212927.GT12131@dread.disaster.area>
References: <20200909081912.1185392-1-david@fromorbit.com>
 <20200909081912.1185392-2-david@fromorbit.com>
 <20200909133111.GA765129@bfoster>
 <20200909214455.GQ12131@dread.disaster.area>
 <20200910131810.GA1143857@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910131810.GA1143857@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=KcmsTjQD c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=7-415B0cAAAA:8
        a=jrPp3eU74khXgmsAEQ8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 10, 2020 at 09:18:10AM -0400, Brian Foster wrote:
> On Thu, Sep 10, 2020 at 07:44:55AM +1000, Dave Chinner wrote:
> > On Wed, Sep 09, 2020 at 09:31:11AM -0400, Brian Foster wrote:
> > > It looks like extents are only freed when the last
> > > reference is dropped (otherwise we log a refcount intent), which makes
> > > me wonder whether we really need 7 log count units if recovery
> > > encounters an EFI.
> > 
> > I don't know if the numbers are correct, and it really is out of
> > scope for this patch to audit/fix that. I really think we need to
> > map this whole thing out in a diagram at this point because I now
> > suspect that the allocfree log count calculation is not correct,
> > either...
> 
> I agree up to the point where it relates to this specific EFI recovery
> issue. reflink is enabled by default, which means the default EFI
> recovery reservation is going to have 7 logcount units. Is that actually
> enough of a reduction to prevent this same recovery problem on newer
> fs'? I'm wondering if the tr_efi logcount should just be set to 1, for
> example, at least for the short term fix.

I spent yesterday mapping out the whole "free extent" chain to
understand exactly what was necessary, and in discussing this with
Darrick on #xfs I came to the conclusion that we cannot -ever- have
a logcount of more than 1 for an intent recovery of any sort.

That's because the transaction may have rolled enough times to
exhaust the initial grant of unit * logcount, so the only
reservation that the runtime kernel has when it crashs is a single
transaction unit reservation (which gets re-reserved on every roll).

Hence recovery cannot assume that intent that was being processed has more
than a single unit reservation of log space available to be used,
and hence all intent recovery reservations must start with a log
count of 1.

THere are other restrictions we need to deal with, too. multiple
intents may pin the tail of the log, so we can't just process a
single intent chain at a time as that will result in using all the
log space for a single intent chain and reservation deadlocking on
one of the intents we haven't yet started.

Hence the first thing we have to do in recovering intents is take an
active reservation for -all- intents in the log to match the
reservation state at runtime. Only then can we guarantee that
intents that pin the tail of the log will have the reservation space
needed to be able to unpin the log tail.

Further, because we now may have consumed all the available log
reservation space to guarantee forwards progress, the first commit
of the first intent may block trying to regrant space if another
intent also pins the tail of the log. This means we cannot replay
intents in a serial manner as we currently do. Each intent chain and it's
transaction context needs to run in it's own process context so it
can block waiting for other intents to make progress, just like
happens at runtime when the system crashed. IOWs, intent replay
needs to be done with a task context per intent chain (probably via
a workqueue).

AFAICT, this is the only way we can make intent recovery deadlock
free - we have to recreate the complete log reservation state in
memory before we start recovery of a single intent, we can only
assume an intent had a single unit reservation of log space assigned
to it, and intent chain execution needs to run concurrently so
commits can block waiting for log space to become available as other
intents commit and unpin the tail of the log...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

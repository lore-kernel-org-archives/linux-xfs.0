Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878B5C47404
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 02:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FC9A206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 02:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbfJHCwD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 22:52:03 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48466 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729536AbfJHCwC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Oct 2019 22:52:02 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0914743E9C5;
        Tue,  8 Oct 2019 13:51:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iHfbR-0003XR-O6; Tue, 08 Oct 2019 13:51:57 +1100
Date:   Tue, 8 Oct 2019 13:51:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Throttle commits on delayed background CIL push
Message-ID: <20191008025157.GE16973@dread.disaster.area>
References: <20190930170358.GD57295@bfoster>
 <20190930215336.GR16973@dread.disaster.area>
 <20191001034207.GS16973@dread.disaster.area>
 <20191001131336.GB62428@bfoster>
 <20191001231433.GU16973@dread.disaster.area>
 <20191002124139.GB2403@bfoster>
 <20191003012556.GW16973@dread.disaster.area>
 <20191003144114.GB2105@bfoster>
 <20191004022755.GY16973@dread.disaster.area>
 <20191004115001.GA6706@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004115001.GA6706@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=AIS7f8n3jaqniZSltz8A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 04, 2019 at 07:50:01AM -0400, Brian Foster wrote:
> On Fri, Oct 04, 2019 at 12:27:55PM +1000, Dave Chinner wrote:
> > On Thu, Oct 03, 2019 at 10:41:14AM -0400, Brian Foster wrote:
> > > Hmm, I'm also not sure the lockless reservation algorithm is totally
> > > immune to increased concurrency in this regard. What prevents multiple
> > > tasks from racing through xlog_grant_head_check() and blowing past the
> > > log head, for example?
> > 
> > Nothing. Debug kernels even emit a "xlog_verify_grant_tail: space >
> > BBTOB(tail_blocks)" messages when that happens. It's pretty
> > difficult to do this in real world conditions, even when there is
> > lots of concurrency being used.
> > 
> 
> Hm, Ok. Though I've seen that alert enough times that I
> (unintentionally) ignore it at this point, so it can't be that hard to
> reproduce. ;) That is usually during fstests however, and not a typical
> workload that I recall.

I can't say I've seen it for a long time now - I want to say "years"
but I may well have simply missed it on the rare occasion it has
occurred and fstests hasn't captured it. i.e. fstests is supposed to
capture unusual things like this appearing in dmesg during a
test....

> Of course, there's a difference between
> reproducing the basic condition and taking it to the point where it
> manifests into a problem.

*nod*

> > But here's the rub: it's not actually the end of the world because
> > the reservation doesn't actually determine how much of the log is
> > currently being used by running transactions - the reservation is
> > for a maximal rolling iteration of a permanent transaction, not the
> > initial transaction will be running. Hence if we overrun
> > occassionally we don't immediately run out of log space and corrupt
> > the log.
> > 
> 
> Ok, that much is evident from the amount of time this mechanism has been
> in place without any notable issues.
> 
> > Yes, if none of the rolling transactions complete and they all need
> > to use their entire reservation, and the tail of the log cannot be
> > moved forward because it is pinned by one of the transactions that
> > is running, then we'll likely get a log hang on a regrant on the
> > write head. But if any of the transactions don't use all of their
> > reservation, then the overrun gets soaked up by the unused parts of
> > the transactions that are completed and returned to reservation
> > head, and nobody even notices taht there was a temporary overrun of
> > the grant head space.
> > 
> 
> Ok, I didn't expect this to be some catastrophic problem or really a
> problem with your patch simply based on the lifetime of the code and how
> the grant heads are actually used. I was going to suggest an assert or
> something to detect whether batching behavior as a side effect of the
> commit throttle would ever increase likelihood of this situation, but it
> looks like the grant verify function somewhat serves that purpose
> already.

Yeah - xlog_verify_grant_tail() will the report reservation
overruns, but the serious log space problems (i.e. head overwritting
the tail) are detected by xlog_verify_tail_lsn() when we stamp the
tail_lsn into the current iclog header. That's still done under the
icloglock and the AIL lock, so the comparison of the tail with the
current log head is still completely serialised.

> I'd _prefer_ to see something, at least in DEBUG mode, that indicates
> the frequency of the fundamental incorrect accounting condition as
> opposed to just the side effect of blowing the tail (because the latter
> depends on other difficult to reproduce factors), but I'd have to think
> about that some more as it would need to balance against normal/expected
> execution flow. Thanks for the background.

You can test that just by removing the XLOG_TAIL_WARN flag setting,
then it will warn on every reservation overrun rather than just the
first.

> > Hence occasional overruns on the reservation head before they start
> > blocking isn't really a problem in practice because the probability
> > of all the transaction reservation of all transactions running being
> > required to make forwards progress is extremely small.
> > 
> > Basically, we gave up "perfect reservation space grant accounting"
> > because performance was extremely important and risk of log hangs as
> > a result of overruns was considered to be extremely low and worth
> > taking for the benefits the algorithm provided. This was just a
> > simple, pragmatic risk based engineering decision.
> > 
> 
> FWIW, the comment for xlog_verify_tail() also suggests the potential for
> false positives and references a panic tag, which all seems kind of
> erratic and misleading compared to what you explain here.

Well, it's fundamentally an unserialised check, so it can race with
other reservation grants, commits that release grant space and tail
lsn updates. Hence it's not a 100% reliable debug check.

It also used to be run at all times, not just under
XFS_CONFIG_DEBUG=y, which is why it has a panic tag associated with
it. When we first deployed it, we weren't 100% sure there weren't
customer workloads that would trip over this and hang the log, so
we gave ourselves a way of triggering kernel dumps the instant an
overrun was detected. Hence a site that had log hangs with this
message in the logs could turn on the panic tag and we'd get a
kernel dump to analyse...

Since then, this code has been relegated to debug code but the panic
tag still exists. It could be turned back into a ASSERT now, but
it's still useful the way it is as it means debug kernels don't fall
over the moment a spurious overrun occurs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

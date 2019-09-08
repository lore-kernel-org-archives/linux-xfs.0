Return-Path: <SRS0=tqf+=XD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDD7C433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Sep 2019 23:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F59F20863
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Sep 2019 23:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbfIHX0i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Sep 2019 19:26:38 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39144 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731040AbfIHX0i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Sep 2019 19:26:38 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6C96D361247;
        Mon,  9 Sep 2019 09:26:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i76Zl-0005ba-0U; Mon, 09 Sep 2019 09:26:33 +1000
Date:   Mon, 9 Sep 2019 09:26:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: push the grant head when the log head moves
 forward
Message-ID: <20190908232632.GD16973@dread.disaster.area>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-8-david@fromorbit.com>
 <20190904193442.GA52970@bfoster>
 <20190904225056.GL1119@dread.disaster.area>
 <20190905162533.GA59149@bfoster>
 <20190906000205.GL1119@dread.disaster.area>
 <20190906131014.GA62719@bfoster>
 <20190907151050.GA3967@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907151050.GA3967@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=WdABKkqc7BbLPFh4LKUA:9 a=F-NADfSBwvrpKSFP:21
        a=BK31MCtrsgmRJlpK:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 07, 2019 at 11:10:50AM -0400, Brian Foster wrote:
> On Fri, Sep 06, 2019 at 09:10:14AM -0400, Brian Foster wrote:
> > On Fri, Sep 06, 2019 at 10:02:05AM +1000, Dave Chinner wrote:
> > > > And the raciness concerns..? AFAICT this still opens a race window where
> > > > the AIL can idle on the push target before AIL insertion.
> > > 
> > > I don't know what race you see - if the AIL completes a push before
> > > we insert new objects at the head from the current commit, then it
> > > does not matter one bit because the items are being inserted at the
> > > log head, not the log tail where the pushing occurs at. If we are
> > > inserting objects into the AIL within the push target window, then
> > > there is something else very wrong going on, because when the log is
> > > out of space the push target should be nowhere near the LSN we are
> > > inserting inew objects into the AIL at. (i.e. they should be 3/4s of
> > > the log apart...)
> > > 
> > 
> > I'm not following your reasoning. It sounds to me that you're arguing it
> > doesn't matter that the AIL is not populated from the current commit
> > because the push target should be much farther behind the head. If
> > that's the case, why does this patch order the AIL push after a
> > ->l_last_sync_lsn update? That's the LSN of the most recent commit
> > record to hit the log and hence the new physical log head.
> > 
> > Side note: I think the LSN of the commit record iclog is different and
> > actually ahead of the LSN associated with AIL insertion. I don't
> > necessarily think that's a problem given how the log subsystem behaves
> > today, but it's another subtle/undocumented (and easily avoidable) quirk
> > that may not always be so benign.
> > 
> 
> Just to put a finer point on this (and since this seems to be the only
> way I can get you to consider nontrivial feedback to your patches):

If I can't make head or tail of the problem you are describing,
exactly how am I supposed to respond? If I'm unable to get my point
across, I'd much prefer to spend my time on patches than on going
around in circles. I'm not interested in winning arguments. I'm not
interested in spending lots of time discussing theoretical problems
with the current set of fixes that don't exist once the root cause
we've already identified is fixed. My time is much better spent
fixing that root cause...

Keep in mind that I also have a lot of different, complex  things
going on at once that all require total focus while I'm looking at
them, so it can take days for me to cycle through everything and get
back to past topics. Delay doesn't mean I haven't read your response
or taken it on board, it just means I don't have time to write a
-meaingful response- straight away.

> kworker/0:1H-220   [000] ...1  3869.403829: xlog_state_do_callback: 2691: l_last_sync_lsn 0x15000021f6
> kworker/0:1H-220   [000] ...1  3869.403864: xfs_ail_push: 639: ail_target 0x15000021f6

Which implies that the log has less than 25% of space free because
we've issued a push, and that the distance we push is bound by the
log head.

>       <...>-215246 [002] ...1  3875.568561: xfsaild: 403: empty (target 0x15000021f6)
>       <...>-215246 [002] ....  3875.568649: xfsaild: 589: idle

has an empty AIL. IOWs, you are creating the situation where the CIL
has not been allowed to run and hence has violated the >50% log size
limit on transactions. This goes away once we prevent the CIL from
doing this.

> kworker/0:1H-220   [000] ...1  3889.843872: xfs_trans_ail_update_bulk: 746: inserted lsn 0x1500001bf6

Ok, so what you see here is somewhat intentional, based on the fact
that the LSN used for items is different to the LSN used for the
commit record (start of commit vs end of commit).  We don't want to
push the currently commiting items instantly to disk as that defeats
the "delayed write" behaviour the AIL uses to allow efficient
relogging to occur.

The next commit will do a similar push during with the new
l_last_sync_lsn, which causes the target to point at the new
last_sync_lsn and so all the items in the AIL from the previous
commit that haven't been relogged (pinned) in the current commit
will get pushed. i.e. commit N will cause commit (N - 1) to get
pushed.

This will continue while we are in a situation where the current log
head location is limiting the push target and we are completely out
of log reservation space. Once we get to the point where the
physical head of the log is more than 25% of the log away from the
tail, the push target will stop being limited by the l_last_sync_lsn
and we'll go back to triggering push target updates via the tail of
the log moving forwards as we currently do.  IOWs, this "log head
pushing" behaviour is likely only necessary for the first 2-3 CIL
commits of a workload, then we fall back into the normal tail
pushing scenario.

> This is an instance of xfsaild going idle between the time this
> new AIL push sets the target based on the iclog about to be
> committed and AIL insertion of the associated log items,
> reproduced via a bit of timing instrumentation.  Don't be
> distracted by the timestamps or the fact that the LSNs do not
> match because the log items in the AIL end up indexed by the start
> lsn of the CIL checkpoint (whereas last_sync_lsn refers to the
> commit record). The point is simply that xfsaild has completed a
> push of a target that hasn't been inserted yet.

AFAICT, what you are showing requires delaying of the CIL push to the
point it violates a fundamental assumption about commit sizes, which
is why I largely think it's irrelevant.

> A couple additional notes.. I don't see further side effects in the
> variant I reproduced, I suspect because we have other wakeups that
> squash this transient state created by the race,

Right, if we do run out of log space, the log reservation tail
pushing mechanisms takes over and does the right thing.

> > > i.e. we changed the unlinked inode processing in a way that
> > > the kernel can now runs tens of thousands of unlink transactions
> > > without yeilding the CPU. That violated the "CIL push work will run
> > > within a few transactions of the background push occurring"
> > > mechanism the workqueue provided us with and that, fundamentally, is
> > > the underlying issue here. It's not a CIL vs empty AIL vs log
> > > reservation exhaustion race condition - that's just an observable
> > > symptom.
> > > 
> > 
> > Yes, but the point is that's not the only thing that can delay CIL push
> > work. Since the AIL is not populated until the commit record iclog is
> > written out, and background CIL pushing doesn't flush the commit record
> > for the associated checkpoint before it completes, and CIL pushing
> > itself is serialized, a stalled commit record iclog I/O is enough to
> > create "log full, empty AIL" conditions.

CIL pushing is not actually serialised. Ordered, yes, serialised,
no. ANd stalling an iclog with a commit record should not cause the
log to fill completely - the next CIL push when it overflows should
get it moving long before the log runs out of reservation space.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

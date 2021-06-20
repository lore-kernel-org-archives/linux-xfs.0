Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12455C48BDF
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Jun 2021 22:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D76256113E
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Jun 2021 22:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhFTWU3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Jun 2021 18:20:29 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:46149 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229875AbhFTWU2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Jun 2021 18:20:28 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 39E6B10943C;
        Mon, 21 Jun 2021 08:18:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lv5lV-00F5xY-QB; Mon, 21 Jun 2021 08:18:05 +1000
Date:   Mon, 21 Jun 2021 08:18:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/8 V2] xfs: log fixes for for-next
Message-ID: <20210620221805.GO664593@dread.disaster.area>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210618224830.GM664593@dread.disaster.area>
 <20210619202249.GG158209@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210619202249.GG158209@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=avvniB5OxZPL_bNl2GsA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 19, 2021 at 01:22:49PM -0700, Darrick J. Wong wrote:
> On Sat, Jun 19, 2021 at 08:48:30AM +1000, Dave Chinner wrote:
> > On Thu, Jun 17, 2021 at 06:26:09PM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > This is followup from the first set of log fixes for for-next that
> > > were posted here:
> > > 
> > > https://lore.kernel.org/linux-xfs/20210615175719.GD158209@locust/T/#mde2cf0bb7d2ac369815a7e9371f0303efc89f51b
> > > 
> > > The first two patches of this series are updates for those patches,
> > > change log below. The rest is the fix for the bigger issue we
> > > uncovered in investigating the generic/019 failures, being that
> > > we're triggering a zero-day bug in the way log recovery assigns LSNs
> > > to checkpoints.
> > > 
> > > The "simple" fix of using the same ordering code as the commit
> > > record for the start records in the CIL push turned into a lot of
> > > patches once I started cleaning it up, separating out all the
> > > different bits and finally realising all the things I needed to
> > > change to avoid unintentional logic/behavioural changes. Hence
> > > there's some code movement, some factoring, API changes to
> > > xlog_write(), changing where we attach callbacks to commit iclogs so
> > > they remain correctly ordered if there are multiple commit records
> > > in the one iclog and then, finally, strictly ordering the start
> > > records....
> > > 
> > > The original "simple fix" I tested last night ran almost a thousand
> > > cycles of generic/019 without a log hang or recovery failure of any
> > > kind. The refactored patchset has run a couple hundred cycles of
> > > g/019 and g/475 over the last few hours without a failure, so I'm
> > > posting this so we can get a review iteration done while I sleep so
> > > we can - hopefully - get this sorted out before the end of the week.
> > 
> > Update on this so people know what's happening.
> > 
> > Yesterday I found another zero-day bug in the CIL code that triggers
> > when a shutdown occurs.
> > 
> > The shutdown processing runs asynchronously and without caring about
> > the current state or users of the iclogs. SO when it runs
> > xlog_state_do_callbacks() after changing the state of all iclogs to
> > XLOG_STATE_IOERROR, it runs the callbacks on all the iclogs and
> > frees everything associated with them.
> > 
> > That includes the CIL context structure that xlog_cil_push_now() is
> > still working on because it has a referenced iclog that it hasn't
> > yet released.
> > 
> > Hence the initial CIL commit that stamps the CIL context with the
> > commit lsn -after- it has attached the context to the commit_iclog
> > callback list can race with shutdown. This results in a UAF
> > situation and an 8 byte memory corruption when we stamp the LSN into
> > the context.
> > 
> > The current for-next tree does *much more* with the context after
> > the callbacks are attached, which opens up this UAF to both reads
> > and writes of free memory. The fix in patch 2, which adds a sleep on
> > the previous iclog after attaching the callbacks to the commit iclog
> > opens this window even futher.
> > 
> > ANd then the start record ordering patch set moves the commit iclog
> > into CIL context structure which we dereference after waiting on the
> > previous iclog means we are dereferencing pointers freed memory.
> > 
> > So, basically, before any of these fixes can go forwards, I first
> > need to fix the pre-existing CIL push/shutdown race.
> > 
> > And then, after I've rebased all these fixes on that fix and we're
> > back to square one and before we do anything else in the log, we
> > need to fix the mess that is caused by unco-ordinated shutdown
> > changing iclog state and running completions while we still have
> > active references to the iclogs and are preparing the iclog for IO.
> > XLOG_STATE_IOERROR must be considered harmful at this point in time.
> 
> This puts me in a difficult spot.  We're past -rc6, which means that
> Linus could tag 5.13.0 tomorrow, and if he does that, whatever's in
> for-next needs to have had at least a few days to soak before Linus will
> want to pull it upstream.
> 
> Or this could be yet another one of those crazy kernels that goes all
> the way to -rc8, in which case there's still time to make small
> adjustments.  But who knows, I have no schedule visibility.
> 
> However, this doesn't sound like small adjustments.  I think it's best
> that I withdraw the CIL changes from for-next until we have more time to
> fix these issues and make sure that there aren't any bugs that are
> easily found by developers.  I feel confident enough about everything
> between "xfs: log stripe roundoff is a property of the log" and
> "xfs: xfs_log_force_lsn isn't passed a LSN" to keep them in for-next.

Yup, that's a fair call. I was going to ask you to do this anyway
this morning (Monday) because I haven't been able to come up with a
magic bullet that fixes everything and makes it all better over the
weekend.

I'll start a new branch that fixes the UAF bug and the start record
ordering, and then rebase the CIL/log scalability patchset on top of
that. I'll also pull Christoph's cleanups for the new xlog_write()
code on top of that, too.

Oh, well, good thing I hadn't deleted the merged branches yet....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

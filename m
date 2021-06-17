Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6803C2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 23:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADEDA6128B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 23:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhFQXpU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 19:45:20 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54859 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230447AbhFQXpT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 19:45:19 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9EE33863244;
        Fri, 18 Jun 2021 09:43:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lu1fA-00Dz6W-Sq; Fri, 18 Jun 2021 09:43:08 +1000
Date:   Fri, 18 Jun 2021 09:43:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/8 V2] xfs: log fixes for for-next
Message-ID: <20210617234308.GH664593@dread.disaster.area>
References: <20210617082617.971602-1-david@fromorbit.com>
 <YMuVPgmEjwaGTaFA@bfoster>
 <20210617190519.GV158209@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617190519.GV158209@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=IxN2oyIkH-iBE5SkDokA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 12:05:19PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 17, 2021 at 02:32:30PM -0400, Brian Foster wrote:
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
> > > 
> > 
> > My first spin of this included generic/019 and generic/475, ran for 18
> > or so iterations and 475 exploded with a stream of asserts followed by a
> > NULL pointer crash:
> > 
> > # grep -e Assertion -e BUG dmesg.out
> > ...
> > [ 7951.878058] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > [ 7952.261251] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > [ 7952.644444] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > [ 7953.027626] XFS: Assertion failed: atomic_read(&buip->bui_refcount) > 0, file: fs/xfs/xfs_bmap_item.c, line: 57
> > [ 7953.410804] BUG: kernel NULL pointer dereference, address: 000000000000031f
> > [ 7954.118973] BUG: unable to handle page fault for address: ffffa57ccf99fa98
> > 
> > I don't know if this is a regression, but I've not seen it before. I've
> > attempted to spin generic/475 since then to see if it reproduces again,
> > but so far I'm only running into some of the preexisting issues
> > associated with that test.

I've not seen anything like that. I can't see how the changes in the
patchset would affect BUI reference counting in any way. That seems
more like an underlying intent item shutdown reference count issue
to me (and we've had a *lot* of them in the past)....

> By any chance, do the two log recovery fixes I sent yesterday make those
> problems go away?
> 
> > I'll let it go a while more and probably
> > switch it back to running both sometime before the end of the day for an
> > overnight test.
> 
> Also, do the CIL livelocks go away if you apply only patches 1-2?
> 
> > A full copy of the assert and NULL pointer BUG splat is included below
> > for reference. It looks like the fault BUG splat ended up interspersed
> > or otherwise mangled, but I suspect that one is just fallout from the
> > immediately previous crash.
> 
> I have a question about the composition of this 8-patch series --
> which patches fix the new cil code, and which ones fix the out of order
> recovery problems?  I suspect that patches 1-2 are for the new CIL code,
> and 3-8 are to fix the recovery problems.

Yes. But don't think of 3-8 as fixing recovery problems - the are
fixing potential runtime data integrity issues (log force lsns for
fsync are based on start LSNs) and journal head->tail overwrite
issues (because AIL ordering is start LSN based).

So, basically, we get the reocvery fixes for free when we fix the
runtime start LSN ordering issues...

> Thinking with my distro kernel not-maintainer hat on, I'm considering
> how to backport whatever fixes emerge for the recovery ordering issue
> into existing kernels.  The way I see things right now, the CIL changes
> (+ fixes) and the ordering bug fixes are separate issues.  The log
> ordering problems should get fixed as soon as we have a practical
> solution; the CIL changes could get deferred if need be since it's a
> medium-high risk; and the real question is how to sequence all this?

The CIL changes in patches 1-2 are low risk - that's just a hang
because of a logic error and we fix that sort of thing all the time

> (Or to put it another way: I'm still stuck going "oh wowwww this is a
> lot more change" while trying to understand patch 4)

It's not unreasonable given the amount of change that was made in
the first place. Really, though, once you take the tracing and code
movement out of it, the actual logic change is much, much smaller...

/me wonders if anyone remembers that I said up front that I
considered the changes to the log code completely unreviewable and
that there would be bugs that slip through both my testing and
review?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

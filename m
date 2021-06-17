Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72FEC48BE5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 01:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADE2E613E1
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 01:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhFQBaO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 21:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231942AbhFQBaO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 21:30:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CC13613DE;
        Thu, 17 Jun 2021 01:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623893287;
        bh=C/vXiM5mV25q05CDSSuFHiPOSj/ZYDc4+8FiWYnTQmY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YXBxabqceEzd8X+c/i546AhOOGA/mvxbTP4tMrU6+kOe1hqrl7BqJSykIQOL0fmhS
         G+R5dov0J9BCO1LWBOVkuUpr1XsFDdMuFGOpKJYlr10KNTAwfEEkIJKQudcfdJ0SGb
         +8uFA8+LEkDjcC/uIKWPq8NBy6xP2avP4oa+tE6ec8LrBtff5FCx/FqDA10xnK7dIM
         s2fvgJjSFwzJi7pBhuPESbjLzGgh/OWXY8GdvdmYiDaSE932q4V8GmNEmpEn7GPczK
         zf0DuhpCrPd4SbQpux+icMoWT0HFmloxEDobgFbERzBb2ZKlHswyzJEcB/wnVep5y1
         A6dklkjzXpMiQ==
Date:   Wed, 16 Jun 2021 18:28:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [BUG] generic/475 recovery failure(s)
Message-ID: <20210617012807.GL158209@locust>
References: <YMIsWJ0Cb2ot/UjG@bfoster>
 <YMOzT1goreWVgo8S@bfoster>
 <20210611223332.GS664593@dread.disaster.area>
 <20210616070542.GY664593@dread.disaster.area>
 <YMpgFmEzjpWnmZ66@bfoster>
 <20210616210500.GF158209@locust>
 <20210616225407.GA664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616225407.GA664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 08:54:07AM +1000, Dave Chinner wrote:
> On Wed, Jun 16, 2021 at 02:05:00PM -0700, Darrick J. Wong wrote:
> > On Wed, Jun 16, 2021 at 04:33:26PM -0400, Brian Foster wrote:
> > > On Wed, Jun 16, 2021 at 05:05:42PM +1000, Dave Chinner wrote:
> > > > Ok, time to step back and think about this for a bit. The good news
> > > > is that this can only happen with pipelined CIL commits, while means
> > > > allowing more than one CIL push to be in progress at once. We can
> > > > avoid this whole problem simply by setting the CIL workqueue back to
> > > > running just a single ordered work at a time. Call that Plan B.
> > > > 
> > > > The bad news is that this is zero day bug, so all kernels out there
> > > > will fail to recovery with out of order start records. Back before
> > > > delayed logging, we could have mulitple transactions commit to the
> > > > journal in just about any order and nesting, and they used exactly
> > > > the same start/commit ordering in recovery that is causing us
> > > > problems now. This wouldn't have been noticed, however, because
> > > > transactions were tiny back then, not huge checkpoints like we run
> > > > now. And if is was, it likely would have been blamed on broken
> > > > storage because it's so ephemeral and there was little test
> > > > infrastructure that exercised these paths... :/
> > 
> > It's a zero day bug, but at least nobody tripped over this until two
> > months ago.  I've been dealing on and off with customer escalations
> > involving a filesystem with large reflinked images that goes down, and
> > then some time after the recovery (minutes to weeks) they hit a
> > corruption goto and crash again.  I've been able to pin down the
> > symptoms to ... the "corrupt" refcount btree block containing partial
> > old contents, where the old contents are always aligned to 128 byte
> > boundaries, and when Dave mentioned this last night I realized that he
> > and I might have fallen into the same thing.
> 
> I have my suspicions that this has been causing issues for a long
> time, but it's been so rare that it's been impossible to reproduce
> and hence capture the information needed to debug it. This time,
> however, the failure triggered an assert before recovery completed
> and so left the filesystem in the state where I could repeat log
> recovery and have it fail with the same ASSERT fail over and over
> again.
> 
> <meme> A few hours later.... </meme>
> 
> > > > What this means is that we can't just make a fix to log recovery
> > > > because taking a log from a current kernel and replaying it on an
> > > > older kernel might still go very wrong, and do so silently. So I
> > > > think we have to fix what we write to the log.
> > > > 
> > > > Hence I think the only way forward here is to recognise that the
> > > > AIL, log forces and log recovery all require strictly ordered
> > > > checkpoint start records (and hence LSNs) as well as commit records.
> > > > We already strictly order the commit records (and this analysis
> > > > proves it is working correctly), so we should be able to leverage
> > > > the existing functionality to do this.
> > > > 
> > > 
> > > Ok. I still need to poke at the code and think about this, but what you
> > > describe here all makes sense. I wonder a bit if we have the option to
> > > fix recovery via some kind of backwards incompatibility, but that
> > > requires more thought (didn't we implement or at least consider
> > > something like a transient feature bit state some time reasonably
> > > recently? I thought we did but I can't quite put my finger on what it
> > > was for or if it landed upstream.).
> > 
> > We did -- it was (is) a patchset to turn on log incompat feature bits in
> > the superblock, and clear them later on when they're not in use and the
> > log is being cleaned.  I proposed doing that for atomic file content
> > swapping, and Allison's deferred xattrs patchset will want the same to
> > protect xattr log intent items.
> > 
> > > That train of thought aside, ordering start records a la traditional
> > > commit record ordering seems like a sane option. I am starting to think
> > > that your plan B might actually be a wise plan A, though. I already
> > > wished we weren't pushing so much log rewrite/rework through all in one
> > > cycle. Now it sounds like we require even more significant (in
> > > complexity, if not code churn, as I don't yet have a picture of what
> > > "start record ordering" looks like) functional changes to make an
> > > otherwise isolated change safe. Just my .02.
> > 
> > /me guesses that we should go with plan B for 5.14, and work on fixing
> > whatever's wrong for 5.15.  But since it's never possible to tell how
> > much time is left until the merge window opens, I'll keep an open
> > mind...
> 
> The simple fix appears to have worked. That was just applying the
> same write ordering code the commit records use to the start record
> write.
> 
> The series of fixes I have now has run about a thousand cycles of
> g/019 without a log hang or a log recovery failure, so I think I've
> got viable fixes for the issues g/019 has exposed. I also suspect
> that this start record ordering issue is what g/475 was tripping
> over, too.

Hooray!

> Given that we still have a couple of months before this will be
> released to users, I'd much prefer that we move forwards with
> testing the fixes because there is a suspicion and anecdotal
> evidence that this problem has been affecting users for a long time
> regardless of the recent changes that have brought it out into the
> daylight.
> 
> I'm about to split up the fix into smaller chunks and then I'll post
> the series for review.

Ok, looking forward to it.  Given the recent rash of log related bugs, I
think I'm going to defer review of all new code patchsets (hch's log
cleanup, deferred inactivation) for 5.15 to prioritize making the
problems go away.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

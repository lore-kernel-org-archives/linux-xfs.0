Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF28C2B9F4
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Jun 2021 20:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EACD611AC
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Jun 2021 20:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhFSUZB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Jun 2021 16:25:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhFSUZB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 19 Jun 2021 16:25:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E296A610C7;
        Sat, 19 Jun 2021 20:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624134170;
        bh=6r5qVptBYT5d3qOYhtem7RdXj1RjMwtehbVtLOdB4GI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UIURvHYxQRcf+5LvbBrWes0E2vQf+UuPM7hDOYga6uu7baxVq+j8uxCAcJBA6pjto
         U/4oN4znmC1OfG+2oiPqQ9I680jhF1VPnKN6Ii6lIJKVvRhPwlzDhfo/V5ksT32lBo
         FQ1Fwisafw8JMa+srwB34j63kr/I6ZeAjiteryJLvNE6fMNUiiINv9GgZFAlreQig9
         fiY1Q0uJpxFNtK6BTjJ2alzYi8P9hFWTUXG2+Uw8HK0tNaitUjfy7Gg1LbCYQERrWo
         obiw7FWXFty8uhlHWDyT+WqxmyaFnuMi/nVlYo18L2vEuMbP5kk5qFseT5Fv9sBC1j
         bc6VTML8w0VKQ==
Date:   Sat, 19 Jun 2021 13:22:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/8 V2] xfs: log fixes for for-next
Message-ID: <20210619202249.GG158209@locust>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210618224830.GM664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618224830.GM664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 19, 2021 at 08:48:30AM +1000, Dave Chinner wrote:
> On Thu, Jun 17, 2021 at 06:26:09PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > This is followup from the first set of log fixes for for-next that
> > were posted here:
> > 
> > https://lore.kernel.org/linux-xfs/20210615175719.GD158209@locust/T/#mde2cf0bb7d2ac369815a7e9371f0303efc89f51b
> > 
> > The first two patches of this series are updates for those patches,
> > change log below. The rest is the fix for the bigger issue we
> > uncovered in investigating the generic/019 failures, being that
> > we're triggering a zero-day bug in the way log recovery assigns LSNs
> > to checkpoints.
> > 
> > The "simple" fix of using the same ordering code as the commit
> > record for the start records in the CIL push turned into a lot of
> > patches once I started cleaning it up, separating out all the
> > different bits and finally realising all the things I needed to
> > change to avoid unintentional logic/behavioural changes. Hence
> > there's some code movement, some factoring, API changes to
> > xlog_write(), changing where we attach callbacks to commit iclogs so
> > they remain correctly ordered if there are multiple commit records
> > in the one iclog and then, finally, strictly ordering the start
> > records....
> > 
> > The original "simple fix" I tested last night ran almost a thousand
> > cycles of generic/019 without a log hang or recovery failure of any
> > kind. The refactored patchset has run a couple hundred cycles of
> > g/019 and g/475 over the last few hours without a failure, so I'm
> > posting this so we can get a review iteration done while I sleep so
> > we can - hopefully - get this sorted out before the end of the week.
> 
> Update on this so people know what's happening.
> 
> Yesterday I found another zero-day bug in the CIL code that triggers
> when a shutdown occurs.
> 
> The shutdown processing runs asynchronously and without caring about
> the current state or users of the iclogs. SO when it runs
> xlog_state_do_callbacks() after changing the state of all iclogs to
> XLOG_STATE_IOERROR, it runs the callbacks on all the iclogs and
> frees everything associated with them.
> 
> That includes the CIL context structure that xlog_cil_push_now() is
> still working on because it has a referenced iclog that it hasn't
> yet released.
> 
> Hence the initial CIL commit that stamps the CIL context with the
> commit lsn -after- it has attached the context to the commit_iclog
> callback list can race with shutdown. This results in a UAF
> situation and an 8 byte memory corruption when we stamp the LSN into
> the context.
> 
> The current for-next tree does *much more* with the context after
> the callbacks are attached, which opens up this UAF to both reads
> and writes of free memory. The fix in patch 2, which adds a sleep on
> the previous iclog after attaching the callbacks to the commit iclog
> opens this window even futher.
> 
> ANd then the start record ordering patch set moves the commit iclog
> into CIL context structure which we dereference after waiting on the
> previous iclog means we are dereferencing pointers freed memory.
> 
> So, basically, before any of these fixes can go forwards, I first
> need to fix the pre-existing CIL push/shutdown race.
> 
> And then, after I've rebased all these fixes on that fix and we're
> back to square one and before we do anything else in the log, we
> need to fix the mess that is caused by unco-ordinated shutdown
> changing iclog state and running completions while we still have
> active references to the iclogs and are preparing the iclog for IO.
> XLOG_STATE_IOERROR must be considered harmful at this point in time.

This puts me in a difficult spot.  We're past -rc6, which means that
Linus could tag 5.13.0 tomorrow, and if he does that, whatever's in
for-next needs to have had at least a few days to soak before Linus will
want to pull it upstream.

Or this could be yet another one of those crazy kernels that goes all
the way to -rc8, in which case there's still time to make small
adjustments.  But who knows, I have no schedule visibility.

However, this doesn't sound like small adjustments.  I think it's best
that I withdraw the CIL changes from for-next until we have more time to
fix these issues and make sure that there aren't any bugs that are
easily found by developers.  I feel confident enough about everything
between "xfs: log stripe roundoff is a property of the log" and
"xfs: xfs_log_force_lsn isn't passed a LSN" to keep them in for-next.

I'll also throw in the random fixes that got reviewed this week.

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

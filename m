Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5211BC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 09:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345414AbiE0JMz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 05:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349938AbiE0JMO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 05:12:14 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 08DFA13C4E1;
        Fri, 27 May 2022 02:08:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4E621534581;
        Fri, 27 May 2022 19:08:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nuVxW-00Gxti-5K; Fri, 27 May 2022 19:08:38 +1000
Date:   Fri, 27 May 2022 19:08:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
Message-ID: <20220527090838.GD3923443@dread.disaster.area>
References: <20220525111715.2769700-1-amir73il@gmail.com>
 <YpBqfdmwQ675m72G@infradead.org>
 <CAOQ4uxjek9331geZGVbVT=gqkNTyVA_vjyjuB=2eGZD-ufeqNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjek9331geZGVbVT=gqkNTyVA_vjyjuB=2eGZD-ufeqNQ@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62909517
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=lqPp78sISulBoH7tflwA:9
        a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 27, 2022 at 10:01:48AM +0300, Amir Goldstein wrote:
> On Fri, May 27, 2022 at 9:06 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > FYI, below is the 5.10-stable backport I have been testing earlier this
> > week that fixes a bugzilla reported hang:
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=214767
> >
> > I was just going to submit it to the stable maintaines today after
> > beeing out of the holiday, but if you want to add it to this queue
> > that is fine with me as well.
> >
> 
> Let me take it for a short spin in out xfs stable test environment, since
> this env has caught one regression with an allegedly safe fix.
> This env has also VMs with old xfsprogs, which is kind of important to
> test since those LTS patches may end up in distros with old xfsprogs.
> 
> If all is well, I'll send your patch later today to stable maintainers
> with this first for-5.10 series.
> 
> > ---
> > From 8e0464752b24f2b3919e8e92298759d116b283eb Mon Sep 17 00:00:00 2001
> > From: Dave Chinner <dchinner@redhat.com>
> > Date: Fri, 18 Jun 2021 08:21:51 -0700
> > Subject: xfs: Fix CIL throttle hang when CIL space used going backwards
> >
> 
> Damn! this patch slipped through my process (even though I did see
> the correspondence on the list).
> 
> My (human) process has eliminated the entire 38 patch series
> https://lore.kernel.org/linux-xfs/20210603052240.171998-1-david@fromorbit.com/
> without noticing the fix that was inside it.

The first two times it was in much smaller patch series (5 and 8
patches total).


Also, you probably need to search for commit IDs on the list, too,
because this discussion was held in November about backporting the
fix to 5.10 stable kernels:

Subject: Help deciding about backported patch (kernel bug 214767, 19f4e7cc8197 xfs: Fix CIL throttle hang when CIL space used going backwards)
https://lore.kernel.org/linux-xfs/C1EC87A2-15B4-45B1-ACE2-F225E9E30DA9@flyingcircus.io/

> In this case, I guess Dave was not aware of the severity of the bug fixed

I was very aware of the severity of the problem, and I don't need
anyone trying to tell me what I should have been doing 18 months
ago.

It simply wasn't a severe bug. We had one user reporting it, and the
when I found the bug I realised that it was a zero-day thinko in
delayed logging accounting I made back in 2010 (~2.6.38 timeframe,
IIRC).  IOWs, it took 10 years before we got the first indication
there was a deep, dark corner case bug lurking in that code.

The time between first post of the bug fix and merge was about 6
months, so it also wasn't considered serious by anyone at the time
as it missed 2 whole kernel releases before it was reviewed and
merged...

There's been a small handful of user reports of this bug since (e.g
the bz above and the backport discussions), but it's pretty clear
that this bug is not (and never has been) a widespread issue.  It
just doesn't fit any of the criteria for a severe bug.

Backport candidate: yes. Severe: absolutely not.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

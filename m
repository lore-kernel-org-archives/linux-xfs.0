Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF201C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 04:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239872AbiFAEbI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 00:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbiFAEbH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 00:31:07 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B051D9EB48;
        Tue, 31 May 2022 21:31:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 266FA5EC373;
        Wed,  1 Jun 2022 14:31:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nwG0a-001Gb3-Qu; Wed, 01 Jun 2022 14:31:00 +1000
Date:   Wed, 1 Jun 2022 14:31:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
Message-ID: <20220601043100.GD227878@dread.disaster.area>
References: <20220525111715.2769700-1-amir73il@gmail.com>
 <YpBqfdmwQ675m72G@infradead.org>
 <CAOQ4uxjek9331geZGVbVT=gqkNTyVA_vjyjuB=2eGZD-ufeqNQ@mail.gmail.com>
 <20220527090838.GD3923443@dread.disaster.area>
 <CAOQ4uxgc9Zu0rvTY3oOqycGG+MoYEL3-+qghm9_qEn67D8OukA@mail.gmail.com>
 <YpDw3uVFB7LjPquX@bombadil.infradead.org>
 <20220527234202.GF3923443@dread.disaster.area>
 <CAOQ4uxgYoK=mE=Fpt8BizgHxXmgajCk=t2k6nzHb2mM=C-HvAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgYoK=mE=Fpt8BizgHxXmgajCk=t2k6nzHb2mM=C-HvAg@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6296eb88
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=cRFpyClB2DYKg6vBUXUA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 28, 2022 at 08:00:48AM +0300, Amir Goldstein wrote:
> On Sat, May 28, 2022 at 2:42 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Fri, May 27, 2022 at 08:40:14AM -0700, Luis Chamberlain wrote:
> > > On Fri, May 27, 2022 at 03:24:02PM +0300, Amir Goldstein wrote:
> > > > On Fri, May 27, 2022 at 12:08 PM Dave Chinner <david@fromorbit.com> wrote:
> > > > > Backport candidate: yes. Severe: absolutely not.
> > > > In the future, if you are writing a cover letter for an improvement
> > > > series or internal pull request and you know there is a backport
> > > > candidate inside, if you happen to remember to mention it, it would
> > > > be of great help to me.
> >
> > That's what "fixes" and "cc: stable" tags in the commit itself are
> > for, not the cover letter.
> 
> Cover letter is an overview of the work.
> A good cover letter includes an overview of the individual patches
> in the context of the whole work as your cover letter did:
> 
> Summary of series:
> 
> Patches Modifications
> ------- -------------
> 1-7: log write FUA/FLUSH optimisations
> 8: bug fix
> 9-11: Async CIL pushes
> 12-25: xlog_write() rework
> 26-39: CIL commit scalability
> 
> So it was lapse of judgement on my part or carelessness that made me
> eliminate the series without noting patch #8.
> 
> Furthermore, the subject of the patch has Fix and trailer has
> Reported-and-tested-by:
> so auto candidate selection would have picked it up easily, but my scripts
> only looked for the obvious Fixes: tag inside the eliminated series, so that
> is a problem with my process that I need to improve.
>
> So the blame is entirely on me! not on you!

I can feel a "But..." is about to arrive....

> And yet.
> "bug fix"?
> Really?

... and there's the passive-aggressive blame-shift.

As you just said yourself, all the information you required was in
both the cover letter and the patch, but you missed them both. You
also missed the other 3 times this patch was posted to the list,
too. Hence even if that cover letter said "patch 8: CIL log space
overrun bug fix", it wouldn't have made any difference because of
the process failures on your side.

So what's the point you're trying to make with this comment? What is
the problem it demonstrates that we need to address? We can't be
much more explicit than "patch X is a bug fix" in a cover letter, so
what are you expecting us to do differently?

> I may not have been expecting more of other developers.
> But I consider you to be one of the best when it comes to analyzing and
> documenting complex and subtle code, so forgive me for expecting more.

That's not very fair.  If you are going to hold me to a high bar,
then you need to hold everyone to that same high bar.....

> It makes me sad that you are being defensive about this, because I wish

.... because people tend to get defensive when they feel like they
are being singled out repeatedly for things that nobody else is
getting called out for.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

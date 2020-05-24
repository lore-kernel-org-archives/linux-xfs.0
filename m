Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2CFBC433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 23:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AB95207FB
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 23:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388104AbgEXXNf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 19:13:35 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:49792 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387863AbgEXXNe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 19:13:34 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id C278E5AAE1C;
        Mon, 25 May 2020 09:13:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jczo9-0000wB-Hy; Mon, 25 May 2020 09:13:29 +1000
Date:   Mon, 25 May 2020 09:13:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/24] xfs: pin inode backing buffer to the inode log item
Message-ID: <20200524231329.GP2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-13-david@fromorbit.com>
 <20200523093451.GA7083@infradead.org>
 <20200523214334.GG2040@dread.disaster.area>
 <20200524053124.GA5468@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524053124.GA5468@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=VfdMf4xpzUXbzcQGyccA:9 a=ru9-lmSHqCEHMk6h:21 a=zneyPrJEtmrGffdD:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 23, 2020 at 10:31:24PM -0700, Christoph Hellwig wrote:
> On Sun, May 24, 2020 at 07:43:34AM +1000, Dave Chinner wrote:
> > I've got to rework the error handling code anyway, so I might end up
> > getting rid of ->li_error and hard coding these like I've done the
> > iodone functions. That way the different objects can use different
> > failure mechanisms until the dquot code is converted to the same
> > "hold at dirty time" flushing mechanism...
> 
> FYI, while reviewing your series I looked at that area a bit, and
> found the (pre-existing) code structure a little weird:
> 
>  - xfs_buf_iodone_callback_errorl  deals with the buffer itself and
>    thus should sit in xfs_buf.c, not xfs_buf_item.c
>  - xfs_buf_do_callbacks_fail really nees to be a buffer level
>    methods instead of polig into b_li_list, which nothing else in
>    "common" code does.  My though was to either add another method
>    or overload the b_write_done method to pass the error back to
>    the buffer owner and let the owner deal with the list iteration
>    an exact error handling method.

No.

Just no.

Please stop with the "we have to clean up all this irrelevant stuff
before we land a feature/bug fix" idiocy already.

We do not need to completely rework the way the infrastructure is
laid out to fix this problem. That is not a priority for me, nor is
it important in any way to solving this problem. This patchset
already removes a huge amount of code so it cleans up a lot in the
process of fixing the important problem. But the reality is that it
also touches many very important areas in the code base and so we
need to -minimise- the unnecessary changes in the patchset, not add
more to it.

The most important thing we need to do here is that we get the
change correct. We do not need to completely rewrite how the code is
laid out, nor do we need to move hundreds of lines of code form one
file to another just to clean up some non-critical code. It's
completely unnecessary and irrelevant to fixing the problem the
patchset is trying to address.

Yes, I will rework the bits needed to fix the problems that have
been found, but I'm not going to go and make wholesale changes to
the buffer and buffer item IO completion infrastructure because it
is *not necessary* to fix the problems.

This patchset has been a nightmare so far precisely because of the
frequent cleanup patchsets merged in the past couple of months that
have caused widespread churn in the codebase. Almost none of these
cleanups have done anything other than change the code - most
haven't even been necessary for bug fixes to be applied, either.
They've just been "change" and that's caused me repeated problems
with severe patch conflicts.

Code cleanups *are not free*. They might be easy to do and review so
there's no big upfront cost to them. The cost to cleanups are in the
downstream effects - developer patch sets no longer apply, code is
no longer recognisable at a glance to experienced developers,
failure modes are different, bugs can be introduced, etc. All of
these things add time and resources to the work that other
developers not involved in the cleanup process are trying to do.

And when the work those developers are trying to address long term
problems and are full of complex, subtle interactions and changes?
Cleanups that keep overlapping with that work are actively harmful
to the process of fixing such problems.

The problem here is all these cleanups are reactive patchsets -
someone sends a patchset for review, and then immediately the list
is filled with cleanup patchsets that hit the exact area of code
that the original patchset modified.  This is not a one-off incident
- over the past few months this has happened almost every time every
time someone has posted a substantial feature or bug-fix patchset.

So, can we please stop with the "clean up before original patchset
lands" reviews and patch postings. If anyone has cleanup patches,
please send them out when you do them, not in response to someone
else trying to fix a problem. If anyone wants to make significant
clean ups around someone elses work as a result of reviewing that
code, we need to do it -after- the current patchset has been
reviewed and merged.

We will still get the code cleanup done, but we need to prioritise
the work we do appropriate. i.e. we need to land the important
thing first, then worry about the little stuff that isn't critical
to addressing the immediate issue. Code cleanups are definitely
necessary, but they are most definitely are not the most important
thing we need to do...

/end rant

-- 
Dave Chinner
david@fromorbit.com

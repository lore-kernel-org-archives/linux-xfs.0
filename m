Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD78C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 22:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 640A861139
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 22:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhKDWVB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Nov 2021 18:21:01 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:39368 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231494AbhKDWVA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Nov 2021 18:21:00 -0400
Received: from dread.disaster.area (pa49-180-20-157.pa.nsw.optusnet.com.au [49.180.20.157])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 80ACAFCD7C3;
        Fri,  5 Nov 2021 09:18:20 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mil3q-004wHX-M8; Fri, 05 Nov 2021 09:18:18 +1100
Date:   Fri, 5 Nov 2021 09:18:18 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix double unlock in defer capture code
Message-ID: <20211104221818.GE449541@dread.disaster.area>
References: <20211103213309.824096-1-allison.henderson@oracle.com>
 <20211104001633.GD449541@dread.disaster.area>
 <20211104013007.GP24307@magnolia>
 <fc3c7b3d-42a2-1901-280e-2a99c3b49226@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc3c7b3d-42a2-1901-280e-2a99c3b49226@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61845c2c
        a=t5ERiztT/VoIE8AqcczM6g==:117 a=t5ERiztT/VoIE8AqcczM6g==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=7-415B0cAAAA:8
        a=uFDyXEGDjp-ZuGVuxm0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 04, 2021 at 09:59:50AM -0700, Allison Henderson wrote:
> On 11/3/21 6:30 PM, Darrick J. Wong wrote:
> > On Thu, Nov 04, 2021 at 11:16:33AM +1100, Dave Chinner wrote:
> > > On Wed, Nov 03, 2021 at 02:33:09PM -0700, Allison Henderson wrote:
> > > > @@ -777,15 +805,25 @@ xfs_defer_ops_continue(
> > > >   	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> > > >   	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
> > > > -	/* Lock and join the captured inode to the new transaction. */
> > > > +	/* Lock the captured resources to the new transaction. */
> > > >   	if (dfc->dfc_held.dr_inos == 2)
> > > >   		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
> > > >   				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
> > > >   	else if (dfc->dfc_held.dr_inos == 1)
> > > >   		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
> > > > +
> > > > +	xfs_defer_relock_buffers(dfc);
> > > > +
> > > > +	/* Join the captured resources to the new transaction. */
> > > >   	xfs_defer_restore_resources(tp, &dfc->dfc_held);
> > > >   	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
> > > > +	/*
> > > > +	 * Inodes must be passed back to the log recovery code to be unlocked,
> > > > +	 * but buffers do not.  Ignore the captured buffers
> > > > +	 */
> > > > +	dres->dr_bufs = 0;
> > > 
> > > I'm not sure what this comment is supposed to indicate. This seems
> > > to be infrastructure specific to log recovery, not general runtime
> > > functionality, but even in that context I don't really understand
> > > what it means or why it is done...
> > 
> > The defer_capture machinery picks up inodes that were ijoined with
> > lock_flags==0 (i.e. caller will unlock explicitly), which is why they
> > have to be passed back out after the entire transaction sequence
> > completes.

I'm still not grokking what "passed back out" is supposed to mean
or how it is implemented.

> > By contrast, the defer capture machinery picks up buffers with BLI_HOLD
> > set on the log item.  These are only meant to maintain the hold across
> > the next transaction roll (or the next defer_finish invocation), which
> > means that the caller is responsible for unlocking and releasing the
> > buffer (or I guess re-holding it) during that next transaction.

Sure, but buffers that have XFS_BLI_HOLD is set are not unlocked on
transaction commit. So this makes little sense to me.

A bunch of notes follows as I tried to make sense of this....

We have deferop "save/restore" resources functions that store held
buffers/inodes on save and hold them again on restore via a struct
xfs_defer_resources. This is only used to wrap transaction commits
in xfs_defer_trans_roll(), which means that the held objects stay
held across the entire transaction commit and defer ops processing.

Then we have "capture/free/continue/rele" which use the same struct
xfs_defer_resources but only takes direct references to buffers and
inodes they "hold" and rather than transaction scope references.
Hence before commit, they have to be relocked and rejoined to the
transaction. Ugh - same xfs_defer_resources structure, different
semantic meaning of contents.

Uses xfs_defer_restore_resources() internally, so it joins *and
holds* those items at the transaction level, meaning they do not get
unlocked by the subsequent transaction commit.  And then it is
committed like so:

                xfs_defer_ops_continue(dfc, tp, &dres);
		error = xfs_trans_commit(tp);
		xfs_defer_resources_rele(&dres);

And then because the objects are held and not unlocked by the
transaction commit, they need to be unlocked and released by the
xfs_defer_resources_rele() call.  But we've hacked dres.nbufs = 0,
so buffers are not released after transaction commit. This makes no
obvious sense - transaction commit does not free/release held
buffers, nor does xfs_defer_resources_rele(), so this just looks
like a buffer leak to me.

[ the API is a mess here - why does xfs_defer_ops_continue() memcpy
dfc->dres to dres, then get freed, then dres get passed to
xfs_defer_resources_rele()? Why isn't this simply:

		xfs_defer_ops_capture_continue(dfc, tp);
		error = xfs_trans_commit(tp);
		xfs_defer_ops_capture_rele(dfc);

The deferops functions are all single caller functions from log
recovery, so it doesn't make a huge amount of sense to me how or why
the code is structured this way. Indeed, I don't know why this
capture interface isn't part of the log recovery API, not core
deferops... ]

> Ok, so should we remove or expand the comment?  I thought it made sense with
> the commentary at the top of the function that talks about why inodes are
> passed back, but I am not picky.  How about:
> 
> /*
>  * Inodes must be passed back to the log recovery code to be unlocked,
>  * but buffers do not.  Buffers are released by the calling code, and
>  * only need to be transferred to the next transaction.  Ignore
>  * captured buffers here
>  */

This still just describes what the code does, and so I have no
more insight into what is actually doing the releasing of these
buffers and why they behave differently to inodes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

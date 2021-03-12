Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E326C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 02:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6689164ED6
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 02:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhCLCh0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 21:37:26 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50494 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229530AbhCLChC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 21:37:02 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 68535825F65;
        Fri, 12 Mar 2021 13:37:01 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKXff-001VFU-RF; Fri, 12 Mar 2021 13:36:59 +1100
Date:   Fri, 12 Mar 2021 13:36:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 43/45] xfs: avoid cil push lock if possible
Message-ID: <20210312023659.GK63242@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-44-david@fromorbit.com>
 <20210311014709.GQ3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311014709.GQ3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=C4FxL-jx8oPV39ssRIAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 05:47:09PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:41PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because now it hurts when the CIL fills up.
> > 
> >   - 37.20% __xfs_trans_commit
> >       - 35.84% xfs_log_commit_cil
> >          - 19.34% _raw_spin_lock
> >             - do_raw_spin_lock
> >                  19.01% __pv_queued_spin_lock_slowpath
> >          - 4.20% xfs_log_ticket_ungrant
> >               0.90% xfs_log_space_wake
> > 
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 6dcc23829bef..d60c72ad391a 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -1115,10 +1115,18 @@ xlog_cil_push_background(
> >  	ASSERT(!test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
> >  
> >  	/*
> > -	 * Don't do a background push if we haven't used up all the
> > -	 * space available yet.
> > +	 * We are done if:
> > +	 * - we haven't used up all the space available yet; or
> > +	 * - we've already queued up a push; and
> > +	 * - we're not over the hard limit; and
> > +	 * - nothing has been over the hard limit.
> 
> Er... do these last three bullet points correspond to the last three
> lines of the if test?  I'm not sure how !waitqueue_active() determines
> that nothing has been over the hard limit?

If a commit has made space used go over the hard limit, it will be
throttled and put to sleep on the push wait queue. Another commit
can then return space (inode fork gets smaller) and bring us back
under the hard limit. Hence just checking against the space used does
not tell us if we've hit the hard limit or not, but checking if
there is a throttled process on the wait queue does...

> Or for that matter how
> comparing push_seq against current_seq tells us if we've queued a
> push?

We only set push_seq == current_seq when we queue up a push in
xlog_cil_push_now() or xlog_cil_push_background().  Hence if no push
has been queued, then push_seq will be less than current_seq.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

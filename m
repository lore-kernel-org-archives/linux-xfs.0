Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C84C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 02:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45751650E5
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 02:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhCDCAh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 21:00:37 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:60951 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230446AbhCDCAW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Mar 2021 21:00:22 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id BE1AF635EA;
        Thu,  4 Mar 2021 12:59:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lHdH3-00DrAC-GB; Thu, 04 Mar 2021 12:59:33 +1100
Date:   Thu, 4 Mar 2021 12:59:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] xfs: AIL needs asynchronous CIL forcing
Message-ID: <20210304015933.GO4662@dread.disaster.area>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-3-david@fromorbit.com>
 <20210224211058.GA4662@dread.disaster.area>
 <20210224232600.GH4662@dread.disaster.area>
 <YD6xrJHgkkHi+7a3@bfoster>
 <20210303005752.GM4662@dread.disaster.area>
 <YD/IN66S3aM1lEQh@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD/IN66S3aM1lEQh@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=udjMChYXyYFnwfMKShUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 12:32:39PM -0500, Brian Foster wrote:
> On Wed, Mar 03, 2021 at 11:57:52AM +1100, Dave Chinner wrote:
> > On Tue, Mar 02, 2021 at 04:44:12PM -0500, Brian Foster wrote:
> > > On Thu, Feb 25, 2021 at 10:26:00AM +1100, Dave Chinner wrote:
> > > >  	 * xlog_cil_push() handles racing pushes for the same sequence,
> > > >  	 * so no need to deal with it here.
> > > >  	 */
> > > >  restart:
> > > > -	xlog_cil_push_now(log, sequence);
> > > > +	xlog_cil_push_now(log, sequence, flags & XFS_LOG_SYNC);
> > > > +	if (!(flags & XFS_LOG_SYNC))
> > > > +		return commit_lsn;
> > > 
> > > Hm, so now we have sync and async log force and sync and async CIL push.
> > > A log force always requires a sync CIL push and commit record submit;
> > > the difference is simply whether or not we wait on commit record I/O
> > > completion. The sync CIL push drains the CIL of log items but does not
> > > switch out the commit record iclog, while the async CIL push executes in
> > > the workqueue context so the drain is async, but it does switch out the
> > > commit record iclog before it completes. IOW, the async CIL push is
> > > basically a "more async" async log force.
> > 
> > Yes.
> > 
> > > I can see the need for the behavior of the async CIL push here, but that
> > > leaves a mess of interfaces and behavior matrix. Is there any reason we
> > > couldn't just make async log forces unconditionally behave equivalent to
> > > the async CIL push as defined by this patch? There's only a handful of
> > > existing users and I don't see any obvious reason why they might care
> > > whether the underlying CIL push is synchronous or not...
> > 
> > I'm not touching the rest of the log force code in this series - it
> > is out of scope of this bug fix and the rest of the series that it
> > is part of.
> > 
> 
> But you already have altered the log force code by changing
> xlog_cil_force_seq(), which implicitly changes how xfs_log_force_seq()
> behaves.

The behaviour of the function when called from xfs_log_force*()
should be unchanged. Can you be specific about exactly what
behaviour did I change for non-synchronous xfs_log_force*() callers
so I can fix it? I have not intended to change it at all, so
whatever you are refering is an issue I need to fix...

> So not only does this patch expose subsystem internals to
> external layers and create more log forcing interfaces/behaviors to

Sorry, I don't follow. What "subsystem internals" are being exposed
and what external layer are they being exposed to?

> > Cleaning up the mess that is the xfs_log_* and xlog_* interfaces and
> > changing things like log force behaviour and implementation is for
> > a future series.
> > 
> 
> TBH I think this patch is kind of a mess on its own. I think the
> mechanism it wants to provide is sane, but I've not even got to the
> point of reviewing _that_ yet because of the seeming dismissal of higher
> level feedback. I'd rather not go around in circles on this so I'll just
> offer my summarized feedback to this patch...

I'm not dismissing review nor am I saying the API cannot or should
not be improved. I'm simply telling you that I think the additional
changes you are proposing are outside the scope of the problem I am
addressing here. I already plan to rework the log force API (and
others) but doing so it not something that this patchset needs to
address, or indeed should address.

There are already enough subtle changes being made to core code and
algorithms that mixing them with unrelated high level external
behavioural changes that it greatly increases the risk of unexpected
regressions in the patchset. The log force are paths are used in
data integrity paths, so I want to limit the scope of behavioural
change to just the AIL where the log force has no data integrity
requirement associcated with it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D412C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0970564F03
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhBXVpA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:45:00 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:41300 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230330AbhBXVo7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 16:44:59 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id C361D4ABFE4;
        Thu, 25 Feb 2021 08:44:17 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF1xB-002kUn-4n; Thu, 25 Feb 2021 08:44:17 +1100
Date:   Thu, 25 Feb 2021 08:44:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <20210224214417.GB4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
 <20210224203429.GR7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224203429.GR7272@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=k4gU2gVVm8cocxQ7w5EA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 12:34:29PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 23, 2021 at 02:34:36PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To allow for iclog IO device cache flush behaviour to be optimised,
> > we first need to separate out the commit record iclog IO from the
> > rest of the checkpoint so we can wait for the checkpoint IO to
> > complete before we issue the commit record.
> > 
> > This separation is only necessary if the commit record is being
> > written into a different iclog to the start of the checkpoint as the
> > upcoming cache flushing changes requires completion ordering against
> > the other iclogs submitted by the checkpoint.
> > 
> > If the entire checkpoint and commit is in the one iclog, then they
> > are both covered by the one set of cache flush primitives on the
> > iclog and hence there is no need to separate them for ordering.
> > 
> > Otherwise, we need to wait for all the previous iclogs to complete
> > so they are ordered correctly and made stable by the REQ_PREFLUSH
> > that the commit record iclog IO issues. This guarantees that if a
> > reader sees the commit record in the journal, they will also see the
> > entire checkpoint that commit record closes off.
> > 
> > This also provides the guarantee that when the commit record IO
> > completes, we can safely unpin all the log items in the checkpoint
> > so they can be written back because the entire checkpoint is stable
> > in the journal.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c      | 55 +++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_log_cil.c  |  7 ++++++
> >  fs/xfs/xfs_log_priv.h |  2 ++
> >  3 files changed, 64 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index fa284f26d10e..ff26fb46d70f 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -808,6 +808,61 @@ xlog_wait_on_iclog(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Wait on any iclogs that are still flushing in the range of start_lsn to the
> > + * current iclog's lsn. The caller holds a reference to the iclog, but otherwise
> > + * holds no log locks.
> > + *
> > + * We walk backwards through the iclogs to find the iclog with the highest lsn
> > + * in the range that we need to wait for and then wait for it to complete.
> > + * Completion ordering of iclog IOs ensures that all prior iclogs to the
> > + * candidate iclog we need to sleep on have been complete by the time our
> > + * candidate has completed it's IO.
> 
> Hmm, I guess this means that iclog header lsns are supposed to increase
> as one walks forwards through the list?

yes, the iclogs are written sequentially to the log - we don't
switch the log->l_iclog pointer to the current active iclog until we
switch it out, and then the next iclog in the loop is physically
located at a higher lsn to the one we just switched out.

> > + *
> > + * Therefore we only need to find the first iclog that isn't clean within the
> > + * span of our flush range. If we come across a clean, newly activated iclog
> > + * with a lsn of 0, it means IO has completed on this iclog and all previous
> > + * iclogs will be have been completed prior to this one. Hence finding a newly
> > + * activated iclog indicates that there are no iclogs in the range we need to
> > + * wait on and we are done searching.
> 
> I don't see an explicit check for an iclog with a zero lsn?  Is that
> implied by XLOG_STATE_ACTIVE?

It's handled by the XFS_LSN_CMP(prev_lsn, start_lsn) < 0 check.  if
the prev_lsn is zero because the iclog is clean, then this check
will always be true.

> Also, do you have any idea what was Christoph talking about wrt devices
> with no-op flushes the last time this patch was posted?  This change
> seems straightforward to me (assuming the answers to my two question are
> 'yes') but I didn't grok what subtlety he was alluding to...?

He was wondering what devices benefited from this. It has no impact
on highspeed devices that do not require flushes/FUA (e.g. high end
intel optane SSDs) but those are not the devices this change is
aimed at. There are no regressions on these high end devices,
either, so they are largely irrelevant to the patch and what it
targets...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

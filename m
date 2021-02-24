Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779F5C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 23:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4513564F06
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 23:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235713AbhBXXHK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 18:07:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235490AbhBXXHK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 18:07:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 224D664F03;
        Wed, 24 Feb 2021 23:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614207989;
        bh=K21bu1f282HPH/T34n2h3tFVV+AyeGZmCHK1jj9quz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OW0zw2GhX4yYqGWANrU+Oy/znHg+7EuO7iKm8NO9F/jKjlnOw6Kmcc4Dl0W9PJN4Q
         eahGJghhTBLOH/Q0bLS0AIuUrNfrhcWB4YCNxdQdwX/HuhqCFQpsAZA1qYImYy+VIp
         FDO63V1T44docHVJZaR4DDexPx2OkscoBIGKkdLAmrn8QuqO3kUrJBBZP2GF3ocqZj
         elIDqyFy16iiSO0HL3fVHPiiDmO3QHNRuCDl3obru1nE0lrCpryQb5NcwIH93hp40z
         kXcud/0tr5TIqxpWH7b+ZNo6W+zSRF9IToYJ98YyGv0VBcjGkPPsKu7GJGe0e1nSkF
         zr2cwLnj6NWxQ==
Date:   Wed, 24 Feb 2021 15:06:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <20210224230628.GG7272@magnolia>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
 <20210224203429.GR7272@magnolia>
 <20210224214417.GB4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224214417.GB4662@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 08:44:17AM +1100, Dave Chinner wrote:
> On Wed, Feb 24, 2021 at 12:34:29PM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 23, 2021 at 02:34:36PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > To allow for iclog IO device cache flush behaviour to be optimised,
> > > we first need to separate out the commit record iclog IO from the
> > > rest of the checkpoint so we can wait for the checkpoint IO to
> > > complete before we issue the commit record.
> > > 
> > > This separation is only necessary if the commit record is being
> > > written into a different iclog to the start of the checkpoint as the
> > > upcoming cache flushing changes requires completion ordering against
> > > the other iclogs submitted by the checkpoint.
> > > 
> > > If the entire checkpoint and commit is in the one iclog, then they
> > > are both covered by the one set of cache flush primitives on the
> > > iclog and hence there is no need to separate them for ordering.
> > > 
> > > Otherwise, we need to wait for all the previous iclogs to complete
> > > so they are ordered correctly and made stable by the REQ_PREFLUSH
> > > that the commit record iclog IO issues. This guarantees that if a
> > > reader sees the commit record in the journal, they will also see the
> > > entire checkpoint that commit record closes off.
> > > 
> > > This also provides the guarantee that when the commit record IO
> > > completes, we can safely unpin all the log items in the checkpoint
> > > so they can be written back because the entire checkpoint is stable
> > > in the journal.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log.c      | 55 +++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_log_cil.c  |  7 ++++++
> > >  fs/xfs/xfs_log_priv.h |  2 ++
> > >  3 files changed, 64 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index fa284f26d10e..ff26fb46d70f 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -808,6 +808,61 @@ xlog_wait_on_iclog(
> > >  	return 0;
> > >  }
> > >  
> > > +/*
> > > + * Wait on any iclogs that are still flushing in the range of start_lsn to the
> > > + * current iclog's lsn. The caller holds a reference to the iclog, but otherwise
> > > + * holds no log locks.
> > > + *
> > > + * We walk backwards through the iclogs to find the iclog with the highest lsn
> > > + * in the range that we need to wait for and then wait for it to complete.
> > > + * Completion ordering of iclog IOs ensures that all prior iclogs to the
> > > + * candidate iclog we need to sleep on have been complete by the time our
> > > + * candidate has completed it's IO.
> > 
> > Hmm, I guess this means that iclog header lsns are supposed to increase
> > as one walks forwards through the list?
> 
> yes, the iclogs are written sequentially to the log - we don't
> switch the log->l_iclog pointer to the current active iclog until we
> switch it out, and then the next iclog in the loop is physically
> located at a higher lsn to the one we just switched out.
> 
> > > + *
> > > + * Therefore we only need to find the first iclog that isn't clean within the
> > > + * span of our flush range. If we come across a clean, newly activated iclog
> > > + * with a lsn of 0, it means IO has completed on this iclog and all previous
> > > + * iclogs will be have been completed prior to this one. Hence finding a newly
> > > + * activated iclog indicates that there are no iclogs in the range we need to
> > > + * wait on and we are done searching.
> > 
> > I don't see an explicit check for an iclog with a zero lsn?  Is that
> > implied by XLOG_STATE_ACTIVE?
> 
> It's handled by the XFS_LSN_CMP(prev_lsn, start_lsn) < 0 check.  if
> the prev_lsn is zero because the iclog is clean, then this check
> will always be true.
> 
> > Also, do you have any idea what was Christoph talking about wrt devices
> > with no-op flushes the last time this patch was posted?  This change
> > seems straightforward to me (assuming the answers to my two question are
> > 'yes') but I didn't grok what subtlety he was alluding to...?
> 
> He was wondering what devices benefited from this. It has no impact
> on highspeed devices that do not require flushes/FUA (e.g. high end
> intel optane SSDs) but those are not the devices this change is
> aimed at. There are no regressions on these high end devices,
> either, so they are largely irrelevant to the patch and what it
> targets...

Ok, that's what I thought.  It seemed fairly self-evident to me that
high speed devices wouldn't care.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

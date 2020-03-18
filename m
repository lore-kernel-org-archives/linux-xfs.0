Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818E9C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 16:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E9ED20752
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 16:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgCRQec (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 12:34:32 -0400
Received: from verein.lst.de ([213.95.11.211]:37583 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgCRQec (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Mar 2020 12:34:32 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CC65E68CEE; Wed, 18 Mar 2020 17:34:29 +0100 (CET)
Date:   Wed, 18 Mar 2020 17:34:29 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/14] xfs: move log shut down handling out of
 xlog_state_iodone_process_iclog
Message-ID: <20200318163429.GA14701@lst.de>
References: <20200316144233.900390-1-hch@lst.de> <20200316144233.900390-10-hch@lst.de> <20200318144825.GB32848@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318144825.GB32848@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 18, 2020 at 10:48:25AM -0400, Brian Foster wrote:
> >  		do {
> > -			if (xlog_state_iodone_process_iclog(log, iclog,
> > -							&ioerror))
> > +			if (XLOG_FORCED_SHUTDOWN(log)) {
> > +				xlog_state_do_iclog_callbacks(log, iclog);
> > +				wake_up_all(&iclog->ic_force_wait);
> > +				continue;
> > +			}
> > +
> 
> Why do we need to change the flow here? The current code looks like it
> proceeds with the _do_iclog_callbacks() call below..
>
> As it is, I also don't think this reflects the comment above because if
> we catch the shutdown partway through a loop, the outer loop will
> execute one more time through. That doesn't look like a problem at a
> glance, but I think we should try to retain closer to existing behavior
> by folding the shutdown check into the ic_state check below as well as
> the outer loop conditional.

True.  I think we just need to clear cycled_icloglock in the
shutdown branch.  I prefer that flow over falling through to the
main loop body as that clearly separates out the shutdown case.

> This (and the next patch) also raises the issue of whether to maintain
> state validity once the iclog ioerror state goes away. Currently we see
> the IOERROR state and kind of have free reign on busting through the
> normal runtime logic to clear out callbacks, etc. on the iclog
> regardless of what the pre-error state was. It certainly makes sense to
> continue to do that based on XLOG_FORCED_SHUTDOWN(), but the iclog state
> sort of provides a platform that allows us to do that because any
> particular context can see it and handle an iclog with care. With
> IOERROR replaced with the (potentially racy) log flag check, I think we
> should try to maintain the coherence of other states wherever possible.
> IOW, XLOG_FORCED_SHUTDOWN() means we can run callbacks and abort and
> whatnot, but we should probably still consider and update the iclog
> state as we progress (as opposed to leaving it in the DONE_SYNC state,
> for example) because there's no guarantee some other context will
> (always) behave just as it did with IOERROR.

I actually very much disagree with that, and this series moves into
the other direction.  We only really changes the states when
writing to iclogs, syncing them to disk, and I/O completion.  And
all the paths just error out at a high level when the log is shut
down, so there is no need to move the state along.  Faking state
changes when they don't correspond to the actual I/O just seems like
a really bad idea.

Also if you look at what state checks are left, the are all (except
for the debug check in xfs_log_unmount_verify_iclog) under
l_icloglock and guarded by a shutdown check.

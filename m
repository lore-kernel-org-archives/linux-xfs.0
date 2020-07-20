Return-Path: <SRS0=nIBV=A7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E69C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 03:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BC9D2250E
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 03:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgGTD6q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Jul 2020 23:58:46 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:47530 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbgGTD6p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Jul 2020 23:58:45 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4A771821524;
        Mon, 20 Jul 2020 13:58:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jxMwq-0002md-Mq; Mon, 20 Jul 2020 13:58:40 +1000
Date:   Mon, 20 Jul 2020 13:58:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/10] xfs: automatic relogging
Message-ID: <20200720035840.GD2005@dread.disaster.area>
References: <20200701165116.47344-1-bfoster@redhat.com>
 <20200702115144.GH2005@dread.disaster.area>
 <20200702185209.GA58137@bfoster>
 <20200703004940.GI2005@dread.disaster.area>
 <20200706160306.GA21048@bfoster>
 <20200706174257.GG7606@magnolia>
 <20200707113743.GA33690@bfoster>
 <20200708164428.GC7625@magnolia>
 <20200709121530.GA56848@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709121530.GA56848@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=_2VJTg5ke6Nig_IZf44A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 08:15:30AM -0400, Brian Foster wrote:
> On Wed, Jul 08, 2020 at 09:44:28AM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 07, 2020 at 07:37:43AM -0400, Brian Foster wrote:
> > > > 
> > > 
> > > Thanks. I think I get the general idea. We're reworking the
> > > ->iop_relog() handler to complete and replace the current intent (rather
> > > than just relog the original intent, which is what this series did for
> > > the quotaoff case) in the current dfops transaction and allow the dfops
> > > code to update its reference to the item. The part that's obviously
> > > missing is some kind of determination on when we actually need to relog
> > > the outstanding intents vs. using a fixed roll count.
> > 
> > <nod>  I don't consider myself sufficiently ail-smart to know how to do
> > that part. :)
> > 
> > > I suppose we could do something like I was mentioning in my other reply
> > > on the AIL pushing issue Dave pointed out where we'd set a bit on
> > > certain items that are tail pinned and in need of relog. That sounds
> > > like overkill given this use case is currently self-contained to dfops.
> > 
> > That might be a useful optimization -- every time defer_finish rolls the
> > transaction, check the items to see if any of them have
> > XFS_LI_RELOGMEPLEASE set, and if any of them do, or we hit our (now
> > probably higher than 7) fixed roll count, we'll relog as desired to keep
> > the log moving forward.
> > 
> 
> It's an optimization in some sense to prevent unnecessary relogs, but
> the intent would be to avoid the need for a fixed count by notifying
> when a relog is needed to a transaction that should be guaranteed to
> have the reservation necessary to do so. I'm not sure it's worth the
> complexity if there were some reason we still needed to fall back to a
> hard count.

FWIW, relogging would only ever be necessary if
xfs_log_item_in_current_chkpt() returned false for an item we are
considering relogging. Otherwise, it's already queued for the next
journal checkpoint and there's no need to relog it until the
checkpoint commits....

> > > Perhaps the other idea of factoring out the threshold determination
> > > logic from xlog_grant_push_ail() might be useful.
> > > 
> > > For example, if the current free reservation is below the calculated
> > > threshold (with need_bytes == 0), return a threshold LSN based on the
> > > current tail. Instead of using that to push the AIL, compare it to
> > > ->li_lsn of each intent and relog any that are inside the threshold LSN
> > > (which will probably be all of them in practice since they are part of
> > > the same transaction). We'd probably need to identify intents that have
> > > been recently relogged so the process doesn't repeat until the CIL
> > > drains and the li_lsn eventually changes. Hmm.. I did have an
> > > XFS_LI_IN_CIL state tracking patch around somewhere for debugging
> > > purposes that might actually be sufficient for that. We could also
> > > consider stashing a "relog push" LSN somewhere (similar to the way AIL
> > > pushing works) and perhaps use that to avoid repeated relogs on a chain,
> > > but it's not immediately clear to me how well that would fit into the
> > > dfops mechanism...
> > 
> > ...is there a sane way for dfops to query the threshold LSN so that it
> > could compare against the li_lsn of each item it holds?
> > 
> 
> I'd start with just trying to reuse the logic in xlog_grant_push_ail()
> (i.e. just factor out the AIL push). That function starts with a check
> on available log reservation to filter out unnecessary pushes, then
> calculates the AIL push LSN by adding the amount of log space we need to
> free up to the current log tail. In this case we're not pushing the AIL,
> but I think we'd be able to use the same threshold calculation logic to
> determine when to relog intents that happen to reside within the range
> from the current tail to the calculated threshold.

Hmmmm. I'm kinda wanting to pull the AIL away from the demand-based
tail pushing that xlog_grant_push_ail() does. Distance from the tail
doesn't really tell us how quickly that distance will be consumed
by ongoing operations....

One of the problems we have at the moment is that the AIL will sit
at under 75% full and do nothing at all (because the
xlog_grant_push_ail() call does nothing at <75% full) until we get
memory pressure or the log worker comes along every 30s and calls
xfs_ail_push_all().

The result is that when we are under bursty workloads, we don't
keep pushing metadata out to free up log space - our working space
to soak up bursts is only 25% of the journal, which we can fill in a
couple of seconds, even on a 2GB log. SO under sustained bursty
worklaods, we really only have 25% of the log available at most,
rather than continuing to write back past the 75% threshold so the
next burst can have, say, 50% of the log space available to soak up
the burst.

i.e. if we have frequent bursts and the IO subsystem can soak up the
metadata writeback rate, we should be writing back faster so that
the bursts can hit the transaction reservation fast path for
longer...

IOWs, I'd like to see the AIL move more towards a mechanism that
balances a time-averaged rate of inserts (journal checkpoint
completions) with a time-averaged rate of removals (metadata IO
completions) rather than working to a free fixed space target.
If the workload is sustained, then this effective ends up the same
as we have now with transactions waiting for log reservation space,
but we should end up draining the AIL down further when than we
currently do when incoming work tails off.

I suspect that we could work into this a "need to be relogged within
X seconds" trigger for active reloggable items in the AIL, such that
if the top layer deferops sees the flag set on any item in the
processing of the deferops it relogs all the reloggable items in the
current set...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06611C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 12:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D15E520838
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 12:17:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AgVuU+pj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgHZMRW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 08:17:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729373AbgHZMRV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 08:17:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598444237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fk/YbGfRFrlZpOUWI6cvQQUNmvhcJ22ptVWZD/wadTw=;
        b=AgVuU+pj9WJr+AxvvRpDI+oFzSHlA5F15plkeCcbKgr21tIOuqWUyAUYe64nrKYzLLsERS
        0BeWajsrC9JOSbvWbQQC02HHAFXnm8VIhYRhA5djCt5lJBBpFuE6jBMeC2PrKluUHwNWcu
        4msKunw8A1+axg5r3oJTtbTJLPcyVxE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-k8NuriijPFWbCQhPUJKUKQ-1; Wed, 26 Aug 2020 08:17:13 -0400
X-MC-Unique: k8NuriijPFWbCQhPUJKUKQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC2A481F027;
        Wed, 26 Aug 2020 12:17:12 +0000 (UTC)
Received: from bfoster (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 50F037C65E;
        Wed, 26 Aug 2020 12:17:12 +0000 (UTC)
Date:   Wed, 26 Aug 2020 08:17:10 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/10] xfs: automatic relogging
Message-ID: <20200826121710.GA355692@bfoster>
References: <20200701165116.47344-1-bfoster@redhat.com>
 <20200702115144.GH2005@dread.disaster.area>
 <20200702185209.GA58137@bfoster>
 <20200703004940.GI2005@dread.disaster.area>
 <20200706160306.GA21048@bfoster>
 <20200706174257.GG7606@magnolia>
 <20200707113743.GA33690@bfoster>
 <20200708164428.GC7625@magnolia>
 <20200709121530.GA56848@bfoster>
 <20200720035840.GD2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720035840.GD2005@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 20, 2020 at 01:58:40PM +1000, Dave Chinner wrote:
> On Thu, Jul 09, 2020 at 08:15:30AM -0400, Brian Foster wrote:
> > On Wed, Jul 08, 2020 at 09:44:28AM -0700, Darrick J. Wong wrote:
> > > On Tue, Jul 07, 2020 at 07:37:43AM -0400, Brian Foster wrote:
> > > > > 
> > > > 
> > > > Thanks. I think I get the general idea. We're reworking the
> > > > ->iop_relog() handler to complete and replace the current intent (rather
> > > > than just relog the original intent, which is what this series did for
> > > > the quotaoff case) in the current dfops transaction and allow the dfops
> > > > code to update its reference to the item. The part that's obviously
> > > > missing is some kind of determination on when we actually need to relog
> > > > the outstanding intents vs. using a fixed roll count.
> > > 
> > > <nod>  I don't consider myself sufficiently ail-smart to know how to do
> > > that part. :)
> > > 
> > > > I suppose we could do something like I was mentioning in my other reply
> > > > on the AIL pushing issue Dave pointed out where we'd set a bit on
> > > > certain items that are tail pinned and in need of relog. That sounds
> > > > like overkill given this use case is currently self-contained to dfops.
> > > 
> > > That might be a useful optimization -- every time defer_finish rolls the
> > > transaction, check the items to see if any of them have
> > > XFS_LI_RELOGMEPLEASE set, and if any of them do, or we hit our (now
> > > probably higher than 7) fixed roll count, we'll relog as desired to keep
> > > the log moving forward.
> > > 
> > 
> > It's an optimization in some sense to prevent unnecessary relogs, but
> > the intent would be to avoid the need for a fixed count by notifying
> > when a relog is needed to a transaction that should be guaranteed to
> > have the reservation necessary to do so. I'm not sure it's worth the
> > complexity if there were some reason we still needed to fall back to a
> > hard count.
> 
> FWIW, relogging would only ever be necessary if
> xfs_log_item_in_current_chkpt() returned false for an item we are
> considering relogging. Otherwise, it's already queued for the next
> journal checkpoint and there's no need to relog it until the
> checkpoint commits....
> 
> > > > Perhaps the other idea of factoring out the threshold determination
> > > > logic from xlog_grant_push_ail() might be useful.
> > > > 
> > > > For example, if the current free reservation is below the calculated
> > > > threshold (with need_bytes == 0), return a threshold LSN based on the
> > > > current tail. Instead of using that to push the AIL, compare it to
> > > > ->li_lsn of each intent and relog any that are inside the threshold LSN
> > > > (which will probably be all of them in practice since they are part of
> > > > the same transaction). We'd probably need to identify intents that have
> > > > been recently relogged so the process doesn't repeat until the CIL
> > > > drains and the li_lsn eventually changes. Hmm.. I did have an
> > > > XFS_LI_IN_CIL state tracking patch around somewhere for debugging
> > > > purposes that might actually be sufficient for that. We could also
> > > > consider stashing a "relog push" LSN somewhere (similar to the way AIL
> > > > pushing works) and perhaps use that to avoid repeated relogs on a chain,
> > > > but it's not immediately clear to me how well that would fit into the
> > > > dfops mechanism...
> > > 
> > > ...is there a sane way for dfops to query the threshold LSN so that it
> > > could compare against the li_lsn of each item it holds?
> > > 
> > 
> > I'd start with just trying to reuse the logic in xlog_grant_push_ail()
> > (i.e. just factor out the AIL push). That function starts with a check
> > on available log reservation to filter out unnecessary pushes, then
> > calculates the AIL push LSN by adding the amount of log space we need to
> > free up to the current log tail. In this case we're not pushing the AIL,
> > but I think we'd be able to use the same threshold calculation logic to
> > determine when to relog intents that happen to reside within the range
> > from the current tail to the calculated threshold.
> 
> Hmmmm. I'm kinda wanting to pull the AIL away from the demand-based
> tail pushing that xlog_grant_push_ail() does. Distance from the tail
> doesn't really tell us how quickly that distance will be consumed
> by ongoing operations....
> 
> One of the problems we have at the moment is that the AIL will sit
> at under 75% full and do nothing at all (because the
> xlog_grant_push_ail() call does nothing at <75% full) until we get
> memory pressure or the log worker comes along every 30s and calls
> xfs_ail_push_all().
> 
> The result is that when we are under bursty workloads, we don't
> keep pushing metadata out to free up log space - our working space
> to soak up bursts is only 25% of the journal, which we can fill in a
> couple of seconds, even on a 2GB log. SO under sustained bursty
> worklaods, we really only have 25% of the log available at most,
> rather than continuing to write back past the 75% threshold so the
> next burst can have, say, 50% of the log space available to soak up
> the burst.
> 
> i.e. if we have frequent bursts and the IO subsystem can soak up the
> metadata writeback rate, we should be writing back faster so that
> the bursts can hit the transaction reservation fast path for
> longer...
> 

(Sorry for the delayed response. I ended up on leave before getting to
this and had to catch back up).

Sure, this is all characteristic of the current AIL pushing mechanism.
The objective above was just to identify how an external component
(dfops) could determine when to efficiently relog a particular item
pinned by the AIL without having to resort to guessing or crude roll
counts, etc. The solution is to essentially reuse AIL logic (flaws and
all) to reasonably determine whether the associated item is pinning the
tail against push pressure. If there's reason to significantly rework
the fundamental AIL pushing mechanism, this use case can most likely
pick up and continue to reuse whatever logic results from that without
much trouble.

> IOWs, I'd like to see the AIL move more towards a mechanism that
> balances a time-averaged rate of inserts (journal checkpoint
> completions) with a time-averaged rate of removals (metadata IO
> completions) rather than working to a free fixed space target.
> If the workload is sustained, then this effective ends up the same
> as we have now with transactions waiting for log reservation space,
> but we should end up draining the AIL down further when than we
> currently do when incoming work tails off.
> 

I'm not quite sure I follow... what this basically sounds like is we'd
have some insert side tracking calculating and storing a running rate of
something like 'items inserted per second' somewhere in the xfs_ail, and
then rather than simply receiving a push target, xfsaild becomes a bit
more self-deterministic and uses that current insert rate to set or
adjust the push target itself. Or perhaps does so based on an analogous
tail moving rate.. hm?

I guess I can see how the mechanics of something like that would work,
but I'm not totally clear on what the rate and translation to push
target would look like. For one, items and checkpoints are arbitrary
sizes, so it seems that something based on consumed log space (i.e.
bytes) might be more accurate. Inserts can also move (i.e. relog) items
that are already AIL resident, so that should be considered somehow
(does it affect the rate?). The current scheme also incorporates log
reservation, which seems like a critical factor since it depends on free
log space. It's not clear to me how an I/O based insert rate alone might
encapsulate all of that, but I'm sure I'm missing much of the bigger
picture..

> I suspect that we could work into this a "need to be relogged within
> X seconds" trigger for active reloggable items in the AIL, such that
> if the top layer deferops sees the flag set on any item in the
> processing of the deferops it relogs all the reloggable items in the
> current set...
> 

Right.. I haven't gone back and reviewed the earlier discussion, but I'm
pretty sure we considered such a flag for the current approach. That it
wasn't necessary atm was just an implementation detail because the
current push logic operates with fixed LSNs and the log item knows its
place in the log...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 


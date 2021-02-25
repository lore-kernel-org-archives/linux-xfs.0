Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E430C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 13:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C6F864F0A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 13:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhBYNNw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 08:13:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229548AbhBYNNs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 08:13:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614258737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BqwDSY9kJxx6mHrQooAxOdpv78v22IWHIp43wL8/dgc=;
        b=YW+G2AXpUH0vXQ6uqlEtkekvmotJ8taloc2T/c/HhSfnqZ2GgGWmEv6Sbjdt+MQrINWTw4
        2B8lczBkbC9xsEIHh1rKAEOIc1jIs+hem+DTbG7vL3h+REmGGXJZBCdTP1utHeUviSZkzc
        9HExxWcT66d3pAo00tdgmRFXI5GK8OM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-ILHQPz5YMjC3KQbjm8_kmw-1; Thu, 25 Feb 2021 08:12:15 -0500
X-MC-Unique: ILHQPz5YMjC3KQbjm8_kmw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76070801978;
        Thu, 25 Feb 2021 13:12:14 +0000 (UTC)
Received: from bfoster (ovpn-113-120.rdu2.redhat.com [10.10.113.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 05A145C234;
        Thu, 25 Feb 2021 13:12:13 +0000 (UTC)
Date:   Thu, 25 Feb 2021 08:12:12 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: AIL needs asynchronous CIL forcing
Message-ID: <YDeiLOdFhIMJegWZ@bfoster>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-3-david@fromorbit.com>
 <20210224211058.GA4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224211058.GA4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 08:10:58AM +1100, Dave Chinner wrote:
> On Tue, Feb 23, 2021 at 04:32:11PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The AIL pushing is stalling on log forces when it comes across
> > pinned items. This is happening on removal workloads where the AIL
> > is dominated by stale items that are removed from AIL when the
> > checkpoint that marks the items stale is committed to the journal.
> > This results is relatively few items in the AIL, but those that are
> > are often pinned as directories items are being removed from are
> > still being logged.
> > 
> > As a result, many push cycles through the CIL will first issue a
> > blocking log force to unpin the items. This can take some time to
> > complete, with tracing regularly showing push delays of half a
> > second and sometimes up into the range of several seconds. Sequences
> > like this aren't uncommon:
> > 
> > ....
> >  399.829437:  xfsaild: last lsn 0x11002dd000 count 101 stuck 101 flushing 0 tout 20
> > <wanted 20ms, got 270ms delay>
> >  400.099622:  xfsaild: target 0x11002f3600, prev 0x11002f3600, last lsn 0x0
> >  400.099623:  xfsaild: first lsn 0x11002f3600
> >  400.099679:  xfsaild: last lsn 0x1100305000 count 16 stuck 11 flushing 0 tout 50
> > <wanted 50ms, got 500ms delay>
> >  400.589348:  xfsaild: target 0x110032e600, prev 0x11002f3600, last lsn 0x0
> >  400.589349:  xfsaild: first lsn 0x1100305000
> >  400.589595:  xfsaild: last lsn 0x110032e600 count 156 stuck 101 flushing 30 tout 50
> > <wanted 50ms, got 460ms delay>
> >  400.950341:  xfsaild: target 0x1100353000, prev 0x110032e600, last lsn 0x0
> >  400.950343:  xfsaild: first lsn 0x1100317c00
> >  400.950436:  xfsaild: last lsn 0x110033d200 count 105 stuck 101 flushing 0 tout 20
> > <wanted 20ms, got 200ms delay>
> >  401.142333:  xfsaild: target 0x1100361600, prev 0x1100353000, last lsn 0x0
> >  401.142334:  xfsaild: first lsn 0x110032e600
> >  401.142535:  xfsaild: last lsn 0x1100353000 count 122 stuck 101 flushing 8 tout 10
> > <wanted 10ms, got 10ms delay>
> >  401.154323:  xfsaild: target 0x1100361600, prev 0x1100361600, last lsn 0x1100353000
> >  401.154328:  xfsaild: first lsn 0x1100353000
> >  401.154389:  xfsaild: last lsn 0x1100353000 count 101 stuck 101 flushing 0 tout 20
> > <wanted 20ms, got 300ms delay>
> >  401.451525:  xfsaild: target 0x1100361600, prev 0x1100361600, last lsn 0x0
> >  401.451526:  xfsaild: first lsn 0x1100353000
> >  401.451804:  xfsaild: last lsn 0x1100377200 count 170 stuck 22 flushing 122 tout 50
> > <wanted 50ms, got 500ms delay>
> >  401.933581:  xfsaild: target 0x1100361600, prev 0x1100361600, last lsn 0x0
> > ....
> > 
> > In each of these cases, every AIL pass saw 101 log items stuck on
> > the AIL (pinned) with very few other items being found. Each pass, a
> > log force was issued, and delay between last/first is the sleep time
> > + the sync log force time.
> > 
> > Some of these 101 items pinned the tail of the log. The tail of the
> > log does slowly creep forward (first lsn), but the problem is that
> > the log is actually out of reservation space because it's been
> > running so many transactions that stale items that never reach the
> > AIL but consume log space. Hence we have a largely empty AIL, with
> > long term pins on items that pin the tail of the log that don't get
> > pushed frequently enough to keep log space available.
> > 
> > The problem is the hundreds of milliseconds that we block in the log
> > force pushing the CIL out to disk. The AIL should not be stalled
> > like this - it needs to run and flush items that are at the tail of
> > the log with minimal latency. What we really need to do is trigger a
> > log flush, but then not wait for it at all - we've already done our
> > waiting for stuff to complete when we backed off prior to the log
> > force being issued.
> > 
> > Even if we remove the XFS_LOG_SYNC from the xfs_log_force() call, we
> > still do a blocking flush of the CIL and that is what is causing the
> > issue. Hence we need a new interface for the CIL to trigger an
> > immediate background push of the CIL to get it moving faster but not
> > to wait on that to occur. While the CIL is pushing, the AIL can also
> > be pushing.
> > 
> > We already have an internal interface to do this -
> > xlog_cil_push_now() - but we need a wrapper for it to be used
> > externally. xlog_cil_force_seq() can easily be extended to do what
> > we need as it already implements the synchronous CIL push via
> > xlog_cil_push_now(). Add the necessary flags and "push current
> > sequence" semantics to xlog_cil_force_seq() and convert the AIL
> > pushing to use it.
> 
> Overnight testing indicates generic/530 hangs on small logs with
> this patch. It essentially runs out of log space because there are
> inode cluster buffers permanently pinned by this workload.
> 
> That is, as inodes are unlinked, they repeatedly relog the inode
> cluster buffer, and so while the CIL is flushing to unpin the
> buffer, a new unlink relogs it and adds a new pin to the buffer.
> Hence the log force that the AIL does to unpin pinned items doesn't
> actually unpin buffers that are being relogged.
> 
> These buffers only get unpinned when the log actually runs out of
> space because they pin the tail of the log. Then the modifications
> that are relogging the buffer stop because they fail to get a log
> reservation, and the tail of the log does not move forward until the
> AIL issues a log force that finally unpins the buffer and writes it
> back.
> 
> Essentially, relogged buffers cannot be flushed by the AIL until the
> log completely stalls.
> 
> The problem being tripped over here is that we no longer force the
> final iclogs in a CIL push to disk - we leave the iclog with the
> commit record in it in ACTIVE state, and by not waiting and forcing
> all the iclogs to disk, the buffer never gets unpinned because there
> isn't any more log pressure to force it out because everything is
> blocked on reservation space.
> 
> The solution to this is to have the CIL push change the state of the
> commit iclog to WANT_SYNC before it is released. This means the CIL
> push will always flush the iclog to disk and the checkpoint will
> complete and unpin the buffers.
> 
> Right now, we really only want to do this state switch for these
> async pushes - for small sync transactions and fsync we really want
> the iclog aggregation that we have now to optimise iclogbuf usage,
> so I'll have to pass a new flag through the push code and back into
> xlog_write(). That will make this patch behave the same as we
> currently do.
> 

Unfortunately I've not yet caught up to reviewing your most recently
posted set of log patches so I can easily be missing some context, but
when passing through some of the feedback/updates so far this has me
rather confused. We discussed this pre-existing CIL behavior in the
previous version, I suggested some similar potential behavior change
where we would opportunistically send off checkpoint iclogs for I/O a
bit earlier than normal and you argued [1] against it. Now it sounds
like not only are we implementing that, but it's actually necessary to
fix a log hang problem..? What am I missing?

The updated iclog behavior does sound more friendly to me than what we
currently do (obviously, based on my previous comments), but I am
slightly skeptical of how such a change fixes the root cause of a hang.
Is this a stall/perf issue or an actual log deadlock? If the latter,
what prevents this deadlock on current upstream?

Brian

[1] https://lore.kernel.org/linux-xfs/20210129222559.GT4662@dread.disaster.area/

> In the longer term, we need to change how the AIL deals with pinned
> buffers, as the current method is definitely sub-optimal. It also
> explains the "everything stops for a second" performance anomalies
> I've been seeing for a while in testing. But fixing that is outside
> the scope of this patchset, so in the mean time I'll fix this one up
> and repost it in a little while.
> 
> FWIW, this is also the likely cause of the "CIL workqueue too deep"
> hangs I was seeing with the next patch in the series, too.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 


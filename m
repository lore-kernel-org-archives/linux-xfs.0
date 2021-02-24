Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F195C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC8EF64F03
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhBXVLp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:11:45 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:54871 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229886AbhBXVLm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 16:11:42 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 803B61ADE1C
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 08:10:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF1Qw-002iFi-J7
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 08:10:58 +1100
Date:   Thu, 25 Feb 2021 08:10:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: AIL needs asynchronous CIL forcing
Message-ID: <20210224211058.GA4662@dread.disaster.area>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223053212.3287398-3-david@fromorbit.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=fANzahRz4QIE9oshsjYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 04:32:11PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The AIL pushing is stalling on log forces when it comes across
> pinned items. This is happening on removal workloads where the AIL
> is dominated by stale items that are removed from AIL when the
> checkpoint that marks the items stale is committed to the journal.
> This results is relatively few items in the AIL, but those that are
> are often pinned as directories items are being removed from are
> still being logged.
> 
> As a result, many push cycles through the CIL will first issue a
> blocking log force to unpin the items. This can take some time to
> complete, with tracing regularly showing push delays of half a
> second and sometimes up into the range of several seconds. Sequences
> like this aren't uncommon:
> 
> ....
>  399.829437:  xfsaild: last lsn 0x11002dd000 count 101 stuck 101 flushing 0 tout 20
> <wanted 20ms, got 270ms delay>
>  400.099622:  xfsaild: target 0x11002f3600, prev 0x11002f3600, last lsn 0x0
>  400.099623:  xfsaild: first lsn 0x11002f3600
>  400.099679:  xfsaild: last lsn 0x1100305000 count 16 stuck 11 flushing 0 tout 50
> <wanted 50ms, got 500ms delay>
>  400.589348:  xfsaild: target 0x110032e600, prev 0x11002f3600, last lsn 0x0
>  400.589349:  xfsaild: first lsn 0x1100305000
>  400.589595:  xfsaild: last lsn 0x110032e600 count 156 stuck 101 flushing 30 tout 50
> <wanted 50ms, got 460ms delay>
>  400.950341:  xfsaild: target 0x1100353000, prev 0x110032e600, last lsn 0x0
>  400.950343:  xfsaild: first lsn 0x1100317c00
>  400.950436:  xfsaild: last lsn 0x110033d200 count 105 stuck 101 flushing 0 tout 20
> <wanted 20ms, got 200ms delay>
>  401.142333:  xfsaild: target 0x1100361600, prev 0x1100353000, last lsn 0x0
>  401.142334:  xfsaild: first lsn 0x110032e600
>  401.142535:  xfsaild: last lsn 0x1100353000 count 122 stuck 101 flushing 8 tout 10
> <wanted 10ms, got 10ms delay>
>  401.154323:  xfsaild: target 0x1100361600, prev 0x1100361600, last lsn 0x1100353000
>  401.154328:  xfsaild: first lsn 0x1100353000
>  401.154389:  xfsaild: last lsn 0x1100353000 count 101 stuck 101 flushing 0 tout 20
> <wanted 20ms, got 300ms delay>
>  401.451525:  xfsaild: target 0x1100361600, prev 0x1100361600, last lsn 0x0
>  401.451526:  xfsaild: first lsn 0x1100353000
>  401.451804:  xfsaild: last lsn 0x1100377200 count 170 stuck 22 flushing 122 tout 50
> <wanted 50ms, got 500ms delay>
>  401.933581:  xfsaild: target 0x1100361600, prev 0x1100361600, last lsn 0x0
> ....
> 
> In each of these cases, every AIL pass saw 101 log items stuck on
> the AIL (pinned) with very few other items being found. Each pass, a
> log force was issued, and delay between last/first is the sleep time
> + the sync log force time.
> 
> Some of these 101 items pinned the tail of the log. The tail of the
> log does slowly creep forward (first lsn), but the problem is that
> the log is actually out of reservation space because it's been
> running so many transactions that stale items that never reach the
> AIL but consume log space. Hence we have a largely empty AIL, with
> long term pins on items that pin the tail of the log that don't get
> pushed frequently enough to keep log space available.
> 
> The problem is the hundreds of milliseconds that we block in the log
> force pushing the CIL out to disk. The AIL should not be stalled
> like this - it needs to run and flush items that are at the tail of
> the log with minimal latency. What we really need to do is trigger a
> log flush, but then not wait for it at all - we've already done our
> waiting for stuff to complete when we backed off prior to the log
> force being issued.
> 
> Even if we remove the XFS_LOG_SYNC from the xfs_log_force() call, we
> still do a blocking flush of the CIL and that is what is causing the
> issue. Hence we need a new interface for the CIL to trigger an
> immediate background push of the CIL to get it moving faster but not
> to wait on that to occur. While the CIL is pushing, the AIL can also
> be pushing.
> 
> We already have an internal interface to do this -
> xlog_cil_push_now() - but we need a wrapper for it to be used
> externally. xlog_cil_force_seq() can easily be extended to do what
> we need as it already implements the synchronous CIL push via
> xlog_cil_push_now(). Add the necessary flags and "push current
> sequence" semantics to xlog_cil_force_seq() and convert the AIL
> pushing to use it.

Overnight testing indicates generic/530 hangs on small logs with
this patch. It essentially runs out of log space because there are
inode cluster buffers permanently pinned by this workload.

That is, as inodes are unlinked, they repeatedly relog the inode
cluster buffer, and so while the CIL is flushing to unpin the
buffer, a new unlink relogs it and adds a new pin to the buffer.
Hence the log force that the AIL does to unpin pinned items doesn't
actually unpin buffers that are being relogged.

These buffers only get unpinned when the log actually runs out of
space because they pin the tail of the log. Then the modifications
that are relogging the buffer stop because they fail to get a log
reservation, and the tail of the log does not move forward until the
AIL issues a log force that finally unpins the buffer and writes it
back.

Essentially, relogged buffers cannot be flushed by the AIL until the
log completely stalls.

The problem being tripped over here is that we no longer force the
final iclogs in a CIL push to disk - we leave the iclog with the
commit record in it in ACTIVE state, and by not waiting and forcing
all the iclogs to disk, the buffer never gets unpinned because there
isn't any more log pressure to force it out because everything is
blocked on reservation space.

The solution to this is to have the CIL push change the state of the
commit iclog to WANT_SYNC before it is released. This means the CIL
push will always flush the iclog to disk and the checkpoint will
complete and unpin the buffers.

Right now, we really only want to do this state switch for these
async pushes - for small sync transactions and fsync we really want
the iclog aggregation that we have now to optimise iclogbuf usage,
so I'll have to pass a new flag through the push code and back into
xlog_write(). That will make this patch behave the same as we
currently do.

In the longer term, we need to change how the AIL deals with pinned
buffers, as the current method is definitely sub-optimal. It also
explains the "everything stops for a second" performance anomalies
I've been seeing for a while in testing. But fixing that is outside
the scope of this patchset, so in the mean time I'll fix this one up
and repost it in a little while.

FWIW, this is also the likely cause of the "CIL workqueue too deep"
hangs I was seeing with the next patch in the series, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

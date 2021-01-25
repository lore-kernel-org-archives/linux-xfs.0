Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D499C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44F56229C4
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731811AbhAZFTM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:19:12 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:58203 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731667AbhAZC03 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 21:26:29 -0500
Received: from dread.disaster.area (pa49-180-243-77.pa.nsw.optusnet.com.au [49.180.243.77])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 918CC106B88
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jan 2021 10:58:57 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l4Bl2-002PKu-Ml
        for linux-xfs@vger.kernel.org; Tue, 26 Jan 2021 10:58:56 +1100
Date:   Tue, 26 Jan 2021 10:58:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: Musings over REQ_PREFLUSH and REQ_FUA in journal IO
Message-ID: <20210125235856.GH4662@dread.disaster.area>
References: <20210125061422.GF4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125061422.GF4662@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=juxvdbeFDU67v5YkIhU0sw==:117 a=juxvdbeFDU67v5YkIhU0sw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=7-415B0cAAAA:8
        a=AHKhnjCwuecWepyCLLsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 05:14:22PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> I've been thinking a little about the way we write use cache flushes
> recently and I was thinking about how we do journal writes and
> whether we need to issue as many cache flushes as we currently do.

....

> And then I woundered if we could apply the same logic to
> post-journal write cache flushes (REQ_FUA) that guarantee that the
> journal writes are stable before we allow writeback of the metadata
> in that LSN range (i.e. once they are unpinned). Again, we have a
> completion to submission ordering requirement here, only this time
> it is journal IO completion to metadata IO submission.
> 
> IOWs, I think the same observation about the log head and the AIL
> writeback mechanism can be made here: we only need to ensure a cache
> flush occurs before we start writing back metadata at an LSN higher
> than the journal head at the time of the last cache flush. The first
> iclog write of last CIL checkpoint will have ensured all
> metadata lower than the LSN of the CIL checkpoint is stable, hence
> we only need to concern ourselves about metadata at the same LSN as
> that checkpoint. checkpoint completion will unpin that metadata, but
> we still need a cache flush to guarantee ordering at the stable
> storage level.
> 
> Hence we can use an on-demand AIL traversal cache flush to ensure
> we have journal-to-metadata ordering. This will be much rarer than
> every using FUA for every iclog write, and should be of similar
> order of gains to the REQ_PREFLUSH optimisation.
> 
> FWIW, because we use checksums to detect complete checkpoints in
> the journal now, we don't actually need to use FUA writes to
> guarantee they hit stable storage. We don't have a guarantee in what
> order they will hit the disk (even with FUA), so the only thing that
> the FUA write gains us is that on some hardware it elides the need
> for a post-write cache flush. Hence I don't think we need REQ_FUA,
> either.

I think that this can be greatly simplified. We simply us
REQ_PREFLUSH | REQ_FUA on all commit records that close off a
transaction. The pre-flush can be used to guarantee that all the
preceeding log writes have completed to the journal, then the commit
record is written w/ FUA, guaranteeing the entire checkpoint is on
stable storage before we run the checkpoint completion callbacks
that unpin the dirty items and insert them into the AIL. This means
we don't need to modify the AIL at all, and all the metadata vs
journal ordering is still maintained entirely within the journal.

The only additional complexity is that we have to separate the
commit record into a new iclog from the rest of the checkpoint,
unless the checkpoint fits entirely inside a single iclog. I don't
think this is hard to do - we can probably do it once we've written
the commit record and hold a reference to the iclog the commit
record was written to that prevents it from being flushed until
we release the reference to it.

> The only explicit ordering we really have are log forces. As long as
> log forces issue a cache flush when they are left pending by CIL
> transaction completion, we shouldn't require anything more here. The
> situation is similar to the AIL requirement...

This won't a concern with the above change, because the commit
mechanism provides the same guarantees about stable journal contents
as it does now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

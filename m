Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15808C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 09:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243002AbiCPJzz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 05:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355006AbiCPJzy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 05:55:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C76535276
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 02:54:39 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 35ABD1F38A;
        Wed, 16 Mar 2022 09:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1647424478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Sx3/aEouzL4UY35fhJnrFwM9FOVEV2nm+iUnDNRFeU=;
        b=2U/sX3G+9S/WaAmhflsKFO82VH1zsAsK5EA0FALtVc5wMiYdBDALxk239AO4IkB/BdfjFb
        +WPn6mUEK54UOJmRHIznjoO/dCeBGzta7NZN4nLwLA91Zv3sY916XEBI/ogpyg5vwZf6/a
        JSDfHVN22AGmZDA5pcXwThED8nO5Lwg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1647424478;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Sx3/aEouzL4UY35fhJnrFwM9FOVEV2nm+iUnDNRFeU=;
        b=/pTnFr4qtUxhA6Vw/2FqfqvDOtWYWHivl54au9Gi92tDpxfe6f1UQIDuMej4uZ89fMjY4P
        Ga6/FV4UmAwsB7Dg==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 12B0BA3B83;
        Wed, 16 Mar 2022 09:54:38 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 96D38A0615; Wed, 16 Mar 2022 10:54:37 +0100 (CET)
Date:   Wed, 16 Mar 2022 10:54:37 +0100
From:   Jan Kara <jack@suse.cz>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: Regression in XFS for fsync heavy workload
Message-ID: <20220316095437.ogwo2fxfpddaerie@quack3.lan>
References: <20220315124943.wtgwrrkuthnwto7w@quack3.lan>
 <20220316010627.GO3927073@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316010627.GO3927073@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed 16-03-22 12:06:27, Dave Chinner wrote:
> On Tue, Mar 15, 2022 at 01:49:43PM +0100, Jan Kara wrote:
> > Hello,
> > 
> > I was tracking down a regression in dbench workload on XFS we have
> > identified during our performance testing. These are results from one of
> > our test machine (server with 64GB of RAM, 48 CPUs, SATA SSD for the test
> > disk):
> > 
> > 			       good		       bad
> > Amean     1        64.29 (   0.00%)       73.11 * -13.70%*
> > Amean     2        84.71 (   0.00%)       98.05 * -15.75%*
> > Amean     4       146.97 (   0.00%)      148.29 *  -0.90%*
> > Amean     8       252.94 (   0.00%)      254.91 *  -0.78%*
> > Amean     16      454.79 (   0.00%)      456.70 *  -0.42%*
> > Amean     32      858.84 (   0.00%)      857.74 (   0.13%)
> > Amean     64     1828.72 (   0.00%)     1865.99 *  -2.04%*
> > 
> > Note that the numbers are actually times to complete workload, not
> > traditional dbench throughput numbers so lower is better.
> 
> How does this work? Dbench is a fixed time workload - the only
> variability from run to run is the time it takes to run the cleanup
> phase. Is this some hacked around version of dbench?

Yes, dbench is a fixed time workload but in fact there is the workload file
that gets executed in a loop. We run a modified version of dbench
(https://github.com/mcgrof/dbench) which also reports time spent by each
execution of the workload file (--show-execute-time option), which has much
better statistical properties than throughput reported by dbench normally
(which is for example completely ignorant of metadata operations and that
leads to big fluctuations in reported numbers especially for high client
counts).

> > Eventually I have
> > tracked down the problem to commit bad77c375e8d ("xfs: CIL checkpoint
> > flushes caches unconditionally").  Before this commit we submit ~63k cache
> > flush requests during the dbench run, after this commit we submit ~150k
> > cache flush requests. And the additional cache flushes are coming from
> > xlog_cil_push_work().
> 
> Yup, that was a known trade-off with this series of changes to the
> REQ_FLUSH/REQ_FUA behaviour of the CIL - fsync heavy workloads could
> see higher cache flush counts, and low concurrency rates would see
> that as increased runtime because there isn't the journal write load
> needed to compeltely mitigate the impact of more frequent cache
> flushes.
> 
> The trade-off is, OTOH, that other workloads see 10-1000x lower cache
> flush rates when streaming large CIL checkpoints through the log as
> fast as it can issue sequential IO to the disk. e.g. a 32MB CIL
> threshold (>256MB journal) with 32KB iclogbuf size (default) on an
> async workload will write ~1000 iclogs to flush a 32MB CIL
> checkpoint. Prior to this series, every one of those iclog writes
> would be issued as REQ_FLUSH|REQ_FUA. After this patch series,
> we do a REQ_FLUSH from xfs_flush_bdev_async(), the first iclog is
> REQ_FUA, and the last iclog is REQ_FLUSH|REQ_FUA. IOW, we reduce
> the number of FUA + cache flushes by 3 orders or magnitude for these
> cases....
> 
> There's a heap more detail of the changes and the complexity in
> the commit message for the commit two patches further along in
> that series where these benefits are realised - see commit
> eef983ffeae7 ("xfs: journal IO cache flush reductions") for more
> details.
> 
> When doing this work, I didn't count cache flushes. What I looked at
> was the number of log forces vs the number of sleeps waiting on log
> forces vs log writes vs the number of stalls waiting for log writes.
> These numbers showed improvements across the board, so any increase
> in overhead from physical cache flushes was not reflected in the
> throughput increases I was measuring at the "fsync drives log
> forces" level.

Thanks for detailed explanation! I'd just note that e.g. for a machine with
8 CPUs, 32 GB of Ram and Intel SSD behind a megaraid_sas controller (it is
some Dell PowerEdge server) we see even larger regressions like:

                    good                      bad
Amean 	1	97.93	( 0.00%)	135.67	( -38.54%)
Amean 	2	147.69	( 0.00%)	194.82	( -31.91%)
Amean 	4	242.82	( 0.00%)	352.98	( -45.36%)
Amean 	8	375.36	( 0.00%)	591.03	( -57.45%)

I didn't investigate on this machine (it was doing some other tests and I
had another machine in my hands which also showed some, although smaller,
regression) but now reading your explanations I'm curious why the
regression grows with number of threads on that machine. Maybe the culprit
is different there or just the dynamics isn't as we imagine it on that
storage controller... I guess I'll borrow the machine and check it.

> > The reason as far as I understand it is that
> > xlog_cil_push_work() never actually ends up writing the iclog (I can see
> > this in the traces) because it is writing just very small amounts (my
> > debugging shows xlog_cil_push_work() tends to add 300-1000 bytes to iclog,
> > 4000 bytes is the largest number I've seen) and very frequent fsync(2)
> > calls from dbench always end up forcing iclog before it gets filled. So the
> > cache flushes issued by xlog_cil_push_work() are just pointless overhead
> > for this workload AFAIU.
> 
> It's not quite that straight forward.
> 
> Keep in mind that the block layer is supposed to merge new flush
> requests that occur while there is still a flush in progress. hence
> the only time this async flush should cause extra flush requests to
> physically occur unless you have storage that either ignores flush
> requests (in which case we don't care because bio_submit() aborts
> real quick) or is really, really fast and so cache flush requests
> complete before we start hitting the block layer merge case or
> slowing down other IO.  If storage is slow and there's any amoutn of
> concurrency, then we're going to be waiting on merged flush requests
> in the block layer if there's any amount of concurrency, so the
> impact is fairly well bound there, too.
>
> Hence cache flush latency is only going to impact on very
> low concurrency workloads where any additional wait time directly
> translates to reduced throughput. That's pretty much what your
> numbers indicate, too.

Yes, for higher thread counts I agree flush merging should mitigate the
impact. But note that there is still some overhead of additional flushes
because the block layer will merge only with flushes that are queued and
not yet issued to the device. If there is flush in progress, new flush will
be queued and will get submitted once the first one completes. It is only
the third flush that gets merged to the second one.

> > This should still
> > submit it rather early to provide the latency advantage. Otherwise postpone
> > the flush to the moment we know we are going to flush the iclog to save
> > pointless flushes. But we would have to record whether the flush happened
> > or not in the iclog and it would all get a bit hairy...
> 
> I think we can just set the NEED_FLUSH flag appropriately.
> 
> However, given all this, I'm wondering if the async cache flush was
> really a case of premature optimisation. That is, we don't really
> gain anything by reducing the flush latency of the first iclog write
> wehn we are writing 100-1000 iclogs before the commit record, and it
> can be harmful to some workloads by issuing more flushes than we
> need to.
> 
> So perhaps the right thing to do is just get rid of it and always
> mark the first iclog in a checkpoint as NEED_FLUSH....
> 
> > I'm definitely not
> > an expert in XFS logging code so that's why I'm just writing here my
> > current findings if people have some ideas.
> 
> Thanks for running the tests and doing some investigation, Jan. We
> should be able to mitigate some of this impact, so let me run a
> couple of experiments here and I'll get back to you.

Cool, thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

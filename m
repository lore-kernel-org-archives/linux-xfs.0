Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D84C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 21:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A6F5206DD
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 21:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgJOVdu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 17:33:50 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39156 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726696AbgJOVdt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 17:33:49 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E205A58C728;
        Fri, 16 Oct 2020 08:33:45 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kTAsb-000v8o-8i; Fri, 16 Oct 2020 08:33:45 +1100
Date:   Fri, 16 Oct 2020 08:33:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/27] libxfs: add a buftarg cache shrinker implementation
Message-ID: <20201015213345.GJ7391@dread.disaster.area>
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-25-david@fromorbit.com>
 <20201015180141.GZ9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015180141.GZ9832@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=mOkLObkkJP7xtPHCCvcA:9 a=EVvicIIz3P5FW3-7:21 a=iyi2_4OjNmh-gyfn:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 11:01:41AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 15, 2020 at 06:21:52PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add a list_lru scanner that runs from the memory pressure detection
> > to free an amount of the buffer cache that will keep the cache from
> > growing when there is memory pressure.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  libxfs/buftarg.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 51 insertions(+)
> > 
> > diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
> > index 6c7142d41eb1..8332bf3341b6 100644
> > --- a/libxfs/buftarg.c
> > +++ b/libxfs/buftarg.c
> > @@ -62,6 +62,19 @@ xfs_buftarg_setsize_early(
> >  	return xfs_buftarg_setsize(btp, bsize);
> >  }
> >  
> > +static void
> > +dispose_list(
> > +	struct list_head	*dispose)
> > +{
> > +	struct xfs_buf		*bp;
> > +
> > +	while (!list_empty(dispose)) {
> > +		bp = list_first_entry(dispose, struct xfs_buf, b_lru);
> > +		list_del_init(&bp->b_lru);
> > +		xfs_buf_rele(bp);
> > +	}
> > +}
> > +
> >  /*
> >   * Scan a chunk of the buffer cache and drop LRU reference counts. If the
> >   * count goes to zero, dispose of the buffer.
> > @@ -70,6 +83,13 @@ static void
> >  xfs_buftarg_shrink(
> >  	struct xfs_buftarg	*btc)
> >  {
> > +	struct list_lru		*lru = &btc->bt_lru;
> > +	struct xfs_buf		*bp;
> > +	int			count;
> > +	int			progress = 16384;
> > +	int			rotate = 0;
> > +	LIST_HEAD(dispose);
> > +
> >  	/*
> >  	 * Make the fact we are in memory reclaim externally visible. This
> >  	 * allows buffer cache allocation throttling while we are trying to
> > @@ -79,6 +99,37 @@ xfs_buftarg_shrink(
> >  
> >  	fprintf(stderr, "Got memory pressure event. Shrinking caches!\n");
> >  
> > +	spin_lock(&lru->l_lock);
> > +	count = lru->l_count / 50;	/* 2% */
> 
> If I'm reading this correctly, we react to a memory pressure event by
> trying to skim 2% of the oldest disposable buffers off the buftarg LRU?
> And every 16384 loop iterations we'll dispose the list even if we
> haven't gotten our 2% yet?  How did you arrive at 2%?

Yup, 2% was the number I came up with. It's a trade-off between
scanning enough to keep the cache growth in check but not so much as
to trash the entire cache as stall events roll in. Also, the PSI
monitor will report at most 1 event per second with the current
config, so the amount of work the shrinker does doesn't need to
consume lots of time.

The system I was testing on ended up OOMing at around 1.2M cached
buffers. Hence each invocation was scanning ~25-30k buffers every
invocation. This was sufficient to control memory usage, without the
PSI stall event tail trashing the cache once repair-triggered memory
pressure had been brought under control

The "progress" thing is just a way of batching up the work so that
we free memory sooner. THe number of 16384 was from when I was
discovering how this behaved and I was trimming up to 50% of the
cache in a singel event. I needed some kind of progress indicaction
while it stalled for seconds freeing memory. It may stay, it may go.
We'll see.

> (Also, I'm assuming that some of these stderr printfs will at some point
> get turned into tracepoints or dbg_printf or the like?)

Maybe. I would prefer the tracepoint model over dbg_printf(), but
that's not something I'm thinking about right now...

Note that this shrinker does not rotate buffers by default. The
kernel rotates buffers once through the LRU before they are
reclaimed. If I try to do that with PSI events, then we OOM kill
because the system is completely out of memory by the time 5-6
events have been delivered and then we get OOM killed. Hence it
reclaims immediately, but that can be tuned for repair by converting
the cache priorities for buffers in LRU references...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

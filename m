Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19134C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 21:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD27D2076A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 21:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgJOVUZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 17:20:25 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38315 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbgJOVUZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 17:20:25 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 33B0758C6BE;
        Fri, 16 Oct 2020 08:20:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kTAfe-000uqv-3d; Fri, 16 Oct 2020 08:20:22 +1100
Date:   Fri, 16 Oct 2020 08:20:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/27] libxfs: use PSI information to detect memory
 pressure
Message-ID: <20201015212022.GI7391@dread.disaster.area>
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-24-david@fromorbit.com>
 <20201015175611.GY9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015175611.GY9832@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=7-415B0cAAAA:8
        a=OR8kNt25WPBK8Lc6AbQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 10:56:11AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 15, 2020 at 06:21:51PM +1100, Dave Chinner wrote:
> > @@ -74,6 +196,8 @@ xfs_buftarg_alloc(
> >  	btp->bt_mount = mp;
> >  	btp->bt_fd = libxfs_device_to_fd(bdev);
> >  	btp->bt_bdev = bdev;
> > +	btp->bt_psi_fd = -1;
> > +	btp->bt_exiting = false;
> >  
> >  	if (xfs_buftarg_setsize_early(btp))
> >  		goto error_free;
> > @@ -84,8 +208,13 @@ xfs_buftarg_alloc(
> >  	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
> >  		goto error_lru;
> >  
> > +	if (xfs_buftarg_mempressue_init(btp))
> 
> So what happens if PSI isn't enabled or procfs isn't mounted yet?
> xfs_repair just ... fails?  That seems disappointing, particularly if
> the admin is trying to fix a dead root fs from the initramfs premount
> shell and /proc isn't set up yet.

Yes, right now it just fails. I'm more interested right now in
getting the new infrastructure working such that the kernel buffer
cache "just works" when there's more metadata than RAM to cache it
in.

> Hmm, looks like Debian actually /does/ set up procfs nowadays.  Still,
> if we're going to add a hard requirement on CONFIG_PSI=y and
> CONFIG_PSI_DEFAULT_DISABLED=n, we need to advertise this kind of loudly.
> 
> (Personally, I thought that if there's no pressure stall information,
> we'd just fall back to not having a shrinker and daring the system to
> OOM us like it does now...)

Well, the existing buffer cache does have a shrinker mechanism - it
will shake the cache down when it is full to free up old buffers.
That's what all the MRU lists and buffer priority stuff in the
repair prefetch code is all about.

repair tries to bound the maximum size of the buffer cache and
prevent OOM that way. If it calculates that the memory requirement
is larger than RAM, that's when it gets into OOM trouble because we
still allow it to use lots of memory and then just hope...

I kind of want to get away from all those messy static heuristics.
I'd much prefer that we do dynamic cache growth detection and size
calculations in repair and determine if we should purge the cache at
the end of each AG or retain it in RAM. i.e. if ((per ag cache size
* no. of AGs) > 75% RAM) then purge the AG cache when the phase scan
is done. This way we run with minimal caching (just what is needed
for prefetching to be efficient) when it is likely we can't fit all
the metadata in RAM, and otherwise we behave like we currently do.

That sort of setup will go a long way to avoiding OOM kill and the
need for actual memory shrinkers to activate. This mode could be
activated if the PSI infomration is not there, hence might also
solve most of the rescue situation problems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

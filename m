Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A7EC4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 05:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E40C2080A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 05:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505740AbgJ0FKs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 01:10:48 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53370 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2505739AbgJ0FKs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 01:10:48 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C4C6F58C2B3;
        Tue, 27 Oct 2020 16:10:44 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kXHFs-004lvr-0j; Tue, 27 Oct 2020 16:10:44 +1100
Date:   Tue, 27 Oct 2020 16:10:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] repair: parallelise phase 6
Message-ID: <20201027051044.GX7391@dread.disaster.area>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-5-david@fromorbit.com>
 <20201022061100.GP9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022061100.GP9832@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=7-415B0cAAAA:8
        a=HpxCKvZK5xTQ37jq3mEA:9 a=d_ErWXtCQ4raF6eb:21 a=2ZwpKjbOBzK9Dlno:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 21, 2020 at 11:11:00PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 22, 2020 at 04:15:34PM +1100, Dave Chinner wrote:
> > +static void
> > +traverse_function(
> > +	struct workqueue	*wq,
> > +	xfs_agnumber_t		agno,
> > +	void			*arg)
> > +{
> > +	struct ino_tree_node	*irec;
> >  	prefetch_args_t		*pf_args = arg;
> > +	struct workqueue	lwq;
> > +	struct xfs_mount	*mp = wq->wq_ctx;
> > +
> >  
> >  	wait_for_inode_prefetch(pf_args);
> >  
> >  	if (verbose)
> >  		do_log(_("        - agno = %d\n"), agno);
> >  
> > +	/*
> > +	 * The more AGs we have in flight at once, the fewer processing threads
> > +	 * per AG. This means we don't overwhelm the machine with hundreds of
> > +	 * threads when we start acting on lots of AGs at once. We just want
> > +	 * enough that we can keep multiple CPUs busy across multiple AGs.
> > +	 */
> > +	workqueue_create_bound(&lwq, mp, ag_stride, 1000);
> 
> Eeeeee, magic number! :)
> 
> /me tosses in obligatory hand-wringing about 2000 CPU systems running
> out of work.  How about ag_stride * 50 or something? :P

ag_stride already determines concurrency via how many AGs are being
scanned at once. However, it provides no insight into the depth of
the queue we need to use per AG.

What this magic number does is bound how deep the work queue gets
before we ask another worker thread to start also processing the
queue. We've already got async threads doing inode prefetch, so the
bound here throttles the rate at which inodes are
prefetched into the buffer cache. In general, we're going to be IO
bound and waiting on readahead rather than throttling on processing
the inodes, so all this bound is doing is preventing readahead from
running too far ahead of processing and potentially causing cache
thrashing.

However, we don't want to go using lots of threads to parallelise
the work within the AG when we have already parallelised across AGs.
We want the initial worker thread per AG to just keep working away
burning CPU while the prefetch code is blocking waiting for more
inodes from disk. Then we get another burst of work being queued,
and so on.

Hence the queue needs to be quite deep so that we can soak up the
bursts of processing that readahead triggers without asking lots of
worker threads to do work. However, if the worker thread hits some
big directories and starts falling behind readahead, that's when it
will hit the maximum queue depth and kick another thread to do work.

IOWs, the queue depth needs to be deep enough to prevent bursts from
triggering extra workers from running, but shallow enough that extra
workers will be scheduled when processing falls behind readahead.

I really don't have a good way to automatically calculate this
depth. I just figure that if we have a 1000 inodes queued up for
processing, we really should kick another thread to start working on
them. It's a simple solution, so I'd like to see if we have problems
with this simple threshold before we try to replace the magic number
with a magic heuristic....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

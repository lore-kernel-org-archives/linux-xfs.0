Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C09C4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 17:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B00020790
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 17:20:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L6CYm+D2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgJ2RUu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 13:20:50 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56742 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgJ2RUu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 13:20:50 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09THJLUj184719;
        Thu, 29 Oct 2020 17:20:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=yXip/K0ZJ2lKo1Jgu18FzNTQZ3edjpMZgLOeqDOcXks=;
 b=L6CYm+D2aB6DvBxI7XRr8GbNp1l8aHdIxhPUCLia2SbjdaQPBa6iHjxQzHJblZZHm8QP
 iyg0d9gCztFYJMTRAmwK/iZZEuRhzJP+WZRD5byUu+I7sEqsb9+GJ2tUq7Z6kaf6rvJO
 liquxgqSq4yjtcKECu7sKPMkWxJYxYHHM18mtMqBXN7eMtvMmBlA9ZUyTm2P+2GWIXB2
 A4N9Qh96GIH/rlBviMZy8/UNYThmWT6e7/RVgMy2rOhoPkDy8kE7IL9HuR8YKyX5mKby
 366XvN7Pnf/0luqYWUlITUTEkOy1EL/885adgI7qxnyzoL7Y2z3dbPyMOZxocJlbxZDq Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34c9sb680m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 17:20:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09THFSLx148435;
        Thu, 29 Oct 2020 17:20:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34cx6yqhah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 17:20:47 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09THKkn8007508;
        Thu, 29 Oct 2020 17:20:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 10:20:46 -0700
Date:   Thu, 29 Oct 2020 10:20:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] repair: parallelise phase 6
Message-ID: <20201029172045.GP1061252@magnolia>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-5-david@fromorbit.com>
 <20201022061100.GP9832@magnolia>
 <20201027051044.GX7391@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027051044.GX7391@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290120
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 04:10:44PM +1100, Dave Chinner wrote:
> On Wed, Oct 21, 2020 at 11:11:00PM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 22, 2020 at 04:15:34PM +1100, Dave Chinner wrote:
> > > +static void
> > > +traverse_function(
> > > +	struct workqueue	*wq,
> > > +	xfs_agnumber_t		agno,
> > > +	void			*arg)
> > > +{
> > > +	struct ino_tree_node	*irec;
> > >  	prefetch_args_t		*pf_args = arg;
> > > +	struct workqueue	lwq;
> > > +	struct xfs_mount	*mp = wq->wq_ctx;
> > > +
> > >  
> > >  	wait_for_inode_prefetch(pf_args);
> > >  
> > >  	if (verbose)
> > >  		do_log(_("        - agno = %d\n"), agno);
> > >  
> > > +	/*
> > > +	 * The more AGs we have in flight at once, the fewer processing threads
> > > +	 * per AG. This means we don't overwhelm the machine with hundreds of
> > > +	 * threads when we start acting on lots of AGs at once. We just want
> > > +	 * enough that we can keep multiple CPUs busy across multiple AGs.
> > > +	 */
> > > +	workqueue_create_bound(&lwq, mp, ag_stride, 1000);
> > 
> > Eeeeee, magic number! :)
> > 
> > /me tosses in obligatory hand-wringing about 2000 CPU systems running
> > out of work.  How about ag_stride * 50 or something? :P
> 
> ag_stride already determines concurrency via how many AGs are being
> scanned at once. However, it provides no insight into the depth of
> the queue we need to use per AG.
> 
> What this magic number does is bound how deep the work queue gets
> before we ask another worker thread to start also processing the
> queue.

It does?  I didn't think we'd wake up extra worker threads when the
queue depth reached max_queued:

	if (wq->max_queued && wq->next_item) {
		/* more work, wake up another worker */
		pthread_cond_signal(&wq->wakeup);
	}

AFAICT, any time a worker dequeues a work item, observes that we have
a max queue depth, and sees that there's still more work to do, it'll
wake up another worker.

TBH I think this is better for cpu utilization because we should never
have idle workers while there's more work to do.  At least for the scrub
case...

<shrug> Either that or I think I've misunderstood something?

> We've already got async threads doing inode prefetch, so the
> bound here throttles the rate at which inodes are
> prefetched into the buffer cache. In general, we're going to be IO
> bound and waiting on readahead rather than throttling on processing
> the inodes, so all this bound is doing is preventing readahead from
> running too far ahead of processing and potentially causing cache
> thrashing.
> 
> However, we don't want to go using lots of threads to parallelise
> the work within the AG when we have already parallelised across AGs.
> We want the initial worker thread per AG to just keep working away
> burning CPU while the prefetch code is blocking waiting for more
> inodes from disk. Then we get another burst of work being queued,
> and so on.
> Hence the queue needs to be quite deep so that we can soak up the
> bursts of processing that readahead triggers without asking lots of
> worker threads to do work. However, if the worker thread hits some
> big directories and starts falling behind readahead, that's when it
> will hit the maximum queue depth and kick another thread to do work.

...ah, I think I grok the differences between what repair and scrub are
trying to do with the workqueue.  Repair reaadahead is driving
workqueue_add() calls, so you don't really want to increase parallelism
of the workqueue until (a) you can be reasonably certain that the
workers won't block on IO and (b) the workers have bogged down on huge
directories such that the buffer cache is filling up with memory that
has no immediate consumer.

It's a little different from what I'm doing with scrub, which
effectively reads inobt records and queues each of them separately for
processing.  In this case, the queue depth merely restrains our work
item memory allocations.

> IOWs, the queue depth needs to be deep enough to prevent bursts from
> triggering extra workers from running, but shallow enough that extra
> workers will be scheduled when processing falls behind readahead.
> 
> I really don't have a good way to automatically calculate this
> depth. I just figure that if we have a 1000 inodes queued up for
> processing, we really should kick another thread to start working on
> them. It's a simple solution, so I'd like to see if we have problems
> with this simple threshold before we try to replace the magic number
> with a magic heuristic....

Hm, in that case, shouldn't that code snippet above read:

	if (wq->max_queued && wq->item_count == wq->max_queued - 1) {
		/* more work, wake up another worker */
		pthread_cond_signal(&wq->wakeup);
	}

That would seem to wake up another worker, but only after 1000 inodes
have been added to the queue.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

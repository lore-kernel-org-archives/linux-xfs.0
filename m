Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A4AC4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 22:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33CBF20882
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 22:40:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rgve2l5u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394639AbgJZWk4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 18:40:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47166 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394638AbgJZWk4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 18:40:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QMcUqh087964;
        Mon, 26 Oct 2020 22:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=NVbpzASoIzykzgwS7XwDPPV19MK6NS0ZMi+GT2ZfpOA=;
 b=rgve2l5ujflzRq8LC2aqxLqUS0/hQQfkj+98H8GPbaUIwPn3X+4SKyLKEv80/QgR6J50
 xMWrTcBoEDDHPJH0RD+XT0qvu1M3c6BwtcGBptt8xt/XArwTol/whspjeVlXO3kEatVK
 6g75d5j0scebRfnfxRDEfyvn19yfsZtvTOFbwHg8mDoi8qFCjudwuBer9biIZoZEFvyC
 prtaD+oZ0B/18LbjLZZNwunwyGjR1VyZW37Ca/0SSmVH2xejhnCL4kqNFbBrsqZMbMdK
 YqBUAolmWqDfGyWr9f2w6orQTUD94zhBRWwPt9YZKv3vg1OQHrj+yS0G79vEjDsAJms8 5Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm3vq98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 22:40:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QMVHFO188309;
        Mon, 26 Oct 2020 22:40:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34cx6v92kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 22:40:53 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QMeqN8010819;
        Mon, 26 Oct 2020 22:40:52 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 15:40:52 -0700
Date:   Mon, 26 Oct 2020 15:40:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] workqueue: bound maximum queue depth
Message-ID: <20201026224051.GC347246@magnolia>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-2-david@fromorbit.com>
 <20201025044114.GA347246@magnolia>
 <20201026222943.GV7391@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026222943.GV7391@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=1 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260147
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 09:29:43AM +1100, Dave Chinner wrote:
> On Sat, Oct 24, 2020 at 09:41:14PM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 22, 2020 at 04:15:31PM +1100, Dave Chinner wrote:
> > > @@ -140,6 +164,7 @@ workqueue_add(
> > >  
> > >  	/* Now queue the new work structure to the work queue. */
> > >  	pthread_mutex_lock(&wq->lock);
> > > +restart:
> > >  	if (wq->next_item == NULL) {
> > >  		assert(wq->item_count == 0);
> > >  		ret = -pthread_cond_signal(&wq->wakeup);
> > > @@ -150,6 +175,16 @@ workqueue_add(
> > >  		}
> > >  		wq->next_item = wi;
> > >  	} else {
> > > +		/* throttle on a full queue if configured */
> > > +		if (wq->max_queued && wq->item_count == wq->max_queued) {
> > > +			pthread_cond_wait(&wq->queue_full, &wq->lock);
> > 
> > I ported xfs_scrub to use max_queued for the inode scanner, and got a
> > hang here.  It uses two workqueues -- the first is an unbouned workqueue
> > that receives one work item per AG in which each work item calls
> > INUMBERS, creates a work item for the returned inode chunk, and throws
> > it at the second workqueue.  The second workqueue is a bounded workqueue
> > that calls BULKSTAT on the INUMBERS work item and then calls the
> > iteration function on each bulkstat record returned.
> > 
> > The hang happens when the inumbers workqueue has more than one thread
> > running.
> 
> IIUC, that means you have multiple producer threads? IIRC, he usage
> in this patchset is single producer, so it won't hit this problem...

Right, there are multiple producers, because that seemed like fun.
At this stage, I'm merely using this patch in anger (as it were) to
prototype a fix to scrub.

I'm not even sure it's a reasonable enhancement for xfs_scrub since each
of those bulkstat workers will then fight with the inumbers workers for
the AGI, but so it goes.  It does seem to eliminate the problem of one
thread working hard on an AG that has one huge fragmented file while the
other threads sit idle, but otherwise I mostly just see more buffer lock
contention.  The total runtime doesn't change on more balanced
filesystems, at least. :P

> > Both* threads notice the full workqueue and wait on
> > queue_full.  One of the workers in the second workqueue goes to pull off
> > the next work item, ends up in this if body, signals one of the sleeping
> > threads, and starts calling bulkstat.
> > 
> > In the time it takes to wake up the sleeping thread from wq 1, the
> > second workqueue pulls far enough ahead that the single thread from wq1
> > never manages to fill wq2 again.  Often, the wq1 thread was sleeping so
> > that it could add the last inode chunk of that AG to wq2.  We therefore
> > never wake up the *other* sleeping thread from wq1, and the whole app
> > stalls.
> > 
> > I dunno if that's a sane way to structure an inumbers/bulkstat scan, but
> > it seemed reasonable to me.  I can envision two possible fixes here: (1)
> > use pthread_cond_broadcast to wake everything up; or (2) always call
> > pthread_cond_wait when we pull a work item off the queue.  Thoughts?
> 
> pthread_cond_broadcast() makes more sense, but I suspect there will
> be other issues with multiple producers that render the throttling
> ineffective. I suspect supporting multiple producers should be a
> separate patchset...

<nod> Making change (2) seems to work for multiple producers, but I
guess I'll keep poking at perf to see if I discover anything exciting.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

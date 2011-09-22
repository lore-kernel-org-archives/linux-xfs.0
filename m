Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8MM1waU000446 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 17:01:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A70D1C21FE2
	for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 15:01:57 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ixQFoFsAXzBbp0iw for <xfs@oss.sgi.com>;
	Thu, 22 Sep 2011 15:01:57 -0700 (PDT)
Date: Thu, 22 Sep 2011 18:01:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfs-masters] xfs deadlock in stable kernel 3.0.4
Message-ID: <20110922220151.GA21701@infradead.org>
References: <20110920172455.GA30757@infradead.org>
	<4E78CEFD.9030603@profihost.ag>
	<20110920223047.GA13758@infradead.org>
	<20110921021133.GM15688@dastard> <4E7994D3.5020103@profihost.ag>
	<20110921114237.GP15688@dastard>
	<20110921122649.GA16602@infradead.org>
	<20110921230718.GS15688@dastard>
	<20110922141457.GA11929@infradead.org>
	<20110922214956.GX15688@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110922214956.GX15688@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

On Fri, Sep 23, 2011 at 07:49:56AM +1000, Dave Chinner wrote:
> On Thu, Sep 22, 2011 at 10:14:57AM -0400, Christoph Hellwig wrote:
> >         By default, a wq guarantees non-reentrance only on the same
> > 	CPU.  A work item may not be executed concurrently on the same
> > 	CPU by multiple workers but is allowed to be executed
> > 	concurrently on multiple CPUs.  This flag makes sure
> > 	non-reentrance is enforced across all CPUs.  Work items queued
> > 	to a non-reentrant wq are guaranteed to be executed by at most
> > 	one worker system-wide at any given time.
> > 
> > So this still seems to preferable for the ail workqueue, and should be
> > able to replace the XFS_AIL_PUSHING_BIT protections.
> 
> No, we can't. WQ_NON_REENTRANT only protects against concurrency on
> the same CPU, not across all CPUs - it still allows concurrent
> per-CPU work processing on the same work item.

Non concurrently for a given work_struct on the same CPU is the default,
WQ_NON_REENTRANT extents that to not beeing exectuted concurrently at
all.  Check the documentation above again, or the code - just look
for the only occurance of WQ_NON_REENTRANT in kernel/workqueue.c and
the surronuding code (e.g. find_worker_executing_work and the
current_work field in struct worker)

> However, we want only a *single* AIL worker instance executing per
> filesystem, not per-cpu per filesystem. Concurrent per-filesystem
> workers will simply bash on the AIL lock trying to walk the AIL at
> the same time, and this is precisely the issue the single AIL worker
> setup is avoiding. The XFS_AIL_PUSHING_BIT is what enforces the
> single per-filesystem push worker running at any time.

I think that's exactly what WQ_NON_REENTRANT is intended for.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3665D7F50
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 17:09:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E35D8F8033
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 15:08:56 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	acXsNrN7sqw4YaRp for <xfs@oss.sgi.com>;
	Wed, 25 Jun 2014 15:08:54 -0700 (PDT)
Date: Thu, 26 Jun 2014 08:08:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: On-stack work item completion race? (was Re: XFS crash?)
Message-ID: <20140625220840.GO9508@dastard>
References: <CANGgnMZ0q9uE3NHj2i0SBK1d0vdKLx7QBJeFNb+YwP-5EAmejQ@mail.gmail.com>
	<20140513063943.GQ26353@dastard>
	<CANGgnMYn++1++UyX+D2d9GxPxtytpQJv0ThFwdxM-yX7xDWqiA@mail.gmail.com>
	<20140513090321.GR26353@dastard>
	<CANGgnMZqQc_NeaDpO_aX+bndmHrQ9VWo9mkfxhPBkRD-J=N6sQ@mail.gmail.com>
	<CANGgnMZ8OwzfBj5m9H7c6q2yahGhU7oFZLsJfVxnWoqZExkZmQ@mail.gmail.com>
	<20140624030240.GB9508@dastard>
	<20140624032521.GA12164@htj.dyndns.org>
	<20140625055641.GL9508@dastard>
	<20140625141836.GC26883@htj.dyndns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140625141836.GC26883@htj.dyndns.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Austin Schuh <austin@peloton-tech.com>, xfs <xfs@oss.sgi.com>

On Wed, Jun 25, 2014 at 10:18:36AM -0400, Tejun Heo wrote:
> Hello, Dave.
> 
> On Wed, Jun 25, 2014 at 03:56:41PM +1000, Dave Chinner wrote:
> > Hmmm - that's different from my understanding of what the original
> > behaviour WQ_MEM_RECLAIM gave us. i.e. that WQ_MEM_RECLAIM
> > workqueues had a rescuer thread created to guarantee that the
> > *workqueue* could make forward progress executing work in a
> > reclaim context.
> 
> From Documentation/workqueue.txt
> 
>   WQ_MEM_RECLAIM
> 
> 	All wq which might be used in the memory reclaim paths _MUST_
> 	have this flag set.  The wq is guaranteed to have at least one
> 	execution context regardless of memory pressure.
> 
> So, all that's guaranteed is that the workqueue has at least one
> worker executing its work items.  If that one worker is serving a work
> item which can't make forward progress, the workqueue is not
> guaranteed to make forward progress.

Adding that to the docco might be useful ;)

> > > As long as a WQ_RECLAIM workqueue dosen't depend upon itself,
> > > forward-progress is guaranteed.
> > 
> > I can't find any documentation that actually defines what
> > WQ_MEM_RECLAIM means, so I can't tell when or how this requirement
> > came about. If it's true, then I suspect most of the WQ_MEM_RECLAIM
> > workqueues in filesystems violate it. Can you point me at
> > documentation/commits/code describing the constraints of
> > WQ_MEM_RECLAIM and the reasons for it?
> 
> Documentation/workqueue.txt should be it but maybe we should be more
> explicit.  The behavior is maintaining what the
> pre-concurrency-management workqueue provided with static
> per-workqueue workers.  Each workqueue reserved its workers (either
> one per cpu or one globally) and it only supported single level of
> concurrency on each CPU.  WQ_MEM_RECLAIM is providing equivalent
> amount of forward progress guarantee and all the existing users
> shouldn't have issues on this front.  If we have grown incorrect
> usages from then on, we need to fix them.

Ok, so it hasn't changed. We're still usingthem like we used the
original workqueues, and we never, ever provided a guarantee of
forwards progress for them, either. So if the workqueues haven't
changed, and we haven't changed how we use workqueues, then
something else is causing all our recent problems....

Thanks for the clarification, Tejun!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

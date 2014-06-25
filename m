Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0FF307F3F
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 00:56:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E9BA1304051
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 22:56:47 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AT8qAtPCAMFCvzMj for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 22:56:46 -0700 (PDT)
Date: Wed, 25 Jun 2014 15:56:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: On-stack work item completion race? (was Re: XFS crash?)
Message-ID: <20140625055641.GL9508@dastard>
References: <CANGgnMa80WwQ8zSkL52yYegmQURVQeZiBFv41=FQXMZJ_NaEDw@mail.gmail.com>
	<20140513034647.GA5421@dastard>
	<CANGgnMZ0q9uE3NHj2i0SBK1d0vdKLx7QBJeFNb+YwP-5EAmejQ@mail.gmail.com>
	<20140513063943.GQ26353@dastard>
	<CANGgnMYn++1++UyX+D2d9GxPxtytpQJv0ThFwdxM-yX7xDWqiA@mail.gmail.com>
	<20140513090321.GR26353@dastard>
	<CANGgnMZqQc_NeaDpO_aX+bndmHrQ9VWo9mkfxhPBkRD-J=N6sQ@mail.gmail.com>
	<CANGgnMZ8OwzfBj5m9H7c6q2yahGhU7oFZLsJfVxnWoqZExkZmQ@mail.gmail.com>
	<20140624030240.GB9508@dastard>
	<20140624032521.GA12164@htj.dyndns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140624032521.GA12164@htj.dyndns.org>
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

On Mon, Jun 23, 2014 at 11:25:21PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jun 24, 2014 at 01:02:40PM +1000, Dave Chinner wrote:
> > As I understand it, what then happens is that the workqueue code
> > grabs another kworker thread and runs the next work item in it's
> > queue. IOWs, work items can block, but doing that does not prevent
> > execution of other work items queued on other work queues or even on
> > the same work queue. Tejun, did I get that correct?
> 
> Yes, as long as the workqueue is under its @max_active limit and has
> access to an existing kworker or can create a new one, it'll start
> executing the next work item immediately; however, the guaranteed
> level of concurrency is 1 even for WQ_RECLAIM workqueues.  IOW, the
> work items queued on a workqueue must be able to make forward progress
> with single work item if the work items are being depended upon for
> memory reclaim.

Hmmm - that's different from my understanding of what the original
behaviour WQ_MEM_RECLAIM gave us. i.e. that WQ_MEM_RECLAIM
workqueues had a rescuer thread created to guarantee that the
*workqueue* could make forward progress executing work in a
reclaim context.

The concept that the *work being executed* needs to guarantee
forwards progress is something I've never heard stated before.
That worries me a lot, especially with all the memory reclaim
problems that have surfaced in the past couple of months....

> As long as a WQ_RECLAIM workqueue dosen't depend upon itself,
> forward-progress is guaranteed.

I can't find any documentation that actually defines what
WQ_MEM_RECLAIM means, so I can't tell when or how this requirement
came about. If it's true, then I suspect most of the WQ_MEM_RECLAIM
workqueues in filesystems violate it. Can you point me at
documentation/commits/code describing the constraints of
WQ_MEM_RECLAIM and the reasons for it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

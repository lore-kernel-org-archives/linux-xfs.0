Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 324777F3F
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 09:18:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 146898F8052
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 07:18:47 -0700 (PDT)
Received: from mail-qg0-f47.google.com (mail-qg0-f47.google.com
	[209.85.192.47]) by cuda.sgi.com with ESMTP id UtaDiQ3IkpBLCDPj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Jun 2014 07:18:42 -0700 (PDT)
Received: by mail-qg0-f47.google.com with SMTP id q108so1713575qgd.34
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 07:18:42 -0700 (PDT)
Date: Wed, 25 Jun 2014 10:18:36 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: On-stack work item completion race? (was Re: XFS crash?)
Message-ID: <20140625141836.GC26883@htj.dyndns.org>
References: <20140513034647.GA5421@dastard>
	<CANGgnMZ0q9uE3NHj2i0SBK1d0vdKLx7QBJeFNb+YwP-5EAmejQ@mail.gmail.com>
	<20140513063943.GQ26353@dastard>
	<CANGgnMYn++1++UyX+D2d9GxPxtytpQJv0ThFwdxM-yX7xDWqiA@mail.gmail.com>
	<20140513090321.GR26353@dastard>
	<CANGgnMZqQc_NeaDpO_aX+bndmHrQ9VWo9mkfxhPBkRD-J=N6sQ@mail.gmail.com>
	<CANGgnMZ8OwzfBj5m9H7c6q2yahGhU7oFZLsJfVxnWoqZExkZmQ@mail.gmail.com>
	<20140624030240.GB9508@dastard>
	<20140624032521.GA12164@htj.dyndns.org>
	<20140625055641.GL9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140625055641.GL9508@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Austin Schuh <austin@peloton-tech.com>, xfs <xfs@oss.sgi.com>

Hello, Dave.

On Wed, Jun 25, 2014 at 03:56:41PM +1000, Dave Chinner wrote:
> Hmmm - that's different from my understanding of what the original
> behaviour WQ_MEM_RECLAIM gave us. i.e. that WQ_MEM_RECLAIM
> workqueues had a rescuer thread created to guarantee that the
> *workqueue* could make forward progress executing work in a
> reclaim context.

>From Documentation/workqueue.txt

  WQ_MEM_RECLAIM

	All wq which might be used in the memory reclaim paths _MUST_
	have this flag set.  The wq is guaranteed to have at least one
	execution context regardless of memory pressure.

So, all that's guaranteed is that the workqueue has at least one
worker executing its work items.  If that one worker is serving a work
item which can't make forward progress, the workqueue is not
guaranteed to make forward progress.

> The concept that the *work being executed* needs to guarantee
> forwards progress is something I've never heard stated before.
> That worries me a lot, especially with all the memory reclaim
> problems that have surfaced in the past couple of months....

I'd love to provide that but guaranteeing that at least one work is
always being executed requires unlimited task allocation (the ones
which get blocked gotta store their context somewhere).

> > As long as a WQ_RECLAIM workqueue dosen't depend upon itself,
> > forward-progress is guaranteed.
> 
> I can't find any documentation that actually defines what
> WQ_MEM_RECLAIM means, so I can't tell when or how this requirement
> came about. If it's true, then I suspect most of the WQ_MEM_RECLAIM
> workqueues in filesystems violate it. Can you point me at
> documentation/commits/code describing the constraints of
> WQ_MEM_RECLAIM and the reasons for it?

Documentation/workqueue.txt should be it but maybe we should be more
explicit.  The behavior is maintaining what the
pre-concurrency-management workqueue provided with static
per-workqueue workers.  Each workqueue reserved its workers (either
one per cpu or one globally) and it only supported single level of
concurrency on each CPU.  WQ_MEM_RECLAIM is providing equivalent
amount of forward progress guarantee and all the existing users
shouldn't have issues on this front.  If we have grown incorrect
usages from then on, we need to fix them.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

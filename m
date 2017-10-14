Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:6278 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750729AbdJNWm1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Oct 2017 18:42:27 -0400
Date: Sun, 15 Oct 2017 09:42:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: agcount for 2TB, 4TB and 8TB drives
Message-ID: <20171014224224.GD15067@dastard>
References: <8e6fd742-8767-e786-746d-2b9f2929b98c@sandeen.net>
 <20171006222031.GU3666@dastard>
 <b97b41f5-76dc-b2d7-3b34-02a331b0d8de@sandeen.net>
 <1b5b6410-b1d9-8519-7032-8ea0ca46f5b5@scylladb.com>
 <20171009112306.GM3666@dastard>
 <89a7ae9a-9960-ae37-f6ca-0c1f2e33f65f@scylladb.com>
 <20171009220332.GP3666@dastard>
 <38bd7785-174d-fd09-fc1f-50a2d4e1dd69@scylladb.com>
 <20171010225524.GV3666@dastard>
 <86635b89-5016-5cd1-53a2-bf21b842ae04@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86635b89-5016-5cd1-53a2-bf21b842ae04@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-xfs@vger.kernel.org

On Fri, Oct 13, 2017 at 11:13:24AM +0300, Avi Kivity wrote:
> On 10/11/2017 01:55 AM, Dave Chinner wrote:
> >On Tue, Oct 10, 2017 at 12:07:42PM +0300, Avi Kivity wrote:
> >>On 10/10/2017 01:03 AM, Dave Chinner wrote:
> >>>>On 10/09/2017 02:23 PM, Dave Chinner wrote:
> >>>>>On Mon, Oct 09, 2017 at 11:05:56AM +0300, Avi Kivity wrote:
> >>>>>Sure, that might be the IO concurrency the SSD sees and handles, but
> >>>>>you very rarely require that much allocation parallelism in the
> >>>>>workload. Only a small amount of the IO submission path is actually
> >>>>>allocation work, so a single AG can provide plenty of async IO
> >>>>>parallelism before an AG is the limiting factor.
> >>>>Sure. Can a single AG issue multiple I/Os, or is it single-threaded?
> >>>AGs don't issue IO. Applications issue IO, the filesystem allocates
> >>>space from AGs according to the write IO that passes through it.
> >>What I meant was I/O in order to satisfy an allocation (read from
> >>the free extent btree or whatever), not the application's I/O.
> >Once you're in the per-AG allocator context, it is single threaded
> >until the allocation is complete. We do things like btree block
> >readahead to minimise IO wait times, but we can't completely hide
> >things like metadata read Io wait time when it is required to make
> >progress.
> 
> I see, thanks. Will RWF_NOWAIT detect the need to do I/O for the
> free space btree, or just contention? (I expect the latter from the
> patches I've seen, but perhaps I missed something).

No, it checks at a high level whether allocation is needed (i.e. IO
into a hole) and if allocation is needed, it punts the IO
immediately to the background thread and returns to userspace. i.e.
it never gets near the allocator to begin with....

Like I said before, RWF_NOWAIT prevents entire classes of
AIO submission blocking issues from occuring. Use it and almost all
filesystem blocking concerns go away....

> The vast majority of the time XFS AIO works very well. The problem
> is that when problems do happen, performance drops of sharply, and
> it's often in a situation that's hard to debug.

Yes, and that's made worse by there being relatively few people
around with the knowledge to be able to find the the root cause when
it does happen. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

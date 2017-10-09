Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37270 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751598AbdJILXJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 07:23:09 -0400
Date: Mon, 9 Oct 2017 22:23:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: agcount for 2TB, 4TB and 8TB drives
Message-ID: <20171009112306.GM3666@dastard>
References: <CAJH6TXgShHj6UynrNAs8eG0ZRFz5gSGGY1ZARPSofsNibi0Grg@mail.gmail.com>
 <20171006153803.GI7122@magnolia>
 <8e6fd742-8767-e786-746d-2b9f2929b98c@sandeen.net>
 <20171006222031.GU3666@dastard>
 <b97b41f5-76dc-b2d7-3b34-02a331b0d8de@sandeen.net>
 <1b5b6410-b1d9-8519-7032-8ea0ca46f5b5@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b5b6410-b1d9-8519-7032-8ea0ca46f5b5@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-xfs@vger.kernel.org

On Mon, Oct 09, 2017 at 11:05:56AM +0300, Avi Kivity wrote:
> On 10/07/2017 01:21 AM, Eric Sandeen wrote:
> >On 10/6/17 5:20 PM, Dave Chinner wrote:
> >>On Fri, Oct 06, 2017 at 11:18:39AM -0500, Eric Sandeen wrote:
> >>>On 10/6/17 10:38 AM, Darrick J. Wong wrote:
> >>>>On Fri, Oct 06, 2017 at 10:46:20AM +0200, Gandalf Corvotempesta wrote:
> >>>>Semirelated question: for a solid state disk on a machine with high CPU
> >>>>counts do we prefer agcount == cpucount to take advantage of the
> >>>>high(er) iops and lack of seek time to increase parallelism?
> >>>>
> >>>>(Not that I've studied that in depth.)
> >>>Interesting question.  :)  Maybe harder to answer for SSD black boxes?
> >>Easy: switch to multidisk mode if /sys/block/<dev>/queue/rotational
> >>is zero after doing all the other checks. Then SSDs will get larger
> >>AG counts automatically.
> >The "hard part" was knowing just how much parallelism is actually inside
> >the black box.
> 
> It's often > 100.

Sure, that might be the IO concurrency the SSD sees and handles, but
you very rarely require that much allocation parallelism in the
workload. Only a small amount of the IO submission path is actually
allocation work, so a single AG can provide plenty of async IO
parallelism before an AG is the limiting factor.

i.e. A single AG can typically support tens of thousands of free
space manipulations per second before the AG locks become the
bottleneck. Hence by the time you get to 16 AGs there's concurrency
available for (runs a concurrent workload and measures) at least
350,000 allocation transactions per second on relatively slow 5 year
old 8-core server CPUs. And that's CPU bound (16 CPUs all at >95%),
so faster, more recent CPUs will run much higher numbers.

IOws, don't confuse allocation concurrency with IO concurrency or
application concurrency. It's not the same thing and it is rarely a
limiting factor for most workloads, even the most IO intensive
ones...

> >   But "multidisk mode" doesn't go too overboard, so yeah
> >that's probably fine.
> 
> Is there a penalty associated with having too many allocation groups?

Yes. You break up the large contiguous free spaces into many smaller
free spaces and so can induce premature onset of filesystem aging
related performance degradations. And for spinning disks, more than
4-8AGs per spindle causes excessive seeks in mixed workloads and
degrades performance that way....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

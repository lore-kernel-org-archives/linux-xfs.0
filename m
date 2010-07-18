Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6INlgvI173148 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 18:47:43 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D463B1E2BD26
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 16:50:40 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	v7IJmg5yDjxb3m6a for <xfs@oss.sgi.com>;
	Sun, 18 Jul 2010 16:50:40 -0700 (PDT)
Date: Mon, 19 Jul 2010 09:50:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hung on 2.6.33.3 kernel
Message-ID: <20100718235036.GC32635@dastard>
References: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
	<20100718012033.GA18888@dastard>
	<AANLkTikEv75KRyRTs4awmG894NSKMnBkJNJPYsypMdWf@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTikEv75KRyRTs4awmG894NSKMnBkJNJPYsypMdWf@mail.gmail.com>
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
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: xfs@oss.sgi.com

On Sat, Jul 17, 2010 at 09:35:33PM -0400, Ilia Mirkin wrote:
> On Sat, Jul 17, 2010 at 9:20 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sat, Jul 17, 2010 at 12:01:11AM -0400, Ilia Mirkin wrote:
> > I can't find a thread that holds the XFS inode lock that everything
> > is waiting on. I think it is the ILOCK, but none of the threads in
> > this trace should be holding it where they are blocked. IOWs, the
> > output does not give me enough information to get to the root cause.
> 
> In case this happens again, was there something more useful I could
> have collected? Should I have grabbed all task states?

All the task states, including the running tasks, is probably a good
start. Also, if the kernel you are running has tracing events
enabled and has the necessary XFS tracepoints (I can't remember off
the top of my head whether they are in 2.6.33), you might want to
enable tracing of:

	xfs_ilock
	xfs_ilock_nowait
	xfs_ilock_demote
	xfs_iunlock

via:

# echo 1 > /sys/kernel/debug/tracing/events/xfs/<trace_point>/enable

and when the problem is hit dumping the trace via:

# cat /sys/kernel/debug/tracing/trace > trace.log

You may also want to bump up the trace buffer size to capture more
events:

# echo 32768 > /sys/kernel/debug/tracing/buffer_size_kb

Though I suspect the only way to get to the bottom of it will
be to work out a reproducable test case....

> It's pretty obvious that allowing userspace to hang the FS is really
> bad, but I appreciate that the app is doing something that the kernel
> didn't expect.

Yeah, we need to fix the hang - it's the bigger issues of mixed
direct/buffered IO that I was refering to...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

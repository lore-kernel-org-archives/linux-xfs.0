Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5E2BD7F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 17:41:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D7B2AAC005
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 15:41:55 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IdRWWtD0bRrb3Ns0 for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 15:41:53 -0800 (PST)
Date: Wed, 2 Dec 2015 10:41:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151201234139.GE19199@dastard>
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
	<565C5D39.8080300@scylladb.com>
	<20151130161438.GD24765@bfoster.bfoster>
	<565D639F.8070403@scylladb.com>
	<20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<CAD-J=zY=A8MQLzykox276cHiH7ddXHFVp0w0B4XRBskv6YK_WQ@mail.gmail.com>
	<20151201204535.GX19199@dastard> <565E0961.4060603@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565E0961.4060603@scylladb.com>
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
To: Avi Kivity <avi@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com

On Tue, Dec 01, 2015 at 10:56:01PM +0200, Avi Kivity wrote:
> On 12/01/2015 10:45 PM, Dave Chinner wrote:
> >On Tue, Dec 01, 2015 at 09:01:13AM -0500, Glauber Costa wrote:
> >The difference is an allocation can block waiting on IO, and the
> >CPU can then go off and run another process, which then tries to do
> >an allocation. So you might only have 4 CPUs, but a workload that
> >can have a hundred active allocations at once (not uncommon in
> >file server workloads).
> 
> But for us, probably not much more.  We try to restrict active I/Os
> to the effective disk queue depth (more than that and they just turn
> sour waiting in the disk queue).
> 
> 
> >On worklaods that are roughly 1 process per CPU, it's typical that
> >agcount = 2 * N cpus gives pretty good results on large filesystems.
> 
> This is probably using sync calls.  Using async calls you can have
> many more I/Os in progress (but still limited by effective disk
> queue depth).

Ah, no. Even with async IO you don't want unbound allocation
concurrency. The allocation algorithms rely on having contiguous
free space extents that are much larger than the allocations being
done to work effeectively and minimise file fragmentation. If you
chop the filesystem up into lots of small AGs, then it accelerates
the rate at which the free space gets chopped up into smaller
extents and performance then suffers. It's the same problem as
running a large filesystem near ENOSPC for an extended period of
time, which again is something we most definitely don't recommend
you do in production systems.

> >If you've got 400GB filesystems or you are using spinning disks,
> >then you probably don't want to go above 16 AGs, because then you
> >have problems with maintaining continugous free space and you'll
> >seek the spinning disks to death....
> 
> We're concentrating on SSDs for now.

Sure, so "problems with maintaining continugous free space" is what
you need to be concerned about.

> >>>>'mount -o ikeep,'
> >>>
> >>>Interesting.  Our files are large so we could try this.
> >Keep in mind that ikeep means that inode allocation permanently
> >fragments free space, which can affect how large files are allocated
> >once you truncate/rm the original files.
> 
> We can try to prime this by allocating a lot of inodes up front,
> then removing them, so that this doesn't happen.

Again - what problem have you measured that inode preallocation will
solves in your application? Don't make changes just because you
*think* it will fix what you *think* is a problem. Measure, analyse,
solve, in that order.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

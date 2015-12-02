Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 87BE67FB7
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 02:23:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5228130408D
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 00:23:12 -0800 (PST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com
	[74.125.82.41]) by cuda.sgi.com with ESMTP id GLMa7Yposh8MK85F
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 00:23:09 -0800 (PST)
Received: by wmec201 with SMTP id c201so241222550wme.0
	for <xfs@oss.sgi.com>; Wed, 02 Dec 2015 00:23:07 -0800 (PST)
Subject: Re: sleeps and waits during io_submit
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
	<565C5D39.8080300@scylladb.com>
	<20151130161438.GD24765@bfoster.bfoster>
	<565D639F.8070403@scylladb.com>
	<20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<CAD-J=zY=A8MQLzykox276cHiH7ddXHFVp0w0B4XRBskv6YK_WQ@mail.gmail.com>
	<20151201204535.GX19199@dastard> <565E0961.4060603@scylladb.com>
	<20151201234139.GE19199@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <565EAA69.80003@scylladb.com>
Date: Wed, 2 Dec 2015 10:23:05 +0200
MIME-Version: 1.0
In-Reply-To: <20151201234139.GE19199@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com

On 12/02/2015 01:41 AM, Dave Chinner wrote:
> On Tue, Dec 01, 2015 at 10:56:01PM +0200, Avi Kivity wrote:
>> On 12/01/2015 10:45 PM, Dave Chinner wrote:
>>> On Tue, Dec 01, 2015 at 09:01:13AM -0500, Glauber Costa wrote:
>>> The difference is an allocation can block waiting on IO, and the
>>> CPU can then go off and run another process, which then tries to do
>>> an allocation. So you might only have 4 CPUs, but a workload that
>>> can have a hundred active allocations at once (not uncommon in
>>> file server workloads).
>> But for us, probably not much more.  We try to restrict active I/Os
>> to the effective disk queue depth (more than that and they just turn
>> sour waiting in the disk queue).
>>
>>
>>> On worklaods that are roughly 1 process per CPU, it's typical that
>>> agcount = 2 * N cpus gives pretty good results on large filesystems.
>> This is probably using sync calls.  Using async calls you can have
>> many more I/Os in progress (but still limited by effective disk
>> queue depth).
> Ah, no. Even with async IO you don't want unbound allocation
> concurrency.

Unbound, certainly not.

But if my disk want 100 concurrent operations to deliver maximum 
bandwidth, and XFS wants fewer concurrent allocations to satisfy some 
internal constraint, then I can't satisfy both.

To be fair, the number 100 was measured for 4k reads.  It's sure to be 
much lower for 128k writes, and since we set an extent size hint of 1MB, 
only 1/8th of those will be allocating.  So I expect things to work in 
practice, at least with the current generation of disks. Unfortunately 
disk bandwidth is growing faster than latency is improving, which means 
that the effective concurrency is increasing.

>   The allocation algorithms rely on having contiguous
> free space extents that are much larger than the allocations being
> done to work effeectively and minimise file fragmentation. If you
> chop the filesystem up into lots of small AGs, then it accelerates
> the rate at which the free space gets chopped up into smaller
> extents and performance then suffers. It's the same problem as
> running a large filesystem near ENOSPC for an extended period of
> time, which again is something we most definitely don't recommend
> you do in production systems.

I understand.  I guess it makes ag randomization even more important, 
for our use case.

What happens when an ag fills up?  Can a file overflow to another ag?

>
>>> If you've got 400GB filesystems or you are using spinning disks,
>>> then you probably don't want to go above 16 AGs, because then you
>>> have problems with maintaining continugous free space and you'll
>>> seek the spinning disks to death....
>> We're concentrating on SSDs for now.
> Sure, so "problems with maintaining continugous free space" is what
> you need to be concerned about.

Right.  Luckily our allocation patterns are very friendly towards that.  
We have append-only files that grow rapidly, then are immutable for a 
time, then are deleted. (It is a log-structured database so a natual fit 
for SSDs).

We can increase our extent size hint if it will help the SSD any.

>
>>>>>> 'mount -o ikeep,'
>>>>> Interesting.  Our files are large so we could try this.
>>> Keep in mind that ikeep means that inode allocation permanently
>>> fragments free space, which can affect how large files are allocated
>>> once you truncate/rm the original files.
>> We can try to prime this by allocating a lot of inodes up front,
>> then removing them, so that this doesn't happen.
> Again - what problem have you measured that inode preallocation will
> solves in your application? Don't make changes just because you
> *think* it will fix what you *think* is a problem. Measure, analyse,
> solve, in that order.

We are now investigating what we can do to fix the problem, we aren't 
committing to any solution yet.  Certainly we plan to be certain of what 
the problem is before we fix it.

Up until a few days ago we never saw any blocks with XFS, and were very 
happy -- but that was with 90us, 450k IOPS disks.  With the slower 
disks, accessed through a certain hypervisor, we do see XFS block, and 
it is very worrying.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:54174 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755538AbdJJJHq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2017 05:07:46 -0400
Received: by mail-wm0-f49.google.com with SMTP id q132so3187482wmd.2
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2017 02:07:46 -0700 (PDT)
Subject: Re: agcount for 2TB, 4TB and 8TB drives
References: <CAJH6TXgShHj6UynrNAs8eG0ZRFz5gSGGY1ZARPSofsNibi0Grg@mail.gmail.com>
 <20171006153803.GI7122@magnolia>
 <8e6fd742-8767-e786-746d-2b9f2929b98c@sandeen.net>
 <20171006222031.GU3666@dastard>
 <b97b41f5-76dc-b2d7-3b34-02a331b0d8de@sandeen.net>
 <1b5b6410-b1d9-8519-7032-8ea0ca46f5b5@scylladb.com>
 <20171009112306.GM3666@dastard>
 <89a7ae9a-9960-ae37-f6ca-0c1f2e33f65f@scylladb.com>
 <20171009220332.GP3666@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <38bd7785-174d-fd09-fc1f-50a2d4e1dd69@scylladb.com>
Date: Tue, 10 Oct 2017 12:07:42 +0300
MIME-Version: 1.0
In-Reply-To: <20171009220332.GP3666@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-xfs@vger.kernel.org



On 10/10/2017 01:03 AM, Dave Chinner wrote:
> On Mon, Oct 09, 2017 at 06:46:41PM +0300, Avi Kivity wrote:
>>
>> On 10/09/2017 02:23 PM, Dave Chinner wrote:
>>> On Mon, Oct 09, 2017 at 11:05:56AM +0300, Avi Kivity wrote:
>>>> On 10/07/2017 01:21 AM, Eric Sandeen wrote:
>>>>> On 10/6/17 5:20 PM, Dave Chinner wrote:
>>>>>> On Fri, Oct 06, 2017 at 11:18:39AM -0500, Eric Sandeen wrote:
>>>>>>> On 10/6/17 10:38 AM, Darrick J. Wong wrote:
>>>>>>>> On Fri, Oct 06, 2017 at 10:46:20AM +0200, Gandalf Corvotempesta wrote:
>>>>>>>> Semirelated question: for a solid state disk on a machine with high CPU
>>>>>>>> counts do we prefer agcount == cpucount to take advantage of the
>>>>>>>> high(er) iops and lack of seek time to increase parallelism?
>>>>>>>>
>>>>>>>> (Not that I've studied that in depth.)
>>>>>>> Interesting question.  :)  Maybe harder to answer for SSD black boxes?
>>>>>> Easy: switch to multidisk mode if /sys/block/<dev>/queue/rotational
>>>>>> is zero after doing all the other checks. Then SSDs will get larger
>>>>>> AG counts automatically.
>>>>> The "hard part" was knowing just how much parallelism is actually inside
>>>>> the black box.
>>>> It's often > 100.
>>> Sure, that might be the IO concurrency the SSD sees and handles, but
>>> you very rarely require that much allocation parallelism in the
>>> workload. Only a small amount of the IO submission path is actually
>>> allocation work, so a single AG can provide plenty of async IO
>>> parallelism before an AG is the limiting factor.
>> Sure. Can a single AG issue multiple I/Os, or is it single-threaded?
> AGs don't issue IO. Applications issue IO, the filesystem allocates
> space from AGs according to the write IO that passes through it.

What I meant was I/O in order to satisfy an allocation (read from the 
free extent btree or whatever), not the application's I/O.

>
> i.e. when you don't do allocation in the write IO path or you are
> doing read IOs, then the number of AGs is /completely irrelevant/.
> In those cases a single AG can "support" the entire IO load your
> application and storage subsystem can handle.
>
> The only time an AG lock is taken in the IO path is during extent
> allocation (i.e. writes). And, as I've already said, a single AG can
> easily handle tens of thousands of allocation transactions a second
> before it becomes a bottleneck.

Well, my own workload has at most a hundred allocations per second (32MB 
hints, 3GB/s writes)*, so I'm asking more to increase my understanding 
of XFS. But for me locks become a problem a lot sooner than they become 
a bottleneck, because I am using AIO and blocking in io_submit() 
destroys performance for me.

*below I see that it may wrong, so perhaps I have about 23k allocs/sec 
(128k buffers, 3GB/s writes).

>
> IOWs, the worse case is that you'll get tens of thousands of IOs per
> second through an AG.

For me, the worst case is worse. If io_submit() blocks, then there is 
nothing to utilize the processor core, and thus generate more I/Os that 
may have utilized the disk (for example, reads that don't need that 
lock). My use case is much more sensitive to lock contention.


Does the new RWF_NOWAIT goodness extend to AG locks? In that case I'll 
punt the io_submit to a worker thread that can block.

Ah, below you say it does.

>
>> I understand that XFS_XFLAG_EXTSIZE and XFS_IOC_FSSETXATTR can
>> reduce the AG's load.
> Not really. They change the allocation pattern on the inode. This
> changes how the inode data is laid out on disk, but it doesn't
> necessarily change the allocation overhead of the write IO path.
> That's all dependent on what the application IO patterns are and how
> they match the extent size hints.

I write 128k naturally-aligned writes using aio, so I expect it will 
match. Will every write go into the AG allocator, or just writes that 
cross a 32MB boundary?


>
> In general, nobody ever notices what the "load" on an AG is and
> that's because almost no-one ever drives AGs to their limits.  The
> mkfs defaults and the allocation policies keep the load distributed
> across the filesystem and so storage subsystems almost always run
> out of IO and/or seek capability before the filesystem runs out of
> allocation concurrency. And, in general, most machines run out of
> CPU power before they drive enough concurrency and load through the
> filesystem that it starts contending on internal locks.
>
> Sure, I have plenty of artificial workloads that drive this sort
> contention, but no-one has a production workload that requires those
> sorts of behaviours or creates the same level of lock contention
> that these artificial workloads drive.

I've certainly seen lock contention in XFS, there was a recent thread 
(started by Tomasz) where a filesystem that was close to full was almost 
completely degraded for us.

Again we are more sensitive to contention than other workloads, because 
contention for us doesn't just block the work downstream from lock 
acquisition, it blocks all other work on that core for the duration.

>
>> Is there a downside? for example, when I
>> truncate + close the file, will the preallocated data still remain
>> allocated? Do I need to return it with an fallocate()?
> No. Yes.

Thanks. Most of my files are much larger, so the waste isn't too high, 
but it's still waste.

>
>>> space manipulations per second before the AG locks become the
>>> bottleneck. Hence by the time you get to 16 AGs there's concurrency
>>> available for (runs a concurrent workload and measures) at least
>>> 350,000 allocation transactions per second on relatively slow 5 year
>>> old 8-core server CPUs. And that's CPU bound (16 CPUs all at >95%),
>>> so faster, more recent CPUs will run much higher numbers.
>>>
>>> IOws, don't confuse allocation concurrency with IO concurrency or
>>> application concurrency. It's not the same thing and it is rarely a
>>> limiting factor for most workloads, even the most IO intensive
>>> ones...
>> In my load, the allocation load is not very high, but the impact of
>> iowait is. So if I can reduce the chance of io_submit() blocking
>> because of AG contention, then I'm happy to increase the number of
>> AGs even if it hurts other things.
> That's what RWF_NOWAIT is for. It pushes any write IO that requires
> allocation into a thread rather possibly blocking the submitting
> thread on any lock or IO in the allocation path.

Excellent, we'll use that, although it will be years before our users 
see the benefit.

>>>>>    But "multidisk mode" doesn't go too overboard, so yeah
>>>>> that's probably fine.
>>>> Is there a penalty associated with having too many allocation groups?
>>> Yes. You break up the large contiguous free spaces into many smaller
>>> free spaces and so can induce premature onset of filesystem aging
>>> related performance degradations. And for spinning disks, more than
>>> 4-8AGs per spindle causes excessive seeks in mixed workloads and
>>> degrades performance that way....
>> For an SSD, would an AG per 10GB be reasonable? per 100GB?
> No. Maybe.
>
> Like I said, we can use the multi-disk mode in mkfs for this - it
> already selects an appropriate number of AGs according to the size
> of the filesystem appropriately.
>
>> Machines with 60-100 logical cores and low-tens of terabytes of SSD
>> are becoming common.  How many AGs would work for such a machine?
> Multidisk default, which will be 32 AGs for anything in the 1->32TB
> range. And over 32TB, you get 1 AG per TB...


Ok. Then doubling it so that each logical core has an AG wouldn't be 
such a big change.

>
>> Again the allocation load is not very high (allocating a few GB/s
>> with 32MB hints, so < 100 allocs/sec), but the penalty for
>> contention is pretty high.
> I think you're worrying about a non-problem. Use RWF_NOWAIT for your
> AIO, and most of your existing IO submission blocking problems will
> go away.
>

We'll start using RWF_NOWAIT, but many of our users are on a 3.10 
derivative kernel and won't install 4.14-rc6 on their production 
clusters. If a mkfs tweak can help them, then I'll happily do it.

I don't have direct proof that too few AGs are causing problems for me, 
but I've seen many traces showing XFS blocking, and like I said, it's a 
disaster for us. Unfortunately these problems are hard to reproduce and 
are expensive to test.



Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40158 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S941131AbcKODKP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2016 22:10:15 -0500
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag during
 slab reclaim
References: <20161015223454.GS23194@dastard>
 <20161017002427.GA70229@clm-mbp.masoncoding.com>
 <20161017015251.GU23194@dastard>
 <e0c37926-a670-98b6-4bd7-b438def130bd@fb.com>
 <20161017223057.GV23194@dastard>
 <f6dadb97-4233-4bbf-3edc-4985c7727548@fb.com>
 <20161018020324.GA23194@dastard>
 <20161114005951.GB2127@clm-mbp.thefacebook.com>
 <20161114072708.GN28922@dastard>
 <1f19925d-6ba8-9bde-b3a8-0bdade80f564@fb.com>
 <20161114235801.GO28922@dastard>
From: Chris Mason <clm@fb.com>
Message-ID: <30bcb115-b3f5-63c4-5693-5e760b46fb41@fb.com>
Date: Mon, 14 Nov 2016 22:09:58 -0500
MIME-Version: 1.0
In-Reply-To: <20161114235801.GO28922@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 11/14/2016 06:58 PM, Dave Chinner wrote:
> On Mon, Nov 14, 2016 at 03:56:14PM -0500, Chris Mason wrote:
>> On 11/14/2016 02:27 AM, Dave Chinner wrote:
>>> On Sun, Nov 13, 2016 at 08:00:04PM -0500, Chris Mason wrote:
>>>> On Tue, Oct 18, 2016 at 01:03:24PM +1100, Dave Chinner wrote:
>>>>
>>>> [ Long stalls from xfs_reclaim_inodes_ag ]
>>>>
>>>>> XFS has *1* tunable that can change the behaviour of metadata
>>>>> writeback. Please try it.
>>>>
>>>> [ weeks go by, so this email is insanely long ]
>>>>
>>>> Testing all of this was slow going because two of the three test
>>>> boxes I had with the hadoop configuration starting having hardware
>>>> problems.  The good news is that while I was adjusting the
>>>> benchmark, we lined up access to a bunch of duplicate boxes, so I
>>>> can now try ~20 different configurations in parallel.
>>>>
>>>> My rough benchmark is here:
>>>>
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/simoop.git
>>>>
>>>> The command line I ended up using was:
>>>>
>>>> simoop -t 512 -m 190 -M 128 -C 28 -r 60000 -f 70 -T 20 -R1 -W 1 -i
>>>> 60 -w 300 -D 2 /hammer/*
>>>
>>> There's a lightly tested patch below that should do the trick.
>>>
>>> After 5 minutes on a modified simoop cli on a single filesystem,
>>> 4.9-rc4+for-next:
>>>
>>> $ ./simoop -t 128 -m 50 -M 128 -C 14 -r 60000 -f 2 -T 20 -R1 -W 1 -i 60 -w 300 -D 2 /mnt/scratch
>>> ....
>>> Run time: 300 seconds
>>> Read latency (p50: 3,174,400) (p95: 4,530,176) (p99: 18,055,168)
>>> Write latency (p50: 14,991,360) (p95: 28,672,000) (p99: 33,325,056)
>>> Allocation latency (p50: 1,771,520) (p95: 17,530,880) (p99: 23,756,800)
>>> work rate = 4.75/sec (avg 5.24/sec) (p50: 5.79) (p95: 6.99) (p99: 6.99)
>>> alloc stall rate = 94.42/sec (avg: 51.63) (p50: 51.60) (p95: 59.12) (p99: 59.12)
>>>
>>> With the patch below:
>>>
>>> Run time: 300 seconds
>>> Read latency (p50: 3,043,328) (p95: 3,649,536) (p99: 4,710,400)
>>> Write latency (p50: 21,004,288) (p95: 27,557,888) (p99: 29,130,752)
>>> Allocation latency (p50: 280,064) (p95: 680,960) (p99: 863,232)
>>> work rate = 4.08/sec (avg 4.76/sec) (p50: 5.39) (p95: 6.93) (p99: 6.93)
>>> alloc stall rate = 0.08/sec (avg: 0.02) (p50: 0.00) (p95: 0.01) (p99: 0.01)
>>>
>>> Stall rate went to zero and stayed there at the 120s mark of the
>>> warmup. Note the p99 difference for read and allocation latency,
>>> too.
>>>
>>> I'll post some graphs tomorrow from my live PCP telemetry that
>>> demonstrate the difference in behaviour better than any words...
>>
>> Thanks Dave, this is definitely better.  But at least for the
>> multi-disk setup, it's not quite there yet.
>
> I can see why now I've run the test for half an hour to get a decent
> idea of steady state behaviour. I'll come back to that....
>
>> Your patch:
>> ___
>> Run time: 15535 seconds
>> Read latency (p50: 22,708,224) (p95: 34,668,544) (p99: 41,746,432)
>> Write latency (p50: 21,200,896) (p95: 34,799,616) (p99: 41,877,504)
>> Allocation latency (p50: 11,550,720) (p95: 31,424,512) (p99: 39,518,208)
>> work rate = 7.48/sec (avg 8.41/sec) (p50: 8.69) (p95: 9.57) (p99: 9.87)
>> alloc stall rate = 14.08/sec (avg: 14.85) (p50: 15.74) (p95: 19.74)
>> (p99: 22.04)
>>
>> Original patch:
>> ___
>> Run time: 15474 seconds
>> Read latency (p50: 20,414,464) (p95: 29,786,112) (p99: 34,275,328)
>> Write latency (p50: 15,155,200) (p95: 25,591,808) (p99: 31,621,120)
>> Allocation latency (p50: 7,675,904) (p95: 22,970,368) (p99: 29,523,968)
>> work rate = 8.33/sec (avg 10.54/sec) (p50: 10.54) (p95: 10.58) (p99: 10.58)
>> alloc stall rate = 37.08/sec (avg: 21.73) (p50: 23.16) (p95: 24.68)
>> (p99: 25.00)
>
> Ok, so stall rate is down, but the latencies are still garbage
> because stalls are happening.
>
>> I've had this running all day, but the differences stabilized after
>> 5-10 minutes.  Everyone's p99s trend higher as the day goes on, but
>> the percentage difference stays about the same.
>
> Right - they stabilise after the first few stalls because they
> dominate the p99 numbers. For example, with my patch, I saw the
> first stall event between 1080 and 1140 seconds - you can see this
> clearly in the 3rd chart:

Yes, I went back and forth a bunch of times between zeroing out the 
p50/p95/p99 periodically or leaving them to gather for the whole run. 
In general for production we average results over a whole day, so I 
ended up letting them gather.

>
> Run time: 1080 seconds
> Read latency (p50: 3,035,136) (p95: 4,284,416) (p99: 5,349,376)
> Write latency (p50: 27,623,424) (p95: 31,031,296) (p99: 45,154,304)
> Allocation latency (p50: 240,384) (p95: 709,632) (p99: 1,308,672)
> work rate = 3.75/sec (avg 3.71/sec) (p50: 3.71) (p95: 4.04) (p99: 4.04)
> alloc stall rate = 0.65/sec (avg: 0.04) (p50: 0.00) (p95: 0.03) (p99: 0.03)
> du thread is done /mnt/scratch
> ___
> Run time: 1140 seconds
> Read latency (p50: 3,035,136) (p95: 4,415,488) (p99: 6,119,424)
> Write latency (p50: 27,557,888) (p95: 31,490,048) (p99: 45,285,376)
> Allocation latency (p50: 247,552) (p95: 1,497,088) (p99: 19,496,960)
> work rate = 3.68/sec (avg 3.71/sec) (p50: 3.71) (p95: 4.04) (p99: 4.04)
> alloc stall rate = 1.65/sec (avg: 0.12) (p50: 0.00) (p95: 0.12) (p99: 0.12)
> du thread is running /mnt/scratch
>
> So a single "stall event" blows out the p99 latencies really badly.
> This is probably the single most important revelation about this
> so far...

Depending on the workload, an allocation stall rate lower than 5 is 
fine, but some tiers notice anything > 0.  If we gave hadoop stalls at 
0, they would almost certainly thank us for all the hard work, and then 
add more load.

>
>> I think the difference between mine and yours is we didn't quite get
>> the allocation stalls down to zero, so making tasks wait for the
>> shrinker shows up in the end numbers.
>
> Right, but so far we haven't answered the obvious question: what
> triggers the stall events?
>
>> For your patch, the stalls from xfs_reclaim_inodes_ag() were about
>> the same as the unpatched kernel yesterday.  We still had long tails
>> in the 30 second+ category.
>
> Because when a stall happens, it's doing more than just trashing the
> inode cache. The 4 charts I've attached in a tarball are:

We have variations for these charts in prod, but my test boxes aren't 
wired into the collection system for some of the stats yet.    We 
usually don't have the granularity of individual slabs, but it can be 
added if needed.

Many proc files do large order allocations when you open them, so they 
can skew the results.  For the next merge window, I have a patch to make 
seq_buf_alloc() fall back into vmalloc without doing direct reclaim.

The page cache on my boxes in vmstat stays relatively constant.  I think 
the huge amount of ram on these machines is soaking up the slop.  But I 
do have a more regular series of stalls (20/sec) than you do, and if I 
lightened up the workload a bit, I might see your peaks and valleys.

The size of the XFS inode cache does vary pretty dramatically, but 
that's not too surprising with the du threads (sorry).

What I found in prod is that generally the allocation stalls are tied to 
kswapd being in the D state.  Whenever they spike, he spits out a stack 
trace of being stuck <somewhere>.  Once it wasn't stuck in slab 
shrinkers, the next step was being stuck in writepage().

Johannes had a patch to change how eager kswapd was to writepage(). 
While that gets bashed out upstream, I just dropped our dirty ratios 
down to saner levels.  This brought our stalls down from ~10-100/sec to 
<1-2.

It's not perfect, our write iops and read iops both went up, but the 
application visible performance was higher so it's good enough for now. 
We also saw cases where kswapd was starved for CPU, or just sitting 
around and waiting for congested block devices to make progress.

The other comment I'll make is this workload is all spindles.  We 
definitely have flash based workloads hit by this too, but not to the 
extent these huge drives are.

I definitely agree about the value of the graphs in addition to the bpf 
probes.  The bpf histogram answer the question of "is it fixed yet" 
while the graphs help understand the rest of what's going on.  The 
biggest place bpf helps is being able to say: show me all the stack 
traces whenever kswapd is stuck longer than X usec

 From the iovisor git repo, you can try:
  offcputime.py -m 3000 -p 365 60

where 365 is the pid of one of your kswapds.  The answer it spits out is 
a mixture of writepage() and cond_resched().   Bumping the prio of 
kswapd and limiting dirty pages cuts my stall down from 20/sec to much 
lower.  We'll have to see what this looks like in the morning, but going 
back to the first parts of the run with my one liner patch:

~600 seconds
alloc stall rate = 32.08/sec (avg: 22.36) (p50: 22.36) (p95: 24.12) 
(p99: 24.12)

vs same kernel but with dirty ratios lower and kswapd prio bumped:

alloc stall rate = 3.85/sec (avg: 6.50) (p50: 7.07) (p95: 9.85) (p99: 9.85)

Thanks for looking at this.  I'm happy to try patches and dig up 
analysis from specific areas where you want to see stats from real 
workloads.

-chris

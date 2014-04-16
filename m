Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 880617F58
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 18:31:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 422BB304082
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 16:31:04 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 6MVbF3NnHH6TPrwc
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 16:31:02 -0700 (PDT)
Message-ID: <534F12B6.9010101@hardwarefreak.com>
Date: Wed, 16 Apr 2014 18:31:02 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Seeking XFS tuning advice for PostgreSQL on SATA SSDs/Linux-md
References: <534D24AB.1050605@geizhals.at> <20140415213408.GL15995@dastard>
	<534E3D98.3000600@geizhals.at>
In-Reply-To: <534E3D98.3000600@geizhals.at>
Reply-To: stan@hardwarefreak.com
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
To: Johannes Truschnigg <johannes.truschnigg@geizhals.at>, Dave Chinner <david@fromorbit.com>
Cc: NeilBrown <neilb@suse.de>, xfs@oss.sgi.com

On 4/16/2014 3:21 AM, Johannes Truschnigg wrote:
> On 04/15/2014 11:34 PM, Dave Chinner wrote:
...
>>> After digging through linux-raid archives, I think the most sensible
>>> approach are two-disk pairs in RAID1 that are concatenated via
>>> either LVM2 or md (leaning towards the latter, since I'd expect that
>>> to have a tad less overhead),
>>
>> I'd stripe them (i.e. RAID10), not concantenate them so as to load
>> both RAID1 legs evenly.
> 
> Afaik, the problem with md is that each array (I'm pretty convinced that
> also holds true for RAID10, but I'm not 100% sure) only has one
> associated kernel thread for writes, which should make that kind of

Neil will surely correct me if I missed any relatively recent patches
may have changed these.  Single write thread personalities (ones people
actually use):

RAID 1, 10, 5, 6

Unbound personalities:

RAID 0, linear

> setup worse, at least in theory and in terms of achiveable parallelism,
> than the setup I described. I'd be very happy to see a comparison
> between the two setups for high-IOPS devices, but I haven't yet found
> one anywhere.

I can't provide such a head-to-head comparison but I can provide some
insight.  With a plain HBA, 6 SSDs, and md you should test RAID50 for
this workload, an md RAID0 over two 3 drive RAID5 arrays.

Your dual socket 6 core Sandy Bridge 15MB L3 parts are 2GHz, boost clock
2.5GHz.  I've been doing tuning for a colleague with a single socket 4
core Ivy Bridge 8MB L3 part at 3.3GHz, boost clock 3.7GHz, Intel board
w/C202 ASIC, 8GB two channel DDR3, 9211-8i PCIe 2.0 x8 HBA (LSISAS 2008
ASIC), and currently 7, previously 5, Intel 520 series 480GB consumer
SSDs, no over provisioning.  These use the SandForce 2281 controller
which relies on compression for peak performance.

The array is md RAID5, metadata 1.2, 64KB chunk, stripe_cache_size 4096,
reshaped from 5 to 7 drives recently.  The system is an iSCSI target
server, poor man's SAN, and has no filesystems for the most part.  The
md device is carved into multiple LVs which are exported as LUNs, w/one
50GB LV reserved for testing/benchmarking.  With the single RAID5 write
thread we're achieving 318k parallel FIO 4KB random read IOPS, 45k per
drive as all 7 drives are in play for reads as there is no parity block
skipping as with rust.  We see a shade over 59k 4KB random write IOPS,
~10k IOPS per drive, using parallel submission, zero_buffers for
compressibility, libaio, etc.  The apparently low 59k figure appears
entirely due to GC, as you can see the latency start small and ramp up
quickly two paragraphs below.

10k per drive is in line with Intel's lowest number for the 520s 480GB
model of 9.5k IOPS, but theirs is for incompressible data.  Given Dave's
4-6k for the 840 EVO I'd say this is probably representative of hi-po
consumer SSDs with no over provisioning being saturated and not being
TRIM'd.

Cpu core burn during the write test averaged ~50% with peak of ~58%, 15
%us and 35 %sy, with the 15% being IO submission, 35% the RAID5 thread,
w/average 40-50 %wa.

> Starting 32 threads
> 
> read: (groupid=0, jobs=16): err= 0: pid=36459
>   read : io=74697MB, bw=1244.1MB/s, iops=318691 , runt= 60003msec
>     slat (usec): min=0 , max=999873 , avg= 5.90, stdev=529.35
>     clat (usec): min=0 , max=1002.4K, avg=795.43, stdev=5201.15
>      lat (usec): min=0 , max=1002.4K, avg=801.56, stdev=5233.38
>     clat percentiles (usec):
>      |  1.00th=[    0],  5.00th=[  213], 10.00th=[  286], 20.00th=[ 366],
>      | 30.00th=[  438], 40.00th=[  516], 50.00th=[  604], 60.00th=[ 708],
>      | 70.00th=[  860], 80.00th=[ 1096], 90.00th=[ 1544], 95.00th=[ 1928],
>      | 99.00th=[ 2608], 99.50th=[ 2800], 99.90th=[ 3536], 99.95th=[ 4128],
>      | 99.99th=[15424]
>     bw (KB/s)  : min=22158, max=245376, per=6.39%, avg=81462.59, stdev=22339.85
>     lat (usec) : 2=3.34%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
>     lat (usec) : 100=0.01%, 250=3.67%, 500=31.43%, 750=24.55%, 1000=13.33%
>     lat (msec) : 2=19.37%, 4=4.25%, 10=0.04%, 20=0.01%, 50=0.01%
>     lat (msec) : 100=0.01%, 250=0.01%, 1000=0.01%, 2000=0.01%
>   cpu          : usr=30.27%, sys=236.67%, ctx=239859018, majf=0, minf=64588
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=19122474/w=0/d=0, short=r=0/w=0/d=0
> write: (groupid=1, jobs=16): err= 0: pid=38376
>   write: io=13885MB, bw=236914KB/s, iops=59228 , runt= 60016msec
>     slat (usec): min=2 , max=25554K, avg=25.74, stdev=17219.99
>     clat (usec): min=122 , max=43459K, avg=4294.06, stdev=100111.47
>      lat (usec): min=129 , max=43459K, avg=4319.92, stdev=101581.66
>     clat percentiles (usec):
>      |  1.00th=[  482],  5.00th=[  628], 10.00th=[  748], 20.00th=[ 996],
>      | 30.00th=[ 1320], 40.00th=[ 1784], 50.00th=[ 2352], 60.00th=[ 3056],
>      | 70.00th=[ 4192], 80.00th=[ 5920], 90.00th=[ 8384], 95.00th=[10816],
>      | 99.00th=[17536], 99.50th=[20096], 99.90th=[57088], 99.95th=[67072],
>      | 99.99th=[123392]
>     bw (KB/s)  : min=   98, max=25256, per=6.74%, avg=15959.71, stdev=2969.06
>     lat (usec) : 250=0.01%, 500=1.25%, 750=8.72%, 1000=10.13%
>     lat (msec) : 2=23.87%, 4=24.78%, 10=24.87%, 20=5.85%, 50=0.39%
>     lat (msec) : 100=0.11%, 250=0.01%, 750=0.01%, 2000=0.01%, >=2000=0.01%
>   cpu          : usr=5.47%, sys=39.74%, ctx=54762279, majf=0, minf=62375
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=3554662/d=0, short=r=0/w=0/d=0 

If a 3.3GHz Ivy Bridge core w/8MB shared L3 can do ~60k random write
IOPS, 70k w/parity with one md RAID5 thread and 64KB chunk, at ~50% core
utilization, it seems reasonable it could do ~120/140k IOPs w/wo parity
at 100% core utilization.

A 2GHz Sandy Bridge core has 61% of the clock, and with almost double
the L3 should have ~66% of the performance.

((0.66*140k)/3= 30.8k IOPS per drive)*2 drives)= ~61k RAID5 4KB IOPS

Thus, two 3 drive md RAID5 arrays nested in an md RAID0 stripe and
optimally configured (see below) should yield up to ~122k or more random
4KB IOPS, SSD limited.  With 3x mirrors and your 830s you get ~35k per
spindle, ~105k IOPS aggregate with 3 write threads using maybe 5-10%
each of 3 cores.  You get redundancy against SSD controller/power
circuit, board failure, but not against flash wear failure as each
mirror sees 100% of the redundant byte writes.

Given you have 12 cores (disable HT as it will decrease md performance),
10 of them likely perennially idle, the better solution may be RAID50.

Doing this...

1.  Tweak IRQ affinity to keep interrupts off the md thread cores
2.  Pin RAID5 threads to cores on different NUMA nodes,
    different L3 domains, so each has 15MB of L3 available,
    core 5 on each socket is good as the process scheduler will
    hit them last
3.  Use 16KB RAID5 chunk, 32KB RAID0 chunk yielding 64KB outer stripe
4.  Set stripe_cache_size to 4096

Should get gain you this...

1.  +~17k IOPS over 3x mirrors
2.  +1 drive capacity or +85GB/drive over provisioning
3.  ~33% lower flash wear and bandwidth

For the cost of two fully utilized cores at peak IOPS.

You have primarily a DB replication workload and the master's workload
in a failover situation.  In both cases your write IO will be to one or
more journals and one or more DB files, and some indexes.  Very few
files will be created and the existing files will be modified in place
via mmap or simply appended in the case of the journals.  So this
workload has little if any allocation.  Is this correct?

If so you'd want a small stripe width and chunk size to get relatively
decent IO distribution across the nested RAID5 arrays.  Matching chunk
size to the erase block size as some recommend is irrelevant here
because all your random IOs are a tiny fraction of the erase block size.
 The elevator (assuming noop) will merge some IOs as well as the the SSD
itself, so you won't get erase block rewrites for each 4KB IO.  md will
be unable to write full stripes, so using a big chunk/stripe is pretty
useless here and just adds read overhead.

If you mkfs.xfs this md RAID0 device using the defaults it will align to
su=32KB sw=2 and create 16 AGs, unless the default has changed.
Regardless, XFS alignment to RAID geometry should be largely irrelevant
for a transactional DB workload that performs very few allocations but
mostly mmap'd modify-in-place and append operations to a small set of files.

>> [...]
>>> I've experimented with mkfs.xfs (on top of LVM only; I don't know if
>>> it takes into account lower block layers and seen that it supposedly
>>> chooses to default to an agcount of 4, which seems insufficient
>>> given the max. bandwidth our setup should be able to provide.
>>
>> The number of AGs has no bearing on acheivable bandwidth... 

with striped storage.  With concat setups it can make a big difference.
 Concat is out of scope for this discussion, but it will be covered in
detail in the documentation I'm currently working on with much expert
input from Dave.

>> The number
>> of AGs affects allocation concurrency. Hence if you have 24 CPU
>> cores, I'd expect that you want 32 AGs. Normally with a RAID array
>> this will be the default, 

You mean just striped md/dm arrays right?  AFAIK we can't yet poll
hardware RAIDs for geometry as no standard exists.  Also, was the
default agcount for striped md/dm arrays changed from the static 16 to
32, or was some intelligence added?  I admit I don't keep up with all
the patches, but if this was in the subject I'd think it would have
caught my eye.  This info would be meaningful and useful to me whereas
most patches are over my head. :(

>> but it seems that RAID1 is not triggering
>> the "optimise for allocation concurrency" heuristics in mkfs....

I thought XFS only do this for md/dm arrays with stripe geometry.  Using
a nested stripe it should kick in though.

> Thanks, that is a very useful heads-up! What's the formula used to get
> to 32 AGs for 24 CPUs - just (num_cpus * 4/3), 

Note Dave says "allocation concurrency", and what I stated up above
about typical database workloads not doing much allocation.  If yours is
typical then more AGs won't yield any additional performance.

> and is there a simple
> explanation for why this is an ideal starting point? And is that an
> advisable rule of thumb for xfs in general?

More AGs can be useful if you have parallel allocation to at least one
directory in each AG.  However with striping this doesn't provide a lot
of extra bang for the buck.  With concatenated storage and proper
file/dir/AG layout it can provide large parallel scalability of IOPS
and/or throughput depending on the hardware, for both files and metadta.
 Wait a few months for me to finish the docs.  Explaining AG
optimization requires too much text for an email exchange.  Dave and I
have done it before, somewhat piecemeal, and that's in the archives.
For your workload and SSDs AGs make zero difference.

>>> Apart from that, is there any kind of advice you can share for
>>> tuning xfs to run postgres (9.0 initially, but we're planning to
>>> upgrade to 9.3 or later eventually) on in 2014, especially
>>> performance-wise?
>>
>> Apart from the AG count and perhaps tuning the sunit/swidth to match
>> the RAID0 part of the equation, I wouldn't touch a thing unless you
>> know that there's a problem that needs fixing and you know exactly
>> what knob will fix the problem you have...

Nothing more than has already been stated.

> OK, I'll read up on stripe width impact and will (hopefully) have enough
> time to test a number of configs that should make sense.

Again, chunk/stripe won't matter much for a typical transactional DB if
using few files and no allocation.

Hope my added input is useful, valuable, and that Dave knows I was
appending some of his remarks for clarity, not attempting to correct
them. :)

Cheers,

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 155E57F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 06:36:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A3102AC002
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 04:36:26 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id VXErs9qMEn2kA1gq
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 04:36:25 -0700 (PDT)
Message-ID: <5194C4BB.9080406@hardwarefreak.com>
Date: Thu, 16 May 2013 06:36:27 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: high-speed disk I/O is CPU-bound?
References: <518CFE7C.9080708@ll.mit.edu> <20130516005913.GE24635@dastard>
In-Reply-To: <20130516005913.GE24635@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: David Oostdyk <daveo@ll.mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 5/15/2013 7:59 PM, Dave Chinner wrote:
> [cc xfs list, seeing as that's where all the people who use XFS in
> these sorts of configurations hang out. ]
> 
> On Fri, May 10, 2013 at 10:04:44AM -0400, David Oostdyk wrote:
>> Hello,
>>
>> I have a few relatively high-end systems with hardware RAIDs which
>> are being used for recording systems, and I'm trying to get a better
>> understanding of contiguous write performance.
>>
>> The hardware that I've tested with includes two high-end Intel
>> E5-2600 and E5-4600 (~3GHz) series systems, as well as a slightly
>> older Xeon 5600 system.  The JBODs include a 45x3.5" JBOD, a 28x3.5"
>> JBOD (with either 7200RPM or 10kRPM SAS drives), and a 24x2.5" JBOD
>> with 10kRPM drives.  I've tried LSI controllers (9285-8e, 9266-8i,
>> as well as the integrated Intel LSI controllers) as well as Adaptec
>> Series 7 RAID controllers (72405 and 71685).

So, you have something like the following raw aggregate drive b/w,
assuming average outer-inner track 120MB/s streaming write throughput
per drive:

45 drives ~5.4 GB/s
28 drives ~3.4 GB/s
24 drives ~2.8 GB/s

The two LSI HBAs you mention are PCIe 2.0 devices.  Note that PCIe 2.0
x8 is limited to ~4GB/s each way.  If those 45 drives are connected to
the 9285-8e via all 8 SAS lanes, you are still losing about 1/3rd of the
aggregate drive b/w.  If they're connected to the 71685 via 8 lanes and
this HBA is in a PCIe 3.0 slot then you're only losing about 600MB/s.

>> Normally I'll setup the RAIDs as RAID60 and format them as XFS, but
>> the exact RAID level, filesystem type, and even RAID hardware don't
>> seem to matter very much from my observations (but I'm willing to
>> try any suggestions).

Lack of performance variability here tends to suggest your workloads are
all streaming in nature, and/or your application profile isn't taking
full advantage of the software stack and the hardware, i.e. insufficient
parallelism, overlapping IOs, etc.  Or, see down below for another
possibility.

These are all current generation HBAs with fast multi-core ASICs and big
write cache.  RAID6 parity writes even with high drive counts shouldn't
significantly degrade large streaming write performance.  RMW workloads
will still suffer substantially as usual due to rotational latencies.
Fast ASICs can't solve this problem.

> Document them. There's many ways to screw them up and get bad
> performance.

More detailed info always helps.

>> As a basic benchmark, I have an application
>> that simply writes the same buffer (say, 128MB) to disk repeatedly.
>> Alternatively you could use the "dd" utility.  (For these
>> benchmarks, I set /proc/sys/vm/dirty_bytes to 512M or lower, since
>> these systems have a lot of RAM.)
>>
>> The basic observations are:
>>
>> 1.  "single-threaded" writes, either a file on the mounted
>> filesystem or with a "dd" to the raw RAID device, seem to be limited
>> to 1200-1400MB/sec.  These numbers vary slightly based on whether
>> TurboBoost is affecting the writing process or not.  "top" will show
>> this process running at 100% CPU.
> 
> Expected. You are using buffered IO. Write speed is limited by the
> rate at which your user process can memcpy data into the page cache.
> 
>> 2.  With two benchmarks running on the same device, I see aggregate
>> write speeds of up to ~2.4GB/sec, which is closer to what I'd expect
>> the drives of being able to deliver.  This can either be with two
>> applications writing to separate files on the same mounted file
>> system, or two separate "dd" applications writing to distinct
>> locations on the raw device.  

2.4GB/s is the interface limit of quad lane 6G SAS.  Coincidence?  If
you've daisy chained the SAS expander backplanes within a server chassis
(9266-8i/72405), or between external enclosures (9285-8e/71685), and
have a single 4 lane cable (SFF-8087/8088/8643/8644) connected to your
RAID card, this would fully explain the 2.4GB/s wall, regardless of how
many parallel processes are writing, or any other software factor.

But surely you already know this, and you're using more than one 4 lane
cable.  Just covering all the bases here, due to seeing 2.4 GB/s as the
stated wall.  This number is just too coincidental to ignore.

>> (Increasing the number of writers
>> beyond two does not seem to increase aggregate performance; "top"
>> will show both processes running at perhaps 80% CPU).

So you're not referring to dd processes when you say "writers beyond
two".  Otherwise you'd say "four" or "eight" instead of "both" processes.

> Still using buffered IO, which means you are typically limited by
> the rate at which the flusher thread can do writeback.
>
>> 3.  I haven't been able to find any tricks (lio_listio, multiple
>> threads writing to distinct file offsets, etc) that seem to deliver
>> higher write speeds when writing to a single file.  (This might be
>> xfs-specific, though)
> 
> How about using direct IO? Single threaded direct IO will beslower
> than buffered IO, but throughput should scale linearly with the
> number of threads if the IO size is large enough (e.g. 32MB).

Try this quick/dirty parallel write test using dd with O_DIRECT file
based output using 1MB IOs.  It fires up 16 dd processes writing 16
files in parallel, 4GB each.  This test should give a fairly accurate
representation of real hardware throughput.  Sum the MB/s figures from
all dd processes for the aggregate b/w.

#!/bin/sh
for i in {1..16}
do
    dd if=/dev/zero of=/XFS_dir/file.$i oflag=direct bs=1M count=4k &
done
wait

>> 4.  Cheap tricks like making a software RAID0 of two hardware RAID
>> devices does not deliver any improved performance for
>> single-threaded writes.  

As Dave C points out, you'll never reach peak throughput with single
threaded buffered IO.  You'd think it would be easy to hit peak write
speed with a single 7.2k SATA drive using a single write thread.  Here's
a salient demonstration of why this may not be the case.

$ dd if=/dev/zero of=/XFS-mount/one-thread bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 17.8513 s, 58.7 MB/s

Now a 4 thread variant of the script mentioned above:

#!/bin/sh
for i in {1..4}
do
    dd if=/dev/zero of=/XFS-mount/file.$i oflag=direct bs=1M count=512 &
done
wait

$ test.sh
512+0 records in
512+0 records out
536870912 bytes (537 MB) copied, 20.3012 s, 26.4 MB/s
512+0 records in
512+0 records out
536870912 bytes (537 MB) copied, 20.3006 s, 26.4 MB/s
512+0 records in
512+0 records out
536870912 bytes (537 MB) copied, 20.3204 s, 26.4 MB/s
512+0 records in
512+0 records out
536870912 bytes (537 MB) copied, 20.324 s, 26.4 MB/s

Single thread buffered write:	 59 MB/s
Quad thread O_DIRECT write:	105 MB/s

Again both targeting a single SATA disk.  I just ran these tests on a 13
year old machine with dual 550MHz Celeron CPUs and 384MB of PC100 DRAM,
vanilla kernel 3.2.6, deadline elevator.  The WD SATA disk is attached
via a $20 USD Silicon Image 3512 SATA 150 32 bit PCI card lacking NCQ
support.  The system bus is 33MHz/32 bit PCI only, 132MB/s peak, tested
at 115MB/s net after PCI 2.1 protocol overhead.  I keep this system
around for such demonstrations.  Note that the SATA card and drive are
10 years newer than the core system, acquired in 2009.

On this machine the single thread buffered IO dd run reaches only some
51% of the net PCI throughput and eats 98% of one of the two 550MHz
CPUs.  This is due to a number of factors including, but not limited to,
memcpy as Dave C points out, tiny 128KB L2 cache, no L3, the fact that
this platform performs snooping on the P6 bus, and other inefficiencies
of the 440BX chipset.

Now for the kicker.  Quad parallel dd direct IO reaches 92% of net PCI
throughput with each dd process eating only 14% CPU, or 28% of each CPU
total.  Its aggregate file write throughput into XFS is some 78% higher
than single thread dd using buffered IO.

> (Have not thoroughly tested this
>> configuration fully with multiple writers, though.)

You may not see a 78% bump with parallel O_DIRECT, but it should be
substantial nonetheless.

> Of course not - you are CPU bound and nothing you do to the storage
> will change that.

I'd agree 100% with Chinner if not for that pesky coincidental 2.4GB/s
number reported as the "brick wall".  A little more info should clear
this up.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

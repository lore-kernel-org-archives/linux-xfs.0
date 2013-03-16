Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B7B068067
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 06:45:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A8B67304051
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 04:45:10 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id uRivN7WIesE0w0c7
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 04:45:06 -0700 (PDT)
Message-ID: <51445B42.5090702@hardwarefreak.com>
Date: Sat, 16 Mar 2013 06:45:06 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_fsr, sunit, and swidth
References: <5140C147.7070205@binghamton.edu>
	<514113C6.9090602@hardwarefreak.com>
	<514153ED.3000405@binghamton.edu>
	<5141C1FC.4060209@hardwarefreak.com>
	<5141C8C1.2080903@hardwarefreak.com>
	<5141E5CF.10101@binghamton.edu>
	<5142AE40.6040408@hardwarefreak.com>
	<20130315114538.GF6369@dastard>
	<5143F94C.1020708@hardwarefreak.com>
	<20130316072126.GG6369@dastard>
In-Reply-To: <20130316072126.GG6369@dastard>
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
Cc: Dave Hall <kdhall@binghamton.edu>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 3/16/2013 2:21 AM, Dave Chinner wrote:
> On Fri, Mar 15, 2013 at 11:47:08PM -0500, Stan Hoeppner wrote:
>> On 3/15/2013 6:45 AM, Dave Chinner wrote:
>>> On Fri, Mar 15, 2013 at 12:14:40AM -0500, Stan Hoeppner wrote:
>>>> On 3/14/2013 9:59 AM, Dave Hall wrote:
>>>> Looks good.  75% is close to tickling the free space fragmentation
>>>> dragon but you're not there yet.
>>>
>>> Don't be so sure ;)
>>
>> The only thing I'm sure of is that I'll always be learning something new
>> about XFS and how to troubleshoot it. ;)
>>
>>>>
>>>>> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
>>>>> /dev/sdb1            5469091840 1367746380 4101345460   26% /infortrend
>>>>
>>>> Plenty of free inodes.
>>>>
>>>>> # xfs_db -r -c freesp /dev/sdb1
>>>>>    from      to extents  blocks    pct
>>>>>       1       1  832735  832735   0.05
>>>>>       2       3  432183 1037663   0.06
>>>>>       4       7  365573 1903965   0.11
>>>>>       8      15  352402 3891608   0.23
>>>>>      16      31  332762 7460486   0.43
>>>>>      32      63  300571 13597941   0.79
>>>>>      64     127  233778 20900655   1.21
>>>>>     128     255  152003 27448751   1.59
>>>>>     256     511  112673 40941665   2.37
>>>>>     512    1023   82262 59331126   3.43
>>>>>    1024    2047   53238 76543454   4.43
>>>>>    2048    4095   34092 97842752   5.66
>>>>>    4096    8191   22743 129915842   7.52
>>>>>    8192   16383   14453 162422155   9.40
>>>>>   16384   32767    8501 190601554  11.03
>>>>>   32768   65535    4695 210822119  12.20
>>>>>   65536  131071    2615 234787546  13.59
>>>>>  131072  262143    1354 237684818  13.76
>>>>>  262144  524287     470 160228724   9.27
>>>>>  524288 1048575      74 47384798   2.74
>>>>> 1048576 2097151       1 2097122   0.12
>>>>
>>>> Your free space map isn't completely horrible given you're at 75%
>>>> capacity.  Looks like most of it is in chunks 32MB and larger.  Those
>>>> 14.8m files have a mean size of ~1.22MB which suggests most of the files
>>>> are small, so you shouldn't be having high seek load (thus latency)
>>>> during allocation.
>>>
>>> FWIW, you can't really tell how bad the freespace fragmentation is
>>> from the global output like this. 
>>
>> True.
>>
>>> All of the large contiguous free
>>> space might be in one or two AGs, and the others might be badly
>>> fragmented. Hence you need to at least sample a few AGs to determine
>>> if this is representative of the freespace in each AG....
>>
>> What would be representative of 26AGs?  First, middle, last?  So Mr.
>> Hall would execute:
>>
>> ~$ xfs_db -r /dev/sdb1
>> xfs_db> freesp -a0
>> ...
>> xfs_db> freesp -a13
>> ...
>> xfs_db> freesp -a26
>> ...
>> xfs_db> quit
> 
> Yup, though I normally just  run something like:
> 
> # for i in `seq 0 1 <agcount - 1>`; do
>> xfs_db -c "freesp -a $i" <dev>
>> done
> 
> To look at the them all quickly...

Ahh, you have to put the xfs_db command in quotes if it has args.  I
kept getting an error when using -a in my command line.  Thanks.

Your command line will give histograms for all 26 AGs.  This isn't
sampling just a few as you suggested.  Do we generally want to have
users dump histograms of all their AGs to the mailing list?  Or will
sampling do?  In this case something like this?

~$ for i in [0 8 17 26]; do xfs_db -r -c "freesp -a $i" /dev/sdb1; done

>>> As it is, the above output raises alarms for me. What I see is that
>>> the number of small extents massively outnumbers the large extents.
>>> The fact that there are roughly 2.5 million extents smaller than 63
>>> blocks and that there is only one freespace extent larger than 4GB
>>> indicates to me that free space is substantially fragmented. At 25%
>>> free space, that's 250GB per AG, and if the largest freespace in
>>> most AGs is less than 4GB in length, then free space is not
>>> contiguous. i.e.  Free space appears to be heavily weighted towards
>>> small extents...`
>>
>> It didn't raise alarms for me.  This is an rsnapshot workload with
>> millions of small files.  For me it was a foregone conclusion he'd have
>> serious fragmentation.  What I was looking at is whether it's severe
>> enough to be a factor in his stated problem.  I don't think it is.  In
>> fact I think it's completely unrelated, which is why I didn't go into
>> deeper analysis of this.  Though I could be incorrect. ;)
> 
> Ok, so what size blocks are the metadata held in? 1-4 filesystem
> block extents. 

So, 4KB to 16KB.  How many of the hard links being created can we store
in each?

> So, when we do a by-size freespace btree lookup, we
> don't find a large freespace to allocate from. So we fall back to a
> by-blkno search down the freespace btree to find a neraby block of
> sufficient size. 

If we only need a free block of 4-16KB for our hardlinks, nearly any of
his free space would be usable wouldn't it?

> That search runs until we run off one end of the
> freespace btree. And when this might have to walk along several tens
> of thousand of btree records, each allocation will consume a *lot*
> of CPU time. How much? well, compared to finding a large freespace
> extent, think orders of magnitude more CPU overhead per
> allocation...

I follow you, up to a point.  I'm disconnected between the free block
size requirements for metadata, and having to potentially walk two
entire btrees looking for a free chunk of sufficient size.  Seems to me
every free extent in his histogram is usable for hardlink metadata if
our minimum is one filesystem block, or 4KB.

WRT CPU burn, I'll address my thoughts on that much further below.

>>> So, the above output would lead me to investigate the freespace
>>> layout more deeply to determine if this is going to affect the
>>> workload that is being run...
>>
>> May be time to hold class again Dave as I'm probably missing something.
>>  His slowdown is serial hardlink creation with "cp -al" of many millions
>> of files.  Hardlinks are metadata structures, which means this workload
>> modifies btrees and inodes, not extents, right?
> 
> It modifies directories and inodes, and adding directory entries
> requires allocation of new directory blocks, and that requires
> scanning of the freespace trees....

Got it.

>> XFS directory metadata is stored closely together in each AG, correct?
>> 'cp -al' is going to walk directories in order, which means we're going
>> have good read caching of the directory information thus little to no
>> random read IO. 
> 
> not f the directory is fragmented. If freespace is fragmented, then
> there's a good chance that directory blocks are not going to have
> good locality, though the effect of that will be minimised by the
> directory block readahead that is done.

Got it.  And given this box has 128GB of RAM there's probably a lot of
directory metadata alreay in cache.

>> The cp is then going to create a hardlink per file.
>> Now, even with the default 4KB write alignment, we should be getting a
>> large bundle of hardlinks per write.  And I would think the 512MB BBWC
>> on the array controller, if firmware is decent, should do a good job of
>> merging these to mitigate RMW cycles.
> 
> it's possible, but I would expect the lack of IO to be caused by the
> fact modification is CPU bound. i.e. it's taking so long for every
> hard link to be created (on average) that the IO subsystem can
> handle the read/write IO demands with ease because there is
> realtively little IO being issued.

The OP stated once CPU is throttled, two have very light load, the other
29 are idle.  The throttled core must be the one on which the cp code is
executing.  The kernel isn't going to schedule the XFS btree walking
thread(s) on the same core, is it?  So if no other cores are anywhere
near peak, isn't it safe to assume the workload isn't CPU bound due to
free space btree walking?

I should have thought of this earlier when he described the load on his
cores...

>> The OP is seeing 100% CPU for the cp operation, almost no IO, and no
>> iowait.  If XFS or RMW were introducing any latency I'd think we'd see
>> some iowait.
> 
> Right, so that leads to the conclusion that the freespace
> fragmentation is definitely a potential cause of the excessive CPU
> usage....

Is is still a candidate, given what I describe above WRT XFS thread
scheduling, and that only one core is hammered?

>> Thus I believe at this point, the problem is those millions of serial
>> user space calls in a single Perl thread causing the high CPU burn,
>> little IO, and long run time, not XFS nor the storage.  And I think the
>> OP came to this conclusion as well, without waiting on our analysis of
>> his filesystem.
> 
> Using perf to profile the kernel while the cp -al workload is
> running will tell use exactly where the CPU is being burnt. That
> will confirm the analysis, or point us at some other issue that is
> causing excessive CPU burn...

I'd like to see this as well.  Because if the bottleneck isn't XFS, I'd
like to understand how a 2GHz core with 18MB of L3 cache is being
completely consumed by a cp command which is doing nothing but creating
hardlinks--while the IO rate is almost nothing.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

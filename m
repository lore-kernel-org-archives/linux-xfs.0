Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8RK9SDw134968 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 15:09:28 -0500
Message-ID: <5064B2BE.8060405@sgi.com>
Date: Thu, 27 Sep 2012 15:10:38 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
	hang
References: <20120924171159.GG1140@sgi.com>
	<201209241809.q8OI94s3003323@eagdhcp-232-125.americas.sgi.com>
	<20120925005632.GB23520@dastard> <5061CA48.3040202@sgi.com>
	<20120925220110.GF29154@dastard> <50630DB6.4070405@sgi.com>
	<20120926234149.GJ29154@dastard>
In-Reply-To: <20120926234149.GJ29154@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: bpm@sgi.com, xfs@oss.sgi.com

On 09/26/12 18:41, Dave Chinner wrote:
> On Wed, Sep 26, 2012 at 09:14:14AM -0500, Mark Tinguely wrote:
>> On 09/25/12 17:01, Dave Chinner wrote:
>>> On Tue, Sep 25, 2012 at 10:14:16AM -0500, Mark Tinguely wrote:
>>
>> <deletes>
>>
>>>>>>
>>>>>> As a bonus, consolidating the loops into one worker actually gives a slight
>>>>>> performance advantage.
>>>>>
>>>>> Can you quantify it?
>>>>
>>>> I was comparing the bonnie and iozone benchmarks outputs. I will see
>>>> if someone can enlighten me on how to quantify those numbers.
>>>
>>> Ugh.
>>>
>>> Don't bother. Those are two of the worst offenders in the "useless
>>> benchmarks for regression testing" category. Yeah, they *look* like
>>> they give decent numbers, but I've wasted so much time looking at
>>> results from these benhmarks only to find they do basic things wrong
>>> and give numbers that vary simple because you've made a change that
>>> increases or decreases the CPU cache footprint of a code path.
>>>
>>> e.g. IOZone uses the same memory buffer as the source/destination of
>>> all it's IO, and does not touch the contents of it at all. Hence for
>>> small IO, the buffer stays resident in the CPU caches and gives
>>> unrealsitically high throughput results. Worse is the fact that CPU
>>> cache residency of the buffer can change according to the kernel
>>> code path taken, so you can get massive changes in throughput just
>>> by changing the layout of the code without changing any logic....
>>>
>>> IOZone can be useful if you know exactly what you are doing and
>>> using it to test a specific code path with a specific set of
>>> configurations. e.g. comparing ext3/4/xfs/btrfs on the same kernel
>>> and storage is fine. However, the moment you start using it to
>>> compare different kernels, it's a total crap shoot....
>>
>> does anyone have a good benchmark XFS should use to share
>> performance results? A number that we can agree a series does not
>> degrade the filesystem..
>
> ffsb and fio with benchmark style workload definitions, fsmark when
> using total runtime rather than files/s for comparison. I also have a
> bunch of hand written scripts that I've written specifically for
> purpose for testing stuff like directory traversal and IO
> parallelism scalability.
>
> The problem is that common benchmarks like iozone, postmark,
> bonnie++ and dbench are really just load generators that output
> numbers - there are all very sensitive to many non-filesystem
> changes (e.g. VM tunings) and so have to be run "just right" to
> produce meaningful numbers.  That "just right" changes from kernel
> to kernel, machine to machine (running the same kernel!) and
> filesystem to filesystem.
>
> Dbench is particularly sensitive to VM changes and tunings, as well as
> log IO latency.  e.g.  running it on the same system on different
> region of the same disk give significantly different results because
> writes to the log are slower on the inner regions of disk. Indeed,
> just changing the log stripe unit without changing anything else can
> have a marked affect on results...
>
> I have machines here that I can't use IOzone at all for IO sizes of
> less than 4MB because the timing loops it uses don't have enough
> granularity to accurately measure syscall times, and hence it
> doesn't report throughputs reliably. The worst part is that in the
> results output, it doesn't tell you it had problems - youhave to
> look inteh log files to get that information and realise that the
> entire benchmark run was compromised...
>
>> lies, damn lies, statistics and then filesystem benchmarks?! :)
>
> I think I've said that myself many times in the past. ;)

Thank-you for the information.

>
>>> I guess I don't understand what you mean by "loop on
>>> xfs_alloc_vextent()" then.
>>>
>>> The problem I see above is this:
>>>
>>> thread 1		worker 1		worker 2..max
>>> xfs_bmapi_write(userdata)
>>
>>      loops here calling xfs_bmapi_alloc()
>
> I don't think it can for userdata allocations. Metadata, yes,
> userdata, no.
>
>>>    xfs_bmapi_allocate(user)
>>>      xfs_alloc_vextent(user)
>>>        wait
>>>
>>> 			_xfs_alloc_vextent()
>>> 			locks AGF
>>
>> 			first loop it takes the lock
>
>> 			one of the next times through the above
>> 			 loop it cannot get a worker. deadlock here.
>
>>
>> 			I saved the xfs_bmalloca and fs_alloc_arg when
>> 			 allocating a buffer to verify the paths.
>>
>>> 						_xfs_alloc_vextent()
>>> 						blocks on AGF lock
>>
>>> 			completes allocation
>>>
>>>        <returns with AGF locked in transaction>
>
> And then xfs_bmapi_allocate() increments bma->nallocs after each
> successful allocation. Hence the only way we can loop there for
> userdata allocations is if the nmap parameter passes in is>  1.
>
> When it returns to xfs-bmapi_write(), it trims and updates the map,
> and then this code prevents it from looping:
>
>                  /*
>                   * If we're done, stop now.  Stop when we've allocated
>                   * XFS_BMAP_MAX_NMAP extents no matter what.  Otherwise
>                   * the transaction may get too big.
>                   */
>                  if (bno>= end || n>= *nmap || bma.nallocs>= *nmap)
>                          break;
>
> Because the userdata callers use these values for *nmap:
>
> 	xfs_iomap_write_direct		nimaps = 1;
> 	xfs_iomap_write_allocate	nimaps = 1;
> 	xfs_iomap_write_unwritten	nimaps = 1;
> 	xfs_alloc_file_space		nimaps = 1;
>
> So basically there will break out of the loop after a single
> allocation, and hence should not be getting stuck on a second
> allocation in xfs_bmapi_allocate()/xfs_alloc_vextent() with the AGF
> locked from this code path.
>
>
>>>      xfs_bmap_add_extent_hole_real
>>>        xfs_bmap_extents_to_btree
>>>          xfs_alloc_vextent(user)
>>>            wait
>>
>> 	this does not need a worker, and since in the same
>
> I agree that it does not *need* a worker, but it will *use* a worker
> thread if args->userdata is not initialised to zero.
>
>>             transaction all locks to the AGF buffer are recursive locks.
>
> Right, the worker won't block on the AGF lock, but if it can't get a
> worker because they are all blocked on the AGF lock, then it
> deadlocks.
>
> As I said before, I cannot see any other path that will trigger a
> userdata allocation with the AGF locked. So does patch 3 by itself
> solve the problem?
>


I thought I tried it, but I will retry it when I have a free machine.


--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

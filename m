Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC6EE7F50
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 18:55:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BBFC58F8033
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 16:55:49 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id BLWoxafUlDTwHQAY
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 16:55:48 -0700 (PDT)
Message-ID: <5446F29F.7090406@hardwarefreak.com>
Date: Tue, 21 Oct 2014 18:56:15 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: gather write metrics on multiple files
References: <543611CF.6030904@hardwarefreak.com> <543613E7.70508@gmail.com>
	<54361C04.5090404@hardwarefreak.com>
	<20141009211339.GD4376@dastard>
	<544202AE.3000003@hardwarefreak.com>
	<5442AE9A.7030703@hardwarefreak.com>
	<20141019222434.GL17506@dastard>
In-Reply-To: <20141019222434.GL17506@dastard>
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
Cc: xfs@oss.sgi.com


On 10/19/2014 05:24 PM, Dave Chinner wrote:
> [ please word wrap your emails at 68-72 columns ]
> 
> On Sat, Oct 18, 2014 at 01:16:58PM -0500, Stan Hoeppner wrote:
>> On 10/18/2014 01:03 AM, Stan Hoeppner wrote:
>>> On 10/09/2014 04:13 PM, Dave Chinner wrote:
>>> ...
>>>>> I'm told we have 800 threads writing to nearly as many files
>>>>> concurrently on a single XFS on a 12+2 spindle RAID6 LUN.
>>>>> Achieved data rate is currently ~300 MiB/s.  Some of these are
>>>>> files are supposedly being written at a rate of only 32KiB every
>>>>> 2-3 seconds, while some (two) are ~50 MiB/s.  I need to determine
>>>>> how many bytes we're writing to each of the low rate files, and
>>>>> how many files, to figure out RMW mitigation strategies.  Out of
>>>>> the apparent 800 streams 700 are these low data rate suckers, one
>>>>> stream writing per file.  
>>>>>
>>>>> Nary a stock RAID controller is going to be able to assemble full
>>>>> stripes out of these small slow writes.  With a 768 KiB stripe
>>>>> that's what, 24 seconds to fill it at 2 seconds per 32 KiB IO?
>>>>
>>>> Raid controllers don't typically have the resources to track
>>>> hundreds of separate write streams at a time. Most don't have the
>>>> memory available to track that many active write streams, and those
>>>> that do probably can't proritise writeback sanely given how slowly
>>>> most cachelines would be touched. The fast writers would simply tune
>>>> over the slower writer caches way too quickly.
>>>>
>>>> Perhaps you need to change the application to make the slow writers
>>>> buffer stripe sized writes in memory and flush them 768k at a
>>>> time...
>>>
>>> All buffers are now 768K multiples--6144, 768, 768, and I'm told
>>> the app should be writing out full buffers.  However I'm not
>>> seeing the throughput increase I should given the amount that
>>> the RMWs should have decreased, which, if my math is correct,
> 
> Maybe that's not your problem. What's the storage array tell you
> about RMW cycles? What's it tell you about lun utilisation - is it
> even or do you have hot luns?

Maybe not.  If what I'm told about the controller statistics screen is
correct, RMWs, or "small destages", are far less than 0.5% of total
destages.  However that rate didn't change noticeably when I switched to
stripe aligned buffer sizes of 768K vs 160K.  Watching the stats in real
time shows zero small destages for long periods of time, then a burst of
them, then nothing again.  I'm told the firmware ignores all low rate
IOs so cache lines can be dedicated to the fast writers, and it only
waits 3 seconds to assemble full stripes for writeback.  So what I'm
seeing maybe doesn't match what I'm being told.  I've been given no docs
for the controllers because they haven't apparently been written yet.  I
must trust what I'm told.  Again, these controllers are in a beta stage
of development.

Hot LUNs isn't an issue as we have one filesystem per LUN, and one LUN
per controller.  At least in this test rig.

>>> should be about half (80) the raw actuator seek rate of these
>>> drives (7.2k SAS).
> 
> Not all drives seek at the same rate. Typically for a RAID 6 array,
> every disk you add to the width of the lun slows the seek rate for
> full stripe writes by 2-3%. So a 12+2 lun is going to have an
> average seek rate of 25-30% lower than a 2+1 lun on full stripe
> writes....

Right.  And partial stripe writes will hit a subset of disks, thus the
associated RMW read will cause extra seeks on one or more of these, and
possibly two others to read parity (RAID6).  The rig I'm testing at the
moment has two 12+1 RAID5 arrays so, only one parity seek on RMW.

>>> Something isn't right.  I'm guessing it's
>>> the controller firmware, maybe the test app, or both.  The test
>>> app backs off then ramps up when response times at the
>>> controller go up and back down.  And it's not super accurate or
>>> timely about it.  The lowest interval setting possible is 10
>>> seconds.  Which is way too high when a controller goes into
>>> congestion.
> 
> The controller should not have any problems with this. If the
> controller IO response times are varying significantly, then you're
> doing something wrong - most probably caching in BBWC rather than
> writing through to disk immediately...

When a controller goes into congestion I see await and avgqu-sz in
iostat jump from 15-50ms steady state up into the hundreds, then into
the thousands of ms if we don't back down the IOs being submitted.  This
is with O_DIRECT, and with and without using AIO.  Once we do back it
down the controller eventually recovers after tens of seconds to a
minute or so, and wait and queue size drop back down to 'normal'.

Due to the number of streams write-through mode would simply make every
IO an RMW and throughput would be abysmal.  I've been testing a two LUN
config with 402 streams per LUN, per XFS filesystem, but the design is
up to 14 LUNs.  So we're talking in excess of 5600 IO streams with the
test harness, possible over 10k in customer hands, or 2600 to 5000 IO
streams per controller.  So writeback and sorting high rate sectors into
stripes is mandatory.

With the to LUN setup I'm working with I see the controllers go into
congestion and iostats await jumps from 10-50ms steady state up into the
hundreds and low thousands of ms.  And avgqu-sz just soars.  Whether
this is due to poor writeback performance or seeking the drives to death
remains to be seen.  Could be a combination of both.

>>> Does XFS give alignment hints with O_DIRECT writes into
>>> preallocated files?
> 
> What do you mean? if the file is preallocated and aligned, then
> the IO alignment is wholly up to the application. i.e. if the
> application is not doing aligned IO, then there's nothing the
> filesystem can do to align it...

I mean during writeout to the block layer.  O_DIRECT writes from the app
must be multiples of 4K.  Does XFS do anything different on writeout if
the app writes 160k vs 768k, when the FS was created with alignment,
writing to files created with posix_fallocate()?  Does XFS group them
into clusters of 1536 sectors?  Or does it just sling pages (8 sectors)
to the block layer?

Forgive my ignorance.  Our mentoring sessions never got this deep into
the stack.  Though we did touch the surface on CDBs and DMA from memory
to the HBA in one discussion.

>>> The filesystems were aligned at make time
>>> w/768K stripe width, so each prealloc file should be aligned on
>>> a stripe boundary.
> 
> "should be aligned"? You haven't verified they are aligned by using
> with 'xfs_bmap -vp'?

If I divide the start of the block range by 192 (768k/4k) those files
checked so far return a fractional value.  So I assume this means these
files are not stripe aligned.  What might cause that given I formatted
with alignment?

>>> I've played with the various queue settings,
>>> even tried deadline instead of noop hoping more LBAs could be
>>> sorted before hitting the controller.  Can't seem to get a
>>> repeatable increase.  I've nr_requests at 524288, rq_affinity 2,
>>> read_ahead_kb 0 since reads are <20% of the IO, add_random 0,
>>> etc.  Nothing seems to help really.
> 
> nr_requests = 524288? Why do you want to queue half a million IOs
> once the CTQ depth has overflowed? That's a major latency problem
> right there.

As I said I was hoping this would give the elevator a larger window in
which to sort IOs into sequential writes.  The documentation of
nr_requests is pretty sparse.  Says the kernel will use only as many as
needed, IIRC.  The default is 128 and I saw additional throughput with
8192.  I bumped it up to 131072, then 524288 as a test.  Neither of the
last two seems to help or hurt, but 8192 helped, with noop.

> You've got latency problems, so your should be removing any source

Latency is only a problem once the controller becomes saturated and
congested.  This occurs somewhere between 250-400 MB/s, but is variable.
 It seems to depend on which sets of files are being written at a given
moment.  Due to the scattered file layout across all 44 AGs it seems
logical to me that seeking up/down the platters is the primary problem.
 We're riting 403 files in parallel, albeit at different rates.  If at
one moment we're mostly hitting AGs 0-10 we're not seeking all that
much.  The next moment we may be writing two high rates files, one in
AG0 and one in AG44, and 50 medium rate files in AGs 12-35.  The
application data rate hasn't changed, but our seek distance, pattern,
and times, are dramatically increased.

I've not yet performed a full file location analysis as we generate over
27k files, and I've not figured out a way to automate this.  But I have
already recommended we optimize the file layout, if possible, to avoid
this situation, as I know we already have this seek latency problem to
some degree.

> of potential or variable latency in the IO stack. e.g. turning off
> all IO scheduler queuing, reducing CTQ depth and using write through
> caching so you can observe the behaviour of the raw luns. Strip it
> right back, then observe...

As I said we can't do write-through.  And I'm pretty sure the latency is
seek latency, not IO path latency.  The disks are slow, 7.2k, in parity
RAID, and we're writing 400 files concurrently--2 fast, 50 medium, and
350 slow, along with 20% random reads thrown in, so reading 80 files
concurrently with the writes.  All against 12 effective 7.2k spindles in
RAID5, or RAID6.

Common sense, or should I say experience, tells me the performance cliff
is insufficient actuator bandwidth for the workload as we currently lay
out the files across the AGs.  So this is where I'm focusing my efforts
at the moment.

>> Some additional background:
>>
>>     Num. Streams     = 350
>>     WRITING:
>>         Num. Write Threads  = 100
>>         Avg. Write Rate     =       72 KiB/s
>>         Avg. Write Intvl    = 10666.666 ms
>>         Num. Write Buffers  = 426
>>         Write Buffer Size   = 768 KiB
>>         Write Buffer Mem.   = 327168 KiB
>>         Group Write Rate    =    25200 KiB/s
>>         Avg. Buffer Rate    = 32.812 bufs/s
>>         Avg. Buffer Intvl.  = 30.476 ms
>>         Avg. Thread Intvl.  = 3047.600 ms
>>
>> The 350 streams are written to 350 preallocated files in parallel.
> 
> And they layout of those files are? If you don't know the physical
> layout of the files and what disks in the storage array they map to,
> then you can't determine what the seek times should be. If you can't
> work out what the seek times should be, then you don't know what the
> stream capacity of the storage should be.

Precisely.  Currently working this issue as mentioned.  Interestingly, I
tried to explain this on day one during my site visit, but nobody wanted
to listen:  "We don't have to worry about file layout with EXT4.  We
shouldn't have to with XFS.  We should just be able to create our
directories and files how we want on a single mount point. etc, etc".  6
weeks later, they're finally ready to listen, somewhat, after all other
tweaking has led to very few gains.

Nobody wants to rewrite their app, whether the test harness group, or
the production app group, to get performance.  This is their first time
through this.  AAIU, their previous product didn't use a filesystem, but
wrote raw to the storage, similar to how some DB vendors used to do it.
 So simply getting them to listen to knew ways of doing things is
difficult.  I guess on the plus side they may keep extending my contract
as they find more value in the advice and information I'm providing.
Moving so slow and chewing through concrete walls is frustrating, however.

> Keep in mind that single extent files are optimised for read
> performance, not write performance. i.e. by default XFS trades off
> some write performance to improve file read performance.  Optimising
> for highest write speeds means linearising all writes (i.e. reducing
> seeks), while XFS's default behaviour is to separate them into
> different regions of the disk (increasing seeks).

Ok, so their idea in using preallocated files was to guarantee space and
prevent file and free space fragmentation.  They loop through the files
once they fill, overwriting them at some point for reuse, IIUC.

The large stream files are 2.5-4.8 GB, and those are the largest, the
mediums are 1.5-2.7 GB, the smalls are 197-314 MB.  We should be able to
split them up across the AGs in a manner in which the heads are sweeping
only one or two adjacent AGs at a time for each 402 IOs, walking from
the outer platter edge to inner as we progress through the files.  I've
checked a few of the large and they are two extents each, one very large
one in AG13 and a very small one in AG15.  This is a result of spillage
when AG13 filled, I assume.  A binary creates the directories and files
and I've not seen the source yet.  I'm guessing it's done in parallel
instead of serially, so the directories are likely scattered across the
AGs in a random order.

Speaking of this, when I straighten this out, how does one create a
large number of directories serially as to ensure placement on
sequential AGs?  Do waits need to be added between each mkdir, for example?

> IOWs, write rates are likely to go up if you allow files to be
> fragmented and interleaved to make writes more sequential.

With this many write streams and slow disks I think the primary goal
should be minimizing large distance seeks during writes (i.e. AG0 to
AG43 and back, platter edge to platter edge).  Proper file placement
matching the application's write pattern should achieve this.  Does it
matter then if we use preallocated or allocated files?  Sticking with
prealloc files prevents fragmentation, and thus free space btree lookup
slowdowns.  Or am I missing you here?

> The down side is that reads will then seek, but if reads aren't the
> primary workload, nor a performance sensitive operation, then
> perhaps you're optimising for the wrong operation....

Perhaps.  I think it's more likely we just haven't been on exactly the
same page, probably because I'd not explained things thoroughly enough
to this point.

My next test is to be 44 O_DIRECT write threads in parallel, writing one
allocated file in each AG, then 22 files each in AG0 and AG1.  This to
demonstrate the throughput differences due to full stroke platter
seeking vs localized short stroke seeking.  Sure, I'll lose some
allocation parallelism but it should still demonstrate the point.  I
need something to convince the guys that modifying their app has promise.

Thanks Dave,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

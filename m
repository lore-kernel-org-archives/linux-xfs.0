Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B6AF7F73
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 11:54:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47823304048
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 09:54:34 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 2RL2tmGGXAQ96xX2
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 09:54:33 -0700 (PDT)
Message-ID: <544FCA6A.5060206@hardwarefreak.com>
Date: Tue, 28 Oct 2014 11:55:06 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: makefs alignment issue
References: <544AB289.8010005@hardwarefreak.com> <544AB338.2050905@sandeen.net>
	<544ACDC4.1070501@hardwarefreak.com>
	<544AD077.4080305@sandeen.net> <544AD234.3060100@sandeen.net>
	<544B1439.6060509@hardwarefreak.com> <544BC6FA.8090101@sandeen.net>
	<544BDF55.9040804@hardwarefreak.com>
	<20141026234325.GB6880@dastard>
	<544ECF65.8090806@hardwarefreak.com>
	<20141028003219.GC16186@dastard>
In-Reply-To: <20141028003219.GC16186@dastard>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



On 10/27/2014 07:32 PM, Dave Chinner wrote:
> On Mon, Oct 27, 2014 at 06:04:05PM -0500, Stan Hoeppner wrote:
>> On 10/26/2014 06:43 PM, Dave Chinner wrote:
>>> On Sat, Oct 25, 2014 at 12:35:17PM -0500, Stan Hoeppner wrote:
>>>> If the same interface is used for Linux logical block devices (md, dm,
>>>> lvm, etc) and hardware RAID, I have a hunch it may be better to
>>>> determine that, if possible, before doing anything with these values.
>>>> As you said previously, and I agree 100%, a lot of RAID vendors don't
>>>> export meaningful information here.  In this specific case, I think the
>>>> RAID engineers are exporting a value, 1 MB, that works best for their
>>>> cache management, or some other path in their firmware.  They're
>>>> concerned with host interface xfer into the controller, not the IOs on
>>>> the back end to the disks.  They don't see this as an end-to-end deal.
>>>> In fact, I'd guess most of these folks see their device as performing
>>>> magic, and it doesn't matter what comes in or goes out either end.
>>>> "We'll take care of it."
>>>
>>> Deja vu. This is an isochronous RAID array you are having trouble
>>> with, isn't it?
>>
>> I don't believe so.  I'm pretty sure the parity rotates; i.e. standard
>> RAID5/6.
> 
> The location of parity doesn't dtermine that it is isochronous in
> behaviour or not. Often RAID5/6 is marketing speak for "single/dual
> parity", not the type of redundancy that is implemented in the
> hardware ;)

Yea, I know.  It's the lack of buffering/blocking that makes it
isochronous.  Above I was referring to something you said last year:

http://oss.sgi.com/archives/xfs/2013-06/msg00981.html

"And at the other end of the scale, isochronous RAID arrays tend to
have dedicated parity disks so that data read and write behaviour is
deterministic and therefore predictable from a high level...."

>>> FWIW, do your problems go away when you make you hardware LUN width
>>> a multiple of the cache segment size?
>>
>> Hadn't tried it.  And I don't have the opportunity now as my contract
>> has ended.  However the problems we were having weren't related to
>> controller issues but excessive seeking.  I mentioned this in that
>> (rather lengthy) previous reply.
> 
> Right, but if you had a 768k stripe width and a 1MB cache segment
> size, a cache segment operation would require two stripe widths to
> be operated on, and only one would be a whole stripe width. hence
> the possibility of doing more IOs than are necessary to populate
> or write back cache segments. i.e. it's a potential reason for
> why the back end disks didn't have anywhere near the expected seek
> capability they were supposed to have....

That's a very good point.  And would be performance suicide for a vendor
pushing 224 drive arrays packed w/7.2 drives.  I don't think that's
what's happening here though, as testing with 132 parallel dd threads
shows 1375 MB/s to the outer most AG.  Peak single thread buffered dd
write is ~1500 - 1800 MB/s depending on file size, etc.  So with the
right parallel workload we can achieve pretty close t peak LUN throughput.

>>>> optimal_io_size.  I'm guessing this has different meaning for different
>>>> folks.  You say optimal_io_size is the same as RAID width.  Apply that
>>>> to this case:
>>>>
>>>> hardware RAID 60 LUN, 4 arrays
>>>> 16+2 RAID6, 256 KB stripe unit, 4096 KB stripe width
>>>> 16 MB LUN stripe width
>>>> optimal_io_size = 16 MB
>>>>
>>>> Is that an appropriate value for optimal_io_size even if this is the
>>>> RAID width?  I'm not saying it isn't.  I don't know.  I don't know what
>>>> other layers of the Linux and RAID firmware stacks are affected by this,
>>>> nor how they're affected.
>>>
>>> yup, i'd expect minimum = 4MB (i.e stripe unit 4MB so we align to
>>> the underlying RAID6 luns) and optimal = 16MB for the stripe width
>>> (and so with swalloc we align to the first lun in the RAID0).
>>
>> At minimum 4MB how does that affect journal writes which will be much
>> smaller, especially with a large file streaming workload, for which this
>> setup is appropriate?  Isn't the minimum a hard setting?  I.e. we can
>> never do an IO less than 4MB?  Do other layers of the stack use this
>> variable?  Are they expecting values this large?
> 
> No, "minimum_io_size" is for "minimum *efficient* IO size" not the
> smallest supported IO size. The smallest supported IO sizes and
> atomic IO sizes are defined by hw_sector_size,
> physical_block_size and logical_block_size.

Ok got it.  So this value is a performance hint.  So would it be better
for RAID vendors to simply populate these values with zeros instead of
values that don't match the LUN geometry, as is the case with the arrays
I've been working with?

BTW, where/how are these values obtained?  Are they returned to a SCSI
inquiry?  If so, which SCSI command?

Thanks,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 090E97F8B
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 18:03:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7BC29AC006
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 16:03:34 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id sHh9YpAcN74VtOhk
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 16:03:33 -0700 (PDT)
Message-ID: <544ECF65.8090806@hardwarefreak.com>
Date: Mon, 27 Oct 2014 18:04:05 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: makefs alignment issue
References: <544AB289.8010005@hardwarefreak.com> <544AB338.2050905@sandeen.net>
	<544ACDC4.1070501@hardwarefreak.com>
	<544AD077.4080305@sandeen.net> <544AD234.3060100@sandeen.net>
	<544B1439.6060509@hardwarefreak.com> <544BC6FA.8090101@sandeen.net>
	<544BDF55.9040804@hardwarefreak.com>
	<20141026234325.GB6880@dastard>
In-Reply-To: <20141026234325.GB6880@dastard>
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

On 10/26/2014 06:43 PM, Dave Chinner wrote:
> On Sat, Oct 25, 2014 at 12:35:17PM -0500, Stan Hoeppner wrote:
>> If the same interface is used for Linux logical block devices (md, dm,
>> lvm, etc) and hardware RAID, I have a hunch it may be better to
>> determine that, if possible, before doing anything with these values.
>> As you said previously, and I agree 100%, a lot of RAID vendors don't
>> export meaningful information here.  In this specific case, I think the
>> RAID engineers are exporting a value, 1 MB, that works best for their
>> cache management, or some other path in their firmware.  They're
>> concerned with host interface xfer into the controller, not the IOs on
>> the back end to the disks.  They don't see this as an end-to-end deal.
>> In fact, I'd guess most of these folks see their device as performing
>> magic, and it doesn't matter what comes in or goes out either end.
>> "We'll take care of it."
> 
> Deja vu. This is an isochronous RAID array you are having trouble
> with, isn't it?

I don't believe so.  I'm pretty sure the parity rotates; i.e. standard
RAID5/6.

> FWIW, do your problems go away when you make you hardware LUN width
> a multiple of the cache segment size?

Hadn't tried it.  And I don't have the opportunity now as my contract
has ended.  However the problems we were having weren't related to
controller issues but excessive seeking.  I mentioned this in that
(rather lengthy) previous reply.

>> optimal_io_size.  I'm guessing this has different meaning for different
>> folks.  You say optimal_io_size is the same as RAID width.  Apply that
>> to this case:
>>
>> hardware RAID 60 LUN, 4 arrays
>> 16+2 RAID6, 256 KB stripe unit, 4096 KB stripe width
>> 16 MB LUN stripe width
>> optimal_io_size = 16 MB
>>
>> Is that an appropriate value for optimal_io_size even if this is the
>> RAID width?  I'm not saying it isn't.  I don't know.  I don't know what
>> other layers of the Linux and RAID firmware stacks are affected by this,
>> nor how they're affected.
> 
> yup, i'd expect minimum = 4MB (i.e stripe unit 4MB so we align to
> the underlying RAID6 luns) and optimal = 16MB for the stripe width
> (and so with swalloc we align to the first lun in the RAID0).

At minimum 4MB how does that affect journal writes which will be much
smaller, especially with a large file streaming workload, for which this
setup is appropriate?  Isn't the minimum a hard setting?  I.e. we can
never do an IO less than 4MB?  Do other layers of the stack use this
variable?  Are they expecting values this large?

> This should be passed up unchanged through the stack if none of the
> software layers are doing other geometry modifications (e.g. more
> raid, thinp, etc).

I agree, if RAID vendors all did the right thing...

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

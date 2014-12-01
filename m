Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5F1F67F5A
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 16:51:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B8D48F808F
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 14:51:05 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	k3gXeYCIYtbbR0ml for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 14:51:03 -0800 (PST)
Date: Tue, 2 Dec 2014 09:51:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: file journal fadvise
Message-ID: <20141201225100.GO16151@dastard>
References: <alpine.DEB.2.00.1411301013490.352@cobra.newdream.net>
	<CALurOm2tEV=RqN21eFJvfU1zTtJkbz2gHDCk_Ntsy4oz9iwHoA@mail.gmail.com>
	<alpine.DEB.2.00.1411301922220.352@cobra.newdream.net>
	<547CBEFA.3000204@redhat.com>
	<alpine.DEB.2.00.1412011122020.3471@cobra.newdream.net>
	<547CEC36.6070309@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <547CEC36.6070309@redhat.com>
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
To: mnelson@redhat.com
Cc: Sage Weil <sweil@redhat.com>, ceph-devel <ceph-devel@vger.kernel.org>, =?utf-8?B?6ams5bu65pyL?= <majianpeng@gmail.com>, xfs@oss.sgi.com

On Mon, Dec 01, 2014 at 04:31:18PM -0600, Mark Nelson wrote:
> 
> 
> On 12/01/2014 01:23 PM, Sage Weil wrote:
> >On Mon, 1 Dec 2014, Mark Nelson wrote:
> >>On 11/30/2014 09:26 PM, Sage Weil wrote:
> >>>On Mon, 1 Dec 2014, ??? wrote:
> >>>>Hi sage:
> >>>>   For fadvise_random it only change the file readahead. I think it make
> >>>>no sense for xfs
> >>>>Becasue xfs don't like btrfs, the journal write always on old place(at
> >>>>first allocated). We only can make those place contiguous.
> >>>
> >>>I'm thinking of the OSD journal, which can be a regular file.  I guess it
> >>>would probably be an allocator mode, set via a XFS_XFLAG_* flag passed to
> >>>an ioctl, which makes the delayed allocation especially unconcerned with
> >>>keeping blocks contiguous.  It would need to be combined with the discard
> >>>ioctl so that any journal write can be allocated wherever it is most
> >>>convenient (hopefully contiguous to some other write).
> >>>
> >>>sage
> >>
> >>Hi Sage,
> >>
> >>Could you quick write down the steps you are thinking we'd take to implement
> >>this?  I'm concerned about the amount of overhead this could cause but I want
> >>to make sure I'm thinking about it correctly. Especially when trim happens and
> >>what you think/expect to happens at the FS and device levels.
> >
> >1- set journal_discard = true
> >2- add journal_preallocate = true config option, set it to false, and make
> >the fallocate(2) call on journal create conditional on that.
> >3- test with defaults (discard = false, preallocate = true) and
> >compare it to discard = true + preallocate = false (with file journal).
> >4- possibly add a call to set extsize to something small on the journal
> >file.  Or give xfs some other appropriate hint, if one exists.

What behaviour are you wanting for a journal file? it sounds like
you want it to behave like a wandering log: automatically allocating
it's next block where-ever the previous write of any kind occurred?

We can't actually do that in XFS - we have no idea where the last
write IO occurred because that's several layers down the IO stack.
We could store where the last allocation was, but that doesn't
guarantee we can allocate another block contiguously to that. Even
if we do, that then fragments whatever file the journal block now
sits adjacent to.

The other issue is that block allocation is divided up into
allocation groups, and allocation is mostly siloed to avoid randomly
allocating a file into different AGs. Just randomly allocating
blocks to a file is the polar opposite of everything the XFS
allocation strategies do, hence a bit more clarity on what the
overall goal is would be helpful. ;)

> >
> >sage
> 
> CCing XFS devel so we can get some feedback from those guys too.
> 
> Question:  Looking through our discard code in common/blkdev.cc, it
> looks like the new discard implementation is using blkdiscard.  For
> co-located journals should we be using fstrim_range?

If you are talking about journals hosted in files on a filesystem,
then discard is the wrong operation to be performing. Discard/trim
operates solely on free filesystem space, and you have to free the
space from the file before you can discard it. To free the space
from the file you need to punch a hole in it. i.e. you need to use
fallocate(FALLOC_FL_PUNCH_HOLE).

> FWIW there were some performance tests done quite a while ago:
> 
> http://people.redhat.com/lczerner/discard/files/Performance_evaluation_of_Linux_DIscard_support_Dev_Con2011_Brno.pdf

Quite frankly, you do not want to use realtime discard - it has too
many performance issues associated with it, not to mention there are
randomly broken firmwares out there that don't handle high volumes
or frequent discard operations at all well (i.e. the devices hang
and/or trash the wrong data).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

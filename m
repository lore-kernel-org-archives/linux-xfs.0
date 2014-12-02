Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0BEDE7F57
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 18:32:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8009FAC01D
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 16:32:45 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	c0nQhy2gFej5qax9 for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 16:32:42 -0800 (PST)
Date: Tue, 2 Dec 2014 11:32:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: file journal fadvise
Message-ID: <20141202003239.GP16151@dastard>
References: <alpine.DEB.2.00.1411301013490.352@cobra.newdream.net>
	<CALurOm2tEV=RqN21eFJvfU1zTtJkbz2gHDCk_Ntsy4oz9iwHoA@mail.gmail.com>
	<alpine.DEB.2.00.1411301922220.352@cobra.newdream.net>
	<547CBEFA.3000204@redhat.com>
	<alpine.DEB.2.00.1412011122020.3471@cobra.newdream.net>
	<547CEC36.6070309@redhat.com> <20141201225100.GO16151@dastard>
	<alpine.DEB.2.00.1412011559200.3471@cobra.newdream.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1412011559200.3471@cobra.newdream.net>
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
To: Sage Weil <sweil@redhat.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>, =?utf-8?B?6ams5bu65pyL?= <majianpeng@gmail.com>, mnelson@redhat.com, xfs@oss.sgi.com

On Mon, Dec 01, 2014 at 04:12:03PM -0800, Sage Weil wrote:
> On Tue, 2 Dec 2014, Dave Chinner wrote:
> > On Mon, Dec 01, 2014 at 04:31:18PM -0600, Mark Nelson wrote:
> > > 
> > > 
> > > On 12/01/2014 01:23 PM, Sage Weil wrote:
> > > >On Mon, 1 Dec 2014, Mark Nelson wrote:
> > > >>On 11/30/2014 09:26 PM, Sage Weil wrote:
> > > >>>On Mon, 1 Dec 2014, ??? wrote:
> > > >>>>Hi sage:
> > > >>>>   For fadvise_random it only change the file readahead. I think it make
> > > >>>>no sense for xfs
> > > >>>>Becasue xfs don't like btrfs, the journal write always on old place(at
> > > >>>>first allocated). We only can make those place contiguous.
> > > >>>
> > > >>>I'm thinking of the OSD journal, which can be a regular file.  I guess it
> > > >>>would probably be an allocator mode, set via a XFS_XFLAG_* flag passed to
> > > >>>an ioctl, which makes the delayed allocation especially unconcerned with
> > > >>>keeping blocks contiguous.  It would need to be combined with the discard
> > > >>>ioctl so that any journal write can be allocated wherever it is most
> > > >>>convenient (hopefully contiguous to some other write).
> > > >>>
> > > >>>sage
> > > >>
> > > >>Hi Sage,
> > > >>
> > > >>Could you quick write down the steps you are thinking we'd take to implement
> > > >>this?  I'm concerned about the amount of overhead this could cause but I want
> > > >>to make sure I'm thinking about it correctly. Especially when trim happens and
> > > >>what you think/expect to happens at the FS and device levels.
> > > >
> > > >1- set journal_discard = true
> > > >2- add journal_preallocate = true config option, set it to false, and make
> > > >the fallocate(2) call on journal create conditional on that.
> > > >3- test with defaults (discard = false, preallocate = true) and
> > > >compare it to discard = true + preallocate = false (with file journal).
> > > >4- possibly add a call to set extsize to something small on the journal
> > > >file.  Or give xfs some other appropriate hint, if one exists.
> > 
> > What behaviour are you wanting for a journal file? it sounds like
> > you want it to behave like a wandering log: automatically allocating
> > it's next block where-ever the previous write of any kind occurred?
> 
> Precisely.  Well, as long as it is adjacent to *some* other scheduled 
> write, it would save us a seek.  The real question, I guess, is whether 
> there is an XFS allocation mode that makes no attempt to avoid 
> fragmentation for the file and that chooses something adjacent to other 
> small, newly-written data during delayed allocation.

Ok, so what is the most common underlying storage you need to
optimise for? Is it raid5/6 where a small write will trigger a
larger RMW cycle and so proximity rather than exact adjacency
matters, or is it raid 0/1/jbod where exact adjacency is the only
way to avoid a seek?

I suspect that we can play certain tricks to trigger unaligned,
discontiguous allocation (i.e. no target allocation block), but the
question is whether we can get determine sufficient
allocation/writeback context to enable delayed allocation to make
sensible "next written block" decisions.

> > We can't actually do that in XFS - we have no idea where the last
> > write IO occurred because that's several layers down the IO stack.
> > We could store where the last allocation was, but that doesn't
> > guarantee we can allocate another block contiguously to that. Even
> > if we do, that then fragments whatever file the journal block now
> > sits adjacent to.
> > 
> > The other issue is that block allocation is divided up into
> > allocation groups, and allocation is mostly siloed to avoid randomly
> > allocating a file into different AGs. Just randomly allocating
> > blocks to a file is the polar opposite of everything the XFS
> > allocation strategies do, hence a bit more clarity on what the
> > overall goal is would be helpful. ;)
> 
> It's a circular file, usually a few GB in site, written sequentially with 
> a range of small to large (block-aligned) write sizes, and (for all 
> intents and purposes) is never read.  We periodically overwrite the first 
> block with recent start and end pointers and other metadata.

Ok, so it's just another typical WAL file. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

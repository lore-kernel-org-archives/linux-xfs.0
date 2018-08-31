Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:3541 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727139AbeHaHLB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Aug 2018 03:11:01 -0400
Date: Fri, 31 Aug 2018 13:05:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <20180831030542.GK5631@dastard>
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
 <20180830162545.GA26816@lst.de>
 <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com>
 <20180830163614.GA27069@lst.de>
 <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net>
 <20180830180204.GC2853@bfoster>
 <20180830182849.GA4359@magnolia>
 <10d35380-6f5f-22a5-7b6a-1cfb60c53cfd@sandeen.net>
 <20180831001106.GG5631@dastard>
 <7ae98d88-7cbf-1314-83b6-dc15da5124eb@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ae98d88-7cbf-1314-83b6-dc15da5124eb@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Aug 30, 2018 at 08:34:02PM -0500, Eric Sandeen wrote:
> On 8/30/18 7:11 PM, Dave Chinner wrote:
> > On Thu, Aug 30, 2018 at 01:51:56PM -0500, Eric Sandeen wrote:
> >> On 8/30/18 1:28 PM, Darrick J. Wong wrote:
> >>> On Thu, Aug 30, 2018 at 02:02:05PM -0400, Brian Foster wrote:
> >>>> On Thu, Aug 30, 2018 at 11:35:46AM -0500, Eric Sandeen wrote:
> >>>>> On 8/30/18 11:36 AM, Christoph Hellwig wrote:
> >>>>>> On Thu, Aug 30, 2018 at 11:31:40AM -0500, Eric Sandeen wrote:
> >>>>>>> That's no reason to uniquely disallow it for reflinked files, though;
> >>>>>>> the problem is universal.  It's true for fiemap as well.  So I'm not sure
> >>>>>>> that's an argument against the patch?
> >>>>>>
> >>>>>> fiemap at least tells you an extent is shared, bmap does not.
> >>>>>
> >>>>> yes, so bmap is clearly the wrong interface to use if you want to
> >>>>> write directly to a file's blocks.  But if you know enough to check
> >>>>> the fiemap shared flag, you know enough to not use fibmap for that purpose...
> >>>>>
> >>>>
> >>>> FWIW, this patch seems reasonable to me. To Christoph's point, I don't
> >>>> think either interface really grants license to write to the underlying
> >>>> blocks, so either way it's technically being abused for this purpose.
> >>>> Unless there's a clear way to return an error for a particular type of
> >>>> file, I think it's reasonable behavior for fibmap to expose the data it
> >>>> supports (i.e., block maps) and drop the data it doesn't (reflink
> >>>> state).
> >>>
> >>> But shared block status isn't something that can be dropped lightly.  If
> >>> you write to a shared block without realizing it, you'll corrupt every
> >>> other file that shares the block.
> >>
> >> But there is no circumstance under which it is safe to write to a mapped
> >> block no matter how you mapped it, tbh.
> > 
> > <sigh>
> > 
> > That's what all the break_layouts() code in XFS provides. It's a
> > mechanism for applications to prevent the block layout from changing
> > unexpected until they - the layout lease owner - give up their
> > exclusive access to the file layout.
> 
> > Seriously, this has been talked about so much in the past year or
> > two in the context of DAX, RDMA, get_user_pages() races in direct
> > IO, etc. it pains me to see this discussion rehashing it all over
> > again.
> > 
> > We want applications to do what they need to do safely.  FIBMAP is
> > unsafe and, worse, it's unfixable. We need to get apps to move away
> > from it to something is actualayl safe.
> 
> 
> > Adding a file lease interface to block 3rd party changes to the
> > file layout until the app releases the lease is a safe way
> > of allowing userspace apps to use FIEMAP to map and identify
> > file extents they can write directly to if they need to.
> > 
> > IOWs, we need to get the FL_LAYOUT flag out into the external file
> > lease interface (IIRC Dan Williams posted patches for this a while
> > back) and get these "FIBMAP + write()" apps to use "FL_LAYOUT,
> > fsync(), FIEMAP, write(), ~FL_LAYOUT".
> > 
> > We need to make FIBMAP go away by providing a safer, more robust
> > solution to the problem people are trying to solve.
> 
> Sure.  I get it that it's not a great interface.  I get it that there
> are better ways.  When those methods are available, we should explicitly
> deprecate FIBMAP.
> 
> But until then I can't understand why we'd intentionally break an
> otherwise reasonably functional interface in subtle and undetectable
> ways for certain classes of files.

Because that's better than subtle, silent and undetectable data
corruption of certain classes of files in certain common FIBMAP use
cases.

> We /could/ FIBMAP a reflinked file
> exactly as well as we can FIBMAP a non-reflinked file, but we choose
> not to.  This choice creates unnecessary problems for existing apps.

Yes, we /could/. But we don't, because because of the typical use
case of FIBMAP which is to map files so that IO (read and/or write)
can be done directly to the block device without going through the
filesystem. For normal files this is /relatively/ safe if the
correct precautions are taken. For a shared extent, writing is
*never* safe.

We don't know what users of FIBMAP are going to do with the block
map they get, but we *know* there are apps that use it to write
direct to block devices and we *know* that this will cause _silent_
data corruption and/or exposure of privileged information (shared
data can have different owners at different permission levels) when
it occurs.

That's what we're stopping by not exposing shared extents via FIBMAP
- applications that are careful and try to do everything as safely
and correctly as possible will still get it wrong and have no
indication that they've just screwed something up badly.

> Until we deprecate the FIBMAP interface, until there is a better way,
> I think we should make it as predictable and complete as
> we can, not cripple it intentionally.

Crippling it is the lesser of two evils, unfortunately. I don't like
it either, but I like the idea of silent data corruption or data
exposure vectors even less.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

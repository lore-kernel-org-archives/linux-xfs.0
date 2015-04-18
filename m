Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E4A707F47
	for <xfs@oss.sgi.com>; Sat, 18 Apr 2015 18:17:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CD7E58F8033
	for <xfs@oss.sgi.com>; Sat, 18 Apr 2015 16:17:54 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	T7H4IJouBK9vd5iG for <xfs@oss.sgi.com>;
	Sat, 18 Apr 2015 16:17:48 -0700 (PDT)
Date: Sun, 19 Apr 2015 09:17:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: extent size hints can round up extents past
	MAXEXTLEN
Message-ID: <20150418231745.GH21261@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150417125843.GA63169@bfoster.bfoster>
	<20150417130120.GB63169@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

[compund reply]

On Fri, Apr 17, 2015 at 08:58:44AM -0400, Brian Foster wrote:
> On Fri, Apr 17, 2015 at 08:28:29AM +1000, Dave Chinner wrote:
> > On Thu, Apr 16, 2015 at 01:32:38PM -0400, Brian Foster wrote:
> > > On Thu, Apr 16, 2015 at 03:00:50PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > This results in BMBT corruption, as seen by this test:
> > > > 
> > > > # mkfs.xfs -f -d size=40051712b,agcount=4 /dev/vdc
> > > > ....
> > > > # mount /dev/vdc /mnt/scratch
> > > > # xfs_io -ft -c "extsize 16m" -c "falloc 0 30g" -c "bmap -vp" /mnt/scratch/foo
> > > > 
> > > > which results in this failure on a debug kernel:
> > > > 
> > > > XFS: Assertion failed: (blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0, file: fs/xfs/libxfs/xfs_bmap_btree.c, line: 211
> > > > ....
> > ....
....
> I think it puts max_length at 0, which basically kills the allocation.
> Increasing the hint further underflows the max and makes it ineffective.
> Regardless, broken either way...
> 
> > Ok. So, the problem is that it is overestimating the amount of space
> > that alignment will need, and that alignment cannot be guaranteed
> > for extsz hints of over (MAXEXTLEN / 2) in size.
> > 
> > i.e. given an alignment (A[0-2]) and an extent (E[01]):
> > 
> >    A0                  A1                  A2
> >    +-------------------+-------------------+
> > 		     +ooo+
> > 		     E0  E1
> > 
> > The problem is that the alignment done by xfs_bmap_extsize_align()
> > only extends outwards (i.e. increases extent size). Hence E0 gets
> > rounded down to A0-A2, and E1 gets extended to A2, which means we
> > are adding almost 2 entire extent size hints to the allocation.
> > That's where the reduction in length by two extsz values came from.
> > 
> 
> Makes sense... From reading through xfs_bmap_extsize_align(), it looks
> like the intent of the function is to basically look at the current bmap
> of the file and apply the extent size hint to the original allocation
> request. E.g., expand the range of the file being allocated while
> dealing with potential overlap of previous or subsequent extents, eof,
> etc.

Yes, that is what it is supposed to be doing.

> > Now, for delayed allocation, this is just fine, because real
> > allocation will break this delalloc extent up into two separate
> > extents, and underflow wouldn't be noticed as delalloc extents are
> > not physically limited to MAXEXTLEN and so nothing would have
> > broken. Still, it's not the intended behaviour.
> > 
> 
> The delalloc behavior wasn't clear to me at first. I was expecting
> something along the lines of the behavior above, only done as a delalloc
> extent (only inserted in the in-core extent list). Observing that not
> happening, however, lead me to this:
> 
> aff3a9ed xfs: Use preallocation for inodes with extsz hints
> 
> ... which leads me to believe all of the extent size hint handling code
> in the bmapi delalloc codepath is historical from when we did have this
> behavior. We simply turned it off without cleaning out the lower layers,
> yes?

Yes. It had crossed my mind that the delalloc code probably wasn't
being called, but I did the analysis assuming that it was called.

> In any case, that explains the behavior. It's a bit confusing having
> that code around. On one hand, I could understand the view that the
> allocator is an independent layer that should account for the hints
> regardless of how the higher layers choose to call it. The downside is
> we can't really test that allocator codepath any longer. I think I'd be
> in favor of ripping that stuff out if it's not called. We could always
> add it back down the road if the extent alignment stuff is well factored
> into helper functions.

Yup.

[.... to other reply ....]

> > Ok, so the callers of xfs_bmap_extsize_align() are:
> > 
> > 	xfs_bmapi_reserve_delalloc()
> > 	xfs_bmap_btalloc()
> > 	xfs_bmap_rtalloc().
> > 
> > For xfs_bmapi_reserve_delalloc(), the alignment does not need grow
> > outwards; it can be truncated mid-range, and the code should still
> > work. i.e.
> > 
> >    A0                  A1                  A2
> >    +-------------------+-------------------+
> > 		     +ooo+
> > 		     E0  E1
> >    +-------------------+
> >    R0                  R1
> > 
> > R[01] is a valid alignment and will result in a second allocation
> > occurring for this:
> > 
> >    A0                  A1                  A2
> >    +-------------------+-------------------+
> > 		       +o+
> > 		      E2  E1
> >                        +-------------------+
> >                        R1                  R2
> > 
> > And so the range we need allocation for (E[01]) will be allocated
> > and correctly extent size aligned.
> > 
> 
> See my previous comments about delalloc extent size hints...
> 
> That aside, seems reasonable at a glance. The delayed allocation is
> effectively aggregated into what we expect to be an allocation that
> covers the entire aligned range.

Right.

> 
> > For xfs_bmap_btalloc() - the problem case here - the code is a
> > little more complex. We do:
> > 
> > xfs_bmapi_write
> >   loop until all allocated {
> >     xfs_bmapi_allocate(bma)
> >       calc off/len
> >         xfs_bmap_btalloc(bma)
> > 	  xfs_bmap_extsize_align(bma)
> > 	  xfs_alloc_vextent
> > 	  update bma->length
> >       BMBT insert
> >     trim returned map
> >   }
> > 
> > So we are doing alignment two steps removed from the off/len
> > calculation (xfs_bmap_rtalloc() is in the same boat). Hence the
> > question is whether xfs_bmap_extsize_align() can trim the range
> > being allocated and still have everything work....
> > 
> > Ok, upon further reading, the xfs_bmalloc structure (bma) that is
> > passed between these functions to track the allocation being done is
> > updated after allocation with the length of the extent allocated.
> > IOWs:
> > 
> > 	bma->length = E(len)
> > 	xfs_bmap_btalloc(bma)
> > 	  A(len) = xfs_bmap_extsize_align(bma->length)
> > 	  R(len) = xfs_alloc_vextent(A(len))
> > 	  bma->length = R(len)
> > 
> > Hence this:
> > 
> >    A0                  A1                  A2
> >    +-------------------+-------------------+
> > 		     +ooo+
> > 		     E0  E1
> >    +-------------------+
> >    R0                  R1
> > 
> > Is a valid result from xfs_bmap_btalloc() and the loop in
> > xfs_bmapi_write() will do a second allocation and alignment as per
> > the above delalloc case. xfs_bmap_rtalloc() appears to mirror this
> > same structure, so should also have the same behaviour.
> > 
> > What this means is that we can actually reduce the requested
> > allocation to be only a partial overlap when aligning it, and
> > everything should still work. Let's now see how complex that makes
> > the code...
> 
> Ok, so xfs_bmapi_write() walks over the file block range to be mapped
> and is thus prepared to handle the potential for multiple allocations.
> As long as the extent size alignment covers the high level range in
> incremental order, the higher layers should keep moving along until the
> originally requested range is allocated.

Yes.

> What I'm not so sure about is that the xfs_bmapi_write() loop also
> accounts for nimap, and that is passed as 1 from at least the couple of
> codepaths I looked at.

Yes. This "shorter allocation" is the same case as not having a
single contiguous region of free space large enough to allocate the
entire space being asked for - the allocated extent comes back
shorter than maxlen but larger than minlen, so another allocation is
needed...

> I'm guessing this is because those paths have a
> transaction reservation good enough for one allocation at a time. Some
> paths (e.g., xfs_iomap_write_allocate()) seems to handle this with an
> even higher level loop, but others such as xfs_iomap_write_direct() do
> not appear to. That said, it might still be the case that everything
> technically works, as then the higher level DIO becomes the next guy up
> the chain responsible for the alloc via requesting the next mapping...

Right, all the higher layers have loops to complete the
allocation/mapping calls because they always have to assume that a
single allocation/mapping call will not span the entire range they
are asking for. If they didn't loop, we'd see broken bits all over
the place ;)

> Even if that is the case, it seems at some level this alters the
> semantics of the extent size hint. Maybe that's fine and we just
> document it such that rather than extent size hints potentially
> resulting in 2x allocations, unaligned I/Os simply result in multiple
> aligned allocations. IIUC, that shouldn't really have much user visible
> impact, if at all..?

I don't think it has any visible user impact at all, just a slight
difference in CPU usage. We'll still end up with the same allocation
being done because we hold the AGF locked over both the allocations,
and the "contiguous allocation block target" should result in the
same free space extents being chosen as if it was a single
allocation...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

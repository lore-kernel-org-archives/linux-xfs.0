Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB3567F3F
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2015 08:47:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B0830304039
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2015 06:47:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RrBFDERU9KFaQEDi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Apr 2015 06:47:28 -0700 (PDT)
Date: Fri, 17 Apr 2015 09:01:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: extent size hints can round up extents past
	MAXEXTLEN
Message-ID: <20150417130120.GB63169@bfoster.bfoster>
References: <1429160450-4782-1-git-send-email-david@fromorbit.com>
	<20150416173238.GB39482@bfoster.bfoster>
	<20150416222829.GE21261@dastard> <20150417000308.GD15810@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150417000308.GD15810@dastard>
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

On Fri, Apr 17, 2015 at 10:03:08AM +1000, Dave Chinner wrote:
> On Fri, Apr 17, 2015 at 08:28:29AM +1000, Dave Chinner wrote:
> > On Thu, Apr 16, 2015 at 01:32:38PM -0400, Brian Foster wrote:
> > > On Thu, Apr 16, 2015 at 03:00:50PM +1000, Dave Chinner wrote:
> > > > + * Calculate the maximum extent length we can ask to allocate after taking into
> > > > + * account the on-disk size limitations, the extent size hints and the size
> > > > + * being requested. We have to deal with the extent size hint here because the
> > > > + * allocation will attempt alignment and hence grow the length outwards by up to
> > > > + * @extsz on either side.
> > > > + */
> > > > +static inline xfs_extlen_t
> > > > +xfs_bmapi_max_extlen(
> > > > +	struct xfs_inode	*ip,
> > > > +	xfs_extlen_t		length)
> > > > +{
> > > > +	xfs_extlen_t		extsz = xfs_get_extsz_hint(ip);
> > > > +	xfs_extlen_t		max_length = MAXEXTLEN;
> > > > +
> > > > +	if (extsz)
> > > > +		max_length -= 2 * extsz - 1;
> > > 
> > > This can underflow or cause other issues if set to just the right value
> > > (with smaller block sizes such that length can be trimmed to 0):
> > 
> > But I assumed the existing code was correct for this context. My
> > bad. :/
> > 
> > > $ mkfs.xfs -f -bsize=1k <dev>
> > > $ mount <dev> /mnt
> > > $ xfs_io -f -c "extsize 1g" -c "pwrite 0 4k" -c fsync /mnt/file
> > > pwrite64: No space left on device
> > 
> > Yup, because it 2^21 = 2G, and extsize = 1g puts max_length < 0.
> > 
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
> > Now, for delayed allocation, this is just fine, because real
> > allocation will break this delalloc extent up into two separate
> > extents, and underflow wouldn't be noticed as delalloc extents are
> > not physically limited to MAXEXTLEN and so nothing would have
> > broken. Still, it's not the intended behaviour.
> > 
> > I'm not sure what the solution is yet - the fundamental problem here
> > is the outwards alignment of both ends of the extent, and this
> > MAXEXTLEN twiddling is just an encoding of that behaviour. I need to
> > spend some time looking at xfs_bmap_extsize_align() and determining
> > if there is something we can do differently here.
> 
> Ok, so the callers of xfs_bmap_extsize_align() are:
> 
> 	xfs_bmapi_reserve_delalloc()
> 	xfs_bmap_btalloc()
> 	xfs_bmap_rtalloc().
> 
> For xfs_bmapi_reserve_delalloc(), the alignment does not need grow
> outwards; it can be truncated mid-range, and the code should still
> work. i.e.
> 
>    A0                  A1                  A2
>    +-------------------+-------------------+
> 		     +ooo+
> 		     E0  E1
>    +-------------------+
>    R0                  R1
> 
> R[01] is a valid alignment and will result in a second allocation
> occurring for this:
> 
>    A0                  A1                  A2
>    +-------------------+-------------------+
> 		       +o+
> 		      E2  E1
>                        +-------------------+
>                        R1                  R2
> 
> And so the range we need allocation for (E[01]) will be allocated
> and correctly extent size aligned.
> 

See my previous comments about delalloc extent size hints...

That aside, seems reasonable at a glance. The delayed allocation is
effectively aggregated into what we expect to be an allocation that
covers the entire aligned range.

> For xfs_bmap_btalloc() - the problem case here - the code is a
> little more complex. We do:
> 
> xfs_bmapi_write
>   loop until all allocated {
>     xfs_bmapi_allocate(bma)
>       calc off/len
>         xfs_bmap_btalloc(bma)
> 	  xfs_bmap_extsize_align(bma)
> 	  xfs_alloc_vextent
> 	  update bma->length
>       BMBT insert
>     trim returned map
>   }
> 
> So we are doing alignment two steps removed from the off/len
> calculation (xfs_bmap_rtalloc() is in the same boat). Hence the
> question is whether xfs_bmap_extsize_align() can trim the range
> being allocated and still have everything work....
> 
> Ok, upon further reading, the xfs_bmalloc structure (bma) that is
> passed between these functions to track the allocation being done is
> updated after allocation with the length of the extent allocated.
> IOWs:
> 
> 	bma->length = E(len)
> 	xfs_bmap_btalloc(bma)
> 	  A(len) = xfs_bmap_extsize_align(bma->length)
> 	  R(len) = xfs_alloc_vextent(A(len))
> 	  bma->length = R(len)
> 
> Hence this:
> 
>    A0                  A1                  A2
>    +-------------------+-------------------+
> 		     +ooo+
> 		     E0  E1
>    +-------------------+
>    R0                  R1
> 
> Is a valid result from xfs_bmap_btalloc() and the loop in
> xfs_bmapi_write() will do a second allocation and alignment as per
> the above delalloc case. xfs_bmap_rtalloc() appears to mirror this
> same structure, so should also have the same behaviour.
> 
> What this means is that we can actually reduce the requested
> allocation to be only a partial overlap when aligning it, and
> everything should still work. Let's now see how complex that makes
> the code...
> 

Ok, so xfs_bmapi_write() walks over the file block range to be mapped
and is thus prepared to handle the potential for multiple allocations.
As long as the extent size alignment covers the high level range in
incremental order, the higher layers should keep moving along until the
originally requested range is allocated.

What I'm not so sure about is that the xfs_bmapi_write() loop also
accounts for nimap, and that is passed as 1 from at least the couple of
codepaths I looked at. I'm guessing this is because those paths have a
transaction reservation good enough for one allocation at a time. Some
paths (e.g., xfs_iomap_write_allocate()) seems to handle this with an
even higher level loop, but others such as xfs_iomap_write_direct() do
not appear to. That said, it might still be the case that everything
technically works, as then the higher level DIO becomes the next guy up
the chain responsible for the alloc via requesting the next mapping...

Even if that is the case, it seems at some level this alters the
semantics of the extent size hint. Maybe that's fine and we just
document it such that rather than extent size hints potentially
resulting in 2x allocations, unaligned I/Os simply result in multiple
aligned allocations. IIUC, that shouldn't really have much user visible
impact, if at all..?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

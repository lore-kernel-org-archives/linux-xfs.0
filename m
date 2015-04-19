Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 42DDC29DFD
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2015 08:33:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 14F56304032
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2015 06:33:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9xydlCmTuYZHCTHX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 Apr 2015 06:33:03 -0700 (PDT)
Date: Sun, 19 Apr 2015 09:33:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: extent size hints can round up extents past
	MAXEXTLEN
Message-ID: <20150419133301.GA41769@bfoster.bfoster>
References: <20150417125843.GA63169@bfoster.bfoster>
	<20150417130120.GB63169@bfoster.bfoster>
	<20150418231745.GH21261@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150418231745.GH21261@dastard>
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

On Sun, Apr 19, 2015 at 09:17:45AM +1000, Dave Chinner wrote:
> [compund reply]
> 
> On Fri, Apr 17, 2015 at 08:58:44AM -0400, Brian Foster wrote:
> > On Fri, Apr 17, 2015 at 08:28:29AM +1000, Dave Chinner wrote:
> > > On Thu, Apr 16, 2015 at 01:32:38PM -0400, Brian Foster wrote:
> > > > On Thu, Apr 16, 2015 at 03:00:50PM +1000, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > 
...
> > > For xfs_bmap_btalloc() - the problem case here - the code is a
> > > little more complex. We do:
> > > 
> > > xfs_bmapi_write
> > >   loop until all allocated {
> > >     xfs_bmapi_allocate(bma)
> > >       calc off/len
> > >         xfs_bmap_btalloc(bma)
> > > 	  xfs_bmap_extsize_align(bma)
> > > 	  xfs_alloc_vextent
> > > 	  update bma->length
> > >       BMBT insert
> > >     trim returned map
> > >   }
> > > 
> > > So we are doing alignment two steps removed from the off/len
> > > calculation (xfs_bmap_rtalloc() is in the same boat). Hence the
> > > question is whether xfs_bmap_extsize_align() can trim the range
> > > being allocated and still have everything work....
> > > 
> > > Ok, upon further reading, the xfs_bmalloc structure (bma) that is
> > > passed between these functions to track the allocation being done is
> > > updated after allocation with the length of the extent allocated.
> > > IOWs:
> > > 
> > > 	bma->length = E(len)
> > > 	xfs_bmap_btalloc(bma)
> > > 	  A(len) = xfs_bmap_extsize_align(bma->length)
> > > 	  R(len) = xfs_alloc_vextent(A(len))
> > > 	  bma->length = R(len)
> > > 
> > > Hence this:
> > > 
> > >    A0                  A1                  A2
> > >    +-------------------+-------------------+
> > > 		     +ooo+
> > > 		     E0  E1
> > >    +-------------------+
> > >    R0                  R1
> > > 
> > > Is a valid result from xfs_bmap_btalloc() and the loop in
> > > xfs_bmapi_write() will do a second allocation and alignment as per
> > > the above delalloc case. xfs_bmap_rtalloc() appears to mirror this
> > > same structure, so should also have the same behaviour.
> > > 
> > > What this means is that we can actually reduce the requested
> > > allocation to be only a partial overlap when aligning it, and
> > > everything should still work. Let's now see how complex that makes
> > > the code...
> > 
> > Ok, so xfs_bmapi_write() walks over the file block range to be mapped
> > and is thus prepared to handle the potential for multiple allocations.
> > As long as the extent size alignment covers the high level range in
> > incremental order, the higher layers should keep moving along until the
> > originally requested range is allocated.
> 
> Yes.
> 
> > What I'm not so sure about is that the xfs_bmapi_write() loop also
> > accounts for nimap, and that is passed as 1 from at least the couple of
> > codepaths I looked at.
> 
> Yes. This "shorter allocation" is the same case as not having a
> single contiguous region of free space large enough to allocate the
> entire space being asked for - the allocated extent comes back
> shorter than maxlen but larger than minlen, so another allocation is
> needed...
> 
> > I'm guessing this is because those paths have a
> > transaction reservation good enough for one allocation at a time. Some
> > paths (e.g., xfs_iomap_write_allocate()) seems to handle this with an
> > even higher level loop, but others such as xfs_iomap_write_direct() do
> > not appear to. That said, it might still be the case that everything
> > technically works, as then the higher level DIO becomes the next guy up
> > the chain responsible for the alloc via requesting the next mapping...
> 
> Right, all the higher layers have loops to complete the
> allocation/mapping calls because they always have to assume that a
> single allocation/mapping call will not span the entire range they
> are asking for. If they didn't loop, we'd see broken bits all over
> the place ;)
> 
> > Even if that is the case, it seems at some level this alters the
> > semantics of the extent size hint. Maybe that's fine and we just
> > document it such that rather than extent size hints potentially
> > resulting in 2x allocations, unaligned I/Os simply result in multiple
> > aligned allocations. IIUC, that shouldn't really have much user visible
> > impact, if at all..?
> 
> I don't think it has any visible user impact at all, just a slight
> difference in CPU usage. We'll still end up with the same allocation
> being done because we hold the AGF locked over both the allocations,
> and the "contiguous allocation block target" should result in the
> same free space extents being chosen as if it was a single
> allocation...
> 

Indeed, a bit of a longer path for the overall allocation... and given
that the purpose of the hint is to cause larger allocations, we'll
naturally end up doing less of them overall for a given workload.

The idea that the same allocation is guaranteed doesn't seem always the
case, however. If we bubble up out of xfs_bmapi_write(), the calling
code commits and starts a new transaction. It does look like the
"first_block" mechanism will certainly try to pick up where it left off,
if I'm following that correctly, so perhaps that is the real world
result most of the time (just as an optimization as opposed to a hard
guarantee).

That still seems reasonable to me regardless since we're still doing
extent size allocations. I don't see any major reason why the hint
mechanism needs to guarantee everything is single allocation as opposed
to just ensuring allocations are of the requested size, provided the
file mapping allows it. The way I understand it, we're just disabling a
small optimization that happens to cause problems under certain
conditions. FWIW, another approach could be to limit the scope of the
optimization (e.g., do the outward rounding depending on the size of the
hint with respect to maxextlen), but at that point we're getting into
territory where it makes things even harder to test for questionable
value in return...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

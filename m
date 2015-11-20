Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 02AAC7F37
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 09:11:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BFC4C8F804B
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 07:11:22 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KOtwmcqE7ypaGC7B (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 20 Nov 2015 07:11:21 -0800 (PST)
Date: Fri, 20 Nov 2015 10:11:19 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: support for non-mmu architectures
Message-ID: <20151120151118.GB60886@bfoster.bfoster>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
	<20151119155525.GB13055@bfoster.bfoster>
	<20151119233547.GN14311@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151119233547.GN14311@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, Octavian Purdila <octavian.purdila@intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Nov 20, 2015 at 10:35:47AM +1100, Dave Chinner wrote:
> On Thu, Nov 19, 2015 at 10:55:25AM -0500, Brian Foster wrote:
> > On Wed, Nov 18, 2015 at 12:46:21AM +0200, Octavian Purdila wrote:
> > > Naive implementation for non-mmu architectures: allocate physically
> > > contiguous xfs buffers with alloc_pages. Terribly inefficient with
> > > memory and fragmentation on high I/O loads but it may be good enough
> > > for basic usage (which most non-mmu architectures will need).
> > > 
> > > This patch was tested with lklfuse [1] and basic operations seems to
> > > work even with 16MB allocated for LKL.
> > > 
> > > [1] https://github.com/lkl/linux
> > > 
> > > Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> > > ---
> > 
> > Interesting, though this makes me wonder why we couldn't have a new
> > _XBF_VMEM (for example) buffer type that uses vmalloc(). I'm not
> > familiar with mmu-less context, but I see that mm/nommu.c has a
> > __vmalloc() interface that looks like it ultimately translates into an
> > alloc_pages() call. Would that accomplish what this patch is currently
> > trying to do?
> 
> vmalloc is always a last resort.  vmalloc space on 32 bit systems is
> extremely limited and it is easy to exhaust with XFS.
> 

Sure, but my impression is that a vmalloc() buffer is roughly equivalent
in this regard to a current !XBF_UNMAPPED && size > PAGE_SIZE buffer. We
just do the allocation and mapping separately (presumably for other
reasons).

> Also, vmalloc limits the control we have over allocation context
> (e.g. the hoops we jump through in kmem_alloc_large() to maintain
> GFP_NOFS contexts), so just using vmalloc doesn't make things much
> simpler from an XFS perspective.
> 

The comment in kmem_zalloc_large() calls out some apparent hardcoded
allocation flags down in the depths of vmalloc(). It looks to me that
page allocation (__vmalloc_area_node()) actually uses the provided
flags, so I'm not following the "data page" part of that comment.
Indeed, I do see that this is not the case down in calls like
pmd_alloc_one(), pte_alloc_one_kernel(), etc., associated with page
table management.

Those latter calls are all from following down through the
map_vm_area()->vmap_page_range() codepath from __vmalloc_area_node(). We
call vm_map_ram() directly from _xfs_buf_map_pages(), which itself calls
down into the same code. Indeed, we already protect ourselves here via
the same memalloc_noio_save() mechanism that kmem_zalloc_large() uses.

I suspect there's more to it than that because it does look like
vm_map_ram() has a different mechanism for managing vmalloc space for
certain (smaller) allocations, either of which I'm not really familiar
with. That aside, I don't see how vmalloc() introduces any new
allocation context issues for those buffers where we already set up a
multi-page mapping.

We still have the somewhat customized page allocation code in
xfs_buf_allocate_memory() to contend with. I actually think it would be
useful to have a DEBUG sysfs tunable to turn on vmalloc() buffers and
actually test how effective some of this code is.

> > I ask because it seems like that would help clean up the code a bit, for
> > one. It might also facilitate some degree of testing of the XFS bits
> > (even if utilized sparingly in DEBUG mode if it weren't suitable enough
> > for generic/mmu use). We currently allocate and map the buffer pages
> > separately and I'm not sure if there's any particular reasons for doing
> > that outside of some congestion handling in the allocation code and
> > XBF_UNMAPPED buffers, the latter probably being irrelevant for nommu.
> > Any other thoughts on that?
> 
> We could probably clean the code up more (the allocation logic
> is now largely a historic relic) but I'm not convinced yet that we
> should be spending any time trying to specifically support mmu-less
> hardware.
> 

Fair point, we'll see where the use case discussion goes. That said, I
was a little surprised that this is all that was required to enable
nommu support. If that is indeed the case and we aren't in for a series
of subsequent nommu specific changes (Octavian?) by letting this
through, what's the big deal? This seems fairly harmless to me as is,
particularly if it can be semi-tested via DEBUG mode and has potential
generic use down the road.

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

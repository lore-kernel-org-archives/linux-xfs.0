Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3CBB27F37
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 16:47:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1F8D68F8039
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 14:47:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SpnNV87k1GtS6ekv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 20 Nov 2015 14:47:37 -0800 (PST)
Date: Fri, 20 Nov 2015 17:47:34 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: support for non-mmu architectures
Message-ID: <20151120224734.GA28795@bfoster.bfoster>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
	<20151119155525.GB13055@bfoster.bfoster>
	<20151119233547.GN14311@dastard>
	<20151120151118.GB60886@bfoster.bfoster>
	<20151120203602.GA26718@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151120203602.GA26718@dastard>
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

On Sat, Nov 21, 2015 at 07:36:02AM +1100, Dave Chinner wrote:
> On Fri, Nov 20, 2015 at 10:11:19AM -0500, Brian Foster wrote:
> > On Fri, Nov 20, 2015 at 10:35:47AM +1100, Dave Chinner wrote:
> > > On Thu, Nov 19, 2015 at 10:55:25AM -0500, Brian Foster wrote:
> > > > On Wed, Nov 18, 2015 at 12:46:21AM +0200, Octavian Purdila wrote:
> > > > > Naive implementation for non-mmu architectures: allocate physically
> > > > > contiguous xfs buffers with alloc_pages. Terribly inefficient with
> > > > > memory and fragmentation on high I/O loads but it may be good enough
> > > > > for basic usage (which most non-mmu architectures will need).
> > > > > 
> > > > > This patch was tested with lklfuse [1] and basic operations seems to
> > > > > work even with 16MB allocated for LKL.
> > > > > 
> > > > > [1] https://github.com/lkl/linux
> > > > > 
> > > > > Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> > > > > ---
> > > > 
> > > > Interesting, though this makes me wonder why we couldn't have a new
> > > > _XBF_VMEM (for example) buffer type that uses vmalloc(). I'm not
> > > > familiar with mmu-less context, but I see that mm/nommu.c has a
> > > > __vmalloc() interface that looks like it ultimately translates into an
> > > > alloc_pages() call. Would that accomplish what this patch is currently
> > > > trying to do?
> > > 
> > > vmalloc is always a last resort.  vmalloc space on 32 bit systems is
> > > extremely limited and it is easy to exhaust with XFS.
> > > 
> > 
> > Sure, but my impression is that a vmalloc() buffer is roughly equivalent
> > in this regard to a current !XBF_UNMAPPED && size > PAGE_SIZE buffer. We
> > just do the allocation and mapping separately (presumably for other
> > reasons).
> 
> Yes, it'a always a last resort. We don't use vmap'd buffers very
> much on block size <= page size filesystems (e.g. iclog buffers are
> the main user in such cases, IIRC), so the typical 32 bit
> system doesn't have major problems with vmalloc space. However, the
> moment you increase the directory block size > block size, that all
> goes out the window...
> 

Ok. It's really only the pre-existing mapped buffer cases we care about
here.

> > > Also, vmalloc limits the control we have over allocation context
> > > (e.g. the hoops we jump through in kmem_alloc_large() to maintain
> > > GFP_NOFS contexts), so just using vmalloc doesn't make things much
> > > simpler from an XFS perspective.
> > > 
> > 
> > The comment in kmem_zalloc_large() calls out some apparent hardcoded
> > allocation flags down in the depths of vmalloc(). It looks to me that
> > page allocation (__vmalloc_area_node()) actually uses the provided
> > flags, so I'm not following the "data page" part of that comment.
> 
> You can pass gfp flags for the page allocation part of vmalloc, but
> not the pte allocation part of it. That's what the hacks in
> kmem_zalloc_large() are doing.
> 
> > Indeed, I do see that this is not the case down in calls like
> > pmd_alloc_one(), pte_alloc_one_kernel(), etc., associated with page
> > table management.
> 
> Right.
> 
> > Those latter calls are all from following down through the
> > map_vm_area()->vmap_page_range() codepath from __vmalloc_area_node(). We
> > call vm_map_ram() directly from _xfs_buf_map_pages(), which itself calls
> > down into the same code. Indeed, we already protect ourselves here via
> > the same memalloc_noio_save() mechanism that kmem_zalloc_large() uses.
> 
> Yes, we do, but that is separately handled to the allocation of the
> pages, which we have to do for all types of buffers, mapped or
> unmapped, because xfs_buf_ioapply_map() requires direct access to
> the underlying pages to build the bio for IO.  If we delegate the
> allocation of pages to vmalloc, we don't have direct reference to
> the underlying pages and so we have to do something completely
> diffferent to build the bios for the buffer....
> 

Octavian points out virt_to_page() in a previous mail. I'm not sure
that's the right interface solely based on looking at some current
callers, but there is vmalloc_to_page() so I'd expect we can gain access
to the pages one way or another. Given that, the buffer allocation code
would fully populate the xfs_buf as it is today. The buffer I/O
submission code wouldn't really know the difference and shouldn't have
to change at all.

> > I suspect there's more to it than that because it does look like
> > vm_map_ram() has a different mechanism for managing vmalloc space for
> > certain (smaller) allocations, either of which I'm not really familiar
> > with.
> 
> Yes, it manages vmalloc space quite differently, and there are
> different scalability aspects to consider as well - vm_map_ram was
> pretty much written for the use XFS has in xfs_buf.c...
> 

Indeed. Looking closer, it appears to have a percpu vmalloc space
allocation strategy for smaller allocations. We clearly can't just
switch mapped buffer cases over and expect it to work/perform just the
same.

That said, the vm_map_ram() comment does call out fragmentation concerns
for objects with mixed lifetimes. I'd be curious whether our buffer
caching can trigger any badness there. OTOH, it's also not clear that
this mechanism couldn't extend to vmalloc (or some variant thereof) in
the future.

Either way, it would require significantly more investigation/testing to
enable generic usage. The core point was really just to abstract the
nommu changes into something that potentially has generic use.

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

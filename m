Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9B6C07F37
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 15:00:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87F90304039
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 13:00:29 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	A7ZL06xJ2LdEV4zZ for <xfs@oss.sgi.com>;
	Mon, 23 Nov 2015 13:00:25 -0800 (PST)
Date: Tue, 24 Nov 2015 08:00:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: support for non-mmu architectures
Message-ID: <20151123210011.GF26718@dastard>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
	<20151119155525.GB13055@bfoster.bfoster>
	<20151119233547.GN14311@dastard>
	<20151120151118.GB60886@bfoster.bfoster>
	<20151120203602.GA26718@dastard>
	<20151120224734.GA28795@bfoster.bfoster>
	<20151122220400.GC26718@dastard>
	<20151123124959.GA58452@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151123124959.GA58452@bfoster.bfoster>
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
Cc: linux-fsdevel@vger.kernel.org, Octavian Purdila <octavian.purdila@intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 23, 2015 at 07:50:00AM -0500, Brian Foster wrote:
> On Mon, Nov 23, 2015 at 09:04:00AM +1100, Dave Chinner wrote:
> > On Fri, Nov 20, 2015 at 05:47:34PM -0500, Brian Foster wrote:
> > > On Sat, Nov 21, 2015 at 07:36:02AM +1100, Dave Chinner wrote:
> > > > On Fri, Nov 20, 2015 at 10:11:19AM -0500, Brian Foster wrote:
> > > > > On Fri, Nov 20, 2015 at 10:35:47AM +1100, Dave Chinner wrote:
> > > > > Those latter calls are all from following down through the
> > > > > map_vm_area()->vmap_page_range() codepath from __vmalloc_area_node(). We
> > > > > call vm_map_ram() directly from _xfs_buf_map_pages(), which itself calls
> > > > > down into the same code. Indeed, we already protect ourselves here via
> > > > > the same memalloc_noio_save() mechanism that kmem_zalloc_large() uses.
> > > > 
> > > > Yes, we do, but that is separately handled to the allocation of the
> > > > pages, which we have to do for all types of buffers, mapped or
> > > > unmapped, because xfs_buf_ioapply_map() requires direct access to
> > > > the underlying pages to build the bio for IO.  If we delegate the
> > > > allocation of pages to vmalloc, we don't have direct reference to
> > > > the underlying pages and so we have to do something completely
> > > > diffferent to build the bios for the buffer....
> > > > 
> > > 
> > > Octavian points out virt_to_page() in a previous mail. I'm not sure
> > > that's the right interface solely based on looking at some current
> > > callers, but there is vmalloc_to_page() so I'd expect we can gain access
> > > to the pages one way or another.
> > 
> > Sure, but these are not zero cost operations....
> > 
> > > Given that, the buffer allocation code
> > > would fully populate the xfs_buf as it is today. The buffer I/O
> > > submission code wouldn't really know the difference and shouldn't have
> > > to change at all.
> > 
> > The abstraction results in more expensive/complex setup and teardown
> > of buffers and/or IO submission. i.e. the use of vmalloc() based
> > abstractions has an additional cost over what we do now.
> > 
> > [...]
> > 
> 
> Yeah, most likely. The vmalloc based lookup certainly looks more
> involved than if the pages are already readily accessible. How much more
> expensive (and whether it's noticeable enough to care) is probably a
> matter of testing. I think the code itself could end up much more
> simple, however. There's still a lot of duplication in our current
> implementation that afaiu right now only continues to exist due to the
> performance advantages of vm_map_ram().

Yup. The historical problem here is that the mm/ people are not
really interested in making vmalloc() scale/perform better. We are
always told that if you need vmalloc() you are doing something
wrong, and so vmalloc() doesn't need improving. The same reason is
generally given for not making vmalloc handle GFP flags properly,
so we're really stuck between a rock and a hard place here.

> > > Either way, it would require significantly more investigation/testing to
> > > enable generic usage. The core point was really just to abstract the
> > > nommu changes into something that potentially has generic use.
> > 
> > I'm not saying that it is impossible to do this, just trying to work
> > out if making any changes to support nommu architectures is worth
> > the potential future trouble making such changes could bring us.
> > i.e. before working out how to do something, we have to decide
> > whether it is worth doing  in the first place.
> > 
> > Just because you can do something doesn't automatically make it a
> > good idea....
> 
> Sure, good point. I've intentionally been sticking to the technical
> points that have been raised (and I think we've covered it thoroughly to
> this point ;).

*nod*

> FWIW, I agree with most of the concerns that have been called out in the
> thread so far, but the support question ultimately sounds moot to me. We
> can reject the "configuration" enabled by this particular patch, but
> afaik this LKL thing could just go and implement an mmu mode and
> fundamentally do what it's trying to do today. If it's useful, users
> will use it, ultimately hit bugs, and we'll have to deal with it one way
> or another.

Right, but we need to set expectations appropriately now, before we
have users that depend on something we can't sanely support....

> Note that I'm not saying we have to support LKL. Rather, I view it as
> equivalent to somebody off running some new non-standard/uncommon
> architecture (or maybe a hypervisor is a better example in this case).

Right, but we don't support every possible kernel/device out there
with XFS. Up to now, no-mmu devices have been small, embedded
systems that can't/won't fit XFS in their flash/RAM because of
space/cost/need and so we've been able to completely ignore the
issues such platforms have. We really don't pay much attention to 32
bit systems anymore, and no-mmu is much, much further down the list
of "users who need XFS" than 32 bit arches....

> If the user runs into some low-level filesystem issue, the user probably
> needs to get through whatever levels of support exist for that special
> architecture/environment first and/or otherwise work with us to find a
> reproducer on something more standard that we all have easy access to.
> Just my .02, though. :)

The biggest problem we have is that the kernel might be tripping
over a problem introduced by some broken version of an app linked against
some old version of LKL. That's my biggest worry here - it's not
that LKL uses kernel code, it's that we no longer have any idea of
what code has been modifying the filesystem nor any easy way of
finding out. And we all know how hard it can be to get a straight
answer to "explain exactly what you did" from bug reporters...

Sure, once we *know* that the filesystem was modified by a random
userspace application, we can say "please reproduce with a vanilla
kernel", but it's getting to that point that can be problematic.

This is why I think a proper FUSE module implemented on top of the
userspace libxfs and is built as part of xfsprogs is a much better
way give users userspace access to XFS filesystems. We can develop
and support that directly, knowing exactly what code users are
running and having a relatively controlled environment the
filesystem code is running in....

Cheers,

Dave.
> 
> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

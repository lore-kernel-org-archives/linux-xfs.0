Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33062 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727301AbeHKPY5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 11 Aug 2018 11:24:57 -0400
Date: Sat, 11 Aug 2018 08:50:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/14] xfs: repair free space btrees
Message-ID: <20180811125049.GA35189@bfoster>
References: <20180803104940.GA5657@bfoster>
 <20180807233458.GH30972@magnolia>
 <20180808122953.GB2819@bfoster>
 <20180808224232.GJ30972@magnolia>
 <20180809120027.GC21030@bfoster>
 <20180809155959.GK30972@magnolia>
 <20180810103351.GA27330@bfoster>
 <20180810153944.GC15083@magnolia>
 <20180810190740.GA27589@bfoster>
 <20180810193651.GE15083@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180810193651.GE15083@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Fri, Aug 10, 2018 at 12:36:51PM -0700, Darrick J. Wong wrote:
> On Fri, Aug 10, 2018 at 03:07:40PM -0400, Brian Foster wrote:
> > On Fri, Aug 10, 2018 at 08:39:44AM -0700, Darrick J. Wong wrote:
> > > On Fri, Aug 10, 2018 at 06:33:52AM -0400, Brian Foster wrote:
> > > > On Thu, Aug 09, 2018 at 08:59:59AM -0700, Darrick J. Wong wrote:
> > > > > On Thu, Aug 09, 2018 at 08:00:28AM -0400, Brian Foster wrote:
> > > > > > On Wed, Aug 08, 2018 at 03:42:32PM -0700, Darrick J. Wong wrote:
> > > > > > > On Wed, Aug 08, 2018 at 08:29:54AM -0400, Brian Foster wrote:
> > > > > > > > On Tue, Aug 07, 2018 at 04:34:58PM -0700, Darrick J. Wong wrote:
> > > > > > > > > On Fri, Aug 03, 2018 at 06:49:40AM -0400, Brian Foster wrote:
> > > > > > > > > > On Thu, Aug 02, 2018 at 12:22:05PM -0700, Darrick J. Wong wrote:
> > > > > > > > > > > On Thu, Aug 02, 2018 at 09:48:24AM -0400, Brian Foster wrote:
> > > > > > > > > > > > On Wed, Aug 01, 2018 at 11:28:45PM -0700, Darrick J. Wong wrote:
> > > > > > > > > > > > > On Wed, Aug 01, 2018 at 02:39:20PM -0400, Brian Foster wrote:
> > > > > > > > > > > > > > On Wed, Aug 01, 2018 at 09:23:16AM -0700, Darrick J. Wong wrote:
> > > > > > > > > > > > > > > On Wed, Aug 01, 2018 at 07:54:09AM -0400, Brian Foster wrote:
> > > > > > > > > > > > > > > > On Tue, Jul 31, 2018 at 03:01:25PM -0700, Darrick J. Wong wrote:
> > > > > > > > > > > > > > > > > On Tue, Jul 31, 2018 at 01:47:23PM -0400, Brian Foster wrote:
> > > > > > > > > > > > > > > > > > On Sun, Jul 29, 2018 at 10:48:21PM -0700, Darrick J. Wong wrote:
...
> > > 
> > > Hmm, ok, so to summarize, I see five options:
> > > 
> > > 1) Pass in a dirfd, repair can internally openat(dirfd, O_TMPFILE...)
> > > however many files it needs.
> > > 
> > > 2) Pass in a however many file fds we need and segment the space.
> > > 
> > > 3) Pass in a single file fd.
> > > 
> > > 4) Let the repair code create as many memfd files as it wants.
> > > 
> > > 5) Let the repair code create one memfd file and segment the space.
> > > 
> > > I'm pretty sure we don't want to support (2) because that just seems
> > > like a requirements communication nightmare and can burn up a lot of
> > > space in struct xfs_scrub_metadata.
> > > 
> > > (3) and (5) are basically the same except for where the file comes from.
> > > For (3) we'd have to make sure the fd filesystem supports large sparse
> > > files (and presumably isn't the xfs we're trying to repair), which
> > > shouldn't be too difficult to probe.  For (5) we know that tmpfs already
> > > supports large sparse files.  Another difficulty might be that on 32-bit
> > > the page cache only supports offsets as high as (ULONG_MAX * PAGE_SIZE),
> > > though I suppose at this point we only need two files and 8TB should be
> > > enough for anyone.
> > > 
> > > (I also think it's reasonable to consider not supporting online repair
> > > on a 32-bit system with a large filesystem...)
> > > 
> > > In general, the "pass in a thing from userspace" variants come with the
> > > complication that we have to check the functionality of whatever gets
> > > passed in.  On the plus side it likely unlocks access to a lot more
> > > storage than we could get with mem+swap.  On the minus side someone
> > > passes in a fd to a drive-managed SMR on USB 2.0, and...
> > > 
> > > (1) seems like it would maximize the kernel's flexibility to create as
> > > many (regular, non-sparse) files as it needs, but now we're calling
> > > do_sys_open and managing files ourselves, which might be avoided.
> > > 
> > > (4) of course is what we do right now. :)
> > > 
> > > Soooo... the simplest userspace interface (I think) is to allow
> > > userspace to pass in a single file fd.  Scrub can reject it if it
> > > doesn't measure up (fs is the same, sparse not supported, high offsets
> > > not supported, etc.).  If userspace doesn't pass in an fd then we create
> > > a memfd and use that instead.  We end up with a hybrid between (3) and (5).
> > > 
> > 
> > That all sounds about right to me except I was thinking userspace would
> > do the memfd fallback of #5 rather than the kernel, just to keep the
> > policy out of the kernel as much as possible. Is there any major
> > advantage to doing it in the kernel? I guess it would slightly
> > complicate 'xfs_io -c repair' ...
> 
> Hm.  We'll have to use one of the reserved areas of struct
> xfs_scrub_metadata to pass in the file descriptor.  If we create a new
> XFS_SCRUB_IFLAG_FD flag to indicate that we're passing in a file
> descriptor then either we lose compatibility with old kernels (because
> they reject unknown flags) or xfs_scrub will have to try a repair
> without a fd (to see if the kernel even cares) and retry if the repair
> fails with some prearranged error code that means "give me a swapfile,
> please".  Alternately we simply require that the fd cannot be fd 0 since
> using stdin for swap space is a stupid idea anyways.
> 

I'm assuming that the kernel would have some basic checks on the fd to
ensure it's usable (seekable, large offsets, etc.), as you mentioned
previously.

With regard to xfs_scrub_metadata, it sounds like we need to deal with
that regardless if we want to support the ability to specify an external
file. Is the issue backwards compatibility with the interface as it
exists today..?

> Technically we're not supposed to have flag days, but otoh this is a
> xfs-only ioctl for a feature that's still experimental, so perhaps it's
> not crucial to maintain compatibility with old kernels where the feature
> is incomplete and experimental?
> 

In my mind, I kind of take the experimental status as all bits/interface
may explode and are otherwise subject to change or disappear. Perhaps
others feel differently, it does seem we've kind of hinted towards the
contrary recently with respect to the per-inode dax bits and then now in
this discussion, but IMO that's kind of an inherent risk of doing
incremental work on complex features upstream.

I dunno, perhaps that's just a misunderstanding on my part. If so, I do
wonder if we should be a bit more cautious (in the future) about
exposing interfaces to experimental features (DEBUG mode only, for
example) for a period of time until the underlying mechanism is fleshed
out enough to establish confidence in the interface. It's one thing if
an experimental feature is shiny new and potentially unstable at the
time it is merged, but enough bits are there for reviewers to understand
the design and interface requirements. It's another thing if the
implementation is not yet complete, because then it's obviously harder
to surmise whether the interface is ultimately sufficient.

This of course is all higher level discussion from how to handle scrub..

> Hmm.  We could define the fd field with the requirement that fd > 0, and
> if the repair function requires an fd and one hasn't been provided, it
> can fail out with ENOMEM.  If it doesn't need extra memory it can just
> ignore the contents of the fd field.  xfs_scrub can then arrange to pass
> in mem fds or file fds or whatever.
> 

Is there a versioning mechanism to the interface? I thought we used that
approach (or planned to..) in other similar internal commands, so a
particular kernel could bump the version and appropriately decide how to
handle older versions.

Brian

> --D
> 
> > Brian
> > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > > (In theory the xbitmap could also be converted to use the fixed record
> > > > > array, but in practice they haven't (yet) become large enough to warrant
> > > > > it, and there's currently no way to insert or delete records from the
> > > > > middle of the array.)
> > > > > 
> > > > > > > > > > I'm not familiar with memfd. The manpage suggests it's ram backed, is it
> > > > > > > > > > swappable or something?
> > > > > > > > > 
> > > > > > > > > It's supposed to be.  The quick test I ran (allocate a memfd, write 1GB
> > > > > > > > > of junk to it on a VM with 400M of RAM) seemed to push about 980MB into
> > > > > > > > > the swap file.
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > Ok.
> > > > > > > > 
> > > > > > > > > > If so, that sounds a reasonable option provided the swap space
> > > > > > > > > > requirement can be made clear to users
> > > > > > > > > 
> > > > > > > > > We can document it.  I don't think it's any worse than xfs_repair being
> > > > > > > > > able to use up all the memory + swap... and since we're probably only
> > > > > > > > > going to be repairing one thing at a time, most likely scrub won't need
> > > > > > > > > as much memory.
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > Right, but as noted below, my concerns with the xfs_repair comparison
> > > > > > > > are that 1.) the kernel generally has more of a limit on anonymous
> > > > > > > > memory allocations than userspace (i.e., not swappable AFAIU?) and 2.)
> > > > > > > > it's not clear how effectively running the system out of memory via the
> > > > > > > > kernel will behave from a failure perspective.
> > > > > > > > 
> > > > > > > > IOW, xfs_repair can run the system out of memory but for the most part
> > > > > > > > that ends up being a simple problem for the system: OOM kill the bloated
> > > > > > > > xfs_repair process. For an online repair in a similar situation, I have
> > > > > > > > no idea what's going to happen.
> > > > > > > 
> > > > > > > Back in the days of the huge linked lists the oom killer would target
> > > > > > > other proceses because it doesn't know that the online repair thread is
> > > > > > > sitting on a ton of pinned kernel memory...
> > > > > > > 
> > > > > > 
> > > > > > Makes sense, kind of what I'd expect...
> > > > > > 
> > > > > > > > The hope is that the online repair hits -ENOMEM and unwinds, but ISTM
> > > > > > > > we'd still be at risk of other subsystems running into memory
> > > > > > > > allocation problems, filling up swap, the OOM killer going after
> > > > > > > > unrelated processes, etc.  What if, for example, the OOM killer starts
> > > > > > > > picking off processes in service to a running online repair that
> > > > > > > > immediately consumes freed up memory until the system is borked?
> > > > > > > 
> > > > > > > Yeah.  One thing we /could/ do is register an oom notifier that would
> > > > > > > urge any running repair threads to bail out if they can.  It seems to me
> > > > > > > that the oom killer blocks on the oom_notify_list chain, so our handler
> > > > > > > could wait until at least one thread exits before returning.
> > > > > > > 
> > > > > > 
> > > > > > Ok, something like that could be useful. I agree that we probably don't
> > > > > > need to go that far until the mechanism is nailed down and testing shows
> > > > > > that OOM is a problem.
> > > > > 
> > > > > It already is a problem on my contrived "2TB hardlink/reflink farm fs" +
> > > > > "400M of RAM and no swap" scenario.  Granted, pretty much every other
> > > > > xfs utility also blows out on that so I'm not sure how hard I really
> > > > > need to try...
> > > > > 
> > > > > > > > I don't know how likely that is or if it really ends up much different
> > > > > > > > from the analogous xfs_repair situation. My only point right now is
> > > > > > > > that failure scenario is something we should explore for any solution
> > > > > > > > we ultimately consider because it may be an unexpected use case of the
> > > > > > > > underlying mechanism.
> > > > > > > 
> > > > > > > Ideally, online repair would always be the victim since we know we have
> > > > > > > a reasonable fallback.  At least for memfd, however, I think the only
> > > > > > > clues we have to decide the question "is this memfd getting in the way
> > > > > > > of other threads?" is either seeing ENOMEM, short writes, or getting
> > > > > > > kicked by an oom notification.  Maybe that'll be enough?
> > > > > > > 
> > > > > > 
> > > > > > Hm, yeah. It may be challenging to track memfd usage as such. If
> > > > > > userspace has access to the fd on an OOM notification or whatever, it
> > > > > > might be able to do more accurate analysis based on an fstat() or
> > > > > > something.
> > > > > > 
> > > > > > Related question... is the online repair sequence currently
> > > > > > interruptible, if xfs_scrub receives a fatal signal while pulling in
> > > > > > entries during an allocbt scan for example?
> > > > > 
> > > > > It's interruptible (fatal signals only) during the scan phase, but once
> > > > > it starts logging metadata updates it will run all the way to
> > > > > completion.
> > > > > 
> > > > > > > > (To the contrary, just using a cached file seems a natural fit from
> > > > > > > > that perspective.)
> > > > > > > 
> > > > > > > Same here.
> > > > > > > 
> > > > > > > > > > and the failure characteristics aren't more severe than for userspace.
> > > > > > > > > > An online repair that puts the broader system at risk of OOM as
> > > > > > > > > > opposed to predictably failing gracefully may not be the most useful
> > > > > > > > > > tool.
> > > > > > > > > 
> > > > > > > > > Agreed.  One huge downside of memfd seems to be the lack of a mechanism
> > > > > > > > > for the vm to push back on us if we successfully write all we need to
> > > > > > > > > the memfd but then other processes need some memory.  Obviously, if the
> > > > > > > > > memfd write itself comes up short or fails then we dump the memfd and
> > > > > > > > > error back to userspace.  We might simply have to free array memory
> > > > > > > > > while we iterate the records to minimize the time spent at peak memory
> > > > > > > > > usage.
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > Hm, yeah. Some kind of fixed/relative size in-core memory pool approach
> > > > > > > > may simplify things because we could allocate it up front and know right
> > > > > > > > away whether we just don't have enough memory available to repair.
> > > > > > > 
> > > > > > > Hmm.  Apparently we actually /can/ call fallocate on memfd to grab all
> > > > > > > the pages at once, provided we have some guesstimate beforehand of how
> > > > > > > much space we think we'll need.
> > > > > > > 
> > > > > > > So long as my earlier statement about the memory requirements being no
> > > > > > > more than the size of the btree leaves is actually true (I haven't
> > > > > > > rigorously tried to prove it), we need about (xrep_calc_ag_resblks() *
> > > > > > > blocksize) worth of space in the memfd file.  Maybe we ask for 1.5x
> > > > > > > that and if we don't get it, we kill the memfd and exit.
> > > > > > > 
> > > > > > 
> > > > > > Indeed. It would be nice if we could do all of the file management bits
> > > > > > in userspace.
> > > > > 
> > > > > Agreed, though no file management would be even better. :)
> > > > > 
> > > > > --D
> > > > > 
> > > > > > Brian
> > > > > > 
> > > > > > > --D
> > > > > > > 
> > > > > > > > 
> > > > > > > > Brian
> > > > > > > > 
> > > > > > > > > --D
> > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > Brian
> > > > > > > > > > 
> > > > > > > > > > > --D
> > > > > > > > > > > 
> > > > > > > > > > > > Brian
> > > > > > > > > > > > 
> > > > > > > > > > > > > --D
> > > > > > > > > > > > > 
> > > > > > > > > > > > > > Brian
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > --D
> > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > Brian
> > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > > > > > +done:
> > > > > > > > > > > > > > > > > > > +	/* Free all the OWN_AG blocks that are not in the rmapbt/agfl. */
> > > > > > > > > > > > > > > > > > > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> > > > > > > > > > > > > > > > > > > +	return xrep_reap_extents(sc, old_allocbt_blocks, &oinfo,
> > > > > > > > > > > > > > > > > > > +			XFS_AG_RESV_NONE);
> > > > > > > > > > > > > > > > > > > +}
> > > > > > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > > > > ...
> > > > > > > > > > > > > > > > > > > diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> > > > > > > > > > > > > > > > > > > index 0ed68379e551..82f99633a597 100644
> > > > > > > > > > > > > > > > > > > --- a/fs/xfs/xfs_extent_busy.c
> > > > > > > > > > > > > > > > > > > +++ b/fs/xfs/xfs_extent_busy.c
> > > > > > > > > > > > > > > > > > > @@ -657,3 +657,17 @@ xfs_extent_busy_ag_cmp(
> > > > > > > > > > > > > > > > > > >  		diff = b1->bno - b2->bno;
> > > > > > > > > > > > > > > > > > >  	return diff;
> > > > > > > > > > > > > > > > > > >  }
> > > > > > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > > > > > +/* Are there any busy extents in this AG? */
> > > > > > > > > > > > > > > > > > > +bool
> > > > > > > > > > > > > > > > > > > +xfs_extent_busy_list_empty(
> > > > > > > > > > > > > > > > > > > +	struct xfs_perag	*pag)
> > > > > > > > > > > > > > > > > > > +{
> > > > > > > > > > > > > > > > > > > +	spin_lock(&pag->pagb_lock);
> > > > > > > > > > > > > > > > > > > +	if (pag->pagb_tree.rb_node) {
> > > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > > RB_EMPTY_ROOT()?
> > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > Good suggestion, thank you!
> > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > --D
> > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > > Brian
> > > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > > > +		spin_unlock(&pag->pagb_lock);
> > > > > > > > > > > > > > > > > > > +		return false;
> > > > > > > > > > > > > > > > > > > +	}
> > > > > > > > > > > > > > > > > > > +	spin_unlock(&pag->pagb_lock);
> > > > > > > > > > > > > > > > > > > +	return true;
> > > > > > > > > > > > > > > > > > > +}
> > > > > > > > > > > > > > > > > > > diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> > > > > > > > > > > > > > > > > > > index 990ab3891971..2f8c73c712c6 100644
> > > > > > > > > > > > > > > > > > > --- a/fs/xfs/xfs_extent_busy.h
> > > > > > > > > > > > > > > > > > > +++ b/fs/xfs/xfs_extent_busy.h
> > > > > > > > > > > > > > > > > > > @@ -65,4 +65,6 @@ static inline void xfs_extent_busy_sort(struct list_head *list)
> > > > > > > > > > > > > > > > > > >  	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
> > > > > > > > > > > > > > > > > > >  }
> > > > > > > > > > > > > > > > > > >  
> > > > > > > > > > > > > > > > > > > +bool xfs_extent_busy_list_empty(struct xfs_perag *pag);
> > > > > > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > > > > >  #endif /* __XFS_EXTENT_BUSY_H__ */
> > > > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > > > --
> > > > > > > > > > > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > > > > > > > > > > --
> > > > > > > > > > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > > > > > > > > > --
> > > > > > > > > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > > > > > > > > --
> > > > > > > > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > > > > > > --
> > > > > > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > > > > > --
> > > > > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > > > > --
> > > > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > > > --
> > > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > > --
> > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > --
> > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > --
> > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > --
> > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > --
> > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html

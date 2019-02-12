Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:15950 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727659AbfBLUV7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Feb 2019 15:21:59 -0500
Date: Wed, 13 Feb 2019 07:21:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/3]: Extreme fragmentation ahoy!
Message-ID: <20190212202150.GS14116@dastard>
References: <20190207050813.24271-1-david@fromorbit.com>
 <20190207052114.GA7991@magnolia>
 <20190207053941.GL14116@dastard>
 <20190207155242.GE2880@bfoster>
 <20190208024730.GM14116@dastard>
 <20190208123432.GB21317@bfoster>
 <20190212011333.GB23989@magnolia>
 <20190212114630.GA35242@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190212114630.GA35242@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Feb 12, 2019 at 06:46:31AM -0500, Brian Foster wrote:
> On Mon, Feb 11, 2019 at 05:13:33PM -0800, Darrick J. Wong wrote:
> > On Fri, Feb 08, 2019 at 07:34:33AM -0500, Brian Foster wrote:
> > > On Fri, Feb 08, 2019 at 01:47:30PM +1100, Dave Chinner wrote:
> > > > On Thu, Feb 07, 2019 at 10:52:43AM -0500, Brian Foster wrote:
> > > > > On Thu, Feb 07, 2019 at 04:39:41PM +1100, Dave Chinner wrote:
> > > > > > On Wed, Feb 06, 2019 at 09:21:14PM -0800, Darrick J. Wong wrote:
> > > > > > > On Thu, Feb 07, 2019 at 04:08:10PM +1100, Dave Chinner wrote:
> > > > > > > > Hi folks,
> > > > > > > > 
> > > > > > > > I've just finished analysing an IO trace from a application
> > > > > > > > generating an extreme filesystem fragmentation problem that started
> > > > > > > > with extent size hints and ended with spurious ENOSPC reports due to
> > > > > > > > massively fragmented files and free space. While the ENOSPC issue
> > > > > > > > looks to have previously been solved, I still wanted to understand
> > > > > > > > how the application had so comprehensively defeated extent size
> > > > > > > > hints as a method of avoiding file fragmentation.
> > > > ....
> > > > > > FWIW, I think the scope of the problem is quite widespread -
> > > > > > anything that does open/something/close repeatedly on a file that is
> > > > > > being written to with O_DSYNC or O_DIRECT appending writes will kill
> > > > > > the post-eof extent size hint allocated space. That's why I suspect
> > > > > > we need to think about not trimming by default and trying to
> > > > > > enumerating only the cases that need to trim eof blocks.
> > > > > > 
> > > > > 
> > > > > To further this point.. I think the eofblocks scanning stuff came long
> > > > > after the speculative preallocation code and associated release time
> > > > > post-eof truncate.
> > > > 
> > > > Yes, I cribed a bit of the history of the xfs_release() behaviour
> > > > on #xfs yesterday afternoon:
> > > > 
> > > >  <djwong>	dchinner: feel free to ignore this until tomorrow if you want, but /me wonders why we'd want to free the eofblocks at close time at all, instead of waiting for inactivation/enospc/background reaper to do it?
> > > >  <dchinner>	historic. People doing operations then complaining du didn't match ls
> > > >  <dchinner>	stuff like that
> > > >  <dchinner>	There used to be a open file cache in XFS - we'd know exactly when the last reference went away and trim it then
> > > >  <dchinner>	but that went away when NFS and the dcache got smarter about file handle conversion
> > > >  <dchinner>	(i.e. that's how we used to make nfs not suck)
> > > >  <dchinner>	that's when we started doing work in ->release
> > > >  <dchinner>	it was close enough to "last close" for most workloads it made no difference.
> > > >  <dchinner>	Except for concurrent NFS writes into the same directory
> > > >  <dchinner>	and now there's another pathological application that triggers problems
> > > >  <dchinner>	The NFS exception was prior to having thebackground reaper
> > > >  <dchinner>	as these things goes the background reaper is relatively recent functionality
> > > >  <dchinner>	so perhaps we should just leave it to "inode cache expiry or background reaping" and not do it on close at al
> > > > 
> > > 
> > > Thanks.
> > > 
> > > > > I think the background scanning was initially an
> > > > > enhancement to deal with things like the dirty release optimization
> > > > > leaving these blocks around longer and being able to free up this
> > > > > accumulated space when we're at -ENOSPC conditions.
> > > > 
> > > > Yes, amongst other things like slow writes keeping the file open
> > > > forever.....
> > > > 
> > > > > Now that we have the
> > > > > scanning mechanism in place (and a 5 minute default background scan,
> > > > > which really isn't all that long), it might be reasonable to just drop
> > > > > the release time truncate completely and only trim post-eof blocks via
> > > > > the bg scan or reclaim paths.
> > > > 
> > > > Yeah, that's kinda the question I'm asking here. What's the likely
> > > > impact of not trimming EOF blocks at least on close apart from
> > > > people complaining about df/ls not matching du?
> > > > 
> > > 
> > > Ok. ISTM it's just a continuation of the same "might confuse some users"
> > > scenario that pops up occasionally. It also seems that kind of thing has
> > > died down as either most people don't really know or care about the
> > > transient state or are just more familiar with it at this point. IME,
> > > complex applications that depend on block ownership stats (userspace
> > > filesystems for example) already have to account for speculative
> > > preallocation with XFS, so tweaking the semantics of the optimization
> > > shouldn't really have much of an impact that I can tell so long as the
> > > broader/long-term behavior doesn't change[1].
> > > 
> > > I suppose there are all kinds of other applications that are technically
> > > affected by dropping the release time trim (simple file copies, archive
> > > extraction, etc.), but it's not clear to me that matters so long as we
> > > have effective bg and -ENOSPC scans. The only thing I can think of so
> > > far is whether we should consider changes to the bg scan heuristics to
> > > accommodate scenarios currently covered by the release time trim. For
> > > example, the release time scan doesn't consider whether the file is
> > > dirty or not while the bg scan always skips "active" files.
> > 
> > I wrote a quick and dirty fstest that writes 999 files between 128k and
> > 256k in size, to simulate untarring onto a filesystem.  No fancy
> > preallocation, just buffered writes.  I patched my kernel to skip the
> > posteof block freeing in xfs_release, so the preallocations get freed by
> > inode inactivation.  Then the freespace histogram looks like:
> > 
> 
> You didn't mention whether you disabled background eofb trims. Are you
> just rendering that irrelevant by disabling the release time trim and
> doing a mount cycle?
> 
> > +   from      to extents  blocks    pct
> > +      1       1      36      36   0.00
> > +      2       3      69     175   0.01
> > +      4       7     122     698   0.02
> > +      8      15     237    2691   0.08
> > +     16      31       1      16   0.00
> > +     32      63     500   27843   0.88
> > + 524288  806272       4 3141225  99.01
> > 
> > Pretty gnarly. :)  By comparison, a stock upstream kernel:
> > 
> 
> Indeed, that's a pretty rapid degradation. Thanks for testing that.
> 
> > +   from      to extents  blocks    pct
> > + 524288  806272       4 3172579 100.00
> > 
> > That's 969 free extents vs. 4, on a fs with 999 new files... which is
> > pretty bad.  Dave also suggessted on IRC that maybe this should be a
> > little smarter -- possibly skipping the posteof removal only if the
> > filesystem has sunit/swidth set, or if the inode has extent size hints,
> > or whatever. :)
> > 
> 
> This test implies that there's a significant difference between eofb
> trims prior to delalloc conversion vs. after, which I suspect is the
> primary difference between doing so on close vs. some time later.

Yes, it's the difference between trimming the excess off the
delalloc extent and trimming the excess off an allocated extent
after writeback. In the later case, we end up fragmenting free space
because, while writeback is packing as tightly as it can, there is
unused space between the end of the one file and the start of the
next that ends up as free space.

> Is
> there any good way to confirm that with your test? If that is the case,
> it makes me wonder whether we should think about more generalized logic
> as opposed to a battery of whatever particular inode state checks that
> we've determined in practice contribute to free space fragmentation.

Yeah, we talked about that on #xfs, and it seems to me that the best
heuristic we can come up with is "trim on first close, if there are
multiple closes treat it as a repeated open/write/close workload and
apply the IDIRTY_RELEASE heuristic to it and don't remove the
prealloc on closes after the first.

> For example, extent size hints just happen to skip delayed allocation.
> I don't recall the exact history, but I don't think this was always the
> case for extsz hints.

It wasn't, but extent size hints + delalloc never played nicely and
could corrupt or expose stale data and caused all sorts of problems
at ENOSPC because delalloc reservations are unaware of alignment
requirements for extent size hints. Hence to make extent size hints
work for buffered writes, I simply made them work the same way as
direct writes (i.e. immediate allocation w/ unwritten extents).

> So would the close time eofb trim be as
> problematic as for extsz hint files if the behavior of the latter
> changed back to using delayed allocation?

Yes, but if it's a write-once file that doesn't matter. If it's
write-many, then we'd retain the post-eof blocks...

> I think a patch for that was
> proposed fairly recently, but it depended on delalloc -> unwritten
> functionality which still had unresolved issues (IIRC).

*nod*

> From another angle, would a system that held files open for a
> significant amount of time relative to a one-time write such that close
> consistently occurred after writeback (and thus delalloc conversion) be
> susceptible to the same level of free space fragmentation as shown
> above?

If the file is held open for writing for a long time, we have to
assume that they are going to write again (and again) so we should
leave the EOF blocks there. If they are writing slower than the eofb
gc, then there's nothing more we can really do in that case...

> (I'm not sure if/why anybody would actually do that.. userspace
> fs with an fd cache perhaps? It's somewhat besides the point,
> anyways...)).

*nod*

> More testing and thought is probably required. I _was_ wondering if we
> should consider something like always waiting as long as possible to
> eofb trim already converted post-eof blocks, but I'm not totally
> convinced that actually has value. For files that are not going to see
> any further appends, we may have already lost since the real post-eof
> blocks will end up truncated just the same whether it happens sooner or
> not until inode reclaim.

If the writes are far enough apart, then we lose any IO optimisation
advantage of retaining post-eof blocks (induces seeks because
location of new writes is fixed ahead of time). Then it just becomes
a fragmentation avoidance If the writes are slow enough,
fragmentation really doesn't matter a whole lot - it's when writes
are frequent and we trash the post-eof blocks quickly that it
matters.

> Hmm, maybe we actually need to think about how to be smarter about when
> to introduce speculative preallocation as opposed to how/when to reclaim
> it. We currently limit speculative prealloc to files of a minimum size
> (64k IIRC). Just thinking out loud, but what if we restricted
> preallocation to files that have been appended after at least one
> writeback cycle, for example?

Speculative delalloc for write once large files also has a massive
impact on things like allocation overhead - we can write gigabytes
into the page cache before writeback begins. If we take away the
specualtive delalloc for these first write files, then we are
essentially doing an extent manipluation (extending delalloc extent)
on every write() call we make.

Right now we only do that extent btree work when we hit the end of
the current speculative delalloc extent, so the normal write case is
just extending the in-memory EOF location rather than running the
entire of xfs_bmapi_reserve_delalloc() and doing space accounting,
etc.

/me points at his 2006 OLS paper about scaling write performance
as an example of just how important keeping delalloc overhead down
is for high throughput write performance:

https://www.kernel.org/doc/ols/2006/ols2006v1-pages-177-192.pdf

IOWs, speculative prealloc beyond EOF is not just about preventing
fragmentation - it also helps minimise the per-write CPU overhead of
delalloc space accounting. (i.e. allows faster write rates into
cache). IOWs, for anything more than a really small files, we want
to be doing speculative delalloc on the first time the file is
written to.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

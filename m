Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfBLLqe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Feb 2019 06:46:34 -0500
Date: Tue, 12 Feb 2019 06:46:31 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 0/3]: Extreme fragmentation ahoy!
Message-ID: <20190212114630.GA35242@bfoster>
References: <20190207050813.24271-1-david@fromorbit.com>
 <20190207052114.GA7991@magnolia>
 <20190207053941.GL14116@dastard>
 <20190207155242.GE2880@bfoster>
 <20190208024730.GM14116@dastard>
 <20190208123432.GB21317@bfoster>
 <20190212011333.GB23989@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190212011333.GB23989@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Mon, Feb 11, 2019 at 05:13:33PM -0800, Darrick J. Wong wrote:
> On Fri, Feb 08, 2019 at 07:34:33AM -0500, Brian Foster wrote:
> > On Fri, Feb 08, 2019 at 01:47:30PM +1100, Dave Chinner wrote:
> > > On Thu, Feb 07, 2019 at 10:52:43AM -0500, Brian Foster wrote:
> > > > On Thu, Feb 07, 2019 at 04:39:41PM +1100, Dave Chinner wrote:
> > > > > On Wed, Feb 06, 2019 at 09:21:14PM -0800, Darrick J. Wong wrote:
> > > > > > On Thu, Feb 07, 2019 at 04:08:10PM +1100, Dave Chinner wrote:
> > > > > > > Hi folks,
> > > > > > > 
> > > > > > > I've just finished analysing an IO trace from a application
> > > > > > > generating an extreme filesystem fragmentation problem that started
> > > > > > > with extent size hints and ended with spurious ENOSPC reports due to
> > > > > > > massively fragmented files and free space. While the ENOSPC issue
> > > > > > > looks to have previously been solved, I still wanted to understand
> > > > > > > how the application had so comprehensively defeated extent size
> > > > > > > hints as a method of avoiding file fragmentation.
> > > ....
> > > > > FWIW, I think the scope of the problem is quite widespread -
> > > > > anything that does open/something/close repeatedly on a file that is
> > > > > being written to with O_DSYNC or O_DIRECT appending writes will kill
> > > > > the post-eof extent size hint allocated space. That's why I suspect
> > > > > we need to think about not trimming by default and trying to
> > > > > enumerating only the cases that need to trim eof blocks.
> > > > > 
> > > > 
> > > > To further this point.. I think the eofblocks scanning stuff came long
> > > > after the speculative preallocation code and associated release time
> > > > post-eof truncate.
> > > 
> > > Yes, I cribed a bit of the history of the xfs_release() behaviour
> > > on #xfs yesterday afternoon:
> > > 
> > >  <djwong>	dchinner: feel free to ignore this until tomorrow if you want, but /me wonders why we'd want to free the eofblocks at close time at all, instead of waiting for inactivation/enospc/background reaper to do it?
> > >  <dchinner>	historic. People doing operations then complaining du didn't match ls
> > >  <dchinner>	stuff like that
> > >  <dchinner>	There used to be a open file cache in XFS - we'd know exactly when the last reference went away and trim it then
> > >  <dchinner>	but that went away when NFS and the dcache got smarter about file handle conversion
> > >  <dchinner>	(i.e. that's how we used to make nfs not suck)
> > >  <dchinner>	that's when we started doing work in ->release
> > >  <dchinner>	it was close enough to "last close" for most workloads it made no difference.
> > >  <dchinner>	Except for concurrent NFS writes into the same directory
> > >  <dchinner>	and now there's another pathological application that triggers problems
> > >  <dchinner>	The NFS exception was prior to having thebackground reaper
> > >  <dchinner>	as these things goes the background reaper is relatively recent functionality
> > >  <dchinner>	so perhaps we should just leave it to "inode cache expiry or background reaping" and not do it on close at al
> > > 
> > 
> > Thanks.
> > 
> > > > I think the background scanning was initially an
> > > > enhancement to deal with things like the dirty release optimization
> > > > leaving these blocks around longer and being able to free up this
> > > > accumulated space when we're at -ENOSPC conditions.
> > > 
> > > Yes, amongst other things like slow writes keeping the file open
> > > forever.....
> > > 
> > > > Now that we have the
> > > > scanning mechanism in place (and a 5 minute default background scan,
> > > > which really isn't all that long), it might be reasonable to just drop
> > > > the release time truncate completely and only trim post-eof blocks via
> > > > the bg scan or reclaim paths.
> > > 
> > > Yeah, that's kinda the question I'm asking here. What's the likely
> > > impact of not trimming EOF blocks at least on close apart from
> > > people complaining about df/ls not matching du?
> > > 
> > 
> > Ok. ISTM it's just a continuation of the same "might confuse some users"
> > scenario that pops up occasionally. It also seems that kind of thing has
> > died down as either most people don't really know or care about the
> > transient state or are just more familiar with it at this point. IME,
> > complex applications that depend on block ownership stats (userspace
> > filesystems for example) already have to account for speculative
> > preallocation with XFS, so tweaking the semantics of the optimization
> > shouldn't really have much of an impact that I can tell so long as the
> > broader/long-term behavior doesn't change[1].
> > 
> > I suppose there are all kinds of other applications that are technically
> > affected by dropping the release time trim (simple file copies, archive
> > extraction, etc.), but it's not clear to me that matters so long as we
> > have effective bg and -ENOSPC scans. The only thing I can think of so
> > far is whether we should consider changes to the bg scan heuristics to
> > accommodate scenarios currently covered by the release time trim. For
> > example, the release time scan doesn't consider whether the file is
> > dirty or not while the bg scan always skips "active" files.
> 
> I wrote a quick and dirty fstest that writes 999 files between 128k and
> 256k in size, to simulate untarring onto a filesystem.  No fancy
> preallocation, just buffered writes.  I patched my kernel to skip the
> posteof block freeing in xfs_release, so the preallocations get freed by
> inode inactivation.  Then the freespace histogram looks like:
> 

You didn't mention whether you disabled background eofb trims. Are you
just rendering that irrelevant by disabling the release time trim and
doing a mount cycle?

> +   from      to extents  blocks    pct
> +      1       1      36      36   0.00
> +      2       3      69     175   0.01
> +      4       7     122     698   0.02
> +      8      15     237    2691   0.08
> +     16      31       1      16   0.00
> +     32      63     500   27843   0.88
> + 524288  806272       4 3141225  99.01
> 
> Pretty gnarly. :)  By comparison, a stock upstream kernel:
> 

Indeed, that's a pretty rapid degradation. Thanks for testing that.

> +   from      to extents  blocks    pct
> + 524288  806272       4 3172579 100.00
> 
> That's 969 free extents vs. 4, on a fs with 999 new files... which is
> pretty bad.  Dave also suggessted on IRC that maybe this should be a
> little smarter -- possibly skipping the posteof removal only if the
> filesystem has sunit/swidth set, or if the inode has extent size hints,
> or whatever. :)
> 

This test implies that there's a significant difference between eofb
trims prior to delalloc conversion vs. after, which I suspect is the
primary difference between doing so on close vs. some time later. Is
there any good way to confirm that with your test? If that is the case,
it makes me wonder whether we should think about more generalized logic
as opposed to a battery of whatever particular inode state checks that
we've determined in practice contribute to free space fragmentation.

For example, extent size hints just happen to skip delayed allocation.
I don't recall the exact history, but I don't think this was always the
case for extsz hints. So would the close time eofb trim be as
problematic as for extsz hint files if the behavior of the latter
changed back to using delayed allocation? I think a patch for that was
proposed fairly recently, but it depended on delalloc -> unwritten
functionality which still had unresolved issues (IIRC).

>From another angle, would a system that held files open for a
significant amount of time relative to a one-time write such that close
consistently occurred after writeback (and thus delalloc conversion) be
susceptible to the same level of free space fragmentation as shown
above? (I'm not sure if/why anybody would actually do that.. userspace
fs with an fd cache perhaps? It's somewhat besides the point,
anyways...)).

More testing and thought is probably required. I _was_ wondering if we
should consider something like always waiting as long as possible to
eofb trim already converted post-eof blocks, but I'm not totally
convinced that actually has value. For files that are not going to see
any further appends, we may have already lost since the real post-eof
blocks will end up truncated just the same whether it happens sooner or
not until inode reclaim.

Hmm, maybe we actually need to think about how to be smarter about when
to introduce speculative preallocation as opposed to how/when to reclaim
it. We currently limit speculative prealloc to files of a minimum size
(64k IIRC). Just thinking out loud, but what if we restricted
preallocation to files that have been appended after at least one
writeback cycle, for example?

Brian

> --D
> 
> > Brian
> > 
> > [1] Which isn't the case for a change to not bg trim files with extent
> > size hints.
> > 
> > > I don't really care about that anymore because, well, reflink/dedupe
> > > completely break any remaining assumption that du reported space
> > > consumption is related to the file size (if sparse files wasn't
> > > enough of a hint arlready)....
> > > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com

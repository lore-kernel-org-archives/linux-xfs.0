Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57118 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbfBLEiu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 23:38:50 -0500
Date: Mon, 11 Feb 2019 17:13:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH 0/3]: Extreme fragmentation ahoy!
Message-ID: <20190212011333.GB23989@magnolia>
References: <20190207050813.24271-1-david@fromorbit.com>
 <20190207052114.GA7991@magnolia>
 <20190207053941.GL14116@dastard>
 <20190207155242.GE2880@bfoster>
 <20190208024730.GM14116@dastard>
 <20190208123432.GB21317@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190208123432.GB21317@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Fri, Feb 08, 2019 at 07:34:33AM -0500, Brian Foster wrote:
> On Fri, Feb 08, 2019 at 01:47:30PM +1100, Dave Chinner wrote:
> > On Thu, Feb 07, 2019 at 10:52:43AM -0500, Brian Foster wrote:
> > > On Thu, Feb 07, 2019 at 04:39:41PM +1100, Dave Chinner wrote:
> > > > On Wed, Feb 06, 2019 at 09:21:14PM -0800, Darrick J. Wong wrote:
> > > > > On Thu, Feb 07, 2019 at 04:08:10PM +1100, Dave Chinner wrote:
> > > > > > Hi folks,
> > > > > > 
> > > > > > I've just finished analysing an IO trace from a application
> > > > > > generating an extreme filesystem fragmentation problem that started
> > > > > > with extent size hints and ended with spurious ENOSPC reports due to
> > > > > > massively fragmented files and free space. While the ENOSPC issue
> > > > > > looks to have previously been solved, I still wanted to understand
> > > > > > how the application had so comprehensively defeated extent size
> > > > > > hints as a method of avoiding file fragmentation.
> > ....
> > > > FWIW, I think the scope of the problem is quite widespread -
> > > > anything that does open/something/close repeatedly on a file that is
> > > > being written to with O_DSYNC or O_DIRECT appending writes will kill
> > > > the post-eof extent size hint allocated space. That's why I suspect
> > > > we need to think about not trimming by default and trying to
> > > > enumerating only the cases that need to trim eof blocks.
> > > > 
> > > 
> > > To further this point.. I think the eofblocks scanning stuff came long
> > > after the speculative preallocation code and associated release time
> > > post-eof truncate.
> > 
> > Yes, I cribed a bit of the history of the xfs_release() behaviour
> > on #xfs yesterday afternoon:
> > 
> >  <djwong>	dchinner: feel free to ignore this until tomorrow if you want, but /me wonders why we'd want to free the eofblocks at close time at all, instead of waiting for inactivation/enospc/background reaper to do it?
> >  <dchinner>	historic. People doing operations then complaining du didn't match ls
> >  <dchinner>	stuff like that
> >  <dchinner>	There used to be a open file cache in XFS - we'd know exactly when the last reference went away and trim it then
> >  <dchinner>	but that went away when NFS and the dcache got smarter about file handle conversion
> >  <dchinner>	(i.e. that's how we used to make nfs not suck)
> >  <dchinner>	that's when we started doing work in ->release
> >  <dchinner>	it was close enough to "last close" for most workloads it made no difference.
> >  <dchinner>	Except for concurrent NFS writes into the same directory
> >  <dchinner>	and now there's another pathological application that triggers problems
> >  <dchinner>	The NFS exception was prior to having thebackground reaper
> >  <dchinner>	as these things goes the background reaper is relatively recent functionality
> >  <dchinner>	so perhaps we should just leave it to "inode cache expiry or background reaping" and not do it on close at al
> > 
> 
> Thanks.
> 
> > > I think the background scanning was initially an
> > > enhancement to deal with things like the dirty release optimization
> > > leaving these blocks around longer and being able to free up this
> > > accumulated space when we're at -ENOSPC conditions.
> > 
> > Yes, amongst other things like slow writes keeping the file open
> > forever.....
> > 
> > > Now that we have the
> > > scanning mechanism in place (and a 5 minute default background scan,
> > > which really isn't all that long), it might be reasonable to just drop
> > > the release time truncate completely and only trim post-eof blocks via
> > > the bg scan or reclaim paths.
> > 
> > Yeah, that's kinda the question I'm asking here. What's the likely
> > impact of not trimming EOF blocks at least on close apart from
> > people complaining about df/ls not matching du?
> > 
> 
> Ok. ISTM it's just a continuation of the same "might confuse some users"
> scenario that pops up occasionally. It also seems that kind of thing has
> died down as either most people don't really know or care about the
> transient state or are just more familiar with it at this point. IME,
> complex applications that depend on block ownership stats (userspace
> filesystems for example) already have to account for speculative
> preallocation with XFS, so tweaking the semantics of the optimization
> shouldn't really have much of an impact that I can tell so long as the
> broader/long-term behavior doesn't change[1].
> 
> I suppose there are all kinds of other applications that are technically
> affected by dropping the release time trim (simple file copies, archive
> extraction, etc.), but it's not clear to me that matters so long as we
> have effective bg and -ENOSPC scans. The only thing I can think of so
> far is whether we should consider changes to the bg scan heuristics to
> accommodate scenarios currently covered by the release time trim. For
> example, the release time scan doesn't consider whether the file is
> dirty or not while the bg scan always skips "active" files.

I wrote a quick and dirty fstest that writes 999 files between 128k and
256k in size, to simulate untarring onto a filesystem.  No fancy
preallocation, just buffered writes.  I patched my kernel to skip the
posteof block freeing in xfs_release, so the preallocations get freed by
inode inactivation.  Then the freespace histogram looks like:

+   from      to extents  blocks    pct
+      1       1      36      36   0.00
+      2       3      69     175   0.01
+      4       7     122     698   0.02
+      8      15     237    2691   0.08
+     16      31       1      16   0.00
+     32      63     500   27843   0.88
+ 524288  806272       4 3141225  99.01

Pretty gnarly. :)  By comparison, a stock upstream kernel:

+   from      to extents  blocks    pct
+ 524288  806272       4 3172579 100.00

That's 969 free extents vs. 4, on a fs with 999 new files... which is
pretty bad.  Dave also suggessted on IRC that maybe this should be a
little smarter -- possibly skipping the posteof removal only if the
filesystem has sunit/swidth set, or if the inode has extent size hints,
or whatever. :)

--D

> Brian
> 
> [1] Which isn't the case for a change to not bg trim files with extent
> size hints.
> 
> > I don't really care about that anymore because, well, reflink/dedupe
> > completely break any remaining assumption that du reported space
> > consumption is related to the file size (if sparse files wasn't
> > enough of a hint arlready)....
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com

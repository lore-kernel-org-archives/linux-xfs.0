Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:65526 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750786AbdIFX37 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Sep 2017 19:29:59 -0400
Date: Thu, 7 Sep 2017 09:29:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/3] XFS real-time device tweaks
Message-ID: <20170906232954.GV17782@dastard>
References: <20170902224145.1291030-1-rwareing@fb.com>
 <20170903085602.GF32385@infradead.org>
 <30E1D468-6E15-469E-8026-8EE542201422@fb.com>
 <20170906034443.GQ17782@dastard>
 <9729DF06-8F96-4F93-BF50-133F9BA2770F@fb.com>
 <20170906114305.GC54570@bfoster.bfoster>
 <20170906121200.GU17782@dastard>
 <20170906124927.GE54570@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906124927.GE54570@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Richard Wareing <rwareing@fb.com>, Christoph Hellwig <hch@infradead.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>

On Wed, Sep 06, 2017 at 08:49:28AM -0400, Brian Foster wrote:
> On Wed, Sep 06, 2017 at 10:12:01PM +1000, Dave Chinner wrote:
> > On Wed, Sep 06, 2017 at 07:43:05AM -0400, Brian Foster wrote:
> > > That said, while the implementation improvement makes sense, I'm still
> > > not necessarily convinced that this has a place in the upstream realtime
> > > feature. I'll grant you that I'm not terribly familiar with the
> > > historical realtime use case.. Dave, do you see value in such a
> > > heuristic as it relates to the realtime feature (not this tiering
> > > setup)? Is there necessarily a mapping between a large file size and a
> > > file that should be tagged realtime?
> > 
> > I don't see it much differently to the inode32 allocator policy.
> > That separates metadata from data based on the type of allocation
> > that is going to take place.  inode32 decides on the AG for the
> > inode data on the first data allocation (via the ag rotor), so
> > there's already precedence for this sort of "locality selection at
> > initial allocation" policy in the XFS allocation algorithms. 
> > 
> > Some workloads run really well on inode32 because the metadata ends
> > up tightly packed and you can keep lots of disks busy with a dm
> > concat because data IO is effectively distributed over all AGs.
> > We've never done that automatically with the rt device before, but
> > if it allows hybrid setups to be constructed easily then I can see
> > it being beneficial to those same sorts of worklaods....
> > 
> > And, FWIW, auto rtdev selection might also work quite nicely with
> > write once large file workloads (i.e. archives) on SMR drives - data
> > device for the PMR region for metadata and small or temporary files,
> > rt device w/ appropriate extent size for larges files in the SMR
> > region...
> > 
> 
> Ok, that sounds reasonable enough to me. Thanks.
> 
> > > E.g., I suppose somebody who is
> > > using traditional realtime (i.e., no SSD) and has a mix of legitimate
> > > realtime (streaming media) files and large sparse virt disk images or
> > > something of that nature would need to know to not use this feature
> > > (i.e., this requires documentation)..?
> > 
> > It wouldn't be enabled by default. We can't break existing rt device
> > setups, so I don't see any issue here. And, well, someone mixing
> > realtime and sparse virt in the same filesystem and storage isn't
> > going to get reliable realtime response. i.e. nobody in their right
> > mind mixes realtime streaming workloads with anything else - it's
> > always dedicated hardware for RT....
> > 
> 
> Yes, that's just a dumb example. Let me rephrase...
> 
> Is there any legitimate realtime use case a filesystem may not want to
> tag all files of a particular size?  E.g., this is more relevant for
> subsequent read requirements than anything, right? (If not, then why do
> we have the flag at all?) If so, then it seems to me this needs to be
> clearly documented...

Hmmm. I'm not following you here, Brian. RT has a deterministic
allocator to prevent arbitrary IO delays on write, not read.  The
read side on RT is no different to the data device (i.e. extent
lookup, read data) and as long as both allocators have given the
file large contiguous extents there's no difference in the size and
shape of read IOs being issued, either.  So I'm not sure what you
are saying needs documenting?

Also, keep in mind the RT device is not suited to small files at
all. It's optimised for allocating large contiguous extents, it
doesn't handle freespace fragmentation at all well so having small
files come and go regularly really screws it up, and it's single
threaded allocator means it can't handle the allocation demand that
comes along with small file workloads, either.....

> Note that this use case defines large as >256k. Realtime use cases may
> have a much different definition, yes?

Again, if the workload is "realtime"(*) then it is not going to be
using this functionality - everything needs to be tightly controlled
and leave nothing to unpredictable algorithmic heuristics.
Regardless, for different *data sets* the size threshold might be
different, but that is for the admin who understands the environment
and applications to separate workloads and set appropriate policy
for each.

If you're only worried about it being a fs global setting, then
start thinking about how to do it per inode/directory.  Personally,
though, I think we need to start moving all the allocation policy
stuff (extsize hints, flags, etc) into a generic alloc policy xattr
space otherwise we're going to run out of space in the inode core
for all this alloc policy stuff...

> I take it that means things like amount of physical memory and
> write workload may also be a significant factor in the
> effectiveness of this heuristic.  For example, how much pagecache
> can we dirty before writeback occurs and does an initial
> allocation?  How many large files are typically written in parallel?

Delayed allocation on large works just fine regardless of these
parameter variations - that's the whole point of all the heuristics
in the delalloc code to prevent fragmentation. IOWs, machine loading
and worklaod should not significantly impact on what device large
files are written to because it's rare that large files get
allocated in tiny chunks by XFS.

Where mistakes are made, xfs_fsr can relocate the files
appropriately. And the good part about having the metadata on SSD is
that the xfs_fsr scan to fnd such files (i.e bulkstat) won't impact
on the running workload significantly.

> Also, what about direct I/O or extent size hints?

If you are doing direct IO, then it's up to the admin and
application to make sure it it's not doing something silly. The
usual raft of alloc policy controls like extent
size hints, preallocation and/or actually setting the rt inherit
bits manually on data set directories can deal with issues here...

> All I'm really saying is that I think this at least needs to consider
> the generic use case and have some documentation around any scnarios
> where this might not make sense for traditional users, what values might
> be sane, etc.

I think you're conflating "integrating new functionality in a
generic manner" with "this is new generic functionality everyone
should use".  CRCs and reflink fall into the latter category, while
allocation policies for rtdevs fall into the former....

> As opposed to such users seeing an "automagic" knob,
> turning it on thinking it replaces the need to think about how to
> properly lay out the fs and then realizing later that this doesn't do
> what they expect. Thoughts?

ISTM that you are over-thinking the problem. :/

We should document how something can/should be used, not iterate all
the cases where it should not be used because they vastly outnumber
the valid use cases. I can see how useful a simple setup like
Richard has described is for effcient long term storage in large
scale storage environments. I think we should aim to support that
cleanly and efficiently first, not try to make it into something
that nobody is asking for....

Cheers,

Dave.

(*) <rant warning>

The "realtime" device isn't real time at all. It's a shit name and I
hate it because it makes people think it's something that it isn't.
It's just an alternative IO address space with a bound overhead
(i.e. deterministic) allocator that is optimised for large
contiguous data allocations.  It's used for workloads are that are
latency sensitive, not "real time". The filesystem is not real time
capable and the IO subsystem is most definitely not real time
capable. It's a crap name.

<end rant>

-- 
Dave Chinner
david@fromorbit.com

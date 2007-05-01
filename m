Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 May 2007 15:30:53 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l41MUnfB011674
	for <xfs@oss.sgi.com>; Tue, 1 May 2007 15:30:50 -0700
Date: Tue, 1 May 2007 15:30:40 -0700
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20070501223040.GL5722@schatzie.adilger.int>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501042254.GD77450368@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On May 01, 2007  14:22 +1000, David Chinner wrote:
> On Mon, Apr 30, 2007 at 04:44:01PM -0600, Andreas Dilger wrote:
> > Hmm, I'd thought "offline" would migrate to EXTENT_UNKNOWN, but I didn't
> 
> I disagree - why would you want to indicate the state is unknown when we know
> very well that it is offline?

If you don't like "UNKNOWN", what about "UNMAPPED"?  I just want a
catch-all flag that indicates "this extent contains data but there is
nothing sensible to be returned for the extent mapping."

> Effectively, when your extent is offline in the HSM, it is inaccessable, and
> you have to bring it back from tape so it becomes accessible again. i.e. some
> action is necessary on behalf of the user to make it accessible. So I think
> that OFFLINE is a good name for this state because it really is inaccessible.

What you are calling OFFLINE I would prefer to call UNMAPPED, since that
can be used by applications as a catch-all for "no mapping".  There can
be further flags that give refinements to UNMAPPED that some applications
might care about them (e.g. HSM_RESIDENT), but many users/apps will not
if they just want the number of fragments in a given file.

> Also, I don't think "secondary" is a good term because most large systems
> have more than one tier of storage. One possibility is "HSM_RESIDENT"
> which indicates the extent is current and resident with a HSM's archive....

Sure.

> > Can you propose reasonable flag names for these (I can't think of anything
> > very good) and a clear explanation of what they mean.  I suspect it will
> > only be XFS that uses them initially.  In mke2fs and ext4+mballoc there is
> > the concept of stripe unit and stripe width, but as yet they are not
> > communicated between the two very well.  I'd be much happier if this info
> > could be queried in a standard way from the block layer instead of the
> > user having to specify it and the filesystem having to track it.
> 
> My preference is definitely for a separate ioctl to grab the
> filesystem geometry so this stuff can be calculated in userspace.
> i.e. the way XFS does it right now (XFS_IOC_FSGEOMETRY). I won't
> bother trying to define names until we decide which appraoch we take
> to implement this.

Hmm, previously you wrote "This information could be easily passed up in the
flags fields if the filesystem has geometry information".  So, I _think_
what you are saying is that you want 4 flags to convey this start/end
alignment information, but the exact semantics of what a "stripe unit" and
a "stripe width" is filesystem specific?

I definitely do NOT want to get into any issues of querying the block
device geometry here.  I was just making a passing comment that ext4+mballoc
can already do RAID-specific allocation alignment, but it depends on the
admin to specify this information and it would be nice if there was some
easy way to get this from userspace/kernel interfaces.

Having an API that can request "tell me the number of blocks from this
offset until the next physical disk boundary" or similar would be useful
to any allocator, and the block layer already needs to know this when
submitting IO.

> In XFS, mkfs.xfs does the work of getting this information
> to see in the filesystem superblock. Here's the code for getting
> sunit/swidth from the underlying block device:
> 
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libdisk/
> 
> Not much in common there ;)

It looks like this might be just what e2fsprogs needs also.

> > It does make sense to specify zero for the fm_extent_count array and a
> > new FIEMAP_FLAG_NO_EXTENTS to return only the count of extents and not the
> > extent data itself, for the non-verbose mode of filefrag, and for
> > pre-allocating a buffer large enough to hold the file if that is important.
> 
> Rather than rely on implicit behaviour of "pass in extent count of
> zero and a don't try to return any extents" to return the number of
> extents on the file, why not just explicitly define this as a valid
> input flag? i.e. FIEMAP_FLAG_GET_NUMEXTENTS

That's what I said, isn't it?  FIEMAP_FLAG_NO_EXTENTS.  I wonder if my
clever-clever for "return no extents" and "return number of extents"
is wasted :-/.

> > - does XFS return an extent for the metadata parts of the file (e.g. btree)?
> 
> No, but we can return the extent map for the attribute fork (i.e.
> extended attrs) if asked for (XFS_IOC_GETBMAPA).

This seems like it would be a useful addition to the interface also, having
FIEMAP_FLAG_METADATA request the return of metadata allocations too.

> > - does XFS return preallocated extents beyond EOF?
> 
> Yes - they are part of the extent map for the file.

OK.

> > - does XFS allow non-root users to call xfs_bmap on files they don't own, or
> >   use by non-root users at all?
> 
> Users can run xfs_bmap on any file they have permission to
> open(O_RDONLY).
> 
> >   The FIBMAP ioctl is for privileged users
> >   only, and I wonder if FIEMAP should be the same, or at least disallow
> >   mapping files that the user can't access especially with FLAG_SYNC and/or
> >   FLAG_HSM_READ.
> 
> I see little reason for restricting FI[BE]MAP to privileged users -
> anyone should be able to determine if files they have permission to
> access are fragmented.

I think I agree with Anton that allowing some of the flags for non-privileged
users seems dangerous.  I think this needs to be determined on a flag-by-flag
basis, and -EPERM should be returned in some cases.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

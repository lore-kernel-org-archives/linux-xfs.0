Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Apr 2007 15:44:08 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3UMi4fB015712
	for <xfs@oss.sgi.com>; Mon, 30 Apr 2007 15:44:06 -0700
Date: Mon, 30 Apr 2007 16:44:01 -0600
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20070430224401.GX5967@schatzie.adilger.int>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419015426.GM48531920@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On Apr 19, 2007  11:54 +1000, David Chinner wrote:
> > struct fiemap {
> > 	__u64 fm_start;		/* logical start offset of mapping (in/out) */
> > 	__u64 fm_len;		/* logical length of mapping (in/out) */
> > 	__u32 fm_flags;		/* FIEMAP_FLAG_* flags for request (in/out) */
> > 	__u32 fm_extent_count;	/* number of extents in fm_extents (in/out) */
> > 	__u64 fm_unused;
> > 	struct fiemap_extent fm_extents[0];
> > }
> > 
> > /* flags for the fiemap request */
> > #define FIEMAP_FLAG_SYNC	0x00000001	/* flush delalloc data to disk*/
> > #define FIEMAP_FLAG_HSM_READ	0x00000002	/* retrieve data from HSM */
> > #define FIEMAP_FLAG_INCOMPAT    0xff000000	/* must understand these flags*/
> 
> No flags in the INCOMPAT range - shouldn't it be 0x3 at this point?

This is actually for future use.  Any flags that are added into this range
must be understood by both sides or it should be considered an error.  Flags
outside the FIEMAP_FLAG_INCOMPAT do not necessarily need to be supported.
If it turns out that 8 bits is too small a range for INCOMPAT flags, then
we can make 0x01000000 an incompat flag that means e.g. 0x00ff0000 are also
incompat flags also.

I'm assuming that all flags that will be in the original FIEMAP proposal
will be understood by the implementations.  Most filesystems can safely
ignore FLAG_HSM_READ, for example, since they don't support HSM, and for
that matter FLAG_SYNC is probably moot for most filesystems also because
they do block allocation at preprw time.

> SO, there's a HSM_READ flag above. If we are going to make this interface
> useful for filesystems that have HSMs interacting with their extents, the
> HSM needs to be able to query whether the extent is online (on disk), 
> has been migrated offline (on tape) or in dual-state (i.e. both online and
> offline).

Hmm, I'd thought "offline" would migrate to EXTENT_UNKNOWN, but I didn't
consider files that are both on disk and on secondary storage (which is
no longer just tape anymore).  I thought I'd call this FIEMAP_EXTENT_OFFLINE,
but that has a confusing connotation that the extent is inaccessible, instead
of just saying it is also on offline storage.  What about
FIEMAP_EXTENT_SECONDARY?  Other proposals welcome.

FIEMAP_EXTENT_SECONDARY could still be set even if the file is mapped.
That would mean an offline-only file would be EXTENT_SECONDARY|EXTENT_UNKNOWN,
while a dual-location file would be EXTENT_SECONDARY only.


> > SUMMARY OF CHANGES
> > ==================
> > - add separate fe_flags word with flags from various suggestions:
> >   - FIEMAP_EXTENT_HOLE = extent has no space allocation
> >   - FIEMAP_EXTENT_UNWRITTEN = extent space allocation but contains no data
> >   - FIEMAP_EXTENT_UNKNOWN = extent contains data, but location is unknown
> >     (e.g. HSM, delalloc awaiting sync, etc)
> 
> I'd like an explicit delalloc flag, not lumping it in with "unknown".
> we *know* the extent is delalloc ;)

Sure, FIEMAP_EXTENT_DELALLOC is fine.  It is mostly redundant with
EXTENT_UNKNOWN (and I think it only makes sense if DELALLOC is given in
addition to UNKNOWN).  I'd like to keep a generic "UNKNOWN" flag that can
be used by applications that don't really care about why it is unmapped
and in case there are other reasons in the future that an extent might
be unmapped (e.g. fsck or storage layer reporting corruption or loss of
that part of the file).

> > > chook 681% xfs_bmap -vv fred
> > > fred:
> > >  EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET          TOTAL FLAGS
> > >    0: [0..151]:        288444888..288445039  8 (1696536..1696687)   152 00010
> > >  FLAG Values:
> > >     010000 Unwritten preallocated extent
> > >     001000 Doesn't begin on stripe unit
> > >     000100 Doesn't end   on stripe unit
> > >     000010 Doesn't begin on stripe width
> > >     000001 Doesn't end   on stripe width
> > 
> > Can you clarify the terminology here?  What is a "stripe unit" and what is
> > a "stripe width"? 
> 
> Stripe unit is equivalent of the chunk size in an MD RAID. It's the amount
> of data that is written to each lun in a stripe before moving onto the
> next stripe element.
> 
> > Are there "N * stripe_unit = stripe_width" in e.g. a
> > RAID 5 (N+1) array, or N-disk RAID 0?  Maybe vice versa?
> 
> Yes, on simple configurations. In more complex HW RAID
> configurations, we'll typically set the stripe unit to the width of
> the RAID5 lun (N * segment size) and the stripe width to the number
> of luns we've striped across.

Can you propose reasonable flag names for these (I can't think of anything
very good) and a clear explanation of what they mean.  I suspect it will
only be XFS that uses them initially.  In mke2fs and ext4+mballoc there is
the concept of stripe unit and stripe width, but as yet they are not
communicated between the two very well.  I'd be much happier if this info
could be queried in a standard way from the block layer instead of the
user having to specify it and the filesystem having to track it.

> > > Ok, so the only way you can determine where you are in the file
> > > is by adding up the length of each extent. What happens if the file
> > > is changing underneath you e.g. someone punches out a hole
> > > in teh file, or truncates and extends it again between ioctl()
> > > calls?
> > 
> > Well, that is always true with data once it is out of the caller.
> 
> Sure, but this interface requires iterative calls where the n+1
> call is reliant on nothing changing since the first call to be
> accurate. My question is how do you use this interface to reliably
> and accurately get all the extents if you using iterative summing
> like this?

Maybe it wasn't clear, but the semantics of the ioctl are that it will
return the first extent that contains the requested byte offset in fm_start.
If the file has changed since the last call to FIEMAP then it will restart
with the extent that covers this byte and continue on.  In most cases the
file mapping should be returnable in a single ioctl (assuming a reasonable
extent count).

> > > Also, what happens if you ask for an offset/len that doesn't map to
> > > any extent boundaries - are you truncating the extents returned to
> > > teh off/len passed in?
> > 
> > The request offset will be returned as the start of the actual extent that
> > it falls inside.  And the returned extents will end with the extent that
> > ends at or after the requested fm_start + fm_len.
> 
> Ok, so you round the start inwards and the round end outwards. Can
> you ensure that this is documented in the header file that describes
> this interface?

Sure.

> > > xfs_bmap gets around this by finding out how many extents there are in the
> > > file and allocating a buffer that big to hold all the extents so they
> > > are gathered in a single atomic call (think sparse matrix files)....
> > 
> > Yeah, except this might be persistent for a long time if it isn't fully
> > read with a single ioctl and the app never continues reading but doesn't
> > close the fd.
> 
> Not sure I follow you here...

Ah, I was thinking that XFS was keeping a copy of the whole extent
mapping in the kernel to handle getting the data with separate calls.
It does make sense to specify zero for the fm_extent_count array and a
new FIEMAP_FLAG_NO_EXTENTS to return only the count of extents and not the
extent data itself, for the non-verbose mode of filefrag, and for
pre-allocating a buffer large enough to hold the file if that is important.

I'm also going to add a FIEMAP_FLAG_LAST to mark the last extent in the file,
so that iterators using a small buffer don't need to retry to get the last
extent, and it is possible in case of e.g. EINTR (or whatever) to return a
short list without signalling EOF.  I think this is cleaner than returning
a HOLE extent from EOF to ~0ULL.

Another question about semantics -
- does XFS return an extent for the metadata parts of the file (e.g. btree)?
- does XFS return preallocated extents beyond EOF?
- does XFS allow non-root users to call xfs_bmap on files they don't own, or
  use by non-root users at all?  The FIBMAP ioctl is for privileged users
  only, and I wonder if FIEMAP should be the same, or at least disallow
  mapping files that the user can't access especially with FLAG_SYNC and/or
  FLAG_HSM_READ.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

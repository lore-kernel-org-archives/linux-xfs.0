Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Apr 2007 21:23:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l414N5fB026879
	for <xfs@oss.sgi.com>; Mon, 30 Apr 2007 21:23:07 -0700
Date: Tue, 1 May 2007 14:22:54 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20070501042254.GD77450368@melbourne.sgi.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430224401.GX5967@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On Mon, Apr 30, 2007 at 04:44:01PM -0600, Andreas Dilger wrote:
> On Apr 19, 2007  11:54 +1000, David Chinner wrote:
> > > struct fiemap {
> > > 	__u64 fm_start;		/* logical start offset of mapping (in/out) */
> > > 	__u64 fm_len;		/* logical length of mapping (in/out) */
> > > 	__u32 fm_flags;		/* FIEMAP_FLAG_* flags for request (in/out) */
> > > 	__u32 fm_extent_count;	/* number of extents in fm_extents (in/out) */
> > > 	__u64 fm_unused;
> > > 	struct fiemap_extent fm_extents[0];
> > > }
> > > 
> > > /* flags for the fiemap request */
> > > #define FIEMAP_FLAG_SYNC	0x00000001	/* flush delalloc data to disk*/
> > > #define FIEMAP_FLAG_HSM_READ	0x00000002	/* retrieve data from HSM */
> > > #define FIEMAP_FLAG_INCOMPAT    0xff000000	/* must understand these flags*/
> > 
> > No flags in the INCOMPAT range - shouldn't it be 0x3 at this point?
> 
> This is actually for future use.  Any flags that are added into this range
> must be understood by both sides or it should be considered an error.  Flags
> outside the FIEMAP_FLAG_INCOMPAT do not necessarily need to be supported.
> If it turns out that 8 bits is too small a range for INCOMPAT flags, then
> we can make 0x01000000 an incompat flag that means e.g. 0x00ff0000 are also
> incompat flags also.

Ah, ok. So it's not really a set of "compatibility" flags,
it's more a "compulsory" set. Under those terms, i don't really
see why this is necessary - either the filesystem will understand
the flags or it will return EINVAL or ignore them...

> I'm assuming that all flags that will be in the original FIEMAP proposal
> will be understood by the implementations.  Most filesystems can safely
> ignore FLAG_HSM_READ, for example, since they don't support HSM, and for
> that matter FLAG_SYNC is probably moot for most filesystems also because
> they do block allocation at preprw time.

Exactly my point - so why do we really need to encode a compulsory set
of flags in the API? 

> > SO, there's a HSM_READ flag above. If we are going to make this interface
> > useful for filesystems that have HSMs interacting with their extents, the
> > HSM needs to be able to query whether the extent is online (on disk), 
> > has been migrated offline (on tape) or in dual-state (i.e. both online and
> > offline).
> 
> Hmm, I'd thought "offline" would migrate to EXTENT_UNKNOWN, but I didn't

I disagree - why would you want to indicate the state is unknown when we know
very well that it is offline?

> consider files that are both on disk and on secondary storage (which is
> no longer just tape anymore).  I thought I'd call this FIEMAP_EXTENT_OFFLINE,
> but that has a confusing connotation that the extent is inaccessible, instead
> of just saying it is also on offline storage.  What about
> FIEMAP_EXTENT_SECONDARY?  Other proposals welcome.

Effectively, when your extent is offline in the HSM, it is inaccessable, and
you have to bring it back from tape so it becomes accessible again. i.e. some
action is necessary on behalf of the user to make it accessible. So I think
that OFFLINE is a good name for this state because it really is inaccessible.

Also, I don't think "secondary" is a good term because most large systems
have more than one tier of storage. One possibility is "HSM_RESIDENT"
which indicates the extent is current and resident with a HSM's archive....

> FIEMAP_EXTENT_SECONDARY could still be set even if the file is mapped.
> That would mean an offline-only file would be EXTENT_SECONDARY|EXTENT_UNKNOWN,
> while a dual-location file would be EXTENT_SECONDARY only.

I much prefer OFFLINE|HSM_RESIDENT and HSM_RESIDENT as it is far more
descriptive as to what the state is (which certainly isn't unknown).

> > > SUMMARY OF CHANGES
> > > ==================
> > > - add separate fe_flags word with flags from various suggestions:
> > >   - FIEMAP_EXTENT_HOLE = extent has no space allocation
> > >   - FIEMAP_EXTENT_UNWRITTEN = extent space allocation but contains no data
> > >   - FIEMAP_EXTENT_UNKNOWN = extent contains data, but location is unknown
> > >     (e.g. HSM, delalloc awaiting sync, etc)
> > 
> > I'd like an explicit delalloc flag, not lumping it in with "unknown".
> > we *know* the extent is delalloc ;)
> 
> Sure, FIEMAP_EXTENT_DELALLOC is fine.  It is mostly redundant with
> EXTENT_UNKNOWN (and I think it only makes sense if DELALLOC is given in
> addition to UNKNOWN).

I disagree that it is redundant - in case you hadn't already noticed I
dislike the idea of "unknown" meaning one of several possible known
states ;)

> I'd like to keep a generic "UNKNOWN" flag that can
> be used by applications that don't really care about why it is unmapped
> and in case there are other reasons in the future that an extent might
> be unmapped (e.g. fsck or storage layer reporting corruption or loss of
> that part of the file).

Sure.

> > > > chook 681% xfs_bmap -vv fred
> > > > fred:
> > > >  EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET          TOTAL FLAGS
> > > >    0: [0..151]:        288444888..288445039  8 (1696536..1696687)   152 00010
> > > >  FLAG Values:
> > > >     010000 Unwritten preallocated extent
> > > >     001000 Doesn't begin on stripe unit
> > > >     000100 Doesn't end   on stripe unit
> > > >     000010 Doesn't begin on stripe width
> > > >     000001 Doesn't end   on stripe width
> > > 
> > > Can you clarify the terminology here?  What is a "stripe unit" and what is
> > > a "stripe width"? 
> > 
> > Stripe unit is equivalent of the chunk size in an MD RAID. It's the amount
> > of data that is written to each lun in a stripe before moving onto the
> > next stripe element.
> > 
> > > Are there "N * stripe_unit = stripe_width" in e.g. a
> > > RAID 5 (N+1) array, or N-disk RAID 0?  Maybe vice versa?
> > 
> > Yes, on simple configurations. In more complex HW RAID
> > configurations, we'll typically set the stripe unit to the width of
> > the RAID5 lun (N * segment size) and the stripe width to the number
> > of luns we've striped across.
> 
> Can you propose reasonable flag names for these (I can't think of anything
> very good) and a clear explanation of what they mean.  I suspect it will
> only be XFS that uses them initially.  In mke2fs and ext4+mballoc there is
> the concept of stripe unit and stripe width, but as yet they are not
> communicated between the two very well.  I'd be much happier if this info
> could be queried in a standard way from the block layer instead of the
> user having to specify it and the filesystem having to track it.

My preference is definitely for a separate ioctl to grab the
filesystem geometry so this stuff can be calculated in userspace.
i.e. the way XFS does it right now (XFS_IOC_FSGEOMETRY). I won't
bother trying to define names until we decide which appraoch we take
to implement this.

The problem with the block layer is that ther is no standard way of
getting this information - every volume manager has a different
method. In XFS, mkfs.xfs does the work of getting this information
to see in the filesystem superblock. Here's the code for getting
sunit/swidth from the underlying block device:

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libdisk/

Not much in common there ;)

The other problem is that there is no guarantee the filesystem and
the block layer are using the same values as they can be overridden
by mount options. e.g the block layer may have a stripe unit of
512k, but it's perfectly valid for the filesystem to use a multiple
of this for it's sunit, or to not use a sunit at all. Hence you
really do need to track this in the filesystem and query it from
there...

> > > > xfs_bmap gets around this by finding out how many extents there are in the
> > > > file and allocating a buffer that big to hold all the extents so they
> > > > are gathered in a single atomic call (think sparse matrix files)....
> > > 
> > > Yeah, except this might be persistent for a long time if it isn't fully
> > > read with a single ioctl and the app never continues reading but doesn't
> > > close the fd.
> > 
> > Not sure I follow you here...
> 
> Ah, I was thinking that XFS was keeping a copy of the whole extent
> mapping in the kernel to handle getting the data with separate calls.

Actually, it keeps the whole mapping in the kernel to make lookups
fast and relatively simple.

> It does make sense to specify zero for the fm_extent_count array and a
> new FIEMAP_FLAG_NO_EXTENTS to return only the count of extents and not the
> extent data itself, for the non-verbose mode of filefrag, and for
> pre-allocating a buffer large enough to hold the file if that is important.

Rather than rely on implicit behaviour of "pass in extent count of
zero and a don't try to return any extents" to return the number of
extents on the file, why not just explicitly define this as a valid
input flag? i.e. FIEMAP_FLAG_GET_NUMEXTENTS

> I'm also going to add a FIEMAP_FLAG_LAST to mark the last extent in the file,
> so that iterators using a small buffer don't need to retry to get the last
> extent, and it is possible in case of e.g. EINTR (or whatever) to return a
> short list without signalling EOF.  I think this is cleaner than returning
> a HOLE extent from EOF to ~0ULL.

Yes, good idea.

> Another question about semantics -
> - does XFS return an extent for the metadata parts of the file (e.g. btree)?

No, but we can return the extent map for the attribute fork (i.e.
extended attrs) if asked for (XFS_IOC_GETBMAPA).

> - does XFS return preallocated extents beyond EOF?

Yes - they are part of the extent map for the file.

> - does XFS allow non-root users to call xfs_bmap on files they don't own, or
>   use by non-root users at all?

Users can run xfs_bmap on any file they have permission to
open(O_RDONLY).

>   The FIBMAP ioctl is for privileged users
>   only, and I wonder if FIEMAP should be the same, or at least disallow
>   mapping files that the user can't access especially with FLAG_SYNC and/or
>   FLAG_HSM_READ.

I see little reason for restricting FI[BE]MAP to privileged users -
anyone should be able to determine if files they have permission to
access are fragmented.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Apr 2007 18:54:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3J1sdfB017095
	for <xfs@oss.sgi.com>; Wed, 18 Apr 2007 18:54:41 -0700
Date: Thu, 19 Apr 2007 11:54:26 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20070419015426.GM48531920@melbourne.sgi.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419002139.GK5967@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On Wed, Apr 18, 2007 at 06:21:39PM -0600, Andreas Dilger wrote:
> On Apr 16, 2007  21:22 +1000, David Chinner wrote:
> > On Thu, Apr 12, 2007 at 05:05:50AM -0600, Andreas Dilger wrote:
> > > struct fiemap_extent {
> > > 	__u64 fe_start;			/* starting offset in bytes */
> > > 	__u64 fe_len;			/* length in bytes */
> > > }
> > > 
> > > struct fiemap {
> > > 	struct fiemap_extent fm_start;	/* offset, length of desired mapping */
> > > 	__u32 fm_extent_count;		/* number of extents in array */
> > > 	__u32 fm_flags;			/* flags (similar to XFS_IOC_GETBMAP) */
> > > 	__u64 unused;
> > > 	struct fiemap_extent fm_extents[0];
> > > }
> > > 
> > > #define FIEMAP_LEN_MASK		0xff000000000000
> > > #define FIEMAP_LEN_HOLE     	0x01000000000000
> > > #define FIEMAP_LEN_UNWRITTEN	0x02000000000000
> > 
> > I'm not sure I like stealing bits from the length to use a flags -
> > I'd prefer an explicit field per fiemap_extent for this.
> 
> Christoph expressed the same concern.  I'm not dead set against having an
> extra 8 bytes per extent (32-bit flags, 32-bit reserved), though it may
> mean the need for 50% more ioctls if the file is large.

I don't think this overhead is a huge problem - just pass in a
larger buffer (e.g. xfs_bmap can ask for thousands of extents in
a single ioctl call as we can extract the number of extents in
an inode via XFS_IOC_FSGETXATTRA).

> Below is an aggregation of the comments in this thread:
> 
> struct fiemap_extent {
> 	__u64 fe_start;		/* starting offset in bytes */
> 	__u64 fe_len;		/* length in bytes */
> 	__u32 fe_flags;		/* FIEMAP_EXTENT_* flags for this extent */
> 	__u32 fe_lun;		/* logical storage device number in array */
> }

Oh, I missed the bit about the fe_lun - I was thinking something like
that might be useful in future....

> struct fiemap {
> 	__u64 fm_start;		/* logical start offset of mapping (in/out) */
> 	__u64 fm_len;		/* logical length of mapping (in/out) */
> 	__u32 fm_flags;		/* FIEMAP_FLAG_* flags for request (in/out) */
> 	__u32 fm_extent_count;	/* number of extents in fm_extents (in/out) */
> 	__u64 fm_unused;
> 	struct fiemap_extent fm_extents[0];
> }
> 
> /* flags for the fiemap request */
> #define FIEMAP_FLAG_SYNC	0x00000001	/* flush delalloc data to disk*/
> #define FIEMAP_FLAG_HSM_READ	0x00000002	/* retrieve data from HSM */
> #define FIEMAP_FLAG_INCOMPAT    0xff000000	/* must understand these flags*/

No flags in the INCOMPAT range - shouldn't it be 0x3 at this point?

> /* flags for the returned extents */
> #define FIEMAP_EXTENT_HOLE	0x00000001	/* no space allocated */
> #define FIEMAP_EXTENT_UNWRITTEN	0x00000002	/* uninitialized space */
> #define FIEMAP_EXTENT_UNKNOWN	0x00000004	/* in use, location unknown */
> #define FIEMAP_EXTENT_ERROR	0x00000008	/* error mapping space */
> #define FIEMAP_EXTENT_NO_DIRECT	0x00000010	/* no direct data access */

SO, there's a HSM_READ flag above. If we are going to make this interface
useful for filesystems that have HSMs interacting with their extents, the
HSM needs to be able to query whether the extent is online (on disk), 
has been migrated offline (on tape) or in dual-state (i.e. both online and
offline).

> SUMMARY OF CHANGES
> ==================
> - use fm_* fields directly in request instead of making it a fiemap_extent
>   (though they are layed out identically)
> 
> - separate flags word for fm_flags:
>   - FIEMAP_FLAG_SYNC = range should be synced to disk before returning
>     mapping, may return FIEMAP_EXTENT_UNKNOWN for delalloc writes otherwise
>   - FIEMAP_FLAG_HSM_READ = force retrieval + mapping from HSM if specified
>     (this has the opposite meaning of XFS's BMV_IF_NO_DMAPI_READ flag)
>   - FIEMAP_FLAG_XATTR = omitted for now, can address that in the future
>     if there is agreement on whether that is desirable to have or if it is
>     better to call ioctl(FIEMAP) on an XATTR fd.
>   - FIEMAP_FLAG_INCOMPAT = if flags are set in this mask in request, kernel
>     must understand them, or fail ioctl with e.g. EOPNOTSUPP, so that we
>     don't request e.g. FIEMAP_FLAG_XATTR and kernel ignores it
> 
> - __u64 fm_unused does not take up an extra space on all power-of-two buffer
>   sizes (would otherwise be at end of buffer), and may be handy in the future.
> 
> - add separate fe_flags word with flags from various suggestions:
>   - FIEMAP_EXTENT_HOLE = extent has no space allocation
>   - FIEMAP_EXTENT_UNWRITTEN = extent space allocation but contains no data
>   - FIEMAP_EXTENT_UNKNOWN = extent contains data, but location is unknown
>     (e.g. HSM, delalloc awaiting sync, etc)

I'd like an explicit delalloc flag, not lumping it in with "unknown".
we *know* the extent is delalloc ;)

>   - FIEMAP_EXTENT_ERROR = error mapping extent.  Should fe_lun == errno?
>   - FIEMAP_EXTENT_NO_DIRECT = data cannot be directly accessed (e.g. data
>     encrypted, compressed, etc), may want separate flags for these?
> 
> - add new fe_lun word per extent for filesystems that manage multiple devices
>   (e.g. OCFS, GFS, ZFS, Lustre).  This would otherwise have been unused.
> 
> 
> > Given that xfs_bmap uses extra information from the filesystem
> > (geometry) to display extra (and frequently used) information
> > about the alignment of extents. ie:
> > 
> > chook 681% xfs_bmap -vv fred
> > fred:
> >  EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET          TOTAL FLAGS
> >    0: [0..151]:        288444888..288445039  8 (1696536..1696687)   152 00010
> >  FLAG Values:
> >     010000 Unwritten preallocated extent
> >     001000 Doesn't begin on stripe unit
> >     000100 Doesn't end   on stripe unit
> >     000010 Doesn't begin on stripe width
> >     000001 Doesn't end   on stripe width
> 
> Can you clarify the terminology here?  What is a "stripe unit" and what is
> a "stripe width"? 

Stripe unit is equivalent of the chunk size in an MD RAID. It's the amount
of data that is written to each lun in a stripe before moving onto the
next stripe element.

> Are there "N * stripe_unit = stripe_width" in e.g. a
> RAID 5 (N+1) array, or N-disk RAID 0?  Maybe vice versa?

Yes, on simple configurations. In more complex HW RAID
configurations, we'll typically set the stripe unit to the width of
the RAID5 lun (N * segment size) and the stripe width to the number
of luns we've striped across.

The reason I want this to come out of the filesystem is that one of
the driving factors for multi-device support in XFS is to allow
multiple devices of different geometries to co-exist efficiently in
the one namespace (another reason I'm happy about the fe_lun
addition). Passing this information out with the extent is far
simpler than trying to find what device it lies on from userspace,
then querying for the geometry of that device and then converting
it. Especially when extents could lie on different devices with
differing geometries....


> I don't mind adding this, as long as it's clear that some filesystems don't
> have this kind of information.

Sure.

> > This information could be easily passed up in the flags fields if the
> > filesystem has geometry information (there go 4 more flags ;). 
> 
> Got lots of flag bits now.

Time to start using them all up ;)

> > Also - what are the explicit sync semantics of this ioctl? The
> > XFS ioctl causes a fsync of the file first to convert delalloc
> > extents to real extents before returning the bmap. Is this functionality
> > going to be the same? If not, then we need a DELALLOC flag to indicate
> > extents that haven't been allocated yet. This might be handy to
> > have, anyway....
> 
> Have added a FIEMAP_FLAG_SYNC on the request to sync if applications care,

OK.

> and FIEMAP_EXTENT_UNKNOWN can handle unmapped extents for delalloc.

I'd prefer explicit enumeration of then, as I said before...

> > >  The fm_extents array
> > > returned contains the packed list of allocation extents for the file,
> > > including entries for holes (which have fe_start == 0, and a flag).
> > 
> > Internalling in XFS, we pass these around as:
> > 
> > #define DELAYSTARTBLOCK         ((xfs_fsblock_t)-1LL)
> > #define HOLESTARTBLOCK          ((xfs_fsblock_t)-2LL)
> 
> We could do this too, instead of having flags, but many of the proposed
> flags are orthogonal so we'd end up needing a lot of separate values here
> and it would just degenerate into the FIEMAP_LEN_MASK I previously suggested.

Yeah, fair enough.

> > > 		for (i = 0; i < fm->fm_extent_count; i++) {
> > > 			__u64 len = fm->fm_extents[i].fe_len & FIEMAP_LEN_MASK;
> > > 			__u64 fm_next = fm->fm_start.fe_start + len;
> > > 			int hole = fm->fm_extents[i].fe_len & FIEMAP_LEN_HOLE;
> > > 			int unwr = fm->fm_extents[i].fe_len & FIEMAP_LEN_UNWRITTEN;
> > > 
> > > 			printf("%llu-%llu\t%llu-%llu\t%llu\t%s%s\n",
> > > 				fm->fm_start.fe_start, fm_next - 1,
> > > 				hole ? 0 : fm->fm_extents[i].fe_start,
> > > 				hole ? 0 : fm->fm_extents[i].fe_start +
> > > 					   fm->fm_extents[i].fe_len - 1,
> > > 				len, hole ? "(hole) " : "",
> > > 				unwr ? "(unwritten) " : "");
> > > 
> > > 			/* get ready for printing next extent, or next ioctl */
> > > 			fm->fm_start.fe_start = fm_next;
> > 
> > Ok, so the only way you can determine where you are in the file
> > is by adding up the length of each extent. What happens if the file
> > is changing underneath you e.g. someone punches out a hole
> > in teh file, or truncates and extends it again between ioctl()
> > calls?
> 
> Well, that is always true with data once it is out of the caller.

Sure, but this interface requires iterative calls where the n+1
call is reliant on nothing changing since the first call to be
accurate. My question is how do you use this interface to reliably
and accurately get all the extents if you using iterative summing
like this?

> > Also, what happens if you ask for an offset/len that doesn't map to
> > any extent boundaries - are you truncating the extents returned to
> > teh off/len passed in?
> 
> The request offset will be returned as the start of the actual extent that
> it falls inside.  And the returned extents will end with the extent that
> ends at or after the requested fm_start + fm_len.

Ok, so you round the start inwards and the round end outwards. Can
you ensure that this is documented in the header file that describes
this interface?

> > xfs_bmap gets around this by finding out how many extents there are in the
> > file and allocating a buffer that big to hold all the extents so they
> > are gathered in a single atomic call (think sparse matrix files)....
> 
> Yeah, except this might be persistent for a long time if it isn't fully
> read with a single ioctl and the app never continues reading but doesn't
> close the fd.

Not sure I follow you here...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

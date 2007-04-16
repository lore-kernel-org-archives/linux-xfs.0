Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Apr 2007 04:23:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3GBN6fB021516
	for <xfs@oss.sgi.com>; Mon, 16 Apr 2007 04:23:08 -0700
Date: Mon, 16 Apr 2007 21:22:53 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20070416112252.GJ48531920@melbourne.sgi.com>
References: <20070412110550.GM5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412110550.GM5967@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On Thu, Apr 12, 2007 at 05:05:50AM -0600, Andreas Dilger wrote:
> I'm interested in getting input for implementing an ioctl to efficiently
> map file extents & holes (FIEMAP) instead of looping over FIBMAP a billion
> times.  We already have customers with single files in the 10TB range and
> we additionally need to get the mapping over the network so it needs to
> be efficient in terms of how data is passed, and how easily it can be
> extracted from the filesystem.
> 
> I had come up with a plan independently and was also steered toward
> XFS_IOC_GETBMAP* ioctls which are in fact very similar to my original
> plan, though I think the XFS structs used there are a bit bloated.

Yeah, they were designed with having a long term stable ABI
that limited expandability. Hence the "future" fields that never
got used ;)

> There was also recent discussion about SEEK_HOLE and SEEK_DATA as
> implemented by Sun, but even if we could skip the holes we still might
> need to do millions of FIBMAPs to see how large files are allocated
> on disk.  Conversely, having filesystems implement an efficient FIBMAP
> ioctl (or ->fiemap() method) could in turn be leveraged for SEEK_HOLE
> and SEEK_DATA instead of doing looping over ->bmap() inside the kernel
> as I saw one patch.

Yup.

> struct fibmap_extent {
> 	__u64 fe_start;			/* starting offset in bytes */
> 	__u64 fe_len;			/* length in bytes */
> }
> 
> struct fibmap {
> 	struct fibmap_extent fm_start;	/* offset, length of desired mapping */
> 	__u32 fm_extent_count;		/* number of extents in array */
> 	__u32 fm_flags;			/* flags (similar to XFS_IOC_GETBMAP) */
> 	__u64 unused;
> 	struct fibmap_extent fm_extents[0];
> }
> 
> #define FIEMAP_LEN_MASK		0xff000000000000
> #define FIEMAP_LEN_HOLE     	0x01000000000000
> #define FIEMAP_LEN_UNWRITTEN	0x02000000000000

I'm not sure I like stealing bits from the length to use a flags -
I'd prefer an explicit field per fibmap_extent for this.

Given that xfs_bmap uses extra information from the filesystem
(geometry) to display extra (and frequently used) information
about the alignment of extents. ie:

chook 681% xfs_bmap -vv fred
fred:
 EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET          TOTAL FLAGS
   0: [0..151]:        288444888..288445039  8 (1696536..1696687)   152 00010
 FLAG Values:
    010000 Unwritten preallocated extent
    001000 Doesn't begin on stripe unit
    000100 Doesn't end   on stripe unit
    000010 Doesn't begin on stripe width
    000001 Doesn't end   on stripe width

This information could be easily passed up in the flags fields if the
filesystem has geometry information (there go 4 more flags ;). 

Also - what are the explicit sync semantics of this ioctl? The
XFS ioctl causes a fsync of the file first to convert delalloc
extents to real extents before returning the bmap. Is this functionality
going to be the same? If not, then we need a DELALLOC flag to indicate
extents that haven't been allocated yet. This might be handy to
have, anyway....

> All offsets are in bytes to allow cases where filesystems are not going
> block-aligned/sized allocations (e.g. tail packing).

So it'll be ok for a few years yet ;)

>  The fm_extents array
> returned contains the packed list of allocation extents for the file,
> including entries for holes (which have fe_start == 0, and a flag).

Internalling in XFS, we pass these around as:

#define DELAYSTARTBLOCK         ((xfs_fsblock_t)-1LL)
#define HOLESTARTBLOCK          ((xfs_fsblock_t)-2LL)

And the offset passed out through XFS_IOC_GETBMAP[X] is a block
number of -1 for the start of a hole. Hence we don't need a
flag for this. We can expose delalloc extents like this as well
without needing flags...

> The ->fm_extents[] array includes all of the holes in addition to
> allocated extents because this avoids the need to return both the logical
> and physical address for every extent and does not make processing any
> harder.

Doesn't really make it any easier to map to disk, either.

> One feature that XFS_IOC_GETBMAPX has that may be desirable is the
> ability to return unwritten extent information.

You got that with the unwritten flag above.....

> required expanding the per-extent struct from 32 to 48 bytes per extent,

not sure I follow your maths here?

> but I'd rather limit a single extent to e.g. 2^56 bytes (oh, what hardship)
> and keep 8 bytes or so for input/output flags per extent (would need to
             ^^^^^ bits?
> be masked before use).
> 
> 
> Caller works something like:
> 
> 	char buf[4096];
> 	struct fibmap *fm = (struct fibmap *)buf;
> 	int count = (sizeof(buf) - sizeof(*fm)) / sizeof(fm_extent);
> 	
> 	fm->fm_extent.fe_start = 0; /* start of file */
> 	fm->fm_extent.fe_len = -1;	/* end of file */
> 	fm->fm_extent_count = count; /* max extents in fm_extents[] array */
> 	fm->fm_flags = 0;		/* maybe "no DMAPI", etc like XFS */
> 
> 	fd = open(path, O_RDONLY);
> 	printf("logical\t\tphysical\t\tbytes\n");
> 
> 	/* The last entry will have less extents than the maximum */
> 	while (fm->fm_extent_count == count) {

fm_extent_count is an in/out parameter?

> 		rc = ioctl(fd, FIEMAP, fm);
> 		if (rc)
> 			break;
> 
> 		/* kernel filled in fm_extents[] array, set fm_extent_count
> 		 * to be actual number of extents returned, leaves fm_start
> 		 * alone (unlike XFS_IOC_GETBMAP). */

Ok, it is.

> 		for (i = 0; i < fm->fm_extent_count; i++) {
> 			__u64 len = fm->fm_extents[i].fe_len & FIEMAP_LEN_MASK;
> 			__u64 fm_next = fm->fm_start + len;
> 			int hole = fm->fm_extents[i].fe_len & FIEMAP_LEN_HOLE;
> 			int unwr = fm->fm_extents[i].fe_len & FIEMAP_LEN_UNWRITTEN;
> 
> 			printf("%llu-%llu\t%llu-%llu\t%llu\t%s%s\n",
> 				fm->fm_start, fm_next - 1,
> 				hole ? 0 : fm->fm_extents[i].fe_start,
> 				hole ? 0 : fm->fm_extents[i].fe_start +
> 					   fm->fm_extents[i].fe_len - 1,
> 				len, hole ? "(hole) " : "",
> 				unwr ? "(unwritten) " : "");
> 
> 			/* get ready for printing next extent, or next ioctl */
> 			fm->fm_start = fm_next;

Ok, so the only way you can determine where you are in the file
is by adding up the length of each extent. What happens if the file
is changing underneath you e.g. someone punches out a hole
in teh file, or truncates and extends it again between ioctl()
calls?

Also, what happens if you ask for an offset/len that doesn't map to
any extent boundaries - are you truncating the extents returned to
teh off/len passed in?

xfs_bmap gets around this by finding out how many extents there are in the
file and allocating a buffer that big to hold all the extents so they
are gathered in a single atomic call (think sparse matrix files)....

> I'm not wedded to an ioctl interface, but it seems consistent with FIBMAP.
> I'm quite open to suggestions at this point, both in terms of how usable
> the fibmap data structures are by the caller, and if we need to add anything
> to make them more flexible for the future.

ioctl is fine by me. perhaps a version number in the structure header
would be handy so we can modify the interface easily in the future
without having to worry about breaking userspace....

> In terms of implementing this in the kernel, there was originally code for
> this during the development of the ext3 extent patches and it was done via
> a callback in the extent tree iterator so it is very efficient.  I believe
> it implements all that is needed to allow this interface to be mapped
> onto XFS_IOC_BMAP internally (or vice versa).

I wouldn't map the ioctls - I'd just write another interface to
xfs_getbmap(). That way we could eventually get rid of the XFS_IOC_BMAP
interface. is there any code yet?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Apr 2007 05:08:17 -0700 (PDT)
Received: from ppsw-9.csi.cam.ac.uk (ppsw-9.csi.cam.ac.uk [131.111.8.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3CC83fB024925
	for <xfs@oss.sgi.com>; Thu, 12 Apr 2007 05:08:04 -0700
In-Reply-To: <20070412110550.GM5967@schatzie.adilger.int>
References: <20070412110550.GM5967@schatzie.adilger.int>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <97211C89-1810-4B22-B2F4-9D206D43C1F6@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Thu, 12 Apr 2007 12:22:55 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Dilger <adilger@clusterfs.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

Hi Andreas,

On 12 Apr 2007, at 12:05, Andreas Dilger wrote:

> I'm interested in getting input for implementing an ioctl to  
> efficiently
> map file extents & holes (FIEMAP) instead of looping over FIBMAP a  
> billion
> times.  We already have customers with single files in the 10TB  
> range and
> we additionally need to get the mapping over the network so it  
> needs to
> be efficient in terms of how data is passed, and how easily it can be
> extracted from the filesystem.
>
> I had come up with a plan independently and was also steered toward
> XFS_IOC_GETBMAP* ioctls which are in fact very similar to my original
> plan, though I think the XFS structs used there are a bit bloated.
>
> There was also recent discussion about SEEK_HOLE and SEEK_DATA as
> implemented by Sun, but even if we could skip the holes we still might
> need to do millions of FIBMAPs to see how large files are allocated
> on disk.  Conversely, having filesystems implement an efficient FIBMAP
> ioctl (or ->fiemap() method) could in turn be leveraged for SEEK_HOLE
> and SEEK_DATA instead of doing looping over ->bmap() inside the kernel
> as I saw one patch.
>
>
> struct fibmap_extent {
> 	__u64 fe_start;			/* starting offset in bytes */
> 	__u64 fe_len;			/* length in bytes */
> }
>
> struct fibmap {
> 	struct fibmap_extent fm_start;	/* offset, length of desired  
> mapping */
> 	__u32 fm_extent_count;		/* number of extents in array */
> 	__u32 fm_flags;			/* flags (similar to XFS_IOC_GETBMAP) */
> 	__u64 unused;
> 	struct fibmap_extent fm_extents[0];
> }
>
> #define FIEMAP_LEN_MASK		0xff000000000000
> #define FIEMAP_LEN_HOLE     	0x01000000000000
> #define FIEMAP_LEN_UNWRITTEN	0x02000000000000

Sound good but I would add:

#define FIEMAP_LEN_NO_DIRECT_ACCESS

This would say that the offset on disk can move at any time or that  
the data is compressed or encrypted on disk thus the data is not  
useful for direct disk access.

On NTFS small files can be inside the inode and there direct access  
is not possible because the metadata on disk is protected with fixups  
which need to be removed when the inode is read into memory.  If you  
access the data directly on disk, you would see corrupt data on reads  
and cause corruption on writes...

Similarly both for compressed and encrypted files doing direct access  
to the on-disk data is totally nonsensical as you would see random  
junk on read and cause fatal data corruption on writes.

Also why are you not using 0xff00000000000000, i.e. two more zeroes  
at the end?  Seems unnecessary to drop an extra 8 bits of  
significance from the byte size...  May not matter today but it  
almost certainly will do in the future (just remember what people  
said about the 640k limit in MSDOS when it first came out!)...

Finally please make sure that the file system can return in one way  
or another errors for example when it fails to determine the extents  
because the system ran out of memory, there was an i/o error,  
whatever...  It may even be useful to be able to say "here is an  
extent of size X bytes but we do not know where it is on disk because  
there was an error determining this particular extent's on-disk  
location for some reason or other"...

> All offsets are in bytes to allow cases where filesystems are not  
> going

Excellent!

> block-aligned/sized allocations (e.g. tail packing).  The  
> fm_extents array
> returned contains the packed list of allocation extents for the file,
> including entries for holes (which have fe_start == 0, and a flag).

Why the fe_start == 0?  Surely just the flag is sufficient...  On  
NTFS it is perfectly valid to have fe_start == 0 and to have that not  
be sparse (normally the $Boot system file is stored in the first 8  
sectors of the volume)...

Best regards,

	Anton

> The ->fm_extents[] array includes all of the holes in addition to
> allocated extents because this avoids the need to return both the  
> logical
> and physical address for every extent and does not make processing any
> harder.
>
> One feature that XFS_IOC_GETBMAPX has that may be desirable is the
> ability to return unwritten extent information.  In order to do  
> this XFS
> required expanding the per-extent struct from 32 to 48 bytes per  
> extent,
> but I'd rather limit a single extent to e.g. 2^56 bytes (oh, what  
> hardship)
> and keep 8 bytes or so for input/output flags per extent (would  
> need to
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
> 		rc = ioctl(fd, FIEMAP, fm);
> 		if (rc)
> 			break;
>
> 		/* kernel filled in fm_extents[] array, set fm_extent_count
> 		 * to be actual number of extents returned, leaves fm_start
> 		 * alone (unlike XFS_IOC_GETBMAP). */
>
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
> 		}
> 	}
>
> I'm not wedded to an ioctl interface, but it seems consistent with  
> FIBMAP.
> I'm quite open to suggestions at this point, both in terms of how  
> usable
> the fibmap data structures are by the caller, and if we need to add  
> anything
> to make them more flexible for the future.
>
> In terms of implementing this in the kernel, there was originally  
> code for
> this during the development of the ext3 extent patches and it was  
> done via
> a callback in the extent tree iterator so it is very efficient.  I  
> believe
> it implements all that is needed to allow this interface to be mapped
> onto XFS_IOC_BMAP internally (or vice versa).  Even for block-mapped
> filesystems, they can at least improve over the ->bmap() case by  
> skipping
> holes in files that cover [dt]indirect blocks (saving thousands of  
> calls).
>
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

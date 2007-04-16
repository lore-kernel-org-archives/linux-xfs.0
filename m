Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Apr 2007 00:59:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3G7xhfB010633
	for <xfs@oss.sgi.com>; Mon, 16 Apr 2007 00:59:46 -0700
Date: Mon, 16 Apr 2007 18:01:17 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <31588A06562720FE1E0F93DF@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070412110550.GM5967@schatzie.adilger.int>
References: <20070412110550.GM5967@schatzie.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: hch@infradead.org

Hi Andreas,

--On 12 April 2007 5:05:50 AM -0600 Andreas Dilger <adilger@clusterfs.com> wrote:

> I'm interested in getting input for implementing an ioctl to efficiently
> map file extents & holes (FIEMAP) instead of looping over FIBMAP a billion
> times.
...
>
> I had come up with a plan independently and was also steered toward
> XFS_IOC_GETBMAP* ioctls which are in fact very similar to my original
> plan, though I think the XFS structs used there are a bit bloated.

They certainly seem to be (combining entries and header).


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
># define FIEMAP_LEN_MASK		0xff000000000000
># define FIEMAP_LEN_HOLE     	0x01000000000000
># define FIEMAP_LEN_UNWRITTEN	0x02000000000000
>
> All offsets are in bytes to allow cases where filesystems are not going
> block-aligned/sized allocations (e.g. tail packing).  The fm_extents array
> returned contains the packed list of allocation extents for the file,
> including entries for holes (which have fe_start == 0, and a flag).
>
> The ->fm_extents[] array includes all of the holes in addition to
> allocated extents because this avoids the need to return both the logical
> and physical address for every extent and does not make processing any
> harder.

Well, that's what stood out for me. I was wondering where the "fe_block" field
had gone - the "physical address".
So is your "fe_start; /* starting offset */" actually the disk location
(not a logical file offset)
_except_ in the header (fibmap) where it is the desired logical offset.
Okay, looking at your example use below that's what it looks like.
And when you refer to fm_start below, you mean fm_start.fe_start?
Sorry, I realise this is just an approximation but this part confused me.
So you get rid of all the logical file offsets in the extents because we
report holes explicitly (and we know everything is contiguous if you
include the holes).

--Tim

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

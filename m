Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Apr 2007 16:03:59 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3IN3sfB029878
	for <xfs@oss.sgi.com>; Wed, 18 Apr 2007 16:03:56 -0700
Date: Wed, 18 Apr 2007 17:03:50 -0600
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20070418230349.GJ5967@schatzie.adilger.int>
References: <20070412110550.GM5967@schatzie.adilger.int> <31588A06562720FE1E0F93DF@timothy-shimmins-power-mac-g5.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31588A06562720FE1E0F93DF@timothy-shimmins-power-mac-g5.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On Apr 16, 2007  18:01 +1000, Timothy Shimmin wrote:
> --On 12 April 2007 5:05:50 AM -0600 Andreas Dilger <adilger@clusterfs.com> 
> wrote:
> >struct fiemap_extent {
> >	__u64 fe_start;			/* starting offset in bytes */
> >	__u64 fe_len;			/* length in bytes */
> >}
> >
> >struct fiemap {
> >	struct fiemap_extent fm_start;	/* offset, length of desired mapping 
> >	*/
> >	__u32 fm_extent_count;		/* number of extents in array */
> >	__u32 fm_flags;			/* flags (similar to 
> >	XFS_IOC_GETBMAP) */
> >	__u64 unused;
> >	struct fiemap_extent fm_extents[0];
> >}
> >
> ># define FIEMAP_LEN_MASK		0xff000000000000
> ># define FIEMAP_LEN_HOLE     	0x01000000000000
> ># define FIEMAP_LEN_UNWRITTEN	0x02000000000000
> >
> >All offsets are in bytes to allow cases where filesystems are not going
> >block-aligned/sized allocations (e.g. tail packing).  The fm_extents array
> >returned contains the packed list of allocation extents for the file,
> >including entries for holes (which have fe_start == 0, and a flag).
> >
> >The ->fm_extents[] array includes all of the holes in addition to
> >allocated extents because this avoids the need to return both the logical
> >and physical address for every extent and does not make processing any
> >harder.
> 
> Well, that's what stood out for me. I was wondering where the "fe_block" 
> field had gone - the "physical address".
> So is your "fe_start; /* starting offset */" actually the disk location
> (not a logical file offset)
> _except_ in the header (fiemap) where it is the desired logical offset.

Correct.  The fm_extent in the request contains the logical start offset
and length in bytes of the requested fiemap region.  In the returned header
it represents the logical start offset of the extent that contained the
requested start offset, and the logical length of all the returned extents.
I haven't decided whether the returned length should be until EOF, or have
the "virtual hole" at the end of the file.  I think EOF makes more sense.

The fe_start + fe_len in the fm_extents represent the physical location on
the block device for that extent.  fm_extent[i].fe_start (per Anton) is
undefined if FIEMAP_LEN_HOLE is set, and .fe_len is the length of the hole.

> Okay, looking at your example use below that's what it looks like.
> And when you refer to fm_start below, you mean fm_start.fe_start?
> Sorry, I realise this is just an approximation but this part confused me.

Right, I'll write up a new RFC based on feedback here, and correcting the
various errors in the original proposal.

> So you get rid of all the logical file offsets in the extents because we
> report holes explicitly (and we know everything is contiguous if you
> include the holes).

Correct.  It saves space in the common case.

> >Caller works something like:
> >
> >	char buf[4096];
> >	struct fiemap *fm = (struct fiemap *)buf;
> >	int count = (sizeof(buf) - sizeof(*fm)) / sizeof(fm_extent);
> >	
> >	fm->fm_start.fe_start = 0; /* start of file */
> >	fm->fm_start.fe_len = -1;	/* end of file */
> >	fm->fm_extent_count = count; /* max extents in fm_extents[] array */
> >	fm->fm_flags = 0;		/* maybe "no DMAPI", etc like XFS */
> >
> >	fd = open(path, O_RDONLY);
> >	printf("logical\t\tphysical\t\tbytes\n");
> >
> >	/* The last entry will have less extents than the maximum */
> >	while (fm->fm_extent_count == count) {
> >		rc = ioctl(fd, FIEMAP, fm);
> >		if (rc)
> >			break;
> >
> >		/* kernel filled in fm_extents[] array, set fm_extent_count
> >		 * to be actual number of extents returned, leaves
> >		 * fm_start.fe_start alone (unlike XFS_IOC_GETBMAP). */
> >
> >		for (i = 0; i < fm->fm_extent_count; i++) {
> >			__u64 len = fm->fm_extents[i].fe_len & 
> >			FIEMAP_LEN_MASK;
> >			__u64 fm_next = fm->fm_start.fe_start + len;
> >			int hole = fm->fm_extents[i].fe_len & 
> >			FIEMAP_LEN_HOLE;
> >			int unwr = fm->fm_extents[i].fe_len & 
> >			FIEMAP_LEN_UNWRITTEN;
> >
> >			printf("%llu-%llu\t%llu-%llu\t%llu\t%s%s\n",
> >				fm->fm_start.fe_start, fm_next - 1,
> >				hole ? 0 : fm->fm_extents[i].fe_start,
> >				hole ? 0 : fm->fm_extents[i].fe_start +
> >					   fm->fm_extents[i].fe_len - 1,
> >				len, hole ? "(hole) " : "",
> >				unwr ? "(unwritten) " : "");
> >
> >			/* get ready for printing next extent, or next ioctl 
> >			*/
> >			fm->fm_start.fe_start = fm_next;
> >		}
> >	}
> >

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

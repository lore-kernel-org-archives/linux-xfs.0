Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 13:14:20 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [74.0.229.162])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9TKEETK003878
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 13:14:15 -0700
Date: Mon, 29 Oct 2007 13:45:07 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20071029194507.GA8578@webber.adilger.int>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1FA8E92B-954D-4624-A089-80D4AA7399FD@cam.ac.uk> <20070502000654.GK77450368@melbourne.sgi.com> <8464EA47-03AC-4162-A2D0-683517568640@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8464EA47-03AC-4162-A2D0-683517568640@cam.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, Anton Altaparmakov <aia21@cam.ac.uk>, Mike Waychison <mikew@google.com>

By request on #linuxfs, here is the FIEMAP spec that we used to implement
the FIEMAP support for ext4.  There was an ext4 patch posted on August 29
to linux-ext4 entitled "[PATCH] FIEMAP ioctl".   I've asked Kalpak to post
an updated version of that patch along with the changes to the "filefrag"
tool to use FIEMAP.

======================== FIEMAP_1.0.txt ==================================

File Mapping Interface

18 June 2007

Andreas Dilger, Kalpak Shah

Introduction

This document covers the user interface and internal implementation of
an efficient fragmentation reporting tool. This will include addition
of a FIEMAP ioctl to fetch extents and changes to filefrag to use this
ioctl. The main objective of this tool is to efficiently and easily allow
inspection of the disk layout of one or more files without requiring
user access to the underlying storage device(s).

1 Requirements

The tool should be efficient in its use of resources, even for large
files. The FIBMAP ioctl is not suitable for use on large files,
as this can result in millions or even billions of ioctls to get the
mapping information for a single file. It should be possible to get the
information about an arbitrary-sized extent in a single call, and the
kernel component and user tool should efficiently use this information.

The user interface should be simple, and the output should be easily
understood - by default the filename(s), a count of extents (for each
file), and the optimal number of extents for a file with the given
striping parameters. The user interface will be "filefrag [options]
{filename ...}" and will allow retrieving the fragmentation information
for one or more files specified on the command-line. The output will be
of the form:

/path/to/file1: extents=2 optimal=1

/path/to/file2: extents=10 optimal=4

..........

2 Functional specification

The FIEMAP ioctl (FIle Extent MAP) is similar to the existing FIBMAP
ioctl block device ioctl used for mapping an individual logical block
address in a file to a physical block address in the block device. The
FIEMAP ioctl will return the logical to physical mapping for the extent
that contains the specified logical byte address.

struct fiemap_extent {
    __u64 fe_offset;/* offset in bytes for the start of the extent */
    __u64 fe_length;/* length in bytes for the extent */
    __u32 fe_flags; /* returned FIEMAP_EXTENT_* flags for the extent */
    __u32 fe_lun;   /* logical device number for extent(starting at 0)*/
};



struct fiemap {
    __u64 fm_start;         /* logical byte offset (in/out) */
    __u64 fm_length;        /* logical length of map (in/out) */
    __u32 fm_flags;         /* FIEMAP_FLAG_* flags (in/out) */
    __u32 fm_extent_count;  /* extents in fm_extents (in/out) */
    __u64 fm_unused;

    struct fiemap_extent fm_extents[0];  
};



In the ioctl request, the fiemap struct is initialized with the desired
mapping information.

	fiemap.fm_start = {desired start byte offset, 0 if whole file};
	fiemap.fm_length = {length of mapping in bytes, ~0ULL if whole file}
	fiemap.fm_extent_count = {number of fiemap_extents in fm_extents array};
	fiemap.fm_flags = {flags from FIEMPA_FLAG_* array, if needed};

	ioctl(fd, FIEMAP, &fiemap);
	{verify fiemap flags are understood }

	for (i = 0; i < fiemap.fm_extent_count; i++) {
		{ process extent fiemap.fm_extents[i]};
	}


The logic for the filefrag would be similar to above. The size of the
extent array will be extrapolated from the filesize and multiple ioctls
of increasing extent count may be called for very large files. filefrag
can easily call the FIEMAP ioctls repeatedly using the end of the last
extent as the start offset for the next ioctl:

	fm_start = fm_extents[fm_extent_count - 1].fe_offset +
                        fm_extents[fm_extent_count - 1].fe_length + 1;

We do this until we find an extent with FIEMAP_EXTENT_LAST flag set. We
will also need to re-initialise the fiemap flags, fm_extent_count, fm_end.

The FIEMAP_FLAG_* values are specified below. If FIEMAP_FLAG_NO_EXTENTS is
given then the fm_extents array is not filled, and only fm_extent_count is
returned with the total number of extents in the file. Any new flags that
introduce and/or require an incompatible behaviour in an application or
in the kernel need to be in the range specified by FIEMAP_FLAG_INCOMPAT
(e.g. FIEMAP_FLAG_SYNC and FIEMAP_FLAG_NO_EXTENTS would fall into that
range if they were not part of the original specification). This is
currently only for future use. If it turns out that FIEMAP_FLAG_INCOMPAT
is not large enough then it is possible to use the last INCOMPAT flag
0x01000000 to incidate that more of the flag range contains incompatible
flags.

#define FIEMAP_FLAG_SYNC        0x00000001 /* sync file data before map */
#define FIEMAP_FLAG_HSM_READ    0x00000002 /* get data from HSM before map */
#define FIEMAP_FLAG_NUM_EXTENTS 0x00000004 /* return only number of extents */
#define FIEMAP_FLAG_INCOMPAT    0xff000000 /* error for unknown flags in here */

The returned data from the FIEMAP ioctl is an array of fiemap_extent
elements, one per extent in the file. The first extent will contain the
byte specified by fm_start and the last extent will contain the byte
specified by fm_start + fm_len, unless there are more than the passed-in
fm_extent_count extents in the file, or this is beyond the EOF in which
case the last extent will be marked with FIEMAP_EXTENT_LAST. Each extent
returned has a set of flags associated with it that provide additional
information about the extent. Not all filesystems will support all flags.

FIEMAP_FLAG_NUM_EXTENTS will return only the number of extents used by
the file. It will be used by default for filefrag since the specific
extent information is not required in many cases.

#define FIEMAP_EXTENT_HOLE      0x00000001 /* has no data or space allocation */
#define FIEMAP_EXTENT_UNWRITTEN 0x00000002 /* space allocated, but no data */
#define FIEMAP_EXTENT_UNMAPPED  0x00000004 /* has data but no space allocated */
#define FIEMAP_EXTENT_ERROR     0x00000008 /* map error, errno in fe_offset. */
#define FIEMAP_EXTENT_NO_DIRECT 0x00000010 /* cannot access data directly */
#define FIEMAP_EXTENT_LAST      0x00000020 /* last extent in the file */
#define FIEMAP_EXTENT_DELALLOC  0x00000040 /* has data but not yet written */
#define FIEMAP_EXTENT_SECONDARY 0x00000080 /* data in secondary storage */
#define FIEMAP_EXTENT_EOF       0x00000100 /* fm_start + fm_len beyond EOF */
#define FIEMAP_EXTENT_UNKNOWN   0x00000200 /* in use but location is unknown */


FIEMAP_EXTENT_NO_DIRECT means data cannot be directly accessed (maybe
encrypted, compressed, etc.)

FIEMAP_EXTENT_ERROR and FIEMAP_EXTENT_DELALLOC flags should always
be returned with FIEMAP_EXTENT_UNMAPPED also set. So some flags are a
superset of other flags. FIEMAP_EXTENT_SECONDARY may optionally include
FIEMAP_EXTENT_UNMAPPED.

Inside ext4, this can be implemented for extent-mapped files by
calling something similar to the existing ext4_ext_ioctl() for
EXT4_IOC_GET_EXTENTS but with a different callback function. Or the
ext4_fiemap() function can be called directly from the ioctl code if
the latest extents patches do not have ext4_ext_ioctl().

3 Use cases

1) Files containing holes including an all-hole file.

2) File having an extent which is not yet allocated.

3) Proper working with fm_start + fm_len beyond EOF.

4) Test proper reporting of preallocated extents.

5) Have non-zero fm_start and non-~0ULL fm_end. This can be 
   tested by having fm_count = 1 and forcing many ioctls.

6) If there is an error mapping an in-between extent then the 
   later extents should be returned.

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

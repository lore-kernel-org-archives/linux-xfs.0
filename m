Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Apr 2007 21:02:07 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3D420fB028758
	for <xfs@oss.sgi.com>; Thu, 12 Apr 2007 21:02:01 -0700
Date: Thu, 12 Apr 2007 22:01:56 -0600
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20070413040156.GU5967@schatzie.adilger.int>
References: <20070412110550.GM5967@schatzie.adilger.int> <97211C89-1810-4B22-B2F4-9D206D43C1F6@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97211C89-1810-4B22-B2F4-9D206D43C1F6@cam.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.orglinux-ext4@vger.kernel.org

On Apr 12, 2007  12:22 +0100, Anton Altaparmakov wrote:
> On 12 Apr 2007, at 12:05, Andreas Dilger wrote:
> >I'm interested in getting input for implementing an ioctl to  
> >efficiently map file extents & holes (FIEMAP) instead of looping
> >over FIBMAP a billion times.  We already have customers with single
> >files in the 10TB range and we additionally need to get the mapping
> >over the network so it needs to be efficient in terms of how data
> >is passed, and how easily it can be extracted from the filesystem.
> >
> >struct fibmap_extent {
> >	__u64 fe_start;			/* starting offset in bytes */
> >	__u64 fe_len;			/* length in bytes */
> >}
> >
> >struct fibmap {
> >	struct fibmap_extent fm_start;	/* offset, length of desired mapping */
> >	__u32 fm_extent_count;		/* number of extents in array */
> >	__u32 fm_flags;			/* flags for input request */
> >	XFS_IOC_GETBMAP) */
> >	__u64 unused;
> >	struct fibmap_extent fm_extents[0];
> >}
> >
> >#define FIEMAP_LEN_MASK		0xff000000000000
> >#define FIEMAP_LEN_HOLE     	0x01000000000000
> >#define FIEMAP_LEN_UNWRITTEN	0x02000000000000
> 
> Sound good but I would add:
> 
> #define FIEMAP_LEN_NO_DIRECT_ACCESS
> 
> This would say that the offset on disk can move at any time or that  
> the data is compressed or encrypted on disk thus the data is not  
> useful for direct disk access.

This makes sense.  Even for Reiserfs the same is true with packed tails,
and I believe if FIBMAP is called on a tail it will migrate the tail into
a block because this is might be a sign that the file is a kernel that
LILO wants to boot.

I'd rather not have any such feature in FIEMAP, and just return the
on-disk allocation for the file, so NO_DIRECT_ACCESS is fine with me.
My main reason for FIEMAP is being able to investigate allocation patterns
of files.

By no means is my flag list exhaustive, just the ones that I thought would
be needed to implement this for ext4 and Lustre.

> Also why are you not using 0xff00000000000000, i.e. two more zeroes  
> at the end?  Seems unnecessary to drop an extra 8 bits of  
> significance from the byte size...

It was actually just a typo (this was the first time I'd written the
structs and flags down, it is just at the discussion stage).  I'd meant
for it to be 2^56 bytes for the file size as I wrote later in the email.
That said, I think that 2^48 bytes is probably sufficient for most uses,
so that we get 16 bits for flags.  As it is this email already discusses
5 flags, and that would give little room for expansion in the future.

Remember, this is the mapping for a single file (which can't practially
be beyond 2^64 bytes as yet) so it wouldn't be hard for the filesystem to
return a few separate extents which are actually contiguous (assuming that
there will actually be files in filesystems with > 2^48 bytes of contiguous
space).  Since the API is that it will return the extent that contains the
requested "start" byte, the kernel will be able to detect this case also,
since it won't be able to specify a length for the extent that contains the
start byte.

At most we'd have to call the ioctl() 65536 times for a completely
contiguous 2^64 byte file if the buffer was only large enough for a
single extent.  In reality, I expect any file to have some discontinuities
and the buffer to be large enough for a thousand or more entries so the
corner case is not very bad.

> Finally please make sure that the file system can return in one way  
> or another errors for example when it fails to determine the extents  
> because the system ran out of memory, there was an i/o error,  
> whatever...  It may even be useful to be able to say "here is an  
> extent of size X bytes but we do not know where it is on disk because  
> there was an error determining this particular extent's on-disk  
> location for some reason or other"...

Yes, that makes sense also, something like FIEMAP_LEN_UNKNOWN, and
FIEMAP_LEN_ERROR.  Consider FIEMAP on a file that was migrated
to tape and currently has no blocks allocated in the filesystem.  We
want to return some indication that there is actual file data and not
just a hole, but at the same time we don't want this to actually return
the file from tape just to generate block mappings for it.

This concept is also present in XFS_IOC_GETBMAPX - BMV_IF_NO_DMAPI_READ,
but this needs to be specified on input to prevent the file being mapped
and I'd rather the opposite (not getting file from tape) be the default,
by principle of least surprise.


> >block-aligned/sized allocations (e.g. tail packing).  The  
> >fm_extents array
> >returned contains the packed list of allocation extents for the file,
> >including entries for holes (which have fe_start == 0, and a flag).
> 
> Why the fe_start == 0?  Surely just the flag is sufficient...  On  
> NTFS it is perfectly valid to have fe_start == 0 and to have that not  
> be sparse (normally the $Boot system file is stored in the first 8  
> sectors of the volume)...

I thought fe_start = 0 was pretty standard for a hole.  It should be
something and I'd rather 0 than anything else.  The _HOLE flag is enough
as you say though.

PS - I'd thought about adding you to the CC list for this, because I know
     you've had opinions on FIBMAP in the past, but I didn't have
     your email handy and it was late, and I know you saw the NTFS kmap
     patch on fsdevel so I figured you would see this too...
     Thanks for your input.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

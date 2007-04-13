Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Apr 2007 03:15:12 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3DAF7fB007394
	for <xfs@oss.sgi.com>; Fri, 13 Apr 2007 03:15:09 -0700
Date: Fri, 13 Apr 2007 11:15:07 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20070413101507.GA11406@infradead.org>
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
> 
> All offsets are in bytes to allow cases where filesystems are not going
> block-aligned/sized allocations (e.g. tail packing).  The fm_extents array
> returned contains the packed list of allocation extents for the file,
> including entries for holes (which have fe_start == 0, and a flag).

> One feature that XFS_IOC_GETBMAPX has that may be desirable is the
> ability to return unwritten extent information.  In order to do this XFS
> required expanding the per-extent struct from 32 to 48 bytes per extent,
> but I'd rather limit a single extent to e.g. 2^56 bytes (oh, what hardship)
> and keep 8 bytes or so for input/output flags per extent (would need to
> be masked before use).

I'd be much happier to have the separate per-extent flags value.
For one thing this allows much nicer representations of unwritten
extents or holes without taking away bits from the len value.  It also
allows to make interesting use of this in the future, e.g. telling
about an offline exttent for use in HSM applications.  Also for
this kernel<->user interface the wasted space shouldn't matter too
much - if you want to pass the above condensed structure over the
wire in lustre that shouldn't a problem, you'd have to convert
to an endian-neutral on the wire format anyway.  Not doing the
masking also make the interface quite a bit simpler to use.

One addition freature from the XFS getbmapx interface we should
provide is the ability to query layout of xattrs.  While other
filesystems might not have the exact xattr fork XFS has it fits
nicely into the interface.  Especially when we have Anton's suggested
flag for inline data.

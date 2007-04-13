Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Apr 2007 04:39:27 -0700 (PDT)
Received: from ppsw-3.csi.cam.ac.uk (ppsw-3.csi.cam.ac.uk [131.111.8.133])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3DBdIfB026056
	for <xfs@oss.sgi.com>; Fri, 13 Apr 2007 04:39:20 -0700
In-Reply-To: <20070413101507.GA11406@infradead.org>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070413101507.GA11406@infradead.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <37B026AB-60FA-4595-B2B1-F57BB023D91C@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Fri, 13 Apr 2007 12:38:58 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 13 Apr 2007, at 11:15, Christoph Hellwig wrote:
> On Thu, Apr 12, 2007 at 05:05:50AM -0600, Andreas Dilger wrote:
>> struct fibmap_extent {
>> 	__u64 fe_start;			/* starting offset in bytes */
>> 	__u64 fe_len;			/* length in bytes */
>> }
>>
>> struct fibmap {
>> 	struct fibmap_extent fm_start;	/* offset, length of desired  
>> mapping */
>> 	__u32 fm_extent_count;		/* number of extents in array */
>> 	__u32 fm_flags;			/* flags (similar to XFS_IOC_GETBMAP) */
>> 	__u64 unused;
>> 	struct fibmap_extent fm_extents[0];
>> }
>>
>> #define FIEMAP_LEN_MASK		0xff000000000000
>> #define FIEMAP_LEN_HOLE     	0x01000000000000
>> #define FIEMAP_LEN_UNWRITTEN	0x02000000000000
>>
>> All offsets are in bytes to allow cases where filesystems are not  
>> going
>> block-aligned/sized allocations (e.g. tail packing).  The  
>> fm_extents array
>> returned contains the packed list of allocation extents for the file,
>> including entries for holes (which have fe_start == 0, and a flag).
>
>> One feature that XFS_IOC_GETBMAPX has that may be desirable is the
>> ability to return unwritten extent information.  In order to do  
>> this XFS
>> required expanding the per-extent struct from 32 to 48 bytes per  
>> extent,
>> but I'd rather limit a single extent to e.g. 2^56 bytes (oh, what  
>> hardship)
>> and keep 8 bytes or so for input/output flags per extent (would  
>> need to
>> be masked before use).
>
> I'd be much happier to have the separate per-extent flags value.
> For one thing this allows much nicer representations of unwritten
> extents or holes without taking away bits from the len value.  It also
> allows to make interesting use of this in the future, e.g. telling
> about an offline exttent for use in HSM applications.  Also for
> this kernel<->user interface the wasted space shouldn't matter too
> much - if you want to pass the above condensed structure over the
> wire in lustre that shouldn't a problem, you'd have to convert
> to an endian-neutral on the wire format anyway.  Not doing the
> masking also make the interface quite a bit simpler to use.
>
> One addition freature from the XFS getbmapx interface we should
> provide is the ability to query layout of xattrs.  While other
> filesystems might not have the exact xattr fork XFS has it fits
> nicely into the interface.  Especially when we have Anton's suggested
> flag for inline data.

Would it not be better to allow people to get a file descriptor on  
the xattr fork and then just run the normal FIEMAP ioctl on that file  
descriptor?

I.e. "openat(base file descriptor, O_STREAM, streamname)" or O_XATTR  
or whatever...  An alternative API would be to provide a "getxattrfd 
()/fgetxattrfd()" call or similar that would instead of returning the  
value of an xattr return an fd to it.  Then you do not need to modify  
openat() at all...  Interface doesn't bother me, just some ideas...

And for XFS you would define a magic streamname or xattrname (or  
whatever you want to call it) of say  
"com.sgi.filesystem.xfs.xattrstream" (or .xattrfork) or something and  
then XFS would intercept that and know what to do with it...

Such an interface could then be used by NTFS named streams and other  
file systems providing such things...

(Yes I know I will now totally get flamed about named streams not  
being wanted in Linux and crap like that but that is exactly what you  
are asking for except you want to special case a particular stream  
using a flag instead of calling it for what it really is and once you  
start doing that you might as well allow full named streams...)

You can just see named streams as an alternative, non-atomic API to  
xattrs if you like, i.e. you can either use the atomic xattr API  
provided in Linux already or you can get a file descriptor to an  
xattr and then use the normal system calls to access it non- 
atomically thus you can use the FIEMAP ioctl also.  (-:

FWIW this two-API approach to xattrs/named streams is the direction  
OSX is heading towards also so it is not without precedent and  
Windows has had both APIs for many years.  And Solaris has the "openat 
(O_XATTR)" interface so that is not without precedent either.

Best regards,

	Anton

PS. to all flamers: I am going to delete any non-technical flames  
without replying so please do us all a favour and don't bother...   
Thanks.

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

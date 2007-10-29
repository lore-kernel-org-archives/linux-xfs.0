Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 15:17:08 -0700 (PDT)
Received: from agminet02.oracle.com (agminet02.oracle.com [141.146.126.229])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9TMH0nj018905
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 15:17:03 -0700
Received: from agminet01.oracle.com (agminet01.oracle.com [141.146.126.228])
	by agminet02.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l9TKw1rY028720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 15:58:02 -0500
Date: Mon, 29 Oct 2007 13:57:44 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20071029205744.GB28607@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1FA8E92B-954D-4624-A089-80D4AA7399FD@cam.ac.uk> <20070502000654.GK77450368@melbourne.sgi.com> <8464EA47-03AC-4162-A2D0-683517568640@cam.ac.uk> <20071029194507.GA8578@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029194507.GA8578@webber.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, Anton Altaparmakov <aia21@cam.ac.uk>, Mike Waychison <mikew@google.com>, ocfs2-devel@oss.oracle.com

Hi Andreas,

	Thanks for posting this. I believe that an interface such as FIEMAP
would be very useful to Ocfs2 as well. (I added ocfs2-devel to the e-mail)

My comments below are generally geared towards understanding the ioctl
interface.

On Mon, Oct 29, 2007 at 01:45:07PM -0600, Andreas Dilger wrote:

> 2 Functional specification
> 
> The FIEMAP ioctl (FIle Extent MAP) is similar to the existing FIBMAP
> ioctl block device ioctl used for mapping an individual logical block
> address in a file to a physical block address in the block device. The
> FIEMAP ioctl will return the logical to physical mapping for the extent
> that contains the specified logical byte address.
> 
> struct fiemap_extent {
>     __u64 fe_offset;/* offset in bytes for the start of the extent */

I'm a little bit confused by fe_offset. Is it a physical offset, or a
logical offset? The reason I ask is that your description above says "FIEMAP
ioctl will return the logical to physical mapping for the extent that
contains the specified logical byte address." Which seems to imply physical,
but your math to get to the next logical start in a very fragmented file,
implies that fe_offset is a logical offset:

       fm_start = fm_extents[fm_extent_count - 1].fe_offset +
                         fm_extents[fm_extent_count - 1].fe_length + 1; 


> The logic for the filefrag would be similar to above. The size of the
> extent array will be extrapolated from the filesize and multiple ioctls
> of increasing extent count may be called for very large files. filefrag
> can easily call the FIEMAP ioctls repeatedly using the end of the last
> extent as the start offset for the next ioctl:
> 
> 	fm_start = fm_extents[fm_extent_count - 1].fe_offset +
>                         fm_extents[fm_extent_count - 1].fe_length + 1;
> 
> We do this until we find an extent with FIEMAP_EXTENT_LAST flag set. We
> will also need to re-initialise the fiemap flags, fm_extent_count, fm_end.

I think you meant 'fm_length' instead of 'fm_end' there.


> The FIEMAP_FLAG_* values are specified below. If FIEMAP_FLAG_NO_EXTENTS is
> given then the fm_extents array is not filled, and only fm_extent_count is
> returned with the total number of extents in the file. Any new flags that
> introduce and/or require an incompatible behaviour in an application or
> in the kernel need to be in the range specified by FIEMAP_FLAG_INCOMPAT
> (e.g. FIEMAP_FLAG_SYNC and FIEMAP_FLAG_NO_EXTENTS would fall into that
> range if they were not part of the original specification). This is
> currently only for future use. If it turns out that FIEMAP_FLAG_INCOMPAT
> is not large enough then it is possible to use the last INCOMPAT flag
> 0x01000000 to incidate that more of the flag range contains incompatible
> flags.
> 
> #define FIEMAP_FLAG_SYNC        0x00000001 /* sync file data before map */
> #define FIEMAP_FLAG_HSM_READ    0x00000002 /* get data from HSM before map */
> #define FIEMAP_FLAG_NUM_EXTENTS 0x00000004 /* return only number of extents */
> #define FIEMAP_FLAG_INCOMPAT    0xff000000 /* error for unknown flags in here */
> 
> The returned data from the FIEMAP ioctl is an array of fiemap_extent
> elements, one per extent in the file. The first extent will contain the
> byte specified by fm_start and the last extent will contain the byte
> specified by fm_start + fm_len, unless there are more than the passed-in
> fm_extent_count extents in the file, or this is beyond the EOF in which
> case the last extent will be marked with FIEMAP_EXTENT_LAST. Each extent
> returned has a set of flags associated with it that provide additional
> information about the extent. Not all filesystems will support all flags.
> 
> FIEMAP_FLAG_NUM_EXTENTS will return only the number of extents used by
> the file. It will be used by default for filefrag since the specific
> extent information is not required in many cases.
> 
> #define FIEMAP_EXTENT_HOLE      0x00000001 /* has no data or space allocation */

Btw, I really like that holes are explicitely marked.


> #define FIEMAP_EXTENT_UNWRITTEN 0x00000002 /* space allocated, but no data */
> #define FIEMAP_EXTENT_UNMAPPED  0x00000004 /* has data but no space allocated */
> #define FIEMAP_EXTENT_ERROR     0x00000008 /* map error, errno in fe_offset. */
> #define FIEMAP_EXTENT_NO_DIRECT 0x00000010 /* cannot access data directly */
> #define FIEMAP_EXTENT_LAST      0x00000020 /* last extent in the file */
> #define FIEMAP_EXTENT_DELALLOC  0x00000040 /* has data but not yet written */
> #define FIEMAP_EXTENT_SECONDARY 0x00000080 /* data in secondary storage */
> #define FIEMAP_EXTENT_EOF       0x00000100 /* fm_start + fm_len beyond EOF */

Is "EOF" here considering "beyond i_size" or "beyond allocation"?


> #define FIEMAP_EXTENT_UNKNOWN   0x00000200 /* in use but location is unknown */
> 
> 
> FIEMAP_EXTENT_NO_DIRECT means data cannot be directly accessed (maybe
> encrypted, compressed, etc.)

Would it be valid to use FIEMAP_EXTENT_NO_DIRECT for marking in-inode data?
Btrfs, Ocfs2, and Gfs2 pack small amounts of user data directly in inode
blocks.

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com

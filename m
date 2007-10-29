Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 15:13:07 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [74.0.229.162])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9TMD0QY018048
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 15:13:01 -0700
Date: Mon, 29 Oct 2007 16:13:02 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20071029221302.GD3042@webber.adilger.int>
References: <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1FA8E92B-954D-4624-A089-80D4AA7399FD@cam.ac.uk> <20070502000654.GK77450368@melbourne.sgi.com> <8464EA47-03AC-4162-A2D0-683517568640@cam.ac.uk> <20071029194507.GA8578@webber.adilger.int> <20071029205744.GB28607@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029205744.GB28607@ca-server1.us.oracle.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, Anton Altaparmakov <aia21@cam.ac.uk>, Mike Waychison <mikew@google.com>, ocfs2-devel@oss.oracle.com

On Oct 29, 2007  13:57 -0700, Mark Fasheh wrote:
> 	Thanks for posting this. I believe that an interface such as FIEMAP
> would be very useful to Ocfs2 as well. (I added ocfs2-devel to the e-mail)

I tried to make it as Lustre-agnostic as possible...

> On Mon, Oct 29, 2007 at 01:45:07PM -0600, Andreas Dilger wrote:
> > The FIEMAP ioctl (FIle Extent MAP) is similar to the existing FIBMAP
> > ioctl block device ioctl used for mapping an individual logical block
> > address in a file to a physical block address in the block device. The
> > FIEMAP ioctl will return the logical to physical mapping for the extent
> > that contains the specified logical byte address.
> > 
> > struct fiemap_extent {
> >     __u64 fe_offset;/* offset in bytes for the start of the extent */
> 
> I'm a little bit confused by fe_offset. Is it a physical offset, or a
> logical offset? The reason I ask is that your description above says "FIEMAP
> ioctl will return the logical to physical mapping for the extent that
> contains the specified logical byte address." Which seems to imply physical,
> but your math to get to the next logical start in a very fragmented file,
> implies that fe_offset is a logical offset:
> 
>        fm_start = fm_extents[fm_extent_count - 1].fe_offset +
>                          fm_extents[fm_extent_count - 1].fe_length + 1; 

Note the distinction between "fe_offset" (which is a physical offset for
a single extent) and "fm_offset" (which is a logical offset for that file).

> > We do this until we find an extent with FIEMAP_EXTENT_LAST flag set. We
> > will also need to re-initialise the fiemap flags, fm_extent_count, fm_end.
> 
> I think you meant 'fm_length' instead of 'fm_end' there.

You're right, thanks.

> > #define FIEMAP_EXTENT_LAST      0x00000020 /* last extent in the file */
> > #define FIEMAP_EXTENT_EOF       0x00000100 /* fm_start + fm_len beyond EOF*/
> 
> Is "EOF" here considering "beyond i_size" or "beyond allocation"?

_EOF == beyond i_size.
_LAST == last extent in the file.

In most cases FIEMAP_EXTENT_EOF will be set at the same time as
FIEMAP_EXTENT_LAST, but in case of e.g. prealloc beyond i_size the 
EOF flag may be set on one or more earlier extents.

> > FIEMAP_EXTENT_NO_DIRECT means data cannot be directly accessed (maybe
> > encrypted, compressed, etc.)
> 
> Would it be valid to use FIEMAP_EXTENT_NO_DIRECT for marking in-inode data?
> Btrfs, Ocfs2, and Gfs2 pack small amounts of user data directly in inode
> blocks.

Hmm, but part of the issue would be how to request the extra data, and
what offset it would be given?  One could, for example, use negative
offsets to represent metadata or something, or add a FIEMAP_EXTENT_META
or similar, I hadn't given that much thought.  The other issue is that
I'd like to get the basics of the API in place before it gets too complex.
We can always add functionality with more FIEMAP_FLAG_* (whether in the
INCOMPAT range or not, depending on what is being done).

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

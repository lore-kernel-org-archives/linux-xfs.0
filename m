Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43778 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750719AbcI2RuU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 13:50:20 -0400
Date: Thu, 29 Sep 2016 10:49:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 42/63] xfs: add dedupe range vfs function
Message-ID: <20160929174952.GZ14092@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503148670.30303.7329267157997002433.stgit@birch.djwong.org>
 <20160929170359.GH4546@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160929170359.GH4546@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 10:03:59AM -0700, Christoph Hellwig wrote:
> > +/* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
> > +#define XFS_EXTENT_DATA_SAME	0
> > +#define XFS_EXTENT_DATA_DIFFERS	1
> > +
> > +/* from struct btrfs_ioctl_file_extent_same_info */
> > +struct xfs_extent_data_info {
> > +	__s64 fd;		/* in - destination file */
> > +	__u64 logical_offset;	/* in - start of extent in destination */
> > +	__u64 bytes_deduped;	/* out - total # of bytes we were able
> > +				 * to dedupe from this file */
> > +	/* status of this dedupe operation:
> > +	 * < 0 for error
> > +	 * == XFS_EXTENT_DATA_SAME if dedupe succeeds
> > +	 * == XFS_EXTENT_DATA_DIFFERS if data differs
> > +	 */
> > +	__s32 status;		/* out - see above description */
> > +	__u32 reserved;
> > +};
> > +
> > +/* from struct btrfs_ioctl_file_extent_same_args */
> > +struct xfs_extent_data {
> > +	__u64 logical_offset;	/* in - start of extent in source */
> > +	__u64 length;		/* in - length of extent */
> > +	__u16 dest_count;	/* in - total elements in info array */
> > +	__u16 reserved1;
> > +	__u32 reserved2;
> > +	struct xfs_extent_data_info info[0];
> > +};
> > +
> >  #define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
> >  #define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
> > +#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_extent_data)
> 
> Same as with the last patch: we use VFS defintions for these, no need
> to add duplicate and unused XFS versions.

Ok, I'll fix both patches.

--D

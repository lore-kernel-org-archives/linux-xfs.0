Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60072 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbcI2REA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 13:04:00 -0400
Date: Thu, 29 Sep 2016 10:03:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 42/63] xfs: add dedupe range vfs function
Message-ID: <20160929170359.GH4546@infradead.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503148670.30303.7329267157997002433.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147503148670.30303.7329267157997002433.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

> +/* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
> +#define XFS_EXTENT_DATA_SAME	0
> +#define XFS_EXTENT_DATA_DIFFERS	1
> +
> +/* from struct btrfs_ioctl_file_extent_same_info */
> +struct xfs_extent_data_info {
> +	__s64 fd;		/* in - destination file */
> +	__u64 logical_offset;	/* in - start of extent in destination */
> +	__u64 bytes_deduped;	/* out - total # of bytes we were able
> +				 * to dedupe from this file */
> +	/* status of this dedupe operation:
> +	 * < 0 for error
> +	 * == XFS_EXTENT_DATA_SAME if dedupe succeeds
> +	 * == XFS_EXTENT_DATA_DIFFERS if data differs
> +	 */
> +	__s32 status;		/* out - see above description */
> +	__u32 reserved;
> +};
> +
> +/* from struct btrfs_ioctl_file_extent_same_args */
> +struct xfs_extent_data {
> +	__u64 logical_offset;	/* in - start of extent in source */
> +	__u64 length;		/* in - length of extent */
> +	__u16 dest_count;	/* in - total elements in info array */
> +	__u16 reserved1;
> +	__u32 reserved2;
> +	struct xfs_extent_data_info info[0];
> +};
> +
>  #define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
>  #define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
> +#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_extent_data)

Same as with the last patch: we use VFS defintions for these, no need
to add duplicate and unused XFS versions.


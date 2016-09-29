Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60059 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbcI2RDD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 13:03:03 -0400
Date: Thu, 29 Sep 2016 10:03:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 41/63] xfs: add clone file and clone range vfs functions
Message-ID: <20160929170302.GG4546@infradead.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503148029.30303.17483529725356722703.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147503148029.30303.17483529725356722703.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

> +/* reflink ioctls; these MUST match the btrfs ioctl definitions */
> +/* from struct btrfs_ioctl_clone_range_args */
> +struct xfs_clone_args {
> +	__s64 src_fd;
> +	__u64 src_offset;
> +	__u64 src_length;
> +	__u64 dest_offset;
> +};
> +
> +#define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
> +#define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)

No need to add these since they are unused in favour of the VFS
definitions.

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60305 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbfHIXbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 19:31:49 -0400
Date: Sat, 10 Aug 2019 09:30:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v2 07/19] fs/xfs: Teach xfs to use new
 dax_layout_busy_page()
Message-ID: <20190809233037.GB7777@dread.disaster.area>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-8-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809225833.6657-8-ira.weiny@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: ira.weiny@intel.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org

On Fri, Aug 09, 2019 at 03:58:21PM -0700, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> dax_layout_busy_page() can now operate on a sub-range of the
> address_space provided.
> 
> Have xfs specify the sub range to dax_layout_busy_page()

Hmmm. I've got patches that change all these XFS interfaces to
support range locks. I'm not sure the way the ranges are passed here
is the best way to do it, and I suspect they aren't correct in some
cases, either....

> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ff3c1fae5357..f0de5486f6c1 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1042,10 +1042,16 @@ xfs_vn_setattr(
>  		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
>  		iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
>  
> -		error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
> -		if (error) {
> -			xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> -			return error;
> +		if (iattr->ia_size < inode->i_size) {
> +			loff_t                  off = iattr->ia_size;
> +			loff_t                  len = inode->i_size - iattr->ia_size;
> +
> +			error = xfs_break_layouts(inode, &iolock, off, len,
> +						  BREAK_UNMAP);
> +			if (error) {
> +				xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> +				return error;
> +			}

This isn't right - truncate up still needs to break the layout on
the last filesystem block of the file, and truncate down needs to
extend to "maximum file offset" because we remove all extents beyond
EOF on a truncate down.

i.e. when we use preallocation, the extent map extends beyond EOF,
and layout leases need to be able to extend beyond the current EOF
to allow the lease owner to do extending writes, extending truncate,
preallocation beyond EOF, etc safely without having to get a new
lease to cover the new region in the extended file...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

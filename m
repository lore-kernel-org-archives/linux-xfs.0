Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39592 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727012AbfHIXXZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 19:23:25 -0400
Date: Sat, 10 Aug 2019 09:22:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v2 08/19] fs/xfs: Fail truncate if page lease can't
 be broken
Message-ID: <20190809232209.GA7777@dread.disaster.area>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-9-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809225833.6657-9-ira.weiny@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: ira.weiny@intel.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org

On Fri, Aug 09, 2019 at 03:58:22PM -0700, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> If pages are under a lease fail the truncate operation.  We change the order of
> lease breaks to directly fail the operation if the lease exists.
> 
> Select EXPORT_BLOCK_OPS for FS_DAX to ensure that xfs_break_lease_layouts() is
> defined for FS_DAX as well as pNFS.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  fs/Kconfig        | 1 +
>  fs/xfs/xfs_file.c | 5 +++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 14cd4abdc143..c10b91f92528 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -48,6 +48,7 @@ config FS_DAX
>  	select DEV_PAGEMAP_OPS if (ZONE_DEVICE && !FS_DAX_LIMITED)
>  	select FS_IOMAP
>  	select DAX
> +	select EXPORTFS_BLOCK_OPS
>  	help
>  	  Direct Access (DAX) can be used on memory-backed block devices.
>  	  If the block device supports DAX and the filesystem supports DAX,

That looks wrong. If you require xfs_break_lease_layouts() outside
of pnfs context, then move the function in the XFS code base to a
file that is built in. It's only external dependency is on the
break_layout() function, and XFS already has other unconditional
direct calls to break_layout()...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

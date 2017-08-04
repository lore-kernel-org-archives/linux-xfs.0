Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:17140 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752614AbdHDXbo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2017 19:31:44 -0400
Date: Sat, 5 Aug 2017 09:31:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/5] fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
Message-ID: <20170804233140.GF21024@dastard>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150181369754.32119.7390149918955188408.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150181369754.32119.7390149918955188408.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: darrick.wong@oracle.com, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

On Thu, Aug 03, 2017 at 07:28:17PM -0700, Dan Williams wrote:
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index fe0f8f7f4bb7..46d8eb9e19fc 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1393,6 +1393,107 @@ xfs_zero_file_space(
>  
>  }
>  
> +/* Return 1 if hole detected, 0 if not, and < 0 if fail to determine */
> +STATIC int
> +xfs_file_has_holes(
> +	struct xfs_inode	*ip)
> +{

Why do we need this function?

We've just run xfs_alloc_file_space() across the entire range we
are sealing, so we've already guaranteed that it won't have holes
in it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42817 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753535AbcJKSnj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Oct 2016 14:43:39 -0400
Date: Tue, 11 Oct 2016 09:21:47 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 13/17] dax: dax_iomap_fault() needs to call iomap_end()
Message-ID: <20161011072147.GE6952@quack2.suse.cz>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475874544-24842-14-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475874544-24842-14-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Fri 07-10-16 15:09:00, Ross Zwisler wrote:
> Currently iomap_end() doesn't do anything for DAX page faults for both ext2
> and XFS.  ext2_iomap_end() just checks for a write underrun, and
> xfs_file_iomap_end() checks to see if it needs to finish a delayed
> allocation.  However, in the future iomap_end() calls might be needed to
> make sure we have balanced allocations, locks, etc.  So, add calls to
> iomap_end() with appropriate error handling to dax_iomap_fault().
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Jan Kara <jack@suse.cz>
...
> @@ -1239,6 +1253,17 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  		break;
>  	}
>  
> + finish_iomap:
> +	if (ops->iomap_end) {
> +		if (error) {
> +			/* keep previous error */
> +			ops->iomap_end(inode, pos, PAGE_SIZE, PAGE_SIZE, flags,
> +					&iomap);

I think for the error case we should set number of 'written' bytes to 0 to
tell fs to cancel what it has prepared. This is mostly cosmetic since the
only case where I can imagine this would matter is shared write fault and
in that case we have currently no error path but still it could bite us in
the future.

Other than that the patch looks good so you can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

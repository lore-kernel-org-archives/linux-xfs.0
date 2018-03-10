Return-Path: linux-xfs-owner@vger.kernel.org
Received: from verein.lst.de ([213.95.11.211]:44742 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751981AbeCJJvp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Mar 2018 04:51:45 -0500
Date: Sat, 10 Mar 2018 10:51:44 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 10/11] xfs: prepare xfs_break_layouts() for another
        layout type
Message-ID: <20180310095144.GB31604@lst.de>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com> <152066494277.40260.7360641938196726871.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152066494277.40260.7360641938196726871.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-kernel@vger.kernel.org

>  
> +int
> +xfs_break_layouts(
> +	struct inode		*inode,
> +	uint			*iolock,
> +	unsigned long		flags)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	uint			iolock_assert = 0;
> +	int			ret = 0;
> +
> +	if (flags & XFS_BREAK_REMOTE)
> +		iolock_assert |= XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL;
> +	if (flags & XFS_BREAK_MAPS)
> +		iolock_assert |= XFS_MMAPLOCK_EXCL;
> +
> +	ASSERT(xfs_isilocked(ip, iolock_assert));
> +
> +	if (flags & XFS_BREAK_REMOTE)
> +		ret = xfs_break_leased_layouts(inode, iolock);
> +	return ret;

This just looks weird as hell.  We already pass in what to drop/reacquire
in the iolock argument.  I don't think we need another argument controlled
by the same callers to assert it.

> @@ -768,7 +790,7 @@ xfs_file_fallocate(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	long			error;
>  	enum xfs_prealloc_flags	flags = 0;
> -	uint			iolock = XFS_IOLOCK_EXCL;
> +	uint			iolock = XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL;

This is a behavior change that should not be in a patch titled
"prepare xfs_break_layouts() for another layout type" but in one
explicitly changing this and documenting why.

In summary:  I think this should be replaced with a patch that
allows xfs_break_layouts to be called with the mmap lock held, and
change the callers that want the mmap lock to pass it with a good
explanation, and we should get rid of the XFS_BREAK_* flags here.
(need to check the next patch if there is any other good reason for
them to be added later, though).

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48406 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750921AbeCPTEp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Mar 2018 15:04:45 -0400
Date: Fri, 16 Mar 2018 20:04:43 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 12/15] xfs: require mmap lock for xfs_break_layouts()
Message-ID: <20180316190443.GF3671@lst.de>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com> <152112914933.24669.5543317105428477772.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152112914933.24669.5543317105428477772.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-kernel@vger.kernel.org

On Thu, Mar 15, 2018 at 08:52:29AM -0700, Dan Williams wrote:
> In preparation for adding coordination between truncate operations and
> busy dax-pages, extend xfs_break_layouts() to assume it must be called
> with the mmap lock held. This locking scheme will be required for
> coordinating the break of 'dax layouts' (non-idle dax (ZONE_DEVICE)
> pages mapped into the file's address space).

This requirement wasn't really there in the last series, why do we
require it now?

As far as I can tell all we'd need is to just drop this assert:

> -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
> +				| XFS_MMAPLOCK_EXCL));

entirely.

>  	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
>  		xfs_iunlock(ip, *iolock);
>  		error = break_layout(inode, true);
> -		*iolock = XFS_IOLOCK_EXCL;
> +		*iolock &= ~XFS_IOLOCK_SHARED;
> +		*iolock |= XFS_IOLOCK_EXCL;
>  		xfs_ilock(ip, *iolock);

And take this one hunk from your patch.

To enable the DAX use case.

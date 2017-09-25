Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:49527 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966079AbdIZAJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2017 20:09:01 -0400
Date: Tue, 26 Sep 2017 09:29:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] xfs: protect S_DAX transitions in XFS write path
Message-ID: <20170925232945.GL10955@dastard>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-5-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170925231404.32723-5-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Mon, Sep 25, 2017 at 05:14:01PM -0600, Ross Zwisler wrote:
> In the current XFS write I/O path we check IS_DAX() in
> xfs_file_write_iter() to decide whether to do DAX I/O, direct I/O or
> buffered I/O.  This check is done without holding the XFS_IOLOCK, though,
> which means that if we allow S_DAX to be manipulated via the inode flag we
> can run into this race:
> 
> CPU 0                           CPU 1
> -----                           -----
> xfs_file_write_iter()
>   IS_DAX() << returns false
> 			    xfs_ioctl_setattr()
> 			      xfs_ioctl_setattr_dax_invalidate()
> 			       xfs_ilock(XFS_MMAPLOCK|XFS_IOLOCK)
> 			      sets S_DAX
> 			      releases XFS_MMAPLOCK and XFS_IOLOCK
>   xfs_file_buffered_aio_write()
>   does buffered I/O to DAX inode, death
> 
> Fix this by ensuring that we only check S_DAX when we hold the XFS_IOLOCK
> in the write path.

NACK. This breaks concurrent direct IO write semantics. We must not
take XFS_IOLOCK_EXCL on direct IO writes unless it is absolutely
necessary - there are lots of applications out there that rely on
these semantics for performance.

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

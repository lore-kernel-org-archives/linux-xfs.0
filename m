Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:55750 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726806AbfBEVsv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Feb 2019 16:48:51 -0500
Date: Wed, 6 Feb 2019 08:48:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ENSOPC on a 10% used disk
Message-ID: <20190205214847.GE14116@dastard>
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

Hi Avi,

On Wed, Oct 17, 2018 at 10:52:48AM +0300, Avi Kivity wrote:
> I have a user running a 1.7TB filesystem with ~10% usage (as shown
> by df), getting sporadic ENOSPC errors. The disk is mounted with
> inode64 and has a relatively small number of large files. The disk
> is a single-member RAID0 array, with 1MB chunk size. There are 32
> AGs. Running Linux 4.9.17.
> 
> 
> The write load consists of AIO/DIO writes, followed by unlinks of
> these files. The writes are non-size-changing (we truncate ahead)
> and we use XFS_IOC_FSSETXATTR/XFS_FLAG_EXTSIZE with a hint size of
> 32MB. The errors happen on commit logs, which have a target size of
> 32MB (but may exceed it a little).
> 
> 
> The errors are sporadic and after restarting the workload they go
> away for a few hours to a few days, but then return. During one of
> the crashes I used xfs_db to look at fragmentation and saw that most
> AGs had free extents of size categories up to 128-255, but a few had
> more. I tried xfs_fsr but it did not help.
> 
> 
> Is this a known issue? Would upgrading the kernel help?

Long time, I know, but Brian has just made me aware of this commit
from early 2018 that went into 4.16 that might be relevant and so I
thought it best to close the loop:

commit 6d8a45ce29c7d67cc4fc3016dc2a07660c62482a
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Fri Jan 19 17:47:36 2018 -0800

    xfs: don't screw up direct writes when freesp is fragmented
    
    xfs_bmap_btalloc is given a range of file offset blocks that must be
    allocated to some data/attr/cow fork.  If the fork has an extent size
    hint associated with it, the request will be enlarged on both ends to
    try to satisfy the alignment hint.  If free space is fragmentated,
    sometimes we can allocate some blocks but not enough to fulfill any of
    the requested range.  Since bmapi_allocate always trims the new extent
    mapping to match the originally requested range, this results in
    bmapi_write returning zero and no mapping.
    
    The consequences of this vary -- buffered writes will simply re-call
    bmapi_write until it can satisfy at least one block from the original
    request.  Direct IO overwrites notice nmaps == 0 and return -ENOSPC
    through the dio mechanism out to userspace with the weird result that
    writes fail even when we have enough space because the ENOSPC return
    overrides any partial write status.  For direct CoW writes the situation
    was disastrous because nobody notices us returning an invalid zero-length
    wrong-offset mapping to iomap and the write goes off into space.
    
    Therefore, if free space is so fragmented that we managed to allocate
    some space but not enough to map into even a single block of the
    original allocation request range, we should break the alignment hint in
    order to guarantee at least some forward progress for the direct write.
    If we return a short allocation to iomap_apply it'll call back about the
    remaining blocks.
    
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>

The spurious ENOSPC symptoms seem to match what you are seeing here
on your customer's 4.9 kernel, so it may be that this is the fix for
the ENOSPC problem that was reported. If this comes up again, then
perhaps it would be worth either upgrading the kernel to 4.16+ or
backporting this commit to see if it fixes the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

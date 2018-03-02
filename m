Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:31250 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934228AbeCBXPU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 18:15:20 -0500
Date: Sat, 3 Mar 2018 10:15:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180302231517.GY30854@dastard>
References: <20180301014144.28892-1-david@fromorbit.com>
 <20180302222031.GA30818@lst.de>
 <20180302225319.GW30854@dastard>
 <20180302230042.GA31370@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302230042.GA31370@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sat, Mar 03, 2018 at 12:00:42AM +0100, Christoph Hellwig wrote:
> Oh, and another thing:  I think you want to make this new code dependent
> on the block devie actually supporting REQ_FUA natively.  Otherwise
> you'll cause a flush for every emulated FUA write, which is only going
> make things worse, especially for ATA where FLUSH is not queued.  And
> last time I check libata still disabled FUA by default.

Yup, but the issue we have right now is that for pure RWF_DSYNC data
overwrites we are already doing a post-flush on every IO. It's being
issued as a separate zero-length IO, which is why REQ_FUA is faster
and results in lower overall IOPS.  The flush comes from this path:

generic_write_sync
  vfs_fsync_range
    xfs_file_fsync
      ....
        /*
         * If we only have a single device, and the log force about was
         * a no-op we might have to flush the data device cache here.
         * This can only happen for fdatasync/O_DSYNC if we were overwriting
         * an already allocated file and thus do not have any metadata to
         * commit.
         */
        if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
            mp->m_logdev_targp == mp->m_ddev_targp)
                xfs_blkdev_issue_flush(mp->m_ddev_targp);

So the end result of using REQ_FUA and not calling
generic_write_sync() on devices that don't support REQ_FUA is that
we get a post-flush attached to the IO rather than separately
issuing the post-flush via generic_write_sync().

Hence I think we end up with the same behaviour on devices that
don't support REQ_FUA, just via a slightly different mechanism.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

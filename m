Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:53928 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751792AbeBEWQi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 17:16:38 -0500
Date: Tue, 6 Feb 2018 09:17:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: rewrite the fdatasync optimization
Message-ID: <20180205221726.c2hdvaairki27gxf@destitution>
References: <20180205073933.17065-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180205073933.17065-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 05, 2018 at 08:39:33AM +0100, Christoph Hellwig wrote:
> Currently we need to the ilock over the log force in xfs_fsync so that we
> can protect ili_fsync_fields against incorrect manipulation.
> 
> But if instead we add new XFS_ILOG_VERSION pseudo log area similar to the
> timestamp one we can use that to just record the last dirty / fdatasync
> dirty lsn as long as the inode is pinned, and clear it when unpinning to
> avoid holding the ilock over I/O.

I thought that NFS requires the iversion changes to be made stable
at the same time as the data changes they correspond to is made
stable? i.e. NFS requires us to stabilise the on disk iversion field
during fdatasync.

As it is, I think this change XFS_ILOG_VERSION change is unnecessary
because Jeff Layton's changes to avoid iversion changes when the
value is not being sampled has been merged. Hence iversion won't be
changed on every write anymore unless NFS is in the picture and is
sampling iversion. 

IOWs, I think this may be needed for older kernels, but its not
clear that we need it for upstream kernels.

> This will drastically reduce latency on multithreaded workloads that
> mix writes with fsync calls.

The change to use ili_datasync_lsn is what reduces the latency
because the ilock is not held over the log force anymore. That's
useful and stands alone from the iversion modification so I
think, at minimum, this needs to be separated into two patches....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

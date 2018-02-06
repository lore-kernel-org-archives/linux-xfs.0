Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42178 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751835AbeBFHX6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Feb 2018 02:23:58 -0500
Date: Tue, 6 Feb 2018 08:23:56 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: rewrite the fdatasync optimization
Message-ID: <20180206072356.GB1649@lst.de>
References: <20180205073933.17065-1-hch@lst.de> <20180205221726.c2hdvaairki27gxf@destitution>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180205221726.c2hdvaairki27gxf@destitution>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>

On Tue, Feb 06, 2018 at 09:17:26AM +1100, Dave Chinner wrote:
> > Currently we need to the ilock over the log force in xfs_fsync so that we
> > can protect ili_fsync_fields against incorrect manipulation.
> > 
> > But if instead we add new XFS_ILOG_VERSION pseudo log area similar to the
> > timestamp one we can use that to just record the last dirty / fdatasync
> > dirty lsn as long as the inode is pinned, and clear it when unpinning to
> > avoid holding the ilock over I/O.
> 
> I thought that NFS requires the iversion changes to be made stable
> at the same time as the data changes they correspond to is made
> stable? i.e. NFS requires us to stabilise the on disk iversion field
> during fdatasync.

Yes, and this patch doesn't change that behavior.  The reason why the
new XFS_ILOG_VERSION flag is needed is to be able to check if
an fdatasync needs to flush out an inode log item.  This is done the
same way we did the XFS_ILOG_TIMESTAMP optimization, i.e. mark the
version updates as XFS_ILOG_VERSION, which gets propagatated to
XFS_ILOG_CORE when flushing (and we still commit every transaction
with a dirty inode), but we then use the ili_datasync_lsn field
that is only set if something that is not the timestamp or version
is logged to check in fdatasync if we need to force the log or not.

> 
> As it is, I think this change XFS_ILOG_VERSION change is unnecessary
> because Jeff Layton's changes to avoid iversion changes when the
> value is not being sampled has been merged. Hence iversion won't be
> changed on every write anymore unless NFS is in the picture and is
> sampling iversion. 

It still is needed.  We need to change i_version everytime we update
the timestamps (IFF it is queried in 4.15+), and we need to log every
transaction that updates timestamps and i_version.  But we do not need
to force out the log in fdatasync if only the timestamps and i_version
have changed.

So the only change in 4.15 is that for non-NFS workloads the change
might not matter that much, but the fundamental issue is the same.

> The change to use ili_datasync_lsn is what reduces the latency
> because the ilock is not held over the log force anymore. That's
> useful and stands alone from the iversion modification so I
> think, at minimum, this needs to be separated into two patches....

I can split it out.  XFS_ILOG_VERSION is the bit that makes our
old XFS_ILOG_TIMESTAMP optimization actually work on v5 file systems.

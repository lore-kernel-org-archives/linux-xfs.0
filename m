Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:16513 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752046AbeBHXR2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Feb 2018 18:17:28 -0500
Date: Fri, 9 Feb 2018 10:17:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: rewrite the fdatasync optimization
Message-ID: <20180208231725.GH20266@dastard>
References: <20180205073933.17065-1-hch@lst.de>
 <20180205221726.c2hdvaairki27gxf@destitution>
 <20180206072356.GB1649@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180206072356.GB1649@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>

On Tue, Feb 06, 2018 at 08:23:56AM +0100, Christoph Hellwig wrote:
> On Tue, Feb 06, 2018 at 09:17:26AM +1100, Dave Chinner wrote:
> > > Currently we need to the ilock over the log force in xfs_fsync so that we
> > > can protect ili_fsync_fields against incorrect manipulation.
> > > 
> > > But if instead we add new XFS_ILOG_VERSION pseudo log area similar to the
> > > timestamp one we can use that to just record the last dirty / fdatasync
> > > dirty lsn as long as the inode is pinned, and clear it when unpinning to
> > > avoid holding the ilock over I/O.
> > 
> > I thought that NFS requires the iversion changes to be made stable
> > at the same time as the data changes they correspond to is made
> > stable? i.e. NFS requires us to stabilise the on disk iversion field
> > during fdatasync.
> 
> Yes,

So you're agreeing with me that if iversion is changed, then
fdatasync needs to force the log.

> and this patch doesn't change that behavior.

I think it does.

> The reason why the
> new XFS_ILOG_VERSION flag is needed is to be able to check if
> an fdatasync needs to flush out an inode log item.

If we don't change iversion because it's not been queried, then in
the current code then XFS_ILOG_CORE will not be set and so the inode
remains only timestamp dirty and does not get flushed by fdatasync.
If we change iversion, then XFS_ILOG_CORE gets set, and the next
fdatasync will correctly flush the inode log item.

That's exactly the behaviour we need to meet the above NFS
requirements - the iversion change is associated with the new data
being written, not the timestamp change we are making as a result of
the data change.

If we look at your code now, when we change iversion we'll set
XFS_ILOG_VERSION and that will now behave identically to the
timestamp code w.r.t. fdatasync. i.e. we will *never* flush pure
iversion/timestamp changes on fdatasync.

That's not the behaviour NFS requires - we'll stabilise data but we
will not stabilise the iversion change that goes along with that
data change. Hence if we crash after fdatasync, there'll be new data
on disk and an old iversion....

So, AFAICT, this patch does change behviour and it breaks the
iversion semantics that the NFS server requires for data
modification.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

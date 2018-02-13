Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:6207 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965783AbeBMX3l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Feb 2018 18:29:41 -0500
Date: Wed, 14 Feb 2018 10:26:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: rewrite the fdatasync optimization
Message-ID: <20180213232640.GG6778@dastard>
References: <20180205073933.17065-1-hch@lst.de>
 <20180205221726.c2hdvaairki27gxf@destitution>
 <20180206072356.GB1649@lst.de>
 <20180208231725.GH20266@dastard>
 <20180213150402.GA15030@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180213150402.GA15030@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>

On Tue, Feb 13, 2018 at 04:04:02PM +0100, Christoph Hellwig wrote:
> On Fri, Feb 09, 2018 at 10:17:25AM +1100, Dave Chinner wrote:
> > > > I thought that NFS requires the iversion changes to be made stable
> > > > at the same time as the data changes they correspond to is made
> > > > stable? i.e. NFS requires us to stabilise the on disk iversion field
> > > > during fdatasync.
> > > 
> > > Yes,
> > 
> > So you're agreeing with me that if iversion is changed, then
> > fdatasync needs to force the log.
> 
> No, not at all.  fdatasync does simply not matter for NFS changetimes.
> NFS comes in through commit_inode_metadata, for which the fdatasync
> optimization is irrelevant.

Yes, for NFS server based IO.i

No, for local user IO to the local fs that is also exported via NFS.

> But even discounting NFS - anyone caring
> about timestamps persisting must use fsync and not fdatasync, in fact
> that is the whole point for fdatasyncs existence!

Yes, but timestamps are not the issue here - we know the behaviour
is correct.  The issue here is the iversion change counter
semantics be w.r.t. fdatasync, and you haven't established a case
fdatasync being able to avoid it.

> > > new XFS_ILOG_VERSION flag is needed is to be able to check if
> > > an fdatasync needs to flush out an inode log item.
> > 
> > If we don't change iversion because it's not been queried, then in
> > the current code then XFS_ILOG_CORE will not be set and so the inode
> > remains only timestamp dirty and does not get flushed by fdatasync.
> > If we change iversion, then XFS_ILOG_CORE gets set, and the next
> > fdatasync will correctly flush the inode log item.
> 
> Yes, if we talk about ili_fields.  Once we are deep down in the logging
> core XFS_ILOG_CORE of course gets set, see xfs_inode_item_format.
> 
> > If we look at your code now, when we change iversion we'll set
> > XFS_ILOG_VERSION and that will now behave identically to the
> > timestamp code w.r.t. fdatasync. i.e. we will *never* flush pure
> > iversion/timestamp changes on fdatasync.
> 
> And that is the correct behavior for fdatasync.

For *timestamps*, yes.

But iversion is a *data change notifier*, and hence it's directly
related to the data being stabilised during fdatasync.

e.g. In the case of a local write to an NFS exported filesystem, the
iversion needs to be made stable at the same time as the data via
fdatasync. That way if the server crashes after fdatasync, when it
comes back up all the NFS clients see that the data in that file
has changed via the recovered iversion change from the fdatasync.
If the iversion change is not written to the log during the
fdatasync, then none of the NFS clients will detect that the data
has actually changed after the server has recovered from the crash.

AIUI, this violates the semantics NFS requires from the iversion
field, and that means fdatasync needs to flush iversion changes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

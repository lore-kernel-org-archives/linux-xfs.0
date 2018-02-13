Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45484 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965037AbeBMPED (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Feb 2018 10:04:03 -0500
Date: Tue, 13 Feb 2018 16:04:02 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: rewrite the fdatasync optimization
Message-ID: <20180213150402.GA15030@lst.de>
References: <20180205073933.17065-1-hch@lst.de> <20180205221726.c2hdvaairki27gxf@destitution> <20180206072356.GB1649@lst.de> <20180208231725.GH20266@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180208231725.GH20266@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>

On Fri, Feb 09, 2018 at 10:17:25AM +1100, Dave Chinner wrote:
> > > I thought that NFS requires the iversion changes to be made stable
> > > at the same time as the data changes they correspond to is made
> > > stable? i.e. NFS requires us to stabilise the on disk iversion field
> > > during fdatasync.
> > 
> > Yes,
> 
> So you're agreeing with me that if iversion is changed, then
> fdatasync needs to force the log.

No, not at all.  fdatasync does simply not matter for NFS changetimes.
NFS comes in through commit_inode_metadata, for which the fdatasync
optimization is irrelevant.  But even discounting NFS - anyone caring
about timestamps persisting must use fsync and not fdatasync, in fact
that is the whole point for fdatasyncs existence!

> > new XFS_ILOG_VERSION flag is needed is to be able to check if
> > an fdatasync needs to flush out an inode log item.
> 
> If we don't change iversion because it's not been queried, then in
> the current code then XFS_ILOG_CORE will not be set and so the inode
> remains only timestamp dirty and does not get flushed by fdatasync.
> If we change iversion, then XFS_ILOG_CORE gets set, and the next
> fdatasync will correctly flush the inode log item.

Yes, if we talk about ili_fields.  Once we are deep down in the logging
core XFS_ILOG_CORE of course gets set, see xfs_inode_item_format.

> If we look at your code now, when we change iversion we'll set
> XFS_ILOG_VERSION and that will now behave identically to the
> timestamp code w.r.t. fdatasync. i.e. we will *never* flush pure
> iversion/timestamp changes on fdatasync.

And that is the correct behavior for fdatasync.

> That's not the behaviour NFS requires - we'll stabilise data but we
> will not stabilise the iversion change that goes along with that
> data change. Hence if we crash after fdatasync, there'll be new data
> on disk and an old iversion....
> 
> So, AFAICT, this patch does change behviour and it breaks the
> iversion semantics that the NFS server requires for data
> modification.

We still log exactly the same transaction to the log with this change.
The only difference is that a fdatasync will only force out the latest
transaction that has some non-timestamp, non-version change instead of
just the latests non-timestamp change.  For anyone using fsync-like
semantics like NFS nothing changes at all.

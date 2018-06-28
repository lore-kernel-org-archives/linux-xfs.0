Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:37373 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755019AbeF1XhY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jun 2018 19:37:24 -0400
Date: Fri, 29 Jun 2018 09:37:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/21] xfs: defer iput on certain inodes while scrub /
 repair are running
Message-ID: <20180628233721.GE2234@dastard>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986826018.3155.9241833069276452949.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152986826018.3155.9241833069276452949.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 24, 2018 at 12:24:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Destroying an incore inode sometimes requires some work to be done on
> the inode.  For example, post-EOF blocks on a non-PREALLOC inode are
> trimmed, and copy-on-write staging extents are freed.  This work is done
> in separate transactions, which is bad for scrub and repair because (a)
> we already have a transaction and can't nest them, and (b) if we've
> frozen the filesystem for scrub/repair work, that (regular) transaction
> allocation will block on the freeze.
> 
> Therefore, if we detect that work has to be done to destroy the incore
> inode, we'll just hang on to the reference until after the scrub is
> finished.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Darrick, I'll just repeat what we discussed on #xfs here so we have
in it the archive and everyone else knows why this is probably going
to be done differently.

I think we should move deferred inode inactivation processing into
the background reclaim radix tree walker rather than introduce a
special new "don't iput this inode yet" state. We're really only
trying to prevent the transactions that xfs_inactive() may run
throught iput() when the filesystem is frozen, and we already stop
background reclaim processing when the fs is frozen.

I've always intended that xfs_fs_destroy_inode() basically becomes a
no-op that just queues the inode for final inactivation, freeing and
reclaim - right now it ony does the reclaim work in the background.
I first proposed this back in ~2008 here:

http://xfs.org/index.php/Improving_inode_Caching#Inode_Unlink

At this point, it really only requires a new inode flag to indicate
that it has an inactivation pending - we set that if xfs_inactive
needs to do work before the inode can be reclaimed, and have a
separate per-ag work queue that walks the inode radix tree finding
reclaimable inodes that have the NEED_INACTIVATION inode flag set.
This way background reclaim doesn't get stuck on them.

This has benefits for many operations e.g. bulk processing of
inode inactivation and freeing either concurrently or after rm -rf
rather than at unlink syscall exit, VFS inode cache shrinker never
blocks on inactivation needing to run transactions, etc.

It also allows us to turn off inactivation on a per-AG basis,
meaning that when we are rebuilding an AG structure in repair (e.g.
the rmap btree) we can turn off inode inactivation and reclaim for
that AG rather than needing to freeze the entire filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

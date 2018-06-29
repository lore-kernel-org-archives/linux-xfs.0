Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38950 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751358AbeF2Otr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jun 2018 10:49:47 -0400
Date: Fri, 29 Jun 2018 07:49:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/21] xfs: defer iput on certain inodes while scrub /
 repair are running
Message-ID: <20180629144943.GL5711@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986826018.3155.9241833069276452949.stgit@magnolia>
 <20180628233721.GE2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628233721.GE2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 29, 2018 at 09:37:21AM +1000, Dave Chinner wrote:
> On Sun, Jun 24, 2018 at 12:24:20PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Destroying an incore inode sometimes requires some work to be done on
> > the inode.  For example, post-EOF blocks on a non-PREALLOC inode are
> > trimmed, and copy-on-write staging extents are freed.  This work is done
> > in separate transactions, which is bad for scrub and repair because (a)
> > we already have a transaction and can't nest them, and (b) if we've
> > frozen the filesystem for scrub/repair work, that (regular) transaction
> > allocation will block on the freeze.
> > 
> > Therefore, if we detect that work has to be done to destroy the incore
> > inode, we'll just hang on to the reference until after the scrub is
> > finished.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Darrick, I'll just repeat what we discussed on #xfs here so we have
> in it the archive and everyone else knows why this is probably going
> to be done differently.
> 
> I think we should move deferred inode inactivation processing into
> the background reclaim radix tree walker rather than introduce a
> special new "don't iput this inode yet" state. We're really only
> trying to prevent the transactions that xfs_inactive() may run
> throught iput() when the filesystem is frozen, and we already stop
> background reclaim processing when the fs is frozen.
> 
> I've always intended that xfs_fs_destroy_inode() basically becomes a
> no-op that just queues the inode for final inactivation, freeing and
> reclaim - right now it ony does the reclaim work in the background.
> I first proposed this back in ~2008 here:
> 
> http://xfs.org/index.php/Improving_inode_Caching#Inode_Unlink
> 
> At this point, it really only requires a new inode flag to indicate
> that it has an inactivation pending - we set that if xfs_inactive
> needs to do work before the inode can be reclaimed, and have a
> separate per-ag work queue that walks the inode radix tree finding
> reclaimable inodes that have the NEED_INACTIVATION inode flag set.
> This way background reclaim doesn't get stuck on them.
> 
> This has benefits for many operations e.g. bulk processing of
> inode inactivation and freeing either concurrently or after rm -rf
> rather than at unlink syscall exit, VFS inode cache shrinker never
> blocks on inactivation needing to run transactions, etc.
> 
> It also allows us to turn off inactivation on a per-AG basis,
> meaning that when we are rebuilding an AG structure in repair (e.g.
> the rmap btree) we can turn off inode inactivation and reclaim for
> that AG rather than needing to freeze the entire filesystem....

So although I've been off playing a JavaScript monkey this week, I should
note that the past few months I've also been slowly combing through all
the past online repair fuzz test output to see what's still majorly
broken.  I've noticed that the bmbt fuzzers have a particular failure
pattern that leads to shutdown, which is:

1) Fuzz a bmbt.br_blockcount value to a large enough value that we now
have a giant post-eof extent.

2) Mount filesystem.

3) Run xfs_scrub, which loads said inode, checks the bad bmbt, and tells
userspace it's broken...

4) ...and releases the inode.

5) Memory reclaim or someone comes along and calls xfs_inactive, which
says "Hey, nice post-EOF extent, let's trim that off!"  The extent free
code then freaks out "ZOMG, that extent is already free!"

6) Bam, filesystem shuts down.

7) xfs_scrub retries the bmbt scrub, but this time with IFLAG_REPAIR
set, but by now the fs has already gone down, and sadness.

I've had a thought lurking around in my head for a while that perhaps we
should have a second SKIP_INACTIVATION iflag that indicates that the
inode is corrupt and we should skip post-eof inactivation to avoid fs
shutdowns.  We'd still have to take the risk of cleaning out the cow
fork (because that metadata are never persisted) but we could at least
avoid a shutdown.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

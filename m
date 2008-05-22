Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 16:54:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4MNsBFg011647
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 16:54:28 -0700
Date: Fri, 23 May 2008 09:55:00 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] make inode reclaim wait for log I/O to complete
Message-ID: <20080522235500.GE173056135@sgi.com>
References: <482A77A9.5040806@sgi.com> <20080514064451.GF155679365@sgi.com> <4834EBB7.5010200@sgi.com> <20080522043150.GM173056135@sgi.com> <48352D8C.8090505@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48352D8C.8090505@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 22, 2008 at 06:23:40PM +1000, Lachlan McIlroy wrote:
> David Chinner wrote:
> >On Thu, May 22, 2008 at 01:42:47PM +1000, Lachlan McIlroy wrote:
> >>David Chinner wrote:
> >>>On Wed, May 14, 2008 at 03:24:57PM +1000, Lachlan McIlroy wrote:
> >>>>An xfs inode can be destroyed before log I/O involving that inode
> >>>>is complete.  We need to wait for the inode to be unpinned before
> >>>>tearing it down.
> >.....
> >>>>--- fs/xfs/xfs_vnodeops.c_1.757	2008-05-12 12:02:45.000000000 +1000
> >>>>+++ fs/xfs/xfs_vnodeops.c	2008-05-12 12:28:15.000000000 +1000
> >>>>@@ -3324,6 +3324,7 @@ xfs_finish_reclaim(
> >>>>			 * because we're gonna reclaim the inode anyway.
> >>>>			 */
> >>>>			if (error) {
> >>>>+				xfs_iunpin_wait(ip);
> >>>>				xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >>>>				goto reclaim;
> >>>>			}
> >>>We can't get an error from xfs_iflush() from here that hasn't
> >>>already passed through xfs_iunpin_wait() in xfs_iflush().
> >>>Hence we should never see a pinned inode through this path.
> >>Okay, good point.  I'll remove that one.  I thought about removing
> >>the XFS_FORCED_SHUTDOWN() and dirty inode checks from xfs_finish_reclaim()
> >>and calling xfs_iflush() anyway.  It will abort if it's a clean inode
> >>or it will do the unpin and then abort if it's a forced shutdown.
> >>It would make the code in xfs_finish_reclaim() a bit cleaner.  I also
> >>wouldn't need to export xfs_iunpin_wait().  Thoughts?
> >
> >Sounds like a fine plan. Please comment it appropriately, though.
> 
> Sounded too easy.  Hit this assert with an inode that's still in
> the AIL on a forced shutdown.
> 
> 	/*
> 	 * If the inode isn't dirty, then just release the inode
> 	 * flush lock and do nothing.
> 	 */
> 	if (xfs_inode_clean(ip)) {
> 		ASSERT((iip != NULL) ?
> 			 !(iip->ili_item.li_flags & XFS_LI_IN_AIL) : 1);
> 		xfs_ifunlock(ip);
> 		return 0;
> 	}

That's actually not a valid assert if xfs_iflush() is being called in
the shutdown case. In all previous cases we've checked for shutdown
before calling xfs_iflush(), so that assert would never fire. Now,
if we are calling knowing we might be in the shutdown case, then
this is an invalid assert.

i.e. on shutdown the AIL list is no longer kept properly up to
date - we remove inodes from the AIL in xfs_idestroy() in the
shutdown case....

Cheers,

Dave.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

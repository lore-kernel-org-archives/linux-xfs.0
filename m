Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 21:31:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4M4V20k009402
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 21:31:03 -0700
Date: Thu, 22 May 2008 14:31:50 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] make inode reclaim wait for log I/O to complete
Message-ID: <20080522043150.GM173056135@sgi.com>
References: <482A77A9.5040806@sgi.com> <20080514064451.GF155679365@sgi.com> <4834EBB7.5010200@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4834EBB7.5010200@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 22, 2008 at 01:42:47PM +1000, Lachlan McIlroy wrote:
> David Chinner wrote:
> >On Wed, May 14, 2008 at 03:24:57PM +1000, Lachlan McIlroy wrote:
> >>An xfs inode can be destroyed before log I/O involving that inode
> >>is complete.  We need to wait for the inode to be unpinned before
> >>tearing it down.
.....
> >>--- fs/xfs/xfs_vnodeops.c_1.757	2008-05-12 12:02:45.000000000 +1000
> >>+++ fs/xfs/xfs_vnodeops.c	2008-05-12 12:28:15.000000000 +1000
> >>@@ -3324,6 +3324,7 @@ xfs_finish_reclaim(
> >>			 * because we're gonna reclaim the inode anyway.
> >>			 */
> >>			if (error) {
> >>+				xfs_iunpin_wait(ip);
> >>				xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >>				goto reclaim;
> >>			}
> >
> >We can't get an error from xfs_iflush() from here that hasn't
> >already passed through xfs_iunpin_wait() in xfs_iflush().
> >Hence we should never see a pinned inode through this path.
> 
> Okay, good point.  I'll remove that one.  I thought about removing
> the XFS_FORCED_SHUTDOWN() and dirty inode checks from xfs_finish_reclaim()
> and calling xfs_iflush() anyway.  It will abort if it's a clean inode
> or it will do the unpin and then abort if it's a forced shutdown.
> It would make the code in xfs_finish_reclaim() a bit cleaner.  I also
> wouldn't need to export xfs_iunpin_wait().  Thoughts?

Sounds like a fine plan. Please comment it appropriately, though.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

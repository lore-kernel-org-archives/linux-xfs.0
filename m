Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 23:44:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4E6iAta017693
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 23:44:13 -0700
Date: Wed, 14 May 2008 16:44:51 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] make inode reclaim wait for log I/O to complete
Message-ID: <20080514064451.GF155679365@sgi.com>
References: <482A77A9.5040806@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482A77A9.5040806@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, May 14, 2008 at 03:24:57PM +1000, Lachlan McIlroy wrote:
> An xfs inode can be destroyed before log I/O involving that inode
> is complete.  We need to wait for the inode to be unpinned before
> tearing it down.
> 
> Lachlan
> 
> --- fs/xfs/xfs_inode.c_1.501	2008-05-12 14:45:17.000000000 +1000
> +++ fs/xfs/xfs_inode.c	2008-05-12 12:23:48.000000000 +1000
> @@ -2787,7 +2787,7 @@ __xfs_iunpin_wait(
> 		wait_event(ip->i_ipin_wait, (atomic_read(&ip->i_pincount) == 
> 		0));
> }
> 
> -static inline void
> +inline void
> xfs_iunpin_wait(
> 	xfs_inode_t	*ip)
> {

You want to kill the inline on this.

> --- fs/xfs/xfs_inode.h_1.245	2008-05-12 14:45:20.000000000 +1000
> +++ fs/xfs/xfs_inode.h	2008-05-12 12:31:37.000000000 +1000
> @@ -481,6 +481,7 @@ void		xfs_ifunlock(xfs_inode_t *);
> void		xfs_ireclaim(xfs_inode_t *);
> int		xfs_finish_reclaim(xfs_inode_t *, int, int);
> int		xfs_finish_reclaim_all(struct xfs_mount *, int);
> +void		xfs_iunpin_wait(xfs_inode_t *);
> 
> /*
>  * xfs_inode.c prototypes.
> --- fs/xfs/xfs_vnodeops.c_1.757	2008-05-12 12:02:45.000000000 +1000
> +++ fs/xfs/xfs_vnodeops.c	2008-05-12 12:28:15.000000000 +1000
> @@ -3324,6 +3324,7 @@ xfs_finish_reclaim(
> 			 * because we're gonna reclaim the inode anyway.
> 			 */
> 			if (error) {
> +				xfs_iunpin_wait(ip);
> 				xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 				goto reclaim;
> 			}

We can't get an error from xfs_iflush() from here that hasn't
already passed through xfs_iunpin_wait() in xfs_iflush().
Hence we should never see a pinned inode through this path.

> @@ -3336,6 +3337,7 @@ xfs_finish_reclaim(
> 	}
> 
> 	xfs_ifunlock(ip);
> +	xfs_iunpin_wait(ip);

If we are not shutting down the filesystem, how do we get a pinned
inode here?  A pinned inode is a dirty inode and should be caught by
the above code. Is the crash occurring when a force shutdown is in
progress?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

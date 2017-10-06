Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:49680 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751025AbdJFHJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 03:09:06 -0400
Date: Fri, 6 Oct 2017 18:07:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/25] xfs: scrub directory metadata
Message-ID: <20171006070714.GS3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706336897.19351.7541168310430592724.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150706336897.19351.7541168310430592724.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 01:42:49PM -0700, Darrick J. Wong wrote:
> +
> +/* Set us up to scrub a file's contents. */
> +int
> +xfs_scrub_setup_inode_contents(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_inode		*ip,
> +	unsigned int			resblks)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	int				error;
> +
> +	error = xfs_scrub_get_inode(sc, ip);
> +	if (error)
> +		return error;
> +
> +	/* Got the inode, lock it and we're ready to go. */
> +	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
> +	xfs_ilock(sc->ip, sc->ilock_flags);
> +	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
> +	if (error)
> +		goto out_unlock;
> +	sc->ilock_flags |= XFS_ILOCK_EXCL;
> +	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
> +
> +	return 0;
> +out_unlock:
> +	xfs_iunlock(sc->ip, sc->ilock_flags);
> +	if (sc->ip != ip)
> +		iput(VFS_I(sc->ip));
> +	sc->ip = NULL;
> +	return error;
> +}

I've seen this get/lock/alloc code many times now - seems like scope
for factoring?

> +/* Scrub a directory entry. */
> +
> +struct xfs_scrub_dir_ctx {
> +	struct dir_context		dc;
> +	struct xfs_scrub_context	*sc;
> +};

These two character variable names make the code really hard to
understand, especially when....

> +
> +/* Check that an inode's mode matches a given DT_ type. */
> +STATIC int
> +xfs_scrub_dir_check_ftype(
> +	struct xfs_scrub_dir_ctx	*sdc,

... we now have sc, dc, and sdc all intertwined. Especially as some
of these functions seem to invert the calling convention of the rest
of the scrub code in that the scrub context is the primary object
that is passed around and everything is attached to the sc....

Brain hurts trying to keep all this straight here...

/me keeps blundering around until it becomes apparent that
dir_context has nothing to do with scrub, but is a VFS filldir
callback structure triggered through readdir.

Darrick, can you add some comments explaining how the dirent
scrubbing works?  It'd make it so much easier to understand if I
didn't have to reverse engineer the intent and design from the
patch. I'm going to skip this one for now...

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

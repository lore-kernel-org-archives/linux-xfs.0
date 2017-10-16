Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:21274
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751612AbdJPD1W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 23:27:22 -0400
Date: Mon, 16 Oct 2017 14:26:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 22/30] xfs: scrub inode block mappings
Message-ID: <20171016032601.GY3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777258634.1724.8710762615801926700.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777258634.1724.8710762615801926700.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:43:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Scrub an individual inode's block mappings to make sure they make sense.

....

> +/* Set us up with an inode's bmap. */
> +int
> +xfs_scrub_setup_inode_bmap(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_inode		*ip)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	int				error;
> +
> +	error = xfs_scrub_get_inode(sc, ip);
> +	if (error)
> +		goto out;
> +
> +	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
> +	xfs_ilock(sc->ip, sc->ilock_flags);
> +
> +	/*
> +	 * We don't want any ephemeral data fork updates sitting around
> +	 * while we inspect block mappings, so wait for directio to finish
> +	 * and flush dirty data if we have delalloc reservations.
> +	 */
> +	if (S_ISREG(VFS_I(sc->ip)->i_mode) &&
> +	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
> +		inode_dio_wait(VFS_I(sc->ip));
> +		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
> +		if (error)
> +			goto out;
> +
> +		/* Drop the page cache if we're repairing block mappings. */
> +		if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
> +			error = invalidate_inode_pages2(
> +					VFS_I(sc->ip)->i_mapping);
> +			if (error)
> +				goto out;

I'll point this out just to say I've seen it. It's a little out of
place for this patch set, but it's harmless.

> +/* Scrub a bmbt record. */
> +STATIC int
> +xfs_scrub_bmapbt_helper(

s/helper/rec/

> + *
> + * First we scan every record in every btree block, if applicable.
> + * Then we unconditionally scan the incore extent cache.
> + */
> +STATIC int
> +xfs_scrub_bmap(
> +	struct xfs_scrub_context	*sc,
> +	int				whichfork)
> +{
> +	struct xfs_bmbt_irec		irec;
> +	struct xfs_scrub_bmap_info	info = {0};
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_inode		*ip = sc->ip;
> +	struct xfs_ifork		*ifp;
> +	xfs_fileoff_t			endoff;
> +	xfs_extnum_t			idx;
> +	bool				found;
> +	int				error = 0;
> +
> +	ifp = XFS_IFORK_PTR(ip, whichfork);
> +
> +	info.is_rt = whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip);
> +	info.whichfork = whichfork;
> +	info.is_shared = whichfork == XFS_DATA_FORK && xfs_is_reflink_inode(ip);
> +	info.sc = sc;
> +
> +	switch (whichfork) {
> +	case XFS_COW_FORK:
> +		/* Non-existent CoW forks are ignorable. */
> +		if (!ifp)
> +			goto out;
> +		/* No CoW forks on non-reflink inodes/filesystems. */
> +		if (!xfs_is_reflink_inode(ip)) {
> +			xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino, NULL);
> +			goto out;
> +		}
> +		break;
> +	case XFS_ATTR_FORK:
> +		if (!ifp)
> +			goto out;
> +		if (!xfs_sb_version_hasattr(&mp->m_sb) &&
> +		    !xfs_sb_version_hasattr2(&mp->m_sb))
> +			xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino, NULL);
> +		break;
> +	}

Missing a default option here for other values. Some compilers will
warn about this.

Otherwise this look fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

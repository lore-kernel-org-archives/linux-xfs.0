Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:43363 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751512AbdJPC4C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 22:56:02 -0400
Date: Mon, 16 Oct 2017 13:55:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/30] xfs: scrub inode btrees
Message-ID: <20171016025559.GU3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777256125.1724.12622578684332324586.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777256125.1724.12622578684332324586.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:42:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the records of the inode btrees to make sure that the values
> make sense given the inode records themselves.

.....

I think maybe I missed this first time around...

> +/* Check a particular inode with ir_free. */
> +STATIC int
> +xfs_scrub_iallocbt_check_cluster_freemask(
> +	struct xfs_scrub_btree		*bs,
> +	xfs_ino_t			fsino,
> +	xfs_agino_t			chunkino,
> +	xfs_agino_t			clusterino,
> +	struct xfs_inobt_rec_incore	*irec,
> +	struct xfs_buf			*bp)
> +{
> +	struct xfs_dinode		*dip;
> +	struct xfs_mount		*mp = bs->cur->bc_mp;
> +	bool				freemask_ok;
> +	bool				inuse;
> +	int				error;
> +
> +	dip = xfs_buf_offset(bp, clusterino * mp->m_sb.sb_inodesize);
> +	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC ||
> +	    (dip->di_version >= 3 &&
> +	     be64_to_cpu(dip->di_ino) != fsino + clusterino)) {
> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +		goto out;
> +	}
> +
> +	freemask_ok = (irec->ir_free & XFS_INOBT_MASK(chunkino + clusterino));

Ok, so if the inode if free, the corresponding bit in the mask
will be set....

> +	error = xfs_icache_inode_is_allocated(mp, bs->cur->bc_tp,
> +			fsino + clusterino, &inuse);
> +	if (error == -ENODATA) {
> +		/* Not cached, just read the disk buffer */
> +		freemask_ok ^= !!(dip->di_mode);

And this uses the lowest bit of the mask? How does that work?

/me spends 10 minutes trying to work out this function before he
realises that freemask_ok is a boolean, so the initial freemask
bit is collapsed down to a single bit.

Ok, that's definitely unexpected and not obvious from the code or
comments. The name "freemask_ok" is misleading the way it's used.
The first time it is set is means "inode is free", then after this
operation it means "inode matches free mask"....

> +		if (!bs->sc->try_harder && !freemask_ok)
> +			return -EDEADLOCK;
> +	} else if (error < 0) {
> +		/*
> +		 * Inode is only half assembled, or there was an IO error,
> +		 * or the verifier failed, so don't bother trying to check.
> +		 * The inode scrubber can deal with this.
> +		 */
> +		freemask_ok = true;

And here it means "we didn't check the free mask"

> +	} else {
> +		/* Inode is all there. */
> +		freemask_ok ^= inuse;

And here is means "inode matches free mask" again....

> +	}
> +	if (!freemask_ok)
> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +out:
> +	return 0;

Can we rewrite this to be a little more obvious?

	bool		inode_is_free = false;
	bool		freemask_ok;
....
	if (irec->ir_free & XFS_INOBT_MASK(chunkino + clusterino))
		inode_is_free = true;
....
	if (error == -ENODATA) {
		freemask_ok = inode_is_free ^ !!(dip->di_mode);
....
	else if (error < 0) {
		/*
		 * Inode is only half assembled, .....
		 */
		goto out;
	} else {
		freemask_ok = inode_is_free ^ inuse;
	}

That's a lot more obvious what the code is checking...


> +/* Scrub an inobt/finobt record. */
> +STATIC int
> +xfs_scrub_iallocbt_helper(

s/helper/rec/

-Dave.
-- 
Dave Chinner
david@fromorbit.com

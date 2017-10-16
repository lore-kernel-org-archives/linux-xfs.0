Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50883 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750826AbdJPE3u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 00:29:50 -0400
Date: Mon, 16 Oct 2017 15:29:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 24/30] xfs: scrub directory metadata
Message-ID: <20171016042947.GA3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777259980.1724.8093055918170430129.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777259980.1724.8093055918170430129.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:43:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Scrub the hash tree and all the entries in a directory.

.....
> +/* Check that an inode's mode matches a given DT_ type. */
> +STATIC int
> +xfs_scrub_dir_check_ftype(
> +	struct xfs_scrub_dir_ctx	*sdc,
> +	xfs_fileoff_t			offset,
> +	xfs_ino_t			inum,
> +	int				dtype)
> +{
> +	struct xfs_mount		*mp = sdc->sc->mp;
> +	struct xfs_inode		*ip;
> +	int				ino_dtype;
> +	int				error = 0;
> +
> +	if (!xfs_sb_version_hasftype(&mp->m_sb)) {
> +		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
> +			xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
> +					offset);
> +		goto out;
> +	}
> +
> +	error = xfs_iget(mp, sdc->sc->tp, inum, XFS_IGET_DONTCACHE, 0, &ip);
> +	if (!xfs_scrub_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
> +			&error))
> +		goto out;
> +
> +	/* Convert mode to the DT_* values that dir_emit uses. */
> +	ino_dtype = (VFS_I(ip)->i_mode & S_IFMT) >> 12;

xfs_mode_to_ftype() ?

Otherwise it looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

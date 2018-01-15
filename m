Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:12947 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750716AbeAOV4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jan 2018 16:56:50 -0500
Date: Tue, 16 Jan 2018 08:56:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/5] xfs: directory scrubber must walk through data
 block to offset
Message-ID: <20180115215648.GA16421@dastard>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
 <151579465813.8694.2293343683195960907.stgit@magnolia>
 <20180115200447.GD5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180115200447.GD5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Mon, Jan 15, 2018 at 12:04:47PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_scrub_dir_rec, we must walk through the directory block entries
> to arrive at the offset given by the hash structure.  If we blindly
> trust the hash address, we can end up midway into a directory entry and
> stray outside the block.  Found by lastbit fuzzing lents[3].address in
> xfs/390 with KASAN enabled.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
> v2: improve defensive pointer checking (endp theoretically can be null)
> ---
>  fs/xfs/libxfs/xfs_dir2.h      |    1 +
>  fs/xfs/libxfs/xfs_dir2_data.c |   19 +++++++++++++++++++
>  fs/xfs/scrub/dir.c            |   30 +++++++++++++++++++++++++++++-
>  3 files changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 1a8f2cf..2c77195 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -340,5 +340,6 @@ xfs_dir2_leaf_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_leaf *lp)
>  #define XFS_READDIR_BUFSIZE	(32768)
>  
>  unsigned char xfs_dir3_get_dtype(struct xfs_mount *mp, uint8_t filetype);
> +void *xfs_dir3_data_endp(struct xfs_mount *mp, struct xfs_dir2_data_hdr *hdr);
>  
>  #endif	/* __XFS_DIR2_H__ */
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 853d9ab..b87db03 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -1098,3 +1098,22 @@ xfs_dir2_data_use_free(
>  	}
>  	*needscanp = needscan;
>  }
> +
> +/* Find the end of the entry data in a data/block format dir block. */
> +void *
> +xfs_dir3_data_endp(
> +	struct xfs_mount		*mp,
> +	struct xfs_dir2_data_hdr	*hdr)
> +{
> +	switch (hdr->magic) {
> +	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
> +	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
> +		return xfs_dir2_block_leaf_p(
> +				xfs_dir2_block_tail_p(mp->m_dir_geo, hdr));
> +	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
> +	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
> +		return (char *)hdr + mp->m_dir_geo->blksize;
> +	default:
> +		return NULL;
> +	}
> +}

Ok, this pattern is used in a few places. e.g.
xfs_dir2_data_make_free, __xfs_dir3_data_check and
xfs_dir2_data_freescan_int, so if you're going to add a helper, at
least convert all the other places there is the same code over to
use it...

Also, it should be passed a geo struct, not a xfs_mount.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

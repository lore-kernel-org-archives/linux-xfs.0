Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39898 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbeJCVlc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Oct 2018 17:41:32 -0400
Date: Wed, 3 Oct 2018 07:52:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/8] xfs: remove suport for filesystems without unwritten
 extent flag
Message-ID: <20181003145205.GE19324@magnolia>
References: <20181002174207.25275-1-hch@lst.de>
 <20181002174207.25275-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002174207.25275-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 02, 2018 at 10:42:01AM -0700, Christoph Hellwig wrote:
> The option to enable unwritten extents was made default in 2003, removed
> from mkfs in 2007, and cannot be disabled in v5.  We also rely on it for
> a lot of common functionality, so filesystems without it will run a
> completely untested and buggy code path.  Enabling the support also is
> a simple bit flip using xfs_db, so legacy file systems can still be
> brought forward.

Will there be a migration tool in xfsprogs to help administrators roll
their filesystems forward?  Generally we don't seem to support enabling
new features on old filesystems (ala ext4) though maybe we should for a
very small and controlled set of porting operations?

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c   | 21 ++++++----------
>  fs/xfs/libxfs/xfs_format.h |  8 ++----
>  fs/xfs/libxfs/xfs_sb.c     |  5 ++--
>  fs/xfs/scrub/scrub.c       | 13 ----------
>  fs/xfs/xfs_bmap_util.c     | 51 +-------------------------------------
>  fs/xfs/xfs_ioctl.c         |  8 ------
>  6 files changed, 12 insertions(+), 94 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index a47670332326..da6b768664e3 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4081,8 +4081,7 @@ xfs_bmapi_allocate(
>  	 * extents to real extents when we're about to write the data.
>  	 */
>  	if ((!bma->wasdel || (bma->flags & XFS_BMAPI_COWFORK)) &&
> -	    (bma->flags & XFS_BMAPI_PREALLOC) &&
> -	    xfs_sb_version_hasextflgbit(&mp->m_sb))
> +	    (bma->flags & XFS_BMAPI_PREALLOC))
>  		bma->got.br_state = XFS_EXT_UNWRITTEN;
>  
>  	if (bma->wasdel)
> @@ -5245,8 +5244,7 @@ __xfs_bunmapi(
>  			 * unmapping part of it.  But we can't really
>  			 * get rid of part of a realtime extent.
>  			 */
> -			if (del.br_state == XFS_EXT_UNWRITTEN ||
> -			    !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
> +			if (del.br_state == XFS_EXT_UNWRITTEN) {
>  				/*
>  				 * This piece is unwritten, or we're not
>  				 * using unwritten extents.  Skip over it.
> @@ -5296,10 +5294,9 @@ __xfs_bunmapi(
>  				del.br_blockcount -= mod;
>  				del.br_startoff += mod;
>  				del.br_startblock += mod;
> -			} else if ((del.br_startoff == start &&
> -				    (del.br_state == XFS_EXT_UNWRITTEN ||
> -				     tp->t_blk_res == 0)) ||
> -				   !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
> +			} else if (del.br_startoff == start &&
> +				   (del.br_state == XFS_EXT_UNWRITTEN ||
> +				    tp->t_blk_res == 0)) {
>  				/*
>  				 * Can't make it unwritten.  There isn't
>  				 * a full extent here so just skip it.
> @@ -6114,11 +6111,7 @@ xfs_bmap_validate_extent(
>  		    XFS_FSB_TO_AGNO(mp, endfsb))
>  			return __this_address;
>  	}
> -	if (irec->br_state != XFS_EXT_NORM) {
> -		if (whichfork != XFS_DATA_FORK)
> -			return __this_address;
> -		if (!xfs_sb_version_hasextflgbit(&mp->m_sb))
> -			return __this_address;
> -	}
> +	if (irec->br_state != XFS_EXT_NORM && whichfork != XFS_DATA_FORK)
> +		return __this_address;
>  	return NULL;
>  }
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index afbe336600e1..9995d5ae380b 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -287,6 +287,8 @@ static inline bool xfs_sb_good_v4_features(struct xfs_sb *sbp)
>  {
>  	if (!(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT))
>  		return false;
> +	if (!(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT))
> +		return false;

The kernel only spits out "XFS(sda): bad version" in dmesg.  Maybe it'd
be helpful to steer admins towards whatever they need to do to make
their ancient fs work again?

--D

>  
>  	/* check for unknown features in the fs */
>  	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
> @@ -357,12 +359,6 @@ static inline bool xfs_sb_version_haslogv2(struct xfs_sb *sbp)
>  	       (sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
>  }
>  
> -static inline bool xfs_sb_version_hasextflgbit(struct xfs_sb *sbp)
> -{
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
> -	       (sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
> -}
> -
>  static inline bool xfs_sb_version_hassector(struct xfs_sb *sbp)
>  {
>  	return (sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 081f46e30556..b5a82acd7dfe 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1115,7 +1115,8 @@ xfs_fs_geometry(
>  
>  	geo->version = XFS_FSOP_GEOM_VERSION;
>  	geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
> -		     XFS_FSOP_GEOM_FLAGS_DIRV2;
> +		     XFS_FSOP_GEOM_FLAGS_DIRV2 |
> +		     XFS_FSOP_GEOM_FLAGS_EXTFLG;
>  	if (xfs_sb_version_hasattr(sbp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR;
>  	if (xfs_sb_version_hasquota(sbp))
> @@ -1124,8 +1125,6 @@ xfs_fs_geometry(
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_IALIGN;
>  	if (xfs_sb_version_hasdalign(sbp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_DALIGN;
> -	if (xfs_sb_version_hasextflgbit(sbp))
> -		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXTFLG;
>  	if (xfs_sb_version_hassector(sbp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
>  	if (xfs_sb_version_hasasciici(sbp))
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 4bfae1e61d30..1b2344d00525 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -412,19 +412,6 @@ xchk_validate_inputs(
>  		goto out;
>  	}
>  
> -	error = -EOPNOTSUPP;
> -	/*
> -	 * We won't scrub any filesystem that doesn't have the ability
> -	 * to record unwritten extents.  The option was made default in
> -	 * 2003, removed from mkfs in 2007, and cannot be disabled in
> -	 * v5, so if we find a filesystem without this flag it's either
> -	 * really old or totally unsupported.  Avoid it either way.
> -	 * We also don't support v1-v3 filesystems, which aren't
> -	 * mountable.
> -	 */
> -	if (!xfs_sb_version_hasextflgbit(&mp->m_sb))
> -		goto out;
> -
>  	/*
>  	 * We only want to repair read-write v5+ filesystems.  Defer the check
>  	 * for ops->repair until after our scrub confirms that we need to
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 6de8d90041ff..416524f6ba69 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1042,44 +1042,6 @@ xfs_unmap_extent(
>  	goto out_unlock;
>  }
>  
> -static int
> -xfs_adjust_extent_unmap_boundaries(
> -	struct xfs_inode	*ip,
> -	xfs_fileoff_t		*startoffset_fsb,
> -	xfs_fileoff_t		*endoffset_fsb)
> -{
> -	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_bmbt_irec	imap;
> -	int			nimap, error;
> -	xfs_extlen_t		mod = 0;
> -
> -	nimap = 1;
> -	error = xfs_bmapi_read(ip, *startoffset_fsb, 1, &imap, &nimap, 0);
> -	if (error)
> -		return error;
> -
> -	if (nimap && imap.br_startblock != HOLESTARTBLOCK) {
> -		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
> -		div_u64_rem(imap.br_startblock, mp->m_sb.sb_rextsize, &mod);
> -		if (mod)
> -			*startoffset_fsb += mp->m_sb.sb_rextsize - mod;
> -	}
> -
> -	nimap = 1;
> -	error = xfs_bmapi_read(ip, *endoffset_fsb - 1, 1, &imap, &nimap, 0);
> -	if (error)
> -		return error;
> -
> -	if (nimap && imap.br_startblock != HOLESTARTBLOCK) {
> -		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
> -		mod++;
> -		if (mod && mod != mp->m_sb.sb_rextsize)
> -			*endoffset_fsb -= mod;
> -	}
> -
> -	return 0;
> -}
> -
>  static int
>  xfs_flush_unmap_range(
>  	struct xfs_inode	*ip,
> @@ -1133,19 +1095,8 @@ xfs_free_file_space(
>  	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
>  
>  	/*
> -	 * Need to zero the stuff we're not freeing, on disk.  If it's a RT file
> -	 * and we can't use unwritten extents then we actually need to ensure
> -	 * to zero the whole extent, otherwise we just need to take of block
> -	 * boundaries, and xfs_bunmapi will handle the rest.
> +	 * Need to zero the stuff we're not freeing, on disk.
>  	 */
> -	if (XFS_IS_REALTIME_INODE(ip) &&
> -	    !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
> -		error = xfs_adjust_extent_unmap_boundaries(ip, &startoffset_fsb,
> -				&endoffset_fsb);
> -		if (error)
> -			return error;
> -	}
> -
>  	if (endoffset_fsb > startoffset_fsb) {
>  		while (!done) {
>  			error = xfs_unmap_extent(ip, startoffset_fsb,
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0ef5ece5634c..6e2c08f30f60 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -604,14 +604,6 @@ xfs_ioc_space(
>  	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
>  	int			error;
>  
> -	/*
> -	 * Only allow the sys admin to reserve space unless
> -	 * unwritten extents are enabled.
> -	 */
> -	if (!xfs_sb_version_hasextflgbit(&ip->i_mount->m_sb) &&
> -	    !capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> -
>  	if (inode->i_flags & (S_IMMUTABLE|S_APPEND))
>  		return -EPERM;
>  
> -- 
> 2.19.0
> 

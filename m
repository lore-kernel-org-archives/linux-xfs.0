Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54876 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752305AbeCURm4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Mar 2018 13:42:56 -0400
Date: Wed, 21 Mar 2018 13:42:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 9/9] xfs: move inode extent size hint validation to libxfs
Message-ID: <20180321174254.GK11127@bfoster.bfoster>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
 <152107382856.19571.17761547971193930776.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152107382856.19571.17761547971193930776.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 14, 2018 at 05:30:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Extent size hint validation is used by scrub to decide if there's an
> error, and it will be used by repair to decide to remove the hint.
> Since these use the same validation functions, move them to libxfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_buf.c |  105 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_inode_buf.h |    5 ++
>  fs/xfs/scrub/inode.c          |  100 +++++----------------------------------
>  3 files changed, 122 insertions(+), 88 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 51019e5..cdd4c1d 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -651,3 +651,108 @@ xfs_iread(
>  	xfs_trans_brelse(tp, bp);
>  	return error;
>  }
> +
> +/*
> + * Validate di_extsize hint.
> + *
> + * The rules are documented at xfs_ioctl_setattr_check_extsize().
> + * These functions must be kept in sync with each other.
> + */
> +xfs_failaddr_t
> +xfs_inode_validate_extsize(
> +	struct xfs_mount		*mp,
> +	uint32_t			extsize,
> +	uint16_t			mode,
> +	uint16_t			flags)
> +{
> +	bool				rt_flag;
> +	bool				hint_flag;
> +	bool				inherit_flag;
> +	uint32_t			extsize_bytes;
> +	uint32_t			blocksize_bytes;
> +
> +	rt_flag = (flags & XFS_DIFLAG_REALTIME);
> +	hint_flag = (flags & XFS_DIFLAG_EXTSIZE);
> +	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
> +	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
> +
> +	if (rt_flag)
> +		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
> +	else
> +		blocksize_bytes = mp->m_sb.sb_blocksize;
> +
> +	if ((hint_flag || inherit_flag) && !(S_ISDIR(mode) || S_ISREG(mode)))
> +		return __this_address;
> +
> +	if (hint_flag && !S_ISREG(mode))
> +		return __this_address;
> +
> +	if (inherit_flag && !S_ISDIR(mode))
> +		return __this_address;
> +
> +	if ((hint_flag || inherit_flag) && extsize == 0)
> +		return __this_address;
> +
> +	if (!(hint_flag || inherit_flag) && extsize != 0)
> +		return __this_address;
> +
> +	if (extsize_bytes % blocksize_bytes)
> +		return __this_address;
> +
> +	if (extsize > MAXEXTLEN)
> +		return __this_address;
> +
> +	if (!rt_flag && extsize > mp->m_sb.sb_agblocks / 2)
> +		return __this_address;
> +
> +	return NULL;
> +}
> +
> +/*
> + * Validate di_cowextsize hint.
> + *
> + * The rules are documented at xfs_ioctl_setattr_check_cowextsize().
> + * These functions must be kept in sync with each other.
> + */
> +xfs_failaddr_t
> +xfs_inode_validate_cowextsize(
> +	struct xfs_mount		*mp,
> +	uint32_t			cowextsize,
> +	uint16_t			mode,
> +	uint16_t			flags,
> +	uint64_t			flags2)
> +{
> +	bool				rt_flag;
> +	bool				hint_flag;
> +	uint32_t			cowextsize_bytes;
> +
> +	rt_flag = (flags & XFS_DIFLAG_REALTIME);
> +	hint_flag = (flags2 & XFS_DIFLAG2_COWEXTSIZE);
> +	cowextsize_bytes = XFS_FSB_TO_B(mp, cowextsize);
> +
> +	if (hint_flag && !xfs_sb_version_hasreflink(&mp->m_sb))
> +		return __this_address;
> +
> +	if (hint_flag && !(S_ISDIR(mode) || S_ISREG(mode)))
> +		return __this_address;
> +
> +	if (hint_flag && cowextsize == 0)
> +		return __this_address;
> +
> +	if (!hint_flag && cowextsize != 0)
> +		return __this_address;
> +
> +	if (hint_flag && rt_flag)
> +		return __this_address;
> +
> +	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
> +		return __this_address;
> +
> +	if (cowextsize > MAXEXTLEN)
> +		return __this_address;
> +
> +	if (cowextsize > mp->m_sb.sb_agblocks / 2)
> +		return __this_address;
> +
> +	return NULL;
> +}
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 8a5e1da..d9a376a 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -84,5 +84,10 @@ void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
>  
>  xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
>  			   struct xfs_dinode *dip);
> +xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
> +		uint32_t extsize, uint16_t mode, uint16_t flags);
> +xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
> +		uint32_t cowextsize, uint16_t mode, uint16_t flags,
> +		uint64_t flags2);
>  
>  #endif	/* __XFS_INODE_BUF_H__ */
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 9eadca9..25bca48 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -89,12 +89,7 @@ xfs_scrub_setup_inode(
>  
>  /* Inode core */
>  
> -/*
> - * Validate di_extsize hint.
> - *
> - * The rules are documented at xfs_ioctl_setattr_check_extsize().
> - * These functions must be kept in sync with each other.
> - */
> +/* Validate di_extsize hint. */
>  STATIC void
>  xfs_scrub_inode_extsize(
>  	struct xfs_scrub_context	*sc,
> @@ -103,52 +98,12 @@ xfs_scrub_inode_extsize(
>  	uint16_t			mode,
>  	uint16_t			flags)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> -	bool				rt_flag;
> -	bool				hint_flag;
> -	bool				inherit_flag;
> -	uint32_t			extsize;
> -	uint32_t			extsize_bytes;
> -	uint32_t			blocksize_bytes;
> -
> -	rt_flag = (flags & XFS_DIFLAG_REALTIME);
> -	hint_flag = (flags & XFS_DIFLAG_EXTSIZE);
> -	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
> -	extsize = be32_to_cpu(dip->di_extsize);
> -	extsize_bytes = XFS_FSB_TO_B(sc->mp, extsize);
> -
> -	if (rt_flag)
> -		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
> -	else
> -		blocksize_bytes = mp->m_sb.sb_blocksize;
> -
> -	if ((hint_flag || inherit_flag) && !(S_ISDIR(mode) || S_ISREG(mode)))
> -		goto bad;
> -
> -	if (hint_flag && !S_ISREG(mode))
> -		goto bad;
> -
> -	if (inherit_flag && !S_ISDIR(mode))
> -		goto bad;
> +	xfs_failaddr_t			fa;
>  
> -	if ((hint_flag || inherit_flag) && extsize == 0)
> -		goto bad;
> -
> -	if (!(hint_flag || inherit_flag) && extsize != 0)
> -		goto bad;
> -
> -	if (extsize_bytes % blocksize_bytes)
> -		goto bad;
> -
> -	if (extsize > MAXEXTLEN)
> -		goto bad;
> -
> -	if (!rt_flag && extsize > mp->m_sb.sb_agblocks / 2)
> -		goto bad;
> -
> -	return;
> -bad:
> -	xfs_scrub_ino_set_corrupt(sc, ino);
> +	fa = xfs_inode_validate_extsize(sc->mp, be32_to_cpu(dip->di_extsize),
> +			mode, flags);
> +	if (fa)
> +		xfs_scrub_ino_set_corrupt(sc, ino);
>  }
>  
>  /*
> @@ -166,44 +121,13 @@ xfs_scrub_inode_cowextsize(
>  	uint16_t			flags,
>  	uint64_t			flags2)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> -	bool				rt_flag;
> -	bool				hint_flag;
> -	uint32_t			extsize;
> -	uint32_t			extsize_bytes;
> -
> -	rt_flag = (flags & XFS_DIFLAG_REALTIME);
> -	hint_flag = (flags2 & XFS_DIFLAG2_COWEXTSIZE);
> -	extsize = be32_to_cpu(dip->di_cowextsize);
> -	extsize_bytes = XFS_FSB_TO_B(sc->mp, extsize);
> -
> -	if (hint_flag && !xfs_sb_version_hasreflink(&mp->m_sb))
> -		goto bad;
> -
> -	if (hint_flag && !(S_ISDIR(mode) || S_ISREG(mode)))
> -		goto bad;
> -
> -	if (hint_flag && extsize == 0)
> -		goto bad;
> -
> -	if (!hint_flag && extsize != 0)
> -		goto bad;
> +	xfs_failaddr_t			fa;
>  
> -	if (hint_flag && rt_flag)
> -		goto bad;
> -
> -	if (extsize_bytes % mp->m_sb.sb_blocksize)
> -		goto bad;
> -
> -	if (extsize > MAXEXTLEN)
> -		goto bad;
> -
> -	if (extsize > mp->m_sb.sb_agblocks / 2)
> -		goto bad;
> -
> -	return;
> -bad:
> -	xfs_scrub_ino_set_corrupt(sc, ino);
> +	fa = xfs_inode_validate_cowextsize(sc->mp,
> +			be32_to_cpu(dip->di_cowextsize), mode, flags,
> +			flags2);
> +	if (fa)
> +		xfs_scrub_ino_set_corrupt(sc, ino);
>  }
>  
>  /* Make sure the di_flags make sense for the inode. */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

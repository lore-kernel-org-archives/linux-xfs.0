Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751959AbdCOPAV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Mar 2017 11:00:21 -0400
Date: Wed, 15 Mar 2017 11:00:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: verify inline directory data forks
Message-ID: <20170315150018.GA24729@bfoster.bfoster>
References: <20170315072855.GA5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170315072855.GA5280@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 15, 2017 at 12:28:55AM -0700, Darrick J. Wong wrote:
> When we're reading or writing the data fork of an inline directory,
> check the contents to make sure we're not overflowing buffers or eating
> garbage data.  xfs/348 corrupts an inline symlink into an inline
> directory, triggering a buffer overflow bug.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Thanks, this looks much nicer to me. I suppose some of the checks in
xfs_dir2_sf_getdents() could be killed off as redundant with the
verifier in place..?

Just a few other comments...

>  fs/xfs/libxfs/xfs_dir2_data.c  |   73 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_dir2_priv.h  |    2 +
>  fs/xfs/libxfs/xfs_inode_fork.c |   22 ++++++++++--
>  fs/xfs/libxfs/xfs_inode_fork.h |    2 +
>  fs/xfs/xfs_inode.c             |   12 +++++--
>  5 files changed, 104 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index d478065..fb6f32d 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -33,6 +33,79 @@
>  #include "xfs_cksum.h"
>  #include "xfs_log.h"
>  
> +/* Check the consistency of an inline directory. */
> +int
> +xfs_dir3_inline_check(
> +	struct xfs_mount		*mp,
> +	struct xfs_dinode		*dip,
> +	int				size)
> +{
> +	struct xfs_dir2_sf_entry	*sfep;
> +	struct xfs_dir2_sf_entry	*next_sfep;
> +	struct xfs_dir2_sf_hdr		*sfp;
> +	char				*endp;
> +	const struct xfs_dir_ops	*dops;
> +	xfs_ino_t			ino;
> +	int				i;
> +	__uint8_t			filetype;
> +
> +	dops = xfs_dir_get_ops(mp, NULL);
> +
> +	/*
> +	 * Give up if the directory is way too short.
> +	 */
> +	XFS_WANT_CORRUPTED_RETURN(mp, size >
> +			offsetof(struct xfs_dir2_sf_hdr, parent));
> +
> +	sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_PTR(dip, XFS_DATA_FORK);
> +	endp = (char *)sfp + size;
> +
> +	XFS_WANT_CORRUPTED_RETURN(mp, size >=
> +			xfs_dir2_sf_hdr_size(sfp->i8count));
> +
> +	/* Check .. entry */
> +	ino = dops->sf_get_parent_ino(sfp);
> +	XFS_WANT_CORRUPTED_RETURN(mp, !xfs_dir_ino_validate(mp, ino));
> +
> +	/*
> +	 * Loop while there are more entries and put'ing works.
> +	 */

Probably need to fix up the comment here.

> +	sfep = xfs_dir2_sf_firstentry(sfp);
> +	for (i = 0; i < sfp->count; i++) {
> +		/*
> +		 * struct xfs_dir2_sf_entry has a variable length.
> +		 * Check the fixed-offset parts of the structure are
> +		 * within the data buffer.
> +		 */
> +		XFS_WANT_CORRUPTED_RETURN(mp,
> +				((char *)sfep + sizeof(*sfep)) < endp);
> +
> +		/* Don't allow names with known bad length. */
> +		XFS_WANT_CORRUPTED_RETURN(mp, sfep->namelen > 0);
> +		XFS_WANT_CORRUPTED_RETURN(mp, sfep->namelen < MAXNAMELEN);
> +
> +		/*
> +		 * Check that the variable-length part of the structure is
> +		 * within the data buffer.  The next entry starts after the
> +		 * name component, so nextentry is an acceptable test.
> +		 */
> +		next_sfep = dops->sf_nextentry(sfp, sfep);
> +		XFS_WANT_CORRUPTED_RETURN(mp, endp >= (char *)next_sfep);
> +
> +		/* Check the inode number. */
> +		ino = dops->sf_get_ino(sfp, sfep);
> +		XFS_WANT_CORRUPTED_RETURN(mp, !xfs_dir_ino_validate(mp, ino));
> +

It might be useful to verify the entry offsets as well (perhaps at least
that they are ascending, for example), particularly since we have
limited header data to go on.

> +		/* Check the file type. */
> +		filetype = dops->sf_get_ftype(sfep);
> +		XFS_WANT_CORRUPTED_RETURN(mp, filetype < XFS_DIR3_FT_MAX);
> +
> +		sfep = next_sfep;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Check the consistency of the data block.
>   * The input can also be a block-format directory.
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index d04547f..e4f489b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -44,6 +44,8 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
>  #define	xfs_dir3_data_check(dp,bp)
>  #endif
>  
> +extern int xfs_dir3_inline_check(struct xfs_mount *mp, struct xfs_dinode *dip,
> +		int size);
>  extern int __xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
>  extern int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
>  		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 25c1e07..2a454cf 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -33,6 +33,8 @@
>  #include "xfs_trace.h"
>  #include "xfs_attr_sf.h"
>  #include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_dir2_priv.h"
>  
>  kmem_zone_t *xfs_ifork_zone;
>  
> @@ -320,6 +322,7 @@ xfs_iformat_local(
>  	int		whichfork,
>  	int		size)
>  {
> +	int		error;
>  
>  	/*
>  	 * If the size is unreasonable, then something
> @@ -336,6 +339,12 @@ xfs_iformat_local(
>  		return -EFSCORRUPTED;
>  	}
>  
> +	if (S_ISDIR(VFS_I(ip)->i_mode) && whichfork == XFS_DATA_FORK) {
> +		error = xfs_dir3_inline_check(ip->i_mount, dip, size);
> +		if (error)
> +			return error;
> +	}
> +

I'm wondering if we should do this after the xfs_init_local_fork() call
and perhaps just pass the fully initialized xfs_ifork to the verifier.
The logic being that the memcpy() to and from the disk buffer are
effectively the "write/read" operations of the fork...

>  	xfs_init_local_fork(ip, whichfork, XFS_DFORK_PTR(dip, whichfork), size);
>  	return 0;
>  }
> @@ -856,7 +865,7 @@ xfs_iextents_copy(
>   * In these cases, the format always takes precedence, because the
>   * format indicates the current state of the fork.
>   */
> -void
> +int
>  xfs_iflush_fork(
>  	xfs_inode_t		*ip,
>  	xfs_dinode_t		*dip,
> @@ -866,6 +875,7 @@ xfs_iflush_fork(
>  	char			*cp;
>  	xfs_ifork_t		*ifp;
>  	xfs_mount_t		*mp;
> +	int			error;
>  	static const short	brootflag[2] =
>  		{ XFS_ILOG_DBROOT, XFS_ILOG_ABROOT };
>  	static const short	dataflag[2] =
> @@ -874,7 +884,7 @@ xfs_iflush_fork(
>  		{ XFS_ILOG_DEXT, XFS_ILOG_AEXT };
>  
>  	if (!iip)
> -		return;
> +		return 0;
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	/*
>  	 * This can happen if we gave up in iformat in an error path,
> @@ -882,7 +892,7 @@ xfs_iflush_fork(
>  	 */
>  	if (!ifp) {
>  		ASSERT(whichfork == XFS_ATTR_FORK);
> -		return;
> +		return 0;
>  	}
>  	cp = XFS_DFORK_PTR(dip, whichfork);
>  	mp = ip->i_mount;
> @@ -894,6 +904,11 @@ xfs_iflush_fork(
>  			ASSERT(ifp->if_bytes <= XFS_IFORK_SIZE(ip, whichfork));
>  			memcpy(cp, ifp->if_u1.if_data, ifp->if_bytes);
>  		}
> +		if (S_ISDIR(VFS_I(ip)->i_mode) && whichfork == XFS_DATA_FORK) {
> +			error = xfs_dir3_inline_check(mp, dip, ifp->if_bytes);
> +			if (error)
> +				return error;
> +		}

... and thus similarly here, with the verifier before the "write" to the
buffer and perhaps only when the data fork has been modified (and hence
the "write" actually occurs).

Then again, it might be prudent to run it even when only the core inode
has changed. I'm not really tied to either way I guess.

Brian

>  		break;
>  
>  	case XFS_DINODE_FMT_EXTENTS:
> @@ -940,6 +955,7 @@ xfs_iflush_fork(
>  		ASSERT(0);
>  		break;
>  	}
> +	return 0;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 7fb8365..132dc59 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -140,7 +140,7 @@ typedef struct xfs_ifork {
>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
>  
>  int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
> -void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
> +int		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
>  				struct xfs_inode_log_item *, int);
>  void		xfs_idestroy_fork(struct xfs_inode *, int);
>  void		xfs_idata_realloc(struct xfs_inode *, int, int);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7eaf1ef..c7fe2c2 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3475,6 +3475,7 @@ xfs_iflush_int(
>  	struct xfs_inode_log_item *iip = ip->i_itemp;
>  	struct xfs_dinode	*dip;
>  	struct xfs_mount	*mp = ip->i_mount;
> +	int			error;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
>  	ASSERT(xfs_isiflocked(ip));
> @@ -3557,9 +3558,14 @@ xfs_iflush_int(
>  	if (ip->i_d.di_flushiter == DI_MAX_FLUSH)
>  		ip->i_d.di_flushiter = 0;
>  
> -	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
> -	if (XFS_IFORK_Q(ip))
> -		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK);
> +	error = xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
> +	if (error)
> +		return error;
> +	if (XFS_IFORK_Q(ip)) {
> +		error = xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK);
> +		if (error)
> +			return error;
> +	}
>  	xfs_inobp_check(mp, bp);
>  
>  	/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

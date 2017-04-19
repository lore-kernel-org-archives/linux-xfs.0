Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34232 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939247AbdDSUR4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 16:17:56 -0400
Date: Wed, 19 Apr 2017 13:17:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: simplify validation of the unwritten extent bit
Message-ID: <20170419201751.GM5193@birch.djwong.org>
References: <20170419192904.22203-1-hch@lst.de>
 <20170419192904.22203-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170419192904.22203-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 19, 2017 at 09:29:04PM +0200, Christoph Hellwig wrote:
> XFS only supports the unwritten extent bit in the data fork, and only if
> the file system has a version 5 superblock or the unwritten extent
> feature bit.
> 
> We currently have two routines that validate the invariant:
> xfs_check_nostate_extents which return -EFSCORRUPTED when it's not met,
> and xfs_validate_extent that triggers and assert in debug build.
> 
> Both of them iterate over all extents of an inode fork when called,
> which isn't very efficient.
> 
> This patch instead adds a new helper that verifies the invariant one
> extent at a time, and calls it from the places where we iterate over
> all extents to converted them from or two the in-memory format.  The
> callers then return -EFSCORRUPTED when reading invalid extents from
> disk, or trigger an assert when writing them to disk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 16 +-------
>  fs/xfs/libxfs/xfs_bmap.h       |  2 -
>  fs/xfs/libxfs/xfs_bmap_btree.c | 26 ------------
>  fs/xfs/libxfs/xfs_bmap_btree.h | 21 ++++++----
>  fs/xfs/libxfs/xfs_format.h     |  8 ----
>  fs/xfs/libxfs/xfs_inode_fork.c | 90 ++++++++++++------------------------------
>  6 files changed, 41 insertions(+), 122 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 9bd104f32908..ad5ae571f74f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1260,7 +1260,6 @@ xfs_bmap_read_extents(
>  	xfs_fsblock_t		bno;	/* block # of "block" */
>  	xfs_buf_t		*bp;	/* buffer for "block" */
>  	int			error;	/* error return value */
> -	xfs_exntfmt_t		exntf;	/* XFS_EXTFMT_NOSTATE, if checking */
>  	xfs_extnum_t		i, j;	/* index into the extents list */
>  	xfs_ifork_t		*ifp;	/* fork structure */
>  	int			level;	/* btree level, for checking */
> @@ -1271,8 +1270,6 @@ xfs_bmap_read_extents(
>  
>  	mp = ip->i_mount;
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	exntf = (whichfork != XFS_DATA_FORK) ? XFS_EXTFMT_NOSTATE :
> -					XFS_EXTFMT_INODE(ip);
>  	block = ifp->if_broot;
>  	/*
>  	 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
> @@ -1340,18 +1337,9 @@ xfs_bmap_read_extents(
>  			xfs_bmbt_rec_host_t *trp = xfs_iext_get_ext(ifp, i);
>  			trp->l0 = be64_to_cpu(frp->l0);
>  			trp->l1 = be64_to_cpu(frp->l1);
> -		}
> -		if (exntf == XFS_EXTFMT_NOSTATE) {
> -			/*
> -			 * Check all attribute bmap btree records and
> -			 * any "older" data bmap btree records for a
> -			 * set bit in the "extent flag" position.
> -			 */
> -			if (unlikely(xfs_check_nostate_extents(ifp,
> -					start, num_recs))) {
> +			if (!xfs_bmbt_validate_extent(mp, whichfork, trp)) {
>  				XFS_ERROR_REPORT("xfs_bmap_read_extents(2)",
> -						 XFS_ERRLEVEL_LOW,
> -						 ip->i_mount);
> +						 XFS_ERRLEVEL_LOW, mp);
>  				goto error0;
>  			}
>  		}
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index a6e612cabe15..c35a14fa1527 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -244,8 +244,6 @@ int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
>  		struct xfs_bmbt_irec *del);
>  void	xfs_bmap_del_extent_cow(struct xfs_inode *ip, xfs_extnum_t *idx,
>  		struct xfs_bmbt_irec *got, struct xfs_bmbt_irec *del);
> -int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
> -		xfs_extnum_t num);
>  uint	xfs_default_attroffset(struct xfs_inode *ip);
>  int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index fd55db479385..a5d34a37f314 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -366,32 +366,6 @@ xfs_bmbt_to_bmdr(
>  	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
>  }
>  
> -/*
> - * Check extent records, which have just been read, for
> - * any bit in the extent flag field. ASSERT on debug
> - * kernels, as this condition should not occur.
> - * Return an error condition (1) if any flags found,
> - * otherwise return 0.
> - */
> -
> -int
> -xfs_check_nostate_extents(
> -	xfs_ifork_t		*ifp,
> -	xfs_extnum_t		idx,
> -	xfs_extnum_t		num)
> -{
> -	for (; num > 0; num--, idx++) {
> -		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, idx);
> -		if ((ep->l0 >>
> -		     (64 - BMBT_EXNTFLAG_BITLEN)) != 0) {
> -			ASSERT(0);
> -			return 1;
> -		}
> -	}
> -	return 0;
> -}
> -
> -
>  STATIC struct xfs_btree_cur *
>  xfs_bmbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
> index 90347a99c6d2..9da5a8d4f184 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.h
> @@ -25,13 +25,6 @@ struct xfs_inode;
>  struct xfs_trans;
>  
>  /*
> - * Extent state and extent format macros.
> - */
> -#define XFS_EXTFMT_INODE(x)	\
> -	(xfs_sb_version_hasextflgbit(&((x)->i_mount->m_sb)) ? \
> -		XFS_EXTFMT_HASSTATE : XFS_EXTFMT_NOSTATE)
> -
> -/*
>   * Btree block header size depends on a superblock flag.
>   */
>  #define XFS_BMBT_BLOCK_LEN(mp) \
> @@ -139,4 +132,18 @@ extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
>  extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
>  		struct xfs_trans *, struct xfs_inode *, int);
>  
> +/*
> + * Check that the extent does not contain an invalid unwritten extent flag.
> + */
> +static inline bool xfs_bmbt_validate_extent(struct xfs_mount *mp, int whichfork,
> +		struct xfs_bmbt_rec_host *ep)

Would be nice to have this function formatted the same way as most of
the rest of the xfs functions, even if it is static inline...

> +{
> +	if (ep->l0 >> (64 - BMBT_EXNTFLAG_BITLEN) == 0)
> +		return true;
> +	if (whichfork == XFS_DATA_FORK &&
> +	    xfs_sb_version_hasextflgbit(&mp->m_sb))
> +		return true;
> +	return false;
> +}
> +
>  #endif	/* __XFS_BMAP_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 8425884668a8..a1dccd8d96bc 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1576,14 +1576,6 @@ static inline xfs_filblks_t startblockval(xfs_fsblock_t x)
>  }
>  
>  /*
> - * Possible extent formats.
> - */
> -typedef enum {
> -	XFS_EXTFMT_NOSTATE = 0,
> -	XFS_EXTFMT_HASSTATE
> -} xfs_exntfmt_t;
> -
> -/*
>   * Possible extent states.
>   */
>  typedef enum {
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 8a37efe04de3..0e80f34fe97c 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -42,35 +42,6 @@ STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
>  STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
>  STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
>  
> -#ifdef DEBUG
> -/*
> - * Make sure that the extents in the given memory buffer
> - * are valid.
> - */
> -void
> -xfs_validate_extents(
> -	xfs_ifork_t		*ifp,
> -	int			nrecs,
> -	xfs_exntfmt_t		fmt)
> -{
> -	xfs_bmbt_irec_t		irec;
> -	xfs_bmbt_rec_host_t	rec;
> -	int			i;
> -
> -	for (i = 0; i < nrecs; i++) {
> -		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
> -		rec.l0 = get_unaligned(&ep->l0);
> -		rec.l1 = get_unaligned(&ep->l1);
> -		xfs_bmbt_get_all(&rec, &irec);
> -		if (fmt == XFS_EXTFMT_NOSTATE)
> -			ASSERT(irec.br_state == XFS_EXT_NORM);
> -	}
> -}
> -#else /* DEBUG */
> -#define xfs_validate_extents(ifp, nrecs, fmt)
> -#endif /* DEBUG */
> -
> -
>  /*
>   * Move inode type and inode format specific information from the
>   * on-disk inode to the in-core inode.  For fifos, devs, and sockets
> @@ -352,40 +323,33 @@ xfs_iformat_local(
>  }
>  
>  /*
> - * The file consists of a set of extents all
> - * of which fit into the on-disk inode.
> - * If there are few enough extents to fit into
> - * the if_inline_ext, then copy them there.
> - * Otherwise allocate a buffer for them and copy
> - * them into it.  Either way, set if_extents
> - * to point at the extents.
> + * The file consists of a set of extents all of which fit into the on-disk
> + * inode.  If there are few enough extents to fit into the if_inline_ext, then
> + * copy them there.  Otherwise allocate a buffer for them and copy them into it.
> + * Either way, set if_extents to point at the extents.
>   */
>  STATIC int
>  xfs_iformat_extents(
> -	xfs_inode_t	*ip,
> -	xfs_dinode_t	*dip,
> -	int		whichfork)
> +	struct xfs_inode	*ip,
> +	struct xfs_dinode	*dip,
> +	int			whichfork)
>  {
> -	xfs_bmbt_rec_t	*dp;
> -	xfs_ifork_t	*ifp;
> -	int		nex;
> -	int		size;
> -	int		i;
> -
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> -	size = nex * (uint)sizeof(xfs_bmbt_rec_t);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	int			size = nex * sizeof(xfs_bmbt_rec_t);
> +	struct xfs_bmbt_rec	*dp;
> +	int			i;
>  
>  	/*
> -	 * If the number of extents is unreasonable, then something
> -	 * is wrong and we just bail out rather than crash in
> -	 * kmem_alloc() or memcpy() below.
> +	 * If the number of extents is unreasonable, then something is wrong and
> +	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
>  	 */
> -	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
> +	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
>  		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
>  			(unsigned long long) ip->i_ino, nex);
>  		XFS_CORRUPTION_ERROR("xfs_iformat_extents(1)", XFS_ERRLEVEL_LOW,
> -				     ip->i_mount, dip);
> +				     mp, dip);
>  		return -EFSCORRUPTED;
>  	}
>  
> @@ -400,22 +364,17 @@ xfs_iformat_extents(
>  	ifp->if_bytes = size;
>  	if (size) {
>  		dp = (xfs_bmbt_rec_t *) XFS_DFORK_PTR(dip, whichfork);
> -		xfs_validate_extents(ifp, nex, XFS_EXTFMT_INODE(ip));
>  		for (i = 0; i < nex; i++, dp++) {
>  			xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
>  			ep->l0 = get_unaligned_be64(&dp->l0);
>  			ep->l1 = get_unaligned_be64(&dp->l1);
> +			if (!xfs_bmbt_validate_extent(mp, whichfork, ep)) {
> +				XFS_ERROR_REPORT("xfs_iformat_extents(2)",
> +						 XFS_ERRLEVEL_LOW, mp);
> +				return -EFSCORRUPTED;
> +			}
>  		}
>  		XFS_BMAP_TRACE_EXLIST(ip, nex, whichfork);
> -		if (whichfork != XFS_DATA_FORK ||
> -			XFS_EXTFMT_INODE(ip) == XFS_EXTFMT_NOSTATE)
> -				if (unlikely(xfs_check_nostate_extents(
> -				    ifp, 0, nex))) {
> -					XFS_ERROR_REPORT("xfs_iformat_extents(2)",
> -							 XFS_ERRLEVEL_LOW,
> -							 ip->i_mount);
> -					return -EFSCORRUPTED;
> -				}
>  	}
>  	ifp->if_flags |= XFS_IFEXTENTS;
>  	return 0;
> @@ -518,7 +477,6 @@ xfs_iread_extents(
>  		xfs_iext_destroy(ifp);
>  		return error;
>  	}
> -	xfs_validate_extents(ifp, nextents, XFS_EXTFMT_INODE(ip));
>  	ifp->if_flags |= XFS_IFEXTENTS;
>  	return 0;
>  }
> @@ -837,6 +795,9 @@ xfs_iextents_copy(
>  	copied = 0;
>  	for (i = 0; i < nrecs; i++) {
>  		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
> +
> +		ASSERT(xfs_bmbt_validate_extent(ip->i_mount, whichfork, ep));

Wouldn't this be better off in xfs_iflush_int (like the inline dir
verifier) since we could prevent bad metadata from hitting the disk?
Rather than this, which doesn't do anything on non-debug kernels.

OTOH I guess we don't do any verification of the records getting written
to the bmbt leaves either...

--D

> +
>  		start_block = xfs_bmbt_get_startblock(ep);
>  		if (isnullstartblock(start_block)) {
>  			/*
> @@ -852,7 +813,6 @@ xfs_iextents_copy(
>  		copied++;
>  	}
>  	ASSERT(copied != 0);
> -	xfs_validate_extents(ifp, copied, XFS_EXTFMT_INODE(ip));
>  
>  	return (copied * (uint)sizeof(xfs_bmbt_rec_t));
>  }
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

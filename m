Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33764 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732562AbeGKQ2g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jul 2018 12:28:36 -0400
Date: Wed, 11 Jul 2018 09:23:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/6] xfs: remove the xfs_ifork_t typedef
Message-ID: <20180711162325.GC32415@magnolia>
References: <20180710060528.4071-1-hch@lst.de>
 <20180710060528.4071-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180710060528.4071-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 10, 2018 at 08:05:25AM +0200, Christoph Hellwig wrote:
> We only have a few more callers left, so seize the opportunity and kill
> it off.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Wooooooo!

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  8 ++++----
>  fs/xfs/libxfs/xfs_bmap.c       | 20 ++++++++++----------
>  fs/xfs/libxfs/xfs_inode_fork.c |  8 ++++----
>  fs/xfs/libxfs/xfs_inode_fork.h |  4 ++--
>  fs/xfs/xfs_icache.c            |  2 +-
>  fs/xfs/xfs_inode.h             |  6 +++---
>  fs/xfs/xfs_super.c             |  2 +-
>  7 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 76e90046731c..3030fba4785c 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -506,7 +506,7 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
>  {
>  	xfs_attr_sf_hdr_t *hdr;
>  	xfs_inode_t *dp;
> -	xfs_ifork_t *ifp;
> +	struct xfs_ifork *ifp;
>  
>  	trace_xfs_attr_sf_create(args);
>  
> @@ -541,7 +541,7 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>  	int i, offset, size;
>  	xfs_mount_t *mp;
>  	xfs_inode_t *dp;
> -	xfs_ifork_t *ifp;
> +	struct xfs_ifork *ifp;
>  
>  	trace_xfs_attr_sf_add(args);
>  
> @@ -682,7 +682,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
>  	xfs_attr_shortform_t *sf;
>  	xfs_attr_sf_entry_t *sfe;
>  	int i;
> -	xfs_ifork_t *ifp;
> +	struct xfs_ifork *ifp;
>  
>  	trace_xfs_attr_sf_lookup(args);
>  
> @@ -758,7 +758,7 @@ xfs_attr_shortform_to_leaf(
>  	int error, i, size;
>  	xfs_dablk_t blkno;
>  	struct xfs_buf *bp;
> -	xfs_ifork_t *ifp;
> +	struct xfs_ifork *ifp;
>  
>  	trace_xfs_attr_sf_to_leaf(args);
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 68ea1f4b9c3f..7ac8f90bd218 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -326,7 +326,7 @@ xfs_bmap_check_leaf_extents(
>  	xfs_buf_t		*bp;	/* buffer for "block" */
>  	int			error;	/* error return value */
>  	xfs_extnum_t		i=0, j;	/* index into the extents list */
> -	xfs_ifork_t		*ifp;	/* fork structure */
> +	struct xfs_ifork	*ifp;	/* fork structure */
>  	int			level;	/* btree level, for checking */
>  	xfs_mount_t		*mp;	/* file system mount structure */
>  	__be64			*pp;	/* pointer to block address */
> @@ -594,7 +594,7 @@ xfs_bmap_btree_to_extents(
>  	xfs_fsblock_t		cbno;	/* child block number */
>  	xfs_buf_t		*cbp;	/* child block's buffer */
>  	int			error;	/* error return value */
> -	xfs_ifork_t		*ifp;	/* inode fork data */
> +	struct xfs_ifork	*ifp;	/* inode fork data */
>  	xfs_mount_t		*mp;	/* mount point structure */
>  	__be64			*pp;	/* ptr to block address */
>  	struct xfs_btree_block	*rblock;/* root btree block */
> @@ -660,7 +660,7 @@ xfs_bmap_extents_to_btree(
>  	struct xfs_btree_block	*block;		/* btree root block */
>  	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
>  	int			error;		/* error return value */
> -	xfs_ifork_t		*ifp;		/* inode fork pointer */
> +	struct xfs_ifork	*ifp;		/* inode fork pointer */
>  	xfs_bmbt_key_t		*kp;		/* root block key pointer */
>  	xfs_mount_t		*mp;		/* mount structure */
>  	xfs_bmbt_ptr_t		*pp;		/* root block address pointer */
> @@ -823,7 +823,7 @@ xfs_bmap_local_to_extents(
>  {
>  	int		error = 0;
>  	int		flags;		/* logging flags returned */
> -	xfs_ifork_t	*ifp;		/* inode fork pointer */
> +	struct xfs_ifork *ifp;		/* inode fork pointer */
>  	xfs_alloc_arg_t	args;		/* allocation arguments */
>  	xfs_buf_t	*bp;		/* buffer for extent block */
>  	struct xfs_bmbt_irec rec;
> @@ -1501,7 +1501,7 @@ xfs_bmap_one_block(
>  	xfs_inode_t	*ip,		/* incore inode */
>  	int		whichfork)	/* data or attr fork */
>  {
> -	xfs_ifork_t	*ifp;		/* inode fork pointer */
> +	struct xfs_ifork *ifp;		/* inode fork pointer */
>  	int		rval;		/* return value */
>  	xfs_bmbt_irec_t	s;		/* internal version of extent */
>  	struct xfs_iext_cursor icur;
> @@ -1539,7 +1539,7 @@ xfs_bmap_add_extent_delay_real(
>  	struct xfs_bmbt_irec	*new = &bma->got;
>  	int			error;	/* error return value */
>  	int			i;	/* temp state */
> -	xfs_ifork_t		*ifp;	/* inode fork pointer */
> +	struct xfs_ifork	*ifp;	/* inode fork pointer */
>  	xfs_fileoff_t		new_endoff;	/* end offset of new entry */
>  	xfs_bmbt_irec_t		r[3];	/* neighbor extent entries */
>  					/* left is 0, right is 1, prev is 2 */
> @@ -2053,7 +2053,7 @@ xfs_bmap_add_extent_unwritten_real(
>  	xfs_btree_cur_t		*cur;	/* btree cursor */
>  	int			error;	/* error return value */
>  	int			i;	/* temp state */
> -	xfs_ifork_t		*ifp;	/* inode fork pointer */
> +	struct xfs_ifork	*ifp;	/* inode fork pointer */
>  	xfs_fileoff_t		new_endoff;	/* end offset of new entry */
>  	xfs_bmbt_irec_t		r[3];	/* neighbor extent entries */
>  					/* left is 0, right is 1, prev is 2 */
> @@ -2520,7 +2520,7 @@ xfs_bmap_add_extent_hole_delay(
>  	struct xfs_iext_cursor	*icur,
>  	xfs_bmbt_irec_t		*new)	/* new data to add to file extents */
>  {
> -	xfs_ifork_t		*ifp;	/* inode fork pointer */
> +	struct xfs_ifork	*ifp;	/* inode fork pointer */
>  	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
>  	xfs_filblks_t		newlen=0;	/* new indirect size */
>  	xfs_filblks_t		oldlen=0;	/* old indirect size */
> @@ -4911,7 +4911,7 @@ xfs_bmap_del_extent_real(
>  	struct xfs_bmbt_irec	got;	/* current extent entry */
>  	xfs_fileoff_t		got_endoff;	/* first offset past got */
>  	int			i;	/* temp state */
> -	xfs_ifork_t		*ifp;	/* inode fork pointer */
> +	struct xfs_ifork	*ifp;	/* inode fork pointer */
>  	xfs_mount_t		*mp;	/* mount structure */
>  	xfs_filblks_t		nblks;	/* quota/sb block count */
>  	xfs_bmbt_irec_t		new;	/* new record to be inserted */
> @@ -5161,7 +5161,7 @@ __xfs_bunmapi(
>  	int			error;		/* error return value */
>  	xfs_extnum_t		extno;		/* extent number in list */
>  	xfs_bmbt_irec_t		got;		/* current extent record */
> -	xfs_ifork_t		*ifp;		/* inode fork pointer */
> +	struct xfs_ifork	*ifp;		/* inode fork pointer */
>  	int			isrt;		/* freeing in rt area */
>  	int			logflags;	/* transaction logging flags */
>  	xfs_extlen_t		mod;		/* rt extent offset */
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index a0e3fb804605..f9acf1d436f6 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -269,7 +269,7 @@ xfs_iformat_btree(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_bmdr_block_t	*dfp;
> -	xfs_ifork_t		*ifp;
> +	struct xfs_ifork	*ifp;
>  	/* REFERENCED */
>  	int			nrecs;
>  	int			size;
> @@ -347,7 +347,7 @@ xfs_iroot_realloc(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			cur_max;
> -	xfs_ifork_t		*ifp;
> +	struct xfs_ifork	*ifp;
>  	struct xfs_btree_block	*new_broot;
>  	int			new_max;
>  	size_t			new_size;
> @@ -503,7 +503,7 @@ xfs_idestroy_fork(
>  	xfs_inode_t	*ip,
>  	int		whichfork)
>  {
> -	xfs_ifork_t	*ifp;
> +	struct xfs_ifork	*ifp;
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	if (ifp->if_broot != NULL) {
> @@ -592,7 +592,7 @@ xfs_iflush_fork(
>  	int			whichfork)
>  {
>  	char			*cp;
> -	xfs_ifork_t		*ifp;
> +	struct xfs_ifork	*ifp;
>  	xfs_mount_t		*mp;
>  	static const short	brootflag[2] =
>  		{ XFS_ILOG_DBROOT, XFS_ILOG_ABROOT };
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 46242052aad0..1492143371f3 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -12,7 +12,7 @@ struct xfs_dinode;
>  /*
>   * File incore extent information, present for each of data & attr forks.
>   */
> -typedef struct xfs_ifork {
> +struct xfs_ifork {
>  	int			if_bytes;	/* bytes in if_u1 */
>  	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
>  	short			if_broot_bytes;	/* bytes allocated for root */
> @@ -22,7 +22,7 @@ typedef struct xfs_ifork {
>  		void		*if_root;	/* extent tree root */
>  		char		*if_data;	/* inline file data */
>  	} if_u1;
> -} xfs_ifork_t;
> +};
>  
>  /*
>   * Per-fork incore inode flags.
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 47f417d20a30..79f344fa8b14 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -66,7 +66,7 @@ xfs_inode_alloc(
>  	ip->i_cowfp = NULL;
>  	ip->i_cnextents = 0;
>  	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
> -	memset(&ip->i_df, 0, sizeof(xfs_ifork_t));
> +	memset(&ip->i_df, 0, sizeof(ip->i_df));
>  	ip->i_flags = 0;
>  	ip->i_delayed_blks = 0;
>  	memset(&ip->i_d, 0, sizeof(ip->i_d));
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 2ed63a49e890..1f910d2ae73a 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -34,9 +34,9 @@ typedef struct xfs_inode {
>  	struct xfs_imap		i_imap;		/* location for xfs_imap() */
>  
>  	/* Extent information. */
> -	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
> -	xfs_ifork_t		*i_cowfp;	/* copy on write extents */
> -	xfs_ifork_t		i_df;		/* data fork */
> +	struct xfs_ifork	*i_afp;		/* attribute fork pointer */
> +	struct xfs_ifork	*i_cowfp;	/* copy on write extents */
> +	struct xfs_ifork	i_df;		/* data fork */
>  
>  	/* operations vectors */
>  	const struct xfs_dir_ops *d_ops;		/* directory ops vector */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f9f8dc490d3d..62312b4cef64 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1886,7 +1886,7 @@ xfs_init_zones(void)
>  	if (!xfs_da_state_zone)
>  		goto out_destroy_btree_cur_zone;
>  
> -	xfs_ifork_zone = kmem_zone_init(sizeof(xfs_ifork_t), "xfs_ifork");
> +	xfs_ifork_zone = kmem_zone_init(sizeof(struct xfs_ifork), "xfs_ifork");
>  	if (!xfs_ifork_zone)
>  		goto out_destroy_da_state_zone;
>  
> -- 
> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

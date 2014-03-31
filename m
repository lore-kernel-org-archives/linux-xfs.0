Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1F43E7F63
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 08:09:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 016448F8037
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 06:09:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ATIL4hWIQaWblfMh for
	<xfs@oss.sgi.com>; Mon, 31 Mar 2014 06:09:35 -0700 (PDT)
Date: Mon, 31 Mar 2014 09:09:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: remove unused transaction pointer args
Message-ID: <20140331130932.GA63718@bfoster.bfoster>
References: <53362976.3060101@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53362976.3060101@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Mar 28, 2014 at 09:01:26PM -0500, Eric Sandeen wrote:
> Several functions pass a transaction pointer around,
> but it's never used in those callchains.  Remove it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 152543c..b308097 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -1675,7 +1675,6 @@ xfs_bmap_isaeof(
>   */
>  int
>  xfs_bmap_last_offset(
> -	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	xfs_fileoff_t		*last_block,
>  	int			whichfork)

Seems Ok to me, but it looks like you could also kill the tp param for
xfs_bmap_last_extent(). I don't see any callers that don't pass NULL...

Brian

> diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
> index 33b41f3..52ad38d 100644
> --- a/fs/xfs/xfs_bmap.h
> +++ b/fs/xfs/xfs_bmap.h
> @@ -146,8 +146,8 @@ int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
>  int	xfs_bmap_last_before(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t *last_block, int whichfork);
> -int	xfs_bmap_last_offset(struct xfs_trans *tp, struct xfs_inode *ip,
> -		xfs_fileoff_t *unused, int whichfork);
> +int	xfs_bmap_last_offset(struct xfs_inode *ip, xfs_fileoff_t *unused,
> +		int whichfork);
>  int	xfs_bmap_one_block(struct xfs_inode *ip, int whichfork);
>  int	xfs_bmap_read_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>  		int whichfork);
> diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
> index ce16ef0..7575a3b 100644
> --- a/fs/xfs/xfs_dir2.c
> +++ b/fs/xfs/xfs_dir2.c
> @@ -230,11 +230,11 @@ xfs_dir_createname(
>  
>  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
>  		rval = xfs_dir2_sf_addname(&args);
> -	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
> +	else if ((rval = xfs_dir2_isblock(dp, &v)))
>  		return rval;
>  	else if (v)
>  		rval = xfs_dir2_block_addname(&args);
> -	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
> +	else if ((rval = xfs_dir2_isleaf(dp, &v)))
>  		return rval;
>  	else if (v)
>  		rval = xfs_dir2_leaf_addname(&args);
> @@ -303,11 +303,11 @@ xfs_dir_lookup(
>  
>  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
>  		rval = xfs_dir2_sf_lookup(&args);
> -	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
> +	else if ((rval = xfs_dir2_isblock(dp, &v)))
>  		return rval;
>  	else if (v)
>  		rval = xfs_dir2_block_lookup(&args);
> -	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
> +	else if ((rval = xfs_dir2_isleaf(dp, &v)))
>  		return rval;
>  	else if (v)
>  		rval = xfs_dir2_leaf_lookup(&args);
> @@ -360,11 +360,11 @@ xfs_dir_removename(
>  
>  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
>  		rval = xfs_dir2_sf_removename(&args);
> -	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
> +	else if ((rval = xfs_dir2_isblock(dp, &v)))
>  		return rval;
>  	else if (v)
>  		rval = xfs_dir2_block_removename(&args);
> -	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
> +	else if ((rval = xfs_dir2_isleaf(dp, &v)))
>  		return rval;
>  	else if (v)
>  		rval = xfs_dir2_leaf_removename(&args);
> @@ -410,11 +410,11 @@ xfs_dir_replace(
>  
>  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
>  		rval = xfs_dir2_sf_replace(&args);
> -	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
> +	else if ((rval = xfs_dir2_isblock(dp, &v)))
>  		return rval;
>  	else if (v)
>  		rval = xfs_dir2_block_replace(&args);
> -	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
> +	else if ((rval = xfs_dir2_isleaf(dp, &v)))
>  		return rval;
>  	else if (v)
>  		rval = xfs_dir2_leaf_replace(&args);
> @@ -456,11 +456,11 @@ xfs_dir_canenter(
>  
>  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
>  		rval = xfs_dir2_sf_addname(&args);
> -	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
> +	else if ((rval = xfs_dir2_isblock(dp, &v)))
>  		return rval;
>  	else if (v)
>  		rval = xfs_dir2_block_addname(&args);
> -	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
> +	else if ((rval = xfs_dir2_isleaf(dp, &v)))
>  		return rval;
>  	else if (v)
>  		rval = xfs_dir2_leaf_addname(&args);
> @@ -525,7 +525,6 @@ xfs_dir2_grow_inode(
>   */
>  int
>  xfs_dir2_isblock(
> -	xfs_trans_t	*tp,
>  	xfs_inode_t	*dp,
>  	int		*vp)		/* out: 1 is block, 0 is not block */
>  {
> @@ -534,7 +533,7 @@ xfs_dir2_isblock(
>  	int		rval;
>  
>  	mp = dp->i_mount;
> -	if ((rval = xfs_bmap_last_offset(tp, dp, &last, XFS_DATA_FORK)))
> +	if ((rval = xfs_bmap_last_offset(dp, &last, XFS_DATA_FORK)))
>  		return rval;
>  	rval = XFS_FSB_TO_B(mp, last) == mp->m_dirblksize;
>  	ASSERT(rval == 0 || dp->i_d.di_size == mp->m_dirblksize);
> @@ -547,7 +546,6 @@ xfs_dir2_isblock(
>   */
>  int
>  xfs_dir2_isleaf(
> -	xfs_trans_t	*tp,
>  	xfs_inode_t	*dp,
>  	int		*vp)		/* out: 1 is leaf, 0 is not leaf */
>  {
> @@ -556,7 +554,7 @@ xfs_dir2_isleaf(
>  	int		rval;
>  
>  	mp = dp->i_mount;
> -	if ((rval = xfs_bmap_last_offset(tp, dp, &last, XFS_DATA_FORK)))
> +	if ((rval = xfs_bmap_last_offset(dp, &last, XFS_DATA_FORK)))
>  		return rval;
>  	*vp = last == mp->m_dirleafblk + (1 << mp->m_sb.sb_dirblklog);
>  	return 0;
> diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
> index cec70e0..64a6b19 100644
> --- a/fs/xfs/xfs_dir2.h
> +++ b/fs/xfs/xfs_dir2.h
> @@ -142,8 +142,8 @@ extern int xfs_dir2_sf_to_block(struct xfs_da_args *args);
>  /*
>   * Interface routines used by userspace utilities
>   */
> -extern int xfs_dir2_isblock(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
> -extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
> +extern int xfs_dir2_isblock(struct xfs_inode *dp, int *r);
> +extern int xfs_dir2_isleaf(struct xfs_inode *dp, int *r);
>  extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
>  				struct xfs_buf *bp);
>  
> diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
> index ae47ec6..f8170bc 100644
> --- a/fs/xfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/xfs_dir2_leaf.c
> @@ -1707,7 +1707,7 @@ xfs_dir2_node_to_leaf(
>  	/*
>  	 * Get the last offset in the file.
>  	 */
> -	if ((error = xfs_bmap_last_offset(tp, dp, &fo, XFS_DATA_FORK))) {
> +	if ((error = xfs_bmap_last_offset(dp, &fo, XFS_DATA_FORK))) {
>  		return error;
>  	}
>  	fo -= mp->m_dirblkfsbs;
> diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
> index 48c7d18..807946d 100644
> --- a/fs/xfs/xfs_dir2_node.c
> +++ b/fs/xfs/xfs_dir2_node.c
> @@ -1726,7 +1726,7 @@ xfs_dir2_node_addname_int(
>  	if (dbno == -1) {
>  		xfs_fileoff_t	fo;		/* freespace block number */
>  
> -		if ((error = xfs_bmap_last_offset(tp, dp, &fo, XFS_DATA_FORK)))
> +		if ((error = xfs_bmap_last_offset(dp, &fo, XFS_DATA_FORK)))
>  			return error;
>  		lastfbno = xfs_dir2_da_to_db(mp, (xfs_dablk_t)fo);
>  		fbno = ifbno;
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index aead369..a18000f 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -687,7 +687,7 @@ xfs_readdir(
>  	lock_mode = xfs_ilock_data_map_shared(dp);
>  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
>  		rval = xfs_dir2_sf_getdents(dp, ctx);
> -	else if ((rval = xfs_dir2_isblock(NULL, dp, &v)))
> +	else if ((rval = xfs_dir2_isblock(dp, &v)))
>  		;
>  	else if (v)
>  		rval = xfs_dir2_block_getdents(dp, ctx);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 22d1cbe..2b2739c 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -734,7 +734,7 @@ xfs_iomap_write_allocate(
>  			 */
>  			nimaps = 1;
>  			end_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
> -			error = xfs_bmap_last_offset(NULL, ip, &last_block,
> +			error = xfs_bmap_last_offset(ip, &last_block,
>  							XFS_DATA_FORK);
>  			if (error)
>  				goto trans_cancel;
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

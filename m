Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q06GwLa0030394 for <xfs@oss.sgi.com>; Fri, 6 Jan 2012 10:58:22 -0600
Date: Fri, 6 Jan 2012 10:58:18 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 04/11] xfs: remove the if_ext_max field in struct xfs_ifork
Message-ID: <20120106165818.GD6390@sgi.com>
References: <20111218200003.557507716@bombadil.infradead.org>
	<20111218200131.321997628@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218200131.321997628@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Dec 18, 2011 at 03:00:07PM -0500, Christoph Hellwig wrote:
> We spent a lot of effort to maintain this field, but it always equalts to the
								 equals the
> fork size divided by the constant size of an extent.  The prime use of it is
> to assert that the two stay in sync.  Just divide the fork size by the extent
> size in the few places that we actually use it and remove the overhead
> of maintaining it.  Also introduce a few helpers to consolidate the places
> where we actually care about the value.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

After reviewing this patch it's not crystal clear to me why we were
putting all that effort into keeping this counter uptodate on the inode
instead of using helpers like you've implemented.  Maybe a question of
integer division as Dave suggested.  This is a nice improvement.

> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c	2011-12-12 10:33:55.748696870 -0800
> +++ xfs/fs/xfs/xfs_bmap.c	2011-12-14 05:15:20.612373687 -0800
> @@ -249,7 +249,27 @@ xfs_bmbt_lookup_ge(
>  }
>  
>  /*
> -* Update the record referred to by cur to the value given
> + * Check if the inode needs to be converted to btree format.
> + */
> +static inline bool xfs_bmap_needs_btree(struct xfs_inode *ip, int whichfork)
> +{
> +	return XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
> +		XFS_IFORK_NEXTENTS(ip, whichfork) >
> +			XFS_IFORK_MAXEXT(ip, whichfork);
> +}
> +
> +/*
> + * Check if the inode should be converted to extent format.
> + */
> +static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
> +{
> +	return XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
> +		XFS_IFORK_NEXTENTS(ip, whichfork) <=
> +			XFS_IFORK_MAXEXT(ip, whichfork);
> +}

The logic in these two appears to be equivalent to the code you've
replaced in all but one case...

...

> @@ -5321,8 +5318,7 @@ xfs_bunmapi(
>  		 * will be dirty.
>  		 */
>  		if (!wasdel && xfs_trans_get_block_res(tp) == 0 &&
> -		    XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
> -		    XFS_IFORK_NEXTENTS(ip, whichfork) >= ifp->if_ext_max &&
						      ^^ 
All other tests for this were:
XFS_IFORK_NEXTENTS(ip, whichfork) > ifp->if_ext_max

Did you just fix a lurking off-by-one or insert one?

xfs_bmap_needs_btree needs ip->i_d.di_nextents to have been incremented 
already in order to detect that we need to convert to btree format.  In
this case we haven't done that yet and are checking to see if doing so
would require conversion to btree format... 

Looks to me like we can't use xfs_bmap_needs_btree here and should use
the old logic.  Right?

> +		    xfs_bmap_needs_btree(ip, whichfork) &&
>  		    del.br_startoff > got.br_startoff &&
>  		    del.br_startoff + del.br_blockcount <
>  		    got.br_startoff + got.br_blockcount) {

...

> @@ -180,18 +182,25 @@ xfs_swap_extents_check_format(
>  	 * (a common defrag case) which will occur when the temp inode is in
>  	 * extent format...
>  	 */
> -	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
> -	    ((XFS_IFORK_BOFF(ip) &&
> -	      tip->i_df.if_broot_bytes > XFS_IFORK_BOFF(ip)) ||
> -	     XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) <= ip->i_df.if_ext_max))
> -		return EINVAL;
> +	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
> +		if (XFS_IFORK_BOFF(ip) &&
> +		    tip->i_df.if_broot_bytes > XFS_IFORK_BOFF(ip))
> +			return EINVAL;
> +		if (XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) <=
> +		    XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
> +			return EINVAL;
> +	}
>  
>  	/* Reciprocal target->temp btree format checks */
> -	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
> -	    ((XFS_IFORK_BOFF(tip) &&
> -	      ip->i_df.if_broot_bytes > XFS_IFORK_BOFF(tip)) ||
> -	     XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) <= tip->i_df.if_ext_max))
> -		return EINVAL;
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
> +		if (XFS_IFORK_BOFF(tip) &&
> +		    ip->i_df.if_broot_bytes > XFS_IFORK_BOFF(tip))
> +			return EINVAL;
> +
> +		if (XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) <=
> +		    XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
> +			return EINVAL;
> +	}

Good readability improvement.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

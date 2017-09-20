Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36511 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbdITVU5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 17:20:57 -0400
Date: Wed, 20 Sep 2017 14:20:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/19] xfs: use xfs_iext_get_extent instead of open
 coding it
Message-ID: <20170920212053.GJ7112@magnolia>
References: <20170918152422.24345-1-hch@lst.de>
 <20170918152422.24345-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918152422.24345-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 18, 2017 at 08:24:05AM -0700, Christoph Hellwig wrote:
> This avoids exposure to details of the extent list implementation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 36 ++++++++++++++++--------------------
>  fs/xfs/xfs_trace.h       |  2 +-
>  2 files changed, 17 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index f2f5bdb9e092..555ff198e28c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1467,7 +1467,7 @@ xfs_bmap_last_extent(
>  		return 0;
>  	}
>  
> -	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, nextents - 1), rec);
> +	xfs_iext_get_extent(ifp, nextents - 1, rec);
>  	*is_empty = 0;
>  	return 0;
>  }
> @@ -1553,7 +1553,6 @@ xfs_bmap_one_block(
>  	xfs_inode_t	*ip,		/* incore inode */
>  	int		whichfork)	/* data or attr fork */
>  {
> -	xfs_bmbt_rec_host_t *ep;	/* ptr to fork's extent */
>  	xfs_ifork_t	*ifp;		/* inode fork pointer */
>  	int		rval;		/* return value */
>  	xfs_bmbt_irec_t	s;		/* internal version of extent */
> @@ -1568,8 +1567,7 @@ xfs_bmap_one_block(
>  		return 0;
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
> -	ep = xfs_iext_get_ext(ifp, 0);
> -	xfs_bmbt_get_all(ep, &s);
> +	xfs_iext_get_extent(ifp, 0, &s);
>  	rval = s.br_startoff == 0 && s.br_blockcount == 1;
>  	if (rval && whichfork == XFS_DATA_FORK)
>  		ASSERT(XFS_ISIZE(ip) == ip->i_mount->m_sb.sb_blocksize);
> @@ -1655,7 +1653,7 @@ xfs_bmap_add_extent_delay_real(
>  	 */
>  	if (bma->idx > 0) {
>  		state |= BMAP_LEFT_VALID;
> -		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx - 1), &LEFT);
> +		xfs_iext_get_extent(ifp, bma->idx - 1, &LEFT);
>  
>  		if (isnullstartblock(LEFT.br_startblock))
>  			state |= BMAP_LEFT_DELAY;
> @@ -1675,7 +1673,7 @@ xfs_bmap_add_extent_delay_real(
>  	 */
>  	if (bma->idx < xfs_iext_count(ifp) - 1) {
>  		state |= BMAP_RIGHT_VALID;
> -		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx + 1), &RIGHT);
> +		xfs_iext_get_extent(ifp, bma->idx + 1, &RIGHT);
>  
>  		if (isnullstartblock(RIGHT.br_startblock))
>  			state |= BMAP_RIGHT_DELAY;
> @@ -2222,7 +2220,7 @@ xfs_bmap_add_extent_unwritten_real(
>  	 */
>  	if (*idx > 0) {
>  		state |= BMAP_LEFT_VALID;
> -		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx - 1), &LEFT);
> +		xfs_iext_get_extent(ifp, *idx - 1, &LEFT);
>  
>  		if (isnullstartblock(LEFT.br_startblock))
>  			state |= BMAP_LEFT_DELAY;
> @@ -2242,7 +2240,7 @@ xfs_bmap_add_extent_unwritten_real(
>  	 */
>  	if (*idx < xfs_iext_count(ifp) - 1) {
>  		state |= BMAP_RIGHT_VALID;
> -		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx + 1), &RIGHT);
> +		xfs_iext_get_extent(ifp, *idx + 1, &RIGHT);
>  		if (isnullstartblock(RIGHT.br_startblock))
>  			state |= BMAP_RIGHT_DELAY;
>  	}
> @@ -2716,7 +2714,7 @@ xfs_bmap_add_extent_hole_delay(
>  	 */
>  	if (*idx > 0) {
>  		state |= BMAP_LEFT_VALID;
> -		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx - 1), &left);
> +		xfs_iext_get_extent(ifp, *idx - 1, &left);
>  
>  		if (isnullstartblock(left.br_startblock))
>  			state |= BMAP_LEFT_DELAY;
> @@ -2728,7 +2726,7 @@ xfs_bmap_add_extent_hole_delay(
>  	 */
>  	if (*idx < xfs_iext_count(ifp)) {
>  		state |= BMAP_RIGHT_VALID;
> -		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx), &right);
> +		xfs_iext_get_extent(ifp, *idx, &right);
>  
>  		if (isnullstartblock(right.br_startblock))
>  			state |= BMAP_RIGHT_DELAY;
> @@ -2880,7 +2878,7 @@ xfs_bmap_add_extent_hole_real(
>  	 */
>  	if (*idx > 0) {
>  		state |= BMAP_LEFT_VALID;
> -		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx - 1), &left);
> +		xfs_iext_get_extent(ifp, *idx - 1, &left);
>  		if (isnullstartblock(left.br_startblock))
>  			state |= BMAP_LEFT_DELAY;
>  	}
> @@ -2891,7 +2889,7 @@ xfs_bmap_add_extent_hole_real(
>  	 */
>  	if (*idx < xfs_iext_count(ifp)) {
>  		state |= BMAP_RIGHT_VALID;
> -		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx), &right);
> +		xfs_iext_get_extent(ifp, *idx, &right);
>  		if (isnullstartblock(right.br_startblock))
>  			state |= BMAP_RIGHT_DELAY;
>  	}
> @@ -4209,10 +4207,8 @@ xfs_bmapi_allocate(
>  	if (bma->wasdel) {
>  		bma->length = (xfs_extlen_t)bma->got.br_blockcount;
>  		bma->offset = bma->got.br_startoff;
> -		if (bma->idx) {
> -			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx - 1),
> -					 &bma->prev);
> -		}
> +		if (bma->idx)
> +			xfs_iext_get_extent(ifp, bma->idx - 1, &bma->prev);
>  	} else {
>  		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
>  		if (!bma->eof)
> @@ -4309,7 +4305,7 @@ xfs_bmapi_allocate(
>  	 * or xfs_bmap_add_extent_hole_real might have merged it into one of
>  	 * the neighbouring ones.
>  	 */
> -	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx), &bma->got);
> +	xfs_iext_get_extent(ifp, bma->idx, &bma->got);
>  
>  	ASSERT(bma->got.br_startoff <= bma->offset);
>  	ASSERT(bma->got.br_startoff + bma->got.br_blockcount >=
> @@ -4390,7 +4386,7 @@ xfs_bmapi_convert_unwritten(
>  	 * xfs_bmap_add_extent_unwritten_real might have merged it into one
>  	 * of the neighbouring ones.
>  	 */
> -	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx), &bma->got);
> +	xfs_iext_get_extent(ifp, bma->idx, &bma->got);
>  
>  	/*
>  	 * We may have combined previously unwritten space with written space,
> @@ -5589,8 +5585,8 @@ __xfs_bunmapi(
>  					del.br_blockcount : mod;
>  				if (bno < got.br_startoff) {
>  					if (--lastx >= 0)
> -						xfs_bmbt_get_all(xfs_iext_get_ext(
> -							ifp, lastx), &got);
> +						xfs_iext_get_extent(ifp, lastx,
> +								&got);
>  				}
>  				continue;
>  			}
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index bb5514688d47..0a8999a310b9 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -277,7 +277,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
>  		struct xfs_bmbt_irec	r;
>  
>  		ifp = xfs_iext_state_to_fork(ip, state);
> -		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &r);
> +		xfs_iext_get_extent(ifp, idx, &r);
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
>  		__entry->idx = idx;
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

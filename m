Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 991807CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:56:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3AB75AC003
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 10:56:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 48R6uDIfbS9g2SVo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2016 10:56:37 -0800 (PST)
Date: Mon, 15 Feb 2016 13:56:35 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: remove xfs_trans_get_block_res
Message-ID: <20160215185635.GD33291@bfoster.bfoster>
References: <1455365381-12592-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455365381-12592-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sat, Feb 13, 2016 at 01:09:41PM +0100, Christoph Hellwig wrote:
> Just use the t_blk_res field directly instead of obsfucating the reference
> by a macro.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c       | 6 +++---
>  fs/xfs/libxfs/xfs_bmap_btree.c | 4 ++--
>  fs/xfs/xfs_trans.h             | 1 -
>  3 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 3e89e0e..a0fa2f5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5707,7 +5707,7 @@ xfs_bunmapi(
>  			 * This is better than zeroing it.
>  			 */
>  			ASSERT(del.br_state == XFS_EXT_NORM);
> -			ASSERT(xfs_trans_get_block_res(tp) > 0);
> +			ASSERT(tp->t_blk_res > 0);
>  			/*
>  			 * If this spans a realtime extent boundary,
>  			 * chop it back to the start of the one we end at.
> @@ -5738,7 +5738,7 @@ xfs_bunmapi(
>  				del.br_startblock += mod;
>  			} else if ((del.br_startoff == start &&
>  				    (del.br_state == XFS_EXT_UNWRITTEN ||
> -				     xfs_trans_get_block_res(tp) == 0)) ||
> +				     tp->t_blk_res == 0)) ||
>  				   !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
>  				/*
>  				 * Can't make it unwritten.  There isn't
> @@ -5829,7 +5829,7 @@ xfs_bunmapi(
>  		 * conversion to btree format, since the transaction
>  		 * will be dirty.
>  		 */
> -		if (!wasdel && xfs_trans_get_block_res(tp) == 0 &&
> +		if (!wasdel && tp->t_blk_res == 0 &&
>  		    XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
>  		    XFS_IFORK_NEXTENTS(ip, whichfork) >= /* Note the >= */
>  			XFS_IFORK_MAXEXT(ip, whichfork) &&
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 77a8c63..5dcbfae 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -464,7 +464,7 @@ try_another_ag:
>  		 * reservation amount is insufficient then we may fail a
>  		 * block allocation here and corrupt the filesystem.
>  		 */
> -		args.minleft = xfs_trans_get_block_res(args.tp);
> +		args.minleft = args.tp->t_blk_res;
>  	} else if (cur->bc_private.b.flist->xbf_low) {
>  		args.type = XFS_ALLOCTYPE_START_BNO;
>  	} else {
> @@ -473,7 +473,7 @@ try_another_ag:
>  
>  	args.minlen = args.maxlen = args.prod = 1;
>  	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
> -	if (!args.wasdel && xfs_trans_get_block_res(args.tp) == 0) {
> +	if (!args.wasdel && args.tp->t_blk_res == 0) {
>  		error = -ENOSPC;
>  		goto error0;
>  	}
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 50fe77e..d49dfef 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -133,7 +133,6 @@ typedef struct xfs_trans {
>   * XFS transaction mechanism exported interfaces that are
>   * actually macros.
>   */
> -#define	xfs_trans_get_block_res(tp)	((tp)->t_blk_res)
>  #define	xfs_trans_set_sync(tp)		((tp)->t_flags |= XFS_TRANS_SYNC)
>  
>  #if defined(DEBUG) || defined(XFS_WARN)
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

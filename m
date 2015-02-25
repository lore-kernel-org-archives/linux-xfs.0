Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E82527F5E
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2015 06:57:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 92A30AC003
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2015 04:57:58 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ce3FZYgaOYlIedf6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Feb 2015 04:57:57 -0800 (PST)
Date: Wed, 25 Feb 2015 09:57:46 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: remove xfs_bmap_sanity_check()
Message-ID: <20150225125746.GB3653@hades.maiolino.org>
References: <1424846470-7623-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424846470-7623-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Looks good to me, consider adding:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


On Wed, Feb 25, 2015 at 05:41:10PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This code is redundant now that we have verifiers that sanity check
> the buffers as they are read from disk.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 32 --------------------------------
>  1 file changed, 32 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 8ae3775..b872e9c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -244,30 +244,6 @@ xfs_bmap_forkoff_reset(
>  	}
>  }
>  
> -/*
> - * Debug/sanity checking code
> - */
> -
> -STATIC int
> -xfs_bmap_sanity_check(
> -	struct xfs_mount	*mp,
> -	struct xfs_buf		*bp,
> -	int			level)
> -{
> -	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
> -
> -	if (block->bb_magic != cpu_to_be32(XFS_BMAP_CRC_MAGIC) &&
> -	    block->bb_magic != cpu_to_be32(XFS_BMAP_MAGIC))
> -		return 0;
> -
> -	if (be16_to_cpu(block->bb_level) != level ||
> -	    be16_to_cpu(block->bb_numrecs) == 0 ||
> -	    be16_to_cpu(block->bb_numrecs) > mp->m_bmap_dmxr[level != 0])
> -		return 0;
> -
> -	return 1;
> -}
> -
>  #ifdef DEBUG
>  STATIC struct xfs_buf *
>  xfs_bmap_get_bp(
> @@ -410,9 +386,6 @@ xfs_bmap_check_leaf_extents(
>  				goto error_norelse;
>  		}
>  		block = XFS_BUF_TO_BLOCK(bp);
> -		XFS_WANT_CORRUPTED_GOTO(mp,
> -			xfs_bmap_sanity_check(mp, bp, level),
> -			error0);
>  		if (level == 0)
>  			break;
>  
> @@ -1312,8 +1285,6 @@ xfs_bmap_read_extents(
>  		if (error)
>  			return error;
>  		block = XFS_BUF_TO_BLOCK(bp);
> -		XFS_WANT_CORRUPTED_GOTO(mp,
> -			xfs_bmap_sanity_check(mp, bp, level), error0);
>  		if (level == 0)
>  			break;
>  		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
> @@ -1346,9 +1317,6 @@ xfs_bmap_read_extents(
>  				XFS_ERRLEVEL_LOW, ip->i_mount, block);
>  			goto error0;
>  		}
> -		XFS_WANT_CORRUPTED_GOTO(mp,
> -			xfs_bmap_sanity_check(mp, bp, 0),
> -			error0);
>  		/*
>  		 * Read-ahead the next leaf block, if any.
>  		 */
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
